import 'package:flutter/material.dart';
import 'package:task_manager/enums/snackbar_status_enum.dart';

import '../services/navigation_service.dart';

class SnackBarShared {
  void circular(String text, SnackBarStatus status) {
    ScaffoldMessenger.of(NavigationService.currentContext!)
        .removeCurrentSnackBar();
    ScaffoldMessenger.of(NavigationService.currentContext!).showSnackBar(
        SnackBar(
            content: Text(text),
            behavior: SnackBarBehavior.floating,
            showCloseIcon: true,
            backgroundColor: status == SnackBarStatus.success
                ? Colors.green
                : status == SnackBarStatus.error
                    ? Colors.red
                    : Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)))));
  }
}
