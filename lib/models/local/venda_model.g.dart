// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venda_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVendaLocalCollection on Isar {
  IsarCollection<VendaLocal> get vendaLocals => this.collection();
}

const VendaLocalSchema = CollectionSchema(
  name: r'VendaLocal',
  id: 5162636752435704399,
  properties: {
    r'dataVenda': PropertySchema(
      id: 0,
      name: r'dataVenda',
      type: IsarType.dateTime,
    ),
    r'desconto': PropertySchema(
      id: 1,
      name: r'desconto',
      type: IsarType.double,
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
    r'observacoes': PropertySchema(
      id: 4,
      name: r'observacoes',
      type: IsarType.string,
    ),
    r'supabaseId': PropertySchema(
      id: 5,
      name: r'supabaseId',
      type: IsarType.string,
    ),
    r'tipoPagamento': PropertySchema(
      id: 6,
      name: r'tipoPagamento',
      type: IsarType.string,
    ),
    r'valorEntrada': PropertySchema(
      id: 7,
      name: r'valorEntrada',
      type: IsarType.double,
    ),
    r'valorTotal': PropertySchema(
      id: 8,
      name: r'valorTotal',
      type: IsarType.double,
    )
  },
  estimateSize: _vendaLocalEstimateSize,
  serialize: _vendaLocalSerialize,
  deserialize: _vendaLocalDeserialize,
  deserializeProp: _vendaLocalDeserializeProp,
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
    r'cliente': LinkSchema(
      id: -8619936429595979693,
      name: r'cliente',
      target: r'ClienteLocal',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _vendaLocalGetId,
  getLinks: _vendaLocalGetLinks,
  attach: _vendaLocalAttach,
  version: '3.3.2',
);

int _vendaLocalEstimateSize(
  VendaLocal object,
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
  bytesCount += 3 + object.observacoes.length * 3;
  {
    final value = object.supabaseId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.tipoPagamento.length * 3;
  return bytesCount;
}

void _vendaLocalSerialize(
  VendaLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.dataVenda);
  writer.writeDouble(offsets[1], object.desconto);
  writer.writeString(offsets[2], object.empresaId);
  writer.writeLong(offsets[3], object.legacyId);
  writer.writeString(offsets[4], object.observacoes);
  writer.writeString(offsets[5], object.supabaseId);
  writer.writeString(offsets[6], object.tipoPagamento);
  writer.writeDouble(offsets[7], object.valorEntrada);
  writer.writeDouble(offsets[8], object.valorTotal);
}

VendaLocal _vendaLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = VendaLocal();
  object.dataVenda = reader.readDateTime(offsets[0]);
  object.desconto = reader.readDouble(offsets[1]);
  object.empresaId = reader.readStringOrNull(offsets[2]);
  object.id = id;
  object.legacyId = reader.readLongOrNull(offsets[3]);
  object.observacoes = reader.readString(offsets[4]);
  object.supabaseId = reader.readStringOrNull(offsets[5]);
  object.tipoPagamento = reader.readString(offsets[6]);
  object.valorEntrada = reader.readDouble(offsets[7]);
  object.valorTotal = reader.readDouble(offsets[8]);
  return object;
}

P _vendaLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _vendaLocalGetId(VendaLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _vendaLocalGetLinks(VendaLocal object) {
  return [object.cliente];
}

void _vendaLocalAttach(IsarCollection<dynamic> col, Id id, VendaLocal object) {
  object.id = id;
  object.cliente
      .attach(col, col.isar.collection<ClienteLocal>(), r'cliente', id);
}

extension VendaLocalQueryWhereSort
    on QueryBuilder<VendaLocal, VendaLocal, QWhere> {
  QueryBuilder<VendaLocal, VendaLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VendaLocalQueryWhere
    on QueryBuilder<VendaLocal, VendaLocal, QWhereClause> {
  QueryBuilder<VendaLocal, VendaLocal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterWhereClause> idBetween(
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterWhereClause> supabaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'supabaseId',
        value: [null],
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterWhereClause>
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterWhereClause> supabaseIdEqualTo(
      String? supabaseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'supabaseId',
        value: [supabaseId],
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterWhereClause> supabaseIdNotEqualTo(
      String? supabaseId) {
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterWhereClause> empresaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'empresaId',
        value: [null],
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterWhereClause> empresaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'empresaId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterWhereClause> empresaIdEqualTo(
      String? empresaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'empresaId',
        value: [empresaId],
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterWhereClause> empresaIdNotEqualTo(
      String? empresaId) {
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

extension VendaLocalQueryFilter
    on QueryBuilder<VendaLocal, VendaLocal, QFilterCondition> {
  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> dataVendaEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataVenda',
        value: value,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      dataVendaGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataVenda',
        value: value,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> dataVendaLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataVenda',
        value: value,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> dataVendaBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataVenda',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> descontoEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'desconto',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      descontoGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'desconto',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> descontoLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'desconto',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> descontoBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'desconto',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      empresaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'empresaId',
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      empresaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'empresaId',
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> empresaIdEqualTo(
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> empresaIdLessThan(
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> empresaIdBetween(
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> empresaIdEndsWith(
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> empresaIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'empresaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> empresaIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'empresaId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      empresaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'empresaId',
        value: '',
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      empresaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'empresaId',
        value: '',
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> legacyIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'legacyId',
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      legacyIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'legacyId',
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> legacyIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'legacyId',
        value: value,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> legacyIdLessThan(
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> legacyIdBetween(
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      observacoesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'observacoes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      observacoesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'observacoes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      observacoesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observacoes',
        value: '',
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      observacoesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'observacoes',
        value: '',
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      supabaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      supabaseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> supabaseIdEqualTo(
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> supabaseIdBetween(
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
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

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      supabaseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> supabaseIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'supabaseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      supabaseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      supabaseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      tipoPagamentoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipoPagamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      tipoPagamentoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tipoPagamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      tipoPagamentoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tipoPagamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      tipoPagamentoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tipoPagamento',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      tipoPagamentoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tipoPagamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      tipoPagamentoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tipoPagamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      tipoPagamentoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tipoPagamento',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      tipoPagamentoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tipoPagamento',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      tipoPagamentoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tipoPagamento',
        value: '',
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      tipoPagamentoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tipoPagamento',
        value: '',
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      valorEntradaEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valorEntrada',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      valorEntradaGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valorEntrada',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      valorEntradaLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valorEntrada',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      valorEntradaBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valorEntrada',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> valorTotalEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valorTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      valorTotalGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valorTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition>
      valorTotalLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valorTotal',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> valorTotalBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valorTotal',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension VendaLocalQueryObject
    on QueryBuilder<VendaLocal, VendaLocal, QFilterCondition> {}

extension VendaLocalQueryLinks
    on QueryBuilder<VendaLocal, VendaLocal, QFilterCondition> {
  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> cliente(
      FilterQuery<ClienteLocal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'cliente');
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterFilterCondition> clienteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'cliente', 0, true, 0, true);
    });
  }
}

extension VendaLocalQuerySortBy
    on QueryBuilder<VendaLocal, VendaLocal, QSortBy> {
  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByDataVenda() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVenda', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByDataVendaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVenda', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByDesconto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desconto', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByDescontoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desconto', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByEmpresaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByEmpresaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByLegacyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyId', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByLegacyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyId', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByObservacoes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacoes', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByObservacoesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacoes', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByTipoPagamento() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoPagamento', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByTipoPagamentoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoPagamento', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByValorEntrada() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorEntrada', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByValorEntradaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorEntrada', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByValorTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorTotal', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> sortByValorTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorTotal', Sort.desc);
    });
  }
}

extension VendaLocalQuerySortThenBy
    on QueryBuilder<VendaLocal, VendaLocal, QSortThenBy> {
  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByDataVenda() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVenda', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByDataVendaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataVenda', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByDesconto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desconto', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByDescontoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desconto', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByEmpresaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByEmpresaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByLegacyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyId', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByLegacyIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'legacyId', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByObservacoes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacoes', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByObservacoesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observacoes', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByTipoPagamento() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoPagamento', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByTipoPagamentoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tipoPagamento', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByValorEntrada() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorEntrada', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByValorEntradaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorEntrada', Sort.desc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByValorTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorTotal', Sort.asc);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QAfterSortBy> thenByValorTotalDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorTotal', Sort.desc);
    });
  }
}

extension VendaLocalQueryWhereDistinct
    on QueryBuilder<VendaLocal, VendaLocal, QDistinct> {
  QueryBuilder<VendaLocal, VendaLocal, QDistinct> distinctByDataVenda() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataVenda');
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QDistinct> distinctByDesconto() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'desconto');
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QDistinct> distinctByEmpresaId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'empresaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QDistinct> distinctByLegacyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'legacyId');
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QDistinct> distinctByObservacoes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'observacoes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QDistinct> distinctBySupabaseId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supabaseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QDistinct> distinctByTipoPagamento(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tipoPagamento',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QDistinct> distinctByValorEntrada() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'valorEntrada');
    });
  }

  QueryBuilder<VendaLocal, VendaLocal, QDistinct> distinctByValorTotal() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'valorTotal');
    });
  }
}

extension VendaLocalQueryProperty
    on QueryBuilder<VendaLocal, VendaLocal, QQueryProperty> {
  QueryBuilder<VendaLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<VendaLocal, DateTime, QQueryOperations> dataVendaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataVenda');
    });
  }

  QueryBuilder<VendaLocal, double, QQueryOperations> descontoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'desconto');
    });
  }

  QueryBuilder<VendaLocal, String?, QQueryOperations> empresaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'empresaId');
    });
  }

  QueryBuilder<VendaLocal, int?, QQueryOperations> legacyIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'legacyId');
    });
  }

  QueryBuilder<VendaLocal, String, QQueryOperations> observacoesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'observacoes');
    });
  }

  QueryBuilder<VendaLocal, String?, QQueryOperations> supabaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supabaseId');
    });
  }

  QueryBuilder<VendaLocal, String, QQueryOperations> tipoPagamentoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tipoPagamento');
    });
  }

  QueryBuilder<VendaLocal, double, QQueryOperations> valorEntradaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'valorEntrada');
    });
  }

  QueryBuilder<VendaLocal, double, QQueryOperations> valorTotalProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'valorTotal');
    });
  }
}
