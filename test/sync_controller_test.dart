import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:venstoque/models/sync_report.dart';
import 'package:venstoque/providers/sync_controller.dart';
import 'package:venstoque/services/sync_gateway.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('construir o controller não inicia sincronização automática', () {
    final gateway = _FakeSyncGateway();
    final controller = SyncController(gateway);

    expect(gateway.allCalls, 0);
    controller.dispose();
  });

  test('publica sucesso e compartilha uma execução concorrente', () async {
    final gateway = _FakeSyncGateway()..holdNextRun();
    final controller = SyncController(gateway);

    final first = controller.syncNow();
    final second = controller.syncNow();

    expect(identical(first, second), isTrue);
    expect(controller.status, SyncStatus.syncing);
    expect(gateway.allCalls, 1);

    gateway.completeHeldRun(_report());
    final result = await first;

    expect(result.outcome, SyncOutcome.success);
    expect(controller.status, SyncStatus.success);
    expect(controller.lastReport, same(result));
    controller.dispose();
  });

  test('enfileira escopos diferentes e executa o segundo após o primeiro',
      () async {
    final gateway = _ScopedFakeSyncGateway();
    final controller = SyncController(gateway);

    final customers = controller.refreshCustomers();
    final products = controller.refreshProducts();

    expect(gateway.customerCalls, 1);
    expect(gateway.productCalls, 0);

    gateway.customerCompleter.complete(_report());
    await customers;
    expect(gateway.productCalls, 1);

    gateway.productCompleter.complete(_report());
    await products;
    controller.dispose();
  });

  test('classifica execução com falhas de rede como offline', () async {
    final gateway = _FakeSyncGateway(
      nextReport: _report(
        issues: const [
          SyncIssue(
            operation: 'pull clientes',
            message: 'Sem conexão com o servidor.',
            isNetworkError: true,
          ),
        ],
      ),
    );
    final controller = SyncController(gateway);

    await controller.syncNow();

    expect(controller.status, SyncStatus.offline);
    controller.dispose();
  });

  test('classifica registros adiados como sincronização parcial', () async {
    final gateway = _FakeSyncGateway(nextReport: _report(deferred: 1));
    final controller = SyncController(gateway);

    await controller.syncNow();

    expect(controller.status, SyncStatus.partialFailure);
    controller.dispose();
  });

  testWidgets('inicia no primeiro frame e respeita intervalo no retorno',
      (tester) async {
    var now = DateTime(2026, 8, 4, 10);
    final gateway = _FakeSyncGateway();
    final controller = SyncController(
      gateway,
      clock: () => now,
      scheduleAfterFrame: (callback) => callback(),
    )..start();

    await tester.pump();
    await tester.pump();
    expect(gateway.allCalls, 1);

    controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump();
    expect(gateway.allCalls, 1);

    now = now.add(const Duration(seconds: 61));
    controller.didChangeAppLifecycleState(AppLifecycleState.resumed);
    await tester.pump();
    expect(gateway.allCalls, 2);
    controller.dispose();
  });
}

SyncReport _report({
  List<SyncIssue> issues = const [],
  int deferred = 0,
}) {
  final now = DateTime(2026, 8, 4, 10);
  return SyncReport(
    scope: SyncScope.all,
    startedAt: now,
    completedAt: now,
    pushed: 0,
    received: 0,
    saved: 0,
    deferred: deferred,
    issues: issues,
  );
}

class _FakeSyncGateway implements SyncGateway {
  _FakeSyncGateway({SyncReport? nextReport})
      : nextReport = nextReport ?? _report();

  SyncReport nextReport;
  int allCalls = 0;
  Completer<SyncReport>? _heldRun;

  void holdNextRun() => _heldRun = Completer<SyncReport>();

  void completeHeldRun(SyncReport report) => _heldRun?.complete(report);

  @override
  Future<SyncReport> syncAll() {
    allCalls++;
    return _heldRun?.future ?? Future.value(nextReport);
  }

  @override
  Future<SyncReport> syncCustomersFromServer() => Future.value(nextReport);

  @override
  Future<SyncReport> syncProductsFromServer() => Future.value(nextReport);

  @override
  Future<SyncReport> syncSalesFromServer() => Future.value(nextReport);
}

class _ScopedFakeSyncGateway implements SyncGateway {
  final customerCompleter = Completer<SyncReport>();
  final productCompleter = Completer<SyncReport>();
  int customerCalls = 0;
  int productCalls = 0;

  @override
  Future<SyncReport> syncAll() => Future.value(_report());

  @override
  Future<SyncReport> syncCustomersFromServer() {
    customerCalls++;
    return customerCompleter.future;
  }

  @override
  Future<SyncReport> syncProductsFromServer() {
    productCalls++;
    return productCompleter.future;
  }

  @override
  Future<SyncReport> syncSalesFromServer() => Future.value(_report());
}
