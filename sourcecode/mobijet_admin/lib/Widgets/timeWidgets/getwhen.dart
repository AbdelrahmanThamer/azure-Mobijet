import 'package:intl/intl.dart';

getWhen(date) {
  DateTime now = DateTime.now();
  String when;
  if (date.day == now.day)
    when = 'Today';
  else if (date.day == now.subtract(Duration(days: 1)).day)
    when = 'Yesterday';
  else
    when = DateFormat.MMMd().format(date);
  return when;
}
