import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Surface card — `card` bg, `border` outline, lg radius.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final content = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: AppRadii.borderLg,
        border: Border.all(color: c.border),
      ),
      child: child,
    );
    if (onTap == null) return content;
    return InkWell(
      borderRadius: AppRadii.borderLg,
      onTap: onTap,
      child: content,
    );
  }
}
