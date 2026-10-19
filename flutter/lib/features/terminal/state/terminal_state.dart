import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/shell_channel.dart';
import 'package:ddagent_app/core/utils/clipboard.dart';
import 'package:ddagent_app/features/terminal/state/terminal_key_handler.dart';
import 'package:ddagent_app/features/terminal/state/terminal_mouse_handler.dart';
import 'package:ddagent_app/features/terminal/state/terminal_output_filter.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart' show Color;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xterm/xterm.dart';

export 'package:ddagent_app/features/workspace/state/split_workspace.dart'
    show TerminalHostSpec, TerminalTabSpec, terminalRouteHost;

enum TerminalTabStatus { connecting, connected, disconnected, exited }

/// One numbered answer in a CLI prompt detected on the terminal buffer
/// (web `CliPromptOption` — `❯ N. label` rows above an "esc to cancel"
/// footer).
typedef CliPromptOption = ({String number, String label});

// Web `constants.ts` — the buffer-scan window + option bounds.
const _promptDebounce = Duration(milliseconds: 500);
const _promptBufferScanLines = 20;
const _promptOptionScanLines = 15;
const _promptMaxOptions = 5;
const _promptMinOptions = 2;

final _syncIdRandom = Random();

/// A tab id unique across the account's devices — also the tab's PTY key,
/// so it stays within the server's safe session-id alphabet.
String newTerminalTabSyncId() =>
    'tab-${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}-'
    '${_syncIdRandom.nextInt(kPaneIdSpace).toRadixString(36)}';

/// Terminal font bounds (web Shell zoom 9–24px) and the Ctrl+0 reset size.
const terminalFontSizeMin = 9.0;
const terminalFontSizeMax = 24.0;
const terminalFontSizeDefault = 13.0;

/// Modifier keys the on-screen key bar can latch for the next keystroke — a
/// soft keyboard has no Ctrl/Alt, so a tap on `Ctrl` arms the modifier and
/// the next typed character (or arrow) is sent as that chord.
enum LatchedModifier { ctrl, alt }

final _csiKeyRegex = RegExp(r'^\x1b\[(?:1;(\d))?([ABCDHF])$');
final _csiTildeKeyRegex = RegExp(r'^\x1b\[(\d+)(?:;(\d))?~$');

/// Applies latched modifiers to one input chunk (web/Termux key-bar
/// semantics). A chunk that is not a single key the modifiers can decorate
/// (multi-character paste, bare Esc) passes through untouched.
///
/// - Ctrl + letter/`[\]^_@` → the control code (`a` → `\x01`).
/// - Ctrl/Alt + cursor key (`\x1b[A`, `\x1b[H`, `\x1b[5~`) → xterm modifier
///   parameter (`\x1b[1;5A`, `\x1b[5;3~`).
/// - Alt + printable character → ESC-prefixed character (`\x1bx`).
String applyLatchedModifiers(String data, Set<LatchedModifier> modifiers) {
  if (modifiers.isEmpty || data.isEmpty) return data;
  final ctrl = modifiers.contains(LatchedModifier.ctrl);
  final alt = modifiers.contains(LatchedModifier.alt);
  // xterm modifier parameter: 1 + shift(1) + alt(2) + ctrl(4).
  final param = 1 + (alt ? 2 : 0) + (ctrl ? 4 : 0);

  final csi = _csiKeyRegex.firstMatch(data);
  if (csi != null) {
    final existing = int.tryParse(csi.group(1) ?? '1') ?? 1;
    final merged = existing + param - 1;
    return '\x1b[1;$merged${csi.group(2)}';
  }
  final tilde = _csiTildeKeyRegex.firstMatch(data);
  if (tilde != null) {
    final existing = int.tryParse(tilde.group(2) ?? '1') ?? 1;
    final merged = existing + param - 1;
    return '\x1b[${tilde.group(1)};$merged~';
  }

  if (data.runes.length != 1) return data;
  final code = data.runes.first;
  var out = data;
  if (ctrl) {
    if (code >= 0x61 && code <= 0x7a) {
      out = String.fromCharCode(code - 0x60); // a-z
    } else if (code >= 0x40 && code <= 0x5f) {
      out = String.fromCharCode(code - 0x40); // @ A-Z [ \ ] ^ _
    } else if (code == 0x3f) {
      out = '\x7f'; // Ctrl+? → DEL
    } else if (code == 0x20) {
      out = '\x00'; // Ctrl+Space → NUL
    }
  }
  if (alt) out = '\x1b$out';
  return out;
}

final _exitCodeRegex = RegExp(r'Process exited with code (\d+)');
final _promptFooterRegex = RegExp(r'esc to cancel|enter to select', caseSensitive: false);
final _promptOptionRegex = RegExp(r'^\s*[❯›>]?\s*(\d+)\.\s+(.+)');

class TerminalTab {
  TerminalTab({
    required this.id,
    required this.syncId,
    required this.title,
    required this.projectPath,
    this.hostId = terminalRouteHost,
    this.sessionId,
    this.provider = 'claude',
    this.initialCommand,
    this.isPlainShell = true,
    this.isCommandMode = false,
    this.ptySessionId,
    this.env,
    this.onComplete,
    required this.terminal,
    required this.channel,
    this.status = TerminalTabStatus.connecting,
    this.isCompleted = false,
    this.exitCode,
    List<String>? authUrls,
  }) : authUrls = authUrls ?? <String>[];

  /// Local id — unique within this app run (also keys the shell channel).
  final String id;

  /// The tab's id on every device of the account ([TerminalTabSpec.id]).
  final String syncId;

  /// Mutable — the tab strip's Rename action edits it in place.
  String title;

  /// Window title the running program set (OSC 0/2) — Claude Code and other
  /// agent CLIs put their session name there. Shown instead of [title] until
  /// the user renames the tab; an empty one hands the tab its name back.
  String? appTitle;

  /// Set by Rename — the user's name then wins over [appTitle], as in WT.
  bool renamed = false;

  String get displayTitle => renamed ? title : appTitle ?? title;

  /// True while a replayed frame is written — the emulator's replies to the
  /// queries in it (device attributes, colours) and its OSC 52 copies were
  /// already handled live; re-sending would type "1;2c" into the shell.
  bool replaying = false;

  /// Which tab row shows this tab ([terminalRouteHost] or a workspace pane
  /// id). Mutable — "Move to new pane" reassigns it; the PTY never notices.
  String hostId;
  final String projectPath;
  final String? sessionId;
  final String provider;
  final String? initialCommand;
  final bool isPlainShell;
  final bool isCommandMode;

  /// Discriminator sent as the init frame's `sessionId` for a shell or CLI
  /// tab with no agent session. The server keys PTYs by
  /// `projectPath_sessionId`, so without it every "new tab" reattached the
  /// same shell. Unique per tab and synced, so every device showing the tab
  /// attaches to the same PTY.
  final String? ptySessionId;

  /// Extra PTY env sent with `init` (per-account login config dirs).
  final Map<String, String>? env;
  final void Function(int exitCode)? onComplete;
  final Terminal terminal;
  final ShellChannel channel;

  TerminalTabStatus status;
  bool isCompleted;
  int? exitCode;
  final List<String> authUrls;
  StreamSubscription<ShellFrame>? subscription;

  /// Drops the keyboard-protocol negotiation sequences xterm.dart misreads
  /// (see [TerminalOutputFilter]); carries split escapes across frames.
  final outputFilter = TerminalOutputFilter();

  /// Terminal font size (web Shell zoom, default 14 there / 13 here).
  double fontSize = terminalFontSizeDefault;

  /// CLI prompt options detected on the buffer (null = no prompt active).
  List<CliPromptOption>? promptOptions;

  /// Pending "spawn at 80×24 anyway" fallback of a tab not yet laid out;
  /// cancelled by the first layout or by closing the tab.
  Timer? initGraceTimer;

  void dispose() {
    initGraceTimer?.cancel();
    initGraceTimer = null;
    subscription?.cancel();
    subscription = null;
    channel.dispose();
  }

  TerminalTab copyWith({
    String? title,
    TerminalTabStatus? status,
    bool? isCompleted,
    int? exitCode,
    List<String>? authUrls,
  }) {
    final tab = TerminalTab(
      id: id,
      syncId: syncId,
      title: title ?? this.title,
      projectPath: projectPath,
      hostId: hostId,
      sessionId: sessionId,
      provider: provider,
      initialCommand: initialCommand,
      isPlainShell: isPlainShell,
      isCommandMode: isCommandMode,
      ptySessionId: ptySessionId,
      env: env,
      onComplete: onComplete,
      terminal: terminal,
      channel: channel,
      status: status ?? this.status,
      isCompleted: isCompleted ?? this.isCompleted,
      exitCode: exitCode ?? this.exitCode,
      authUrls: authUrls ?? List<String>.from(this.authUrls),
    );
    tab.subscription = subscription;
    return tab;
  }
}

class TerminalState {
  const TerminalState({
    this.tabs = const [],
    this.activeTabIds = const {},
    this.showShortcutsBar = true,
    this.latchedModifiers = const {},
  });

  /// Every tab of every host, in strip order (hosts interleave freely).
  final List<TerminalTab> tabs;

  /// Active tab per host — each tab row remembers its own selection.
  final Map<String, String> activeTabIds;
  final bool showShortcutsBar;

  /// Modifiers armed by the on-screen key bar for the next keystroke.
  final Set<LatchedModifier> latchedModifiers;

  List<TerminalTab> tabsFor(String hostId) => [
    for (final tab in tabs)
      if (tab.hostId == hostId) tab,
  ];

  TerminalTab? activeTabFor(String hostId) {
    final own = tabsFor(hostId);
    if (own.isEmpty) return null;
    final id = activeTabIds[hostId];
    for (final tab in own) {
      if (tab.id == id) return tab;
    }
    return own.first;
  }

  int activeIndexFor(String hostId) =>
      tabsFor(hostId).indexWhere((tab) => tab.id == activeTabFor(hostId)?.id);

  /// The `/terminal` screen's selection (the common case for callers that
  /// know no pane).
  String? get activeTabId => activeTabFor(terminalRouteHost)?.id;
  TerminalTab? get activeTab => activeTabFor(terminalRouteHost);
  int get activeIndex => activeIndexFor(terminalRouteHost);

  TerminalState copyWith({
    List<TerminalTab>? tabs,
    Map<String, String>? activeTabIds,
    bool? showShortcutsBar,
    Set<LatchedModifier>? latchedModifiers,
  }) {
    return TerminalState(
      tabs: tabs ?? this.tabs,
      activeTabIds: activeTabIds ?? this.activeTabIds,
      showShortcutsBar: showShortcutsBar ?? this.showShortcutsBar,
      latchedModifiers: latchedModifiers ?? this.latchedModifiers,
    );
  }
}

/// Platforms whose primary input is a soft keyboard — the on-screen key bar
/// is on by default there and off (toggleable) where a hardware keyboard is
/// the norm, as a desktop terminal would have it.
bool terminalKeyBarDefault(TargetPlatform platform) =>
    platform == TargetPlatform.android ||
    platform == TargetPlatform.iOS ||
    platform == TargetPlatform.fuchsia;

final terminalControllerProvider = NotifierProvider<TerminalController, TerminalState>(
  TerminalController.new,
);

class TerminalController extends Notifier<TerminalState> {
  int _nextTabId = 1;

  /// Pane colours reported to TUIs that query them (OSC 10/11) — the view
  /// keeps these in sync with the active palette; Campbell until then.
  (int, int, int) _paletteForeground = (0xCC, 0xCC, 0xCC);
  (int, int, int) _paletteBackground = (0x0C, 0x0C, 0x0C);

  void setPaletteColors({required Color foreground, required Color background}) {
    (int, int, int) rgb(Color c) => ((c.r * 255).round(), (c.g * 255).round(), (c.b * 255).round());
    _paletteForeground = rgb(foreground);
    _paletteBackground = rgb(background);
  }

  final List<TerminalTab> _activeTabs = [];
  final Map<String, Timer> _promptTimers = {};

  @override
  TerminalState build() {
    ref.onDispose(() {
      for (final timer in _promptTimers.values) {
        timer.cancel();
      }
      _promptTimers.clear();
      for (final tab in _activeTabs) {
        tab.dispose();
      }
      _activeTabs.clear();
    });
    return TerminalState(showShortcutsBar: terminalKeyBarDefault(defaultTargetPlatform));
  }

  /// How long a tab created in the background may wait for its first layout
  /// before the PTY is spawned at the 80×24 default anyway.
  static const _initGracePeriod = Duration(milliseconds: 400);

  TerminalTab createTab({
    String? title,
    required String projectPath,
    String hostId = terminalRouteHost,
    String? sessionId,
    String provider = 'claude',
    String? initialCommand,
    bool isPlainShell = true,
    bool isCommandMode = false,
    Map<String, String>? env,
    void Function(int exitCode)? onComplete,
    int? cols,
    int? rows,
    bool autoSelect = true,
    TerminalTabSpec? synced,
  }) {
    final tabIndex = _nextTabId++;
    final tabId = 'term-$tabIndex';
    final syncId = synced?.id ?? newTerminalTabSyncId();
    final terminal = Terminal(
      maxLines: 10000,
      inputHandler: const XtermInputHandler(),
      mouseHandler: XtermMouseHandler(),
    );
    final channel = ref.read(shellChannelProvider(tabId));

    final tabTitle =
        title ??
        (isCommandMode && initialCommand != null
            ? (initialCommand.length > 20
                  ? '${initialCommand.substring(0, 17)}...'
                  : initialCommand)
            : (isPlainShell ? t.terminal.tabs.shellName(index: tabIndex) : '$provider CLI'));

    // Every shell / CLI tab gets its own PTY (WT: every tab is a fresh
    // shell), keyed by its sync id so the account's other devices attach to
    // the same one. One-shot commands and agent sessions keep their own keys.
    final ptySessionId =
        synced?.ptySessionId ?? (!isCommandMode && sessionId == null ? syncId : null);

    final tab = TerminalTab(
      id: tabId,
      syncId: syncId,
      title: tabTitle,
      projectPath: projectPath,
      hostId: hostId,
      sessionId: sessionId,
      provider: provider,
      initialCommand: initialCommand,
      isPlainShell: isPlainShell,
      isCommandMode: isCommandMode,
      ptySessionId: ptySessionId,
      env: env,
      onComplete: onComplete,
      terminal: terminal,
      channel: channel,
      status: TerminalTabStatus.connecting,
    );

    terminal.onTitleChange = (value) {
      final next = value.trim().isEmpty ? null : value.trim();
      if (tab.appTitle == next) return;
      tab.appTitle = next;
      if (!tab.renamed) _notifyTabsChanged();
    };
    // OSC 52 — how a CLI on the server sets the viewer's clipboard (Claude
    // Code's /copy, tmux, nvim). Reads ('?') are never answered.
    terminal.onPrivateOSC = (code, args) {
      if (tab.replaying || code != '52' || args.length < 2 || args[1] == '?') return;
      try {
        unawaited(copyText(utf8.decode(base64.decode(args[1]))));
      } on FormatException {
        return;
      }
    };

    // Wire terminal user output -> channel input. Soft-keyboard typing lands
    // here too, so the key bar's latched Ctrl/Alt is applied on this path.
    terminal.onOutput = (data) {
      if (tab.replaying) return;
      channel.input(_consumeLatchedModifiers(data));
    };

    // The PTY must be spawned at the size the pane really has: a shell
    // started at the 80×24 placeholder draws its prompt for that width and
    // the later resize reflows it into overlapping lines. So `init` waits
    // for the view's first layout (xterm reports it through onResize) and
    // carries that size; a tab that is never laid out (created in the
    // background) still starts after a short grace period at the default.
    var initSent = false;
    void sendInit(int initCols, int initRows) {
      if (initSent) return;
      initSent = true;
      tab.initGraceTimer?.cancel();
      tab.initGraceTimer = null;
      channel.init(
        projectPath: projectPath,
        sessionId: sessionId ?? ptySessionId,
        provider: provider,
        hasSession: sessionId != null,
        initialCommand: initialCommand,
        isPlainShell: isPlainShell,
        // A one-shot command (install/update/login) is a fresh run: the server
        // keys PTYs by a short command prefix, so reattaching could land on a
        // stale run of a different command or account.
        forceRestart: isCommandMode,
        env: env,
        cols: initCols,
        rows: initRows,
      );
    }

    // Wire terminal resize -> channel resize (the first one spawns the PTY).
    terminal.onResize = (width, height, pixelWidth, pixelHeight) {
      if (!initSent) {
        sendInit(width, height);
        return;
      }
      channel.resize(width, height);
    };

    // Listen to incoming frames
    tab.subscription = channel.frames.listen(
      (ShellFrame frame) {
        _handleFrame(tab.id, frame);
      },
      onError: (Object err) {
        _handleError(tab.id, err.toString());
      },
      onDone: () {
        _handleDone(tab.id);
      },
    );

    // Open the socket now (`init` only stores its frame until the WS is
    // open, so the order does not matter); spawn with a known size right
    // away, otherwise at first layout — or after the grace period.
    if (cols != null && rows != null) {
      sendInit(cols, rows);
    } else {
      tab.initGraceTimer = Timer(_initGracePeriod, () {
        tab.initGraceTimer = null;
        if (_activeTabs.contains(tab)) sendInit(80, 24);
      });
    }
    unawaited(channel.connect());

    _activeTabs.add(tab);
    final newTabs = [...state.tabs, tab];
    state = state.copyWith(
      tabs: newTabs,
      activeTabIds: autoSelect || !state.activeTabIds.containsKey(hostId)
          ? _withActive(hostId, tabId)
          : null,
    );

    return tab;
  }

  Map<String, String> _withActive(String hostId, String? tabId) {
    final next = {...state.activeTabIds};
    if (tabId == null) {
      next.remove(hostId);
    } else {
      next[hostId] = tabId;
    }
    return next;
  }

  /// Hands a tab to another host (a workspace pane) — the live `Terminal`,
  /// `ShellChannel` and frame subscription stay as they are, so the shell
  /// keeps running and its buffer follows the tab.
  void moveTab(String tabId, {required String toHost}) {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null || tab.hostId == toHost) return;
    final fromHost = tab.hostId;
    tab.hostId = toHost;
    var active = {...state.activeTabIds, toHost: tabId};
    if (active[fromHost] == tabId) {
      active.remove(fromHost);
      final next = state.tabsFor(fromHost).firstOrNull;
      if (next != null) active = {...active, fromHost: next.id};
    }
    state = state.copyWith(tabs: [...state.tabs], activeTabIds: active);
  }

  // --- Cross-device tab rows (see TerminalHostSpec) ---

  /// This device's tab row of [hostId] as it is synced — command tabs left
  /// out. The active id follows [TerminalHostSpec.fromJson]'s rule, so a row
  /// applied by [applySyncedRow] derives back to exactly itself.
  TerminalHostSpec syncedRowFor(String hostId) {
    final tabs = [
      for (final tab in state.tabsFor(hostId))
        if (!tab.isCommandMode)
          TerminalTabSpec(
            id: tab.syncId,
            title: tab.title,
            renamed: tab.renamed,
            projectPath: tab.projectPath,
            provider: tab.provider,
            isPlainShell: tab.isPlainShell,
            sessionId: tab.sessionId,
            ptySessionId: tab.ptySessionId,
          ),
    ].take(maxSyncedTerminalTabs).toList();
    final active = state.activeTabFor(hostId)?.syncId;
    return TerminalHostSpec(
      tabs: tabs,
      activeTabId: tabs.any((t) => t.id == active) ? active : tabs.firstOrNull?.id,
    );
  }

  /// Makes [hostId]'s tabs match a row from another device: attaches the
  /// tabs it added (to the same PTYs), closes the ones it closed, and takes
  /// its order, titles and selection. Live tabs it already holds are kept
  /// as they are — buffer, socket and zoom untouched. Command tabs stay.
  void applySyncedRow(String hostId, TerminalHostSpec row) {
    final wanted = {for (final spec in row.tabs) spec.id};
    for (final tab in state.tabsFor(hostId)) {
      if (!tab.isCommandMode && !wanted.contains(tab.syncId)) closeTab(tab.id);
    }

    final local = {
      for (final tab in state.tabsFor(hostId))
        if (!tab.isCommandMode) tab.syncId: tab,
    };
    for (final spec in row.tabs) {
      final tab =
          local[spec.id] ??
          createTab(
            title: spec.title.isEmpty ? null : spec.title,
            projectPath: spec.projectPath,
            hostId: hostId,
            sessionId: spec.sessionId,
            provider: spec.provider,
            isPlainShell: spec.isPlainShell,
            autoSelect: false,
            synced: spec,
          );
      local[spec.id] = tab;
      if (spec.title.isNotEmpty) tab.title = spec.title;
      tab.renamed = spec.renamed;
    }

    // The row's order; command tabs follow it, other hosts keep their slots.
    final keep = [
      for (final spec in row.tabs) local[spec.id]!,
      for (final tab in state.tabsFor(hostId))
        if (tab.isCommandMode) tab,
    ];
    // A stray duplicate of a synced tab would break the slot fill below.
    for (final tab in state.tabsFor(hostId)) {
      if (!keep.contains(tab)) closeTab(tab.id);
    }
    final ordered = keep.iterator;
    final active = row.activeTabId == null ? null : local[row.activeTabId]?.id;
    state = state.copyWith(
      tabs: [
        for (final tab in state.tabs) tab.hostId == hostId ? (ordered..moveNext()).current : tab,
      ],
      activeTabIds: active == null ? null : _withActive(hostId, active),
    );
  }

  /// Closes the tabs of hosts that no longer exist (terminal panes closed
  /// here or on another device) — their sockets would keep the PTYs alive.
  void closeHostsExcept(Set<String> liveHosts) {
    for (final tab in [...state.tabs]) {
      if (tab.hostId != terminalRouteHost && !liveHosts.contains(tab.hostId)) closeTab(tab.id);
    }
  }

  void _handleFrame(String tabId, ShellFrame frame) {
    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex == -1) return;
    final tab = state.tabs[tabIndex];

    if (frame.isOutput) {
      tab.replaying = frame.isReplay;
      tab.terminal.write(tab.outputFilter.feed(frame.output));
      tab.replaying = false;
      // Answer the colour / mode probes the emulator cannot (theme detection
      // in OpenCode, Codex, Claude Code) — live ones only.
      final queries = tab.outputFilter.takeQueries();
      for (final query in frame.isReplay ? const <TerminalQuery>[] : queries) {
        tab.channel.input(
          terminalQueryReply(query, foreground: _paletteForeground, background: _paletteBackground),
        );
      }

      if (tab.status != TerminalTabStatus.connected && !tab.isCompleted) {
        tab.status = TerminalTabStatus.connected;
      }

      final match = _exitCodeRegex.firstMatch(frame.output);
      if (match != null) {
        final code = int.tryParse(match.group(1) ?? '0') ?? 0;
        tab.isCompleted = true;
        tab.exitCode = code;
        tab.status = TerminalTabStatus.exited;
        tab.onComplete?.call(code);
      }
      _schedulePromptScan(tab);
      _notifyTabsChanged();
    } else if (frame.isAuthUrl) {
      final url = frame.authUrl;
      if (url != null && !tab.authUrls.contains(url)) {
        tab.authUrls.add(url);
      }
      _notifyTabsChanged();
    } else if (frame.isError) {
      tab.terminal.write(
        '\r\n\x1b[31m${t.terminal.errors.frameError(message: frame.error ?? '')}\x1b[0m\r\n',
      );
      _notifyTabsChanged();
    }
  }

  void _handleError(String tabId, String errorMessage) {
    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex == -1) return;
    final tab = state.tabs[tabIndex];
    tab.terminal.write(
      '\r\n\x1b[31m${t.terminal.errors.connectionError(message: errorMessage)}\x1b[0m\r\n',
    );
    tab.status = TerminalTabStatus.disconnected;
    _clearPrompt(tab);
    _notifyTabsChanged();
  }

  void _handleDone(String tabId) {
    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex == -1) return;
    final tab = state.tabs[tabIndex];
    if (tab.status != TerminalTabStatus.exited) {
      tab.status = TerminalTabStatus.disconnected;
      _clearPrompt(tab);
      _notifyTabsChanged();
    }
  }

  // --- CLI prompt chips (web checkBufferForPrompt) ---

  /// Debounced buffer scan after each output frame (PROMPT_DEBOUNCE_MS).
  void _schedulePromptScan(TerminalTab tab) {
    _promptTimers[tab.id]?.cancel();
    _promptTimers[tab.id] = Timer(_promptDebounce, () {
      _promptTimers.remove(tab.id);
      _scanPrompt(tab);
    });
  }

  /// Scan the tail of the buffer for `❯ N. label` rows above an
  /// "esc to cancel"/"enter to select" footer; expose them as chips.
  void _scanPrompt(TerminalTab tab) {
    if (!state.tabs.contains(tab)) return;
    final buffer = tab.terminal.buffer;
    final lastRow = buffer.absoluteCursorY;
    final scanEnd = min(buffer.lines.length - 1, lastRow + 10);
    final scanStart = max(0, lastRow - _promptBufferScanLines);
    if (scanEnd <= scanStart) return;

    final lines = [
      for (var i = scanStart; i <= scanEnd; i++) buffer.lines[i].getText().trimRight(),
    ];

    var footerIdx = -1;
    for (var i = lines.length - 1; i >= 0; i--) {
      if (_promptFooterRegex.hasMatch(lines[i])) {
        footerIdx = i;
        break;
      }
    }
    if (footerIdx == -1) {
      _clearPrompt(tab);
      return;
    }

    // Non-matching lines are allowed (multi-line labels, separators).
    final optMap = <String, String>{};
    final optStart = max(0, footerIdx - _promptOptionScanLines);
    for (var i = footerIdx - 1; i >= optStart; i--) {
      final m = _promptOptionRegex.firstMatch(lines[i]);
      if (m == null) continue;
      final num = m.group(1)!;
      final label = m.group(2)!.trim();
      if (int.parse(num) <= _promptMaxOptions && label.isNotEmpty && !optMap.containsKey(num)) {
        optMap[num] = label;
      }
    }

    final options = <CliPromptOption>[];
    for (var i = 1; i <= optMap.length; i++) {
      final label = optMap['$i'];
      if (label == null) break;
      options.add((number: '$i', label: label));
    }

    final next = options.length >= _promptMinOptions ? options : null;
    final prev = tab.promptOptions;
    final changed = next == null
        ? prev != null
        : prev == null ||
              next.length != prev.length ||
              !List.generate(
                next.length,
                (i) => next[i].number == prev[i].number && next[i].label == prev[i].label,
              ).every((e) => e);
    tab.promptOptions = next;
    if (changed) _notifyTabsChanged();
  }

  void _clearPrompt(TerminalTab tab) {
    if (tab.promptOptions != null) {
      tab.promptOptions = null;
      _notifyTabsChanged();
    }
  }

  /// Answer a detected CLI prompt — sends the option digit (or `'\x1b'` for
  /// the Esc chip) and clears the chip row (web parity).
  void answerPrompt(String tabId, String input) {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null) return;
    tab.promptOptions = null;
    sendInput(tabId, input);
    _notifyTabsChanged();
  }

  /// Disconnect the socket without touching the PTY (web
  /// `disconnectFromShell({suppressAutoConnect: true})`) — the overlay's
  /// Connect CTA re-opens it via [connectTab].
  void disconnectTab(String tabId) {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null) return;
    _promptTimers[tabId]?.cancel();
    tab.promptOptions = null;
    unawaited(tab.channel.close());
    tab.status = TerminalTabStatus.disconnected;
    _notifyTabsChanged();
  }

  /// Re-open the socket — `start()` re-sends the init frame on open, so the
  /// server re-attaches the same PTY key and replays its ring buffer.
  void connectTab(String tabId) {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null) return;
    tab.status = TerminalTabStatus.connecting;
    unawaited(tab.channel.connect());
    _notifyTabsChanged();
  }

  /// Font zoom (web ShellHeader ±1px, clamped 9–24); Ctrl+0 resets.
  void zoomIn(String tabId) => _zoom(tabId, 1);
  void zoomOut(String tabId) => _zoom(tabId, -1);
  void zoomReset(String tabId) {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null || tab.fontSize == terminalFontSizeDefault) return;
    tab.fontSize = terminalFontSizeDefault;
    _notifyTabsChanged();
  }

  void _zoom(String tabId, double delta) {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null) return;
    final next = (tab.fontSize + delta).clamp(terminalFontSizeMin, terminalFontSizeMax);
    if (next == tab.fontSize) return;
    tab.fontSize = next;
    _notifyTabsChanged();
  }

  // --- Tab management (Windows Terminal tab-row semantics) ---

  /// Ctrl+Tab / Ctrl+Shift+Tab — wraps around both ends.
  void selectRelativeTab(int delta, {String hostId = terminalRouteHost}) {
    final tabs = state.tabsFor(hostId);
    if (tabs.length < 2) return;
    final index = state.activeIndexFor(hostId);
    final current = index < 0 ? 0 : index;
    final next = (current + delta) % tabs.length;
    selectTab(tabs[next < 0 ? next + tabs.length : next].id);
  }

  /// Ctrl+Alt+1..9 — 9 (or the last digit) always lands on the last tab.
  void selectTabAt(int index, {String hostId = terminalRouteHost}) {
    final tabs = state.tabsFor(hostId);
    if (tabs.isEmpty) return;
    selectTab(tabs[index.clamp(0, tabs.length - 1)].id);
  }

  /// Drag-reorder on the tab strip — indices are positions within the
  /// host's own row, [newIndex] the final one of the moved tab
  /// (`ReorderableListView.onReorderItem` semantics). Other hosts' tabs keep
  /// their slots in the full list.
  void reorderTab(int oldIndex, int newIndex, {String hostId = terminalRouteHost}) {
    final own = state.tabsFor(hostId);
    if (oldIndex < 0 || oldIndex >= own.length) return;
    final target = newIndex.clamp(0, own.length - 1);
    if (target == oldIndex) return;
    final moved = own.removeAt(oldIndex);
    own.insert(target, moved);
    final iterator = own.iterator;
    state = state.copyWith(
      tabs: [
        for (final tab in state.tabs) tab.hostId == hostId ? (iterator..moveNext()).current : tab,
      ],
    );
  }

  void renameTab(String tabId, String title) {
    final trimmed = title.trim();
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (trimmed.isEmpty || tab == null || (tab.renamed && tab.title == trimmed)) return;
    tab.title = trimmed;
    tab.renamed = true;
    _notifyTabsChanged();
  }

  /// Ctrl+Shift+D — a fresh tab with the same profile, placed right after
  /// the source tab.
  TerminalTab? duplicateTab(String tabId) {
    final source = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (source == null) return null;
    final index = state.tabsFor(source.hostId).indexOf(source);
    final tab = createTab(
      projectPath: source.projectPath,
      hostId: source.hostId,
      sessionId: source.sessionId,
      provider: source.provider,
      isPlainShell: source.isPlainShell,
      // One-shot commands are not re-run on duplicate — the copy is a plain
      // shell in the same directory, like duplicating a profile.
      title: source.isCommandMode ? null : source.title,
    );
    reorderTab(state.tabsFor(source.hostId).length - 1, index + 1, hostId: source.hostId);
    return tab;
  }

  void closeOtherTabs(String tabId) {
    final source = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (source == null) return;
    for (final tab in state.tabsFor(source.hostId)) {
      if (tab.id != tabId) closeTab(tab.id);
    }
  }

  void closeTabsToRight(String tabId) {
    final source = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (source == null) return;
    final own = state.tabsFor(source.hostId);
    for (final tab in own.sublist(own.indexOf(source) + 1)) {
      closeTab(tab.id);
    }
  }

  // --- Latched modifiers (on-screen key bar) ---

  void toggleLatchedModifier(LatchedModifier modifier) {
    final next = {...state.latchedModifiers};
    if (!next.remove(modifier)) next.add(modifier);
    state = state.copyWith(latchedModifiers: next);
  }

  void clearLatchedModifiers() {
    if (state.latchedModifiers.isEmpty) return;
    state = state.copyWith(latchedModifiers: const {});
  }

  /// Applies and releases the armed modifiers — one chord per tap, like the
  /// sticky-keys behaviour of mobile terminal key bars.
  String _consumeLatchedModifiers(String data) {
    final modifiers = state.latchedModifiers;
    if (modifiers.isEmpty) return data;
    final out = applyLatchedModifiers(data, modifiers);
    clearLatchedModifiers();
    return out;
  }

  /// Buffer contents for "Copy output" (trailing blank rows trimmed — the
  /// web port pops empty lines off the end before joining).
  String? copyOutputText(String tabId) {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null) return null;
    final lines = <String>[
      for (var i = 0; i < tab.terminal.buffer.lines.length; i++)
        tab.terminal.buffer.lines[i].getText().trimRight(),
    ];
    while (lines.isNotEmpty && lines.last.trim().isEmpty) {
      lines.removeLast();
    }
    if (lines.isEmpty) return null;
    return lines.join('\n');
  }

  void _notifyTabsChanged() {
    state = state.copyWith(tabs: [...state.tabs]);
  }

  void selectTab(String tabId) {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null || state.activeTabIds[tab.hostId] == tabId) return;
    state = state.copyWith(activeTabIds: _withActive(tab.hostId, tabId));
  }

  void closeTab(String tabId) {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null) return;

    _activeTabs.remove(tab);
    tab.dispose();

    final own = state.tabsFor(tab.hostId);
    final tabIndex = own.indexOf(tab);
    final remaining = state.tabs.where((t) => t.id != tabId).toList();
    var active = state.activeTabIds;

    if (state.activeTabFor(tab.hostId)?.id == tabId) {
      own.removeAt(tabIndex);
      final nextIdx = (tabIndex < own.length) ? tabIndex : own.length - 1;
      active = _withActive(tab.hostId, nextIdx < 0 ? null : own[nextIdx].id);
    }

    state = state.copyWith(tabs: remaining, activeTabIds: active);
  }

  /// Raw input from the key bar / prompt chips. Latched Ctrl/Alt apply here
  /// as well, so `Ctrl` then `▲` sends Ctrl+Up.
  void sendInput(String tabId, String data) {
    final tab = state.tabs.firstWhere(
      (t) => t.id == tabId,
      orElse: () => throw Exception('Tab not found'),
    );
    tab.channel.input(_consumeLatchedModifiers(data));
  }

  void resize(String tabId, int cols, int rows) {
    final tab = state.tabs.firstWhere(
      (t) => t.id == tabId,
      orElse: () => throw Exception('Tab not found'),
    );
    tab.channel.resize(cols, rows);
  }

  void restartTab(String tabId) {
    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex == -1) return;
    final tab = state.tabs[tabIndex];

    tab.terminal.write('\x1b[2J\x1b[3J\x1b[H');
    tab.isCompleted = false;
    tab.exitCode = null;
    tab.promptOptions = null;
    tab.status = TerminalTabStatus.connecting;

    tab.channel.init(
      projectPath: tab.projectPath,
      sessionId: tab.sessionId ?? tab.ptySessionId,
      provider: tab.provider,
      hasSession: tab.sessionId != null,
      initialCommand: tab.initialCommand,
      isPlainShell: tab.isPlainShell,
      forceRestart: true,
      env: tab.env,
      // The view is laid out already — restart at its real size.
      cols: tab.terminal.viewWidth,
      rows: tab.terminal.viewHeight,
    );
    // A disconnected tab needs the socket re-opened first (`init` only
    // sends when already open; `start()` re-sends it on reconnect anyway).
    unawaited(tab.channel.connect());

    _notifyTabsChanged();
  }

  void clearTab(String tabId) {
    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex == -1) return;
    state.tabs[tabIndex].terminal.write('\x1b[2J\x1b[3J\x1b[H');
    _notifyTabsChanged();
  }

  void toggleShortcutsBar() {
    state = state.copyWith(showShortcutsBar: !state.showShortcutsBar);
  }

  TerminalTab runOneShotCommand({
    required String projectPath,
    required String command,
    String? title,
    Map<String, String>? env,
    void Function(int exitCode)? onComplete,
  }) {
    return createTab(
      title: title ?? t.terminal.tabs.runTitle(command: command),
      projectPath: projectPath,
      initialCommand: command,
      isPlainShell: true,
      isCommandMode: true,
      env: env,
      onComplete: onComplete,
    );
  }

  TerminalTab runProviderLogin({
    required String projectPath,
    required String provider,
    void Function(int exitCode)? onComplete,
  }) {
    return createTab(
      title: t.terminal.tabs.loginTitle(provider: provider),
      projectPath: projectPath,
      provider: provider,
      initialCommand: providerLoginCommand(provider),
      isPlainShell: true,
      isCommandMode: true,
      onComplete: onComplete,
    );
  }
}

/// The most complete detected auth URL. Progressive TUI redraws emit
/// truncated fragments that are strict prefixes of the real link, so the
/// longest URL seen is the safest pick — `.last` can be a fragment emitted
/// mid-render. Used by the login dialog and the terminal banner.
String? bestAuthUrl(List<String> authUrls) =>
    authUrls.isEmpty ? null : authUrls.reduce((a, b) => b.length > a.length ? b : a);

/// The provider's interactive login shell command. Shared by the login
/// dialog, the terminal header and per-account logins (which wrap it in
/// `env KEY=VALUE …` overrides).
String providerLoginCommand(String provider) => switch (provider) {
  'claude' => 'claude --dangerously-skip-permissions /login',
  'cursor' => 'cursor-agent login',
  'codex' => 'codex login --device-auth',
  'opencode' => 'opencode auth login',
  // `command-code` is the canonical binary; `cmd`/`cmdc` are aliases.
  'commandcode' => 'command-code login',
  // `agy` is the Antigravity CLI binary — it has no login subcommand;
  // launching it interactively starts the Google sign-in flow.
  'antigravity' => 'agy',
  'devin' => 'devin login',
  _ => '$provider login',
};
