import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:venstoque/models/produto_model.dart';
import 'package:venstoque/models/sync_report.dart';
import 'package:venstoque/models/venda_model.dart';
import 'package:venstoque/providers/sale_provider.dart';
import 'package:venstoque/providers/stock_provider.dart';
import 'package:venstoque/providers/sync_controller.dart';
import 'package:venstoque/screens/dashboard/dashboard_screen.dart';
import 'package:venstoque/services/sync_gateway.dart';
import 'package:venstoque/widgets/sync_status_button.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  testWidgets('mantém providers disponíveis em modais e novas rotas',
      (tester) async {
    final sales = _FakeSaleProvider();
    final stock = _FakeStockProvider();
    final sync = SyncController(_FakeSyncGateway());
    addTearDown(sales.dispose);
    addTearDown(stock.dispose);
    addTearDown(sync.dispose);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SaleProvider>.value(value: sales),
          ChangeNotifierProvider<StockProvider>.value(value: stock),
          ChangeNotifierProvider<SyncController>.value(value: sync),
        ],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );
    await tester.pump();

    await tester.tap(find.byType(SyncStatusButton));
    await tester.pumpAndSettle();

    expect(find.text('Sincronizar agora'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.tap(find.byType(ModalBarrier).last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('VER HISTÓRICO DE VENDAS'));
    await tester.pump();
    await tester.tap(find.text('VER HISTÓRICO DE VENDAS'));
    await tester.pumpAndSettle();

    expect(find.text('Histórico de Vendas'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakeSaleProvider extends ChangeNotifier implements SaleProvider {
  @override
  bool get isLoading => false;

  @override
  List<Map<String, dynamic>> get receivables => const [];

  @override
  List<VendaModel> get sales => const [];

  @override
  List<Map<String, dynamic>> get salesHistory => const [];

  @override
  Future<void> loadSales() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeStockProvider extends ChangeNotifier implements StockProvider {
  @override
  List<ProdutoModel> get products => const [];

  @override
  Future<void> loadProducts() async {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSyncGateway implements SyncGateway {
  SyncReport get _report {
    final now = DateTime(2026, 8, 4, 10);
    return SyncReport(
      scope: SyncScope.all,
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
