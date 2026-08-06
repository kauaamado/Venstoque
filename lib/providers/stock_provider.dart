import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';

import '../models/estoque_model.dart';
import '../models/local/item_venda_model.dart';
import '../models/local/produto_model.dart';
import '../models/produto_model.dart';
import '../services/sync_mutation_queue.dart';

enum ProductDeleteResult { deleted, deactivated }

class StockProvider with ChangeNotifier {
  StockProvider(this._isar, {required String empresaId})
      : _empresaId = empresaId.trim() {
    if (_empresaId.isEmpty) {
      throw ArgumentError.value(
        empresaId,
        'empresaId',
        'O identificador da empresa não pode ser vazio.',
      );
    }

    _productSubscription =
        _isar.produtoLocals.watchLazy(fireImmediately: true).listen(
              (_) => unawaited(_refreshFromWatcher()),
              onError: _handleWatcherError,
            );
  }

  final Isar _isar;
  final String _empresaId;
  late final StreamSubscription<void> _productSubscription;

  List<ProdutoModel> _products = [];
  bool _isLoading = false;
  bool _isDisposed = false;
  int _refreshVersion = 0;
  String? _errorMessage;

  List<ProdutoModel> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProducts() async {
    _setLoading(true);
    try {
      await _refreshProducts();
      _errorMessage = null;
    } catch (error, stackTrace) {
      _recordError('Erro ao carregar produtos locais', error, stackTrace);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addProduct(ProdutoModel product) async {
    if (product.localId != null) {
      await updateProduct(product);
      return;
    }

    await _runMutation('Erro ao salvar produto local', () async {
      final local = ProdutoLocal()
        ..supabaseId = null
        ..empresaId = _empresaId;
      _applyModel(local, product);

      await _isar.writeTxn(() async {
        await _isar.produtoLocals.put(local);
        await SyncMutationQueue.queueProduto(_isar, _empresaId, local);
      });
    });
  }

  Future<void> updateProduct(ProdutoModel product) async {
    final localId = _requiredLocalId(product.localId);

    await _runMutation('Erro ao atualizar produto local', () async {
      await _isar.writeTxn(() async {
        final current = await _isar.produtoLocals.get(localId);
        if (current == null || current.empresaId != _empresaId) {
          throw StateError('Produto local não encontrado.');
        }

        _applyModel(current, product);
        current
          ..syncRevision = current.syncRevision + 1
          ..syncPending = current.supabaseId != null;
        await _isar.produtoLocals.put(current);
        await SyncMutationQueue.queueProduto(_isar, _empresaId, current);
      });
    });
  }

  Future<void> registerEntry(EstoqueModel entry, double newPrice) async {
    final localId = _requiredLocalId(entry.produtoId);

    await _runMutation('Erro ao registrar entrada local', () async {
      await _isar.writeTxn(() async {
        final current = await _isar.produtoLocals.get(localId);
        if (current == null || current.empresaId != _empresaId) {
          throw StateError('Produto local não encontrado.');
        }

        current
          ..quantidadeEstoque += entry.quantidade
          ..precoCusto = entry.custoUnitario
          ..valorVenda = newPrice
          ..fornecedor = entry.fornecedor.trim()
          ..syncRevision = current.syncRevision + 1
          ..syncPending = current.supabaseId != null;
        await _isar.produtoLocals.put(current);
        if (current.supabaseId == null) {
          await SyncMutationQueue.queueProduto(_isar, _empresaId, current);
        } else {
          await SyncMutationQueue.queueEstoqueDelta(
            isar: _isar,
            tenantId: _empresaId,
            produto: current,
            delta: entry.quantidade,
          );
          await SyncMutationQueue.queueProduto(
            _isar,
            _empresaId,
            current,
            includeStock: false,
          );
        }
      });
    });
  }

  Future<ProductDeleteResult> deleteProduct(String productId) async {
    final localId = _requiredLocalId(productId);
    late ProductDeleteResult result;

    await _runMutation('Erro ao remover produto local', () async {
      final linkedItems = await _isar.itemVendaLocals
          .filter()
          .produto((query) => query.idEqualTo(localId))
          .count();

      await _isar.writeTxn(() async {
        final current = await _isar.produtoLocals.get(localId);
        if (current == null || current.empresaId != _empresaId) {
          throw StateError('Produto local não encontrado.');
        }

        if (linkedItems > 0) {
          current
            ..ativo = false
            ..syncRevision = current.syncRevision + 1
            ..syncPending = current.supabaseId != null;
          await _isar.produtoLocals.put(current);
          await SyncMutationQueue.queueProduto(_isar, _empresaId, current);
          result = ProductDeleteResult.deactivated;
        } else if (current.supabaseId != null) {
          current
            ..ativo = false
            ..pendingDelete = true
            ..syncRevision = current.syncRevision + 1
            ..syncPending = false;
          await _isar.produtoLocals.put(current);
          await SyncMutationQueue.queueProduto(_isar, _empresaId, current);
          result = ProductDeleteResult.deleted;
        } else {
          await _isar.produtoLocals.delete(localId);
          result = ProductDeleteResult.deleted;
        }
      });
    });

    return result;
  }

  Future<void> _runMutation(
    String errorMessage,
    Future<void> Function() operation,
  ) async {
    _setLoading(true);
    try {
      await operation();
      await _refreshProducts();
      _errorMessage = null;
    } catch (error, stackTrace) {
      _recordError(errorMessage, error, stackTrace);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _refreshFromWatcher() async {
    try {
      await _refreshProducts();
      _errorMessage = null;
      _notifyListeners();
    } catch (error, stackTrace) {
      _recordError('Erro ao observar produtos locais', error, stackTrace);
      _notifyListeners();
    }
  }

  Future<void> _refreshProducts() async {
    final refreshVersion = ++_refreshVersion;
    final localProducts = await _isar.produtoLocals
        .filter()
        .empresaIdEqualTo(_empresaId)
        .and()
        .ativoEqualTo(true)
        .and()
        .pendingDeleteEqualTo(false)
        .sortByNome()
        .findAll();
    if (_isDisposed || refreshVersion != _refreshVersion) return;

    _products = localProducts.map(_toModel).toList();
  }

  ProdutoModel _toModel(ProdutoLocal product) {
    return ProdutoModel(
      localId: product.id.toString(),
      id: product.supabaseId,
      nome: product.nome,
      categoria: product.categoria,
      fornecedor: product.fornecedor,
      precoCusto: product.precoCusto,
      valorVenda: product.valorVenda,
      quantidadeEstoque: product.quantidadeEstoque,
      ativo: product.ativo,
    );
  }

  void _applyModel(ProdutoLocal local, ProdutoModel product) {
    local
      ..nome = product.nome.trim()
      ..categoria = product.categoria.trim()
      ..fornecedor = product.fornecedor.trim()
      ..precoCusto = product.precoCusto
      ..valorVenda = product.valorVenda
      ..quantidadeEstoque = product.quantidadeEstoque
      ..ativo = product.ativo;
  }

  int _requiredLocalId(String? value) {
    final localId = int.tryParse(value ?? '');
    if (localId == null || localId <= 0) {
      throw ArgumentError.value(
        value,
        'localId',
        'O identificador local do produto é inválido.',
      );
    }
    return localId;
  }

  void _setLoading(bool value) {
    if (_isDisposed || _isLoading == value) return;
    _isLoading = value;
    _notifyListeners();
  }

  void _recordError(
    String message,
    Object error,
    StackTrace stackTrace,
  ) {
    if (_isDisposed) return;
    _errorMessage = message;
    debugPrint('$message: $error');
    debugPrintStack(stackTrace: stackTrace);
  }

  void _handleWatcherError(Object error, StackTrace stackTrace) {
    _recordError('Erro ao observar produtos locais', error, stackTrace);
    _notifyListeners();
  }

  void _notifyListeners() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    unawaited(_productSubscription.cancel());
    super.dispose();
  }
}
