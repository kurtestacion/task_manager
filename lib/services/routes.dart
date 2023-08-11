import 'package:flutter/material.dart';

import '../modules/task/screens/task_details_screen.dart';
import '../modules/task/screens/task_screen.dart';

routes() {
  return {
    '/': (context) => const TaskScreen(),
    'task_details': (context) => const TaskDetailsScreen(),
  };
}

class Routes {
  Route animatedRoute(Widget widget) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => widget,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
