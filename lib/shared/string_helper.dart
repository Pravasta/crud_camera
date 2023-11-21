import 'package:intl/intl.dart';

String formatNumber(double number) {
  if (number == number.toInt() && number % 1 == 0 && number < 100000) {
    return NumberFormat('#,###', 'id_ID').format(number);
  } else if (number >= 100000) {
    double formattedNumber = number / 1000;
    String formattedString = formattedNumber.toStringAsFixed(1);

    if (formattedString.endsWith('.0')) {
      formattedString =
          formattedString.substring(0, formattedString.length - 2);
    }
    return "${formattedString}K";
  } else {
    return number.toString();
  }
}
