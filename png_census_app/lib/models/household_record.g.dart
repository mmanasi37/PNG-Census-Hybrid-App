// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_record.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHouseholdRecordCollection on Isar {
  IsarCollection<HouseholdRecord> get householdRecords => this.collection();
}

const HouseholdRecordSchema = CollectionSchema(
  name: r'HouseholdRecord',
  id: -6744218323515361055,
  properties: {
    r'accuracy': PropertySchema(
      id: 0,
      name: r'accuracy',
      type: IsarType.double,
    ),
    r'answersJson': PropertySchema(
      id: 1,
      name: r'answersJson',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'district': PropertySchema(
      id: 3,
      name: r'district',
      type: IsarType.string,
    ),
    r'enumeratorId': PropertySchema(
      id: 4,
      name: r'enumeratorId',
      type: IsarType.string,
    ),
    r'householdNumber': PropertySchema(
      id: 5,
      name: r'householdNumber',
      type: IsarType.string,
    ),
    r'latitude': PropertySchema(
      id: 6,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'llg': PropertySchema(
      id: 7,
      name: r'llg',
      type: IsarType.string,
    ),
    r'longitude': PropertySchema(
      id: 8,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'province': PropertySchema(
      id: 9,
      name: r'province',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 10,
      name: r'status',
      type: IsarType.string,
    ),
    r'supervisorId': PropertySchema(
      id: 11,
      name: r'supervisorId',
      type: IsarType.string,
    ),
    r'syncedAt': PropertySchema(
      id: 12,
      name: r'syncedAt',
      type: IsarType.dateTime,
    ),
    r'updatedAt': PropertySchema(
      id: 13,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'uuid': PropertySchema(
      id: 14,
      name: r'uuid',
      type: IsarType.string,
    ),
    r'vectorClock': PropertySchema(
      id: 15,
      name: r'vectorClock',
      type: IsarType.object,
      target: r'VectorClock',
    ),
    r'village': PropertySchema(
      id: 16,
      name: r'village',
      type: IsarType.string,
    ),
    r'ward': PropertySchema(
      id: 17,
      name: r'ward',
      type: IsarType.string,
    )
  },
  estimateSize: _householdRecordEstimateSize,
  serialize: _householdRecordSerialize,
  deserialize: _householdRecordDeserialize,
  deserializeProp: _householdRecordDeserializeProp,
  idName: r'id',
  indexes: {
    r'uuid': IndexSchema(
      id: 2134397340427724972,
      name: r'uuid',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'uuid',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'enumeratorId': IndexSchema(
      id: -1257362248086867314,
      name: r'enumeratorId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'enumeratorId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'province': IndexSchema(
      id: -6035047385865569949,
      name: r'province',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'province',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'createdAt': IndexSchema(
      id: -3433535483987302584,
      name: r'createdAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'createdAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {r'VectorClock': VectorClockSchema},
  getId: _householdRecordGetId,
  getLinks: _householdRecordGetLinks,
  attach: _householdRecordAttach,
  version: '3.1.0+1',
);

int _householdRecordEstimateSize(
  HouseholdRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.answersJson.length * 3;
  bytesCount += 3 + object.district.length * 3;
  bytesCount += 3 + object.enumeratorId.length * 3;
  bytesCount += 3 + object.householdNumber.length * 3;
  bytesCount += 3 + object.llg.length * 3;
  bytesCount += 3 + object.province.length * 3;
  bytesCount += 3 + object.status.length * 3;
  bytesCount += 3 + object.supervisorId.length * 3;
  bytesCount += 3 + object.uuid.length * 3;
  bytesCount += 3 +
      VectorClockSchema.estimateSize(
          object.vectorClock, allOffsets[VectorClock]!, allOffsets);
  bytesCount += 3 + object.village.length * 3;
  bytesCount += 3 + object.ward.length * 3;
  return bytesCount;
}

void _householdRecordSerialize(
  HouseholdRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.accuracy);
  writer.writeString(offsets[1], object.answersJson);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.district);
  writer.writeString(offsets[4], object.enumeratorId);
  writer.writeString(offsets[5], object.householdNumber);
  writer.writeDouble(offsets[6], object.latitude);
  writer.writeString(offsets[7], object.llg);
  writer.writeDouble(offsets[8], object.longitude);
  writer.writeString(offsets[9], object.province);
  writer.writeString(offsets[10], object.status);
  writer.writeString(offsets[11], object.supervisorId);
  writer.writeDateTime(offsets[12], object.syncedAt);
  writer.writeDateTime(offsets[13], object.updatedAt);
  writer.writeString(offsets[14], object.uuid);
  writer.writeObject<VectorClock>(
    offsets[15],
    allOffsets,
    VectorClockSchema.serialize,
    object.vectorClock,
  );
  writer.writeString(offsets[16], object.village);
  writer.writeString(offsets[17], object.ward);
}

HouseholdRecord _householdRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HouseholdRecord();
  object.accuracy = reader.readDoubleOrNull(offsets[0]);
  object.answersJson = reader.readString(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.district = reader.readString(offsets[3]);
  object.enumeratorId = reader.readString(offsets[4]);
  object.householdNumber = reader.readString(offsets[5]);
  object.id = id;
  object.latitude = reader.readDoubleOrNull(offsets[6]);
  object.llg = reader.readString(offsets[7]);
  object.longitude = reader.readDoubleOrNull(offsets[8]);
  object.province = reader.readString(offsets[9]);
  object.status = reader.readString(offsets[10]);
  object.supervisorId = reader.readString(offsets[11]);
  object.syncedAt = reader.readDateTimeOrNull(offsets[12]);
  object.updatedAt = reader.readDateTime(offsets[13]);
  object.uuid = reader.readString(offsets[14]);
  object.vectorClock = reader.readObjectOrNull<VectorClock>(
        offsets[15],
        VectorClockSchema.deserialize,
        allOffsets,
      ) ??
      VectorClock();
  object.village = reader.readString(offsets[16]);
  object.ward = reader.readString(offsets[17]);
  return object;
}

P _householdRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (reader.readDateTime(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readObjectOrNull<VectorClock>(
            offset,
            VectorClockSchema.deserialize,
            allOffsets,
          ) ??
          VectorClock()) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _householdRecordGetId(HouseholdRecord object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _householdRecordGetLinks(HouseholdRecord object) {
  return [];
}

void _householdRecordAttach(
    IsarCollection<dynamic> col, Id id, HouseholdRecord object) {
  object.id = id;
}

extension HouseholdRecordByIndex on IsarCollection<HouseholdRecord> {
  Future<HouseholdRecord?> getByUuid(String uuid) {
    return getByIndex(r'uuid', [uuid]);
  }

  HouseholdRecord? getByUuidSync(String uuid) {
    return getByIndexSync(r'uuid', [uuid]);
  }

  Future<bool> deleteByUuid(String uuid) {
    return deleteByIndex(r'uuid', [uuid]);
  }

  bool deleteByUuidSync(String uuid) {
    return deleteByIndexSync(r'uuid', [uuid]);
  }

  Future<List<HouseholdRecord?>> getAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndex(r'uuid', values);
  }

  List<HouseholdRecord?> getAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'uuid', values);
  }

  Future<int> deleteAllByUuid(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'uuid', values);
  }

  int deleteAllByUuidSync(List<String> uuidValues) {
    final values = uuidValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'uuid', values);
  }

  Future<Id> putByUuid(HouseholdRecord object) {
    return putByIndex(r'uuid', object);
  }

  Id putByUuidSync(HouseholdRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'uuid', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByUuid(List<HouseholdRecord> objects) {
    return putAllByIndex(r'uuid', objects);
  }

  List<Id> putAllByUuidSync(List<HouseholdRecord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'uuid', objects, saveLinks: saveLinks);
  }
}

extension HouseholdRecordQueryWhereSort
    on QueryBuilder<HouseholdRecord, HouseholdRecord, QWhere> {
  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhere> anyCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'createdAt'),
      );
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension HouseholdRecordQueryWhere
    on QueryBuilder<HouseholdRecord, HouseholdRecord, QWhereClause> {
  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause> uuidEqualTo(
      String uuid) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'uuid',
        value: [uuid],
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      uuidNotEqualTo(String uuid) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [uuid],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'uuid',
              lower: [],
              upper: [uuid],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      enumeratorIdEqualTo(String enumeratorId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'enumeratorId',
        value: [enumeratorId],
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      enumeratorIdNotEqualTo(String enumeratorId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'enumeratorId',
              lower: [],
              upper: [enumeratorId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'enumeratorId',
              lower: [enumeratorId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'enumeratorId',
              lower: [enumeratorId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'enumeratorId',
              lower: [],
              upper: [enumeratorId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      provinceEqualTo(String province) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'province',
        value: [province],
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      provinceNotEqualTo(String province) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'province',
              lower: [],
              upper: [province],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'province',
              lower: [province],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'province',
              lower: [province],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'province',
              lower: [],
              upper: [province],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      statusEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      statusNotEqualTo(String status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      createdAtEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'createdAt',
        value: [createdAt],
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      createdAtNotEqualTo(DateTime createdAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [createdAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'createdAt',
              lower: [],
              upper: [createdAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      createdAtGreaterThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [createdAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      createdAtLessThan(
    DateTime createdAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [],
        upper: [createdAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      createdAtBetween(
    DateTime lowerCreatedAt,
    DateTime upperCreatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'createdAt',
        lower: [lowerCreatedAt],
        includeLower: includeLower,
        upper: [upperCreatedAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      updatedAtNotEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      updatedAtGreaterThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [updatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      updatedAtLessThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [],
        upper: [updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterWhereClause>
      updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [lowerUpdatedAt],
        includeLower: includeLower,
        upper: [upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension HouseholdRecordQueryFilter
    on QueryBuilder<HouseholdRecord, HouseholdRecord, QFilterCondition> {
  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      accuracyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'accuracy',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      accuracyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'accuracy',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      accuracyEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      accuracyGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      accuracyLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      accuracyBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accuracy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      answersJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'answersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      answersJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'answersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      answersJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'answersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      answersJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'answersJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      answersJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'answersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      answersJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'answersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      answersJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'answersJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      answersJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'answersJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      answersJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'answersJson',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      answersJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'answersJson',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      districtEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      districtGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      districtLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      districtBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'district',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      districtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      districtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      districtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'district',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      districtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'district',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      districtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'district',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      districtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'district',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      enumeratorIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enumeratorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      enumeratorIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'enumeratorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      enumeratorIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'enumeratorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      enumeratorIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'enumeratorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      enumeratorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'enumeratorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      enumeratorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'enumeratorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      enumeratorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'enumeratorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      enumeratorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'enumeratorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      enumeratorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'enumeratorId',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      enumeratorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'enumeratorId',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      householdNumberEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'householdNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      householdNumberGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'householdNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      householdNumberLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'householdNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      householdNumberBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'householdNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      householdNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'householdNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      householdNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'householdNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      householdNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'householdNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      householdNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'householdNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      householdNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'householdNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      householdNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'householdNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      latitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'latitude',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      latitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'latitude',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      latitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      latitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      latitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      latitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      llgEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'llg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      llgGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'llg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      llgLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'llg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      llgBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'llg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      llgStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'llg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      llgEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'llg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      llgContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'llg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      llgMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'llg',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      llgIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'llg',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      llgIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'llg',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      longitudeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'longitude',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      longitudeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'longitude',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      longitudeEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      longitudeGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      longitudeLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      longitudeBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      provinceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'province',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      provinceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'province',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      provinceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'province',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      provinceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'province',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      provinceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'province',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      provinceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'province',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      provinceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'province',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      provinceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'province',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      provinceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'province',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      provinceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'province',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      statusEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      statusGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      statusLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      statusBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      statusStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      statusEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      statusMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      supervisorIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supervisorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      supervisorIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'supervisorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      supervisorIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'supervisorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      supervisorIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'supervisorId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      supervisorIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'supervisorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      supervisorIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'supervisorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      supervisorIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'supervisorId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      supervisorIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'supervisorId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      supervisorIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supervisorId',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      supervisorIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'supervisorId',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      syncedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'syncedAt',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      syncedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'syncedAt',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      syncedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      syncedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      syncedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      syncedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      uuidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      uuidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      uuidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      uuidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'uuid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      uuidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      uuidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      uuidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'uuid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      uuidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'uuid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      uuidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      uuidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'uuid',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      villageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'village',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      villageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'village',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      villageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'village',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      villageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'village',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      villageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'village',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      villageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'village',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      villageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'village',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      villageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'village',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      villageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'village',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      villageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'village',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      wardEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ward',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      wardGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ward',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      wardLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ward',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      wardBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ward',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      wardStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ward',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      wardEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ward',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      wardContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ward',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      wardMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ward',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      wardIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ward',
        value: '',
      ));
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      wardIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ward',
        value: '',
      ));
    });
  }
}

extension HouseholdRecordQueryObject
    on QueryBuilder<HouseholdRecord, HouseholdRecord, QFilterCondition> {
  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterFilterCondition>
      vectorClock(FilterQuery<VectorClock> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'vectorClock');
    });
  }
}

extension HouseholdRecordQueryLinks
    on QueryBuilder<HouseholdRecord, HouseholdRecord, QFilterCondition> {}

extension HouseholdRecordQuerySortBy
    on QueryBuilder<HouseholdRecord, HouseholdRecord, QSortBy> {
  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByAnswersJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'answersJson', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByAnswersJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'answersJson', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByDistrict() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'district', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByDistrictDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'district', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByEnumeratorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enumeratorId', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByEnumeratorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enumeratorId', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByHouseholdNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'householdNumber', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByHouseholdNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'householdNumber', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy> sortByLlg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'llg', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy> sortByLlgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'llg', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByProvince() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'province', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByProvinceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'province', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortBySupervisorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supervisorId', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortBySupervisorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supervisorId', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy> sortByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy> sortByVillage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'village', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByVillageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'village', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy> sortByWard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ward', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      sortByWardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ward', Sort.desc);
    });
  }
}

extension HouseholdRecordQuerySortThenBy
    on QueryBuilder<HouseholdRecord, HouseholdRecord, QSortThenBy> {
  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accuracy', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByAnswersJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'answersJson', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByAnswersJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'answersJson', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByDistrict() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'district', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByDistrictDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'district', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByEnumeratorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enumeratorId', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByEnumeratorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'enumeratorId', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByHouseholdNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'householdNumber', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByHouseholdNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'householdNumber', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy> thenByLlg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'llg', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy> thenByLlgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'llg', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByProvince() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'province', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByProvinceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'province', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenBySupervisorId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supervisorId', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenBySupervisorIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supervisorId', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenBySyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncedAt', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy> thenByUuid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByUuidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'uuid', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy> thenByVillage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'village', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByVillageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'village', Sort.desc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy> thenByWard() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ward', Sort.asc);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QAfterSortBy>
      thenByWardDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ward', Sort.desc);
    });
  }
}

extension HouseholdRecordQueryWhereDistinct
    on QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct> {
  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct>
      distinctByAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accuracy');
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct>
      distinctByAnswersJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'answersJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct> distinctByDistrict(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'district', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct>
      distinctByEnumeratorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'enumeratorId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct>
      distinctByHouseholdNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'householdNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct>
      distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct> distinctByLlg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'llg', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct>
      distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct> distinctByProvince(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'province', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct>
      distinctBySupervisorId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supervisorId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct>
      distinctBySyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncedAt');
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct> distinctByUuid(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'uuid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct> distinctByVillage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'village', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HouseholdRecord, HouseholdRecord, QDistinct> distinctByWard(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ward', caseSensitive: caseSensitive);
    });
  }
}

extension HouseholdRecordQueryProperty
    on QueryBuilder<HouseholdRecord, HouseholdRecord, QQueryProperty> {
  QueryBuilder<HouseholdRecord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HouseholdRecord, double?, QQueryOperations> accuracyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accuracy');
    });
  }

  QueryBuilder<HouseholdRecord, String, QQueryOperations>
      answersJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'answersJson');
    });
  }

  QueryBuilder<HouseholdRecord, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<HouseholdRecord, String, QQueryOperations> districtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'district');
    });
  }

  QueryBuilder<HouseholdRecord, String, QQueryOperations>
      enumeratorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'enumeratorId');
    });
  }

  QueryBuilder<HouseholdRecord, String, QQueryOperations>
      householdNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'householdNumber');
    });
  }

  QueryBuilder<HouseholdRecord, double?, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<HouseholdRecord, String, QQueryOperations> llgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'llg');
    });
  }

  QueryBuilder<HouseholdRecord, double?, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<HouseholdRecord, String, QQueryOperations> provinceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'province');
    });
  }

  QueryBuilder<HouseholdRecord, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<HouseholdRecord, String, QQueryOperations>
      supervisorIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supervisorId');
    });
  }

  QueryBuilder<HouseholdRecord, DateTime?, QQueryOperations>
      syncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncedAt');
    });
  }

  QueryBuilder<HouseholdRecord, DateTime, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<HouseholdRecord, String, QQueryOperations> uuidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'uuid');
    });
  }

  QueryBuilder<HouseholdRecord, VectorClock, QQueryOperations>
      vectorClockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vectorClock');
    });
  }

  QueryBuilder<HouseholdRecord, String, QQueryOperations> villageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'village');
    });
  }

  QueryBuilder<HouseholdRecord, String, QQueryOperations> wardProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ward');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const VectorClockSchema = Schema(
  name: r'VectorClock',
  id: -1692153006469546634,
  properties: {
    r'counters': PropertySchema(
      id: 0,
      name: r'counters',
      type: IsarType.longList,
    ),
    r'nodeIds': PropertySchema(
      id: 1,
      name: r'nodeIds',
      type: IsarType.stringList,
    )
  },
  estimateSize: _vectorClockEstimateSize,
  serialize: _vectorClockSerialize,
  deserialize: _vectorClockDeserialize,
  deserializeProp: _vectorClockDeserializeProp,
);

int _vectorClockEstimateSize(
  VectorClock object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.counters.length * 8;
  bytesCount += 3 + object.nodeIds.length * 3;
  {
    for (var i = 0; i < object.nodeIds.length; i++) {
      final value = object.nodeIds[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _vectorClockSerialize(
  VectorClock object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLongList(offsets[0], object.counters);
  writer.writeStringList(offsets[1], object.nodeIds);
}

VectorClock _vectorClockDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VectorClock();
  object.counters = reader.readLongList(offsets[0]) ?? [];
  object.nodeIds = reader.readStringList(offsets[1]) ?? [];
  return object;
}

P _vectorClockDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongList(offset) ?? []) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension VectorClockQueryFilter
    on QueryBuilder<VectorClock, VectorClock, QFilterCondition> {
  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      countersElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'counters',
        value: value,
      ));
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      countersElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'counters',
        value: value,
      ));
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      countersElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'counters',
        value: value,
      ));
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      countersElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'counters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      countersLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'counters',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      countersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'counters',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      countersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'counters',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      countersLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'counters',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      countersLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'counters',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      countersLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'counters',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nodeIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nodeIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nodeIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nodeIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nodeIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nodeIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nodeIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nodeIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nodeIds',
        value: '',
      ));
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nodeIds',
        value: '',
      ));
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nodeIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nodeIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nodeIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nodeIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nodeIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<VectorClock, VectorClock, QAfterFilterCondition>
      nodeIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'nodeIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension VectorClockQueryObject
    on QueryBuilder<VectorClock, VectorClock, QFilterCondition> {}
