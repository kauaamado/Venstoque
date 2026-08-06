// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produto_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetProdutoLocalCollection on Isar {
  IsarCollection<ProdutoLocal> get produtoLocals => this.collection();
}

const ProdutoLocalSchema = CollectionSchema(
  name: r'ProdutoLocal',
  id: -2867617703037322759,
  properties: {
    r'ativo': PropertySchema(
      id: 0,
      name: r'ativo',
      type: IsarType.bool,
    ),
    r'bootstrapGeneration': PropertySchema(
      id: 1,
      name: r'bootstrapGeneration',
      type: IsarType.long,
    ),
    r'categoria': PropertySchema(
      id: 2,
      name: r'categoria',
      type: IsarType.string,
    ),
    r'empresaId': PropertySchema(
      id: 3,
      name: r'empresaId',
      type: IsarType.string,
    ),
    r'fornecedor': PropertySchema(
      id: 4,
      name: r'fornecedor',
      type: IsarType.string,
    ),
    r'nome': PropertySchema(
      id: 5,
      name: r'nome',
      type: IsarType.string,
    ),
    r'pendingDelete': PropertySchema(
      id: 6,
      name: r'pendingDelete',
      type: IsarType.bool,
    ),
    r'precoCusto': PropertySchema(
      id: 7,
      name: r'precoCusto',
      type: IsarType.double,
    ),
    r'quantidadeEstoque': PropertySchema(
      id: 8,
      name: r'quantidadeEstoque',
      type: IsarType.long,
    ),
    r'rowVersion': PropertySchema(
      id: 9,
      name: r'rowVersion',
      type: IsarType.long,
    ),
    r'supabaseId': PropertySchema(
      id: 10,
      name: r'supabaseId',
      type: IsarType.string,
    ),
    r'syncPending': PropertySchema(
      id: 11,
      name: r'syncPending',
      type: IsarType.bool,
    ),
    r'syncRevision': PropertySchema(
      id: 12,
      name: r'syncRevision',
      type: IsarType.long,
    ),
    r'valorVenda': PropertySchema(
      id: 13,
      name: r'valorVenda',
      type: IsarType.double,
    )
  },
  estimateSize: _produtoLocalEstimateSize,
  serialize: _produtoLocalSerialize,
  deserialize: _produtoLocalDeserialize,
  deserializeProp: _produtoLocalDeserializeProp,
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
    ),
    r'rowVersion': IndexSchema(
      id: 2605361139837295030,
      name: r'rowVersion',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'rowVersion',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _produtoLocalGetId,
  getLinks: _produtoLocalGetLinks,
  attach: _produtoLocalAttach,
  version: '3.3.2',
);

int _produtoLocalEstimateSize(
  ProdutoLocal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.categoria.length * 3;
  {
    final value = object.empresaId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.fornecedor.length * 3;
  bytesCount += 3 + object.nome.length * 3;
  {
    final value = object.supabaseId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _produtoLocalSerialize(
  ProdutoLocal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.ativo);
  writer.writeLong(offsets[1], object.bootstrapGeneration);
  writer.writeString(offsets[2], object.categoria);
  writer.writeString(offsets[3], object.empresaId);
  writer.writeString(offsets[4], object.fornecedor);
  writer.writeString(offsets[5], object.nome);
  writer.writeBool(offsets[6], object.pendingDelete);
  writer.writeDouble(offsets[7], object.precoCusto);
  writer.writeLong(offsets[8], object.quantidadeEstoque);
  writer.writeLong(offsets[9], object.rowVersion);
  writer.writeString(offsets[10], object.supabaseId);
  writer.writeBool(offsets[11], object.syncPending);
  writer.writeLong(offsets[12], object.syncRevision);
  writer.writeDouble(offsets[13], object.valorVenda);
}

ProdutoLocal _produtoLocalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProdutoLocal();
  object.ativo = reader.readBool(offsets[0]);
  object.bootstrapGeneration = reader.readLong(offsets[1]);
  object.categoria = reader.readString(offsets[2]);
  object.empresaId = reader.readStringOrNull(offsets[3]);
  object.fornecedor = reader.readString(offsets[4]);
  object.id = id;
  object.nome = reader.readString(offsets[5]);
  object.pendingDelete = reader.readBool(offsets[6]);
  object.precoCusto = reader.readDouble(offsets[7]);
  object.quantidadeEstoque = reader.readLong(offsets[8]);
  object.rowVersion = reader.readLong(offsets[9]);
  object.supabaseId = reader.readStringOrNull(offsets[10]);
  object.syncPending = reader.readBool(offsets[11]);
  object.syncRevision = reader.readLong(offsets[12]);
  object.valorVenda = reader.readDouble(offsets[13]);
  return object;
}

P _produtoLocalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _produtoLocalGetId(ProdutoLocal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _produtoLocalGetLinks(ProdutoLocal object) {
  return [];
}

void _produtoLocalAttach(
    IsarCollection<dynamic> col, Id id, ProdutoLocal object) {
  object.id = id;
}

extension ProdutoLocalQueryWhereSort
    on QueryBuilder<ProdutoLocal, ProdutoLocal, QWhere> {
  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhere> anyRowVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'rowVersion'),
      );
    });
  }
}

extension ProdutoLocalQueryWhere
    on QueryBuilder<ProdutoLocal, ProdutoLocal, QWhereClause> {
  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause> idBetween(
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause>
      supabaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'supabaseId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause> supabaseIdEqualTo(
      String? supabaseId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'supabaseId',
        value: [supabaseId],
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause>
      empresaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'empresaId',
        value: [null],
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause> empresaIdEqualTo(
      String? empresaId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'empresaId',
        value: [empresaId],
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause> rowVersionEqualTo(
      int rowVersion) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'rowVersion',
        value: [rowVersion],
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause>
      rowVersionNotEqualTo(int rowVersion) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rowVersion',
              lower: [],
              upper: [rowVersion],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rowVersion',
              lower: [rowVersion],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rowVersion',
              lower: [rowVersion],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'rowVersion',
              lower: [],
              upper: [rowVersion],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause>
      rowVersionGreaterThan(
    int rowVersion, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'rowVersion',
        lower: [rowVersion],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause>
      rowVersionLessThan(
    int rowVersion, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'rowVersion',
        lower: [],
        upper: [rowVersion],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterWhereClause> rowVersionBetween(
    int lowerRowVersion,
    int upperRowVersion, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'rowVersion',
        lower: [lowerRowVersion],
        includeLower: includeLower,
        upper: [upperRowVersion],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ProdutoLocalQueryFilter
    on QueryBuilder<ProdutoLocal, ProdutoLocal, QFilterCondition> {
  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition> ativoEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ativo',
        value: value,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      bootstrapGenerationEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bootstrapGeneration',
        value: value,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      bootstrapGenerationGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bootstrapGeneration',
        value: value,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      bootstrapGenerationLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bootstrapGeneration',
        value: value,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      bootstrapGenerationBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bootstrapGeneration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      categoriaEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      categoriaGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      categoriaLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      categoriaBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoria',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      categoriaStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      categoriaEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      categoriaContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoria',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      categoriaMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoria',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      categoriaIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoria',
        value: '',
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      categoriaIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoria',
        value: '',
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      empresaIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'empresaId',
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      empresaIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'empresaId',
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      empresaIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'empresaId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      empresaIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'empresaId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      empresaIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'empresaId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      empresaIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'empresaId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      fornecedorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fornecedor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      fornecedorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fornecedor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      fornecedorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fornecedor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      fornecedorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fornecedor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      fornecedorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fornecedor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      fornecedorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fornecedor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      fornecedorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fornecedor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      fornecedorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fornecedor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      fornecedorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fornecedor',
        value: '',
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      fornecedorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fornecedor',
        value: '',
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition> nomeEqualTo(
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition> nomeLessThan(
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition> nomeBetween(
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition> nomeEndsWith(
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition> nomeContains(
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition> nomeMatches(
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      nomeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nome',
        value: '',
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      nomeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nome',
        value: '',
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      pendingDeleteEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pendingDelete',
        value: value,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      precoCustoEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'precoCusto',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      precoCustoGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'precoCusto',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      precoCustoLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'precoCusto',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      precoCustoBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'precoCusto',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      quantidadeEstoqueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'quantidadeEstoque',
        value: value,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      quantidadeEstoqueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'quantidadeEstoque',
        value: value,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      quantidadeEstoqueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'quantidadeEstoque',
        value: value,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      quantidadeEstoqueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'quantidadeEstoque',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      rowVersionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rowVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      rowVersionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rowVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      rowVersionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rowVersion',
        value: value,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      rowVersionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rowVersion',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      supabaseIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      supabaseIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'supabaseId',
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      supabaseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'supabaseId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      supabaseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'supabaseId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      supabaseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      supabaseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'supabaseId',
        value: '',
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      syncPendingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncPending',
        value: value,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      syncRevisionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'syncRevision',
        value: value,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
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

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      valorVendaEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valorVenda',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      valorVendaGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valorVenda',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      valorVendaLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valorVenda',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterFilterCondition>
      valorVendaBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valorVenda',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension ProdutoLocalQueryObject
    on QueryBuilder<ProdutoLocal, ProdutoLocal, QFilterCondition> {}

extension ProdutoLocalQueryLinks
    on QueryBuilder<ProdutoLocal, ProdutoLocal, QFilterCondition> {}

extension ProdutoLocalQuerySortBy
    on QueryBuilder<ProdutoLocal, ProdutoLocal, QSortBy> {
  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortByAtivo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ativo', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortByAtivoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ativo', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      sortByBootstrapGeneration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bootstrapGeneration', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      sortByBootstrapGenerationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bootstrapGeneration', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortByCategoria() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoria', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortByCategoriaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoria', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortByEmpresaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortByEmpresaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortByFornecedor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fornecedor', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      sortByFornecedorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fornecedor', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortByNome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nome', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortByNomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nome', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortByPendingDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingDelete', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      sortByPendingDeleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingDelete', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortByPrecoCusto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'precoCusto', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      sortByPrecoCustoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'precoCusto', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      sortByQuantidadeEstoque() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantidadeEstoque', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      sortByQuantidadeEstoqueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantidadeEstoque', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortByRowVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rowVersion', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      sortByRowVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rowVersion', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      sortBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortBySyncPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncPending', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      sortBySyncPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncPending', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortBySyncRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncRevision', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      sortBySyncRevisionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncRevision', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> sortByValorVenda() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorVenda', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      sortByValorVendaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorVenda', Sort.desc);
    });
  }
}

extension ProdutoLocalQuerySortThenBy
    on QueryBuilder<ProdutoLocal, ProdutoLocal, QSortThenBy> {
  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenByAtivo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ativo', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenByAtivoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ativo', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      thenByBootstrapGeneration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bootstrapGeneration', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      thenByBootstrapGenerationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bootstrapGeneration', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenByCategoria() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoria', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenByCategoriaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoria', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenByEmpresaId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenByEmpresaIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'empresaId', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenByFornecedor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fornecedor', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      thenByFornecedorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fornecedor', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenByNome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nome', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenByNomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nome', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenByPendingDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingDelete', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      thenByPendingDeleteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pendingDelete', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenByPrecoCusto() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'precoCusto', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      thenByPrecoCustoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'precoCusto', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      thenByQuantidadeEstoque() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantidadeEstoque', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      thenByQuantidadeEstoqueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'quantidadeEstoque', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenByRowVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rowVersion', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      thenByRowVersionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rowVersion', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenBySupabaseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      thenBySupabaseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'supabaseId', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenBySyncPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncPending', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      thenBySyncPendingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncPending', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenBySyncRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncRevision', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      thenBySyncRevisionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'syncRevision', Sort.desc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy> thenByValorVenda() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorVenda', Sort.asc);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QAfterSortBy>
      thenByValorVendaDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valorVenda', Sort.desc);
    });
  }
}

extension ProdutoLocalQueryWhereDistinct
    on QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct> {
  QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct> distinctByAtivo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ativo');
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct>
      distinctByBootstrapGeneration() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bootstrapGeneration');
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct> distinctByCategoria(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoria', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct> distinctByEmpresaId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'empresaId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct> distinctByFornecedor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fornecedor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct> distinctByNome(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nome', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct>
      distinctByPendingDelete() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pendingDelete');
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct> distinctByPrecoCusto() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'precoCusto');
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct>
      distinctByQuantidadeEstoque() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'quantidadeEstoque');
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct> distinctByRowVersion() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rowVersion');
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct> distinctBySupabaseId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'supabaseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct> distinctBySyncPending() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncPending');
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct> distinctBySyncRevision() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'syncRevision');
    });
  }

  QueryBuilder<ProdutoLocal, ProdutoLocal, QDistinct> distinctByValorVenda() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'valorVenda');
    });
  }
}

extension ProdutoLocalQueryProperty
    on QueryBuilder<ProdutoLocal, ProdutoLocal, QQueryProperty> {
  QueryBuilder<ProdutoLocal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProdutoLocal, bool, QQueryOperations> ativoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ativo');
    });
  }

  QueryBuilder<ProdutoLocal, int, QQueryOperations>
      bootstrapGenerationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bootstrapGeneration');
    });
  }

  QueryBuilder<ProdutoLocal, String, QQueryOperations> categoriaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoria');
    });
  }

  QueryBuilder<ProdutoLocal, String?, QQueryOperations> empresaIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'empresaId');
    });
  }

  QueryBuilder<ProdutoLocal, String, QQueryOperations> fornecedorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fornecedor');
    });
  }

  QueryBuilder<ProdutoLocal, String, QQueryOperations> nomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nome');
    });
  }

  QueryBuilder<ProdutoLocal, bool, QQueryOperations> pendingDeleteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pendingDelete');
    });
  }

  QueryBuilder<ProdutoLocal, double, QQueryOperations> precoCustoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'precoCusto');
    });
  }

  QueryBuilder<ProdutoLocal, int, QQueryOperations>
      quantidadeEstoqueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'quantidadeEstoque');
    });
  }

  QueryBuilder<ProdutoLocal, int, QQueryOperations> rowVersionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rowVersion');
    });
  }

  QueryBuilder<ProdutoLocal, String?, QQueryOperations> supabaseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'supabaseId');
    });
  }

  QueryBuilder<ProdutoLocal, bool, QQueryOperations> syncPendingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncPending');
    });
  }

  QueryBuilder<ProdutoLocal, int, QQueryOperations> syncRevisionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'syncRevision');
    });
  }

  QueryBuilder<ProdutoLocal, double, QQueryOperations> valorVendaProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'valorVenda');
    });
  }
}
