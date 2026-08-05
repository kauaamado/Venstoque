import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthGateway {
  User? get currentUser;

  Stream<User?> get authStateChanges;

  Future<User> signIn({
    required String email,
    required String password,
  });

  Future<User?> refreshSession();

  Future<void> signOut();
}

class SupabaseAuthGateway implements AuthGateway {
  SupabaseAuthGateway({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  User? get currentUser => _client.auth.currentUser;

  @override
  Stream<User?> get authStateChanges => _client.auth.onAuthStateChange.map(
        (state) => state.session?.user,
      );

  @override
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) {
      throw const AuthException(
        'O Supabase não retornou o usuário autenticado.',
      );
    }
    return user;
  }

  @override
  Future<User?> refreshSession() async {
    final response = await _client.auth.refreshSession();
    return response.user;
  }

  @override
  Future<void> signOut() {
    return _client.auth.signOut(scope: SignOutScope.local);
  }
}
