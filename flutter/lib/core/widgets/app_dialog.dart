import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';

/// Modal dialog — popover surface, lg radius.
class AppDialog extends StatelessWidget {
  const AppDialog({super.key, required this.title, required this.content, this.actions = const []});

  final String title;
  final Widget content;
  final List<Widget> actions;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget content,
    List<Widget> actions = const [],
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => AppDialog(title: title, content: content, actions: actions),
    );
  }

  /// Closes a dialog opened by [show] with an optional [result].
  ///
  /// [show] pushes on the root navigator (`showDialog`'s `useRootNavigator`
  /// default), but callers' action buttons only hold the page context. In the
  /// shell layout (see `ShellRoute`) the nearest navigator is the shell's
  /// inner one, so `Navigator.of(context).pop()` would pop the page underneath
  /// and leave the dialog — and its awaiting `show` future — stuck. Always pop
  /// the dialog through this helper instead.
  static void pop(BuildContext context, [Object? result]) {
    Navigator.of(context, rootNavigator: true).pop(result);
  }

  /// Confirm dialog with Cancel/Confirm — resolves to true on confirm.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
  }) async {
    final t = Translations.of(context);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: title,
        content: Text(message),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.chat.orchestrator.summary.cancelTasks),
          ),
          AppButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(confirmLabel)),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      content: content,
      actions: actions,
      actionsPadding: const EdgeInsets.all(AppSpacing.lg),
    );
  }
}
