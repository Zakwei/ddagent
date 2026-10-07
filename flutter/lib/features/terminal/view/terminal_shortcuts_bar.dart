import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/theme/typography.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// On-screen key bar for touch/keyboard-less use. A phone soft keyboard has no
/// arrow keys, Esc, Tab or Ctrl, so without this bar a full-screen TUI (agent
/// prompt, editor, pager) can't be navigated at all. Every button writes the
/// raw escape sequence straight to the PTY.
class TerminalShortcutsBar extends StatelessWidget {
  const TerminalShortcutsBar({
    super.key,
    required this.onSendInput,
    required this.onClear,
    required this.onClose,
  });

  final void Function(String input) onSendInput;
  final VoidCallback onClear;
  final VoidCallback onClose;

  Future<void> _handlePaste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text;
    if (text != null && text.isNotEmpty) {
      onSendInput(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final t = Translations.of(context);

    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  _ShortcutButton(
                    label: t.settings.terminalShortcuts.escape,
                    onPressed: () => onSendInput('\x1b'),
                  ),
                  _ShortcutButton(
                    label: t.settings.terminalShortcuts.tab,
                    onPressed: () => onSendInput('\t'),
                  ),
                  // Arrows — the keys a soft keyboard never provides.
                  _ShortcutButton(label: '▲', onPressed: () => onSendInput('\x1b[A')),
                  _ShortcutButton(label: '▼', onPressed: () => onSendInput('\x1b[B')),
                  _ShortcutButton(label: '◄', onPressed: () => onSendInput('\x1b[D')),
                  _ShortcutButton(label: '►', onPressed: () => onSendInput('\x1b[C')),
                  _ShortcutButton(label: 'Home', onPressed: () => onSendInput('\x1b[H')),
                  _ShortcutButton(label: 'End', onPressed: () => onSendInput('\x1b[F')),
                  _ShortcutButton(label: 'PgUp', onPressed: () => onSendInput('\x1b[5~')),
                  _ShortcutButton(label: 'PgDn', onPressed: () => onSendInput('\x1b[6~')),
                  _ShortcutButton(
                    label: 'Ctrl+C',
                    onPressed: () => onSendInput('\x03'),
                    tooltip: t.terminal.shortcuts.interrupt,
                  ),
                  _ShortcutButton(
                    label: 'Ctrl+D',
                    onPressed: () => onSendInput('\x04'),
                    tooltip: t.terminal.shortcuts.eof,
                  ),
                  _ShortcutButton(label: 'Ctrl+L', onPressed: () => onSendInput('\x0c')),
                  _ShortcutButton(
                    label: 'Ctrl+Z',
                    onPressed: () => onSendInput('\x1a'),
                    tooltip: t.terminal.shortcuts.suspend,
                  ),
                  _ShortcutButton(
                    label: t.settings.terminalShortcuts.paste,
                    icon: Icons.paste_outlined,
                    onPressed: _handlePaste,
                  ),
                  _ShortcutButton(
                    label: t.common.buttons.clear,
                    icon: Icons.clear_all,
                    onPressed: onClear,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_hide, size: 20),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            tooltip: t.terminal.shortcuts.hide,
            color: colors.mutedForeground,
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}

class _ShortcutButton extends StatelessWidget {
  const _ShortcutButton({required this.label, this.icon, required this.onPressed, this.tooltip});

  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    // ≥36px tall so the key stays comfortably tappable with a thumb.
    final button = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
      child: Material(
        color: colors.muted,
        borderRadius: BorderRadius.circular(AppRadii.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          onTap: onPressed,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 16, color: colors.foreground),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      fontFamilyFallback: AppFonts.terminal,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colors.foreground,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
