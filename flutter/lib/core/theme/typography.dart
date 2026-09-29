import 'package:flutter/material.dart';

/// Type scale — mirrors the web UI typography.
///
/// Body font: "Encode Sans" stack from `body` in src/index.css. The font files
/// are bundled in a later task; until then the platform fallbacks apply.
/// Mono stack: `ui-monospace, SFMono-Regular, Menlo, Consolas, Liberation Mono`
/// used for code blocks and the terminal in index.css.
abstract final class AppFonts {
  static const List<String> sans = [
    'Encode Sans',
    '-apple-system',
    'BlinkMacSystemFont',
    'Segoe UI',
    'Roboto',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  /// Serif stack — `fontFamily.serif` in tailwind.config.js (chat bodies,
  /// onboarding/auth headings).
  static const List<String> serif = [
    'Merriweather',
    'Georgia',
    'Cambria',
    'Times New Roman',
    'serif',
  ];

  static const List<String> mono = [
    'ui-monospace',
    'SFMono-Regular',
    'SF Mono',
    'Menlo',
    'Consolas',
    'Liberation Mono',
    'monospace',
  ];
}

TextTheme buildTextTheme(Color foreground, Color mutedForeground) {
  TextStyle s(double size, FontWeight weight, Color color, {double? height}) => TextStyle(
    fontFamily: 'Encode Sans',
    fontFamilyFallback: AppFonts.sans,
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  );

  return TextTheme(
    displaySmall: s(30, FontWeight.w700, foreground, height: 1.2),
    headlineLarge: s(24, FontWeight.w700, foreground, height: 1.25),
    headlineMedium: s(20, FontWeight.w600, foreground, height: 1.3),
    headlineSmall: s(18, FontWeight.w600, foreground, height: 1.35),
    titleLarge: s(16, FontWeight.w600, foreground, height: 1.4),
    titleMedium: s(14, FontWeight.w600, foreground, height: 1.4),
    titleSmall: s(13, FontWeight.w600, mutedForeground, height: 1.4),
    bodyLarge: s(16, FontWeight.w400, foreground, height: 1.5),
    bodyMedium: s(14, FontWeight.w400, foreground, height: 1.5),
    bodySmall: s(12, FontWeight.w400, mutedForeground, height: 1.45),
    labelLarge: s(14, FontWeight.w500, foreground, height: 1.3),
    labelMedium: s(12, FontWeight.w500, foreground, height: 1.3),
    labelSmall: s(11, FontWeight.w500, mutedForeground, height: 1.3),
  );
}

/// Mono text style for code/terminal surfaces (xterm, code blocks, diffs).
TextStyle monoStyle(Color color, {double size = 13, FontWeight weight = FontWeight.w400}) {
  return TextStyle(
    fontFamilyFallback: AppFonts.mono,
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: 1.45,
  );
}
