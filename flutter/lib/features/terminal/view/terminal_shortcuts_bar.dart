import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/theme/typography.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/terminal_theme.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// On-screen key bar for touch/keyboard-less use. A phone soft keyboard has no
/// arrow keys, Esc, Tab or Ctrl, so without this bar a full-screen TUI (agent
/// prompt, editor, pager) can't be navigated at all. Every key writes the raw
/// escape sequence straight to the PTY; `Ctrl`/`Alt` are sticky modifiers
/// that arm the next key or typed character (the key stays lit while armed).
class TerminalShortcutsBar extends StatelessWidget {
  const TerminalShortcutsBar({
    super.key,
    required this.onSendInput,
    required this.onClear,
    required this.onClose,
    required this.onPaste,
    required this.onPickImages,
    required this.latched,
    required this.onToggleModifier,
    this.onShowKeyboard,
  });

  final void Function(String input) onSendInput;
  final VoidCallback onClear;
  final VoidCallback onClose;
  final VoidCallback onPaste;
  final VoidCallback onPickImages;
  final Set<LatchedModifier> latched;
  final void Function(LatchedModifier modifier) onToggleModifier;

  /// Re-opens the soft keyboard (touch only) — tapping the pane also does
  /// it, but a dedicated key is quicker once the IME has been dismissed.
  final VoidCallback? onShowKeyboard;

  static const double height = 46;

  @override
  Widget build(BuildContext context) {
    final palette = TerminalPalette.of(context);
    final t = Translations.of(context);
    final ctrl = latched.contains(LatchedModifier.ctrl);
    final shift = latched.contains(LatchedModifier.shift);

    Widget key(
      String label, {
      String? send,
      VoidCallback? onTap,
      IconData? icon,
      String? tooltip,
      bool active = false,
      double minWidth = 38,
    }) => _KeyCap(
      label: label,
      icon: icon,
      tooltip: tooltip,
      active: active,
      minWidth: minWidth,
      palette: palette,
      onPressed: onTap ?? () => onSendInput(send!),
    );

    Widget group(List<Widget> keys) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(mainAxisSize: MainAxisSize.min, children: keys),
    );

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: palette.tabStrip,
        border: Border(top: BorderSide(color: palette.chromeBorder.withValues(alpha: 0.6))),
      ),
      child: Row(
        children: [
          if (onShowKeyboard != null)
            _BarIconButton(
              icon: LucideIcons.keyboard,
              tooltip: t.terminal.keyBar.showKeyboard,
              palette: palette,
              onPressed: onShowKeyboard!,
            ),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Row(
                  children: [
                    group([
                      key('Esc', send: '\x1b'),
                      key('Tab', send: '\t'),
                      key(
                        t.terminal.keyBar.ctrl,
                        active: ctrl,
                        tooltip: t.terminal.keyBar.ctrlHint,
                        onTap: () => onToggleModifier(LatchedModifier.ctrl),
                      ),
                      key(
                        t.terminal.keyBar.shift,
                        active: shift,
                        tooltip: t.terminal.keyBar.shiftHint,
                        onTap: () => onToggleModifier(LatchedModifier.shift),
                      ),
                    ]),
                    _Divider(palette: palette),
                    group([
                      key('▲', send: '\x1b[A'),
                      key('▼', send: '\x1b[B'),
                      key('◄', send: '\x1b[D'),
                      key('►', send: '\x1b[C'),
                    ]),
                    _Divider(palette: palette),
                    group([
                      key('Home', send: '\x1b[H'),
                      key('End', send: '\x1b[F'),
                      key('PgUp', send: '\x1b[5~'),
                      key('PgDn', send: '\x1b[6~'),
                    ]),
                    _Divider(palette: palette),
                    group([
                      key('Ctrl+C', send: '\x03', tooltip: t.terminal.shortcuts.interrupt),
                      key('Ctrl+D', send: '\x04', tooltip: t.terminal.shortcuts.eof),
                      key('Ctrl+L', send: '\x0c'),
                      key('Ctrl+Z', send: '\x1a', tooltip: t.terminal.shortcuts.suspend),
                    ]),
                    _Divider(palette: palette),
                    group([
                      key('-', send: '-'),
                      key('/', send: '/'),
                      key('|', send: '|'),
                      key('~', send: '~'),
                    ]),
                    _Divider(palette: palette),
                    group([
                      key(
                        t.settings.terminalShortcuts.paste,
                        icon: LucideIcons.clipboardPaste,
                        onTap: onPaste,
                      ),
                      key(t.chat.input.attachImages, icon: LucideIcons.image, onTap: onPickImages),
                      key(t.common.buttons.clear, icon: LucideIcons.eraser, onTap: onClear),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          _BarIconButton(
            icon: LucideIcons.keyboardOff,
            tooltip: t.terminal.shortcuts.hide,
            palette: palette,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({required this.palette});

  final TerminalPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 20,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: palette.tabStripForeground.withValues(alpha: 0.15),
    );
  }
}

class _BarIconButton extends StatelessWidget {
  const _BarIconButton({
    required this.icon,
    required this.tooltip,
    required this.palette,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final TerminalPalette palette;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          hoverColor: palette.tabHover,
          child: SizedBox(
            width: 40,
            height: TerminalShortcutsBar.height,
            child: Icon(icon, size: 18, color: palette.tabStripForeground.withValues(alpha: 0.8)),
          ),
        ),
      ),
    );
  }
}

/// A flat keycap — ≥36px tall so it stays comfortably tappable with a thumb.
class _KeyCap extends StatelessWidget {
  const _KeyCap({
    required this.label,
    required this.palette,
    required this.onPressed,
    required this.minWidth,
    this.icon,
    this.tooltip,
    this.active = false,
  });

  final String label;
  final IconData? icon;
  final String? tooltip;
  final bool active;
  final double minWidth;
  final TerminalPalette palette;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final fg = active ? colors.primaryForeground : palette.tabStripForeground;
    final button = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
      child: Material(
        color: active ? colors.primary : palette.chrome,
        borderRadius: BorderRadius.circular(AppRadii.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          onTap: () {
            HapticFeedback.selectionClick();
            onPressed();
          },
          child: Container(
            constraints: BoxConstraints(minWidth: minWidth, minHeight: 36),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadii.sm),
              border: Border.all(
                color: active ? colors.primary : palette.chromeBorder.withValues(alpha: 0.7),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[Icon(icon, size: 15, color: fg), const SizedBox(width: 5)],
                Text(
                  label,
                  style: TextStyle(
                    fontFamilyFallback: AppFonts.terminal,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) return Tooltip(message: tooltip!, child: button);
    return button;
  }
}
