import 'dart:async';
import 'dart:ui' show PointerDeviceKind;

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/theme/typography.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xterm/xterm.dart' as xt;

final _fileLinkRegex = RegExp(
  r"""(?:^|[\s"'`(\[])(\/?[a-zA-Z0-9_.-]+(?:\/[a-zA-Z0-9_.-]+)+\.[a-zA-Z0-9]+)(?::(\d+))?""",
);
final _urlRegex = RegExp(r"""https?://[^\s<>"')]+""");

class TerminalViewWrapper extends ConsumerStatefulWidget {
  const TerminalViewWrapper({
    super.key,
    required this.tab,
    this.onFileOpen,
    this.onUrlOpen,
    this.autofocus = true,
  });

  final TerminalTab tab;
  final void Function(String filePath, int? line)? onFileOpen;
  final void Function(String url)? onUrlOpen;
  final bool autofocus;

  @override
  ConsumerState<TerminalViewWrapper> createState() => _TerminalViewWrapperState();
}

class _TerminalViewWrapperState extends ConsumerState<TerminalViewWrapper> {
  late final FocusNode _focusNode;
  late final xt.TerminalController _terminalViewController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _terminalViewController = xt.TerminalController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _terminalViewController.dispose();
    super.dispose();
  }

  void _handleTapUp(TapUpDetails details, xt.CellOffset offset) {
    final terminal = widget.tab.terminal;
    final lines = terminal.buffer.lines;
    if (offset.y < 0 || offset.y >= lines.length) return;

    final lineText = lines[offset.y].getText();
    if (lineText.isEmpty) return;

    // Check for URLs first
    final urlMatches = _urlRegex.allMatches(lineText);
    for (final match in urlMatches) {
      if (offset.x >= match.start && offset.x <= match.end) {
        final url = match.group(0);
        if (url != null) {
          _openUrl(url);
          return;
        }
      }
    }

    // Check for file path matches
    final fileMatches = _fileLinkRegex.allMatches(lineText);
    for (final match in fileMatches) {
      if (offset.x >= match.start && offset.x <= match.end) {
        final filePath = match.group(1);
        final lineStr = match.group(2);
        final line = lineStr != null ? int.tryParse(lineStr) : null;
        if (filePath != null) {
          _openFile(filePath, line);
          return;
        }
      }
    }
  }

  void _openUrl(String url) async {
    if (widget.onUrlOpen != null) {
      widget.onUrlOpen!(url);
      return;
    }
    final uri = Uri.tryParse(url);
    if (uri != null) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } on Object {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Could not open link: $url')));
        }
      }
    }
  }

  /// Paste entry point for every gesture (Ctrl/Cmd+V, Ctrl+Shift+V,
  /// Shift+Insert, right-click). When `Clipboard.getData` can't read the
  /// clipboard — permission denied, or a plain-HTTP non-secure context
  /// where `navigator.clipboard` doesn't exist — a dialog with a real
  /// text field takes over: native browser paste into an input still
  /// works without the Clipboard API.
  Future<void> _paste() async {
    String? text;
    try {
      text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
    } on Object {
      // Clipboard read failed — the dialog below is the fallback.
    }
    if (text != null && text.isNotEmpty) {
      widget.tab.terminal.paste(text);
      return;
    }
    if (!mounted) return;
    final pasted = await showDialog<String>(
      context: context,
      builder: (context) => const _TerminalPasteDialog(),
    );
    if (pasted != null && pasted.isNotEmpty) {
      widget.tab.terminal.paste(pasted);
    }
  }

  /// Intercepts paste chords before xterm's own shortcut map so a failed
  /// clipboard read still reaches [_paste]'s dialog fallback.
  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final kb = HardwareKeyboard.instance;
    final isPaste =
        event.logicalKey == LogicalKeyboardKey.keyV && (kb.isControlPressed || kb.isMetaPressed) ||
        event.logicalKey == LogicalKeyboardKey.insert && kb.isShiftPressed;
    if (!isPaste) return KeyEventResult.ignored;
    unawaited(_paste());
    return KeyEventResult.handled;
  }

  void _openFile(String filePath, int? line) {
    if (widget.onFileOpen != null) {
      widget.onFileOpen!(filePath, line);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('File detected: $filePath${line != null ? ':$line' : ''}'),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () => widget.onFileOpen?.call(filePath, line),
          ),
        ),
      );
    }
  }

  xt.TerminalTheme _buildTheme(BuildContext context) {
    final colors = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return xt.TerminalTheme(
      cursor: colors.primary,
      selection: colors.primary.withValues(alpha: 0.3),
      foreground: isDark ? const Color(0xFFE6EDF3) : const Color(0xFF1F2328),
      background: isDark ? const Color(0xFF0D1117) : const Color(0xFFFFFFFF),
      black: isDark ? const Color(0xFF484F58) : const Color(0xFF24292F),
      red: colors.destructive,
      green: const Color(0xFF22C55E),
      yellow: const Color(0xFFE3B341),
      blue: colors.primary,
      magenta: const Color(0xFFBC8CFF),
      cyan: const Color(0xFF39C5CF),
      white: isDark ? const Color(0xFFB1BAC4) : const Color(0xFF6E7781),
      brightBlack: isDark ? const Color(0xFF6E7681) : const Color(0xFF57606A),
      brightRed: const Color(0xFFFF7B72),
      brightGreen: const Color(0xFF56D364),
      brightYellow: const Color(0xFFE3B341),
      brightBlue: const Color(0xFF79C0FF),
      brightMagenta: const Color(0xFFD2A8FF),
      brightCyan: const Color(0xFF56D4DD),
      brightWhite: const Color(0xFFFFFFFF),
      searchHitBackground: const Color(0xFFE3B341).withValues(alpha: 0.3),
      searchHitBackgroundCurrent: const Color(0xFFE3B341).withValues(alpha: 0.6),
      searchHitForeground: colors.foreground,
    );
  }

  /// `focusFollowsPointer` pref (web `onPointerEnter`) — hovering the
  /// terminal with a mouse gives it keyboard focus. A focused editable
  /// field keeps it (same commit-on-blur guard as ChatInterface).
  void _onPointerEnter(PointerEnterEvent event) {
    if (event.kind != PointerDeviceKind.mouse) return;
    if (!ref.read(uiPreferencesProvider).focusFollowsPointer) return;
    if (widget.tab.status != TerminalTabStatus.connected) return;
    final focused = FocusManager.instance.primaryFocus?.context;
    if (focused?.findAncestorWidgetOfExactType<EditableText>() != null) {
      return;
    }
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: _onPointerEnter,
      child: Container(
        color: isDark ? const Color(0xFF0D1117) : const Color(0xFFFFFFFF),
        child: xt.TerminalView(
          widget.tab.terminal,
          controller: _terminalViewController,
          theme: _buildTheme(context),
          textStyle: xt.TerminalStyle(
            fontFamilyFallback: AppFonts.mono,
            fontSize: widget.tab.fontSize,
            height: 1.3,
          ),
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          onTapUp: _handleTapUp,
          onSecondaryTapUp: (_, _) => unawaited(_paste()),
          onKeyEvent: _onKeyEvent,
        ),
      ),
    );
  }
}

/// Fallback for [_TerminalViewWrapperState._paste]: when the Clipboard API
/// is unavailable (plain-HTTP non-secure context, denied permission) the
/// user pastes natively into this field — browser paste events on a real
/// input don't need `navigator.clipboard`.
class _TerminalPasteDialog extends StatefulWidget {
  const _TerminalPasteDialog();

  @override
  State<_TerminalPasteDialog> createState() => _TerminalPasteDialogState();
}

class _TerminalPasteDialogState extends State<_TerminalPasteDialog> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(_ctrl.text);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return AlertDialog(
      backgroundColor: colors.card,
      title: const Text('Paste into terminal'),
      content: SizedBox(
        width: 420,
        child: TextField(
          controller: _ctrl,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Ctrl+V / right-click → Paste'),
          maxLines: null,
          onSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
        FilledButton(onPressed: _submit, child: const Text('Paste')),
      ],
    );
  }
}
