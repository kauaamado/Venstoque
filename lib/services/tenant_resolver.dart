import 'package:supabase_flutter/supabase_flutter.dart';

class TenantResolution {
  const TenantResolution._({this.empresaId, this.message});

  const TenantResolution.success(String empresaId)
      : this._(empresaId: empresaId);

  const TenantResolution.failure(String message) : this._(message: message);

  final String? empresaId;
  final String? message;

  bool get isValid => empresaId != null;
}

class TenantResolver {
  static final RegExp _uuidPattern = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-'
    r'[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  );

  static TenantResolution resolve(User? user) {
    return resolveMetadata(
      isAuthenticated: user != null,
      appMetadata: user?.appMetadata ?? const {},
    );
  }

  static TenantResolution resolveMetadata({
    required bool isAuthenticated,
    required Map<String, dynamic> appMetadata,
  }) {
    if (!isAuthenticated) {
      return const TenantResolution.failure(
        'Não há uma sessão autenticada. Entre novamente para continuar.',
      );
    }

    final empresaId = appMetadata['empresa_id']?.toString().trim();
    if (empresaId == null || !_uuidPattern.hasMatch(empresaId)) {
      return const TenantResolution.failure(
        'A empresa deste usuário não está configurada corretamente. '
        'Entre em contato com o administrador.',
      );
    }
    return TenantResolution.success(empresaId);
  }
}
