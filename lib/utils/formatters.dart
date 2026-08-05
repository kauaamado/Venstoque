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
    // Remove caracteres não numéricos
    String fone = telefone.replaceAll(RegExp(r'[^\d]'), '');
    // Adiciona o DDI 55 se não tiver
    if (fone.length <= 11) fone = '55$fone';

    // Mudança aqui: Usando a API direta em vez do wa.me
    final String textEncoded = Uri.encodeComponent(mensagem);
    final Uri url = Uri.parse(
        "https://api.whatsapp.com/send?phone=$fone&text=$textEncoded");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Não foi possível abrir o WhatsApp');
    }
  }
}
