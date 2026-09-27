import 'package:flutter/material.dart';

/// Design tokens extracted 1:1 from the web UI (`src/index.css` CSS vars +
/// `tailwind.config.js`). Colors are stored in CSS as `H S% L%` triplets —
/// keep them that way here so diffs against the source stay trivial.
Color _hsl(double h, double s, double l, [double a = 1]) =>
    HSLColor.fromAHSL(a, h, s / 100, l / 100).toColor();

/// Semantic palette — mirrors `--background/--foreground/--card/...` vars.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
  });

  final Color background;
  final Color foreground;
  final Color card;
  final Color cardForeground;
  final Color popover;
  final Color popoverForeground;
  final Color primary;
  final Color primaryForeground;
  final Color secondary;
  final Color secondaryForeground;
  final Color muted;
  final Color mutedForeground;
  final Color accent;
  final Color accentForeground;
  final Color destructive;
  final Color destructiveForeground;
  final Color border;
  final Color input;
  final Color ring;

  /// `:root` from index.css.
  static const light = AppColors(
    background: Color(0xFFF7F6F3), // hsl(44 22% 96%)
    foreground: Color(0xFF0D0B08), // hsl(36 25% 4%)
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF0D0B08),
    popover: Color(0xFFFFFFFF),
    popoverForeground: Color(0xFF0D0B08),
    primary: Color(0xFF2563EB), // hsl(221.2 83.2% 53.3%)
    primaryForeground: Color(0xFFF8FAFC),
    secondary: Color(0xFFEBEAE5), // hsl(44 15% 91%)
    secondaryForeground: Color(0xFF352F27), // hsl(36 15% 18%)
    muted: Color(0xFFEBEAE5),
    mutedForeground: Color(0xFF76726B), // hsl(40 5% 44%)
    accent: Color(0xFFEBEAE5),
    accentForeground: Color(0xFF352F27),
    destructive: Color(0xFFEF4444), // hsl(0 84.2% 60.2%)
    destructiveForeground: Color(0xFFF8FAFC),
    border: Color(0xFFE2E0D9), // hsl(44 14% 87%)
    input: Color(0xFFE2E0D9),
    ring: Color(0xFF2563EB),
  );

  /// `.dark` from index.css.
  static const dark = AppColors(
    background: Color(0xFF141414), // hsl(0 0% 8%)
    foreground: Color(0xFFEFEEEC), // hsl(40 8% 93%)
    card: Color(0xFF1F1F1F), // hsl(0 0% 12%)
    cardForeground: Color(0xFFEFEEEC),
    popover: Color(0xFF1F1F1F),
    popoverForeground: Color(0xFFEFEEEC),
    primary: Color(0xFF3B82F6), // hsl(217.2 91.2% 59.8%)
    primaryForeground: Color(0xFF141414),
    secondary: Color(0xFF2B2B2B), // hsl(0 0% 17%)
    secondaryForeground: Color(0xFFEFEEEC),
    muted: Color(0xFF2B2B2B),
    mutedForeground: Color(0xFF999999), // hsl(0 0% 60%)
    accent: Color(0xFF2B2B2B),
    accentForeground: Color(0xFFEFEEEC),
    destructive: Color(0xFF7F1D1D), // hsl(0 62.8% 30.6%)
    destructiveForeground: Color(0xFFEFEEEC),
    border: Color(0xFF2B2B2B),
    input: Color(0xFF3B3B3B), // hsl(0 0% 23%)
    ring: Color(0xFF3B82F6),
  );

  @override
  AppColors copyWith() => this;

  @override
  AppColors lerp(AppColors? other, double t) => t < 0.5 ? this : (other ?? this);
}

/// Nav surface tokens — `--nav-*` vars (glass bar, tab glow, dividers).
@immutable
class AppNavTokens extends ThemeExtension<AppNavTokens> {
  const AppNavTokens({
    required this.glassBackground,
    required this.glassBlur,
    required this.glassSaturate,
    required this.tabGlow,
    required this.tabRing,
    required this.floatShadow,
    required this.floatRing,
    required this.dividerColor,
    required this.inputBackground,
    required this.inputFocusRing,
  });

  final Color glassBackground;
  final double glassBlur;
  final double glassSaturate;
  final Color tabGlow;
  final Color tabRing;
  final Color floatShadow;
  final Color floatRing;
  final Color dividerColor;
  final Color inputBackground;
  final Color inputFocusRing;

  static final light = AppNavTokens(
    glassBackground: _hsl(44, 22, 96, 0.7),
    glassBlur: 20,
    glassSaturate: 1.8,
    tabGlow: _hsl(221.2, 83.2, 53.3, 0.18),
    tabRing: _hsl(221.2, 83.2, 53.3, 0.10),
    floatShadow: _hsl(0, 0, 0, 0.06),
    floatRing: _hsl(44, 14, 87, 0.5),
    dividerColor: _hsl(44, 14, 87, 0.5),
    inputBackground: _hsl(44, 15, 91, 0.5),
    inputFocusRing: _hsl(221.2, 83.2, 53.3, 0.22),
  );

  static final dark = AppNavTokens(
    glassBackground: _hsl(0, 0, 12, 0.55),
    glassBlur: 24,
    glassSaturate: 1.6,
    tabGlow: _hsl(217.2, 91.2, 59.8, 0.25),
    tabRing: _hsl(217.2, 91.2, 59.8, 0.15),
    floatShadow: _hsl(0, 0, 0, 0.35),
    floatRing: _hsl(0, 0, 17, 0.3),
    dividerColor: _hsl(0, 0, 17, 0.5),
    inputBackground: _hsl(0, 0, 17, 0.5),
    inputFocusRing: _hsl(217.2, 91.2, 59.8, 0.25),
  );

  @override
  AppNavTokens copyWith() => this;

  @override
  AppNavTokens lerp(AppNavTokens? other, double t) => t < 0.5 ? this : (other ?? this);
}

/// Radii — Tailwind `borderRadius`: lg = --radius (0.5rem), md = -2px, sm = -4px.
abstract final class AppRadii {
  static const double lg = 8;
  static const double md = 6;
  static const double sm = 4;

  static const BorderRadius borderLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius borderMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius borderSm = BorderRadius.all(Radius.circular(sm));
}

/// Spacing scale — Tailwind default (4px base).
abstract final class AppSpacing {
  static const double xs = 4; // 1
  static const double sm = 8; // 2
  static const double md = 12; // 3
  static const double lg = 16; // 4
  static const double xl = 24; // 6
  static const double xxl = 32; // 8

  /// `--mobile-nav-height` + `--mobile-nav-padding` from index.css.
  static const double mobileNavHeight = 52;
  static const double mobileNavPadding = 20;
}

/// Motion — transition timings from index.css.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 50); // :active
  static const Duration hover = Duration(milliseconds: 100);
  static const Duration base = Duration(milliseconds: 150);
  static const Duration theme = Duration(milliseconds: 200);
  static const Duration emphasis = Duration(milliseconds: 300);

  static const Curve standard = Cubic(0.4, 0, 0.2, 1);
  static const Curve enter = Cubic(0.22, 1, 0.36, 1);
}

extension AppThemeContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
  AppNavTokens get appNav => Theme.of(this).extension<AppNavTokens>()!;
}
