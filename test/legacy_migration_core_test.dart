import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../tool/legacy_migration_core.dart';

void main() {
  const empresaId = '00000000-0000-4000-8000-000000000001';

  test('converte valores por centavos e gera data explícita de Brasília', () {
    expect(moneyToCents(0.1 + 0.2), 30);
    expect(centsToDouble(3155040), 31550.4);
    expect(
      brasiliaIsoFromEpochMillis(
          DateTime.utc(2026, 8, 1, 2).millisecondsSinceEpoch),
      '2026-07-31T23:00:00.000-03:00',
    );
    expect(
      brasiliaIsoFromEpochMillis(
        DateTime.utc(2026, 8, 1, 2).millisecondsSinceEpoch,
        addDays: 30,
      ),
      '2026-08-30T23:00:00.000-03:00',
    );
  });

  group('comparação de datas civis', () {
    const expected = '2026-08-31T23:00:00.000-03:00';

    test('aceita o mesmo dia preservando o deslocamento UTC-3', () {
      expect(sameCalendarDate('2026-08-31', expected), isTrue);
    });

    test('rejeita uma data adjacente', () {
      expect(sameCalendarDate('2026-09-01', expected), isFalse);
    });

    test('rejeita valor remoto inválido ou ausente', () {
      expect(sameCalendarDate('31/08/2026', expected), isFalse);
      expect(sameCalendarDate('2026-02-30', expected), isFalse);
      expect(sameCalendarDate(null, expected), isFalse);
    });
  });

  test('comparação de data_venda continua sendo por instante', () {
    expect(
      sameInstant(
        '2026-09-01T02:00:00.000Z',
        '2026-08-31T23:00:00.000-03:00',
      ),
      isTrue,
    );
    expect(
      sameInstant(
        '2026-08-31T23:00:00.000Z',
        '2026-08-31T23:00:00.000-03:00',
      ),
      isFalse,
    );
  });

  test('preserva vendas sem identidade em um único Consumidor Final', () {
    final plan = buildLegacyMigrationPlan(_source());

    final consumer = plan.clientes.singleWhere(
      (cliente) => cliente.nome == legacyMigrationConsumerName,
    );
    expect(consumer.legacyId, 0);
    expect(plan.clientes, hasLength(3));

    final consumerSales = plan.vendas
        .where((venda) => venda.clienteLegacyId == consumer.legacyId)
        .map((venda) => venda.legacyId)
        .toSet();
    expect(consumerSales, {180, 464});
    expect(plan.parcelas, hasLength(3));
    expect(
      plan.parcelas
          .singleWhere((parcela) => parcela.vendaLegacyId == 464)
          .valorCentavos,
      500,
    );
  });

  test('dry-run não grava registros', () async {
    final gateway = _FakeGateway();
    final report = await LegacyMigrationRunner(gateway).run(
      plan: buildLegacyMigrationPlan(_source()),
      empresaId: empresaId,
      apply: false,
    );

    expect(report.dryRun, isTrue);
    expect(report.expected['vendas'], 4);
    expect(gateway.totalInsertCalls, 0);
  });

  test('divide inserções em lotes de no máximo 500 registros', () async {
    final clients = List.generate(
      501,
      (index) => LegacyMigrationCliente(
        legacyId: index + 1,
        nome: 'Cliente $index',
        celular: '',
        referencia: '',
        observacoes: '',
      ),
    );
    final gateway = _FakeGateway();
    await LegacyMigrationRunner(gateway).run(
      plan: LegacyMigrationPlan(
        clientes: clients,
        produtos: const [],
        vendas: const [],
        itens: const [],
        parcelas: const [],
        warnings: const [],
      ),
      empresaId: empresaId,
      apply: true,
    );

    expect(gateway.clienteBatchSizes, [500, 1]);
  });

  test('retoma venda existente incluindo item e parcela ausentes', () async {
    final plan = buildLegacyMigrationPlan(_source());
    final gateway = _FakeGateway();
    final originalCustomer = plan.clientes.singleWhere(
      (cliente) => cliente.legacyId == 1,
    );
    final consumer = plan.clientes.singleWhere(
      (cliente) => cliente.legacyId == 0,
    );
    final recovered = plan.clientes.singleWhere(
      (cliente) => cliente.legacyId < 0,
    );
    gateway.clientes = [
      {'id': 'cliente-1', ...originalCustomer.toPayload(empresaId)},
      {'id': 'cliente-0', ...consumer.toPayload(empresaId)},
      {'id': 'cliente-recuperado', ...recovered.toPayload(empresaId)},
    ];
    gateway.produtos = [
      for (final produto in plan.produtos)
        {
          'id': 'produto-${produto.nome.hashCode}',
          ...produto.toPayload(empresaId)
        },
    ];
    gateway.vendas = [
      for (final venda in plan.vendas)
        {
          'id': 'venda-${venda.legacyId}',
          ...venda.toPayload(
            empresaId: empresaId,
            clienteId: venda.clienteLegacyId == 1
                ? 'cliente-1'
                : venda.clienteLegacyId == 0
                    ? 'cliente-0'
                    : 'cliente-recuperado',
          ),
        },
    ];

    final report = await LegacyMigrationRunner(gateway).run(
      plan: plan,
      empresaId: empresaId,
      apply: true,
    );

    expect(report.inserted['clientes'], 0);
    expect(report.inserted['produtos'], 0);
    expect(report.inserted['vendas'], 0);
    expect(report.inserted['itens_venda'], 4);
    expect(report.inserted['parcelas'], 3);
  });

  test('detecta conflito de filho antes de escrever novos registros', () async {
    final plan = buildLegacyMigrationPlan(_source());
    final gateway = _FakeGateway();
    final clientIds = <int, String>{};
    for (final cliente in plan.clientes) {
      final id = 'cliente-${cliente.legacyId}';
      clientIds[cliente.legacyId] = id;
      gateway.clientes.add({'id': id, ...cliente.toPayload(empresaId)});
    }
    final productIds = <String, String>{};
    for (final produto in plan.produtos) {
      final id = 'produto-${produto.nome.hashCode}';
      productIds[produto.identity] = id;
      gateway.produtos.add({'id': id, ...produto.toPayload(empresaId)});
    }
    for (final venda in plan.vendas) {
      gateway.vendas.add({
        'id': 'venda-${venda.legacyId}',
        ...venda.toPayload(
          empresaId: empresaId,
          clienteId: clientIds[venda.clienteLegacyId]!,
        ),
      });
    }
    final item = plan.itens.first;
    gateway.itens.add({
      'id': 'item-conflitante',
      'venda_id': 'venda-${item.vendaLegacyId}',
      'produto_id': productIds[item.produtoIdentity],
      'quantidade': 1,
      'preco_unitario': 999.99,
      'custo_unitario': 0,
    });

    await expectLater(
      LegacyMigrationRunner(gateway).run(
        plan: plan,
        empresaId: empresaId,
        apply: true,
      ),
      throwsA(isA<LegacyMigrationException>()),
    );
    expect(gateway.totalInsertCalls, 0);
  });

  test('informa lotes confirmados quando uma etapa posterior falha', () async {
    final gateway = _FakeGateway()..failOnProducts = true;

    await expectLater(
      LegacyMigrationRunner(gateway).run(
        plan: buildLegacyMigrationPlan(_source()),
        empresaId: empresaId,
        apply: true,
      ),
      throwsA(
        isA<LegacyMigrationExecutionException>().having(
          (error) => error.report.inserted['clientes'],
          'clientes confirmados',
          3,
        ),
      ),
    );
  });

  test('valida os totais do export legado local quando ele está disponível',
      () {
    final file = File('lib/data/db.json');
    if (!file.existsSync()) return;

    final source = Map<String, dynamic>.from(
      jsonDecode(file.readAsStringSync()) as Map,
    );
    final plan = buildLegacyMigrationPlan(source);

    expect(plan.clientes, hasLength(430));
    expect(plan.produtos, hasLength(1437));
    expect(plan.vendas, hasLength(1566));
    expect(plan.itens, hasLength(1566));
    expect(plan.parcelas, hasLength(152));
  });
}

Map<String, dynamic> _source() => {
      'clients': [
        {
          'a': 1,
          'b': '2026-07-28 23:41:01',
          'c': 'Cliente original',
          'd': '(21) 99999-9999',
          'e': 'Observação do cliente',
        },
      ],
      'sales': [
        {
          'q': 1,
          'A': 1,
          'B': 'Cliente original',
          'C': '(21) 99999-9999',
          'v': DateTime.utc(2026, 8, 1, 12).millisecondsSinceEpoch,
          'z': DateTime.utc(2026, 8, 1, 12).millisecondsSinceEpoch,
          'w': 100.0,
          'x': 100.0,
          'D': 0.0,
          'y': 'Produto A',
          'E': '',
        },
        {
          'q': 180,
          'A': 0,
          'B': '',
          'C': '',
          'v': DateTime.utc(2026, 8, 2, 12).millisecondsSinceEpoch,
          'z': DateTime.utc(2026, 8, 2, 12).millisecondsSinceEpoch,
          'w': 10.0,
          'x': 0.0,
          'D': 0.0,
          'y': 'Produto B',
          'E': '',
        },
        {
          'q': 464,
          'A': 0,
          'B': '',
          'C': '',
          'v': DateTime.utc(2026, 8, 3, 12).millisecondsSinceEpoch,
          'z': DateTime.utc(2026, 8, 3, 12).millisecondsSinceEpoch,
          'w': 7.0,
          'x': 2.0,
          'D': 0.0,
          'y': 'Produto B',
          'E': '',
        },
        {
          'q': 600,
          'A': 99,
          'B': 'Cliente recuperado',
          'C': '(21) 98888-7777',
          'v': DateTime.utc(2026, 8, 4, 12).millisecondsSinceEpoch,
          'z': DateTime.utc(2026, 8, 4, 12).millisecondsSinceEpoch,
          'w': 30.0,
          'x': 0.0,
          'D': 0.0,
          'y': 'Produto A',
          'E': '',
        },
      ],
      'products': [],
    };

class _FakeGateway implements LegacyMigrationGateway {
  List<Map<String, dynamic>> clientes = [];
  List<Map<String, dynamic>> produtos = [];
  List<Map<String, dynamic>> vendas = [];
  List<Map<String, dynamic>> itens = [];
  List<Map<String, dynamic>> parcelas = [];
  final List<int> clienteBatchSizes = [];
  int totalInsertCalls = 0;
  bool failOnProducts = false;

  @override
  Future<List<Map<String, dynamic>>> fetchClientes(String empresaId) async =>
      clientes;

  @override
  Future<List<Map<String, dynamic>>> fetchItensVenda(String empresaId) async =>
      itens;

  @override
  Future<List<Map<String, dynamic>>> fetchParcelas(String empresaId) async =>
      parcelas;

  @override
  Future<List<Map<String, dynamic>>> fetchProdutos(String empresaId) async =>
      produtos;

  @override
  Future<List<Map<String, dynamic>>> fetchVendas(String empresaId) async =>
      vendas;

  @override
  Future<List<Map<String, dynamic>>> insertClientes(
    List<Map<String, dynamic>> payload,
  ) async {
    totalInsertCalls++;
    clienteBatchSizes.add(payload.length);
    return [
      for (final row in payload)
        {'id': 'cliente-${row['legacy_id']}', 'legacy_id': row['legacy_id']},
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> insertItensVenda(
    List<Map<String, dynamic>> payload,
  ) async {
    totalInsertCalls++;
    return [
      for (var index = 0; index < payload.length; index++) {'id': 'item-$index'}
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> insertParcelas(
    List<Map<String, dynamic>> payload,
  ) async {
    totalInsertCalls++;
    return [
      for (var index = 0; index < payload.length; index++)
        {'id': 'parcela-$index'}
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> insertProdutos(
    List<Map<String, dynamic>> payload,
  ) async {
    totalInsertCalls++;
    if (failOnProducts) throw StateError('Falha simulada.');
    return [
      for (final row in payload)
        {
          'id': 'produto-${row['nome'].hashCode}',
          'nome': row['nome'],
          'categoria': row['categoria'],
          'fornecedor': row['fornecedor'],
        },
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> insertVendas(
    List<Map<String, dynamic>> payload,
  ) async {
    totalInsertCalls++;
    return [
      for (final row in payload)
        {'id': 'venda-${row['legacy_id']}', 'legacy_id': row['legacy_id']},
    ];
  }
}
