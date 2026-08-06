import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';
import 'package:uuid/uuid.dart';

import '../models/cliente_model.dart';
import '../models/item_venda_model.dart';
import '../models/local/cliente_model.dart';
import '../models/local/item_venda_model.dart';
import '../models/local/parcela_model.dart';
import '../models/local/produto_model.dart';
import '../models/local/venda_model.dart';
import '../models/parcela_model.dart';
import '../models/produto_model.dart';
import '../models/venda_model.dart';
import '../models/local/sync_state_model.dart';

class SaleProvider with ChangeNotifier {
  SaleProvider(this._isar, {required String empresaId})
      : _empresaId = empresaId.trim() {
    if (_empresaId.isEmpty) {
      throw ArgumentError.value(
        empresaId,
        'empresaId',
        'O identificador da empresa não pode ser vazio.',
      );
    }

    _subscriptions = [
      _isar.vendaLocals.watchLazy(fireImmediately: true).listen(
            (_) => unawaited(_refreshFromWatcher()),
            onError: _handleWatcherError,
          ),
      _isar.itemVendaLocals.watchLazy().listen(
            (_) => unawaited(_refreshFromWatcher()),
            onError: _handleWatcherError,
          ),
      _isar.parcelaLocals.watchLazy().listen(
            (_) => unawaited(_refreshFromWatcher()),
            onError: _handleWatcherError,
          ),
      _isar.clienteLocals.watchLazy().listen(
            (_) => unawaited(_refreshFromWatcher()),
            onError: _handleWatcherError,
          ),
      _isar.produtoLocals.watchLazy().listen(
            (_) => unawaited(_refreshFromWatcher()),
            onError: _handleWatcherError,
          ),
    ];
  }

  final Isar _isar;
  final String _empresaId;
  late final List<StreamSubscription<void>> _subscriptions;

  ClienteModel? _selectedCustomer;
  final List<ItemVendaModel> _cart = [];
  String _paymentType = 'a_vista';
  bool _isLoading = false;
  bool _isLoadingHistory = false;
  bool _isDisposed = false;
  bool _refreshInProgress = false;
  bool _refreshRequested = false;
  String? _errorMessage;
  List<_SaleSnapshot> _snapshots = [];
  List<VendaModel> _sales = [];
  List<Map<String, dynamic>> _salesHistory = [];
  List<Map<String, dynamic>> _receivables = [];
  List<Map<String, dynamic>> _customerHistory = [];
  Map<String, Map<String, dynamic>> _customerInsightsCache = {};

  ClienteModel? get selectedCustomer => _selectedCustomer;
  List<ItemVendaModel> get cart => List.unmodifiable(_cart);
  String get paymentType => _paymentType;
  bool get isLoading => _isLoading;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get errorMessage => _errorMessage;
  List<VendaModel> get sales => List.unmodifiable(_sales);
  List<Map<String, dynamic>> get salesHistory =>
      List.unmodifiable(_salesHistory);
  List<Map<String, dynamic>> get receivables => List.unmodifiable(_receivables);
  List<Map<String, dynamic>> get customerHistory =>
      List.unmodifiable(_customerHistory);

  double get total => _cart.fold(
        0,
        (sum, item) => sum + item.subtotal,
      );

  void setCustomer(ClienteModel customer) {
    _selectedCustomer = customer;
    _notifyListeners();
  }

  void setPaymentType(String type) {
    _paymentType = type;
    _notifyListeners();
  }

  void addToCart(ProdutoModel product, int quantity) {
    final localId = _requiredLocalId(product.localId, 'produtoLocalId');
    if (quantity <= 0) {
      throw ArgumentError.value(
        quantity,
        'quantity',
        'A quantidade deve ser maior que zero.',
      );
    }

    final productId = localId.toString();
    final existingIndex = _cart.indexWhere(
      (item) => item.produtoId == productId,
    );
    if (existingIndex >= 0) {
      _cart[existingIndex].quantidade += quantity;
    } else {
      _cart.add(
        ItemVendaModel(
          produtoId: productId,
          produtoNome: product.nome,
          quantidade: quantity,
          precoUnitario: product.valorVenda,
          custoUnitario: product.precoCusto,
        ),
      );
    }
    _notifyListeners();
  }

  void removeFromCart(int index) {
    if (index < 0 || index >= _cart.length) return;
    _cart.removeAt(index);
    _notifyListeners();
  }

  void clear() {
    _selectedCustomer = null;
    _cart.clear();
    _paymentType = 'a_vista';
    _notifyListeners();
  }

  Future<void> loadSales() async {
    _setLoading(true);
    try {
      await _refreshSales();
      _errorMessage = null;
    } catch (error, stackTrace) {
      _recordError('Erro ao carregar vendas locais', error, stackTrace);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> finalizeSale(List<ParcelaModel>? installments) async {
    final customer = _selectedCustomer;
    if (customer == null || _cart.isEmpty) {
      throw StateError('Selecione um cliente e adicione produtos à venda.');
    }

    final customerId = _requiredLocalId(customer.localId, 'clienteLocalId');
    final items = List<ItemVendaModel>.from(_cart);
    final saleTotal = total;
    final paymentType = _paymentType;
    final saleDate = DateTime.now();

    _setLoading(true);
    try {
      await _isar.writeTxn(() async {
        final localCustomer = await _isar.clienteLocals.get(customerId);
        if (localCustomer == null ||
            (localCustomer.empresaId != null &&
                localCustomer.empresaId != _empresaId)) {
          throw StateError('Cliente local não encontrado para esta empresa.');
        }

        final sale = VendaLocal()
          ..supabaseId = null
          ..empresaId = _empresaId
          ..clienteLocalId = localCustomer.id.toString()
          ..syncOperationId = const Uuid().v4()
          ..syncPending = true
          ..dataVenda = saleDate
          ..valorTotal = saleTotal
          ..valorEntrada = paymentType == 'a_vista' ? saleTotal : 0
          ..desconto = 0
          ..tipoPagamento = paymentType
          ..observacoes = '';
        sale.cliente.value = localCustomer;
        await _isar.vendaLocals.put(sale);
        await sale.cliente.save();
        await _isar.syncMutationLocals.put(
          SyncMutationLocal()
            ..tenantId = _empresaId
            ..operationId = sale.syncOperationId!
            ..entity = 'venda_graph'
            ..operation = 'create_graph'
            ..localId = sale.id
            ..payloadJson = '{}',
        );

        for (final cartItem in items) {
          final productId = _requiredLocalId(
            cartItem.produtoId,
            'produtoLocalId',
          );
          final product = await _isar.produtoLocals.get(productId);
          if (product == null ||
              product.empresaId != _empresaId ||
              !product.ativo) {
            throw StateError('Produto local indisponível para esta empresa.');
          }
          if (product.quantidadeEstoque < cartItem.quantidade) {
            throw StateError('Estoque insuficiente para ${product.nome}.');
          }

          product
            ..quantidadeEstoque -= cartItem.quantidade
            ..syncRevision = product.syncRevision + 1
            ..syncPending = product.supabaseId == null;
          await _isar.produtoLocals.put(product);

          final item = ItemVendaLocal()
            ..supabaseId = null
            ..empresaId = _empresaId
            ..vendaLocalId = sale.id
            ..produtoLocalId = product.id
            ..quantidade = cartItem.quantidade
            ..precoUnitario = cartItem.precoUnitario
            ..custoUnitario = cartItem.custoUnitario;
          item
            ..venda.value = sale
            ..produto.value = product;
          await _isar.itemVendaLocals.put(item);
          await item.venda.save();
          await item.produto.save();
        }

        for (final installment in installments ?? const <ParcelaModel>[]) {
          final localInstallment = ParcelaLocal()
            ..supabaseId = null
            ..empresaId = _empresaId
            ..vendaLocalId = sale.id
            ..numeroParcela = installment.numeroParcela
            ..valor = installment.valor
            ..dataVencimento = installment.dataVencimento
            ..dataPagamento = installment.dataPagamento
            ..status = installment.status;
          localInstallment.venda.value = sale;
          await _isar.parcelaLocals.put(localInstallment);
          await localInstallment.venda.save();
        }
      });

      _selectedCustomer = null;
      _cart.clear();
      _paymentType = 'a_vista';
      await _refreshSales();
      _errorMessage = null;
    } catch (error, stackTrace) {
      _recordError('Erro ao registrar venda local', error, stackTrace);
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Map<String, dynamic>>> getSalesHistory() async {
    await _refreshSales();
    return salesHistory;
  }

  Future<List<Map<String, dynamic>>> getReceivables() async {
    await _refreshSales();
    return receivables;
  }

  Map<String, dynamic>? getCachedInsights(String customerId) {
    return _customerInsightsCache[customerId];
  }

  Future<Map<String, dynamic>> getCustomerInsights(String customerId) async {
    _requiredLocalId(customerId, 'clienteLocalId');
    await _refreshSales();
    return _customerInsightsCache[customerId] ?? _emptyInsights();
  }

  Future<void> loadCustomerHistory(String customerId, int days) async {
    final customerIdValue = _requiredLocalId(customerId, 'clienteLocalId');
    _isLoadingHistory = true;
    _notifyListeners();
    try {
      await _refreshSales();
      final cutoff = DateTime.now().subtract(Duration(days: days));
      _customerHistory = _snapshots
          .where(
            (snapshot) =>
                snapshot.customer?.id == customerIdValue &&
                !snapshot.sale.dataVenda.isBefore(cutoff),
          )
          .map(_customerHistoryMap)
          .toList()
        ..sort(
          (first, second) => DateTime.parse(second['data'].toString())
              .compareTo(DateTime.parse(first['data'].toString())),
        );
    } finally {
      _isLoadingHistory = false;
      _notifyListeners();
    }
  }

  Future<void> markParcelAsPaid(String installmentId) async {
    final localId = _requiredLocalId(installmentId, 'parcelaLocalId');
    await _isar.writeTxn(() async {
      final installment = await _isar.parcelaLocals.get(localId);
      if (installment == null || installment.empresaId != _empresaId) {
        throw StateError('Parcela local não encontrada.');
      }
      installment
        ..status = 'pago'
        ..dataPagamento = DateTime.now()
        ..syncRevision = installment.syncRevision + 1
        ..syncPending = installment.supabaseId != null;
      await _isar.parcelaLocals.put(installment);
      await _queueInstallmentMutation(installment);
    });
    await _refreshSales();
  }

  Future<void> markAllParcelsAsPaid(String saleId) async {
    final localSaleId = _requiredLocalId(saleId, 'vendaLocalId');
    final installments = await _isar.parcelaLocals
        .filter()
        .venda((query) => query.idEqualTo(localSaleId))
        .findAll();
    final paymentDate = DateTime.now();
    await _isar.writeTxn(() async {
      for (final installment in installments) {
        if (installment.empresaId != _empresaId) continue;
        installment
          ..status = 'pago'
          ..dataPagamento = paymentDate
          ..syncRevision = installment.syncRevision + 1
          ..syncPending = installment.supabaseId != null;
        await _isar.parcelaLocals.put(installment);
        await _queueInstallmentMutation(installment);
      }
    });
    await _refreshSales();
  }

  Future<void> payPartialParcel(String installmentId, double remaining) async {
    if (remaining <= 0) {
      await markParcelAsPaid(installmentId);
      return;
    }
    final localId = _requiredLocalId(installmentId, 'parcelaLocalId');
    await _isar.writeTxn(() async {
      final installment = await _isar.parcelaLocals.get(localId);
      if (installment == null || installment.empresaId != _empresaId) {
        throw StateError('Parcela local não encontrada.');
      }
      installment
        ..valor = remaining
        ..syncRevision = installment.syncRevision + 1
        ..syncPending = installment.supabaseId != null;
      await _isar.parcelaLocals.put(installment);
      await _queueInstallmentMutation(installment);
    });
    await _refreshSales();
  }

  Future<void> _queueInstallmentMutation(ParcelaLocal installment) async {
    if (installment.supabaseId == null) return;
    final existing = await _isar.syncMutationLocals
        .filter()
        .tenantIdEqualTo(_empresaId)
        .entityEqualTo('parcelas')
        .localIdEqualTo(installment.id)
        .stateEqualTo('queued')
        .findFirst();
    final mutation = existing ?? SyncMutationLocal()
      ..tenantId = _empresaId
      ..operationId = const Uuid().v4()
      ..entity = 'parcelas'
      ..operation = 'update'
      ..localId = installment.id
      ..remoteId = installment.supabaseId;
    mutation
      ..baseRowVersion =
          installment.rowVersion == 0 ? null : installment.rowVersion
      ..payloadJson = jsonEncode(<String, dynamic>{
        'valor': installment.valor,
        'data_vencimento': installment.dataVencimento.toIso8601String(),
        'data_pagamento': installment.dataPagamento?.toIso8601String(),
        'status': installment.status,
      });
    await _isar.syncMutationLocals.put(mutation);
  }

  Future<void> _refreshFromWatcher() async {
    if (_refreshInProgress) {
      _refreshRequested = true;
      return;
    }
    _refreshInProgress = true;
    try {
      do {
        _refreshRequested = false;
        await _refreshSales();
        _errorMessage = null;
        _notifyListeners();
      } while (_refreshRequested && !_isDisposed);
    } catch (error, stackTrace) {
      _recordError('Erro ao observar vendas locais', error, stackTrace);
      _notifyListeners();
    } finally {
      _refreshInProgress = false;
    }
  }

  Future<void> _refreshSales() async {
    final localSales = await _isar.vendaLocals
        .filter()
        .empresaIdEqualTo(_empresaId)
        .sortByDataVendaDesc()
        .findAll();
    final customers = await _isar.clienteLocals
        .filter()
        .empresaIdEqualTo(_empresaId)
        .findAll();
    final products = await _isar.produtoLocals
        .filter()
        .empresaIdEqualTo(_empresaId)
        .findAll();
    final allItems = await _isar.itemVendaLocals
        .filter()
        .empresaIdEqualTo(_empresaId)
        .findAll();
    final allInstallments = await _isar.parcelaLocals
        .filter()
        .empresaIdEqualTo(_empresaId)
        .sortByNumeroParcela()
        .findAll();
    final customersById = {for (final item in customers) item.id: item};
    final productsById = {for (final item in products) item.id: item};
    final itemsBySale = <int, List<ItemVendaLocal>>{};
    for (final item in allItems) {
      final saleId = item.vendaLocalId;
      if (saleId != null) {
        itemsBySale.putIfAbsent(saleId, () => []).add(item);
      }
    }
    final installmentsBySale = <int, List<ParcelaLocal>>{};
    for (final installment in allInstallments) {
      final saleId = installment.vendaLocalId;
      if (saleId != null) {
        installmentsBySale.putIfAbsent(saleId, () => []).add(installment);
      }
    }
    final snapshots = <_SaleSnapshot>[];

    for (final sale in localSales) {
      ClienteLocal? customer = sale.clienteLocalId == null
          ? null
          : customersById[int.tryParse(sale.clienteLocalId!)];
      customer ??= await _loadCustomerFallback(sale);
      var items = itemsBySale[sale.id] ?? const <ItemVendaLocal>[];
      if (items.isEmpty) {
        items = await _isar.itemVendaLocals
            .filter()
            .venda((query) => query.idEqualTo(sale.id))
            .findAll();
      }
      final itemSnapshots = <_ItemSnapshot>[];
      for (final item in items) {
        ProdutoLocal? product = item.produtoLocalId == null
            ? null
            : productsById[item.produtoLocalId];
        if (product == null) {
          await item.produto.load();
          product = item.produto.value;
        }
        itemSnapshots.add(_ItemSnapshot(item, product));
      }
      var installments = installmentsBySale[sale.id] ?? const <ParcelaLocal>[];
      if (installments.isEmpty) {
        installments = await _isar.parcelaLocals
            .filter()
            .venda((query) => query.idEqualTo(sale.id))
            .sortByNumeroParcela()
            .findAll();
      }
      snapshots.add(
        _SaleSnapshot(
          sale,
          customer,
          itemSnapshots,
          installments,
        ),
      );
    }

    if (_isDisposed) return;
    _snapshots = snapshots;
    _sales = snapshots.map(_saleModel).toList();
    final now = DateTime.now();
    final offlineCutoff = DateTime(now.year - 1, now.month, now.day);
    _salesHistory = snapshots
        .where((snapshot) => !snapshot.sale.dataVenda.isBefore(offlineCutoff))
        .map(_saleHistoryMap)
        .toList();
    _receivables = snapshots
        .expand(_receivableMaps)
        .where((installment) => installment['status'] != 'pago')
        .toList();
    _customerInsightsCache = _buildCustomerInsights(snapshots);
  }

  Future<ClienteLocal?> _loadCustomerFallback(VendaLocal sale) async {
    await sale.cliente.load();
    return sale.cliente.value;
  }

  VendaModel _saleModel(_SaleSnapshot snapshot) {
    final pending = snapshot.installments.any(
      (installment) => installment.status != 'pago',
    );
    return VendaModel(
      localId: snapshot.sale.id.toString(),
      id: snapshot.sale.supabaseId,
      clienteId: snapshot.customer?.id.toString() ?? '',
      clienteNome: snapshot.customer?.nome,
      dataVenda: snapshot.sale.dataVenda,
      valorTotal: snapshot.sale.valorTotal,
      valorEntrada: snapshot.sale.valorEntrada,
      desconto: snapshot.sale.desconto,
      tipoPagamento: snapshot.sale.tipoPagamento,
      observacoes: snapshot.sale.observacoes,
      status: pending ? 'pendente' : 'pago',
      legacyId: snapshot.sale.legacyId,
    );
  }

  Map<String, dynamic> _saleHistoryMap(_SaleSnapshot snapshot) {
    return {
      'local_id': snapshot.sale.id.toString(),
      'id': snapshot.sale.supabaseId,
      'data_venda': snapshot.sale.dataVenda.toIso8601String(),
      'valor_total': snapshot.sale.valorTotal,
      'tipo_pagamento': snapshot.sale.tipoPagamento,
      'clientes': {
        'local_id': snapshot.customer?.id.toString(),
        'nome': snapshot.customer?.nome ?? 'Cliente não informado',
        'celular': snapshot.customer?.celular ?? '',
      },
      'itens_venda': snapshot.items.map(_itemMap).toList(),
      'parcelas': snapshot.installments.map(_installmentMap).toList(),
    };
  }

  Map<String, dynamic> _itemMap(_ItemSnapshot snapshot) {
    return {
      'local_id': snapshot.item.id.toString(),
      'id': snapshot.item.supabaseId,
      'quantidade': snapshot.item.quantidade,
      'preco_unitario': snapshot.item.precoUnitario,
      'custo_unitario': snapshot.item.custoUnitario,
      'produtos': {
        'local_id': snapshot.product?.id.toString(),
        'nome': snapshot.product?.nome ?? 'Produto excluído',
        'categoria': snapshot.product?.categoria ?? '',
      },
    };
  }

  Map<String, dynamic> _installmentMap(ParcelaLocal installment) {
    return {
      'local_id': installment.id.toString(),
      'id': installment.supabaseId,
      'numero_parcela': installment.numeroParcela,
      'valor': installment.valor,
      'data_vencimento': installment.dataVencimento.toIso8601String(),
      'data_pagamento': installment.dataPagamento?.toIso8601String(),
      'status': installment.status,
    };
  }

  Iterable<Map<String, dynamic>> _receivableMaps(_SaleSnapshot snapshot) {
    final saleMap = _saleHistoryMap(snapshot);
    return snapshot.installments.map((installment) {
      return {
        ..._installmentMap(installment),
        'venda_id': snapshot.sale.id.toString(),
        'vendas': saleMap,
      };
    });
  }

  Map<String, Map<String, dynamic>> _buildCustomerInsights(
    List<_SaleSnapshot> snapshots,
  ) {
    final insights = <String, Map<String, dynamic>>{};
    final categoryCounts = <String, Map<String, int>>{};
    final paymentCounts = <String, Map<String, int>>{};
    final now = DateTime.now();

    for (final snapshot in snapshots) {
      final customerId = snapshot.customer?.id.toString();
      if (customerId == null) continue;
      final result = insights.putIfAbsent(customerId, _emptyInsights);
      result['totalComprado'] =
          (result['totalComprado'] as double) + snapshot.sale.valorTotal;

      final payments = paymentCounts.putIfAbsent(customerId, () => {});
      payments[snapshot.sale.tipoPagamento] =
          (payments[snapshot.sale.tipoPagamento] ?? 0) + 1;

      final categories = categoryCounts.putIfAbsent(customerId, () => {});
      for (final item in snapshot.items) {
        final category = item.product?.categoria ?? '';
        if (category.isNotEmpty) {
          categories[category] =
              (categories[category] ?? 0) + item.item.quantidade;
        }
      }

      for (final installment in snapshot.installments) {
        if (installment.status == 'pago') continue;
        result['totalPendente'] =
            (result['totalPendente'] as double) + installment.valor;
        if (installment.dataVencimento.isBefore(now)) {
          result['totalAtrasos'] = (result['totalAtrasos'] as int) + 1;
        }
      }
    }

    for (final entry in insights.entries) {
      entry.value['tipoMaisComprado'] =
          _mostFrequent(categoryCounts[entry.key]) ?? '-';
      entry.value['tipoPagamentoMaisUsado'] =
          _mostFrequent(paymentCounts[entry.key]) ?? '-';
    }
    return insights;
  }

  Map<String, dynamic> _customerHistoryMap(_SaleSnapshot snapshot) {
    final productNames = snapshot.items
        .map((item) => item.product?.nome ?? 'Produto excluído')
        .join(', ');
    return {
      'produto': productNames,
      'data': snapshot.sale.dataVenda.toIso8601String(),
      'valor': snapshot.sale.valorTotal,
      'tipo_pagamento': snapshot.sale.tipoPagamento,
      'numero_parcela': snapshot.installments.length,
    };
  }

  Map<String, dynamic> _emptyInsights() {
    return {
      'totalComprado': 0.0,
      'tipoMaisComprado': '-',
      'tipoPagamentoMaisUsado': '-',
      'totalPendente': 0.0,
      'totalAtrasos': 0,
    };
  }

  String? _mostFrequent(Map<String, int>? values) {
    if (values == null || values.isEmpty) return null;
    return values.entries.reduce((first, second) {
      return second.value > first.value ? second : first;
    }).key;
  }

  int _requiredLocalId(String? value, String name) {
    final localId = int.tryParse(value ?? '');
    if (localId == null || localId <= 0) {
      throw ArgumentError.value(value, name, 'Identificador local inválido.');
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
    _recordError('Erro ao observar vendas locais', error, stackTrace);
    _notifyListeners();
  }

  void _notifyListeners() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    for (final subscription in _subscriptions) {
      unawaited(subscription.cancel());
    }
    super.dispose();
  }
}

class _SaleSnapshot {
  const _SaleSnapshot(
    this.sale,
    this.customer,
    this.items,
    this.installments,
  );

  final VendaLocal sale;
  final ClienteLocal? customer;
  final List<_ItemSnapshot> items;
  final List<ParcelaLocal> installments;
}

class _ItemSnapshot {
  const _ItemSnapshot(this.item, this.product);

  final ItemVendaLocal item;
  final ProdutoLocal? product;
}
