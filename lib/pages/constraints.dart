import 'package:intl/intl.dart';

String formatMoney(int price) {
  return NumberFormat.currency(locale: 'vi').format(price);
}