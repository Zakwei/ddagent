import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/theme/typography.dart';
import 'package:ddagent_app/core/utils/clipboard.dart';
import 'package:ddagent_app/core/utils/selection_copy.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/terminal_keymap.dart';
import 'package:ddagent_app/features/terminal/view/terminal_search.dart';
import 'package:ddagent_app/features/terminal/view/terminal_theme.dart';
import 'package:ddagent_app/features/workspace/view/split_workspace_grid.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xterm/xterm.dart' as xt;

final _fileLinkRegex = RegExp(
  r"""(?:^|[\s"'`(\[])(\/?[a-zA-Z0-9_.-]+(?:\/[a-zA-Z0-9_.-]+)+\.[a-zA-Z0-9]+)(?::(\d+))?""",
);
final _urlRegex = RegExp(r"""https?://[^\s<>"')]+""");

/// Pinch distance (logical px) per one font-size step.
const _pinchStepPx = 40.0;

class TerminalViewWrapper extends ConsumerStatefulWidget {
  const TerminalViewWrapper({
    super.key,
    required this.tab,
    this.onFileOpen,
    this.onUrlOpen,
    this.onTabCommand,
    this.autofocus = true,
  });

  final TerminalTab tab;
  final void Function(String filePath, int? line)? onFileOpen;
  final void Function(String url)? onUrlOpen;

  /// Tab-level chords (new/close/switch tab, zoom, command menu) resolved
  /// here but owned by the screen — the pane has no tab list.
  final void Function(TerminalCommand command, int? index)? onTabCommand;
  final bool autofocus;

  @override
  ConsumerState<TerminalViewWrapper> createState() => TerminalViewWrapperState();
}

class TerminalViewWrapperState extends ConsumerState<TerminalViewWrapper> {
  /// True while keyboard focus sits inside a terminal pane (the xterm view or
  /// its find box). App-wide `HardwareKeyboard` handlers run alongside focus
  /// dispatch, so chords the terminal owns (Ctrl+Shift+F = find) must be
  /// skipped there or both actions fire.
  static bool get hasKeyboardFocus =>
      FocusManager.instance.primaryFocus?.context
          ?.findAncestorStateOfType<TerminalViewWrapperState>() !=
      null;

  late final FocusNode _focusNode;
  late final xt.TerminalController _terminalViewController;
  late final ScrollController _scrollController;
  late final TerminalSearch _search;
  final _searchFieldFocus = FocusNode();
  final _searchFieldController = TextEditingController();

  /// Ctrl held anywhere (global keyboard state) — the pane's wheel then
  /// zooms instead of scrolling, like WT's Ctrl+wheel.
  bool _ctrlHeld = false;

  /// Pointer kind of the last press — the floating selection toolbar is a
  /// touch affordance; a mouse has right-click.
  PointerDeviceKind _lastPointerKind = PointerDeviceKind.mouse;

  /// Two-finger pinch tracking (zoom) — raw pointer bookkeeping instead of
  /// a ScaleGestureRecognizer so xterm's pan/selection recognizers are
  /// not contested in the gesture arena.
  final Map<int, Offset> _pointers = {};
  double? _pinchBaseDistance;
  double _pinchAccum = 0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _terminalViewController = xt.TerminalController()..addListener(_onSelectionChanged);
    _scrollController = ScrollController();
    HardwareKeyboard.instance.addHandler(_trackModifiers);
    final palette = TerminalPalette.campbell;
    _search = TerminalSearch(
      terminal: widget.tab.terminal,
      controller: _terminalViewController,
      hitColor: palette.theme.searchHitBackground,
      currentHitColor: palette.theme.searchHitBackgroundCurrent,
    )..addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_trackModifiers);
    _search
      ..removeListener(_onSearchChanged)
      ..dispose();
    _searchFieldFocus.dispose();
    _searchFieldController.dispose();
    _terminalViewController
      ..removeListener(_onSelectionChanged)
      ..dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = TerminalPalette.of(context).theme;
    _search.setColors(hit: theme.searchHitBackground, current: theme.searchHitBackgroundCurrent);
  }

  bool _trackModifiers(KeyEvent event) {
    final held = HardwareKeyboard.instance.isControlPressed;
    if (held != _ctrlHeld && mounted) setState(() => _ctrlHeld = held);
    return false;
  }

  void _onSelectionChanged() {
    if (mounted) setState(() {});
  }

  void _onSearchChanged() {
    if (mounted) setState(() {});
  }

  bool get _hasSelection => _terminalViewController.selection != null;

  // --- Public surface for the screen's menu ---

  void focusTerminal() => _focusNode.requestFocus();

  /// Touch: bring the soft keyboard back after the IME was dismissed.
  void showSoftKeyboard() {
    _focusNode.requestFocus();
    unawaited(SystemChannels.textInput.invokeMethod<void>('TextInput.show'));
  }

  void openSearch() {
    _search.open();
    _searchFieldFocus.requestFocus();
    _searchFieldController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _searchFieldController.text.length,
    );
  }

  void closeSearch() {
    _search.close();
    _focusNode.requestFocus();
  }

  Future<void> copySelection() async {
    final selection = _terminalViewController.selection;
    if (selection == null) return;
    final text = widget.tab.terminal.buffer.getText(selection);
    reportSelectionText(text);
    await copyText(text);
    // WT: copying releases the selection.
    _terminalViewController.clearSelection();
  }

  void selectAll() {
    final terminal = widget.tab.terminal;
    final buffer = terminal.buffer;
    _terminalViewController.setSelection(
      buffer.createAnchor(0, 0),
      buffer.createAnchor(terminal.viewWidth, buffer.height - 1),
      mode: xt.SelectionMode.line,
    );
  }

  void clearSelection() => _terminalViewController.clearSelection();

  // --- Links ---

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

  // --- Clipboard ---

  /// Paste entry point for every gesture (Ctrl/Cmd+V, Ctrl+Shift+V,
  /// Shift+Insert, right-click, key bar). When `Clipboard.getData` can't
  /// read the clipboard — permission denied, or a plain-HTTP non-secure
  /// context where `navigator.clipboard` doesn't exist — a dialog with a
  /// real text field takes over: native browser paste into an input still
  /// works without the Clipboard API.
  Future<void> paste() async {
    String? text;
    try {
      text = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
    } on Object {
      // Clipboard read failed — the dialog below is the fallback.
    }
    if (text != null && text.isNotEmpty) {
      widget.tab.terminal.paste(text);
      _terminalViewController.clearSelection();
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

  /// WT right-click: copy when text is selected, paste otherwise.
  void _onSecondaryTap() {
    if (_hasSelection) {
      unawaited(copySelection());
    } else {
      unawaited(paste());
    }
  }

  // --- Keyboard ---

  /// Intercepts the Windows Terminal chord set before xterm's own key path
  /// (which would otherwise turn e.g. Ctrl+Shift+T into a ^T for the PTY).
  /// Pane-local commands run here; tab-level ones go to [onTabCommand].
  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final kb = HardwareKeyboard.instance;
    // AltGr arrives as Ctrl+Alt on Windows — without this, xterm's key path
    // would turn AltGr+A ('ą') into a Ctrl/Alt chord instead of the character.
    final character = event.character;
    if (_isWindows &&
        kb.isControlPressed &&
        kb.isAltPressed &&
        character != null &&
        character.isNotEmpty &&
        character.codeUnitAt(0) >= 0x20) {
      widget.tab.terminal.textInput(character);
      return KeyEventResult.handled;
    }
    // Key repeats resolve too — holding Ctrl+Shift+↓ keeps scrolling.
    final binding = resolveTerminalCommand(
      key: event.logicalKey,
      control: kb.isControlPressed,
      shift: kb.isShiftPressed,
      alt: kb.isAltPressed,
      meta: kb.isMetaPressed,
      platform: defaultTargetPlatform,
      hasSelection: _hasSelection,
    );
    if (binding == null) return KeyEventResult.ignored;
    return runCommand(binding.command, binding.index)
        ? KeyEventResult.handled
        : KeyEventResult.ignored;
  }

  /// Executes a resolved command. Returns false when nothing could take it
  /// (tab-level command without an owner).
  bool runCommand(TerminalCommand command, [int? index]) {
    switch (command) {
      case TerminalCommand.copy:
        unawaited(copySelection());
      case TerminalCommand.paste:
        unawaited(paste());
      case TerminalCommand.selectAll:
        selectAll();
      case TerminalCommand.clearSelection:
        clearSelection();
      case TerminalCommand.find:
        openSearch();
      case TerminalCommand.scrollUpLine:
        _scrollLines(-1);
      case TerminalCommand.scrollDownLine:
        _scrollLines(1);
      case TerminalCommand.scrollUpPage:
        _scrollLines(-widget.tab.terminal.viewHeight);
      case TerminalCommand.scrollDownPage:
        _scrollLines(widget.tab.terminal.viewHeight);
      case TerminalCommand.scrollToTop:
        _scrollTo(0);
      case TerminalCommand.scrollToBottom:
        _scrollTo(double.infinity);
      case TerminalCommand.newTab:
      case TerminalCommand.closeTab:
      case TerminalCommand.duplicateTab:
      case TerminalCommand.nextTab:
      case TerminalCommand.previousTab:
      case TerminalCommand.selectTab:
      case TerminalCommand.zoomIn:
      case TerminalCommand.zoomOut:
      case TerminalCommand.zoomReset:
      case TerminalCommand.commandMenu:
        final owner = widget.onTabCommand;
        if (owner == null) return false;
        owner(command, index);
    }
    return true;
  }

  double? get _lineHeightPx {
    if (!_scrollController.hasClients) return null;
    final terminal = widget.tab.terminal;
    final scrollBack = terminal.buffer.height - terminal.viewHeight;
    if (scrollBack <= 0) return null;
    return _scrollController.position.maxScrollExtent / scrollBack;
  }

  void _scrollLines(int lines) {
    final lineHeight = _lineHeightPx;
    if (lineHeight == null) return;
    _scrollTo(_scrollController.offset + lines * lineHeight);
  }

  void _scrollTo(double offset) {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    _scrollController.jumpTo(offset.clamp(position.minScrollExtent, position.maxScrollExtent));
  }

  // --- Pointer: Ctrl+wheel zoom, pinch zoom, pointer-kind tracking ---

  void _onPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || !_ctrlHeld) return;
    final dy = event.scrollDelta.dy;
    if (dy == 0) return;
    widget.onTabCommand?.call(dy < 0 ? TerminalCommand.zoomIn : TerminalCommand.zoomOut, null);
  }

  void _onPointerDown(PointerDownEvent event) {
    if (event.kind != _lastPointerKind) setState(() => _lastPointerKind = event.kind);
    if (event.kind != PointerDeviceKind.touch) return;
    _pointers[event.pointer] = event.position;
    if (_pointers.length == 2) {
      _pinchBaseDistance = _pinchDistance();
      _pinchAccum = 0;
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_pointers.containsKey(event.pointer)) return;
    _pointers[event.pointer] = event.position;
    final base = _pinchBaseDistance;
    if (_pointers.length != 2 || base == null) return;
    final delta = _pinchDistance() - base - _pinchAccum;
    if (delta.abs() < _pinchStepPx) return;
    final steps = delta ~/ _pinchStepPx;
    _pinchAccum += steps * _pinchStepPx;
    for (var i = 0; i < steps.abs(); i++) {
      widget.onTabCommand?.call(steps > 0 ? TerminalCommand.zoomIn : TerminalCommand.zoomOut, null);
    }
  }

  void _onPointerEnd(PointerEvent event) {
    _pointers.remove(event.pointer);
    if (_pointers.length < 2) _pinchBaseDistance = null;
  }

  double _pinchDistance() {
    final points = _pointers.values.toList();
    return (points[0] - points[1]).distance;
  }

  /// `focusFollowsPointer` pref (web `onPointerEnter`) — hovering the
  /// terminal with a mouse gives it keyboard focus. A focused editable
  /// field keeps it (same commit-on-blur guard as ChatInterface).
  void _onPointerEnter(PointerEnterEvent event) {
    if (event.kind != PointerDeviceKind.mouse) return;
    if (!ref.read(uiPreferencesProvider).focusFollowsPointer) return;
    if (widget.tab.status != TerminalTabStatus.connected) return;
    if (hoverFocusBlockedByField()) return;
    if (_searchFieldFocus.hasFocus) return;
    _focusNode.requestFocus();
  }

  /// Touch platforms whose soft keyboard needs the delete-detection workaround
  /// and the on-screen key bar.
  bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  /// xterm's text-input client attaches without a `viewId`, which the Windows
  /// embedder rejects ("view ID is null") — no characters would ever arrive.
  /// Windows reads typed characters straight from key events instead.
  bool get _isWindows => !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  @override
  Widget build(BuildContext context) {
    final palette = TerminalPalette.of(context);
    final showSelectionToolbar = _hasSelection && _lastPointerKind == PointerDeviceKind.touch;

    final terminalView = xt.TerminalView(
      widget.tab.terminal,
      controller: _terminalViewController,
      scrollController: _scrollController,
      theme: palette.theme,
      // WT default `padding: 8`.
      padding: const EdgeInsets.all(8),
      textStyle: xt.TerminalStyle(
        fontFamily: AppFonts.terminalFamily,
        fontFamilyFallback: AppFonts.terminal,
        fontSize: widget.tab.fontSize,
        height: 1.2,
      ),
      // WT defaults to a bar cursor, but xterm 4.0's bar/underline painter
      // drops the row offset and draws the bar on the first visible line —
      // a block cursor at the right place beats a bar at the wrong one.
      cursorType: xt.TerminalCursorType.block,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      keyboardAppearance: Theme.of(context).brightness,
      // Android/iOS soft keyboards don't emit a hardware delete event — the
      // IME reports backspace textually, which xterm otherwise drops.
      deleteDetection: _isMobile,
      hardwareKeyboardOnly: _isWindows,
      // xterm's built-in map binds Ctrl+A to select-all, which would eat the
      // shell's beginning-of-line; every chord is resolved in [_onKeyEvent].
      shortcuts: const {},
      onTapUp: _handleTapUp,
      onSecondaryTapUp: (_, _) => _onSecondaryTap(),
      onKeyEvent: _onKeyEvent,
    );

    return MouseRegion(
      onEnter: _onPointerEnter,
      child: Listener(
        onPointerSignal: _onPointerSignal,
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerEnd,
        onPointerCancel: _onPointerEnd,
        child: ColoredBox(
          color: palette.background,
          child: Stack(
            children: [
              Positioned.fill(
                child: ScrollConfiguration(
                  // While Ctrl is held the wheel zooms — the scrollable must
                  // refuse the offset or the pane would scroll as well.
                  behavior: ScrollConfiguration.of(context).copyWith(
                    scrollbars: false,
                    physics: _ctrlHeld ? const NeverScrollableScrollPhysics() : null,
                  ),
                  child: terminalView,
                ),
              ),
              if (_search.isOpen)
                Positioned(
                  top: 6,
                  right: 12,
                  child: _TerminalSearchBar(
                    search: _search,
                    palette: palette,
                    fieldFocus: _searchFieldFocus,
                    fieldController: _searchFieldController,
                    onNext: () {
                      _search.next();
                      _search.revealCurrent(_scrollController);
                    },
                    onPrevious: () {
                      _search.previous();
                      _search.revealCurrent(_scrollController);
                    },
                    onQuery: (q) {
                      _search.setQuery(q);
                      _search.revealCurrent(_scrollController);
                    },
                    onClose: closeSearch,
                  ),
                ),
              if (showSelectionToolbar)
                Positioned(
                  top: _search.isOpen ? 52 : 8,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: _SelectionToolbar(
                      palette: palette,
                      onCopy: () => unawaited(copySelection()),
                      onPaste: () => unawaited(paste()),
                      onSelectAll: selectAll,
                      onDismiss: clearSelection,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// WT search box — top-right overlay: query field, match counter, case
/// toggle, previous/next, close. Enter = next, Shift+Enter = previous,
/// Esc = close (focus returns to the pane).
class _TerminalSearchBar extends StatelessWidget {
  const _TerminalSearchBar({
    required this.search,
    required this.palette,
    required this.fieldFocus,
    required this.fieldController,
    required this.onNext,
    required this.onPrevious,
    required this.onQuery,
    required this.onClose,
  });

  final TerminalSearch search;
  final TerminalPalette palette;
  final FocusNode fieldFocus;
  final TextEditingController fieldController;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final void Function(String) onQuery;
  final VoidCallback onClose;

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final kb = HardwareKeyboard.instance;
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      onClose();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      kb.isShiftPressed ? onPrevious() : onNext();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.f3) {
      kb.isShiftPressed ? onPrevious() : onNext();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context).terminal.search;
    final colors = context.appColors;
    final fg = palette.tabStripForeground;
    final muted = fg.withValues(alpha: 0.6);
    final hasQuery = search.query.isNotEmpty;
    final counter = !hasQuery
        ? ''
        : search.hitCount == 0
        ? t.noResults
        : t.count(current: search.currentIndex + 1, total: search.hitCount);

    return Material(
      color: palette.chrome,
      elevation: 6,
      shadowColor: Colors.black54,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: Container(
        height: 36,
        padding: const EdgeInsets.only(left: 10, right: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: Border.all(color: palette.chromeBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.search, size: 14, color: muted),
            const SizedBox(width: 8),
            SizedBox(
              width: 180,
              child: Focus(
                onKeyEvent: _onKey,
                child: TextField(
                  controller: fieldController,
                  focusNode: fieldFocus,
                  autofocus: true,
                  onChanged: onQuery,
                  style: TextStyle(fontSize: 13, color: fg),
                  cursorColor: colors.primary,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: t.hint,
                    hintStyle: TextStyle(fontSize: 13, color: muted),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            if (counter.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                counter,
                style: TextStyle(
                  fontSize: 11,
                  color: hasQuery && search.hitCount == 0 ? const Color(0xFFE74856) : muted,
                ),
              ),
            ],
            const SizedBox(width: 4),
            _SearchButton(
              icon: LucideIcons.caseSensitive,
              tooltip: t.matchCase,
              active: search.caseSensitive,
              palette: palette,
              onPressed: () => search.setCaseSensitive(!search.caseSensitive),
            ),
            _SearchButton(
              icon: LucideIcons.arrowUp,
              tooltip: t.previous,
              palette: palette,
              onPressed: search.hitCount > 0 ? onPrevious : null,
            ),
            _SearchButton(
              icon: LucideIcons.arrowDown,
              tooltip: t.next,
              palette: palette,
              onPressed: search.hitCount > 0 ? onNext : null,
            ),
            _SearchButton(
              icon: LucideIcons.x,
              tooltip: t.close,
              palette: palette,
              onPressed: onClose,
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton({
    required this.icon,
    required this.tooltip,
    required this.palette,
    required this.onPressed,
    this.active = false,
  });

  final IconData icon;
  final String tooltip;
  final TerminalPalette palette;
  final VoidCallback? onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final fg = onPressed == null
        ? palette.tabStripForeground.withValues(alpha: 0.3)
        : active
        ? colors.primary
        : palette.tabStripForeground.withValues(alpha: 0.85);
    return Tooltip(
      message: tooltip,
      waitDuration: const Duration(milliseconds: 600),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        hoverColor: palette.tabHover,
        child: Container(
          width: 28,
          height: 28,
          decoration: active
              ? BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                )
              : null,
          child: Icon(icon, size: 15, color: fg),
        ),
      ),
    );
  }
}

/// Floating pill shown over the pane while text is selected by touch —
/// the mobile stand-in for right-click copy.
class _SelectionToolbar extends StatelessWidget {
  const _SelectionToolbar({
    required this.palette,
    required this.onCopy,
    required this.onPaste,
    required this.onSelectAll,
    required this.onDismiss,
  });

  final TerminalPalette palette;
  final VoidCallback onCopy;
  final VoidCallback onPaste;
  final VoidCallback onSelectAll;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final fg = palette.tabStripForeground;

    Widget action(IconData icon, String label, VoidCallback onTap) => InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: fg),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: fg),
            ),
          ],
        ),
      ),
    );

    return Material(
      color: palette.chrome,
      elevation: 6,
      shadowColor: Colors.black54,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: palette.chromeBorder),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            action(LucideIcons.copy, t.common.buttons.copy, onCopy),
            action(LucideIcons.clipboardPaste, t.settings.terminalShortcuts.paste, onPaste),
            action(LucideIcons.textSelect, t.terminal.menu.selectAll, onSelectAll),
            InkWell(
              onTap: onDismiss,
              borderRadius: BorderRadius.circular(999),
              child: Padding(
                padding: const EdgeInsets.all(9),
                child: Icon(LucideIcons.x, size: 15, color: fg.withValues(alpha: 0.7)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fallback for [TerminalViewWrapperState.paste]: when the Clipboard API
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
