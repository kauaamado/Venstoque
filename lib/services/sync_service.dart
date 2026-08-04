import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/local/cliente_model.dart';
import '../models/local/item_venda_model.dart';
import '../models/local/parcela_model.dart';
import '../models/local/produto_model.dart';
import '../models/local/venda_model.dart';
import '../utils/constants.dart';

class SyncService {
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

  static const int _pageSize = 500;

  final Isar _isar;
  final String _empresaId;
  final SupabaseClient _client;

  Future<void>? _activeSync;

  Future<void> syncAllToServer() => _runExclusive(_pushAll);

  Future<void> syncAllFromServer() => _runExclusive(_pullAll);

  Future<void> syncAll() => _runExclusive(() async {
        await _pushAll();
        await _pullAll();
      });

  Future<void> _pushAll() async {
    // A ordem garante que todos os UUIDs exigidos pelos filhos já existam.
    await _runStageSafely('push clientes', _pushClientes);
    await _runStageSafely('push produtos', _pushProdutos);
    await _runStageSafely('push vendas', _pushVendas);
    await _runStageSafely('push itens de venda', _pushItensVenda);
    await _runStageSafely('push parcelas', _pushParcelas);
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
        () => _deleteMissingForTenant<ParcelaLocal>(
          entity: 'parcela',
          collection: _isar.parcelaLocals,
          remoteIds: parcelas,
          localId: (item) => item.id,
          remoteId: (item) => item.supabaseId,
          tenantId: (item) => item.empresaId,
        ),
      );
    }
    if (vendas != null) {
      await _runStageSafely(
        'reconciliação de vendas',
        () => _deleteMissingForTenant<VendaLocal>(
          entity: 'venda',
          collection: _isar.vendaLocals,
          remoteIds: vendas,
          localId: (item) => item.id,
          remoteId: (item) => item.supabaseId,
          tenantId: (item) => item.empresaId,
        ),
      );
    }
    if (produtos != null) {
      await _runStageSafely(
        'reconciliação de produtos',
        () => _deleteMissingForTenant<ProdutoLocal>(
          entity: 'produto',
          collection: _isar.produtoLocals,
          remoteIds: produtos,
          localId: (item) => item.id,
          remoteId: (item) => item.supabaseId,
          tenantId: (item) => item.empresaId,
        ),
      );
    }
    if (clientes != null) {
      await _runStageSafely(
        'reconciliação de clientes',
        () => _deleteMissingForTenant<ClienteLocal>(
          entity: 'cliente',
          collection: _isar.clienteLocals,
          remoteIds: clientes,
          localId: (item) => item.id,
          remoteId: (item) => item.supabaseId,
          tenantId: (item) => item.empresaId,
        ),
      );
    }
  }

  Future<void> _pushClientes() async {
    final pending =
        await _isar.clienteLocals.where().supabaseIdIsNull().findAll();

    for (final cliente in pending) {
      if (!_canUseTenant(cliente.empresaId)) continue;

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

        await _markSynced<ClienteLocal>(
          collection: _isar.clienteLocals,
          localId: cliente.id,
          remoteId: remoteId,
          update: (current, id) {
            current.supabaseId = id;
            current.empresaId ??= _empresaId;
          },
        );
      });
    }
  }

  Future<void> _pushProdutos() async {
    final pending =
        await _isar.produtoLocals.where().supabaseIdIsNull().findAll();

    for (final produto in pending) {
      if (!_canUseTenant(produto.empresaId)) continue;

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

        await _markSynced<ProdutoLocal>(
          collection: _isar.produtoLocals,
          localId: produto.id,
          remoteId: remoteId,
          update: (current, id) {
            current.supabaseId = id;
            current.empresaId ??= _empresaId;
          },
        );
      });
    }
  }

  Future<void> _pushVendas() async {
    final pending =
        await _isar.vendaLocals.where().supabaseIdIsNull().findAll();

    for (final venda in pending) {
      if (!_canUseTenant(venda.empresaId)) continue;

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
      });
    }
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
      });
    }
  }

  Future<void> _pushParcelas() async {
    final pending =
        await _isar.parcelaLocals.where().supabaseIdIsNull().findAll();

    for (final parcela in pending) {
      if (!_canUseTenant(parcela.empresaId)) continue;

      await _runRecordSafely('push parcela', parcela.id, () async {
        await parcela.venda.load();
        final venda = parcela.venda.value;
        if (venda == null ||
            !_canUseTenant(venda.empresaId) ||
            venda.supabaseId == null) {
          _logDeferred('parcela', parcela.id, 'venda ainda não sincronizada');
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
          },
        );
      });
    }
  }

  Future<Set<String>?> _pullClientes() async {
    final rows = await _fetchSnapshot(
      entity: 'clientes',
      fetchPage: (from, to) async {
        final response = await _client
            .from(AppTables.clientes)
            .select()
            .eq('empresa_id', _empresaId)
            .order('id')
            .range(from, to);
        return List<Map<String, dynamic>>.from(response);
      },
    );
    if (rows == null) return null;

    final seenIds = <String>{};
    var savedCount = 0;
    for (final row in rows) {
      final remoteId = _readRemoteId(row);
      if (remoteId == null) continue;
      seenIds.add(remoteId);

      await _runRecordSafely('pull cliente', remoteId, () async {
        final cliente = await _isar.clienteLocals
                .where()
                .supabaseIdEqualTo(remoteId)
                .findFirst() ??
            ClienteLocal();
        cliente
          ..supabaseId = remoteId
          ..empresaId = _empresaId
          ..nome = _asString(row['nome'])
          ..celular = _asString(row['celular'])
          ..referencia = _asString(row['referencia'])
          ..observacoes = _asString(row['observacoes'])
          ..ativo = _asBool(row['ativo'], fallback: true)
          ..legacyId = _asNullableInt(row['legacy_id']);

        await _isar.writeTxn(() => _isar.clienteLocals.put(cliente));
        savedCount++;
      });
    }
    _logPullSummary('clientes', rows.length, savedCount);
    return seenIds;
  }

  Future<Set<String>?> _pullProdutos() async {
    final rows = await _fetchSnapshot(
      entity: 'produtos',
      fetchPage: (from, to) async {
        final response = await _client
            .from(AppTables.produtos)
            .select()
            .eq('empresa_id', _empresaId)
            .order('id')
            .range(from, to);
        return List<Map<String, dynamic>>.from(response);
      },
    );
    if (rows == null) return null;

    final seenIds = <String>{};
    var savedCount = 0;
    for (final row in rows) {
      final remoteId = _readRemoteId(row);
      if (remoteId == null) continue;
      seenIds.add(remoteId);

      await _runRecordSafely('pull produto', remoteId, () async {
        final produto = await _isar.produtoLocals
                .where()
                .supabaseIdEqualTo(remoteId)
                .findFirst() ??
            ProdutoLocal();
        produto
          ..supabaseId = remoteId
          ..empresaId = _empresaId
          ..nome = _asString(row['nome'])
          ..categoria = _asString(row['categoria'])
          ..fornecedor = _asString(row['fornecedor'])
          ..precoCusto = _asDouble(row['preco_custo'])
          ..valorVenda = _asDouble(row['valor_venda'])
          ..quantidadeEstoque = _asInt(row['quantidade_estoque'])
          ..ativo = _asBool(row['ativo'], fallback: true);

        await _isar.writeTxn(() => _isar.produtoLocals.put(produto));
        savedCount++;
      });
    }
    _logPullSummary('produtos', rows.length, savedCount);
    return seenIds;
  }

  Future<Set<String>?> _pullVendas() async {
    final rows = await _fetchSnapshot(
      entity: 'vendas',
      fetchPage: (from, to) async {
        final response = await _client
            .from(AppTables.vendas)
            .select()
            .eq('empresa_id', _empresaId)
            .order('id')
            .range(from, to);
        return List<Map<String, dynamic>>.from(response);
      },
    );
    if (rows == null) return null;

    final seenIds = <String>{};
    var savedCount = 0;
    for (final row in rows) {
      final remoteId = _readRemoteId(row);
      if (remoteId == null) continue;
      seenIds.add(remoteId);

      await _runRecordSafely('pull venda', remoteId, () async {
        final clienteId = _requiredString(row, 'cliente_id');
        final cliente = await _isar.clienteLocals
            .where()
            .supabaseIdEqualTo(clienteId)
            .findFirst();
        if (cliente == null) {
          throw StateError(
              'Cliente remoto da venda não encontrado localmente.');
        }

        final venda = await _isar.vendaLocals
                .where()
                .supabaseIdEqualTo(remoteId)
                .findFirst() ??
            VendaLocal();
        venda
          ..supabaseId = remoteId
          ..empresaId = _empresaId
          ..dataVenda = _requiredDate(row, 'data_venda')
          ..valorTotal = _asDouble(row['valor_total'])
          ..valorEntrada = _asDouble(row['valor_entrada'])
          ..desconto = _asDouble(row['desconto'])
          ..tipoPagamento = _asString(row['tipo_pagamento'])
          ..observacoes = _asString(row['observacoes'])
          ..legacyId = _asNullableInt(row['legacy_id']);
        venda.cliente.value = cliente;

        await _isar.writeTxn(() async {
          await _isar.vendaLocals.put(venda);
          await venda.cliente.save();
        });
        savedCount++;
      });
    }
    _logPullSummary('vendas', rows.length, savedCount);
    return seenIds;
  }

  Future<Set<String>?> _pullItensVenda() async {
    final rows = await _fetchSnapshot(
      entity: 'itens de venda',
      fetchPage: (from, to) async {
        final response = await _client
            .from(AppTables.itensVenda)
            .select('*, vendas!inner(empresa_id)')
            .eq('vendas.empresa_id', _empresaId)
            .order('id')
            .range(from, to);
        return List<Map<String, dynamic>>.from(response);
      },
    );
    if (rows == null) return null;

    final seenIds = <String>{};
    var savedCount = 0;
    for (final row in rows) {
      final remoteId = _readRemoteId(row);
      if (remoteId == null) continue;
      seenIds.add(remoteId);

      await _runRecordSafely('pull item de venda', remoteId, () async {
        final vendaId = _requiredString(row, 'venda_id');
        final produtoId = _requiredString(row, 'produto_id');
        final venda = await _isar.vendaLocals
            .where()
            .supabaseIdEqualTo(vendaId)
            .findFirst();
        final produto = await _isar.produtoLocals
            .where()
            .supabaseIdEqualTo(produtoId)
            .findFirst();
        if (venda == null || produto == null) {
          throw StateError(
              'Dependência remota do item não encontrada localmente.');
        }

        final item = await _isar.itemVendaLocals
                .where()
                .supabaseIdEqualTo(remoteId)
                .findFirst() ??
            ItemVendaLocal();
        item
          ..supabaseId = remoteId
          ..quantidade = _asInt(row['quantidade'])
          ..precoUnitario = _asDouble(row['preco_unitario'])
          ..custoUnitario = _asDouble(row['custo_unitario']);
        item.venda.value = venda;
        item.produto.value = produto;

        await _isar.writeTxn(() async {
          await _isar.itemVendaLocals.put(item);
          await item.venda.save();
          await item.produto.save();
        });
        savedCount++;
      });
    }
    _logPullSummary('itens de venda', rows.length, savedCount);
    return seenIds;
  }

  Future<Set<String>?> _pullParcelas() async {
    final rows = await _fetchSnapshot(
      entity: 'parcelas',
      fetchPage: (from, to) async {
        final response = await _client
            .from(AppTables.parcelas)
            .select()
            .eq('empresa_id', _empresaId)
            .order('id')
            .range(from, to);
        return List<Map<String, dynamic>>.from(response);
      },
    );
    if (rows == null) return null;

    final seenIds = <String>{};
    var savedCount = 0;
    for (final row in rows) {
      final remoteId = _readRemoteId(row);
      if (remoteId == null) continue;
      seenIds.add(remoteId);

      await _runRecordSafely('pull parcela', remoteId, () async {
        final vendaId = _requiredString(row, 'venda_id');
        final venda = await _isar.vendaLocals
            .where()
            .supabaseIdEqualTo(vendaId)
            .findFirst();
        if (venda == null) {
          throw StateError(
              'Venda remota da parcela não encontrada localmente.');
        }

        final parcela = await _isar.parcelaLocals
                .where()
                .supabaseIdEqualTo(remoteId)
                .findFirst() ??
            ParcelaLocal();
        parcela
          ..supabaseId = remoteId
          ..empresaId = _empresaId
          ..numeroParcela = _asInt(row['numero_parcela'])
          ..valor = _asDouble(row['valor'])
          ..dataVencimento = _requiredDate(row, 'data_vencimento')
          ..dataPagamento = _asNullableDate(row['data_pagamento'])
          ..status = _asString(row['status']);
        parcela.venda.value = venda;

        await _isar.writeTxn(() async {
          await _isar.parcelaLocals.put(parcela);
          await parcela.venda.save();
        });
        savedCount++;
      });
    }
    _logPullSummary('parcelas', rows.length, savedCount);
    return seenIds;
  }

  Future<List<Map<String, dynamic>>?> _fetchSnapshot({
    required String entity,
    required Future<List<Map<String, dynamic>>> Function(int from, int to)
        fetchPage,
  }) async {
    final rows = <Map<String, dynamic>>[];
    var from = 0;

    try {
      while (true) {
        final page = await fetchPage(from, from + _pageSize - 1);
        rows.addAll(page);
        if (page.length < _pageSize) return rows;
        from += _pageSize;
      }
    } on SocketException catch (error) {
      _logError('pull $entity', 'snapshot', error);
    } on PostgrestException catch (error) {
      _logError('pull $entity', 'snapshot', error);
    } catch (error, stackTrace) {
      _logError('pull $entity', 'snapshot', error, stackTrace);
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

  Future<void> _deleteMissingForTenant<T>({
    required String entity,
    required IsarCollection<T> collection,
    required Set<String> remoteIds,
    required Id Function(T item) localId,
    required String? Function(T item) remoteId,
    required String? Function(T item) tenantId,
  }) async {
    final localItems = await collection.where().findAll();

    for (final item in localItems) {
      final cloudId = remoteId(item);
      if (cloudId == null ||
          tenantId(item) != _empresaId ||
          remoteIds.contains(cloudId)) {
        continue;
      }

      final id = localId(item);
      await _runRecordSafely('exclusão local de $entity', id, () async {
        await _isar.writeTxn(() => collection.delete(id));
      });
    }
  }

  Future<String> _insertAndGetId(
    String table,
    Map<String, dynamic> payload,
  ) async {
    final response =
        await _client.from(table).insert(payload).select('id').single();
    return _requiredString(response, 'id');
  }

  Future<void> _markSynced<T>({
    required IsarCollection<T> collection,
    required Id localId,
    required String remoteId,
    required void Function(T current, String remoteId) update,
  }) async {
    await _isar.writeTxn(() async {
      final current = await collection.get(localId);
      if (current == null) return;
      update(current, remoteId);
      await collection.put(current);
    });
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

  Future<void> _guardOperation(Future<void> Function() operation) async {
    try {
      await operation();
    } catch (error, stackTrace) {
      _logError('sincronização', 'ciclo', error, stackTrace);
    }
  }

  Future<void> _runExclusive(Future<void> Function() operation) {
    final activeSync = _activeSync;
    if (activeSync != null) return activeSync;

    late final Future<void> currentSync;
    currentSync = _guardOperation(operation).whenComplete(() {
      if (identical(_activeSync, currentSync)) _activeSync = null;
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

  String _asString(dynamic value) => value?.toString() ?? '';

  double _asDouble(dynamic value) =>
      value is num ? value.toDouble() : double.tryParse('$value') ?? 0;

  int _asInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;

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
    debugPrint('Falha em $operation para $recordId: $error');
    if (stackTrace != null) debugPrintStack(stackTrace: stackTrace);
  }
}
