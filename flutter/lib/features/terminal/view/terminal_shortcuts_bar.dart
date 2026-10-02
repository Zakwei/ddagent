import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/theme/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: colors.card,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: [
                  _ShortcutButton(label: 'ESC', onPressed: () => onSendInput('\x1b')),
                  _ShortcutButton(label: 'TAB', onPressed: () => onSendInput('\t')),
                  _ShortcutButton(label: '▲', onPressed: () => onSendInput('\x1b[A')),
                  _ShortcutButton(label: '▼', onPressed: () => onSendInput('\x1b[B')),
                  _ShortcutButton(label: '◄', onPressed: () => onSendInput('\x1b[D')),
                  _ShortcutButton(label: '►', onPressed: () => onSendInput('\x1b[C')),
                  _ShortcutButton(
                    label: 'Ctrl+C',
                    onPressed: () => onSendInput('\x03'),
                    tooltip: 'Interrupt (SIGINT)',
                  ),
                  _ShortcutButton(
                    label: 'Ctrl+D',
                    onPressed: () => onSendInput('\x04'),
                    tooltip: 'EOF',
                  ),
                  _ShortcutButton(
                    label: 'Ctrl+Z',
                    onPressed: () => onSendInput('\x1a'),
                    tooltip: 'Suspend (SIGTSTP)',
                  ),
                  _ShortcutButton(
                    label: 'Paste',
                    icon: Icons.paste_outlined,
                    onPressed: _handlePaste,
                  ),
                  _ShortcutButton(label: 'Clear', icon: Icons.clear_all, onPressed: onClear),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_hide, size: 18),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            tooltip: 'Hide shortcuts bar',
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

    final button = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      child: Material(
        color: colors.muted,
        borderRadius: BorderRadius.circular(AppRadii.sm),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.sm),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 14, color: colors.foreground),
                  const SizedBox(width: 4),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontFamilyFallback: AppFonts.mono,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.foreground,
                  ),
                ),
              ],
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
