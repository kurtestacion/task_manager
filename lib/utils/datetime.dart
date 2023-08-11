import 'package:intl/intl.dart';

String milSecSinceEpochToString(String date) {
  var newDate = DateTime.fromMillisecondsSinceEpoch((int.parse(date)));
  return DateFormat('MMMM, d yyyy hh:mm aa').format(newDate);
}

DateTime milSecSinceEpochToDateTime(String date) {
  var newDate = DateTime.fromMillisecondsSinceEpoch((int.parse(date)));
  return newDate;
}
