import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFormatters {
  static String formatCurrency(double value) {
    return NumberFormat.simpleCurrency(locale: 'pt_BR').format(value);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
}

class WhatsAppHelper {
  static Future<void> sendMessage(String telefone, String mensagem) async {
    final url = buildConversationUri(telefone, mensagem: mensagem);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw const WhatsAppException('Não foi possível abrir o WhatsApp.');
    }
  }

  static Future<void> openConversation(String telefone) {
    return sendMessage(telefone, '');
  }

  static Uri buildConversationUri(
    String telefone, {
    String mensagem = '',
  }) {
    final phone = _normalizeBrazilianPhone(telefone);
    return Uri.https(
      'api.whatsapp.com',
      '/send',
      {
        'phone': phone,
        if (mensagem.trim().isNotEmpty) 'text': mensagem,
      },
    );
  }

  static String _normalizeBrazilianPhone(String telefone) {
    var digits = telefone.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      throw const WhatsAppException(
        'Cadastre um celular antes de enviar uma mensagem.',
      );
    }

    if (digits.startsWith('00')) digits = digits.substring(2);

    late final String nationalNumber;
    if (digits.startsWith('55') &&
        (digits.length == 12 || digits.length == 13)) {
      nationalNumber = digits.substring(2);
    } else {
      if (digits.startsWith('0') &&
          (digits.length == 11 || digits.length == 12)) {
        digits = digits.substring(1);
      }
      nationalNumber = digits;
    }

    final hasValidLength =
        nationalNumber.length == 10 || nationalNumber.length == 11;
    final hasOnlyRepeatedDigits = nationalNumber.split('').toSet().length == 1;
    if (!hasValidLength || hasOnlyRepeatedDigits) {
      throw const WhatsAppException(
        'Informe um celular válido com DDD.',
      );
    }

    return '55$nationalNumber';
  }
}

class WhatsAppException implements Exception {
  const WhatsAppException(this.message);

  final String message;

  @override
  String toString() => message;
}
