// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetClienteLocalCollection on Isar {
  IsarCollection<ClienteLocal> get clienteLocals => this.collection();
}

const ClienteLocalSchema = CollectionSchema(
  name: r'ClienteLocal',
  id: -2581183314480681732,
  properties: {
    r'ativo': PropertySchema(
      id: 0,
      name: r'ativo',
      type: IsarType.bool,
    ),
    r'celular': PropertySchema(
      id: 1,
      name: r'celular',
      type: IsarType.string,
    ),
    r'empresaId': PropertySchema(
      id: 2,
      name: r'empresaId',
      type: IsarType.string,
    ),
    r'legacyId': PropertySchema(
      id: 3,
      name: r'legacyId',
      type: IsarType.long,
    ),
    r'nome': PropertySchema(
      id: 4,
      name: r'nome',
      type: IsarType.string,
    ),
    r'observacoes': PropertySchema(
      id: 5,
      name: r'observacoes',
      type: IsarType.string,
    ),
    r'pendingDelete': PropertySchema(
      id: 6,
      name: r'pendingDelete',
      type: IsarType.bool,
    ),
    r'referencia': PropertySchema(
      id: 7,
      name: r'referencia',
      type: IsarType.string,
    ),
    r'supabaseId': PropertySchema(
      id: 8,
      name: r'supabaseId',
      type: IsarType.string,
    ),
    r'syncPending': PropertySchema(
      id: 9,
      name: r'syncPending',
      type: IsarType.bool,
    ),
    r'syncRevision': PropertySchema(
      id: 10,
      name: r'syncRevision',
      type: IsarType.long,
    )
  },
  estimateSize: _clienteLocalEstimateSize,
  serialize: _clienteLocalSerialize,
  deserialize: _clienteLocalDeserialize,
  deserializeProp: _clienteLocalDeserializeProp,
  idName: r'id',
  indexes: {
    r'supabaseId': IndexSchema(
      id: 2753382765909358918,
      name: r'supabaseId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'supabaseId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'empresaId': IndexSchema(
      id: 4061495233042072508,
      name: r'empresaId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'empresaId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _clienteLocalGetId,
  getLinks: _clienteLocalGetLinks,
  attach: _clienteLocalAttach,
  version: '3.3.2',
);

int _clienteLocalEstimateSize(
  ClienteLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.celular.length * 3;
  {
    final value = object.empresaId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.nome.length * 3;
  bytesCount += 3 + object.observacoes.length * 3;
  bytesCount += 3 + object.referencia.length * 3;
  {
    final value = object.supabaseId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _clienteLocalSerialize(
  ClienteLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.ativo);
  writer.writeString(offsets[1], object.celular);
  writer.writeString(offsets[2], object.empresaId);
  writer.writeLong(offsets[3], object.legacyId);
  writer.writeString(offsets[4], object.nome);
  writer.writeString(offsets[5], object.observacoes);
  writer.writeBool(offsets[6], object.pendingDelete);
  writer.writeString(offsets[7], object.referencia);
  writer.writeString(offsets[8], object.supabaseId);
  writer.writeBool(offsets[9], object.syncPending);
  writer.writeLong(offsets[10], object.syncRevision);
}

ClienteLocal _clienteLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ClienteLocal();
  object.ativo = reader.readBool(offsets[0]);
  object.celular = reader.readString(offsets[1]);
  object.empresaId = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.legacyId = reader.readLongOrNull(offsets[3]);
  object.nome = reader.readString(offsets[4]);
  object.observacoes = reader.readString(offsets[5]);
  object.pendingDelete = reader.readBool(offsets[6]);
  object.referencia = reader.readString(offsets[7]);
  object.supabaseId = reader.readStringOrNull(offsets[8]);
  object.syncPending = reader.readBool(offsets[9]);
  object.syncRevision = reader.readLong(offsets[10]);
  return object;
}

P _clienteLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _clienteLocalGetId(ClienteLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _clienteLocalGetLinks(ClienteLocal object) {
  return [];
}

void _clienteLocalAttach(
    IsarCollection<dynamic> col, Id id, ClienteLocal object) {
  object.id = id;
}

extension ClienteLocalQueryWhereSort
    on QueryBuilder<ClienteLocal, ClienteLocal, QWhere> {
  QueryBuilder<ClienteLocal, ClienteLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ClienteLocalQueryWhere
    on QueryBuilder<ClienteLocal, ClienteLocal, QWhereClause> {
  QueryBuilder<ClienteLocal, ClienteLocal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterWhereClause> idBetween(
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

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterWhereClause>
      supabaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'supabaseId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterWhereClause>
      supabaseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'supabaseId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterWhereClause> supabaseIdEqualTo(
      String? supabaseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'supabaseId',
        value: [supabaseId],
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterWhereClause>
      supabaseIdNotEqualTo(String? supabaseId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'supabaseId',
              lower: [],
              upper: [supabaseId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'supabaseId',
              lower: [supabaseId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'supabaseId',
              lower: [supabaseId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'supabaseId',
              lower: [],
              upper: [supabaseId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterWhereClause>
      empresaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'empresaId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterWhereClause>
      empresaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'empresaId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterWhereClause> empresaIdEqualTo(
      String? empresaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'empresaId',
        value: [empresaId],
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterWhereClause>
      empresaIdNotEqualTo(String? empresaId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'empresaId',
              lower: [],
              upper: [empresaId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'empresaId',
              lower: [empresaId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'empresaId',
              lower: [empresaId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'empresaId',
              lower: [],
              upper: [empresaId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension ClienteLocalQueryFilter
    on QueryBuilder<ClienteLocal, ClienteLocal, QFilterCondition> {
  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition> ativoEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ativo',
        value: value,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      celularEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'celular',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      celularGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'celular',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      celularLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'celular',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      celularBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'celular',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      celularStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'celular',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      celularEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'celular',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      celularContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'celular',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      celularMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'celular',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      celularIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'celular',
        value: '',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      celularIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'celular',
        value: '',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      empresaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'empresaId',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      empresaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'empresaId',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      empresaIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'empresaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      empresaIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'empresaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      empresaIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'empresaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      empresaIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'empresaId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      empresaIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'empresaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      empresaIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'empresaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      empresaIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'empresaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      empresaIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'empresaId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      empresaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'empresaId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      empresaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'empresaId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      legacyIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'legacyId',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      legacyIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'legacyId',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      legacyIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'legacyId',
        value: value,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      legacyIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'legacyId',
        value: value,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      legacyIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'legacyId',
        value: value,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      legacyIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'legacyId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition> nomeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      nomeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition> nomeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition> nomeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nome',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      nomeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition> nomeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition> nomeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition> nomeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nome',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      nomeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nome',
        value: '',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      nomeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nome',
        value: '',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      observacoesEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observacoes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      observacoesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'observacoes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      observacoesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'observacoes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      observacoesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'observacoes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      observacoesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'observacoes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      observacoesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'observacoes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      observacoesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'observacoes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      observacoesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'observacoes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      observacoesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observacoes',
        value: '',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      observacoesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'observacoes',
        value: '',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      pendingDeleteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pendingDelete',
        value: value,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      referenciaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referencia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      referenciaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'referencia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      referenciaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'referencia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      referenciaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'referencia',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      referenciaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'referencia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      referenciaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'referencia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      referenciaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'referencia',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      referenciaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'referencia',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      referenciaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referencia',
        value: '',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      referenciaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'referencia',
        value: '',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      supabaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      supabaseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      supabaseIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      supabaseIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      supabaseIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      supabaseIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'supabaseId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      supabaseIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      supabaseIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      supabaseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      supabaseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'supabaseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      supabaseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      supabaseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      syncPendingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncPending',
        value: value,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      syncRevisionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncRevision',
        value: value,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      syncRevisionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'syncRevision',
        value: value,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      syncRevisionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'syncRevision',
        value: value,
      ));
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterFilterCondition>
      syncRevisionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'syncRevision',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ClienteLocalQueryObject
    on QueryBuilder<ClienteLocal, ClienteLocal, QFilterCondition> {}

extension ClienteLocalQueryLinks
    on QueryBuilder<ClienteLocal, ClienteLocal, QFilterCondition> {}

extension ClienteLocalQuerySortBy
    on QueryBuilder<ClienteLocal, ClienteLocal, QSortBy> {
  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortByAtivo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ativo', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortByAtivoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ativo', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortByCelular() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'celular', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortByCelularDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'celular', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortByEmpresaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortByEmpresaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortByLegacyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyId', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortByLegacyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyId', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortByNome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nome', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortByNomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nome', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortByObservacoes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacoes', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy>
      sortByObservacoesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacoes', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortByPendingDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingDelete', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy>
      sortByPendingDeleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingDelete', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortByReferencia() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referencia', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy>
      sortByReferenciaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referencia', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy>
      sortBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortBySyncPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncPending', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy>
      sortBySyncPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncPending', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> sortBySyncRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncRevision', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy>
      sortBySyncRevisionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncRevision', Sort.desc);
    });
  }
}

extension ClienteLocalQuerySortThenBy
    on QueryBuilder<ClienteLocal, ClienteLocal, QSortThenBy> {
  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenByAtivo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ativo', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenByAtivoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ativo', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenByCelular() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'celular', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenByCelularDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'celular', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenByEmpresaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenByEmpresaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenByLegacyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyId', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenByLegacyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyId', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenByNome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nome', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenByNomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nome', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenByObservacoes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacoes', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy>
      thenByObservacoesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacoes', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenByPendingDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingDelete', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy>
      thenByPendingDeleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingDelete', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenByReferencia() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referencia', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy>
      thenByReferenciaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referencia', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy>
      thenBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenBySyncPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncPending', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy>
      thenBySyncPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncPending', Sort.desc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy> thenBySyncRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncRevision', Sort.asc);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QAfterSortBy>
      thenBySyncRevisionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncRevision', Sort.desc);
    });
  }
}

extension ClienteLocalQueryWhereDistinct
    on QueryBuilder<ClienteLocal, ClienteLocal, QDistinct> {
  QueryBuilder<ClienteLocal, ClienteLocal, QDistinct> distinctByAtivo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ativo');
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QDistinct> distinctByCelular(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'celular', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QDistinct> distinctByEmpresaId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'empresaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QDistinct> distinctByLegacyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'legacyId');
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QDistinct> distinctByNome(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nome', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QDistinct> distinctByObservacoes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'observacoes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QDistinct>
      distinctByPendingDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pendingDelete');
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QDistinct> distinctByReferencia(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'referencia', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QDistinct> distinctBySupabaseId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supabaseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QDistinct> distinctBySyncPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncPending');
    });
  }

  QueryBuilder<ClienteLocal, ClienteLocal, QDistinct> distinctBySyncRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncRevision');
    });
  }
}

extension ClienteLocalQueryProperty
    on QueryBuilder<ClienteLocal, ClienteLocal, QQueryProperty> {
  QueryBuilder<ClienteLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ClienteLocal, bool, QQueryOperations> ativoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ativo');
    });
  }

  QueryBuilder<ClienteLocal, String, QQueryOperations> celularProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'celular');
    });
  }

  QueryBuilder<ClienteLocal, String?, QQueryOperations> empresaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'empresaId');
    });
  }

  QueryBuilder<ClienteLocal, int?, QQueryOperations> legacyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'legacyId');
    });
  }

  QueryBuilder<ClienteLocal, String, QQueryOperations> nomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nome');
    });
  }

  QueryBuilder<ClienteLocal, String, QQueryOperations> observacoesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'observacoes');
    });
  }

  QueryBuilder<ClienteLocal, bool, QQueryOperations> pendingDeleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pendingDelete');
    });
  }

  QueryBuilder<ClienteLocal, String, QQueryOperations> referenciaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referencia');
    });
  }

  QueryBuilder<ClienteLocal, String?, QQueryOperations> supabaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supabaseId');
    });
  }

  QueryBuilder<ClienteLocal, bool, QQueryOperations> syncPendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncPending');
    });
  }

  QueryBuilder<ClienteLocal, int, QQueryOperations> syncRevisionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncRevision');
    });
  }
}
