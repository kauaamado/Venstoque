import 'package:flutter_test/flutter_test.dart';
import 'package:venstoque/utils/formatters.dart';

void main() {
  group('WhatsAppHelper', () {
    test('normaliza celular brasileiro e não duplica o DDI', () {
      final local = WhatsAppHelper.buildConversationUri('(21) 99999-9999');
      final international = WhatsAppHelper.buildConversationUri(
        '+55 21 99999-9999',
      );

      expect(local.host, 'api.whatsapp.com');
      expect(local.queryParameters['phone'], '5521999999999');
      expect(international.queryParameters['phone'], '5521999999999');
    });

    test('codifica a mensagem usando parâmetros da URI', () {
      final uri = WhatsAppHelper.buildConversationUri(
        '21999999999',
        mensagem: 'Olá!\nTudo bem?',
      );

      expect(uri.queryParameters['phone'], '5521999999999');
      expect(uri.queryParameters['text'], 'Olá!\nTudo bem?');
    });

    test('rejeita celular vazio, incompleto ou fictício', () {
      expect(
        () => WhatsAppHelper.buildConversationUri(''),
        throwsA(isA<WhatsAppException>()),
      );
      expect(
        () => WhatsAppHelper.buildConversationUri('219999'),
        throwsA(isA<WhatsAppException>()),
      );
      expect(
        () => WhatsAppHelper.buildConversationUri('00000000000'),
        throwsA(isA<WhatsAppException>()),
      );
    });
  });
}
