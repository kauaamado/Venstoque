import 'dart:io';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/local/cliente_model.dart';
import '../models/local/item_venda_model.dart';
import '../models/local/parcela_model.dart';
import '../models/local/produto_model.dart';
import '../models/local/venda_model.dart';
import '../models/local/sync_state_model.dart';
import '../models/sync_report.dart';
import '../utils/constants.dart';
import 'sync_gateway.dart';
import 'sync_worker.dart';

class SyncService implements SyncGateway {
  SyncService(this._isar, {required String empresaId})
      : _empresaId = empresaId.trim(),
        _client = Supabase.instance.client {
    if (_empresaId.isEmpty) {
      throw ArgumentError.value(
        empresaId,
        'empresaId',
        'O identificador da empresa não pode ser vazio.',
      );
    }
  }

  final Isar _isar;
  final String _empresaId;
  final SupabaseClient _client;

  Future<RemoteHistoryPage> fetchRemoteHistoryPage({
    required DateTime from,
    required DateTime to,
    DateTime? before,
    String? beforeId,
    int limit = 50,
  }) async {
    if (from.isAfter(to)) {
      throw ArgumentError('O início do intervalo deve ser anterior ao fim.');
    }
    if (to.difference(from).inDays > 90) {
      throw ArgumentError('O intervalo não pode exceder 90 dias.');
    }
    final response = await _client.rpc('sync_history_period_page', params: {
      'p_empresa_id': _empresaId,
      'p_from': _civilDate(from),
      'p_to': _civilDate(to),
      'p_before': before?.toUtc().toIso8601String(),
      'p_before_id': beforeId,
      'p_limit': limit,
    });
    if (response is! List) {
      throw StateError('Resposta inválida do histórico remoto.');
    }
    final records = <RemoteHistoryRecord>[];
    for (final raw in response) {
      if (raw is! Map) continue;
      final row = Map<String, dynamic>.from(raw);
      final id = row['record_id']?.toString();
      final date = DateTime.tryParse(row['data_venda']?.toString() ?? '');
      final snapshot = row['snapshot'];
      if (id == null || date == null || snapshot is! Map) continue;
      records.add(RemoteHistoryRecord(
        id: id,
        date: date,
        snapshot: Map<String, dynamic>.from(snapshot),
      ));
    }
    DateTime? nextBefore;
    String? nextBeforeId;
    if (response.isNotEmpty && response.last is Map) {
      final last = Map<String, dynamic>.from(response.last as Map);
      nextBefore = DateTime.tryParse(last['next_before']?.toString() ?? '');
      nextBeforeId = last['next_before_id']?.toString();
    }
    return RemoteHistoryPage(
      records: records,
      nextBefore: nextBefore,
      nextBeforeId: nextBeforeId,
      hasMore: records.isNotEmpty && nextBefore != null && nextBeforeId != null,
    );
  }

  Future<SyncReport>? _activeSync;
  SyncReportBuilder? _currentReport;

  Future<SyncReport> syncAllToServer() =>
      _runExclusive(SyncScope.all, _pushAll);

  Future<SyncReport> syncAllFromServer() =>
      _runExclusive(SyncScope.all, _pullAll);

  @override
  Future<SyncReport> syncAll() => _runExclusive(SyncScope.all, () async {
        await _pushAll();
        await _pullAll();
      });

  @override
  Future<SyncReport> syncCustomersFromServer() =>
      _runExclusive(SyncScope.customers, () async {
        await _runStageSafely('push clientes', _pushClientes);
        final clientes =
            await _runPullStageSafely('pull clientes', _pullClientes);
        if (clientes != null) await _reconcileClientes(clientes);
      });

  @override
  Future<SyncReport> syncProductsFromServer() =>
      _runExclusive(SyncScope.products, () async {
        await _runStageSafely('push produtos', _pushProdutos);
        final produtos =
            await _runPullStageSafely('pull produtos', _pullProdutos);
        if (produtos != null) await _reconcileProdutos(produtos);
      });

  @override
  Future<SyncReport> syncSalesFromServer() =>
      _runExclusive(SyncScope.sales, () async {
        await _pushAll();
        await _pullSalesGraph();
      });

  Future<void> _pushAll() async {
    await _runStageSafely('push outbox', _pushOutbox);
    // A ordem garante que todos os UUIDs exigidos pelos filhos já existam.
    await _runStageSafely('push clientes', _pushClientes);
    await _runStageSafely('push produtos', _pushProdutos);
    await _runStageSafely('push grafo de vendas', _pushSaleGraphs);
    await _runStageSafely('push vendas', _pushVendas);
    await _runStageSafely('push itens de venda', _pushItensVenda);
    await _runStageSafely('push parcelas', _pushParcelas);
  }

  Future<void> _pushOutbox() async {
    final allMutations = await _isar.syncMutationLocals
        .filter()
        .tenantIdEqualTo(_empresaId)
        .stateEqualTo('queued')
        .sortByCreatedAt()
        .limit(200)
        .findAll();
    if (allMutations.isEmpty) return;
    final stockMutations =
        allMutations.where((mutation) => mutation.entity == 'estoque').toList();
    final mutations = allMutations
        .where(
          (mutation) =>
              mutation.entity != 'estoque' && mutation.entity != 'venda_graph',
        )
        .toList();
    if (mutations.isEmpty) {
      await _pushStockOutbox(stockMutations);
      return;
    }

    final commands = <Map<String, dynamic>>[];
    for (final mutation in mutations) {
      try {
        final payload = jsonDecode(mutation.payloadJson);
        if (payload is! Map<String, dynamic>) {
          throw const FormatException('Payload de sincronização inválido.');
        }
        commands.add(<String, dynamic>{
          'operation_id': mutation.operationId,
          'entity': mutation.entity,
          'operation': mutation.operation,
          'record_id': mutation.remoteId,
          'base_row_version': mutation.baseRowVersion,
          'data': payload,
        });
      } catch (error, stackTrace) {
        await _markMutationNeedsAttention(mutation, '$error');
        _logError('push outbox', mutation.id, error, stackTrace);
      }
    }
    if (commands.isEmpty) {
      await _pushStockOutbox(stockMutations);
      return;
    }

    final response = await _client.rpc('sync_apply_batch', params: {
      'p_empresa_id': _empresaId,
      'p_commands': commands,
    });
    if (response is! List) {
      throw StateError('Resposta inválida do lote de sincronização.');
    }

    final byOperation = <String, Map<String, dynamic>>{
      for (final item in response)
        if (item is Map && item['operation_id'] != null)
          item['operation_id'].toString(): Map<String, dynamic>.from(item),
    };
    for (final mutation in mutations) {
      final result = byOperation[mutation.operationId];
      if (result == null) continue;
      if (result['status'] == 'success') {
        await _completeMutation(mutation, result);
        _recordPushed();
      } else {
        final code = result['code']?.toString();
        final message = result['message']?.toString() ?? 'Comando rejeitado.';
        if (code == '40001') {
          await _recordConflict(mutation, message);
        } else {
          await _markMutationNeedsAttention(mutation, message, code: code);
        }
        _logError('push outbox', mutation.id, message);
      }
    }
    await _pushStockOutbox(stockMutations);
  }

  Future<void> _pushStockOutbox(List<SyncMutationLocal> mutations) async {
    if (mutations.isEmpty) return;
    final commands = <Map<String, dynamic>>[];
    for (final mutation in mutations) {
      try {
        final payload = jsonDecode(mutation.payloadJson);
        if (payload is! Map<String, dynamic>) {
          throw const FormatException('Payload de estoque inválido.');
        }
        commands.add(<String, dynamic>{
          'operation_id': mutation.operationId,
          ...payload,
        });
      } catch (error, stackTrace) {
        await _markMutationNeedsAttention(mutation, '$error');
        _logError('push estoque', mutation.id, error, stackTrace);
      }
    }
    if (commands.isEmpty) return;
    final response = await _client.rpc('sync_apply_stock_batch', params: {
      'p_empresa_id': _empresaId,
      'p_commands': commands,
    });
    if (response is! List) {
      throw StateError('Resposta inválida do lote de estoque.');
    }
    final byOperation = <String, Map<String, dynamic>>{
      for (final item in response)
        if (item is Map && item['operation_id'] != null)
          item['operation_id'].toString(): Map<String, dynamic>.from(item),
    };
    for (final mutation in mutations) {
      final result = byOperation[mutation.operationId];
      if (result == null) continue;
      if (result['status'] == 'success') {
        await _completeMutation(mutation, result);
        _recordPushed();
      } else {
        await _markMutationNeedsAttention(
          mutation,
          result['message']?.toString() ?? 'Movimento rejeitado.',
          code: result['code']?.toString(),
        );
        _logError('push estoque', mutation.id, result['message'] ?? 'erro');
      }
    }
  }

  Future<void> _completeMutation(
    SyncMutationLocal mutation,
    Map<String, dynamic> result,
  ) async {
    final rowVersion = _asInt(result['row_version']);
    final remoteId = result['record_id']?.toString();
    await _isar.writeTxn(() async {
      mutation
        ..state = 'completed'
        ..attemptedAt = DateTime.now()
        ..attemptCount = mutation.attemptCount + 1
        ..lastErrorCode = null
        ..lastErrorMessage = null;
      await _isar.syncMutationLocals.put(mutation);

      if (mutation.entity == 'clientes' && mutation.localId != null) {
        final local = await _isar.clienteLocals.get(mutation.localId!);
        if (local != null) {
          if (mutation.operation == 'delete') {
            await _isar.clienteLocals.delete(local.id);
            return;
          }
          local
            ..supabaseId = remoteId ?? local.supabaseId
            ..rowVersion = rowVersion
            ..syncPending = false
            ..pendingDelete = false;
          await _isar.clienteLocals.put(local);
        }
      } else if (mutation.entity == 'produtos' && mutation.localId != null) {
        final local = await _isar.produtoLocals.get(mutation.localId!);
        if (local != null) {
          if (mutation.operation == 'delete') {
            await _isar.produtoLocals.delete(local.id);
            return;
          }
          local
            ..supabaseId = remoteId ?? local.supabaseId
            ..rowVersion = rowVersion
            ..syncPending = false
            ..pendingDelete = false;
          await _isar.produtoLocals.put(local);
        }
      } else if (mutation.entity == 'parcelas' && mutation.localId != null) {
        final local = await _isar.parcelaLocals.get(mutation.localId!);
        if (local != null) {
          local
            ..rowVersion = rowVersion
            ..syncPending = false;
          await _isar.parcelaLocals.put(local);
        }
      } else if (mutation.entity == 'estoque' && mutation.localId != null) {
        final local = await _isar.produtoLocals.get(mutation.localId!);
        if (local != null) {
          local.rowVersion = rowVersion;
          await _isar.produtoLocals.put(local);
        }
      }
    });
  }

  Future<void> _markMutationNeedsAttention(
    SyncMutationLocal mutation,
    String message, {
    String? code,
  }) async {
    await _isar.writeTxn(() async {
      mutation
        ..state = 'needsAttention'
        ..attemptedAt = DateTime.now()
        ..attemptCount = mutation.attemptCount + 1
        ..lastErrorCode = code
        ..lastErrorMessage = message;
      await _isar.syncMutationLocals.put(mutation);
    });
  }

  Future<void> _recordConflict(
    SyncMutationLocal mutation,
    String message,
  ) async {
    await _isar.writeTxn(() async {
      mutation
        ..state = 'conflict'
        ..attemptedAt = DateTime.now()
        ..attemptCount = mutation.attemptCount + 1
        ..lastErrorCode = '40001'
        ..lastErrorMessage = message;
      await _isar.syncMutationLocals.put(mutation);

      final conflict = SyncConflictLocal()
        ..tenantId = _empresaId
        ..mutationId = mutation.operationId
        ..entity = mutation.entity
        ..localId = mutation.localId
        ..remoteId = mutation.remoteId
        ..localPayloadJson = mutation.payloadJson
        ..remoteSnapshotJson = '{}'
        ..baseRowVersion = mutation.baseRowVersion
        ..createdAt = DateTime.now();
      await _isar.syncConflictLocals.put(conflict);
    });
  }

  Future<void> _pullAll() async {
    final clientes = await _runPullStageSafely('pull clientes', _pullClientes);
    final produtos = await _runPullStageSafely('pull produtos', _pullProdutos);
    final vendas = await _runPullStageSafely('pull vendas', _pullVendas);
    final itens =
        await _runPullStageSafely('pull itens de venda', _pullItensVenda);
    final parcelas = await _runPullStageSafely('pull parcelas', _pullParcelas);

    // A exclusão reversa evita remover pais antes de avaliar seus filhos.
    if (itens != null) {
      await _runStageSafely(
        'reconciliação de itens de venda',
        () => _deleteMissingItens(itens),
      );
    }
    if (parcelas != null) {
      await _runStageSafely(
        'reconciliação de parcelas',
        () => _deleteMissingParcelas(parcelas),
      );
    }
    if (vendas != null) {
      await _runStageSafely(
        'reconciliação de vendas',
        () => _deleteMissingVendas(vendas),
      );
    }
    if (produtos != null) await _reconcileProdutos(produtos);
    if (clientes != null) await _reconcileClientes(clientes);
  }

  Future<void> _pullSalesGraph() async {
    await _runPullStageSafely('pull clientes', _pullClientes);
    await _runPullStageSafely('pull produtos', _pullProdutos);
    final vendas = await _runPullStageSafely('pull vendas', _pullVendas);
    final itens =
        await _runPullStageSafely('pull itens de venda', _pullItensVenda);
    final parcelas = await _runPullStageSafely('pull parcelas', _pullParcelas);

    if (itens != null) {
      await _runStageSafely(
        'reconciliação de itens de venda',
        () => _deleteMissingItens(itens),
      );
    }
    if (parcelas != null) {
      await _runStageSafely(
        'reconciliação de parcelas',
        () => _deleteMissingParcelas(parcelas),
      );
    }
    if (vendas != null) {
      await _runStageSafely(
        'reconciliação de vendas',
        () => _deleteMissingVendas(vendas),
      );
    }
  }

  Future<void> _pushClientes() async {
    final pending =
        await _isar.clienteLocals.where().supabaseIdIsNull().findAll();

    for (final cliente in pending) {
      if (!_canUseTenant(cliente.empresaId)) continue;
      final sentRevision = cliente.syncRevision;

      await _runRecordSafely('push cliente', cliente.id, () async {
        final remoteId = await _insertAndGetId(AppTables.clientes, {
          'empresa_id': _empresaId,
          'nome': cliente.nome,
          'celular': cliente.celular,
          'referencia': cliente.referencia,
          'observacoes': cliente.observacoes,
          'ativo': cliente.ativo,
          'legacy_id': cliente.legacyId,
        });

        final keptLocally = await _markSynced<ClienteLocal>(
          collection: _isar.clienteLocals,
          localId: cliente.id,
          remoteId: remoteId,
          update: (current, id) {
            current.supabaseId = id;
            current.empresaId ??= _empresaId;
            current.syncPending = current.syncRevision != sentRevision;
          },
        );
        if (!keptLocally) {
          await _deleteRemote(AppTables.clientes, remoteId);
        }
        _recordPushed();
      });
    }

    await _pushClienteUpdates();
    await _pushClienteDeletes();
  }

  Future<void> _pushProdutos() async {
    final pending =
        await _isar.produtoLocals.where().supabaseIdIsNull().findAll();

    for (final produto in pending) {
      if (!_canUseTenant(produto.empresaId)) continue;
      final sentRevision = produto.syncRevision;

      await _runRecordSafely('push produto', produto.id, () async {
        final remoteId = await _insertAndGetId(AppTables.produtos, {
          'empresa_id': _empresaId,
          'nome': produto.nome,
          'categoria': produto.categoria,
          'fornecedor': produto.fornecedor,
          'preco_custo': produto.precoCusto,
          'valor_venda': produto.valorVenda,
          'quantidade_estoque': produto.quantidadeEstoque,
          'ativo': produto.ativo,
        });

        final keptLocally = await _markSynced<ProdutoLocal>(
          collection: _isar.produtoLocals,
          localId: produto.id,
          remoteId: remoteId,
          update: (current, id) {
            current.supabaseId = id;
            current.empresaId ??= _empresaId;
            current.syncPending = current.syncRevision != sentRevision;
          },
        );
        if (!keptLocally) {
          await _deleteRemote(AppTables.produtos, remoteId);
        }
        _recordPushed();
      });
    }

    await _pushProdutoUpdates();
    await _pushProdutoDeletes();
  }

  Future<void> _pushVendas() async {
    final pending =
        await _isar.vendaLocals.where().supabaseIdIsNull().findAll();

    for (final venda in pending) {
      if (!_canUseTenant(venda.empresaId)) continue;
      if (venda.syncOperationId != null) {
        _logDeferred('venda', venda.id, 'aguardando o grafo transacional');
        continue;
      }

      await _runRecordSafely('push venda', venda.id, () async {
        await venda.cliente.load();
        final cliente = venda.cliente.value;
        if (cliente == null ||
            !_canUseTenant(cliente.empresaId) ||
            cliente.supabaseId == null) {
          _logDeferred('venda', venda.id, 'cliente ainda não sincronizado');
          return;
        }

        final remoteId = await _insertAndGetId(AppTables.vendas, {
          'empresa_id': _empresaId,
          'cliente_id': cliente.supabaseId,
          'data_venda': venda.dataVenda.toIso8601String(),
          'valor_total': venda.valorTotal,
          'valor_entrada': venda.valorEntrada,
          'desconto': venda.desconto,
          'tipo_pagamento': venda.tipoPagamento,
          'observacoes': venda.observacoes,
          'legacy_id': venda.legacyId,
        });

        await _markSynced<VendaLocal>(
          collection: _isar.vendaLocals,
          localId: venda.id,
          remoteId: remoteId,
          update: (current, id) {
            current.supabaseId = id;
            current.empresaId ??= _empresaId;
          },
        );
        _recordPushed();
      });
    }
  }

  Future<void> _pushSaleGraphs() async {
    final mutations = await _isar.syncMutationLocals
        .filter()
        .tenantIdEqualTo(_empresaId)
        .entityEqualTo('venda_graph')
        .stateEqualTo('queued')
        .sortByCreatedAt()
        .limit(50)
        .findAll();
    for (final mutation in mutations) {
      await _runRecordSafely(
          'push grafo de venda', mutation.localId ?? mutation.id, () async {
        final saleId = mutation.localId;
        if (saleId == null) {
          await _markMutationNeedsAttention(mutation, 'Venda local ausente.');
          return;
        }
        final sale = await _isar.vendaLocals.get(saleId);
        if (sale == null || sale.empresaId != _empresaId) {
          await _markMutationNeedsAttention(mutation, 'Venda local inválida.');
          return;
        }
        await sale.cliente.load();
        final client = sale.cliente.value;
        if (client == null || client.supabaseId == null) {
          _logDeferred('venda', sale.id, 'cliente ainda não sincronizado');
          return;
        }
        final items = await _isar.itemVendaLocals
            .filter()
            .empresaIdEqualTo(_empresaId)
            .vendaLocalIdEqualTo(sale.id)
            .findAll();
        final installments = await _isar.parcelaLocals
            .filter()
            .empresaIdEqualTo(_empresaId)
            .vendaLocalIdEqualTo(sale.id)
            .findAll();
        final itemPayload = <Map<String, dynamic>>[];
        for (final item in items) {
          await item.produto.load();
          final product = item.produto.value;
          if (product?.supabaseId == null) {
            _logDeferred('venda', sale.id, 'produto ainda não sincronizado');
            return;
          }
          itemPayload.add(<String, dynamic>{
            'produto_id': product!.supabaseId,
            'quantidade': item.quantidade,
            'preco_unitario': item.precoUnitario,
            'custo_unitario': item.custoUnitario,
          });
        }
        final parcelPayload = installments
            .map((item) => <String, dynamic>{
                  'numero_parcela': item.numeroParcela,
                  'valor': item.valor,
                  'data_vencimento': _civilDate(item.dataVencimento),
                  'data_pagamento': item.dataPagamento == null
                      ? null
                      : _civilDate(item.dataPagamento!),
                  'status': item.status,
                })
            .toList();
        final response = await _client.rpc('create_sale_graph', params: {
          'p_empresa_id': _empresaId,
          'p_operation_id': mutation.operationId,
          'p_cliente_id': client.supabaseId,
          'p_data_venda': sale.dataVenda.toIso8601String(),
          'p_valor_total': sale.valorTotal,
          'p_valor_entrada': sale.valorEntrada,
          'p_desconto': sale.desconto,
          'p_tipo_pagamento': sale.tipoPagamento,
          'p_observacoes': sale.observacoes,
          'p_legacy_id': sale.legacyId,
          'p_itens': itemPayload,
          'p_parcelas': parcelPayload,
        });
        if (response is! Map) {
          throw StateError('Resposta inválida do grafo de venda.');
        }
        await _completeSaleGraph(mutation, sale, items, installments,
            Map<String, dynamic>.from(response));
        _recordPushed();
      });
    }
  }

  Future<void> _completeSaleGraph(
    SyncMutationLocal mutation,
    VendaLocal sale,
    List<ItemVendaLocal> items,
    List<ParcelaLocal> installments,
    Map<String, dynamic> result,
  ) async {
    final remoteSaleId = result['venda_id']?.toString();
    if (remoteSaleId == null || remoteSaleId.isEmpty) {
      throw StateError('O grafo remoto não retornou o UUID da venda.');
    }
    final remoteItems = <String, Map<String, dynamic>>{
      for (final item in (result['itens'] as List? ?? const <dynamic>[]))
        if (item is Map && item['produto_id'] != null)
          item['produto_id'].toString(): Map<String, dynamic>.from(item),
    };
    final remoteParcels = <int, Map<String, dynamic>>{
      for (final item in (result['parcelas'] as List? ?? const <dynamic>[]))
        if (item is Map && item['numero_parcela'] != null)
          _asInt(item['numero_parcela']): Map<String, dynamic>.from(item),
    };
    final itemRemoteProductIds = <int, String>{};
    for (final item in items) {
      await item.produto.load();
      final productId = item.produto.value?.supabaseId;
      if (productId != null && productId.isNotEmpty) {
        itemRemoteProductIds[item.id] = productId;
      }
    }
    await _isar.writeTxn(() async {
      sale
        ..supabaseId = remoteSaleId
        ..rowVersion = _asInt(result['row_version'], fallback: 1)
        ..syncPending = false;
      await _isar.vendaLocals.put(sale);
      for (final item in items) {
        final productId = itemRemoteProductIds[item.id];
        final remote = productId == null ? null : remoteItems[productId];
        if (remote != null) {
          item
            ..supabaseId = remote['item_id']?.toString()
            ..rowVersion = _asInt(remote['row_version'], fallback: 1);
          await _isar.itemVendaLocals.put(item);
        }
      }
      for (final parcel in installments) {
        final remote = remoteParcels[parcel.numeroParcela];
        if (remote != null) {
          parcel
            ..supabaseId = remote['parcela_id']?.toString()
            ..rowVersion = _asInt(remote['row_version'], fallback: 1)
            ..syncPending = false;
          await _isar.parcelaLocals.put(parcel);
        }
      }
      mutation
        ..state = 'completed'
        ..attemptedAt = DateTime.now()
        ..attemptCount = mutation.attemptCount + 1;
      await _isar.syncMutationLocals.put(mutation);
    });
  }

  Future<void> _pushItensVenda() async {
    final pending =
        await _isar.itemVendaLocals.where().supabaseIdIsNull().findAll();

    for (final item in pending) {
      await _runRecordSafely('push item de venda', item.id, () async {
        await item.venda.load();
        await item.produto.load();
        final venda = item.venda.value;
        final produto = item.produto.value;

        if (venda == null ||
            produto == null ||
            !_canUseTenant(venda.empresaId) ||
            !_canUseTenant(produto.empresaId) ||
            venda.supabaseId == null ||
            produto.supabaseId == null) {
          _logDeferred(
            'item de venda',
            item.id,
            'venda ou produto ainda não sincronizado',
          );
          return;
        }
        if (venda.syncOperationId != null && venda.supabaseId == null) {
          _logDeferred('item de venda', item.id, 'grafo da venda pendente');
          return;
        }

        final remoteId = await _insertAndGetId(AppTables.itensVenda, {
          'venda_id': venda.supabaseId,
          'produto_id': produto.supabaseId,
          'quantidade': item.quantidade,
          'preco_unitario': item.precoUnitario,
          'custo_unitario': item.custoUnitario,
        });

        await _markSynced<ItemVendaLocal>(
          collection: _isar.itemVendaLocals,
          localId: item.id,
          remoteId: remoteId,
          update: (current, id) => current.supabaseId = id,
        );
        _recordPushed();
      });
    }
  }

  Future<void> _pushParcelas() async {
    final pending =
        await _isar.parcelaLocals.where().supabaseIdIsNull().findAll();

    for (final parcela in pending) {
      if (!_canUseTenant(parcela.empresaId)) continue;
      final sentRevision = parcela.syncRevision;

      await _runRecordSafely('push parcela', parcela.id, () async {
        await parcela.venda.load();
        final venda = parcela.venda.value;
        if (venda == null ||
            !_canUseTenant(venda.empresaId) ||
            venda.supabaseId == null) {
          _logDeferred('parcela', parcela.id, 'venda ainda não sincronizada');
          return;
        }
        if (venda.syncOperationId != null && venda.supabaseId == null) {
          _logDeferred('parcela', parcela.id, 'grafo da venda pendente');
          return;
        }

        final remoteId = await _insertAndGetId(AppTables.parcelas, {
          'empresa_id': _empresaId,
          'venda_id': venda.supabaseId,
          'numero_parcela': parcela.numeroParcela,
          'valor': parcela.valor,
          'data_vencimento': parcela.dataVencimento.toIso8601String(),
          'data_pagamento': parcela.dataPagamento?.toIso8601String(),
          'status': parcela.status,
        });

        await _markSynced<ParcelaLocal>(
          collection: _isar.parcelaLocals,
          localId: parcela.id,
          remoteId: remoteId,
          update: (current, id) {
            current.supabaseId = id;
            current.empresaId ??= _empresaId;
            current.syncPending = current.syncRevision != sentRevision;
          },
        );
        _recordPushed();
      });
    }

    await _pushParcelaUpdates();
  }

  Future<void> _pushClienteUpdates() async {
    final clientes = await _isar.clienteLocals.where().findAll();
    for (final cliente in clientes.where(
      (item) =>
          item.supabaseId != null &&
          item.syncPending &&
          !item.pendingDelete &&
          item.empresaId == _empresaId,
    )) {
      final sentRevision = cliente.syncRevision;
      await _runRecordSafely('update cliente', cliente.id, () async {
        await _updateRemote(
          AppTables.clientes,
          cliente.supabaseId!,
          {
            'nome': cliente.nome,
            'celular': cliente.celular,
            'referencia': cliente.referencia,
            'observacoes': cliente.observacoes,
            'ativo': cliente.ativo,
            'legacy_id': cliente.legacyId,
          },
        );
        await _isar.writeTxn(() async {
          final current = await _isar.clienteLocals.get(cliente.id);
          if (current?.supabaseId != cliente.supabaseId) return;
          current!.syncPending = current.syncRevision != sentRevision;
          await _isar.clienteLocals.put(current);
        });
        _recordPushed();
      });
    }
  }

  Future<void> _pushClienteDeletes() async {
    final clientes = await _isar.clienteLocals.where().findAll();
    for (final cliente in clientes.where(
      (item) =>
          item.supabaseId != null &&
          item.pendingDelete &&
          item.empresaId == _empresaId,
    )) {
      await _runRecordSafely('delete cliente', cliente.id, () async {
        await _deleteRemote(AppTables.clientes, cliente.supabaseId!);
        await _isar.writeTxn(
          () => _isar.clienteLocals.delete(cliente.id),
        );
        _recordPushed();
      });
    }
  }

  Future<void> _pushProdutoUpdates() async {
    final produtos = await _isar.produtoLocals.where().findAll();
    for (final produto in produtos.where(
      (item) =>
          item.supabaseId != null &&
          item.syncPending &&
          !item.pendingDelete &&
          item.empresaId == _empresaId,
    )) {
      final sentRevision = produto.syncRevision;
      await _runRecordSafely('update produto', produto.id, () async {
        await _updateRemote(
          AppTables.produtos,
          produto.supabaseId!,
          {
            'nome': produto.nome,
            'categoria': produto.categoria,
            'fornecedor': produto.fornecedor,
            'preco_custo': produto.precoCusto,
            'valor_venda': produto.valorVenda,
            'quantidade_estoque': produto.quantidadeEstoque,
            'ativo': produto.ativo,
          },
        );
        await _isar.writeTxn(() async {
          final current = await _isar.produtoLocals.get(produto.id);
          if (current?.supabaseId != produto.supabaseId) return;
          current!.syncPending = current.syncRevision != sentRevision;
          await _isar.produtoLocals.put(current);
        });
        _recordPushed();
      });
    }
  }

  Future<void> _pushProdutoDeletes() async {
    final produtos = await _isar.produtoLocals.where().findAll();
    for (final produto in produtos.where(
      (item) =>
          item.supabaseId != null &&
          item.pendingDelete &&
          item.empresaId == _empresaId,
    )) {
      await _runRecordSafely('delete produto', produto.id, () async {
        await _deleteRemote(AppTables.produtos, produto.supabaseId!);
        await _isar.writeTxn(
          () => _isar.produtoLocals.delete(produto.id),
        );
        _recordPushed();
      });
    }
  }

  Future<void> _pushParcelaUpdates() async {
    final parcelas = await _isar.parcelaLocals.where().findAll();
    for (final parcela in parcelas.where(
      (item) =>
          item.supabaseId != null &&
          item.syncPending &&
          item.empresaId == _empresaId,
    )) {
      final sentRevision = parcela.syncRevision;
      await _runRecordSafely('update parcela', parcela.id, () async {
        await _updateRemote(
          AppTables.parcelas,
          parcela.supabaseId!,
          {
            'valor': parcela.valor,
            'data_vencimento': parcela.dataVencimento.toIso8601String(),
            'data_pagamento': parcela.dataPagamento?.toIso8601String(),
            'status': parcela.status,
          },
        );
        await _isar.writeTxn(() async {
          final current = await _isar.parcelaLocals.get(parcela.id);
          if (current?.supabaseId != parcela.supabaseId) return;
          current!.syncPending = current.syncRevision != sentRevision;
          await _isar.parcelaLocals.put(current);
        });
        _recordPushed();
      });
    }
  }

  Future<Set<String>?> _pullClientes() async {
    final rows = await _fetchBootstrapRows('clientes');
    if (rows == null) return null;

    final seenIds = <String>{};
    var savedCount = 0;
    final existing = await _isar.clienteLocals
        .filter()
        .empresaIdEqualTo(_empresaId)
        .findAll();
    final byRemoteId = <String, ClienteLocal>{
      for (final item in existing)
        if (item.supabaseId != null) item.supabaseId!: item,
    };
    final toSave = <ClienteLocal>[];
    for (final row in rows) {
      final remoteId = _readRemoteId(row);
      if (remoteId == null) continue;
      seenIds.add(remoteId);
      try {
        final current = byRemoteId[remoteId];
        if (current != null && (current.syncPending || current.pendingDelete)) {
          _logDeferred('cliente', current.id, 'alteração local pendente');
          continue;
        }
        final cliente = current ?? ClienteLocal();
        cliente
          ..supabaseId = remoteId
          ..empresaId = _empresaId
          ..rowVersion = _asInt(row['row_version'], fallback: 1)
          ..nome = _asString(row['nome'])
          ..celular = _asString(row['celular'])
          ..referencia = _asString(row['referencia'])
          ..observacoes = _asString(row['observacoes'])
          ..ativo = _asBool(row['ativo'], fallback: true)
          ..syncPending = false
          ..pendingDelete = false
          ..legacyId = _asNullableInt(row['legacy_id']);
        toSave.add(cliente);
        byRemoteId[remoteId] = cliente;
        savedCount++;
      } catch (error, stackTrace) {
        _logError('pull cliente', remoteId, error, stackTrace);
      }
    }
    if (toSave.isNotEmpty) {
      await _isar.writeTxn(() => _isar.clienteLocals.putAll(toSave));
      _currentReport?.saved += savedCount;
    }
    _logPullSummary('clientes', rows.length, savedCount);
    return seenIds;
  }

  Future<Set<String>?> _pullProdutos() async {
    final rows = await _fetchBootstrapRows('produtos');
    if (rows == null) return null;

    final seenIds = <String>{};
    var savedCount = 0;
    final existing = await _isar.produtoLocals
        .filter()
        .empresaIdEqualTo(_empresaId)
        .findAll();
    final byRemoteId = <String, ProdutoLocal>{
      for (final item in existing)
        if (item.supabaseId != null) item.supabaseId!: item,
    };
    final toSave = <ProdutoLocal>[];
    for (final row in rows) {
      final remoteId = _readRemoteId(row);
      if (remoteId == null) continue;
      seenIds.add(remoteId);
      try {
        final current = byRemoteId[remoteId];
        if (current != null && (current.syncPending || current.pendingDelete)) {
          _logDeferred('produto', current.id, 'alteração local pendente');
          continue;
        }
        final produto = current ?? ProdutoLocal();
        produto
          ..supabaseId = remoteId
          ..empresaId = _empresaId
          ..rowVersion = _asInt(row['row_version'], fallback: 1)
          ..nome = _asString(row['nome'])
          ..categoria = _asString(row['categoria'])
          ..fornecedor = _asString(row['fornecedor'])
          ..precoCusto = _asDouble(row['preco_custo'])
          ..valorVenda = _asDouble(row['valor_venda'])
          ..quantidadeEstoque = _asInt(row['quantidade_estoque'])
          ..ativo = _asBool(row['ativo'], fallback: true)
          ..syncPending = false
          ..pendingDelete = false;
        toSave.add(produto);
        byRemoteId[remoteId] = produto;
        savedCount++;
      } catch (error, stackTrace) {
        _logError('pull produto', remoteId, error, stackTrace);
      }
    }
    if (toSave.isNotEmpty) {
      await _isar.writeTxn(() => _isar.produtoLocals.putAll(toSave));
      _currentReport?.saved += savedCount;
    }
    _logPullSummary('produtos', rows.length, savedCount);
    return seenIds;
  }

  Future<Set<String>?> _pullVendas() async {
    final rows = await _fetchBootstrapRows('vendas');
    if (rows == null) return null;

    final seenIds = <String>{};
    var savedCount = 0;
    final clientes = await _isar.clienteLocals
        .filter()
        .empresaIdEqualTo(_empresaId)
        .findAll();
    final clientesPorUuid = <String, ClienteLocal>{
      for (final item in clientes)
        if (item.supabaseId != null) item.supabaseId!: item,
    };
    final existing =
        await _isar.vendaLocals.filter().empresaIdEqualTo(_empresaId).findAll();
    final vendasPorUuid = <String, VendaLocal>{
      for (final item in existing)
        if (item.supabaseId != null) item.supabaseId!: item,
    };
    final toSave = <VendaLocal>[];
    for (final row in rows) {
      final remoteId = _readRemoteId(row);
      if (remoteId == null) continue;
      seenIds.add(remoteId);
      try {
        final clienteId = _requiredString(row, 'cliente_id');
        final cliente = clientesPorUuid[clienteId];
        if (cliente == null) {
          throw StateError(
              'Cliente remoto da venda não encontrado localmente.');
        }
        final existingSale = vendasPorUuid[remoteId];
        if (existingSale?.syncPending == true) {
          _logDeferred('venda', existingSale!.id, 'alteração local pendente');
          continue;
        }
        final venda = existingSale ?? VendaLocal();
        venda
          ..supabaseId = remoteId
          ..empresaId = _empresaId
          ..clienteLocalId = cliente.id.toString()
          ..rowVersion = _asInt(row['row_version'], fallback: 1)
          ..dataVenda = _requiredDate(row, 'data_venda')
          ..valorTotal = _asDouble(row['valor_total'])
          ..valorEntrada = _asDouble(row['valor_entrada'])
          ..desconto = _asDouble(row['desconto'])
          ..tipoPagamento = _asString(row['tipo_pagamento'])
          ..observacoes = _asString(row['observacoes'])
          ..legacyId = _asNullableInt(row['legacy_id'])
          ..syncPending = false;
        venda.cliente.value = cliente;
        toSave.add(venda);
        vendasPorUuid[remoteId] = venda;
        savedCount++;
      } catch (error, stackTrace) {
        _logError('pull venda', remoteId, error, stackTrace);
      }
    }
    if (toSave.isNotEmpty) {
      await _isar.writeTxn(() async {
        await _isar.vendaLocals.putAll(toSave);
        for (final venda in toSave) {
          await venda.cliente.save();
        }
      });
      _currentReport?.saved += savedCount;
    }
    _logPullSummary('vendas', rows.length, savedCount);
    return seenIds;
  }

  Future<Set<String>?> _pullItensVenda() async {
    final rows = await _fetchBootstrapRows('itens_venda');
    if (rows == null) return null;

    final seenIds = <String>{};
    var savedCount = 0;
    final vendas =
        await _isar.vendaLocals.filter().empresaIdEqualTo(_empresaId).findAll();
    final vendasPorUuid = <String, VendaLocal>{
      for (final item in vendas)
        if (item.supabaseId != null) item.supabaseId!: item,
    };
    final produtos = await _isar.produtoLocals
        .filter()
        .empresaIdEqualTo(_empresaId)
        .findAll();
    final produtosPorUuid = <String, ProdutoLocal>{
      for (final item in produtos)
        if (item.supabaseId != null) item.supabaseId!: item,
    };
    final existing = await _isar.itemVendaLocals
        .filter()
        .empresaIdEqualTo(_empresaId)
        .findAll();
    final itensPorUuid = <String, ItemVendaLocal>{
      for (final item in existing)
        if (item.supabaseId != null) item.supabaseId!: item,
    };
    final toSave = <ItemVendaLocal>[];
    for (final row in rows) {
      final remoteId = _readRemoteId(row);
      if (remoteId == null) continue;
      seenIds.add(remoteId);
      try {
        final vendaId = _requiredString(row, 'venda_id');
        final produtoId = _requiredString(row, 'produto_id');
        final venda = vendasPorUuid[vendaId];
        final produto = produtosPorUuid[produtoId];
        if (venda == null || produto == null) {
          throw StateError(
              'Dependência remota do item não encontrada localmente.');
        }
        final item = itensPorUuid[remoteId] ?? ItemVendaLocal();
        item
          ..supabaseId = remoteId
          ..empresaId = _empresaId
          ..vendaLocalId = venda.id
          ..produtoLocalId = produto.id
          ..rowVersion = _asInt(row['row_version'], fallback: 1)
          ..quantidade = _asInt(row['quantidade'])
          ..precoUnitario = _asDouble(row['preco_unitario'])
          ..custoUnitario = _asDouble(row['custo_unitario']);
        item.venda.value = venda;
        item.produto.value = produto;
        toSave.add(item);
        itensPorUuid[remoteId] = item;
        savedCount++;
      } catch (error, stackTrace) {
        _logError('pull item de venda', remoteId, error, stackTrace);
      }
    }
    if (toSave.isNotEmpty) {
      await _isar.writeTxn(() async {
        await _isar.itemVendaLocals.putAll(toSave);
        for (final item in toSave) {
          await item.venda.save();
          await item.produto.save();
        }
      });
      _currentReport?.saved += savedCount;
    }
    _logPullSummary('itens de venda', rows.length, savedCount);
    return seenIds;
  }

  Future<Set<String>?> _pullParcelas() async {
    final rows = await _fetchBootstrapRows('parcelas');
    if (rows == null) return null;

    final seenIds = <String>{};
    var savedCount = 0;
    final vendas =
        await _isar.vendaLocals.filter().empresaIdEqualTo(_empresaId).findAll();
    final vendasPorUuid = <String, VendaLocal>{
      for (final item in vendas)
        if (item.supabaseId != null) item.supabaseId!: item,
    };
    final existing = await _isar.parcelaLocals
        .filter()
        .empresaIdEqualTo(_empresaId)
        .findAll();
    final parcelasPorUuid = <String, ParcelaLocal>{
      for (final item in existing)
        if (item.supabaseId != null) item.supabaseId!: item,
    };
    final toSave = <ParcelaLocal>[];
    for (final row in rows) {
      final remoteId = _readRemoteId(row);
      if (remoteId == null) continue;
      seenIds.add(remoteId);
      try {
        final vendaId = _requiredString(row, 'venda_id');
        final venda = vendasPorUuid[vendaId];
        if (venda == null) {
          throw StateError(
              'Venda remota da parcela não encontrada localmente.');
        }
        final current = parcelasPorUuid[remoteId];
        if (current?.syncPending == true) {
          _logDeferred('parcela', current!.id, 'alteração local pendente');
          continue;
        }
        final parcela = current ?? ParcelaLocal();
        parcela
          ..supabaseId = remoteId
          ..empresaId = _empresaId
          ..vendaLocalId = venda.id
          ..rowVersion = _asInt(row['row_version'], fallback: 1)
          ..numeroParcela = _asInt(row['numero_parcela'])
          ..valor = _asDouble(row['valor'])
          ..dataVencimento = _requiredDate(row, 'data_vencimento')
          ..dataPagamento = _asNullableDate(row['data_pagamento'])
          ..status = _asString(row['status'])
          ..syncPending = false;
        parcela.venda.value = venda;
        toSave.add(parcela);
        parcelasPorUuid[remoteId] = parcela;
        savedCount++;
      } catch (error, stackTrace) {
        _logError('pull parcela', remoteId, error, stackTrace);
      }
    }
    if (toSave.isNotEmpty) {
      await _isar.writeTxn(() async {
        await _isar.parcelaLocals.putAll(toSave);
        for (final parcela in toSave) {
          await parcela.venda.save();
        }
      });
      _currentReport?.saved += savedCount;
    }
    _logPullSummary('parcelas', rows.length, savedCount);
    return seenIds;
  }

  Future<List<Map<String, dynamic>>?> _fetchBootstrapRows(String entity) async {
    final rows = <Map<String, dynamic>>[];
    String? afterId;
    try {
      while (true) {
        final response = await _client.rpc('sync_bootstrap_page', params: {
          'p_empresa_id': _empresaId,
          'p_entity': entity,
          'p_after_id': afterId,
          'p_limit': 200,
        });
        if (response is! List) {
          throw StateError('Resposta inválida do bootstrap de $entity.');
        }
        final page = <Map<String, dynamic>>[];
        for (final raw in response) {
          if (raw is! Map) continue;
          final wrapper = Map<String, dynamic>.from(raw);
          final snapshot = wrapper['snapshot'];
          final id = wrapper['record_id']?.toString();
          if (snapshot is! Map || id == null || id.isEmpty) continue;
          final row = Map<String, dynamic>.from(snapshot)
            ..['id'] = id
            ..['row_version'] = _asInt(
              wrapper['row_version'] ?? snapshot['row_version'],
              fallback: 1,
            );
          page.add(row);
        }
        rows.addAll(page);
        _currentReport?.received += page.length;
        _currentReport?.pages++;
        if (page.length < 200) return rows;
        afterId = page.last['id']?.toString();
        if (afterId == null) return rows;
      }
    } on SocketException catch (error) {
      _logError('pull $entity', 'bootstrap', error);
    } on PostgrestException catch (error) {
      _logError('pull $entity', 'bootstrap', error);
    } catch (error, stackTrace) {
      _logError('pull $entity', 'bootstrap', error, stackTrace);
    }
    return null;
  }

  Future<void> _deleteMissingItens(Set<String> remoteIds) async {
    final localItems =
        await _isar.itemVendaLocals.where().supabaseIdIsNotNull().findAll();

    for (final item in localItems) {
      final remoteId = item.supabaseId;
      if (remoteId == null || remoteIds.contains(remoteId)) continue;

      await _runRecordSafely('exclusão local de item', item.id, () async {
        await item.venda.load();
        final venda = item.venda.value;
        if (venda?.empresaId != _empresaId) return;
        await _isar.writeTxn(() => _isar.itemVendaLocals.delete(item.id));
      });
    }
  }

  Future<void> _deleteMissingParcelas(Set<String> remoteIds) async {
    final parcelas = await _isar.parcelaLocals.where().findAll();
    for (final parcela in parcelas) {
      final remoteId = parcela.supabaseId;
      if (remoteId == null ||
          parcela.empresaId != _empresaId ||
          remoteIds.contains(remoteId) ||
          parcela.syncPending) {
        continue;
      }
      await _runRecordSafely('exclusão local de parcela', parcela.id, () async {
        await _isar.writeTxn(() => _isar.parcelaLocals.delete(parcela.id));
      });
    }
  }

  Future<void> _deleteMissingVendas(Set<String> remoteIds) async {
    final vendas = await _isar.vendaLocals.where().findAll();
    for (final venda in vendas) {
      final remoteId = venda.supabaseId;
      if (remoteId == null ||
          venda.empresaId != _empresaId ||
          remoteIds.contains(remoteId) ||
          venda.syncPending) {
        continue;
      }

      await _runRecordSafely('reconciliação local de venda', venda.id,
          () async {
        final items = await _isar.itemVendaLocals
            .filter()
            .venda((query) => query.idEqualTo(venda.id))
            .findAll();
        final parcelas = await _isar.parcelaLocals
            .filter()
            .venda((query) => query.idEqualTo(venda.id))
            .findAll();
        final hasPendingChildren =
            items.any((item) => item.supabaseId == null) ||
                parcelas.any(
                  (parcela) =>
                      parcela.supabaseId == null || parcela.syncPending,
                );
        if (hasPendingChildren) {
          _logDeferred(
            'venda',
            venda.id,
            'possui dependências locais pendentes',
          );
          return;
        }
        await _isar.writeTxn(() => _isar.vendaLocals.delete(venda.id));
      });
    }
  }

  Future<void> _reconcileProdutos(Set<String> remoteIds) async {
    await _runStageSafely('reconciliação de produtos', () async {
      final produtos = await _isar.produtoLocals.where().findAll();
      for (final produto in produtos) {
        final remoteId = produto.supabaseId;
        if (remoteId == null ||
            produto.empresaId != _empresaId ||
            remoteIds.contains(remoteId) ||
            produto.syncPending ||
            produto.pendingDelete) {
          continue;
        }

        await _runRecordSafely('reconciliação local de produto', produto.id,
            () async {
          final linkedItems = await _isar.itemVendaLocals
              .filter()
              .produto((query) => query.idEqualTo(produto.id))
              .count();
          await _isar.writeTxn(() async {
            final current = await _isar.produtoLocals.get(produto.id);
            if (current == null) return;
            if (linkedItems > 0) {
              current.ativo = false;
              await _isar.produtoLocals.put(current);
            } else {
              await _isar.produtoLocals.delete(current.id);
            }
          });
        });
      }
    });
  }

  Future<void> _reconcileClientes(Set<String> remoteIds) async {
    await _runStageSafely('reconciliação de clientes', () async {
      final clientes = await _isar.clienteLocals.where().findAll();
      for (final cliente in clientes) {
        final remoteId = cliente.supabaseId;
        if (remoteId == null ||
            cliente.empresaId != _empresaId ||
            remoteIds.contains(remoteId) ||
            cliente.syncPending ||
            cliente.pendingDelete) {
          continue;
        }

        await _runRecordSafely('reconciliação local de cliente', cliente.id,
            () async {
          final linkedSales = await _isar.vendaLocals
              .filter()
              .cliente((query) => query.idEqualTo(cliente.id))
              .count();
          await _isar.writeTxn(() async {
            final current = await _isar.clienteLocals.get(cliente.id);
            if (current == null) return;
            if (linkedSales > 0) {
              current.ativo = false;
              await _isar.clienteLocals.put(current);
            } else {
              await _isar.clienteLocals.delete(current.id);
            }
          });
        });
      }
    });
  }

  Future<String> _insertAndGetId(
    String table,
    Map<String, dynamic> payload,
  ) async {
    final response =
        await _client.from(table).insert(payload).select('id').single();
    return _requiredString(response, 'id');
  }

  Future<void> _updateRemote(
    String table,
    String remoteId,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client
        .from(table)
        .update(payload)
        .eq('id', remoteId)
        .eq('empresa_id', _empresaId)
        .select('id');
    if (response.isEmpty) {
      throw StateError('Registro remoto não encontrado para atualização.');
    }
  }

  Future<void> _deleteRemote(String table, String remoteId) async {
    await _client
        .from(table)
        .delete()
        .eq('id', remoteId)
        .eq('empresa_id', _empresaId)
        .select('id');
  }

  Future<bool> _markSynced<T>({
    required IsarCollection<T> collection,
    required Id localId,
    required String remoteId,
    required void Function(T current, String remoteId) update,
  }) async {
    var updated = false;
    await _isar.writeTxn(() async {
      final current = await collection.get(localId);
      if (current == null) return;
      update(current, remoteId);
      await collection.put(current);
      updated = true;
    });
    return updated;
  }

  Future<void> _runRecordSafely(
    String operation,
    Object recordId,
    Future<void> Function() action,
  ) async {
    try {
      await action();
    } on SocketException catch (error) {
      _logError(operation, recordId, error);
    } on PostgrestException catch (error) {
      _logError(operation, recordId, error);
    } catch (error, stackTrace) {
      _logError(operation, recordId, error, stackTrace);
    }
  }

  Future<void> _runStageSafely(
    String operation,
    Future<void> Function() action,
  ) async {
    try {
      await action();
    } catch (error, stackTrace) {
      _logError(operation, 'estágio', error, stackTrace);
    }
  }

  Future<Set<String>?> _runPullStageSafely(
    String operation,
    Future<Set<String>?> Function() action,
  ) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      _logError(operation, 'estágio', error, stackTrace);
      return null;
    }
  }

  Future<SyncReport> _guardOperation(
    SyncReportBuilder report,
    Future<void> Function() operation,
  ) async {
    try {
      await _runLocalMaintenance();
      await operation();
      final mutations = await _isar.syncMutationLocals
          .filter()
          .tenantIdEqualTo(_empresaId)
          .findAll();
      report.pendingAfter =
          mutations.where((mutation) => mutation.state != 'completed').length;
      report.conflicts = await _isar.syncConflictLocals
          .filter()
          .tenantIdEqualTo(_empresaId)
          .resolvedAtIsNull()
          .count();
    } catch (error, stackTrace) {
      _logError('sincronização', 'ciclo', error, stackTrace);
    }
    return report.build();
  }

  Future<void> _runLocalMaintenance() async {
    final now = DateTime.now();
    final cutoff = DateTime(now.year - 1, now.month, now.day);
    try {
      final result = await SyncWorker.migrateAndPrune(
        isar: _isar,
        tenantId: _empresaId,
        cutoff: cutoff,
      );
      if (result.migratedMutations > 0 || result.prunedSales > 0) {
        debugPrint(
          'Worker local: ${result.migratedMutations} pendências migradas; '
          '${result.prunedSales} vendas quitadas antigas removidas.',
        );
      }
    } catch (error, stackTrace) {
      _logError('manutenção local', 'worker', error, stackTrace);
    }
  }

  Future<SyncReport> _runExclusive(
    SyncScope scope,
    Future<void> Function() operation,
  ) {
    final activeSync = _activeSync;
    if (activeSync != null) return activeSync;

    final report = SyncReportBuilder(scope);
    _currentReport = report;
    late final Future<SyncReport> currentSync;
    currentSync = _guardOperation(report, operation).whenComplete(() {
      if (identical(_activeSync, currentSync)) {
        _activeSync = null;
        _currentReport = null;
      }
    });
    _activeSync = currentSync;
    return currentSync;
  }

  bool _canUseTenant(String? tenantId) =>
      tenantId == null || tenantId == _empresaId;

  String? _readRemoteId(Map<String, dynamic> row) {
    try {
      return _requiredString(row, 'id');
    } catch (error, stackTrace) {
      _logError('pull', 'registro sem UUID', error, stackTrace);
      return null;
    }
  }

  String _requiredString(Map<String, dynamic> row, String key) {
    final value = row[key]?.toString().trim();
    if (value == null || value.isEmpty) {
      throw FormatException('Campo obrigatório ausente: $key.');
    }
    return value;
  }

  DateTime _requiredDate(Map<String, dynamic> row, String key) {
    final value = _requiredString(row, key);
    return DateTime.parse(value);
  }

  DateTime? _asNullableDate(dynamic value) {
    if (value == null || value.toString().trim().isEmpty) return null;
    return DateTime.parse(value.toString());
  }

  String _civilDate(DateTime value) {
    final local = value.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '${local.year}-$month-$day';
  }

  String _asString(dynamic value) => value?.toString() ?? '';

  double _asDouble(dynamic value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;

  int _asInt(dynamic value, {int fallback = 0}) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? fallback;

  int? _asNullableInt(dynamic value) {
    if (value == null) return null;
    return value is num ? value.toInt() : int.tryParse('$value');
  }

  bool _asBool(dynamic value, {required bool fallback}) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      if (value.toLowerCase() == 'true') return true;
      if (value.toLowerCase() == 'false') return false;
    }
    return fallback;
  }

  void _logDeferred(String entity, Object id, String reason) {
    _currentReport?.deferred++;
    debugPrint('Sync adiado: $entity local $id; $reason.');
  }

  void _logPullSummary(String entity, int received, int saved) {
    debugPrint(
      'Pull $entity: $received recebidos do Supabase; '
      '$saved salvos no Isar.',
    );
  }

  void _logError(
    String operation,
    Object recordId,
    Object error, [
    StackTrace? stackTrace,
  ]) {
    final isNetworkError = _isNetworkError(error);
    _currentReport?.issues.add(
      SyncIssue(
        operation: operation,
        message: isNetworkError
            ? 'Sem conexão com o servidor.'
            : 'Não foi possível concluir esta operação.',
        isNetworkError: isNetworkError,
      ),
    );
    debugPrint('Falha em $operation para $recordId: $error');
    if (stackTrace != null) debugPrintStack(stackTrace: stackTrace);
  }

  void _recordPushed() => _currentReport?.pushed++;

  bool _isNetworkError(Object error) {
    if (error is SocketException) return true;
    final description = error.toString().toLowerCase();
    return description.contains('socket') ||
        description.contains('connection') ||
        description.contains('network') ||
        description.contains('failed host lookup');
  }
}

class RemoteHistoryPage {
  const RemoteHistoryPage({
    required this.records,
    required this.nextBefore,
    required this.nextBeforeId,
    required this.hasMore,
  });

  final List<RemoteHistoryRecord> records;
  final DateTime? nextBefore;
  final String? nextBeforeId;
  final bool hasMore;
}

class RemoteHistoryRecord {
  const RemoteHistoryRecord({
    required this.id,
    required this.date,
    required this.snapshot,
  });

  final String id;
  final DateTime date;
  final Map<String, dynamic> snapshot;
}
