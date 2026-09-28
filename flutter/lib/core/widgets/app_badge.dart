import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';

enum AppBadgeVariant { neutral, primary, destructive }

/// Small status pill (counts, statuses).
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.neutral,
  });

  final String label;
  final AppBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final (bg, fg) = switch (variant) {
      AppBadgeVariant.neutral => (c.muted, c.mutedForeground),
      AppBadgeVariant.primary => (c.primary, c.primaryForeground),
      AppBadgeVariant.destructive => (c.destructive, c.destructiveForeground),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 2,
      ),
      decoration: BoxDecoration(color: bg, borderRadius: AppRadii.borderSm),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: fg),
      ),
    );
  }
}
