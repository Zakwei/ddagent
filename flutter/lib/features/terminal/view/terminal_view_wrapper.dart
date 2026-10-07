import 'dart:async';
import 'dart:ui' show PointerDeviceKind;

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/theme/typography.dart';
import 'package:ddagent_app/core/utils/clipboard.dart';
import 'package:ddagent_app/core/utils/selection_copy.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/workspace/view/split_workspace_grid.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/foundation.dart';
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
          _openUrl(_resolveAuthUrl(url));
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

  /// A tapped link is matched against a single rendered line — a URL wrapped
  /// at terminal width yields only that line's fragment. When the fragment is
  /// a prefix of a canonical URL already detected in the stream (auth links),
  /// open the complete URL instead.
  String _resolveAuthUrl(String tappedUrl) {
    var resolved = tappedUrl;
    for (final known in widget.tab.authUrls) {
      if (known.length > resolved.length && known.startsWith(tappedUrl)) {
        resolved = known;
      }
    }
    return resolved;
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
          final t = Translations.of(context);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(t.terminal.errors.couldNotOpenLink(url: url))));
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
  /// clipboard read still reaches [_paste]'s dialog fallback. Ctrl/Cmd(+Shift)+C
  /// copies the selection when one exists (terminal convention); with no
  /// selection Ctrl+C stays a plain ^C to the PTY.
  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final kb = HardwareKeyboard.instance;
    final modifier = kb.isControlPressed || kb.isMetaPressed;
    if (event.logicalKey == LogicalKeyboardKey.keyC && modifier) {
      final selection = _terminalViewController.selection;
      if (selection == null) return KeyEventResult.ignored;
      final text = widget.tab.terminal.buffer.getText(selection);
      reportSelectionText(text);
      unawaited(copyText(text));
      return KeyEventResult.handled;
    }
    final isPaste =
        event.logicalKey == LogicalKeyboardKey.keyV && modifier ||
        event.logicalKey == LogicalKeyboardKey.insert && kb.isShiftPressed;
    if (!isPaste) return KeyEventResult.ignored;
    unawaited(_paste());
    return KeyEventResult.handled;
  }

  void _openFile(String filePath, int? line) {
    if (widget.onFileOpen != null) {
      widget.onFileOpen!(filePath, line);
    } else {
      final t = Translations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.terminal.fileLink.detected(path: '$filePath${line != null ? ':$line' : ''}'),
          ),
          action: SnackBarAction(
            label: t.common.gitPanel.worktrees.open,
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
    if (hoverFocusBlockedByField()) return;
    _focusNode.requestFocus();
  }

  /// Touch platforms whose soft keyboard needs the delete-detection workaround
  /// and the on-screen key bar.
  bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          textStyle: xt.TerminalStyle(
            fontFamily: AppFonts.terminalFamily,
            fontFamilyFallback: AppFonts.terminal,
            fontSize: widget.tab.fontSize,
            height: 1.35,
          ),
          focusNode: _focusNode,
          autofocus: widget.autofocus,
          // Android/iOS soft keyboards don't emit a hardware delete event — the
          // IME reports backspace textually, which xterm otherwise drops.
          deleteDetection: _isMobile,
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
    final t = Translations.of(context);
    return AlertDialog(
      backgroundColor: colors.card,
      title: Text(t.terminal.paste.title),
      content: SizedBox(
        width: 420,
        child: TextField(
          controller: _ctrl,
          autofocus: true,
          decoration: InputDecoration(hintText: t.terminal.paste.hint),
          maxLines: null,
          onSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.common.buttons.cancel),
        ),
        FilledButton(onPressed: _submit, child: Text(t.settings.terminalShortcuts.paste)),
      ],
    );
  }
}
