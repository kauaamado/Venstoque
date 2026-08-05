import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:venstoque/models/sync_report.dart';
import 'package:venstoque/providers/sync_controller.dart';
import 'package:venstoque/services/sync_gateway.dart';
import 'package:venstoque/widgets/sync_status_button.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  testWidgets('abre os detalhes e permite sincronização manual',
      (tester) async {
    final gateway = _FakeGateway();
    final controller = SyncController(gateway);
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(actions: const [SyncStatusButton()]),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(SyncStatusButton));
    await tester.pumpAndSettle();
    expect(find.text('Sincronizar agora'), findsOneWidget);

    await tester.tap(find.text('Sincronizar agora'));
    await tester.pumpAndSettle();

    expect(gateway.calls, 1);
    expect(find.text('Dados sincronizados'), findsOneWidget);
    controller.dispose();
  });
}

class _FakeGateway implements SyncGateway {
  int calls = 0;

  SyncReport get _report {
    final now = DateTime(2026, 8, 4, 10);
    return SyncReport(
      scope: SyncScope.all,
      startedAt: now,
      completedAt: now,
      pushed: 1,
      received: 2,
      saved: 2,
      deferred: 0,
      issues: const [],
    );
  }

  @override
  Future<SyncReport> syncAll() async {
    calls++;
    return _report;
  }

  @override
  Future<SyncReport> syncCustomersFromServer() async => _report;

  @override
  Future<SyncReport> syncProductsFromServer() async => _report;

  @override
  Future<SyncReport> syncSalesFromServer() async => _report;
}
