const int legacyMigrationBatchSize = 500;
const String legacyMigrationProductCategory = 'Histórico legado';
const String legacyMigrationProductSupplier = '__migracao_legado_v1__';
const String legacyMigrationConsumerName = 'Consumidor Final';

/// Erro que impede a migração antes de uma escrita inconsistente.
class LegacyMigrationException implements Exception {
  LegacyMigrationException(this.message);

  final String message;

  @override
  String toString() => 'LegacyMigrationException: $message';
}

/// Informa que a validação passou, mas um lote remoto interrompeu a execução.
/// O relatório permite retomar a importação com evidência dos lotes confirmados.
class LegacyMigrationExecutionException extends LegacyMigrationException {
  LegacyMigrationExecutionException(super.message, this.report);

  final LegacyMigrationRunReport report;
}

/// Representa o conteúdo validado do arquivo legado, sem UUIDs remotos.
class LegacyMigrationPlan {
  LegacyMigrationPlan({
    required this.clientes,
    required this.produtos,
    required this.vendas,
    required this.itens,
    required this.parcelas,
    required this.warnings,
  });

  final List<LegacyMigrationCliente> clientes;
  final List<LegacyMigrationProduto> produtos;
  final List<LegacyMigrationVenda> vendas;
  final List<LegacyMigrationItem> itens;
  final List<LegacyMigrationParcela> parcelas;
  final List<String> warnings;
}

class LegacyMigrationCliente {
  const LegacyMigrationCliente({
    required this.legacyId,
    required this.nome,
    required this.celular,
    required this.referencia,
    required this.observacoes,
  });

  final int legacyId;
  final String nome;
  final String celular;
  final String referencia;
  final String observacoes;

  Map<String, dynamic> toPayload(String empresaId) => {
        'empresa_id': empresaId,
        'nome': nome,
        'celular': celular,
        'referencia': referencia,
        'observacoes': observacoes,
        'ativo': true,
        'legacy_id': legacyId,
      };
}

class LegacyMigrationProduto {
  const LegacyMigrationProduto({required this.nome});

  final String nome;

  String get identity => legacyProductIdentity(nome);

  Map<String, dynamic> toPayload(String empresaId) => {
        'empresa_id': empresaId,
        'nome': nome,
        'categoria': legacyMigrationProductCategory,
        'fornecedor': legacyMigrationProductSupplier,
        'preco_custo': 0.0,
        'valor_venda': 0.0,
        'quantidade_estoque': 0,
        'ativo': false,
      };
}

class LegacyMigrationVenda {
  const LegacyMigrationVenda({
    required this.legacyId,
    required this.clienteLegacyId,
    required this.dataVenda,
    required this.valorTotalCentavos,
    required this.valorEntradaCentavos,
    required this.observacoes,
  });

  final int legacyId;
  final int clienteLegacyId;
  final String dataVenda;
  final int valorTotalCentavos;
  final int valorEntradaCentavos;
  final String observacoes;

  bool get possuiSaldo => valorEntradaCentavos < valorTotalCentavos;

  Map<String, dynamic> toPayload({
    required String empresaId,
    required String clienteId,
  }) =>
      {
        'empresa_id': empresaId,
        'cliente_id': clienteId,
        'data_venda': dataVenda,
        'valor_total': centsToDouble(valorTotalCentavos),
        'valor_entrada': centsToDouble(valorEntradaCentavos),
        'desconto': 0.0,
        'tipo_pagamento': possuiSaldo ? 'fiado' : 'a_vista',
        'observacoes': observacoes,
        'legacy_id': legacyId,
      };
}

class LegacyMigrationItem {
  const LegacyMigrationItem({
    required this.vendaLegacyId,
    required this.produtoIdentity,
    required this.precoUnitarioCentavos,
    required this.custoUnitarioCentavos,
  });

  final int vendaLegacyId;
  final String produtoIdentity;
  final int precoUnitarioCentavos;
  final int custoUnitarioCentavos;

  Map<String, dynamic> toPayload({
    required String vendaId,
    required String produtoId,
  }) =>
      {
        'venda_id': vendaId,
        'produto_id': produtoId,
        'quantidade': 1,
        'preco_unitario': centsToDouble(precoUnitarioCentavos),
        'custo_unitario': centsToDouble(custoUnitarioCentavos),
      };
}

class LegacyMigrationParcela {
  const LegacyMigrationParcela({
    required this.vendaLegacyId,
    required this.valorCentavos,
    required this.dataVencimento,
  });

  final int vendaLegacyId;
  final int valorCentavos;
  final String dataVencimento;

  Map<String, dynamic> toPayload({
    required String empresaId,
    required String vendaId,
  }) =>
      {
        'empresa_id': empresaId,
        'venda_id': vendaId,
        'numero_parcela': 1,
        'valor': centsToDouble(valorCentavos),
        'data_vencimento': dataVencimento,
        'data_pagamento': null,
        'status': 'pendente',
      };
}

/// Lê e valida o formato exportado pelo aplicativo legado.
LegacyMigrationPlan buildLegacyMigrationPlan(Map<String, dynamic> source) {
  final clientsSource = _requiredList(source, 'clients');
  final salesSource = _requiredList(source, 'sales');
  final sourceClientIds = <int>{};
  final clientes = <LegacyMigrationCliente>[];
  final clientesPorLegacyId = <int, LegacyMigrationCliente>{};

  for (final raw in clientsSource) {
    final row = _requiredMap(raw, 'clients');
    final legacyId = _requiredInt(row, 'a');
    if (!sourceClientIds.add(legacyId)) {
      throw LegacyMigrationException('Há clientes legados com ID duplicado.');
    }

    final nome = _requiredText(row, 'c');
    final cadastroLegado = _requiredText(row, 'b');
    final observacoes = _joinLines([
      '[Legado] Cadastro criado em: $cadastroLegado',
      _optionalText(row['e']),
    ]);
    final cliente = LegacyMigrationCliente(
      legacyId: legacyId,
      nome: nome,
      celular: _digitsOnly(_optionalText(row['d'])),
      referencia: '',
      observacoes: observacoes,
    );
    clientes.add(cliente);
    clientesPorLegacyId[legacyId] = cliente;
  }

  final parsedSales = <_ParsedLegacySale>[];
  final saleIds = <int>{};
  for (final raw in salesSource) {
    final row = _requiredMap(raw, 'sales');
    final sale = _ParsedLegacySale.fromMap(row);
    if (!saleIds.add(sale.legacyId)) {
      throw LegacyMigrationException('Há vendas legadas com ID duplicado.');
    }
    parsedSales.add(sale);
  }
  parsedSales
      .sort((first, second) => first.legacyId.compareTo(second.legacyId));

  final recoveredCustomerGroups = <String, List<_ParsedLegacySale>>{};
  final consumerFinalSales = <_ParsedLegacySale>[];
  for (final sale in parsedSales) {
    if (clientesPorLegacyId.containsKey(sale.clienteLegacyId)) continue;

    final name = sale.nomeCliente.trim();
    final phone = _digitsOnly(sale.telefoneCliente);
    if (name.isNotEmpty || phone.isNotEmpty) {
      if (name.isEmpty) {
        throw LegacyMigrationException(
          'Uma venda órfã possui telefone, mas não possui nome de cliente.',
        );
      }
      final identity = '${_identityText(name)}\u0000$phone';
      recoveredCustomerGroups.putIfAbsent(identity, () => []).add(sale);
      continue;
    }

    if (sale.clienteLegacyId == 0 &&
        (sale.legacyId == 180 || sale.legacyId == 464)) {
      consumerFinalSales.add(sale);
      continue;
    }

    throw LegacyMigrationException(
      'Há uma venda órfã sem identificação recuperável do cliente.',
    );
  }

  final usedLegacyIds = <int>{...sourceClientIds};
  for (final group in recoveredCustomerGroups.values) {
    group.sort((first, second) => first.legacyId.compareTo(second.legacyId));
    final syntheticLegacyId = -group.first.legacyId;
    if (!usedLegacyIds.add(syntheticLegacyId)) {
      throw LegacyMigrationException(
        'Não foi possível reservar um ID legado para cliente recuperado.',
      );
    }
    final first = group.first;
    final recovered = LegacyMigrationCliente(
      legacyId: syntheticLegacyId,
      nome: first.nomeCliente.trim(),
      celular: _digitsOnly(first.telefoneCliente),
      referencia: '',
      observacoes: '[Legado] Cliente recuperado de venda sem referência.',
    );
    clientes.add(recovered);
    for (final sale in group) {
      sale.clienteLegacyId = syntheticLegacyId;
    }
  }

  if (consumerFinalSales.isNotEmpty) {
    if (!usedLegacyIds.add(0)) {
      throw LegacyMigrationException(
        'O ID legado reservado para Consumidor Final já está em uso.',
      );
    }
    clientes.add(const LegacyMigrationCliente(
      legacyId: 0,
      nome: legacyMigrationConsumerName,
      celular: '',
      referencia: '',
      observacoes: '[Legado] Cliente criado para vendas sem identificação.',
    ));
    for (final sale in consumerFinalSales) {
      sale.clienteLegacyId = 0;
    }
  }

  final productsByIdentity = <String, LegacyMigrationProduto>{};
  final vendas = <LegacyMigrationVenda>[];
  final itens = <LegacyMigrationItem>[];
  final parcelas = <LegacyMigrationParcela>[];

  for (final sale in parsedSales) {
    final description = _normalizeDescription(sale.descricao);
    final product = productsByIdentity.putIfAbsent(
      legacyProductIdentity(description),
      () => LegacyMigrationProduto(nome: description),
    );
    final valorTotal = sale.valorTotalCentavos;
    final valorEntrada = sale.valorEntradaCentavos;
    final venda = LegacyMigrationVenda(
      legacyId: sale.legacyId,
      clienteLegacyId: sale.clienteLegacyId,
      dataVenda: brasiliaIsoFromEpochMillis(sale.dataVendaMillis),
      valorTotalCentavos: valorTotal,
      valorEntradaCentavos: valorEntrada,
      observacoes: _joinLines([
        '[Legado] Criada no sistema em: '
            '${brasiliaIsoFromEpochMillis(sale.criadaEmMillis)}',
        sale.observacoes,
      ]),
    );
    vendas.add(venda);
    itens.add(LegacyMigrationItem(
      vendaLegacyId: sale.legacyId,
      produtoIdentity: product.identity,
      precoUnitarioCentavos: valorTotal,
      custoUnitarioCentavos: sale.custoUnitarioCentavos,
    ));
    if (venda.possuiSaldo) {
      parcelas.add(LegacyMigrationParcela(
        vendaLegacyId: sale.legacyId,
        valorCentavos: valorTotal - valorEntrada,
        dataVencimento: brasiliaIsoFromEpochMillis(
          sale.dataVendaMillis,
          addDays: 30,
        ),
      ));
    }
  }

  final warnings = <String>[];
  if (consumerFinalSales.isNotEmpty) {
    warnings.add(
      '${consumerFinalSales.length} vendas foram vinculadas a Consumidor Final.',
    );
  }
  return LegacyMigrationPlan(
    clientes: List.unmodifiable(clientes),
    produtos: List.unmodifiable(productsByIdentity.values),
    vendas: List.unmodifiable(vendas),
    itens: List.unmodifiable(itens),
    parcelas: List.unmodifiable(parcelas),
    warnings: List.unmodifiable(warnings),
  );
}

String legacyProductIdentity(String name) =>
    '$legacyMigrationProductSupplier\u0000$legacyMigrationProductCategory\u0000$name';

int moneyToCents(num value) => (value.toDouble() * 100).round();

double centsToDouble(int value) => value / 100.0;

/// Representa o instante em UTC-3 sem depender do fuso da máquina local.
String brasiliaIsoFromEpochMillis(int milliseconds, {int addDays = 0}) {
  final shifted = DateTime.fromMillisecondsSinceEpoch(
    milliseconds,
    isUtc: true,
  ).subtract(const Duration(hours: 3));
  final wallClock = DateTime.utc(
    shifted.year,
    shifted.month,
    shifted.day,
    shifted.hour,
    shifted.minute,
    shifted.second,
    shifted.millisecond,
    shifted.microsecond,
  ).add(Duration(days: addDays));
  String two(int value) => value.toString().padLeft(2, '0');
  String three(int value) => value.toString().padLeft(3, '0');
  return '${wallClock.year.toString().padLeft(4, '0')}-${two(wallClock.month)}-'
      '${two(wallClock.day)}T${two(wallClock.hour)}:${two(wallClock.minute)}:'
      '${two(wallClock.second)}.${three(wallClock.millisecond)}-03:00';
}

/// Porta remota. O núcleo não conhece credenciais nem Supabase Flutter.
abstract interface class LegacyMigrationGateway {
  Future<List<Map<String, dynamic>>> fetchClientes(String empresaId);

  Future<List<Map<String, dynamic>>> fetchProdutos(String empresaId);

  Future<List<Map<String, dynamic>>> fetchVendas(String empresaId);

  Future<List<Map<String, dynamic>>> fetchItensVenda(String empresaId);

  Future<List<Map<String, dynamic>>> fetchParcelas(String empresaId);

  Future<List<Map<String, dynamic>>> insertClientes(
    List<Map<String, dynamic>> payload,
  );

  Future<List<Map<String, dynamic>>> insertProdutos(
    List<Map<String, dynamic>> payload,
  );

  Future<List<Map<String, dynamic>>> insertVendas(
    List<Map<String, dynamic>> payload,
  );

  Future<List<Map<String, dynamic>>> insertItensVenda(
    List<Map<String, dynamic>> payload,
  );

  Future<List<Map<String, dynamic>>> insertParcelas(
    List<Map<String, dynamic>> payload,
  );
}

class LegacyMigrationRunReport {
  LegacyMigrationRunReport({
    required this.dryRun,
    required this.expected,
    required this.existing,
    required this.inserted,
    required this.warnings,
  });

  final bool dryRun;
  final Map<String, int> expected;
  final Map<String, int> existing;
  final Map<String, int> inserted;
  final List<String> warnings;

  Map<String, dynamic> toJson() => {
        'dry_run': dryRun,
        'expected': expected,
        'existing': existing,
        'inserted': inserted,
        'warnings': warnings,
      };
}

/// Faz a reconciliação e executa somente os inserts que faltarem.
class LegacyMigrationRunner {
  LegacyMigrationRunner(this._gateway);

  final LegacyMigrationGateway _gateway;

  Future<LegacyMigrationRunReport> run({
    required LegacyMigrationPlan plan,
    required String empresaId,
    required bool apply,
  }) async {
    final trimmedEmpresaId = empresaId.trim();
    if (trimmedEmpresaId.isEmpty) {
      throw LegacyMigrationException(
          'O identificador da empresa é obrigatório.');
    }

    final snapshots = await Future.wait([
      _gateway.fetchClientes(trimmedEmpresaId),
      _gateway.fetchProdutos(trimmedEmpresaId),
      _gateway.fetchVendas(trimmedEmpresaId),
      _gateway.fetchItensVenda(trimmedEmpresaId),
      _gateway.fetchParcelas(trimmedEmpresaId),
    ]);
    final remote = _RemoteMigrationSnapshot(
      clientes: snapshots[0],
      produtos: snapshots[1],
      vendas: snapshots[2],
      itens: snapshots[3],
      parcelas: snapshots[4],
    );
    final reconciliation = _reconcile(plan, remote, trimmedEmpresaId);
    final expected = <String, int>{
      'clientes': plan.clientes.length,
      'produtos': plan.produtos.length,
      'vendas': plan.vendas.length,
      'itens_venda': plan.itens.length,
      'parcelas': plan.parcelas.length,
    };
    final existing = reconciliation.existingCounts;
    final inserted = <String, int>{
      'clientes': 0,
      'produtos': 0,
      'vendas': 0,
      'itens_venda': 0,
      'parcelas': 0,
    };
    if (!apply) {
      return LegacyMigrationRunReport(
        dryRun: true,
        expected: expected,
        existing: existing,
        inserted: inserted,
        warnings: plan.warnings,
      );
    }

    var stage = 'clientes';
    try {
      final clienteIds = Map<int, String>.from(reconciliation.clienteIds);
      final produtoIds = Map<String, String>.from(reconciliation.produtoIds);
      final vendaIds = Map<int, String>.from(reconciliation.vendaIds);

      final insertedClientes = await _insertInBatches(
        reconciliation.clientesMissing
            .map((cliente) => cliente.toPayload(trimmedEmpresaId))
            .toList(),
        _gateway.insertClientes,
        onBatchInserted: (count) =>
            inserted['clientes'] = inserted['clientes']! + count,
      );
      _bindClientes(insertedClientes, clienteIds);

      stage = 'produtos';
      final insertedProdutos = await _insertInBatches(
        reconciliation.produtosMissing
            .map((produto) => produto.toPayload(trimmedEmpresaId))
            .toList(),
        _gateway.insertProdutos,
        onBatchInserted: (count) =>
            inserted['produtos'] = inserted['produtos']! + count,
      );
      _bindProdutos(insertedProdutos, produtoIds);

      stage = 'vendas';
      final salesPayload = reconciliation.vendasMissing.map((venda) {
        final clienteId = clienteIds[venda.clienteLegacyId];
        if (clienteId == null) {
          throw LegacyMigrationException(
            'Não foi possível resolver o cliente de uma venda legada.',
          );
        }
        return venda.toPayload(
          empresaId: trimmedEmpresaId,
          clienteId: clienteId,
        );
      }).toList();
      final insertedVendas = await _insertInBatches(
        salesPayload,
        _gateway.insertVendas,
        onBatchInserted: (count) =>
            inserted['vendas'] = inserted['vendas']! + count,
      );
      _bindVendas(insertedVendas, vendaIds);

      stage = 'itens de venda';
      final itemsPayload = reconciliation.itensMissing.map((item) {
        final vendaId = vendaIds[item.vendaLegacyId];
        final produtoId = produtoIds[item.produtoIdentity];
        if (vendaId == null || produtoId == null) {
          throw LegacyMigrationException(
            'Não foi possível resolver as dependências de um item de venda.',
          );
        }
        return item.toPayload(vendaId: vendaId, produtoId: produtoId);
      }).toList();
      await _insertInBatches(
        itemsPayload,
        _gateway.insertItensVenda,
        onBatchInserted: (count) =>
            inserted['itens_venda'] = inserted['itens_venda']! + count,
      );

      stage = 'parcelas';
      final parcelsPayload = reconciliation.parcelasMissing.map((parcela) {
        final vendaId = vendaIds[parcela.vendaLegacyId];
        if (vendaId == null) {
          throw LegacyMigrationException(
            'Não foi possível resolver a venda de uma parcela.',
          );
        }
        return parcela.toPayload(empresaId: trimmedEmpresaId, vendaId: vendaId);
      }).toList();
      await _insertInBatches(
        parcelsPayload,
        _gateway.insertParcelas,
        onBatchInserted: (count) =>
            inserted['parcelas'] = inserted['parcelas']! + count,
      );

      return LegacyMigrationRunReport(
        dryRun: false,
        expected: expected,
        existing: existing,
        inserted: inserted,
        warnings: plan.warnings,
      );
    } catch (error) {
      throw LegacyMigrationExecutionException(
        'A execução foi interrompida durante a etapa de $stage.',
        LegacyMigrationRunReport(
          dryRun: false,
          expected: expected,
          existing: existing,
          inserted: inserted,
          warnings: plan.warnings,
        ),
      );
    }
  }

  _Reconciliation _reconcile(
    LegacyMigrationPlan plan,
    _RemoteMigrationSnapshot remote,
    String empresaId,
  ) {
    final remoteClientes = remote.clientsByLegacyId(plan.clientes);
    final remoteProdutos = remote.productsByIdentity(plan.produtos);
    final remoteVendas = remote.salesByLegacyId(plan.vendas);
    final clienteIds = <int, String>{};
    final produtoIds = <String, String>{};
    final vendaIds = <int, String>{};
    final clientesMissing = <LegacyMigrationCliente>[];
    final produtosMissing = <LegacyMigrationProduto>[];
    final vendasMissing = <LegacyMigrationVenda>[];
    final itensMissing = <LegacyMigrationItem>[];
    final parcelasMissing = <LegacyMigrationParcela>[];

    for (final cliente in plan.clientes) {
      final row = remoteClientes[cliente.legacyId];
      if (row == null) {
        clientesMissing.add(cliente);
        continue;
      }
      if (!_sameCliente(row, cliente, empresaId)) {
        throw LegacyMigrationException('Conflito em cliente já migrado.');
      }
      clienteIds[cliente.legacyId] = _remoteId(row);
    }

    for (final produto in plan.produtos) {
      final row = remoteProdutos[produto.identity];
      if (row == null) {
        produtosMissing.add(produto);
        continue;
      }
      if (!_sameProduto(row, produto, empresaId)) {
        throw LegacyMigrationException(
            'Conflito em produto histórico já migrado.');
      }
      produtoIds[produto.identity] = _remoteId(row);
    }

    for (final venda in plan.vendas) {
      final row = remoteVendas[venda.legacyId];
      if (row == null) {
        vendasMissing.add(venda);
        continue;
      }
      final clienteId = clienteIds[venda.clienteLegacyId];
      if (clienteId == null || !_sameVenda(row, venda, empresaId, clienteId)) {
        throw LegacyMigrationException('Conflito em venda já migrada.');
      }
      vendaIds[venda.legacyId] = _remoteId(row);
    }

    final itemBySale = remote.rowsBySale(remote.itens);
    final parcelaBySale = remote.rowsBySale(remote.parcelas);
    final itemsByLegacySale = <int, LegacyMigrationItem>{
      for (final item in plan.itens) item.vendaLegacyId: item,
    };
    final parcelsByLegacySale = <int, LegacyMigrationParcela>{
      for (final parcela in plan.parcelas) parcela.vendaLegacyId: parcela,
    };

    for (final venda in plan.vendas) {
      final remoteSaleId = vendaIds[venda.legacyId];
      if (remoteSaleId == null) {
        itensMissing.add(itemsByLegacySale[venda.legacyId]!);
        final parcela = parcelsByLegacySale[venda.legacyId];
        if (parcela != null) parcelasMissing.add(parcela);
        continue;
      }

      final expectedItem = itemsByLegacySale[venda.legacyId]!;
      final productId = produtoIds[expectedItem.produtoIdentity];
      if (productId == null) {
        throw LegacyMigrationException('Conflito em item de venda já migrado.');
      }
      final existingItems = itemBySale[remoteSaleId] ?? const [];
      if (existingItems.isEmpty) {
        itensMissing.add(expectedItem);
      } else if (existingItems.length != 1 ||
          !_sameItem(
              existingItems.single, expectedItem, remoteSaleId, productId)) {
        throw LegacyMigrationException('Conflito em item de venda já migrado.');
      }

      final expectedParcela = parcelsByLegacySale[venda.legacyId];
      final existingParcelas = parcelaBySale[remoteSaleId] ?? const [];
      if (expectedParcela == null) {
        if (existingParcelas.isNotEmpty) {
          throw LegacyMigrationException(
              'Conflito em parcela de venda quitada.');
        }
      } else if (existingParcelas.isEmpty) {
        parcelasMissing.add(expectedParcela);
      } else if (existingParcelas.length != 1 ||
          !_sameParcela(
            existingParcelas.single,
            expectedParcela,
            empresaId,
            remoteSaleId,
          )) {
        throw LegacyMigrationException('Conflito em parcela já migrada.');
      }
    }

    return _Reconciliation(
      clienteIds: clienteIds,
      produtoIds: produtoIds,
      vendaIds: vendaIds,
      clientesMissing: clientesMissing,
      produtosMissing: produtosMissing,
      vendasMissing: vendasMissing,
      itensMissing: itensMissing,
      parcelasMissing: parcelasMissing,
      existingCounts: {
        'clientes': plan.clientes.length - clientesMissing.length,
        'produtos': plan.produtos.length - produtosMissing.length,
        'vendas': plan.vendas.length - vendasMissing.length,
        'itens_venda': plan.itens.length - itensMissing.length,
        'parcelas': plan.parcelas.length - parcelasMissing.length,
      },
    );
  }
}

class _Reconciliation {
  const _Reconciliation({
    required this.clienteIds,
    required this.produtoIds,
    required this.vendaIds,
    required this.clientesMissing,
    required this.produtosMissing,
    required this.vendasMissing,
    required this.itensMissing,
    required this.parcelasMissing,
    required this.existingCounts,
  });

  final Map<int, String> clienteIds;
  final Map<String, String> produtoIds;
  final Map<int, String> vendaIds;
  final List<LegacyMigrationCliente> clientesMissing;
  final List<LegacyMigrationProduto> produtosMissing;
  final List<LegacyMigrationVenda> vendasMissing;
  final List<LegacyMigrationItem> itensMissing;
  final List<LegacyMigrationParcela> parcelasMissing;
  final Map<String, int> existingCounts;
}

class _RemoteMigrationSnapshot {
  const _RemoteMigrationSnapshot({
    required this.clientes,
    required this.produtos,
    required this.vendas,
    required this.itens,
    required this.parcelas,
  });

  final List<Map<String, dynamic>> clientes;
  final List<Map<String, dynamic>> produtos;
  final List<Map<String, dynamic>> vendas;
  final List<Map<String, dynamic>> itens;
  final List<Map<String, dynamic>> parcelas;

  Map<int, Map<String, dynamic>> clientsByLegacyId(
    List<LegacyMigrationCliente> expected,
  ) {
    final expectedIds = expected.map((item) => item.legacyId).toSet();
    return _byIntKey(clientes, 'legacy_id', expectedIds, 'clientes');
  }

  Map<String, Map<String, dynamic>> productsByIdentity(
    List<LegacyMigrationProduto> expected,
  ) {
    final expectedIds = expected.map((item) => item.identity).toSet();
    final result = <String, Map<String, dynamic>>{};
    for (final row in produtos) {
      if (_string(row['fornecedor']) != legacyMigrationProductSupplier ||
          _string(row['categoria']) != legacyMigrationProductCategory) {
        continue;
      }
      final identity = legacyProductIdentity(_string(row['nome']));
      if (!expectedIds.contains(identity)) continue;
      if (result.containsKey(identity)) {
        throw LegacyMigrationException(
            'Há produtos históricos remotos duplicados.');
      }
      result[identity] = row;
    }
    return result;
  }

  Map<int, Map<String, dynamic>> salesByLegacyId(
    List<LegacyMigrationVenda> expected,
  ) {
    final expectedIds = expected.map((item) => item.legacyId).toSet();
    return _byIntKey(vendas, 'legacy_id', expectedIds, 'vendas');
  }

  Map<String, List<Map<String, dynamic>>> rowsBySale(
    List<Map<String, dynamic>> rows,
  ) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final row in rows) {
      final saleId = _string(row['venda_id']);
      if (saleId.isEmpty) continue;
      grouped.putIfAbsent(saleId, () => []).add(row);
    }
    return grouped;
  }
}

Map<int, Map<String, dynamic>> _byIntKey(
  List<Map<String, dynamic>> rows,
  String key,
  Set<int> expectedIds,
  String entity,
) {
  final result = <int, Map<String, dynamic>>{};
  for (final row in rows) {
    final value = _nullableInt(row[key]);
    if (value == null || !expectedIds.contains(value)) continue;
    if (result.containsKey(value)) {
      throw LegacyMigrationException(
          'Há $entity remotos com legacy_id duplicado.');
    }
    result[value] = row;
  }
  return result;
}

bool _sameCliente(
  Map<String, dynamic> row,
  LegacyMigrationCliente expected,
  String empresaId,
) =>
    _string(row['empresa_id']) == empresaId &&
    _string(row['nome']) == expected.nome &&
    _string(row['celular']) == expected.celular &&
    _string(row['referencia']) == expected.referencia &&
    _string(row['observacoes']) == expected.observacoes &&
    _bool(row['ativo']) &&
    _nullableInt(row['legacy_id']) == expected.legacyId;

bool _sameProduto(
  Map<String, dynamic> row,
  LegacyMigrationProduto expected,
  String empresaId,
) =>
    _string(row['empresa_id']) == empresaId &&
    _string(row['nome']) == expected.nome &&
    _string(row['categoria']) == legacyMigrationProductCategory &&
    _string(row['fornecedor']) == legacyMigrationProductSupplier &&
    _moneyFromRemote(row['preco_custo']) == 0 &&
    _moneyFromRemote(row['valor_venda']) == 0 &&
    _integer(row['quantidade_estoque']) == 0 &&
    !_bool(row['ativo']);

bool _sameVenda(
  Map<String, dynamic> row,
  LegacyMigrationVenda expected,
  String empresaId,
  String clienteId,
) =>
    _string(row['empresa_id']) == empresaId &&
    _string(row['cliente_id']) == clienteId &&
    sameInstant(row['data_venda'], expected.dataVenda) &&
    _moneyFromRemote(row['valor_total']) == expected.valorTotalCentavos &&
    _moneyFromRemote(row['valor_entrada']) == expected.valorEntradaCentavos &&
    _moneyFromRemote(row['desconto']) == 0 &&
    _string(row['tipo_pagamento']) ==
        (expected.possuiSaldo ? 'fiado' : 'a_vista') &&
    _string(row['observacoes']) == expected.observacoes &&
    _nullableInt(row['legacy_id']) == expected.legacyId;

bool _sameItem(
  Map<String, dynamic> row,
  LegacyMigrationItem expected,
  String vendaId,
  String produtoId,
) =>
    _string(row['venda_id']) == vendaId &&
    _string(row['produto_id']) == produtoId &&
    _integer(row['quantidade']) == 1 &&
    _moneyFromRemote(row['preco_unitario']) == expected.precoUnitarioCentavos &&
    _moneyFromRemote(row['custo_unitario']) == expected.custoUnitarioCentavos;

bool _sameParcela(
  Map<String, dynamic> row,
  LegacyMigrationParcela expected,
  String empresaId,
  String vendaId,
) =>
    _string(row['empresa_id']) == empresaId &&
    _string(row['venda_id']) == vendaId &&
    _integer(row['numero_parcela']) == 1 &&
    _moneyFromRemote(row['valor']) == expected.valorCentavos &&
    sameCalendarDate(row['data_vencimento'], expected.dataVencimento) &&
    row['data_pagamento'] == null &&
    _string(row['status']) == 'pendente';

Future<List<Map<String, dynamic>>> _insertInBatches(
  List<Map<String, dynamic>> payload,
  Future<List<Map<String, dynamic>>> Function(List<Map<String, dynamic>>)
      insert, {
  void Function(int count)? onBatchInserted,
}) async {
  final inserted = <Map<String, dynamic>>[];
  for (var start = 0;
      start < payload.length;
      start += legacyMigrationBatchSize) {
    final end = start + legacyMigrationBatchSize < payload.length
        ? start + legacyMigrationBatchSize
        : payload.length;
    final batch = payload.sublist(start, end);
    final response = await insert(batch);
    if (response.length != batch.length) {
      throw LegacyMigrationException(
        'O servidor não confirmou todos os registros de um lote.',
      );
    }
    inserted.addAll(response);
    onBatchInserted?.call(response.length);
  }
  return inserted;
}

void _bindClientes(
  List<Map<String, dynamic>> rows,
  Map<int, String> ids,
) {
  for (final row in rows) {
    final legacyId = _nullableInt(row['legacy_id']);
    if (legacyId == null || ids.containsKey(legacyId)) {
      throw LegacyMigrationException('Retorno inválido ao inserir clientes.');
    }
    ids[legacyId] = _remoteId(row);
  }
}

void _bindProdutos(
  List<Map<String, dynamic>> rows,
  Map<String, String> ids,
) {
  for (final row in rows) {
    final identity = legacyProductIdentity(_string(row['nome']));
    if (ids.containsKey(identity) ||
        _string(row['fornecedor']) != legacyMigrationProductSupplier ||
        _string(row['categoria']) != legacyMigrationProductCategory) {
      throw LegacyMigrationException('Retorno inválido ao inserir produtos.');
    }
    ids[identity] = _remoteId(row);
  }
}

void _bindVendas(List<Map<String, dynamic>> rows, Map<int, String> ids) {
  for (final row in rows) {
    final legacyId = _nullableInt(row['legacy_id']);
    if (legacyId == null || ids.containsKey(legacyId)) {
      throw LegacyMigrationException('Retorno inválido ao inserir vendas.');
    }
    ids[legacyId] = _remoteId(row);
  }
}

class _ParsedLegacySale {
  _ParsedLegacySale({
    required this.legacyId,
    required this.clienteLegacyId,
    required this.criadaEmMillis,
    required this.dataVendaMillis,
    required this.valorTotalCentavos,
    required this.valorEntradaCentavos,
    required this.custoUnitarioCentavos,
    required this.descricao,
    required this.nomeCliente,
    required this.telefoneCliente,
    required this.observacoes,
  });

  factory _ParsedLegacySale.fromMap(Map<String, dynamic> row) {
    final total = _requiredMoney(row, 'w');
    final entrada = _requiredMoney(row, 'x');
    if (total < 0 || entrada < 0 || entrada > total) {
      throw LegacyMigrationException(
          'Há valores financeiros inválidos em venda.');
    }
    final cost = _requiredMoney(row, 'D');
    if (cost < 0) {
      throw LegacyMigrationException('Há custo negativo em venda legada.');
    }
    return _ParsedLegacySale(
      legacyId: _requiredInt(row, 'q'),
      clienteLegacyId: _requiredInt(row, 'A'),
      criadaEmMillis: _requiredEpoch(row, 'v'),
      dataVendaMillis: _requiredEpoch(row, 'z'),
      valorTotalCentavos: total,
      valorEntradaCentavos: entrada,
      custoUnitarioCentavos: cost,
      descricao: _optionalText(row['y']),
      nomeCliente: _optionalText(row['B']),
      telefoneCliente: _optionalText(row['C']),
      observacoes: _optionalText(row['E']),
    );
  }

  final int legacyId;
  int clienteLegacyId;
  final int criadaEmMillis;
  final int dataVendaMillis;
  final int valorTotalCentavos;
  final int valorEntradaCentavos;
  final int custoUnitarioCentavos;
  final String descricao;
  final String nomeCliente;
  final String telefoneCliente;
  final String observacoes;
}

List<dynamic> _requiredList(Map<String, dynamic> source, String key) {
  final value = source[key];
  if (value is! List) {
    throw LegacyMigrationException('O arquivo não possui a lista $key.');
  }
  return value;
}

Map<String, dynamic> _requiredMap(Object? value, String source) {
  if (value is! Map) {
    throw LegacyMigrationException('Há um registro inválido em $source.');
  }
  return Map<String, dynamic>.from(value);
}

String _requiredText(Map<String, dynamic> row, String key) {
  final value = _optionalText(row[key]);
  if (value.isEmpty) {
    throw LegacyMigrationException(
        'Há um texto obrigatório ausente no legado.');
  }
  return value;
}

String _optionalText(Object? value) => value?.toString().trim() ?? '';

int _requiredInt(Map<String, dynamic> row, String key) {
  final value = row[key];
  final parsed = value is num ? value : num.tryParse('$value');
  if (parsed == null || parsed != parsed.roundToDouble()) {
    throw LegacyMigrationException('Há um identificador legado inválido.');
  }
  return parsed.toInt();
}

int _requiredEpoch(Map<String, dynamic> row, String key) {
  final value = _requiredInt(row, key);
  try {
    DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
  } on ArgumentError {
    throw LegacyMigrationException('Há uma data Epoch inválida no legado.');
  }
  return value;
}

int _requiredMoney(Map<String, dynamic> row, String key) {
  final value = row[key];
  final parsed = value is num ? value : num.tryParse('$value');
  if (parsed == null || !parsed.isFinite) {
    throw LegacyMigrationException(
        'Há um valor financeiro inválido no legado.');
  }
  return moneyToCents(parsed);
}

String _normalizeDescription(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? 'Item legado sem descrição' : trimmed;
}

String _identityText(String value) =>
    value.replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();

String _digitsOnly(String value) => value.replaceAll(RegExp(r'\D'), '');

String _joinLines(Iterable<String> parts) =>
    parts.where((part) => part.trim().isNotEmpty).join('\n');

String _string(Object? value) => value?.toString() ?? '';

int? _nullableInt(Object? value) {
  if (value == null) return null;
  final parsed = value is num ? value : num.tryParse('$value');
  if (parsed == null || parsed != parsed.roundToDouble()) return null;
  return parsed.toInt();
}

int _integer(Object? value) => _nullableInt(value) ?? 0;

int _moneyFromRemote(Object? value) {
  final parsed = value is num ? value : num.tryParse('$value');
  if (parsed == null || !parsed.isFinite) return 0;
  return moneyToCents(parsed);
}

bool _bool(Object? value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  return value?.toString().toLowerCase() == 'true';
}

String _remoteId(Map<String, dynamic> row) {
  final id = _string(row['id']).trim();
  if (id.isEmpty) {
    throw LegacyMigrationException('O servidor retornou um registro sem UUID.');
  }
  return id;
}

bool sameInstant(Object? actual, String expected) {
  if (actual == null) return false;
  try {
    return DateTime.parse(actual.toString()).toUtc() ==
        DateTime.parse(expected).toUtc();
  } on FormatException {
    return false;
  }
}

bool sameCalendarDate(Object? actual, String expected) {
  if (actual == null) return false;

  final actualMatch =
      RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(actual.toString());
  final expectedMatch =
      RegExp(r'^(\d{4})-(\d{2})-(\d{2})T').firstMatch(expected);
  if (actualMatch == null || expectedMatch == null) return false;

  try {
    final actualDate = DateTime.utc(
      int.parse(actualMatch.group(1)!),
      int.parse(actualMatch.group(2)!),
      int.parse(actualMatch.group(3)!),
    );
    final expectedDate = DateTime.utc(
      int.parse(expectedMatch.group(1)!),
      int.parse(expectedMatch.group(2)!),
      int.parse(expectedMatch.group(3)!),
    );
    return actualDate.year == int.parse(actualMatch.group(1)!) &&
        actualDate.month == int.parse(actualMatch.group(2)!) &&
        actualDate.day == int.parse(actualMatch.group(3)!) &&
        expectedDate.year == int.parse(expectedMatch.group(1)!) &&
        expectedDate.month == int.parse(expectedMatch.group(2)!) &&
        expectedDate.day == int.parse(expectedMatch.group(3)!) &&
        actualDate == expectedDate;
  } on FormatException {
    return false;
  }
}
