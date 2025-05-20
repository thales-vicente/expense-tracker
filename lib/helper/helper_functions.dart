/*
These are some helpful functions used across the app
 */

// TODO convert string to a double
import 'package:intl/intl.dart';

double convertStringToDouble(String string) {
  double? amount = double.tryParse(string);
  return amount ?? 0;
}

// TODO format double into dollars & cents
String formatAmount(double amount) {
  final format = NumberFormat.currency(
    locale: "en_US",
    symbol: "\$",
    decimalDigits: 2,
  );
  return format.format(amount);
}

// TODO calculate the number of months since the first start month
int calculateMonthCount(int startYear, startMonth, currentYear, currentMonth) {
  int monthCount =
      (currentYear - startYear) * 12 + currentMonth - startMonth + 1;
  return monthCount;
}
