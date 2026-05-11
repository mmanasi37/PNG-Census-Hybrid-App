import 'package:isar/isar.dart';

part 'household_record.g.dart';

enum RecordStatus {
  draft('draft'),
  complete('complete'),
  synced('synced'),
  conflict('conflict');

  const RecordStatus(this.value);
  final String value;

  static RecordStatus fromString(String value) =>
      RecordStatus.values.firstWhere((e) => e.value == value);
}

@embedded
class VectorClock {
  List<String> nodeIds = [];
  List<int> counters = [];

  Map<String, int> toMap() => Map.fromIterables(nodeIds, counters);

  static VectorClock fromMap(Map<String, int> map) {
    return VectorClock()
      ..nodeIds = map.keys.toList()
      ..counters = map.values.toList();
  }

  VectorClock increment(String nodeId) {
    final map = toMap();
    map[nodeId] = (map[nodeId] ?? 0) + 1;
    return VectorClock.fromMap(map);
  }

  VectorClock merge(VectorClock other) {
    final a = toMap();
    final b = other.toMap();
    final result = <String, int>{};
    for (final key in {...a.keys, ...b.keys}) {
      result[key] = (a[key] ?? 0) > (b[key] ?? 0) ? a[key]! : (b[key] ?? 0);
    }
    return VectorClock.fromMap(result);
  }

  /// Returns true if this clock strictly happened before [other].
  bool happensBefore(VectorClock other) {
    final a = toMap();
    final b = other.toMap();
    final allKeys = {...a.keys, ...b.keys};
    var hasStrictlyLess = false;
    for (final key in allKeys) {
      final aVal = a[key] ?? 0;
      final bVal = b[key] ?? 0;
      if (aVal > bVal) return false;
      if (aVal < bVal) hasStrictlyLess = true;
    }
    return hasStrictlyLess;
  }

  /// Returns true when neither clock dominates the other (concurrent edits).
  bool isConcurrentWith(VectorClock other) {
    return !happensBefore(other) && !other.happensBefore(this) && toMap() != other.toMap();
  }
}

@collection
class HouseholdRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  @Index()
  late String enumeratorId;

  late String supervisorId;

  @Index()
  late String province;

  late String district;
  late String llg;
  late String ward;
  late String village;
  late String householdNumber;

  double? latitude;
  double? longitude;
  double? accuracy;

  /// JSON-encoded `Map<String, dynamic>` — question id → answer value
  late String answersJson;

  @Index()
  late String status;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  DateTime? syncedAt;

  VectorClock vectorClock = VectorClock();

  @ignore
  RecordStatus get recordStatus => RecordStatus.fromString(status);
  set recordStatus(RecordStatus s) => status = s.value;
}
