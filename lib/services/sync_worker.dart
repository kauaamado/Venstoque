import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

import '../models/local/cliente_model.dart';
import '../models/local/item_venda_model.dart';
import '../models/local/parcela_model.dart';
import '../models/local/produto_model.dart';
import '../models/local/sync_state_model.dart';
import '../models/local/venda_model.dart';
import 'local_database.dart';

/// Executa operações pesadas do Isar fora do isolate da UI.
/// Apenas strings, inteiros e mapas serializáveis atravessam o isolate.
class SyncWorker {
  const SyncWorker._();

  static Future<SyncWorkerResult> migrateAndPrune({
    required Isar isar,
    required String tenantId,
    required DateTime cutoff,
  }) async {
    final directory = isar.directory;
    if (directory == null) {
      throw StateError('O Isar precisa de um diretório nativo para o worker.');
    }

    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(
      _entrypoint,
      <String, dynamic>{
        'sendPort': receivePort.sendPort,
        'directory': directory,
        'tenantId': tenantId,
        'cutoff': cutoff.toIso8601String(),
      },
    );

    try {
      final message = await receivePort.first as Map<Object?, Object?>;
      if (message['ok'] != true) {
        throw StateError(message['error']?.toString() ?? 'Falha no worker.');
      }
      return SyncWorkerResult(
        migratedMutations: (message['migratedMutations'] as num?)?.toInt() ?? 0,
        prunedSales: (message['prunedSales'] as num?)?.toInt() ?? 0,
      );
    } finally {
      receivePort.close();
      isolate.kill(priority: Isolate.immediate);
    }
  }

  static Future<void> _entrypoint(Map<Object?, Object?> args) async {
    final sendPort = args['sendPort']! as SendPort;
    Isar? workerIsar;
    try {
      workerIsar = await Isar.open(
        LocalDatabase.schemas,
        directory: args['directory']! as String,
        name: 'venstoque',
      );
      final tenantId = args['tenantId']! as String;
      final cutoff = DateTime.parse(args['cutoff']! as String);
      final migrated = await _migrateV1(workerIsar, tenantId);
      final pruned = await _pruneOldSales(workerIsar, tenantId, cutoff);
      sendPort.send(<String, dynamic>{
        'ok': true,
        'migratedMutations': migrated,
        'prunedSales': pruned,
      });
    } catch (error, stackTrace) {
      sendPort.send(<String, dynamic>{
        'ok': false,
        'error': '$error',
        'stack': '$stackTrace',
      });
    } finally {
      await workerIsar?.close();
    }
  }

  static Future<int> _migrateV1(Isar isar, String tenantId) async {
    final state = await isar.syncStateLocals
        .filter()
        .tenantIdEqualTo(tenantId)
        .findFirst();
    if (state?.v1Migrated == true) return 0;

    var created = 0;
    final sales =
        await isar.vendaLocals.filter().empresaIdEqualTo(tenantId).findAll();
    for (final sale in sales) {
      await sale.cliente.load();
      sale
        ..clienteLocalId =
            sale.cliente.value?.id.toString() ?? sale.clienteLocalId
        ..rowVersion = sale.supabaseId == null
            ? sale.rowVersion
            : (sale.rowVersion == 0 ? 1 : sale.rowVersion);
    }
    final items = await isar.itemVendaLocals
        .filter()
        .empresaIdEqualTo(tenantId)
        .findAll();
    for (final item in items) {
      await item.venda.load();
      await item.produto.load();
      item
        ..vendaLocalId = item.venda.value?.id ?? item.vendaLocalId
        ..produtoLocalId = item.produto.value?.id ?? item.produtoLocalId
        ..rowVersion = item.supabaseId == null
            ? item.rowVersion
            : (item.rowVersion == 0 ? 1 : item.rowVersion);
    }
    final installments =
        await isar.parcelaLocals.filter().empresaIdEqualTo(tenantId).findAll();
    for (final installment in installments) {
      await installment.venda.load();
      installment
        ..vendaLocalId = installment.venda.value?.id ?? installment.vendaLocalId
        ..rowVersion = installment.supabaseId == null
            ? installment.rowVersion
            : (installment.rowVersion == 0 ? 1 : installment.rowVersion);
    }
    await isar.writeTxn(() async {
      final currentState = state ?? (SyncStateLocal()..tenantId = tenantId);
      currentState
        ..bootstrapPhase = currentState.bootstrapPhase == 'idle'
            ? 'pending'
            : currentState.bootstrapPhase
        ..v1Migrated = true;
      await isar.syncStateLocals.put(currentState);

      final clients = await isar.clienteLocals
          .filter()
          .empresaIdEqualTo(tenantId)
          .findAll();
      for (final client in clients) {
        if (client.supabaseId != null && client.rowVersion == 0) {
          client.rowVersion = 1;
          await isar.clienteLocals.put(client);
        }
        if (!client.syncPending &&
            !client.pendingDelete &&
            client.supabaseId != null) {
          continue;
        }
        final operation = _operationId('clientes', client.id);
        if (await _hasMutation(isar, tenantId, operation)) continue;
        await isar.syncMutationLocals.put(_mutation(
          tenantId: tenantId,
          operationId: operation,
          entity: 'clientes',
          operation: client.pendingDelete
              ? 'delete'
              : (client.supabaseId == null ? 'insert' : 'update'),
          localId: client.id,
          remoteId: client.supabaseId,
          baseRowVersion: client.rowVersion == 0 ? null : client.rowVersion,
          payload: <String, dynamic>{
            'nome': client.nome,
            'celular': client.celular,
            'referencia': client.referencia,
            'observacoes': client.observacoes,
            'ativo': client.ativo,
            'legacy_id': client.legacyId,
          },
        ));
        created++;
      }

      final products = await isar.produtoLocals
          .filter()
          .empresaIdEqualTo(tenantId)
          .findAll();
      for (final product in products) {
        if (product.supabaseId != null && product.rowVersion == 0) {
          product.rowVersion = 1;
          await isar.produtoLocals.put(product);
        }
        if (!product.syncPending &&
            !product.pendingDelete &&
            product.supabaseId != null) {
          continue;
        }
        final operation = _operationId('produtos', product.id);
        if (await _hasMutation(isar, tenantId, operation)) continue;
        await isar.syncMutationLocals.put(_mutation(
          tenantId: tenantId,
          operationId: operation,
          entity: 'produtos',
          operation: product.pendingDelete
              ? 'delete'
              : (product.supabaseId == null ? 'insert' : 'update'),
          localId: product.id,
          remoteId: product.supabaseId,
          baseRowVersion: product.rowVersion == 0 ? null : product.rowVersion,
          payload: <String, dynamic>{
            'nome': product.nome,
            'categoria': product.categoria,
            'fornecedor': product.fornecedor,
            'preco_custo': product.precoCusto,
            'valor_venda': product.valorVenda,
            'quantidade_estoque': product.quantidadeEstoque,
            'ativo': product.ativo,
          },
        ));
        created++;
      }
      if (sales.isNotEmpty) await isar.vendaLocals.putAll(sales);
      if (items.isNotEmpty) await isar.itemVendaLocals.putAll(items);
      if (installments.isNotEmpty) {
        await isar.parcelaLocals.putAll(installments);
      }
    });
    return created;
  }

  static Future<int> _pruneOldSales(
    Isar isar,
    String tenantId,
    DateTime cutoff,
  ) async {
    final candidates = await isar.vendaLocals
        .filter()
        .empresaIdEqualTo(tenantId)
        .dataVendaLessThan(cutoff)
        .supabaseIdIsNotNull()
        .syncPendingEqualTo(false)
        .findAll();
    final removable = <VendaLocal>[];
    for (final sale in candidates) {
      final installments = await isar.parcelaLocals
          .filter()
          .empresaIdEqualTo(tenantId)
          .vendaLocalIdEqualTo(sale.id)
          .findAll();
      final hasPending = installments.any(
        (item) => item.status != 'pago' || item.syncPending,
      );
      if (!hasPending) removable.add(sale);
    }
    if (removable.isEmpty) return 0;

    await isar.writeTxn(() async {
      for (final sale in removable) {
        await isar.itemVendaLocals
            .filter()
            .empresaIdEqualTo(tenantId)
            .vendaLocalIdEqualTo(sale.id)
            .deleteAll();
        await isar.parcelaLocals
            .filter()
            .empresaIdEqualTo(tenantId)
            .vendaLocalIdEqualTo(sale.id)
            .deleteAll();
        await isar.vendaLocals.delete(sale.id);
      }
    });
    return removable.length;
  }

  static Future<bool> _hasMutation(
    Isar isar,
    String tenantId,
    String operationId,
  ) async {
    return (await isar.syncMutationLocals
            .filter()
            .tenantIdEqualTo(tenantId)
            .operationIdEqualTo(operationId)
            .count()) >
        0;
  }

  static SyncMutationLocal _mutation({
    required String tenantId,
    required String operationId,
    required String entity,
    required String operation,
    required int localId,
    required String? remoteId,
    required int? baseRowVersion,
    required Map<String, dynamic> payload,
  }) {
    return SyncMutationLocal()
      ..tenantId = tenantId
      ..operationId = operationId
      ..entity = entity
      ..operation = operation
      ..localId = localId
      ..remoteId = remoteId
      ..baseRowVersion = baseRowVersion
      ..payloadJson = jsonEncode(payload);
  }

  static String _operationId(String entity, int localId) =>
      const Uuid().v5(Namespace.url.value, 'venstoque-v1:$entity:$localId');
}

class SyncWorkerResult {
  const SyncWorkerResult({
    required this.migratedMutations,
    required this.prunedSales,
  });

  final int migratedMutations;
  final int prunedSales;
}
