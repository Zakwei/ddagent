import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/theme/typography.dart';
import 'package:flutter/material.dart';

/// Builds the light/dark ThemeData pair from the extracted tokens.
abstract final class AppTheme {
  static ThemeData light() => _build(AppColors.light, AppNavTokens.light, Brightness.light);
  static ThemeData dark() => _build(AppColors.dark, AppNavTokens.dark, Brightness.dark);

  static ThemeData _build(AppColors c, AppNavTokens nav, Brightness brightness) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.primaryForeground,
      secondary: c.secondary,
      onSecondary: c.secondaryForeground,
      error: c.destructive,
      onError: c.destructiveForeground,
      surface: c.card,
      onSurface: c.cardForeground,
      surfaceContainerHighest: c.muted,
      outline: c.border,
      outlineVariant: c.input,
    );
    final textTheme = buildTextTheme(c.foreground, c.mutedForeground);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: c.background,
      textTheme: textTheme,
      extensions: [c, nav],
      dividerColor: c.border,
      splashFactory: InkRipple.splashFactory,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.foreground,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: c.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.borderLg,
          side: BorderSide(color: c.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.card,
        hintStyle: TextStyle(color: c.mutedForeground),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadii.borderMd,
          borderSide: BorderSide(color: c.input),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.borderMd,
          borderSide: BorderSide(color: c.input),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.borderMd,
          borderSide: BorderSide(color: c.ring, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadii.borderMd,
          borderSide: BorderSide(color: c.destructive),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.popover,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.borderLg),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.popover,
        contentTextStyle: TextStyle(color: c.popoverForeground),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.borderMd),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: c.popover,
          borderRadius: AppRadii.borderMd,
          border: Border.all(color: c.border),
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: c.popoverForeground),
      ),
      focusColor: c.ring.withValues(alpha: 0.3),
      hoverColor: c.accent.withValues(alpha: 0.6),
      highlightColor: Colors.transparent,
    );
  }
}
