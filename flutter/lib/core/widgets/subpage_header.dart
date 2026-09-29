import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_interactive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Shared sub-page header matching the old web UI pattern:
/// `flex items-center gap-2 border-b border-border/60 px-3 py-1.5`
/// with a ghost "← Back to chat" button, an optional icon+title group and a
/// free-form slot for selectors/actions.
class SubpageHeader extends StatelessWidget {
  const SubpageHeader({
    super.key,
    this.title,
    this.icon,
    this.backLabel = 'Back to chat',
    this.backRoute = '/workspace',
    this.showBack = true,
    this.children = const [],
    this.trailing = const [],
  });

  final String? title;
  final IconData? icon;
  final String backLabel;

  /// Route for the back button — `/workspace` is the new app's chat home
  /// (old app navigates to `/`).
  final String backRoute;
  final bool showBack;

  /// Widgets placed right after the title group (e.g. project selectors).
  final List<Widget> children;

  /// Right-aligned action widgets.
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = context.appColors;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: c.border.withValues(alpha: 0.6)),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 6,
      ),
      child: Row(
        spacing: AppSpacing.sm,
        children: [
          if (showBack)
            AppInteractive(
              onTap: () => context.go(backRoute),
              borderRadius: AppRadii.borderMd,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: AppSpacing.xs,
                  children: [
                    Icon(LucideIcons.arrowLeft, size: 16, color: c.foreground),
                    Text(backLabel, style: t.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
          if (title != null || icon != null)
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                if (icon != null)
                  Icon(icon, size: 16, color: c.mutedForeground),
                if (title != null)
                  Text(
                    title!,
                    style: t.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ...children,
          const Spacer(),
          ...trailing,
        ],
      ),
    );
  }
}
