import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_gateway.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._gateway);

  final AuthGateway _gateway;
  StreamSubscription<User?>? _authSubscription;

  User? _user;
  String? _errorMessage;
  bool _isLoading = false;
  bool _started = false;
  bool _disposed = false;

  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  void start() {
    if (_started) return;
    _started = true;
    _user = _gateway.currentUser;
    _authSubscription = _gateway.authStateChanges.listen(
      _handleAuthChange,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Falha ao observar a sessão autenticada: $error');
        debugPrintStack(stackTrace: stackTrace);
      },
    );
    _notifySafely();
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    if (_isLoading) return false;
    _setLoading(true);
    _errorMessage = null;
    try {
      _user = await _gateway.signIn(
        email: email.trim(),
        password: password,
      );
      return true;
    } catch (error) {
      _errorMessage = _messageFor(error);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> refreshSession() async {
    if (_isLoading) return false;
    _setLoading(true);
    _errorMessage = null;
    try {
      _user = await _gateway.refreshSession();
      if (_user == null) {
        _errorMessage = 'Sua sessão expirou. Entre novamente para continuar.';
        return false;
      }
      return true;
    } catch (error) {
      _errorMessage = _messageFor(error);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signOut() async {
    if (_isLoading) return false;
    _setLoading(true);
    _errorMessage = null;
    try {
      await _gateway.signOut();
      _user = null;
      return true;
    } catch (error) {
      _errorMessage = _messageFor(error);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
    _notifySafely();
  }

  void _handleAuthChange(User? user) {
    _user = user;
    if (user != null) _errorMessage = null;
    _notifySafely();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    _notifySafely();
  }

  String _messageFor(Object error) {
    if (error is AuthRetryableFetchException) {
      return 'Não foi possível acessar o servidor. Verifique sua conexão.';
    }
    if (error is AuthException) {
      final code = error.code?.toLowerCase();
      final message = error.message.toLowerCase();
      if (code == 'invalid_credentials' ||
          message.contains('invalid login credentials')) {
        return 'E-mail ou senha inválidos.';
      }
      if (code == 'email_not_confirmed' ||
          message.contains('email not confirmed')) {
        return 'Confirme seu e-mail antes de entrar.';
      }
      if (code == 'over_request_rate_limit' || error.statusCode == '429') {
        return 'Muitas tentativas. Aguarde um momento e tente novamente.';
      }
    }
    return 'Não foi possível concluir a autenticação. Tente novamente.';
  }

  void _notifySafely() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _authSubscription?.cancel();
    super.dispose();
  }
}
