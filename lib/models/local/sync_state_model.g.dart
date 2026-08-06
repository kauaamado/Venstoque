// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_state_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSyncStateLocalCollection on Isar {
  IsarCollection<SyncStateLocal> get syncStateLocals => this.collection();
}

const SyncStateLocalSchema = CollectionSchema(
  name: r'SyncStateLocal',
  id: -7413554007308492322,
  properties: {
    r'bootstrapAfterId': PropertySchema(
      id: 0,
      name: r'bootstrapAfterId',
      type: IsarType.string,
    ),
    r'bootstrapPhase': PropertySchema(
      id: 1,
      name: r'bootstrapPhase',
      type: IsarType.string,
    ),
    r'changeCursor': PropertySchema(
      id: 2,
      name: r'changeCursor',
      type: IsarType.long,
    ),
    r'cutoff': PropertySchema(
      id: 3,
      name: r'cutoff',
      type: IsarType.dateTime,
    ),
    r'generation': PropertySchema(
      id: 4,
      name: r'generation',
      type: IsarType.long,
    ),
    r'initialChangeCursor': PropertySchema(
      id: 5,
      name: r'initialChangeCursor',
      type: IsarType.long,
    ),
    r'lastAttemptAt': PropertySchema(
      id: 6,
      name: r'lastAttemptAt',
      type: IsarType.dateTime,
    ),
    r'lastError': PropertySchema(
      id: 7,
      name: r'lastError',
      type: IsarType.string,
    ),
    r'lastSuccessAt': PropertySchema(
      id: 8,
      name: r'lastSuccessAt',
      type: IsarType.dateTime,
    ),
    r'tenantId': PropertySchema(
      id: 9,
      name: r'tenantId',
      type: IsarType.string,
    ),
    r'v1Migrated': PropertySchema(
      id: 10,
      name: r'v1Migrated',
      type: IsarType.bool,
    )
  },
  estimateSize: _syncStateLocalEstimateSize,
  serialize: _syncStateLocalSerialize,
  deserialize: _syncStateLocalDeserialize,
  deserializeProp: _syncStateLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'tenantId': IndexSchema(
      id: -1042425927805315167,
      name: r'tenantId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tenantId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _syncStateLocalGetId,
  getLinks: _syncStateLocalGetLinks,
  attach: _syncStateLocalAttach,
  version: '3.3.2',
);

int _syncStateLocalEstimateSize(
  SyncStateLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bootstrapAfterId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.bootstrapPhase.length * 3;
  {
    final value = object.lastError;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tenantId.length * 3;
  return bytesCount;
}

void _syncStateLocalSerialize(
  SyncStateLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bootstrapAfterId);
  writer.writeString(offsets[1], object.bootstrapPhase);
  writer.writeLong(offsets[2], object.changeCursor);
  writer.writeDateTime(offsets[3], object.cutoff);
  writer.writeLong(offsets[4], object.generation);
  writer.writeLong(offsets[5], object.initialChangeCursor);
  writer.writeDateTime(offsets[6], object.lastAttemptAt);
  writer.writeString(offsets[7], object.lastError);
  writer.writeDateTime(offsets[8], object.lastSuccessAt);
  writer.writeString(offsets[9], object.tenantId);
  writer.writeBool(offsets[10], object.v1Migrated);
}

SyncStateLocal _syncStateLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SyncStateLocal();
  object.bootstrapAfterId = reader.readStringOrNull(offsets[0]);
  object.bootstrapPhase = reader.readString(offsets[1]);
  object.changeCursor = reader.readLong(offsets[2]);
  object.cutoff = reader.readDateTimeOrNull(offsets[3]);
  object.generation = reader.readLong(offsets[4]);
  object.id = id;
  object.initialChangeCursor = reader.readLong(offsets[5]);
  object.lastAttemptAt = reader.readDateTimeOrNull(offsets[6]);
  object.lastError = reader.readStringOrNull(offsets[7]);
  object.lastSuccessAt = reader.readDateTimeOrNull(offsets[8]);
  object.tenantId = reader.readString(offsets[9]);
  object.v1Migrated = reader.readBool(offsets[10]);
  return object;
}

P _syncStateLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _syncStateLocalGetId(SyncStateLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _syncStateLocalGetLinks(SyncStateLocal object) {
  return [];
}

void _syncStateLocalAttach(
    IsarCollection<dynamic> col, Id id, SyncStateLocal object) {
  object.id = id;
}

extension SyncStateLocalQueryWhereSort
    on QueryBuilder<SyncStateLocal, SyncStateLocal, QWhere> {
  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SyncStateLocalQueryWhere
    on QueryBuilder<SyncStateLocal, SyncStateLocal, QWhereClause> {
  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterWhereClause> idBetween(
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

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterWhereClause>
      tenantIdEqualTo(String tenantId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tenantId',
        value: [tenantId],
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterWhereClause>
      tenantIdNotEqualTo(String tenantId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenantId',
              lower: [],
              upper: [tenantId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenantId',
              lower: [tenantId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenantId',
              lower: [tenantId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenantId',
              lower: [],
              upper: [tenantId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SyncStateLocalQueryFilter
    on QueryBuilder<SyncStateLocal, SyncStateLocal, QFilterCondition> {
  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapAfterIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bootstrapAfterId',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapAfterIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bootstrapAfterId',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapAfterIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bootstrapAfterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapAfterIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bootstrapAfterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapAfterIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bootstrapAfterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapAfterIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bootstrapAfterId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapAfterIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bootstrapAfterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapAfterIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bootstrapAfterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapAfterIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bootstrapAfterId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapAfterIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bootstrapAfterId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapAfterIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bootstrapAfterId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapAfterIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bootstrapAfterId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapPhaseEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bootstrapPhase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapPhaseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bootstrapPhase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapPhaseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bootstrapPhase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapPhaseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bootstrapPhase',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapPhaseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bootstrapPhase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapPhaseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bootstrapPhase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapPhaseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bootstrapPhase',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapPhaseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bootstrapPhase',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapPhaseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bootstrapPhase',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      bootstrapPhaseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bootstrapPhase',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      changeCursorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'changeCursor',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      changeCursorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'changeCursor',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      changeCursorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'changeCursor',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      changeCursorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'changeCursor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      cutoffIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cutoff',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      cutoffIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cutoff',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      cutoffEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cutoff',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      cutoffGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cutoff',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      cutoffLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cutoff',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      cutoffBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cutoff',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      generationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generation',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      generationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'generation',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      generationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'generation',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      generationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'generation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
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

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
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

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      initialChangeCursorEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'initialChangeCursor',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      initialChangeCursorGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'initialChangeCursor',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      initialChangeCursorLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'initialChangeCursor',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      initialChangeCursorBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'initialChangeCursor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastAttemptAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastAttemptAt',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastAttemptAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastAttemptAt',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastAttemptAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAttemptAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastAttemptAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastAttemptAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastAttemptAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastAttemptAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastAttemptAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastAttemptAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastErrorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastError',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastErrorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastError',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastErrorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastErrorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastErrorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastErrorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastError',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastErrorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastErrorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastErrorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastError',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastErrorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastError',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastErrorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastError',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastErrorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastError',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastSuccessAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSuccessAt',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastSuccessAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSuccessAt',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastSuccessAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSuccessAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastSuccessAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSuccessAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastSuccessAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSuccessAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      lastSuccessAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSuccessAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      tenantIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      tenantIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      tenantIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      tenantIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tenantId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      tenantIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      tenantIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      tenantIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      tenantIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tenantId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      tenantIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tenantId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      tenantIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tenantId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterFilterCondition>
      v1MigratedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'v1Migrated',
        value: value,
      ));
    });
  }
}

extension SyncStateLocalQueryObject
    on QueryBuilder<SyncStateLocal, SyncStateLocal, QFilterCondition> {}

extension SyncStateLocalQueryLinks
    on QueryBuilder<SyncStateLocal, SyncStateLocal, QFilterCondition> {}

extension SyncStateLocalQuerySortBy
    on QueryBuilder<SyncStateLocal, SyncStateLocal, QSortBy> {
  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByBootstrapAfterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bootstrapAfterId', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByBootstrapAfterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bootstrapAfterId', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByBootstrapPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bootstrapPhase', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByBootstrapPhaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bootstrapPhase', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByChangeCursor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeCursor', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByChangeCursorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeCursor', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy> sortByCutoff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cutoff', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByCutoffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cutoff', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByGeneration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generation', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByGenerationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generation', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByInitialChangeCursor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialChangeCursor', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByInitialChangeCursorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialChangeCursor', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByLastAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByLastAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy> sortByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByLastSuccessAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSuccessAt', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByLastSuccessAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSuccessAt', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy> sortByTenantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByTenantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByV1Migrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'v1Migrated', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      sortByV1MigratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'v1Migrated', Sort.desc);
    });
  }
}

extension SyncStateLocalQuerySortThenBy
    on QueryBuilder<SyncStateLocal, SyncStateLocal, QSortThenBy> {
  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByBootstrapAfterId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bootstrapAfterId', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByBootstrapAfterIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bootstrapAfterId', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByBootstrapPhase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bootstrapPhase', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByBootstrapPhaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bootstrapPhase', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByChangeCursor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeCursor', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByChangeCursorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'changeCursor', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy> thenByCutoff() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cutoff', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByCutoffDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cutoff', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByGeneration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generation', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByGenerationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generation', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByInitialChangeCursor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialChangeCursor', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByInitialChangeCursorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'initialChangeCursor', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByLastAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByLastAttemptAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAttemptAt', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy> thenByLastError() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByLastErrorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastError', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByLastSuccessAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSuccessAt', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByLastSuccessAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSuccessAt', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy> thenByTenantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByTenantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.desc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByV1Migrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'v1Migrated', Sort.asc);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QAfterSortBy>
      thenByV1MigratedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'v1Migrated', Sort.desc);
    });
  }
}

extension SyncStateLocalQueryWhereDistinct
    on QueryBuilder<SyncStateLocal, SyncStateLocal, QDistinct> {
  QueryBuilder<SyncStateLocal, SyncStateLocal, QDistinct>
      distinctByBootstrapAfterId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bootstrapAfterId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QDistinct>
      distinctByBootstrapPhase({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bootstrapPhase',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QDistinct>
      distinctByChangeCursor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'changeCursor');
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QDistinct> distinctByCutoff() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cutoff');
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QDistinct>
      distinctByGeneration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generation');
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QDistinct>
      distinctByInitialChangeCursor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'initialChangeCursor');
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QDistinct>
      distinctByLastAttemptAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAttemptAt');
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QDistinct> distinctByLastError(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastError', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QDistinct>
      distinctByLastSuccessAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSuccessAt');
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QDistinct> distinctByTenantId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tenantId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncStateLocal, SyncStateLocal, QDistinct>
      distinctByV1Migrated() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'v1Migrated');
    });
  }
}

extension SyncStateLocalQueryProperty
    on QueryBuilder<SyncStateLocal, SyncStateLocal, QQueryProperty> {
  QueryBuilder<SyncStateLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SyncStateLocal, String?, QQueryOperations>
      bootstrapAfterIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bootstrapAfterId');
    });
  }

  QueryBuilder<SyncStateLocal, String, QQueryOperations>
      bootstrapPhaseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bootstrapPhase');
    });
  }

  QueryBuilder<SyncStateLocal, int, QQueryOperations> changeCursorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'changeCursor');
    });
  }

  QueryBuilder<SyncStateLocal, DateTime?, QQueryOperations> cutoffProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cutoff');
    });
  }

  QueryBuilder<SyncStateLocal, int, QQueryOperations> generationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generation');
    });
  }

  QueryBuilder<SyncStateLocal, int, QQueryOperations>
      initialChangeCursorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'initialChangeCursor');
    });
  }

  QueryBuilder<SyncStateLocal, DateTime?, QQueryOperations>
      lastAttemptAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAttemptAt');
    });
  }

  QueryBuilder<SyncStateLocal, String?, QQueryOperations> lastErrorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastError');
    });
  }

  QueryBuilder<SyncStateLocal, DateTime?, QQueryOperations>
      lastSuccessAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSuccessAt');
    });
  }

  QueryBuilder<SyncStateLocal, String, QQueryOperations> tenantIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tenantId');
    });
  }

  QueryBuilder<SyncStateLocal, bool, QQueryOperations> v1MigratedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'v1Migrated');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSyncMutationLocalCollection on Isar {
  IsarCollection<SyncMutationLocal> get syncMutationLocals => this.collection();
}

const SyncMutationLocalSchema = CollectionSchema(
  name: r'SyncMutationLocal',
  id: -4540814779263943053,
  properties: {
    r'attemptCount': PropertySchema(
      id: 0,
      name: r'attemptCount',
      type: IsarType.long,
    ),
    r'attemptedAt': PropertySchema(
      id: 1,
      name: r'attemptedAt',
      type: IsarType.dateTime,
    ),
    r'baseRowVersion': PropertySchema(
      id: 2,
      name: r'baseRowVersion',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'entity': PropertySchema(
      id: 4,
      name: r'entity',
      type: IsarType.string,
    ),
    r'lastErrorCode': PropertySchema(
      id: 5,
      name: r'lastErrorCode',
      type: IsarType.string,
    ),
    r'lastErrorMessage': PropertySchema(
      id: 6,
      name: r'lastErrorMessage',
      type: IsarType.string,
    ),
    r'localId': PropertySchema(
      id: 7,
      name: r'localId',
      type: IsarType.long,
    ),
    r'operation': PropertySchema(
      id: 8,
      name: r'operation',
      type: IsarType.string,
    ),
    r'operationId': PropertySchema(
      id: 9,
      name: r'operationId',
      type: IsarType.string,
    ),
    r'payloadJson': PropertySchema(
      id: 10,
      name: r'payloadJson',
      type: IsarType.string,
    ),
    r'remoteId': PropertySchema(
      id: 11,
      name: r'remoteId',
      type: IsarType.string,
    ),
    r'state': PropertySchema(
      id: 12,
      name: r'state',
      type: IsarType.string,
    ),
    r'tenantId': PropertySchema(
      id: 13,
      name: r'tenantId',
      type: IsarType.string,
    )
  },
  estimateSize: _syncMutationLocalEstimateSize,
  serialize: _syncMutationLocalSerialize,
  deserialize: _syncMutationLocalDeserialize,
  deserializeProp: _syncMutationLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'tenantId': IndexSchema(
      id: -1042425927805315167,
      name: r'tenantId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tenantId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'operationId': IndexSchema(
      id: 7498062369325286803,
      name: r'operationId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'operationId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'entity': IndexSchema(
      id: -5285054254130720380,
      name: r'entity',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'entity',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'state': IndexSchema(
      id: 7917036384617311412,
      name: r'state',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'state',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _syncMutationLocalGetId,
  getLinks: _syncMutationLocalGetLinks,
  attach: _syncMutationLocalAttach,
  version: '3.3.2',
);

int _syncMutationLocalEstimateSize(
  SyncMutationLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.entity.length * 3;
  {
    final value = object.lastErrorCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastErrorMessage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.operation.length * 3;
  bytesCount += 3 + object.operationId.length * 3;
  bytesCount += 3 + object.payloadJson.length * 3;
  {
    final value = object.remoteId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.state.length * 3;
  bytesCount += 3 + object.tenantId.length * 3;
  return bytesCount;
}

void _syncMutationLocalSerialize(
  SyncMutationLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.attemptCount);
  writer.writeDateTime(offsets[1], object.attemptedAt);
  writer.writeLong(offsets[2], object.baseRowVersion);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeString(offsets[4], object.entity);
  writer.writeString(offsets[5], object.lastErrorCode);
  writer.writeString(offsets[6], object.lastErrorMessage);
  writer.writeLong(offsets[7], object.localId);
  writer.writeString(offsets[8], object.operation);
  writer.writeString(offsets[9], object.operationId);
  writer.writeString(offsets[10], object.payloadJson);
  writer.writeString(offsets[11], object.remoteId);
  writer.writeString(offsets[12], object.state);
  writer.writeString(offsets[13], object.tenantId);
}

SyncMutationLocal _syncMutationLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SyncMutationLocal();
  object.attemptCount = reader.readLong(offsets[0]);
  object.attemptedAt = reader.readDateTimeOrNull(offsets[1]);
  object.baseRowVersion = reader.readLongOrNull(offsets[2]);
  object.createdAt = reader.readDateTime(offsets[3]);
  object.entity = reader.readString(offsets[4]);
  object.id = id;
  object.lastErrorCode = reader.readStringOrNull(offsets[5]);
  object.lastErrorMessage = reader.readStringOrNull(offsets[6]);
  object.localId = reader.readLongOrNull(offsets[7]);
  object.operation = reader.readString(offsets[8]);
  object.operationId = reader.readString(offsets[9]);
  object.payloadJson = reader.readString(offsets[10]);
  object.remoteId = reader.readStringOrNull(offsets[11]);
  object.state = reader.readString(offsets[12]);
  object.tenantId = reader.readString(offsets[13]);
  return object;
}

P _syncMutationLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _syncMutationLocalGetId(SyncMutationLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _syncMutationLocalGetLinks(
    SyncMutationLocal object) {
  return [];
}

void _syncMutationLocalAttach(
    IsarCollection<dynamic> col, Id id, SyncMutationLocal object) {
  object.id = id;
}

extension SyncMutationLocalQueryWhereSort
    on QueryBuilder<SyncMutationLocal, SyncMutationLocal, QWhere> {
  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SyncMutationLocalQueryWhere
    on QueryBuilder<SyncMutationLocal, SyncMutationLocal, QWhereClause> {
  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterWhereClause>
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

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterWhereClause>
      tenantIdEqualTo(String tenantId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tenantId',
        value: [tenantId],
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterWhereClause>
      tenantIdNotEqualTo(String tenantId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenantId',
              lower: [],
              upper: [tenantId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenantId',
              lower: [tenantId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenantId',
              lower: [tenantId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenantId',
              lower: [],
              upper: [tenantId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterWhereClause>
      operationIdEqualTo(String operationId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'operationId',
        value: [operationId],
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterWhereClause>
      operationIdNotEqualTo(String operationId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'operationId',
              lower: [],
              upper: [operationId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'operationId',
              lower: [operationId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'operationId',
              lower: [operationId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'operationId',
              lower: [],
              upper: [operationId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterWhereClause>
      entityEqualTo(String entity) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'entity',
        value: [entity],
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterWhereClause>
      entityNotEqualTo(String entity) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entity',
              lower: [],
              upper: [entity],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entity',
              lower: [entity],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entity',
              lower: [entity],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'entity',
              lower: [],
              upper: [entity],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterWhereClause>
      stateEqualTo(String state) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'state',
        value: [state],
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterWhereClause>
      stateNotEqualTo(String state) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'state',
              lower: [],
              upper: [state],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'state',
              lower: [state],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'state',
              lower: [state],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'state',
              lower: [],
              upper: [state],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SyncMutationLocalQueryFilter
    on QueryBuilder<SyncMutationLocal, SyncMutationLocal, QFilterCondition> {
  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      attemptCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attemptCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      attemptCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'attemptCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      attemptCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'attemptCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      attemptCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'attemptCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      attemptedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'attemptedAt',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      attemptedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'attemptedAt',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      attemptedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'attemptedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      attemptedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'attemptedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      attemptedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'attemptedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      attemptedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'attemptedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      baseRowVersionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'baseRowVersion',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      baseRowVersionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'baseRowVersion',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      baseRowVersionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseRowVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      baseRowVersionGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'baseRowVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      baseRowVersionLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'baseRowVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      baseRowVersionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'baseRowVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
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

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
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

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
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

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      entityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      entityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      entityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      entityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      entityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'entity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      entityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'entity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      entityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      entityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entity',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      entityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entity',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      entityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entity',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
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

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
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

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
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

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastErrorCode',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastErrorCode',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorCodeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastErrorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorCodeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastErrorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorCodeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastErrorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorCodeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastErrorCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastErrorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastErrorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastErrorCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastErrorCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastErrorCode',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastErrorCode',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastErrorMessage',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorMessageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastErrorMessage',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorMessageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastErrorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorMessageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastErrorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorMessageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastErrorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorMessageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastErrorMessage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorMessageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastErrorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorMessageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastErrorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorMessageContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastErrorMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorMessageMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastErrorMessage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastErrorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      lastErrorMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastErrorMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      localIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'localId',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      localIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'localId',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      localIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      localIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      localIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      localIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'operation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'operation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'operation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'operation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'operation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'operation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'operation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operation',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'operation',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'operationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'operationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'operationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'operationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'operationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'operationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'operationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'operationId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      operationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'operationId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      payloadJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      payloadJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      payloadJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      payloadJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'payloadJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      payloadJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      payloadJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      payloadJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'payloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      payloadJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'payloadJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      payloadJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'payloadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      payloadJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'payloadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      remoteIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'remoteId',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      remoteIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'remoteId',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      remoteIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      remoteIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      remoteIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      remoteIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      remoteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      remoteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      remoteIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      remoteIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'remoteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      remoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      remoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      stateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      stateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      stateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      stateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'state',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      stateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      stateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      stateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'state',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      stateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'state',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      stateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      stateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'state',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      tenantIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      tenantIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      tenantIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      tenantIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tenantId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      tenantIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      tenantIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      tenantIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      tenantIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tenantId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      tenantIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tenantId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterFilterCondition>
      tenantIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tenantId',
        value: '',
      ));
    });
  }
}

extension SyncMutationLocalQueryObject
    on QueryBuilder<SyncMutationLocal, SyncMutationLocal, QFilterCondition> {}

extension SyncMutationLocalQueryLinks
    on QueryBuilder<SyncMutationLocal, SyncMutationLocal, QFilterCondition> {}

extension SyncMutationLocalQuerySortBy
    on QueryBuilder<SyncMutationLocal, SyncMutationLocal, QSortBy> {
  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByAttemptCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptCount', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByAttemptCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptCount', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByAttemptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptedAt', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByAttemptedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptedAt', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByBaseRowVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRowVersion', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByBaseRowVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRowVersion', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByEntity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entity', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByEntityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entity', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByLastErrorCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastErrorCode', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByLastErrorCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastErrorCode', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByLastErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastErrorMessage', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByLastErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastErrorMessage', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByOperation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operation', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByOperationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operation', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByOperationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationId', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByOperationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationId', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByTenantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      sortByTenantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.desc);
    });
  }
}

extension SyncMutationLocalQuerySortThenBy
    on QueryBuilder<SyncMutationLocal, SyncMutationLocal, QSortThenBy> {
  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByAttemptCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptCount', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByAttemptCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptCount', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByAttemptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptedAt', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByAttemptedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'attemptedAt', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByBaseRowVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRowVersion', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByBaseRowVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRowVersion', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByEntity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entity', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByEntityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entity', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByLastErrorCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastErrorCode', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByLastErrorCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastErrorCode', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByLastErrorMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastErrorMessage', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByLastErrorMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastErrorMessage', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByOperation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operation', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByOperationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operation', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByOperationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationId', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByOperationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'operationId', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'payloadJson', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'state', Sort.desc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByTenantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.asc);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QAfterSortBy>
      thenByTenantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.desc);
    });
  }
}

extension SyncMutationLocalQueryWhereDistinct
    on QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct> {
  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct>
      distinctByAttemptCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attemptCount');
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct>
      distinctByAttemptedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'attemptedAt');
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct>
      distinctByBaseRowVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseRowVersion');
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct>
      distinctByEntity({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entity', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct>
      distinctByLastErrorCode({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastErrorCode',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct>
      distinctByLastErrorMessage({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastErrorMessage',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct>
      distinctByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localId');
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct>
      distinctByOperation({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'operation', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct>
      distinctByOperationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'operationId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct>
      distinctByPayloadJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'payloadJson', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct>
      distinctByRemoteId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct> distinctByState(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'state', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncMutationLocal, SyncMutationLocal, QDistinct>
      distinctByTenantId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tenantId', caseSensitive: caseSensitive);
    });
  }
}

extension SyncMutationLocalQueryProperty
    on QueryBuilder<SyncMutationLocal, SyncMutationLocal, QQueryProperty> {
  QueryBuilder<SyncMutationLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SyncMutationLocal, int, QQueryOperations>
      attemptCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attemptCount');
    });
  }

  QueryBuilder<SyncMutationLocal, DateTime?, QQueryOperations>
      attemptedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'attemptedAt');
    });
  }

  QueryBuilder<SyncMutationLocal, int?, QQueryOperations>
      baseRowVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseRowVersion');
    });
  }

  QueryBuilder<SyncMutationLocal, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<SyncMutationLocal, String, QQueryOperations> entityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entity');
    });
  }

  QueryBuilder<SyncMutationLocal, String?, QQueryOperations>
      lastErrorCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastErrorCode');
    });
  }

  QueryBuilder<SyncMutationLocal, String?, QQueryOperations>
      lastErrorMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastErrorMessage');
    });
  }

  QueryBuilder<SyncMutationLocal, int?, QQueryOperations> localIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localId');
    });
  }

  QueryBuilder<SyncMutationLocal, String, QQueryOperations>
      operationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'operation');
    });
  }

  QueryBuilder<SyncMutationLocal, String, QQueryOperations>
      operationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'operationId');
    });
  }

  QueryBuilder<SyncMutationLocal, String, QQueryOperations>
      payloadJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'payloadJson');
    });
  }

  QueryBuilder<SyncMutationLocal, String?, QQueryOperations>
      remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<SyncMutationLocal, String, QQueryOperations> stateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'state');
    });
  }

  QueryBuilder<SyncMutationLocal, String, QQueryOperations> tenantIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tenantId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSyncConflictLocalCollection on Isar {
  IsarCollection<SyncConflictLocal> get syncConflictLocals => this.collection();
}

const SyncConflictLocalSchema = CollectionSchema(
  name: r'SyncConflictLocal',
  id: -8834152070367304205,
  properties: {
    r'baseRowVersion': PropertySchema(
      id: 0,
      name: r'baseRowVersion',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currentRowVersion': PropertySchema(
      id: 2,
      name: r'currentRowVersion',
      type: IsarType.long,
    ),
    r'entity': PropertySchema(
      id: 3,
      name: r'entity',
      type: IsarType.string,
    ),
    r'localId': PropertySchema(
      id: 4,
      name: r'localId',
      type: IsarType.long,
    ),
    r'localPayloadJson': PropertySchema(
      id: 5,
      name: r'localPayloadJson',
      type: IsarType.string,
    ),
    r'mutationId': PropertySchema(
      id: 6,
      name: r'mutationId',
      type: IsarType.string,
    ),
    r'remoteId': PropertySchema(
      id: 7,
      name: r'remoteId',
      type: IsarType.string,
    ),
    r'remoteSnapshotJson': PropertySchema(
      id: 8,
      name: r'remoteSnapshotJson',
      type: IsarType.string,
    ),
    r'resolution': PropertySchema(
      id: 9,
      name: r'resolution',
      type: IsarType.string,
    ),
    r'resolvedAt': PropertySchema(
      id: 10,
      name: r'resolvedAt',
      type: IsarType.dateTime,
    ),
    r'tenantId': PropertySchema(
      id: 11,
      name: r'tenantId',
      type: IsarType.string,
    )
  },
  estimateSize: _syncConflictLocalEstimateSize,
  serialize: _syncConflictLocalSerialize,
  deserialize: _syncConflictLocalDeserialize,
  deserializeProp: _syncConflictLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'tenantId': IndexSchema(
      id: -1042425927805315167,
      name: r'tenantId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tenantId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'mutationId': IndexSchema(
      id: 4450546051540618180,
      name: r'mutationId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'mutationId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _syncConflictLocalGetId,
  getLinks: _syncConflictLocalGetLinks,
  attach: _syncConflictLocalAttach,
  version: '3.3.2',
);

int _syncConflictLocalEstimateSize(
  SyncConflictLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.entity.length * 3;
  bytesCount += 3 + object.localPayloadJson.length * 3;
  {
    final value = object.mutationId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.remoteId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.remoteSnapshotJson.length * 3;
  {
    final value = object.resolution;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tenantId.length * 3;
  return bytesCount;
}

void _syncConflictLocalSerialize(
  SyncConflictLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.baseRowVersion);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.currentRowVersion);
  writer.writeString(offsets[3], object.entity);
  writer.writeLong(offsets[4], object.localId);
  writer.writeString(offsets[5], object.localPayloadJson);
  writer.writeString(offsets[6], object.mutationId);
  writer.writeString(offsets[7], object.remoteId);
  writer.writeString(offsets[8], object.remoteSnapshotJson);
  writer.writeString(offsets[9], object.resolution);
  writer.writeDateTime(offsets[10], object.resolvedAt);
  writer.writeString(offsets[11], object.tenantId);
}

SyncConflictLocal _syncConflictLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SyncConflictLocal();
  object.baseRowVersion = reader.readLongOrNull(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.currentRowVersion = reader.readLongOrNull(offsets[2]);
  object.entity = reader.readString(offsets[3]);
  object.id = id;
  object.localId = reader.readLongOrNull(offsets[4]);
  object.localPayloadJson = reader.readString(offsets[5]);
  object.mutationId = reader.readStringOrNull(offsets[6]);
  object.remoteId = reader.readStringOrNull(offsets[7]);
  object.remoteSnapshotJson = reader.readString(offsets[8]);
  object.resolution = reader.readStringOrNull(offsets[9]);
  object.resolvedAt = reader.readDateTimeOrNull(offsets[10]);
  object.tenantId = reader.readString(offsets[11]);
  return object;
}

P _syncConflictLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readStringOrNull(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _syncConflictLocalGetId(SyncConflictLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _syncConflictLocalGetLinks(
    SyncConflictLocal object) {
  return [];
}

void _syncConflictLocalAttach(
    IsarCollection<dynamic> col, Id id, SyncConflictLocal object) {
  object.id = id;
}

extension SyncConflictLocalQueryWhereSort
    on QueryBuilder<SyncConflictLocal, SyncConflictLocal, QWhere> {
  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SyncConflictLocalQueryWhere
    on QueryBuilder<SyncConflictLocal, SyncConflictLocal, QWhereClause> {
  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterWhereClause>
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

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterWhereClause>
      tenantIdEqualTo(String tenantId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tenantId',
        value: [tenantId],
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterWhereClause>
      tenantIdNotEqualTo(String tenantId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenantId',
              lower: [],
              upper: [tenantId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenantId',
              lower: [tenantId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenantId',
              lower: [tenantId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenantId',
              lower: [],
              upper: [tenantId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterWhereClause>
      mutationIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mutationId',
        value: [null],
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterWhereClause>
      mutationIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'mutationId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterWhereClause>
      mutationIdEqualTo(String? mutationId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'mutationId',
        value: [mutationId],
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterWhereClause>
      mutationIdNotEqualTo(String? mutationId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mutationId',
              lower: [],
              upper: [mutationId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mutationId',
              lower: [mutationId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mutationId',
              lower: [mutationId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'mutationId',
              lower: [],
              upper: [mutationId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension SyncConflictLocalQueryFilter
    on QueryBuilder<SyncConflictLocal, SyncConflictLocal, QFilterCondition> {
  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      baseRowVersionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'baseRowVersion',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      baseRowVersionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'baseRowVersion',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      baseRowVersionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseRowVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      baseRowVersionGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'baseRowVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      baseRowVersionLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'baseRowVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      baseRowVersionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'baseRowVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
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

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
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

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
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

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      currentRowVersionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'currentRowVersion',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      currentRowVersionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'currentRowVersion',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      currentRowVersionEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currentRowVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      currentRowVersionGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currentRowVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      currentRowVersionLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currentRowVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      currentRowVersionBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currentRowVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      entityEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      entityGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'entity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      entityLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'entity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      entityBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'entity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      entityStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'entity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      entityEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'entity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      entityContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'entity',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      entityMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'entity',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      entityIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'entity',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      entityIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'entity',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
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

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
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

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
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

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'localId',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'localId',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localPayloadJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localPayloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localPayloadJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localPayloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localPayloadJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localPayloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localPayloadJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localPayloadJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localPayloadJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'localPayloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localPayloadJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'localPayloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localPayloadJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'localPayloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localPayloadJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'localPayloadJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localPayloadJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localPayloadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      localPayloadJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'localPayloadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      mutationIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'mutationId',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      mutationIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'mutationId',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      mutationIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mutationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      mutationIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mutationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      mutationIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mutationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      mutationIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mutationId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      mutationIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mutationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      mutationIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mutationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      mutationIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mutationId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      mutationIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mutationId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      mutationIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mutationId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      mutationIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mutationId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'remoteId',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'remoteId',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'remoteId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'remoteId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'remoteId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteSnapshotJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteSnapshotJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteSnapshotJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteSnapshotJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteSnapshotJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteSnapshotJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'remoteSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteSnapshotJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'remoteSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteSnapshotJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'remoteSnapshotJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteSnapshotJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'remoteSnapshotJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteSnapshotJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteSnapshotJson',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      remoteSnapshotJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'remoteSnapshotJson',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolutionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'resolution',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolutionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'resolution',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolutionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resolution',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolutionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resolution',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolutionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resolution',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolutionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resolution',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolutionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'resolution',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolutionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'resolution',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolutionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'resolution',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolutionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'resolution',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolutionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resolution',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolutionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'resolution',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolvedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'resolvedAt',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolvedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'resolvedAt',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolvedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resolvedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolvedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resolvedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolvedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resolvedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      resolvedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resolvedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      tenantIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      tenantIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      tenantIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      tenantIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tenantId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      tenantIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      tenantIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      tenantIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tenantId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      tenantIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tenantId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      tenantIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tenantId',
        value: '',
      ));
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterFilterCondition>
      tenantIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tenantId',
        value: '',
      ));
    });
  }
}

extension SyncConflictLocalQueryObject
    on QueryBuilder<SyncConflictLocal, SyncConflictLocal, QFilterCondition> {}

extension SyncConflictLocalQueryLinks
    on QueryBuilder<SyncConflictLocal, SyncConflictLocal, QFilterCondition> {}

extension SyncConflictLocalQuerySortBy
    on QueryBuilder<SyncConflictLocal, SyncConflictLocal, QSortBy> {
  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByBaseRowVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRowVersion', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByBaseRowVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRowVersion', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByCurrentRowVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentRowVersion', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByCurrentRowVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentRowVersion', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByEntity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entity', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByEntityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entity', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByLocalPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPayloadJson', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByLocalPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPayloadJson', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByMutationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mutationId', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByMutationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mutationId', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByRemoteSnapshotJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteSnapshotJson', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByRemoteSnapshotJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteSnapshotJson', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByResolution() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolution', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByResolutionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolution', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByResolvedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedAt', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByResolvedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedAt', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByTenantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      sortByTenantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.desc);
    });
  }
}

extension SyncConflictLocalQuerySortThenBy
    on QueryBuilder<SyncConflictLocal, SyncConflictLocal, QSortThenBy> {
  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByBaseRowVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRowVersion', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByBaseRowVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRowVersion', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByCurrentRowVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentRowVersion', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByCurrentRowVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentRowVersion', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByEntity() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entity', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByEntityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'entity', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByLocalPayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPayloadJson', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByLocalPayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localPayloadJson', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByMutationId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mutationId', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByMutationIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mutationId', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByRemoteId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByRemoteIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteId', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByRemoteSnapshotJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteSnapshotJson', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByRemoteSnapshotJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteSnapshotJson', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByResolution() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolution', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByResolutionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolution', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByResolvedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedAt', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByResolvedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedAt', Sort.desc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByTenantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.asc);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QAfterSortBy>
      thenByTenantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenantId', Sort.desc);
    });
  }
}

extension SyncConflictLocalQueryWhereDistinct
    on QueryBuilder<SyncConflictLocal, SyncConflictLocal, QDistinct> {
  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QDistinct>
      distinctByBaseRowVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseRowVersion');
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QDistinct>
      distinctByCurrentRowVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentRowVersion');
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QDistinct>
      distinctByEntity({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'entity', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QDistinct>
      distinctByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localId');
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QDistinct>
      distinctByLocalPayloadJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localPayloadJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QDistinct>
      distinctByMutationId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mutationId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QDistinct>
      distinctByRemoteId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QDistinct>
      distinctByRemoteSnapshotJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteSnapshotJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QDistinct>
      distinctByResolution({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resolution', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QDistinct>
      distinctByResolvedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resolvedAt');
    });
  }

  QueryBuilder<SyncConflictLocal, SyncConflictLocal, QDistinct>
      distinctByTenantId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tenantId', caseSensitive: caseSensitive);
    });
  }
}

extension SyncConflictLocalQueryProperty
    on QueryBuilder<SyncConflictLocal, SyncConflictLocal, QQueryProperty> {
  QueryBuilder<SyncConflictLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SyncConflictLocal, int?, QQueryOperations>
      baseRowVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseRowVersion');
    });
  }

  QueryBuilder<SyncConflictLocal, DateTime, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<SyncConflictLocal, int?, QQueryOperations>
      currentRowVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentRowVersion');
    });
  }

  QueryBuilder<SyncConflictLocal, String, QQueryOperations> entityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'entity');
    });
  }

  QueryBuilder<SyncConflictLocal, int?, QQueryOperations> localIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localId');
    });
  }

  QueryBuilder<SyncConflictLocal, String, QQueryOperations>
      localPayloadJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localPayloadJson');
    });
  }

  QueryBuilder<SyncConflictLocal, String?, QQueryOperations>
      mutationIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mutationId');
    });
  }

  QueryBuilder<SyncConflictLocal, String?, QQueryOperations>
      remoteIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteId');
    });
  }

  QueryBuilder<SyncConflictLocal, String, QQueryOperations>
      remoteSnapshotJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteSnapshotJson');
    });
  }

  QueryBuilder<SyncConflictLocal, String?, QQueryOperations>
      resolutionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resolution');
    });
  }

  QueryBuilder<SyncConflictLocal, DateTime?, QQueryOperations>
      resolvedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resolvedAt');
    });
  }

  QueryBuilder<SyncConflictLocal, String, QQueryOperations> tenantIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tenantId');
    });
  }
}
