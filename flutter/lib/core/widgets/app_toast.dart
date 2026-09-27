import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Toast/snackbar helper — floating snackbar themed via `snackBarTheme`.
abstract final class AppToast {
  static void show(BuildContext context, String message, {bool isError = false}) {
    final c = context.appColors;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(color: isError ? c.destructiveForeground : c.popoverForeground),
          ),
          backgroundColor: isError ? c.destructive : c.popover,
        ),
      );
  }

  static void error(BuildContext context, String message) => show(context, message, isError: true);
}
