import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

enum SnackbarStatus { success, error, warning, nothing }

void showMySnackBar(
    BuildContext context, String message, SnackbarStatus status) {
  late Color snackbarColor;
  switch (status) {
    case SnackbarStatus.success:
      snackbarColor = Colors.greenAccent;
      break;
    case SnackbarStatus.error:
      snackbarColor = colorScheme.error;
      break;
    case SnackbarStatus.warning:
      snackbarColor = Colors.orangeAccent;
      break;
    case SnackbarStatus.nothing:
      snackbarColor = Colors.grey.shade200;
      break;
    default:
      snackbarColor = colorScheme.primaryContainer;
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: snackbarColor,
      padding: const EdgeInsets.all(25.0),
      margin: const EdgeInsets.all(10),
      behavior: SnackBarBehavior.floating,
      content: Text(message,
          style: textStyle.bodyLarge?.copyWith(
            color: status == SnackbarStatus.error
                ? colorScheme.onError
                : colorScheme.onPrimary,
          )),
    ),
  );
}
