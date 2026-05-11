import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../models/household_record.dart';
import 'isar_service.dart';

// ── Value types ────────────────────────────────────────────────────────────────

class SyncException implements Exception {
  const SyncException(this.message);
  final String message;
  @override
  String toString() => 'SyncException: $message';
}

class SyncResult {
  const SyncResult({
    required this.uploaded,
    required this.downloaded,
    required this.conflicts,
    required this.errors,
  });

  final int uploaded;
  final int downloaded;
  final int conflicts;
  final List<String> errors;

  bool get hasErrors => errors.isNotEmpty;
  bool get hasActivity => uploaded > 0 || downloaded > 0 || conflicts > 0;
}

enum ConflictResolution { localWins, remoteWins, merged }

class ResolvedRecord {
  const ResolvedRecord({required this.record, required this.resolution});
  final HouseholdRecord record;
  final ConflictResolution resolution;
}

// ── Conflict resolver ──────────────────────────────────────────────────────────

class ConflictResolver {
  ResolvedRecord resolve(HouseholdRecord local, HouseholdRecord remote) {
    final lc = local.vectorClock;
    final rc = remote.vectorClock;

    if (rc.happensBefore(lc) || _equal(lc, rc)) {
      return ResolvedRecord(record: local, resolution: ConflictResolution.localWins);
    }
    if (lc.happensBefore(rc)) {
      remote.id = local.id;
      return ResolvedRecord(record: remote, resolution: ConflictResolution.remoteWins);
    }

    // Concurrent edits — last-write-wins at record level, merged clock
    return _merge(local, remote);
  }

  bool _equal(VectorClock a, VectorClock b) {
    final am = a.toMap();
    final bm = b.toMap();
    final keys = {...am.keys, ...bm.keys};
    return keys.every((k) => (am[k] ?? 0) == (bm[k] ?? 0));
  }

  ResolvedRecord _merge(HouseholdRecord local, HouseholdRecord remote) {
    final base = local.updatedAt.isAfter(remote.updatedAt) ? local : remote;
    final merged = HouseholdRecord()
      ..id = local.id
      ..uuid = base.uuid
      ..enumeratorId = base.enumeratorId
      ..supervisorId = base.supervisorId
      ..province = base.province
      ..district = base.district
      ..llg = base.llg
      ..ward = base.ward
      ..village = base.village
      ..householdNumber = base.householdNumber
      ..latitude = base.latitude
      ..longitude = base.longitude
      ..accuracy = base.accuracy
      ..answersJson = base.answersJson
      ..status = RecordStatus.conflict.value
      ..createdAt = base.createdAt
      ..updatedAt = base.updatedAt
      ..syncedAt = base.syncedAt
      ..vectorClock = local.vectorClock.merge(remote.vectorClock);
    return ResolvedRecord(record: merged, resolution: ConflictResolution.merged);
  }
}

// ── Wire-format DTO ────────────────────────────────────────────────────────────

class _RecordDto {
  const _RecordDto({
    required this.uuid,
    required this.enumeratorId,
    required this.supervisorId,
    required this.province,
    required this.district,
    required this.llg,
    required this.ward,
    required this.village,
    required this.householdNumber,
    this.latitude,
    this.longitude,
    this.accuracy,
    required this.answers,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
    required this.vectorClock,
  });

  final String uuid;
  final String enumeratorId;
  final String supervisorId;
  final String province;
  final String district;
  final String llg;
  final String ward;
  final String village;
  final String householdNumber;
  final double? latitude;
  final double? longitude;
  final double? accuracy;
  final Map<String, dynamic> answers;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  final Map<String, int> vectorClock;

  factory _RecordDto.fromRecord(HouseholdRecord r) {
    Map<String, dynamic> answers;
    try {
      answers = r.answersJson.isEmpty
          ? {}
          : jsonDecode(r.answersJson) as Map<String, dynamic>;
    } catch (_) {
      answers = {};
    }
    return _RecordDto(
      uuid: r.uuid,
      enumeratorId: r.enumeratorId,
      supervisorId: r.supervisorId,
      province: r.province,
      district: r.district,
      llg: r.llg,
      ward: r.ward,
      village: r.village,
      householdNumber: r.householdNumber,
      latitude: r.latitude,
      longitude: r.longitude,
      accuracy: r.accuracy,
      answers: answers,
      status: r.status,
      createdAt: r.createdAt,
      updatedAt: r.updatedAt,
      syncedAt: r.syncedAt,
      vectorClock: r.vectorClock.toMap(),
    );
  }

  factory _RecordDto.fromJson(Map<String, dynamic> j) => _RecordDto(
        uuid: j['uuid'] as String,
        enumeratorId: j['enumeratorId'] as String? ?? '',
        supervisorId: j['supervisorId'] as String? ?? '',
        province: j['province'] as String? ?? '',
        district: j['district'] as String? ?? '',
        llg: j['llg'] as String? ?? '',
        ward: j['ward'] as String? ?? '',
        village: j['village'] as String? ?? '',
        householdNumber: j['householdNumber'] as String? ?? '',
        latitude: (j['latitude'] as num?)?.toDouble(),
        longitude: (j['longitude'] as num?)?.toDouble(),
        accuracy: (j['accuracy'] as num?)?.toDouble(),
        answers: (j['answers'] as Map<String, dynamic>?) ?? {},
        status: j['status'] as String? ?? RecordStatus.complete.value,
        createdAt: DateTime.parse(j['createdAt'] as String),
        updatedAt: DateTime.parse(j['updatedAt'] as String),
        syncedAt: j['syncedAt'] != null
            ? DateTime.parse(j['syncedAt'] as String)
            : null,
        vectorClock: ((j['vectorClock'] as Map<String, dynamic>?) ?? {})
            .map((k, v) => MapEntry(k, (v as num).toInt())),
      );

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'enumeratorId': enumeratorId,
        'supervisorId': supervisorId,
        'province': province,
        'district': district,
        'llg': llg,
        'ward': ward,
        'village': village,
        'householdNumber': householdNumber,
        if (latitude != null) 'latitude': latitude,
        if (longitude != null) 'longitude': longitude,
        if (accuracy != null) 'accuracy': accuracy,
        'answers': answers,
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (syncedAt != null) 'syncedAt': syncedAt!.toIso8601String(),
        'vectorClock': vectorClock,
      };

  HouseholdRecord toRecord() => HouseholdRecord()
    ..uuid = uuid
    ..enumeratorId = enumeratorId
    ..supervisorId = supervisorId
    ..province = province
    ..district = district
    ..llg = llg
    ..ward = ward
    ..village = village
    ..householdNumber = householdNumber
    ..latitude = latitude
    ..longitude = longitude
    ..accuracy = accuracy
    ..answersJson = jsonEncode(answers)
    ..status = status
    ..createdAt = createdAt
    ..updatedAt = updatedAt
    ..syncedAt = syncedAt
    ..vectorClock = VectorClock.fromMap(vectorClock);
}

// ── Sync engine ────────────────────────────────────────────────────────────────

enum _UploadOutcome { success, conflict }

class SyncEngine {
  SyncEngine._();
  static final instance = SyncEngine._();

  static const periodicTaskName = 'census_periodic_sync';
  static const oneTimeTaskName = 'census_one_time_sync';

  String _baseUrl = '';
  String _apiKey = '';
  String _enumeratorId = 'enumerator_1';

  final _resolver = ConflictResolver();

  void configure({
    required String baseUrl,
    required String apiKey,
    String enumeratorId = 'enumerator_1',
  }) {
    _baseUrl = baseUrl.trimRight().replaceAll(RegExp(r'/$'), '');
    _apiKey = apiKey;
    _enumeratorId = enumeratorId;
  }

  bool get isConfigured => _baseUrl.isNotEmpty && _apiKey.isNotEmpty;

  Future<SyncResult> sync() async {
    if (!isConfigured) {
      return const SyncResult(
        uploaded: 0, downloaded: 0, conflicts: 0,
        errors: ['Sync server not configured.'],
      );
    }

    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.every((r) => r == ConnectivityResult.none)) {
      return const SyncResult(
        uploaded: 0, downloaded: 0, conflicts: 0,
        errors: ['No network connectivity.'],
      );
    }

    var uploaded = 0, downloaded = 0, conflicts = 0;
    final errors = <String>[];
    final client = http.Client();

    try {
      // ── Upload pending records ──────────────────────────────────────────────
      final pending = await IsarService.instance.getPendingSync();
      for (final record in pending) {
        try {
          final outcome = await _uploadRecord(client, record);
          if (outcome == _UploadOutcome.success) uploaded++;
          if (outcome == _UploadOutcome.conflict) conflicts++;
        } catch (e) {
          errors.add('Upload ${record.uuid.substring(0, 8)}: $e');
        }
      }

      // ── Fetch & apply server updates ────────────────────────────────────────
      try {
        final r = await _fetchAndApply(client);
        downloaded += r.downloaded;
        conflicts += r.conflicts;
      } catch (e) {
        errors.add('Download: $e');
      }
    } finally {
      client.close();
    }

    return SyncResult(
      uploaded: uploaded,
      downloaded: downloaded,
      conflicts: conflicts,
      errors: errors,
    );
  }

  Future<_UploadOutcome> _uploadRecord(
    http.Client client,
    HouseholdRecord record,
  ) async {
    final resp = await client
        .post(
          Uri.parse('$_baseUrl/api/v1/records'),
          headers: _headers,
          body: jsonEncode(_RecordDto.fromRecord(record).toJson()),
        )
        .timeout(const Duration(seconds: 30));

    if (resp.statusCode == 200 || resp.statusCode == 201) {
      await IsarService.instance.markSynced(record.uuid);
      return _UploadOutcome.success;
    }

    if (resp.statusCode == 409) {
      final serverRecord = _RecordDto.fromJson(
        jsonDecode(resp.body) as Map<String, dynamic>,
      ).toRecord()..id = record.id;

      final resolved = _resolver.resolve(record, serverRecord);
      await IsarService.instance.save(resolved.record);
      return resolved.resolution == ConflictResolution.merged
          ? _UploadOutcome.conflict
          : _UploadOutcome.success;
    }

    throw SyncException('HTTP ${resp.statusCode}');
  }

  Future<({int downloaded, int conflicts})> _fetchAndApply(
    http.Client client,
  ) async {
    final since = await _lastSyncAt();
    final uri = Uri.parse('$_baseUrl/api/v1/records').replace(
      queryParameters: {
        'since': since.toIso8601String(),
        'enumeratorId': _enumeratorId,
      },
    );

    final resp = await client
        .get(uri, headers: _headers)
        .timeout(const Duration(seconds: 30));

    if (resp.statusCode != 200) throw SyncException('HTTP ${resp.statusCode}');

    final list = (jsonDecode(resp.body) as List<dynamic>)
        .cast<Map<String, dynamic>>();

    var downloaded = 0, conflicts = 0;

    for (final json in list) {
      final remote = _RecordDto.fromJson(json).toRecord();
      final local = await IsarService.instance.getByUuid(remote.uuid);

      if (local == null) {
        await IsarService.instance.save(remote);
        downloaded++;
      } else {
        remote.id = local.id;
        final resolved = _resolver.resolve(local, remote);
        if (resolved.resolution != ConflictResolution.localWins) {
          await IsarService.instance.save(resolved.record);
          downloaded++;
          if (resolved.resolution == ConflictResolution.merged) conflicts++;
        }
      }
    }

    await _saveLastSyncAt(DateTime.now().toUtc());
    return (downloaded: downloaded, conflicts: conflicts);
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'X-Api-Key': _apiKey,
        'X-Enumerator-Id': _enumeratorId,
      };

  Future<DateTime> _lastSyncAt() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final f = File('${dir.path}/.census_last_sync');
      if (!f.existsSync()) return DateTime.fromMillisecondsSinceEpoch(0);
      return DateTime.parse(f.readAsStringSync().trim());
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  Future<void> _saveLastSyncAt(DateTime t) async {
    final dir = await getApplicationDocumentsDirectory();
    await File('${dir.path}/.census_last_sync')
        .writeAsString(t.toIso8601String());
  }
}
