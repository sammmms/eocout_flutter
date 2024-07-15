import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

enum SnackbarStatus { success, error, warning, nothing }

class SnackbarStatusUtil {
  static Color getColor(SnackbarStatus status) {
    switch (status) {
      case SnackbarStatus.success:
        return colorScheme.primaryContainer;
      case SnackbarStatus.error:
        return Colors.redAccent;
      case SnackbarStatus.warning:
        return Colors.amberAccent;
      default:
        return Colors.grey.shade200;
    }
  }
}

void showMySnackBar(
    BuildContext context, String message, SnackbarStatus status) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: SnackbarStatusUtil.getColor(status),
      padding: const EdgeInsets.all(25.0),
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
      behavior: SnackBarBehavior.floating,
      content: Text(message,
          style: textTheme.bodyLarge?.copyWith(
            color: status == SnackbarStatus.error
                ? colorScheme.onError
                : colorScheme.onPrimary,
          )),
    ),
  );
}
