import 'dart:async';
import 'dart:math';

import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/shell_channel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xterm/xterm.dart';

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

/// Terminal font bounds (web Shell zoom 9–24px).
const terminalFontSizeMin = 9.0;
const terminalFontSizeMax = 24.0;

final _exitCodeRegex = RegExp(r'Process exited with code (\d+)');
final _promptFooterRegex = RegExp(r'esc to cancel|enter to select', caseSensitive: false);
final _promptOptionRegex = RegExp(r'^\s*[❯›>]?\s*(\d+)\.\s+(.+)');

class TerminalTab {
  TerminalTab({
    required this.id,
    required this.title,
    required this.projectPath,
    this.sessionId,
    this.provider = 'claude',
    this.initialCommand,
    this.isPlainShell = true,
    this.isCommandMode = false,
    this.onComplete,
    required this.terminal,
    required this.channel,
    this.status = TerminalTabStatus.connecting,
    this.isCompleted = false,
    this.exitCode,
    List<String>? authUrls,
  }) : authUrls = authUrls ?? <String>[];

  final String id;
  final String title;
  final String projectPath;
  final String? sessionId;
  final String provider;
  final String? initialCommand;
  final bool isPlainShell;
  final bool isCommandMode;
  final void Function(int exitCode)? onComplete;
  final Terminal terminal;
  final ShellChannel channel;

  TerminalTabStatus status;
  bool isCompleted;
  int? exitCode;
  final List<String> authUrls;
  StreamSubscription<ShellFrame>? subscription;

  /// Terminal font size (web Shell zoom, default 14 there / 13 here).
  double fontSize = 13;

  /// CLI prompt options detected on the buffer (null = no prompt active).
  List<CliPromptOption>? promptOptions;

  void dispose() {
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
      title: title ?? this.title,
      projectPath: projectPath,
      sessionId: sessionId,
      provider: provider,
      initialCommand: initialCommand,
      isPlainShell: isPlainShell,
      isCommandMode: isCommandMode,
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
  const TerminalState({this.tabs = const [], this.activeTabId, this.showShortcutsBar = true});

  final List<TerminalTab> tabs;
  final String? activeTabId;
  final bool showShortcutsBar;

  TerminalTab? get activeTab {
    if (activeTabId == null || tabs.isEmpty) return null;
    for (final tab in tabs) {
      if (tab.id == activeTabId) return tab;
    }
    return tabs.first;
  }

  TerminalState copyWith({List<TerminalTab>? tabs, String? activeTabId, bool? showShortcutsBar}) {
    return TerminalState(
      tabs: tabs ?? this.tabs,
      activeTabId: activeTabId ?? this.activeTabId,
      showShortcutsBar: showShortcutsBar ?? this.showShortcutsBar,
    );
  }
}

final terminalControllerProvider = NotifierProvider<TerminalController, TerminalState>(
  TerminalController.new,
);

class TerminalController extends Notifier<TerminalState> {
  int _nextTabId = 1;
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
    return const TerminalState();
  }

  TerminalTab createTab({
    String? title,
    required String projectPath,
    String? sessionId,
    String provider = 'claude',
    String? initialCommand,
    bool isPlainShell = true,
    bool isCommandMode = false,
    void Function(int exitCode)? onComplete,
    int? cols,
    int? rows,
    bool autoSelect = true,
  }) {
    final tabIndex = _nextTabId++;
    final tabId = 'term-$tabIndex';
    final terminal = Terminal(maxLines: 10000);
    final channel = ref.read(shellChannelProvider(tabId));

    final tabTitle =
        title ??
        (isCommandMode && initialCommand != null
            ? (initialCommand.length > 20
                  ? '${initialCommand.substring(0, 17)}...'
                  : initialCommand)
            : (isPlainShell ? 'Shell $tabIndex' : '$provider CLI'));

    final tab = TerminalTab(
      id: tabId,
      title: tabTitle,
      projectPath: projectPath,
      sessionId: sessionId,
      provider: provider,
      initialCommand: initialCommand,
      isPlainShell: isPlainShell,
      isCommandMode: isCommandMode,
      onComplete: onComplete,
      terminal: terminal,
      channel: channel,
      status: TerminalTabStatus.connecting,
    );

    // Wire terminal user output -> channel input
    terminal.onOutput = (data) {
      channel.input(data);
    };

    // Wire terminal resize -> channel resize
    terminal.onResize = (width, height, pixelWidth, pixelHeight) {
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

    // Initialize PTY session + open the socket (`init` alone only stores the
    // frame — nothing reaches the server until the WS is open).
    channel.init(
      projectPath: projectPath,
      sessionId: sessionId,
      provider: provider,
      hasSession: sessionId != null,
      initialCommand: initialCommand,
      isPlainShell: isPlainShell,
      forceRestart: false,
      cols: cols ?? 80,
      rows: rows ?? 24,
    );
    unawaited(channel.connect());

    _activeTabs.add(tab);
    final newTabs = [...state.tabs, tab];
    state = state.copyWith(
      tabs: newTabs,
      activeTabId: autoSelect ? tabId : state.activeTabId ?? tabId,
    );

    return tab;
  }

  void _handleFrame(String tabId, ShellFrame frame) {
    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex == -1) return;
    final tab = state.tabs[tabIndex];

    if (frame.isOutput) {
      tab.terminal.write(frame.output);

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
      tab.terminal.write('\r\n\x1b[31m[Error] ${frame.error}\x1b[0m\r\n');
      _notifyTabsChanged();
    }
  }

  void _handleError(String tabId, String errorMessage) {
    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex == -1) return;
    final tab = state.tabs[tabIndex];
    tab.terminal.write('\r\n\x1b[31m[Connection Error] $errorMessage\x1b[0m\r\n');
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

  /// Font zoom (web ShellHeader ±1px, clamped 9–24).
  void zoomIn(String tabId) => _zoom(tabId, 1);
  void zoomOut(String tabId) => _zoom(tabId, -1);

  void _zoom(String tabId, double delta) {
    final tab = state.tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null) return;
    final next = (tab.fontSize + delta).clamp(terminalFontSizeMin, terminalFontSizeMax);
    if (next == tab.fontSize) return;
    tab.fontSize = next;
    _notifyTabsChanged();
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
    if (state.activeTabId != tabId) {
      state = state.copyWith(activeTabId: tabId);
    }
  }

  void closeTab(String tabId) {
    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex == -1) return;

    final tab = state.tabs[tabIndex];
    _activeTabs.remove(tab);
    tab.dispose();

    final remaining = state.tabs.where((t) => t.id != tabId).toList();
    String? newActiveId = state.activeTabId;

    if (state.activeTabId == tabId) {
      if (remaining.isNotEmpty) {
        final nextIdx = (tabIndex < remaining.length) ? tabIndex : remaining.length - 1;
        newActiveId = remaining[nextIdx].id;
      } else {
        newActiveId = null;
      }
    }

    state = state.copyWith(tabs: remaining, activeTabId: newActiveId);
  }

  void sendInput(String tabId, String data) {
    final tab = state.tabs.firstWhere(
      (t) => t.id == tabId,
      orElse: () => throw Exception('Tab not found'),
    );
    tab.channel.input(data);
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
      sessionId: tab.sessionId,
      provider: tab.provider,
      hasSession: tab.sessionId != null,
      initialCommand: tab.initialCommand,
      isPlainShell: tab.isPlainShell,
      forceRestart: true,
      cols: 80,
      rows: 24,
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
    void Function(int exitCode)? onComplete,
  }) {
    return createTab(
      title: title ?? 'Run: $command',
      projectPath: projectPath,
      initialCommand: command,
      isPlainShell: true,
      isCommandMode: true,
      onComplete: onComplete,
    );
  }

  TerminalTab runProviderLogin({
    required String projectPath,
    required String provider,
    void Function(int exitCode)? onComplete,
  }) {
    return createTab(
      title: 'Login: $provider',
      projectPath: projectPath,
      provider: provider,
      initialCommand: providerLoginCommand(provider),
      isPlainShell: true,
      isCommandMode: true,
      onComplete: onComplete,
    );
  }
}

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
