import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Desktop affordances for a tappable region (3.6):
/// hover tint (`accent`), focus ring (`ring`), keyboard activation
/// via Enter/Space, pointer cursor.
class AppInteractive extends StatefulWidget {
  const AppInteractive({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius = AppRadii.borderMd,
    this.focusNode,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final FocusNode? focusNode;

  @override
  State<AppInteractive> createState() => _AppInteractiveState();
}

class _AppInteractiveState extends State<AppInteractive> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return FocusableActionDetector(
      focusNode: widget.focusNode,
      enabled: widget.onTap != null,
      mouseCursor: widget.onTap != null
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onShowFocusHighlight: (v) => setState(() => _focused = v),
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
        SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
      },
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) => widget.onTap?.call(),
        ),
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: AppMotion.hover,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            border: _focused ? Border.all(color: c.ring, width: 2) : null,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// App-wide keyboard shortcut infra — bind activators at the shell level
/// (see features/*/ui shells in later tasks). The intent carries the callback
/// because Actions dispatch by intent *type*.
class AppIntent extends Intent {
  const AppIntent(this.invoke);

  final VoidCallback invoke;
}

/// Binds [bindings] (SingleActivator → callback) around [child].
class AppShortcuts extends StatelessWidget {
  const AppShortcuts({super.key, required this.bindings, required this.child});

  final Map<SingleActivator, VoidCallback> bindings;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {for (final e in bindings.entries) e.key: AppIntent(e.value)},
      child: Actions(
        actions: {
          AppIntent: CallbackAction<AppIntent>(
            onInvoke: (intent) {
              intent.invoke();
              return null;
            },
          ),
        },
        child: Focus(autofocus: true, child: child),
      ),
    );
  }
}
