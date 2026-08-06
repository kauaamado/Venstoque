import 'dart:convert';

import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

import '../models/local/cliente_model.dart';
import '../models/local/produto_model.dart';
import '../models/local/sync_state_model.dart';

class SyncMutationQueue {
  const SyncMutationQueue._();

  static Future<void> queueCliente(
    Isar isar,
    String tenantId,
    ClienteLocal cliente, {
    String? operation,
  }) async {
    await _queue(
      isar: isar,
      tenantId: tenantId,
      entity: 'clientes',
      localId: cliente.id,
      remoteId: cliente.supabaseId,
      operation: operation ??
          (cliente.supabaseId == null
              ? 'insert'
              : (cliente.pendingDelete ? 'delete' : 'update')),
      baseRowVersion: cliente.rowVersion == 0 ? null : cliente.rowVersion,
      payload: <String, dynamic>{
        'nome': cliente.nome,
        'celular': cliente.celular,
        'referencia': cliente.referencia,
        'observacoes': cliente.observacoes,
        'ativo': cliente.ativo,
        'legacy_id': cliente.legacyId,
      },
    );
  }

  static Future<void> queueProduto(
    Isar isar,
    String tenantId,
    ProdutoLocal produto, {
    bool includeStock = true,
    String? operation,
  }) async {
    final payload = <String, dynamic>{
      'nome': produto.nome,
      'categoria': produto.categoria,
      'fornecedor': produto.fornecedor,
      'preco_custo': produto.precoCusto,
      'valor_venda': produto.valorVenda,
      'ativo': produto.ativo,
    };
    if (includeStock) payload['quantidade_estoque'] = produto.quantidadeEstoque;
    await _queue(
      isar: isar,
      tenantId: tenantId,
      entity: 'produtos',
      localId: produto.id,
      remoteId: produto.supabaseId,
      operation: operation ??
          (produto.supabaseId == null
              ? 'insert'
              : (produto.pendingDelete ? 'delete' : 'update')),
      baseRowVersion: produto.rowVersion == 0 ? null : produto.rowVersion,
      payload: payload,
    );
  }

  static Future<void> queueEstoqueDelta({
    required Isar isar,
    required String tenantId,
    required ProdutoLocal produto,
    required int delta,
  }) async {
    if (delta == 0 || produto.supabaseId == null) return;
    final operationId = const Uuid().v4();
    final mutation = SyncMutationLocal()
      ..tenantId = tenantId
      ..operationId = operationId
      ..entity = 'estoque'
      ..operation = 'delta'
      ..localId = produto.id
      ..remoteId = produto.supabaseId
      ..payloadJson = jsonEncode(<String, dynamic>{
        'produto_id': produto.supabaseId,
        'quantidade_delta': delta,
      });
    await isar.syncMutationLocals.put(mutation);
  }

  static Future<void> _queue({
    required Isar isar,
    required String tenantId,
    required String entity,
    required int localId,
    required String? remoteId,
    required String operation,
    required int? baseRowVersion,
    required Map<String, dynamic> payload,
  }) async {
    final existing = await isar.syncMutationLocals
        .filter()
        .tenantIdEqualTo(tenantId)
        .entityEqualTo(entity)
        .localIdEqualTo(localId)
        .stateEqualTo('queued')
        .findFirst();
    if (existing != null && existing.operation == 'insert') {
      existing
        ..remoteId = remoteId
        ..payloadJson = jsonEncode(payload)
        ..baseRowVersion = baseRowVersion;
      await isar.syncMutationLocals.put(existing);
      return;
    }

    final mutation = SyncMutationLocal()
      ..tenantId = tenantId
      ..operationId = const Uuid().v4()
      ..entity = entity
      ..operation = operation
      ..localId = localId
      ..remoteId = remoteId
      ..baseRowVersion = baseRowVersion
      ..payloadJson = jsonEncode(payload);
    await isar.syncMutationLocals.put(mutation);
  }
}
