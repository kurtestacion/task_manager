import 'package:flutter/material.dart';

import '../services/navigation_service.dart';

Future<DateTime> datePicker(DateTime initialDate) async {
  var realDate = DateTime.now();
  var dateResult = await showDatePicker(
      context: NavigationService.currentContext!,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: initialDate.add(const Duration(days: 1825)));

  if (dateResult != null) {
    final time = await showTimePicker(
        context: NavigationService.currentContext!,
        initialTime: TimeOfDay.fromDateTime(initialDate));
    if (time == null) {
      return DateTime.now();
    }
    realDate = DateTime(dateResult.year, dateResult.month, dateResult.day,
        time.hour, time.minute, 0);
  } else {
    return initialDate;
  }
  return realDate;
}
