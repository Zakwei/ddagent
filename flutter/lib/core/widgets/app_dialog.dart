import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
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

  /// Confirm dialog with Cancel/Confirm — resolves to true on confirm.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: title,
        content: Text(message),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
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
