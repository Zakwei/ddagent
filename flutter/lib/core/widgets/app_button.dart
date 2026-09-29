import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';

enum AppButtonVariant { primary, secondary, destructive, outline, ghost }

enum AppButtonSize { sm, md, lg }

/// Button matching the web UI variants (primary/secondary/destructive/ghost).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.md,
    this.loading = false,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final (bg, fg, border) = switch (variant) {
      AppButtonVariant.primary => (
        c.primary,
        c.primaryForeground,
        Colors.transparent,
      ),
      AppButtonVariant.secondary => (
        c.secondary,
        c.secondaryForeground,
        Colors.transparent,
      ),
      AppButtonVariant.destructive => (
        c.destructive,
        c.destructiveForeground,
        Colors.transparent,
      ),
      // `outline` — border-input bg-background shadow-sm.
      AppButtonVariant.outline => (c.background, c.foreground, c.input),
      // `ghost` — no chrome, hover bg-accent only.
      AppButtonVariant.ghost => (
        Colors.transparent,
        c.foreground,
        Colors.transparent,
      ),
    };
    final padding = switch (size) {
      AppButtonSize.sm => const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      AppButtonSize.md => const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      AppButtonSize.lg => const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
    };
    final effectiveOnPressed = loading ? null : onPressed;

    return TextButton(
      onPressed: effectiveOnPressed,
      style: TextButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        disabledBackgroundColor: bg.withValues(alpha: 0.5),
        padding: padding,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.borderMd,
          side: BorderSide(color: border),
        ),
      ),
      child: loading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: fg),
            )
          : child,
    );
  }
}
