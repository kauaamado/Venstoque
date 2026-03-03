import 'package:intl/intl.dart';

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
