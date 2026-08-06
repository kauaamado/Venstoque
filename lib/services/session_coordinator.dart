import 'package:isar_community/isar.dart';

import '../models/local/cliente_model.dart';
import '../models/local/item_venda_model.dart';
import '../models/local/parcela_model.dart';
import '../models/local/produto_model.dart';
import '../models/local/sync_state_model.dart';
import '../models/local/venda_model.dart';
import '../providers/auth_controller.dart';
import '../services/sync_gateway.dart';

enum LogoutResult { signedOut, needsConfirmation, failed }

class SessionCoordinator {
  SessionCoordinator({
    required Isar isar,
    required String tenantId,
    required SyncGateway syncGateway,
    required AuthController authController,
  })  : _isar = isar,
        _tenantId = tenantId,
        _syncGateway = syncGateway,
        _authController = authController;

  final Isar _isar;
  final String _tenantId;
  final SyncGateway _syncGateway;
  final AuthController _authController;

  Future<LogoutResult> signOut({bool force = false}) async {
    if (!force) {
      var pending = await _pendingCount();
      if (pending > 0) {
        try {
          await _syncGateway.syncAll();
        } catch (_) {
          // O SyncService registra a falha; a decisão continua protegida.
        }
        pending = await _pendingCount();
        if (pending > 0) return LogoutResult.needsConfirmation;
      }
    }

    try {
      await _clearTenantData();
      final signedOut = await _authController.signOut();
      return signedOut ? LogoutResult.signedOut : LogoutResult.failed;
    } catch (_) {
      return LogoutResult.failed;
    }
  }

  Future<int> _pendingCount() async {
    final mutations = await _isar.syncMutationLocals
        .filter()
        .tenantIdEqualTo(_tenantId)
        .findAll();
    return mutations.where((mutation) => mutation.state != 'completed').length;
  }

  Future<void> _clearTenantData() async {
    await _isar.writeTxn(() async {
      await _isar.itemVendaLocals
          .filter()
          .empresaIdEqualTo(_tenantId)
          .deleteAll();
      await _isar.parcelaLocals
          .filter()
          .empresaIdEqualTo(_tenantId)
          .deleteAll();
      await _isar.vendaLocals.filter().empresaIdEqualTo(_tenantId).deleteAll();
      await _isar.produtoLocals
          .filter()
          .empresaIdEqualTo(_tenantId)
          .deleteAll();
      await _isar.clienteLocals
          .filter()
          .empresaIdEqualTo(_tenantId)
          .deleteAll();
      await _isar.syncMutationLocals
          .filter()
          .tenantIdEqualTo(_tenantId)
          .deleteAll();
      await _isar.syncConflictLocals
          .filter()
          .tenantIdEqualTo(_tenantId)
          .deleteAll();
      await _isar.syncStateLocals
          .filter()
          .tenantIdEqualTo(_tenantId)
          .deleteAll();
    });
  }
}
