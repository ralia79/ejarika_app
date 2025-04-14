import 'package:intl/intl.dart';

String formatToToman(double number) {
  final formatter = NumberFormat.decimalPattern('fa');
  return '${formatter.format(number)} تومان';
}
