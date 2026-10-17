import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart' as xt;

/// Windows Terminal colour schemes. Dark mode renders "Campbell" (the WT
/// default profile scheme, `#0C0C0C` background); light mode renders
/// "One Half Light", which WT ships for light desktops. The tab strip reads
/// the same palette so the active tab merges seamlessly into the pane.
@immutable
class TerminalPalette {
  const TerminalPalette({
    required this.background,
    required this.foreground,
    required this.cursor,
    required this.selection,
    required this.tabStrip,
    required this.tabStripForeground,
    required this.tabHover,
    required this.chrome,
    required this.chromeBorder,
    required this.theme,
  });

  /// Terminal pane background — also the active tab colour.
  final Color background;
  final Color foreground;
  final Color cursor;
  final Color selection;

  /// Tab row background (WT titlebar/Mica tone).
  final Color tabStrip;
  final Color tabStripForeground;
  final Color tabHover;

  /// Floating chrome (search box, selection toolbar, key bar).
  final Color chrome;
  final Color chromeBorder;

  final xt.TerminalTheme theme;

  static TerminalPalette of(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? campbell : oneHalfLight;

  /// WT `Campbell` (defaults.json).
  static final campbell = TerminalPalette(
    background: const Color(0xFF0C0C0C),
    foreground: const Color(0xFFCCCCCC),
    cursor: const Color(0xFFFFFFFF),
    selection: const Color(0xFFFFFFFF).withValues(alpha: 0.30),
    tabStrip: const Color(0xFF202020),
    tabStripForeground: const Color(0xFFE0E0E0),
    tabHover: const Color(0xFFFFFFFF).withValues(alpha: 0.07),
    chrome: const Color(0xFF2B2B2B),
    chromeBorder: const Color(0xFF3F3F3F),
    theme: xt.TerminalTheme(
      cursor: const Color(0xFFFFFFFF),
      selection: const Color(0xFFFFFFFF).withValues(alpha: 0.30),
      foreground: const Color(0xFFCCCCCC),
      background: const Color(0xFF0C0C0C),
      black: const Color(0xFF0C0C0C),
      red: const Color(0xFFC50F1F),
      green: const Color(0xFF13A10E),
      yellow: const Color(0xFFC19C00),
      blue: const Color(0xFF0037DA),
      magenta: const Color(0xFF881798),
      cyan: const Color(0xFF3A96DD),
      white: const Color(0xFFCCCCCC),
      brightBlack: const Color(0xFF767676),
      brightRed: const Color(0xFFE74856),
      brightGreen: const Color(0xFF16C60C),
      brightYellow: const Color(0xFFF9F1A5),
      brightBlue: const Color(0xFF3B78FF),
      brightMagenta: const Color(0xFFB4009E),
      brightCyan: const Color(0xFF61D6D6),
      brightWhite: const Color(0xFFF2F2F2),
      searchHitBackground: const Color(0xFFC19C00).withValues(alpha: 0.45),
      searchHitBackgroundCurrent: const Color(0xFFF9F1A5).withValues(alpha: 0.85),
      searchHitForeground: const Color(0xFF0C0C0C),
    ),
  );

  /// WT `One Half Light`.
  static final oneHalfLight = TerminalPalette(
    background: const Color(0xFFFAFAFA),
    foreground: const Color(0xFF383A42),
    cursor: const Color(0xFF4F525D),
    selection: const Color(0xFF4F525D).withValues(alpha: 0.25),
    tabStrip: const Color(0xFFF0F0F0),
    tabStripForeground: const Color(0xFF1F1F1F),
    tabHover: const Color(0xFF000000).withValues(alpha: 0.05),
    chrome: const Color(0xFFFFFFFF),
    chromeBorder: const Color(0xFFD9D9D9),
    theme: xt.TerminalTheme(
      cursor: const Color(0xFF4F525D),
      selection: const Color(0xFF4F525D).withValues(alpha: 0.25),
      foreground: const Color(0xFF383A42),
      background: const Color(0xFFFAFAFA),
      black: const Color(0xFF383A42),
      red: const Color(0xFFE45649),
      green: const Color(0xFF50A14F),
      yellow: const Color(0xFFC18401),
      blue: const Color(0xFF0184BC),
      magenta: const Color(0xFFA626A4),
      cyan: const Color(0xFF0997B3),
      white: const Color(0xFFFAFAFA),
      brightBlack: const Color(0xFF4F525D),
      brightRed: const Color(0xFFDF6C75),
      brightGreen: const Color(0xFF98C379),
      brightYellow: const Color(0xFFE4C07A),
      brightBlue: const Color(0xFF61AFEF),
      brightMagenta: const Color(0xFFC577DD),
      brightCyan: const Color(0xFF56B5C1),
      brightWhite: const Color(0xFFFFFFFF),
      searchHitBackground: const Color(0xFFE4C07A).withValues(alpha: 0.5),
      searchHitBackgroundCurrent: const Color(0xFFC18401).withValues(alpha: 0.7),
      searchHitForeground: const Color(0xFF383A42),
    ),
  );
}

/// Tab/profile icon — WT shows the profile glyph before the title.
IconData terminalProfileIcon(String provider, {required bool isPlainShell}) {
  if (isPlainShell) return Icons.terminal_rounded;
  return switch (provider) {
    'claude' => Icons.auto_awesome_rounded,
    'devin' => Icons.psychology_rounded,
    'cursor' => Icons.computer_rounded,
    _ => Icons.smart_toy_outlined,
  };
}
