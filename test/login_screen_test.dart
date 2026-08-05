import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:venstoque/providers/auth_controller.dart';
import 'package:venstoque/screens/auth/login_screen.dart';
import 'package:venstoque/services/auth_gateway.dart';

void main() {
  testWidgets('valida os campos antes de tentar entrar', (tester) async {
    final gateway = _FakeAuthGateway();
    final controller = AuthController(gateway)..start();
    await tester.pumpWidget(_app(controller));

    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pump();

    expect(find.text('Informe seu e-mail.'), findsOneWidget);
    expect(find.text('Informe sua senha.'), findsOneWidget);
    expect(gateway.signInCalls, 0);

    controller.dispose();
    await gateway.close();
  });

  testWidgets('exibe erro amigável para credenciais inválidas', (tester) async {
    final gateway = _FakeAuthGateway(
      signInError: const AuthException(
        'Invalid login credentials',
        code: 'invalid_credentials',
      ),
    );
    final controller = AuthController(gateway)..start();
    await tester.pumpWidget(_app(controller));

    await tester.enterText(
      find.widgetWithText(TextFormField, 'E-mail'),
      'usuario@exemplo.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Senha'),
      'senha-incorreta',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('E-mail ou senha inválidos.'), findsOneWidget);
    expect(gateway.signInCalls, 1);

    controller.dispose();
    await gateway.close();
  });
}

Widget _app(AuthController controller) {
  return ChangeNotifierProvider.value(
    value: controller,
    child: const MaterialApp(home: LoginScreen()),
  );
}

class _FakeAuthGateway implements AuthGateway {
  _FakeAuthGateway({this.signInError});

  final StreamController<User?> _controller =
      StreamController<User?>.broadcast();
  final Object? signInError;
  int signInCalls = 0;

  @override
  User? get currentUser => null;

  @override
  Stream<User?> get authStateChanges => _controller.stream;

  Future<void> close() => _controller.close();

  @override
  Future<User?> refreshSession() async => null;

  @override
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    final error = signInError;
    if (error != null) throw error;
    throw StateError('Este fake deve ser configurado com uma falha.');
  }

  @override
  Future<void> signOut() async {}
}
