import 'package:flutter_test/flutter_test.dart';
import 'package:venstoque/services/tenant_resolver.dart';

void main() {
  const empresaId = '07039448-04c1-4ecd-94f0-65176475868c';

  test('resolve tenant válido dos metadados autenticados', () {
    final result = TenantResolver.resolveMetadata(
      isAuthenticated: true,
      appMetadata: const {'empresa_id': empresaId},
    );

    expect(result.isValid, isTrue);
    expect(result.empresaId, empresaId);
    expect(result.message, isNull);
  });

  test('bloqueia sessão ausente', () {
    final result = TenantResolver.resolveMetadata(
      isAuthenticated: false,
      appMetadata: const {},
    );

    expect(result.isValid, isFalse);
    expect(result.message, contains('sessão autenticada'));
  });

  test('bloqueia empresa ausente ou inválida', () {
    final missing = TenantResolver.resolveMetadata(
      isAuthenticated: true,
      appMetadata: const {},
    );
    final invalid = TenantResolver.resolveMetadata(
      isAuthenticated: true,
      appMetadata: const {'empresa_id': 'empresa-inválida'},
    );

    expect(missing.isValid, isFalse);
    expect(invalid.isValid, isFalse);
  });
}
