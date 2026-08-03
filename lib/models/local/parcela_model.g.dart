// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcela_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetParcelaLocalCollection on Isar {
  IsarCollection<ParcelaLocal> get parcelaLocals => this.collection();
}

const ParcelaLocalSchema = CollectionSchema(
  name: r'ParcelaLocal',
  id: -4154994121289351938,
  properties: {
    r'dataPagamento': PropertySchema(
      id: 0,
      name: r'dataPagamento',
      type: IsarType.dateTime,
    ),
    r'dataVencimento': PropertySchema(
      id: 1,
      name: r'dataVencimento',
      type: IsarType.dateTime,
    ),
    r'empresaId': PropertySchema(
      id: 2,
      name: r'empresaId',
      type: IsarType.string,
    ),
    r'numeroParcela': PropertySchema(
      id: 3,
      name: r'numeroParcela',
      type: IsarType.long,
    ),
    r'status': PropertySchema(
      id: 4,
      name: r'status',
      type: IsarType.string,
    ),
    r'supabaseId': PropertySchema(
      id: 5,
      name: r'supabaseId',
      type: IsarType.string,
    ),
    r'valor': PropertySchema(
      id: 6,
      name: r'valor',
      type: IsarType.double,
    )
  },
  estimateSize: _parcelaLocalEstimateSize,
  serialize: _parcelaLocalSerialize,
  deserialize: _parcelaLocalDeserialize,
  deserializeProp: _parcelaLocalDeserializeProp,
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
  links: {
    r'venda': LinkSchema(
      id: 8242133675090895943,
      name: r'venda',
      target: r'VendaLocal',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _parcelaLocalGetId,
  getLinks: _parcelaLocalGetLinks,
  attach: _parcelaLocalAttach,
  version: '3.3.2',
);

int _parcelaLocalEstimateSize(
  ParcelaLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.empresaId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.status.length * 3;
  {
    final value = object.supabaseId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _parcelaLocalSerialize(
  ParcelaLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dataPagamento);
  writer.writeDateTime(offsets[1], object.dataVencimento);
  writer.writeString(offsets[2], object.empresaId);
  writer.writeLong(offsets[3], object.numeroParcela);
  writer.writeString(offsets[4], object.status);
  writer.writeString(offsets[5], object.supabaseId);
  writer.writeDouble(offsets[6], object.valor);
}

ParcelaLocal _parcelaLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ParcelaLocal();
  object.dataPagamento = reader.readDateTimeOrNull(offsets[0]);
  object.dataVencimento = reader.readDateTime(offsets[1]);
  object.empresaId = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.numeroParcela = reader.readLong(offsets[3]);
  object.status = reader.readString(offsets[4]);
  object.supabaseId = reader.readStringOrNull(offsets[5]);
  object.valor = reader.readDouble(offsets[6]);
  return object;
}

P _parcelaLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _parcelaLocalGetId(ParcelaLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _parcelaLocalGetLinks(ParcelaLocal object) {
  return [object.venda];
}

void _parcelaLocalAttach(
    IsarCollection<dynamic> col, Id id, ParcelaLocal object) {
  object.id = id;
  object.venda.attach(col, col.isar.collection<VendaLocal>(), r'venda', id);
}

extension ParcelaLocalQueryWhereSort
    on QueryBuilder<ParcelaLocal, ParcelaLocal, QWhere> {
  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ParcelaLocalQueryWhere
    on QueryBuilder<ParcelaLocal, ParcelaLocal, QWhereClause> {
  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterWhereClause> idBetween(
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterWhereClause>
      supabaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'supabaseId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterWhereClause>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterWhereClause> supabaseIdEqualTo(
      String? supabaseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'supabaseId',
        value: [supabaseId],
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterWhereClause>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterWhereClause>
      empresaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'empresaId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterWhereClause>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterWhereClause> empresaIdEqualTo(
      String? empresaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'empresaId',
        value: [empresaId],
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterWhereClause>
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

extension ParcelaLocalQueryFilter
    on QueryBuilder<ParcelaLocal, ParcelaLocal, QFilterCondition> {
  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      dataPagamentoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dataPagamento',
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      dataPagamentoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dataPagamento',
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      dataPagamentoEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataPagamento',
        value: value,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      dataPagamentoGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataPagamento',
        value: value,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      dataPagamentoLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataPagamento',
        value: value,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      dataPagamentoBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataPagamento',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      dataVencimentoEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataVencimento',
        value: value,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      dataVencimentoGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataVencimento',
        value: value,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      dataVencimentoLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataVencimento',
        value: value,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      dataVencimentoBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataVencimento',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      empresaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'empresaId',
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      empresaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'empresaId',
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      empresaIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'empresaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      empresaIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'empresaId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      empresaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'empresaId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      empresaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'empresaId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      numeroParcelaEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'numeroParcela',
        value: value,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      numeroParcelaGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'numeroParcela',
        value: value,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      numeroParcelaLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'numeroParcela',
        value: value,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      numeroParcelaBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'numeroParcela',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition> statusEqualTo(
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition> statusBetween(
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      statusContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'status',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition> statusMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'status',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      statusIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      statusIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'status',
        value: '',
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      supabaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      supabaseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
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

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      supabaseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      supabaseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'supabaseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      supabaseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      supabaseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition> valorEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      valorGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition> valorLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valor',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition> valorBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension ParcelaLocalQueryObject
    on QueryBuilder<ParcelaLocal, ParcelaLocal, QFilterCondition> {}

extension ParcelaLocalQueryLinks
    on QueryBuilder<ParcelaLocal, ParcelaLocal, QFilterCondition> {
  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition> venda(
      FilterQuery<VendaLocal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'venda');
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterFilterCondition>
      vendaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'venda', 0, true, 0, true);
    });
  }
}

extension ParcelaLocalQuerySortBy
    on QueryBuilder<ParcelaLocal, ParcelaLocal, QSortBy> {
  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> sortByDataPagamento() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataPagamento', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy>
      sortByDataPagamentoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataPagamento', Sort.desc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy>
      sortByDataVencimento() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVencimento', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy>
      sortByDataVencimentoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVencimento', Sort.desc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> sortByEmpresaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> sortByEmpresaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.desc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> sortByNumeroParcela() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numeroParcela', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy>
      sortByNumeroParcelaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numeroParcela', Sort.desc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> sortBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy>
      sortBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> sortByValor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valor', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> sortByValorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valor', Sort.desc);
    });
  }
}

extension ParcelaLocalQuerySortThenBy
    on QueryBuilder<ParcelaLocal, ParcelaLocal, QSortThenBy> {
  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> thenByDataPagamento() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataPagamento', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy>
      thenByDataPagamentoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataPagamento', Sort.desc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy>
      thenByDataVencimento() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVencimento', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy>
      thenByDataVencimentoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVencimento', Sort.desc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> thenByEmpresaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> thenByEmpresaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.desc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> thenByNumeroParcela() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numeroParcela', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy>
      thenByNumeroParcelaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'numeroParcela', Sort.desc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> thenBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy>
      thenBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> thenByValor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valor', Sort.asc);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QAfterSortBy> thenByValorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valor', Sort.desc);
    });
  }
}

extension ParcelaLocalQueryWhereDistinct
    on QueryBuilder<ParcelaLocal, ParcelaLocal, QDistinct> {
  QueryBuilder<ParcelaLocal, ParcelaLocal, QDistinct>
      distinctByDataPagamento() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataPagamento');
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QDistinct>
      distinctByDataVencimento() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataVencimento');
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QDistinct> distinctByEmpresaId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'empresaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QDistinct>
      distinctByNumeroParcela() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'numeroParcela');
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QDistinct> distinctByStatus(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QDistinct> distinctBySupabaseId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supabaseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ParcelaLocal, ParcelaLocal, QDistinct> distinctByValor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'valor');
    });
  }
}

extension ParcelaLocalQueryProperty
    on QueryBuilder<ParcelaLocal, ParcelaLocal, QQueryProperty> {
  QueryBuilder<ParcelaLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ParcelaLocal, DateTime?, QQueryOperations>
      dataPagamentoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataPagamento');
    });
  }

  QueryBuilder<ParcelaLocal, DateTime, QQueryOperations>
      dataVencimentoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataVencimento');
    });
  }

  QueryBuilder<ParcelaLocal, String?, QQueryOperations> empresaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'empresaId');
    });
  }

  QueryBuilder<ParcelaLocal, int, QQueryOperations> numeroParcelaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'numeroParcela');
    });
  }

  QueryBuilder<ParcelaLocal, String, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<ParcelaLocal, String?, QQueryOperations> supabaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supabaseId');
    });
  }

  QueryBuilder<ParcelaLocal, double, QQueryOperations> valorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'valor');
    });
  }
}
