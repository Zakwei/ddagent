import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Snackbars fired outside a route context (e.g. session-expired listener,
/// state controllers) — wired as the app's `scaffoldMessengerKey`.
final rootMessengerKey = GlobalKey<ScaffoldMessengerState>();

/// Toast/snackbar helper — floating snackbar themed via `snackBarTheme`.
abstract final class AppToast {
  /// Toast without a widget context; a no-op before the app has mounted.
  /// Talks to the root messenger directly — its own context has no
  /// ScaffoldMessenger above it to look up.
  static void global(String message, {bool isError = false}) {
    final messenger = rootMessengerKey.currentState;
    if (messenger == null || !messenger.mounted) return;
    _showOn(messenger, message, isError: isError);
  }

  static void show(BuildContext context, String message, {bool isError = false}) =>
      _showOn(ScaffoldMessenger.of(context), message, isError: isError);

  static void _showOn(ScaffoldMessengerState messenger, String message, {required bool isError}) {
    final context = messenger.context;
    // The root messenger sits above the app's Theme (MaterialApp builds it
    // outside), so its context finds no AppColors — fall back by brightness.
    final c =
        Theme.of(context).extension<AppColors>() ??
        (MediaQuery.maybePlatformBrightnessOf(context) == Brightness.dark
            ? AppColors.dark
            : AppColors.light);
    messenger
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
