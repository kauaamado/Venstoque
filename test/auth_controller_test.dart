import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:venstoque/providers/auth_controller.dart';
import 'package:venstoque/services/auth_gateway.dart';

void main() {
  const empresaId = '07039448-04c1-4ecd-94f0-65176475868c';
  final user = _user(empresaId: empresaId);

  test('restaura a sessão e cancela a assinatura no dispose', () async {
    final gateway = _FakeAuthGateway(currentUser: user);
    final controller = AuthController(gateway)..start();

    expect(controller.user, user);
    expect(gateway.hasAuthListener, isTrue);

    gateway.emit(null);
    await Future<void>.delayed(Duration.zero);
    expect(controller.isAuthenticated, isFalse);

    controller.dispose();
    await Future<void>.delayed(Duration.zero);
    expect(gateway.hasAuthListener, isFalse);
    await gateway.close();
  });

  test('faz login com e-mail normalizado', () async {
    final gateway = _FakeAuthGateway(signInUser: user);
    final controller = AuthController(gateway)..start();

    final success = await controller.signIn(
      email: '  usuario@exemplo.com  ',
      password: 'senha-segura',
    );

    expect(success, isTrue);
    expect(controller.user, user);
    expect(controller.isLoading, isFalse);
    expect(gateway.lastEmail, 'usuario@exemplo.com');
    expect(gateway.lastPassword, 'senha-segura');

    controller.dispose();
    await gateway.close();
  });

  test('traduz credenciais inválidas sem deixar loading ativo', () async {
    final gateway = _FakeAuthGateway(
      signInError: const AuthException(
        'Invalid login credentials',
        code: 'invalid_credentials',
      ),
    );
    final controller = AuthController(gateway)..start();

    final success = await controller.signIn(
      email: 'usuario@exemplo.com',
      password: 'senha-incorreta',
    );

    expect(success, isFalse);
    expect(controller.errorMessage, 'E-mail ou senha inválidos.');
    expect(controller.isLoading, isFalse);

    controller.dispose();
    await gateway.close();
  });

  test('logout local limpa o usuário autenticado', () async {
    final gateway = _FakeAuthGateway(currentUser: user);
    final controller = AuthController(gateway)..start();

    final success = await controller.signOut();

    expect(success, isTrue);
    expect(controller.user, isNull);
    expect(gateway.signOutCalls, 1);

    controller.dispose();
    await gateway.close();
  });
}

User _user({required String empresaId}) {
  return User(
    id: 'user-id',
    appMetadata: {'empresa_id': empresaId},
    userMetadata: const {},
    aud: 'authenticated',
    email: 'usuario@exemplo.com',
    createdAt: '2026-08-04T00:00:00.000Z',
  );
}

class _FakeAuthGateway implements AuthGateway {
  _FakeAuthGateway({
    this.currentUser,
    this.signInUser,
    this.signInError,
  });

  final StreamController<User?> _controller =
      StreamController<User?>.broadcast();

  @override
  User? currentUser;
  final User? signInUser;
  final Object? signInError;
  String? lastEmail;
  String? lastPassword;
  int signOutCalls = 0;

  bool get hasAuthListener => _controller.hasListener;

  @override
  Stream<User?> get authStateChanges => _controller.stream;

  void emit(User? user) => _controller.add(user);

  Future<void> close() => _controller.close();

  @override
  Future<User?> refreshSession() async => currentUser;

  @override
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    lastEmail = email;
    lastPassword = password;
    final error = signInError;
    if (error != null) throw error;
    return signInUser!;
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    currentUser = null;
  }
}
