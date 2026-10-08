import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Snackbars fired outside a route context (e.g. session-expired listener,
/// state controllers) — wired as the app's `scaffoldMessengerKey`.
final rootMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Toast/snackbar helper — floating snackbar themed via `snackBarTheme`.
abstract final class AppToast {
  /// Toast without a widget context; a no-op before the app has mounted.
  static void global(String message, {bool isError = false}) {
    final context = rootMessengerKey.currentContext;
    if (context != null && context.mounted) show(context, message, isError: isError);
  }

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
