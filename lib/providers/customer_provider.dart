import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:isar_community/isar.dart';

import '../models/cliente_model.dart';
import '../models/local/cliente_model.dart';
import '../models/local/venda_model.dart';

enum CustomerDeleteResult { deleted, deactivated }

class CustomerProvider with ChangeNotifier {
  CustomerProvider(this._isar, {required String empresaId})
      : _empresaId = empresaId.trim() {
    if (_empresaId.isEmpty) {
      throw ArgumentError.value(
        empresaId,
        'empresaId',
        'O identificador da empresa não pode ser vazio.',
      );
    }

    _customerSubscription =
        _isar.clienteLocals.watchLazy(fireImmediately: true).listen(
              (_) => unawaited(_refreshFromWatcher()),
              onError: _handleWatcherError,
            );
  }

  final Isar _isar;
  final String _empresaId;
  late final StreamSubscription<void> _customerSubscription;

  List<ClienteModel> _customers = [];
  bool _isLoading = false;
  bool _isDisposed = false;
  int _refreshVersion = 0;
  String? _errorMessage;

  List<ClienteModel> get customers => List.unmodifiable(_customers);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCustomers() async {
    _setLoading(true);
    try {
      await _refreshCustomers();
      _errorMessage = null;
    } catch (error, stackTrace) {
      _recordError('Erro ao carregar clientes locais', error, stackTrace);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addCustomer(ClienteModel cliente) async {
    if (cliente.localId != null) {
      await updateCustomer(cliente);
      return;
    }

    await _runMutation('Erro ao salvar cliente local', () async {
      final local = ClienteLocal()
        ..supabaseId = null
        ..empresaId = _empresaId;
      _applyModel(local, cliente);

      await _isar.writeTxn(() => _isar.clienteLocals.put(local));
    });
  }

  Future<void> updateCustomer(ClienteModel cliente) async {
    final localId = _requiredLocalId(cliente.localId);

    await _runMutation('Erro ao atualizar cliente local', () async {
      await _isar.writeTxn(() async {
        final current = await _isar.clienteLocals.get(localId);
        if (current == null || !_canUseTenant(current.empresaId)) {
          throw StateError('Cliente local não encontrado.');
        }

        _applyModel(current, cliente);
        current.empresaId ??= _empresaId;
        await _isar.clienteLocals.put(current);
      });
    });
  }

  Future<CustomerDeleteResult> deleteCustomer(String customerId) async {
    final localId = _requiredLocalId(customerId);
    late CustomerDeleteResult result;

    await _runMutation('Erro ao remover cliente local', () async {
      final linkedSales = await _isar.vendaLocals
          .filter()
          .cliente((query) => query.idEqualTo(localId))
          .count();

      await _isar.writeTxn(() async {
        final current = await _isar.clienteLocals.get(localId);
        if (current == null || !_canUseTenant(current.empresaId)) {
          throw StateError('Cliente local não encontrado.');
        }

        if (linkedSales > 0) {
          current.ativo = false;
          await _isar.clienteLocals.put(current);
          result = CustomerDeleteResult.deactivated;
        } else {
          await _isar.clienteLocals.delete(localId);
          result = CustomerDeleteResult.deleted;
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
      await _refreshCustomers();
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
      await _refreshCustomers();
      _errorMessage = null;
      _notifyListeners();
    } catch (error, stackTrace) {
      _recordError(
        'Erro ao observar clientes locais',
        error,
        stackTrace,
      );
      _notifyListeners();
    }
  }

  Future<void> _refreshCustomers() async {
    final refreshVersion = ++_refreshVersion;
    final localCustomers = await _isar.clienteLocals.where().findAll();
    if (_isDisposed || refreshVersion != _refreshVersion) return;

    final visibleCustomers = localCustomers
        .where(
          (cliente) => cliente.ativo && _canUseTenant(cliente.empresaId),
        )
        .map(_toModel)
        .toList()
      ..sort(
        (first, second) => first.nome.toLowerCase().compareTo(
              second.nome.toLowerCase(),
            ),
      );

    _customers = visibleCustomers;
  }

  ClienteModel _toModel(ClienteLocal cliente) {
    return ClienteModel(
      localId: cliente.id.toString(),
      id: cliente.supabaseId,
      nome: cliente.nome,
      celular: cliente.celular,
      referencia: cliente.referencia,
      observacoes: cliente.observacoes,
      ativo: cliente.ativo,
      legacyId: cliente.legacyId,
    );
  }

  void _applyModel(ClienteLocal local, ClienteModel cliente) {
    local
      ..nome = cliente.nome.trim()
      ..celular = cliente.celular.trim()
      ..referencia = cliente.referencia.trim()
      ..observacoes = cliente.observacoes.trim()
      ..ativo = cliente.ativo
      ..legacyId = cliente.legacyId;
  }

  int _requiredLocalId(String? value) {
    final localId = int.tryParse(value ?? '');
    if (localId == null || localId <= 0) {
      throw ArgumentError.value(
        value,
        'localId',
        'O identificador local do cliente é inválido.',
      );
    }
    return localId;
  }

  bool _canUseTenant(String? empresaId) {
    return empresaId == null || empresaId == _empresaId;
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
    _recordError(
      'Erro ao observar clientes locais',
      error,
      stackTrace,
    );
    _notifyListeners();
  }

  void _notifyListeners() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    unawaited(_customerSubscription.cancel());
    super.dispose();
  }
}
