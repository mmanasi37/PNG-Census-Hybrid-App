import 'dart:convert';
import 'dart:math';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/household_record.dart';

class IsarService {
  IsarService._();
  static final IsarService instance = IsarService._();

  late final Isar _isar;
  bool _isOpen = false;

  Future<void> open() async {
    if (_isOpen) return;
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [HouseholdRecordSchema],
      directory: dir.path,
    );
    _isOpen = true;
  }

  // ── Queries ────────────────────────────────────────────────────────────────

  Future<HouseholdRecord?> getByUuid(String uuid) =>
      _isar.householdRecords.where().uuidEqualTo(uuid).findFirst();

  Future<List<HouseholdRecord>> getAll() =>
      _isar.householdRecords.where().findAll();

  Future<List<HouseholdRecord>> getByStatus(RecordStatus status) =>
      _isar.householdRecords
          .where()
          .statusEqualTo(status.value)
          .findAll();

  Future<List<HouseholdRecord>> getByEnumerator(String enumeratorId) =>
      _isar.householdRecords
          .where()
          .enumeratorIdEqualTo(enumeratorId)
          .findAll();

  Future<List<HouseholdRecord>> getPendingSync() async {
    final complete = await getByStatus(RecordStatus.complete);
    final conflict = await getByStatus(RecordStatus.conflict);
    return [...complete, ...conflict];
  }

  // ── Writes ─────────────────────────────────────────────────────────────────

  Future<void> save(HouseholdRecord record) async {
    await _isar.writeTxn(() => _isar.householdRecords.put(record));
  }

  Future<void> delete(Id id) async {
    await _isar.writeTxn(() => _isar.householdRecords.delete(id));
  }

  // ── Draft helpers ──────────────────────────────────────────────────────────

  Future<HouseholdRecord> createDraft({
    required String enumeratorId,
    required String supervisorId,
    required String province,
    required String district,
    required String llg,
    required String ward,
    required String village,
    required String householdNumber,
  }) async {
    final now = DateTime.now();
    final record = HouseholdRecord()
      ..uuid = _generateUuid()
      ..enumeratorId = enumeratorId
      ..supervisorId = supervisorId
      ..province = province
      ..district = district
      ..llg = llg
      ..ward = ward
      ..village = village
      ..householdNumber = householdNumber
      ..answersJson = '{}'
      ..status = RecordStatus.draft.value
      ..createdAt = now
      ..updatedAt = now
      ..vectorClock = VectorClock();
    await save(record);
    return record;
  }

  Future<void> updateAnswers(
    String uuid,
    Map<String, dynamic> answers, {
    double? latitude,
    double? longitude,
    double? accuracy,
  }) async {
    final record = await getByUuid(uuid);
    if (record == null) return;
    record
      ..answersJson = jsonEncode(answers)
      ..updatedAt = DateTime.now();
    if (latitude != null) record.latitude = latitude;
    if (longitude != null) record.longitude = longitude;
    if (accuracy != null) record.accuracy = accuracy;
    await save(record);
  }

  Future<void> markComplete(String uuid, String nodeId) async {
    final record = await getByUuid(uuid);
    if (record == null) return;
    record
      ..status = RecordStatus.complete.value
      ..updatedAt = DateTime.now()
      ..vectorClock = record.vectorClock.increment(nodeId);
    await save(record);
  }

  Future<void> markSynced(String uuid) async {
    final record = await getByUuid(uuid);
    if (record == null) return;
    final now = DateTime.now();
    record
      ..status = RecordStatus.synced.value
      ..syncedAt = now
      ..updatedAt = now;
    await save(record);
  }

  Future<void> markConflict(String uuid) async {
    final record = await getByUuid(uuid);
    if (record == null) return;
    record
      ..status = RecordStatus.conflict.value
      ..updatedAt = DateTime.now();
    await save(record);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Decodes the stored answersJson for a record.
  Map<String, dynamic> decodeAnswers(HouseholdRecord record) {
    if (record.answersJson.isEmpty || record.answersJson == '{}') return {};
    return Map<String, dynamic>.from(
      jsonDecode(record.answersJson) as Map,
    );
  }

  String _generateUuid() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40; // version 4
    bytes[8] = (bytes[8] & 0x3f) | 0x80; // variant
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}'
        '-${hex.substring(12, 16)}-${hex.substring(16, 20)}'
        '-${hex.substring(20)}';
  }
}
