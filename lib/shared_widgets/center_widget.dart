import 'package:flutter/material.dart';
import 'package:task_manager/services/navigation_service.dart';

Column centerWidget(Widget widget) {
  print('centerWidget');
  return Column(
    children: [
      SizedBox(
          height:
              MediaQuery.of(NavigationService.currentContext!).size.height / 5),
      widget,
    ],
  );
}
