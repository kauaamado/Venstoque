import 'dart:async';

import 'package:flutter/widgets.dart';

import '../models/sync_report.dart';
import '../services/sync_gateway.dart';

enum SyncStatus { idle, syncing, success, partialFailure, offline }

class SyncController extends ChangeNotifier with WidgetsBindingObserver {
  SyncController(
    this._gateway, {
    Duration resumeInterval = const Duration(seconds: 60),
    DateTime Function()? clock,
    void Function(VoidCallback callback)? scheduleAfterFrame,
  })  : _resumeInterval = resumeInterval,
        _clock = clock ?? DateTime.now,
        _scheduleAfterFrame = scheduleAfterFrame ?? _onNextFrame;

  final SyncGateway _gateway;
  final Duration _resumeInterval;
  final DateTime Function() _clock;
  final void Function(VoidCallback callback) _scheduleAfterFrame;

  SyncStatus _status = SyncStatus.idle;
  SyncReport? _lastReport;
  Future<SyncReport>? _activeSync;
  DateTime? _lastAttemptAt;
  bool _started = false;
  bool _disposed = false;

  SyncStatus get status => _status;
  SyncReport? get lastReport => _lastReport;
  bool get isSyncing => _status == SyncStatus.syncing;

  void start() {
    if (_started || _disposed) return;
    _started = true;
    WidgetsBinding.instance.addObserver(this);
    _scheduleAfterFrame(() {
      if (!_disposed) unawaited(syncNow());
    });
  }

  Future<SyncReport> syncNow() => _run(_gateway.syncAll);

  Future<SyncReport> refreshCustomers() =>
      _run(_gateway.syncCustomersFromServer);

  Future<SyncReport> refreshProducts() => _run(_gateway.syncProductsFromServer);

  Future<SyncReport> refreshSales() => _run(_gateway.syncSalesFromServer);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed || _disposed) return;
    final lastAttemptAt = _lastAttemptAt;
    if (lastAttemptAt != null &&
        _clock().difference(lastAttemptAt) < _resumeInterval) {
      return;
    }
    unawaited(syncNow());
  }

  Future<SyncReport> _run(Future<SyncReport> Function() operation) {
    final activeSync = _activeSync;
    if (activeSync != null) return activeSync;

    _lastAttemptAt = _clock();
    _status = SyncStatus.syncing;
    _notifyListeners();

    late final Future<SyncReport> currentSync;
    currentSync = _execute(operation).whenComplete(() {
      if (identical(_activeSync, currentSync)) _activeSync = null;
    });
    _activeSync = currentSync;
    return currentSync;
  }

  Future<SyncReport> _execute(
    Future<SyncReport> Function() operation,
  ) async {
    try {
      final report = await operation();
      if (_disposed) return report;
      _lastReport = report;
      _status = switch (report.outcome) {
        SyncOutcome.success => SyncStatus.success,
        SyncOutcome.partialFailure => SyncStatus.partialFailure,
        SyncOutcome.offline => SyncStatus.offline,
      };
      return report;
    } catch (error, stackTrace) {
      debugPrint('Falha inesperada no controlador de sincronização: $error');
      debugPrintStack(stackTrace: stackTrace);
      final now = _clock();
      final report = SyncReport(
        scope: SyncScope.all,
        startedAt: _lastAttemptAt ?? now,
        completedAt: now,
        pushed: 0,
        received: 0,
        saved: 0,
        deferred: 0,
        issues: const [
          SyncIssue(
            operation: 'sincronização',
            message: 'Não foi possível concluir a sincronização.',
            isNetworkError: false,
          ),
        ],
      );
      if (!_disposed) {
        _lastReport = report;
        _status = SyncStatus.partialFailure;
      }
      return report;
    } finally {
      _notifyListeners();
    }
  }

  void _notifyListeners() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}

void _onNextFrame(VoidCallback callback) {
  WidgetsBinding.instance.addPostFrameCallback((_) => callback());
}
