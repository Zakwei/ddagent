import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Section header + body — port of the web settings `SettingsSection`
/// (title + optional description + children, sections spaced by `space-y-8`).
class SettingsSectionBlock extends StatelessWidget {
  const SettingsSectionBlock({
    super.key,
    required this.title,
    this.description,
    this.icon,
    required this.children,
  });

  final String title;
  final String? description;
  final IconData? icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: c.foreground),
              const SizedBox(width: AppSpacing.sm),
            ],
            Flexible(child: Text(title, style: tt.titleMedium)),
          ],
        ),
        if (description != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            description!,
            style: tt.bodySmall?.copyWith(color: c.mutedForeground),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        ...children,
      ],
    );
  }
}

/// Label + optional description on the left, control on the right — port of
/// the web `SettingsRow`.
class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.label,
    this.description,
    required this.child,
  });

  final String label;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: tt.bodyMedium),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(child: child),
        ],
      ),
    );
  }
}
