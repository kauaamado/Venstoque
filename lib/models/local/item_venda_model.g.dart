// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_venda_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetItemVendaLocalCollection on Isar {
  IsarCollection<ItemVendaLocal> get itemVendaLocals => this.collection();
}

const ItemVendaLocalSchema = CollectionSchema(
  name: r'ItemVendaLocal',
  id: 2020262140648840478,
  properties: {
    r'custoUnitario': PropertySchema(
      id: 0,
      name: r'custoUnitario',
      type: IsarType.double,
    ),
    r'precoUnitario': PropertySchema(
      id: 1,
      name: r'precoUnitario',
      type: IsarType.double,
    ),
    r'quantidade': PropertySchema(
      id: 2,
      name: r'quantidade',
      type: IsarType.long,
    ),
    r'supabaseId': PropertySchema(
      id: 3,
      name: r'supabaseId',
      type: IsarType.string,
    )
  },
  estimateSize: _itemVendaLocalEstimateSize,
  serialize: _itemVendaLocalSerialize,
  deserialize: _itemVendaLocalDeserialize,
  deserializeProp: _itemVendaLocalDeserializeProp,
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
    )
  },
  links: {
    r'venda': LinkSchema(
      id: 1435672161955640958,
      name: r'venda',
      target: r'VendaLocal',
      single: true,
    ),
    r'produto': LinkSchema(
      id: -8861151664969776666,
      name: r'produto',
      target: r'ProdutoLocal',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _itemVendaLocalGetId,
  getLinks: _itemVendaLocalGetLinks,
  attach: _itemVendaLocalAttach,
  version: '3.3.2',
);

int _itemVendaLocalEstimateSize(
  ItemVendaLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.supabaseId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _itemVendaLocalSerialize(
  ItemVendaLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.custoUnitario);
  writer.writeDouble(offsets[1], object.precoUnitario);
  writer.writeLong(offsets[2], object.quantidade);
  writer.writeString(offsets[3], object.supabaseId);
}

ItemVendaLocal _itemVendaLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ItemVendaLocal();
  object.custoUnitario = reader.readDouble(offsets[0]);
  object.id = id;
  object.precoUnitario = reader.readDouble(offsets[1]);
  object.quantidade = reader.readLong(offsets[2]);
  object.supabaseId = reader.readStringOrNull(offsets[3]);
  return object;
}

P _itemVendaLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _itemVendaLocalGetId(ItemVendaLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _itemVendaLocalGetLinks(ItemVendaLocal object) {
  return [object.venda, object.produto];
}

void _itemVendaLocalAttach(
    IsarCollection<dynamic> col, Id id, ItemVendaLocal object) {
  object.id = id;
  object.venda.attach(col, col.isar.collection<VendaLocal>(), r'venda', id);
  object.produto
      .attach(col, col.isar.collection<ProdutoLocal>(), r'produto', id);
}

extension ItemVendaLocalQueryWhereSort
    on QueryBuilder<ItemVendaLocal, ItemVendaLocal, QWhere> {
  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ItemVendaLocalQueryWhere
    on QueryBuilder<ItemVendaLocal, ItemVendaLocal, QWhereClause> {
  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterWhereClause> idBetween(
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

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterWhereClause>
      supabaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'supabaseId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterWhereClause>
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

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterWhereClause>
      supabaseIdEqualTo(String? supabaseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'supabaseId',
        value: [supabaseId],
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterWhereClause>
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
}

extension ItemVendaLocalQueryFilter
    on QueryBuilder<ItemVendaLocal, ItemVendaLocal, QFilterCondition> {
  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      custoUnitarioEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'custoUnitario',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      custoUnitarioGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'custoUnitario',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      custoUnitarioLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'custoUnitario',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      custoUnitarioBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'custoUnitario',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
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

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
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

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      precoUnitarioEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'precoUnitario',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      precoUnitarioGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'precoUnitario',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      precoUnitarioLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'precoUnitario',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      precoUnitarioBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'precoUnitario',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      quantidadeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantidade',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      quantidadeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantidade',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      quantidadeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantidade',
        value: value,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      quantidadeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantidade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      supabaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      supabaseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
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

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
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

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
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

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
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

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
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

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
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

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      supabaseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      supabaseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'supabaseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      supabaseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      supabaseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'supabaseId',
        value: '',
      ));
    });
  }
}

extension ItemVendaLocalQueryObject
    on QueryBuilder<ItemVendaLocal, ItemVendaLocal, QFilterCondition> {}

extension ItemVendaLocalQueryLinks
    on QueryBuilder<ItemVendaLocal, ItemVendaLocal, QFilterCondition> {
  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition> venda(
      FilterQuery<VendaLocal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'venda');
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      vendaIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'venda', 0, true, 0, true);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition> produto(
      FilterQuery<ProdutoLocal> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'produto');
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterFilterCondition>
      produtoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'produto', 0, true, 0, true);
    });
  }
}

extension ItemVendaLocalQuerySortBy
    on QueryBuilder<ItemVendaLocal, ItemVendaLocal, QSortBy> {
  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      sortByCustoUnitario() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'custoUnitario', Sort.asc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      sortByCustoUnitarioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'custoUnitario', Sort.desc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      sortByPrecoUnitario() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'precoUnitario', Sort.asc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      sortByPrecoUnitarioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'precoUnitario', Sort.desc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      sortByQuantidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantidade', Sort.asc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      sortByQuantidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantidade', Sort.desc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      sortBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      sortBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }
}

extension ItemVendaLocalQuerySortThenBy
    on QueryBuilder<ItemVendaLocal, ItemVendaLocal, QSortThenBy> {
  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      thenByCustoUnitario() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'custoUnitario', Sort.asc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      thenByCustoUnitarioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'custoUnitario', Sort.desc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      thenByPrecoUnitario() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'precoUnitario', Sort.asc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      thenByPrecoUnitarioDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'precoUnitario', Sort.desc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      thenByQuantidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantidade', Sort.asc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      thenByQuantidadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantidade', Sort.desc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      thenBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QAfterSortBy>
      thenBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }
}

extension ItemVendaLocalQueryWhereDistinct
    on QueryBuilder<ItemVendaLocal, ItemVendaLocal, QDistinct> {
  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QDistinct>
      distinctByCustoUnitario() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'custoUnitario');
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QDistinct>
      distinctByPrecoUnitario() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'precoUnitario');
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QDistinct>
      distinctByQuantidade() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantidade');
    });
  }

  QueryBuilder<ItemVendaLocal, ItemVendaLocal, QDistinct> distinctBySupabaseId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supabaseId', caseSensitive: caseSensitive);
    });
  }
}

extension ItemVendaLocalQueryProperty
    on QueryBuilder<ItemVendaLocal, ItemVendaLocal, QQueryProperty> {
  QueryBuilder<ItemVendaLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ItemVendaLocal, double, QQueryOperations>
      custoUnitarioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'custoUnitario');
    });
  }

  QueryBuilder<ItemVendaLocal, double, QQueryOperations>
      precoUnitarioProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'precoUnitario');
    });
  }

  QueryBuilder<ItemVendaLocal, int, QQueryOperations> quantidadeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantidade');
    });
  }

  QueryBuilder<ItemVendaLocal, String?, QQueryOperations> supabaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supabaseId');
    });
  }
}
