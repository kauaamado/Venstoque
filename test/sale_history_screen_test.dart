import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:venstoque/models/sync_report.dart';
import 'package:venstoque/providers/sale_provider.dart';
import 'package:venstoque/providers/sync_controller.dart';
import 'package:venstoque/screens/sales/sale_history_screen.dart';
import 'package:venstoque/services/sync_gateway.dart';
import 'package:venstoque/utils/formatters.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  testWidgets('exibe total, lucro e valor pendente por mês', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final sales = _FakeSaleProvider();
    final sync = SyncController(_FakeSyncGateway());
    addTearDown(sales.dispose);
    addTearDown(sync.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SaleProvider>.value(value: sales),
          ChangeNotifierProvider<SyncController>.value(value: sync),
        ],
        child: const MaterialApp(home: SalesHistoryScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Total: ${AppFormatters.formatCurrency(100)}'),
      findsOneWidget,
    );
    expect(
      find.text('Lucro: ${AppFormatters.formatCurrency(50)}'),
      findsOneWidget,
    );
    expect(
      find.text('Pendente: ${AppFormatters.formatCurrency(80)}'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}

class _FakeSaleProvider extends ChangeNotifier implements SaleProvider {
  @override
  bool get isLoading => false;

  @override
  List<Map<String, dynamic>> get salesHistory => [
        {
          'data_venda': DateTime(2026, 8, 10).toIso8601String(),
          'valor_total': 100.0,
          'tipo_pagamento': 'parcelado',
          'clientes': {'nome': 'Cliente'},
          'itens_venda': [
            {
              'quantidade': 1,
              'custo_unitario': 50.0,
              'produtos': {'nome': 'Produto'},
            },
          ],
          'parcelas': [
            {
              'numero_parcela': 1,
              'valor': 80.0,
              'data_vencimento': DateTime(2026, 9, 10).toIso8601String(),
              'status': 'pendente',
            },
            {
              'numero_parcela': 2,
              'valor': 20.0,
              'data_vencimento': DateTime(2026, 9, 20).toIso8601String(),
              'status': 'pago',
            },
          ],
        },
      ];

  @override
  Future<void> loadSales() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSyncGateway implements SyncGateway {
  SyncReport get _report {
    final now = DateTime(2026, 8, 6);
    return SyncReport(
      scope: SyncScope.sales,
      startedAt: now,
      completedAt: now,
      pushed: 0,
      received: 0,
      saved: 0,
      deferred: 0,
      issues: const [],
    );
  }

  @override
  Future<SyncReport> syncAll() async => _report;

  @override
  Future<SyncReport> syncCustomersFromServer() async => _report;

  @override
  Future<SyncReport> syncProductsFromServer() async => _report;

  @override
  Future<SyncReport> syncSalesFromServer() async => _report;
}
