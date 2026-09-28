import 'dart:async';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/shell_channel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xterm/xterm.dart';

enum TerminalTabStatus {
  connecting,
  connected,
  disconnected,
  exited,
}

final _exitCodeRegex = RegExp(r'Process exited with code (\d+)');

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
  const TerminalState({
    this.tabs = const [],
    this.activeTabId,
    this.showShortcutsBar = true,
  });

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

  TerminalState copyWith({
    List<TerminalTab>? tabs,
    String? activeTabId,
    bool? showShortcutsBar,
  }) {
    return TerminalState(
      tabs: tabs ?? this.tabs,
      activeTabId: activeTabId ?? this.activeTabId,
      showShortcutsBar: showShortcutsBar ?? this.showShortcutsBar,
    );
  }
}

final terminalControllerProvider =
    NotifierProvider<TerminalController, TerminalState>(
  TerminalController.new,
);

class TerminalController extends Notifier<TerminalState> {
  int _nextTabId = 1;
  final List<TerminalTab> _activeTabs = [];

  @override
  TerminalState build() {
    ref.onDispose(() {
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

    final tabTitle = title ??
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

    // Initialize PTY session
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
    _notifyTabsChanged();
  }

  void _handleDone(String tabId) {
    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex == -1) return;
    final tab = state.tabs[tabIndex];
    if (tab.status != TerminalTabStatus.exited) {
      tab.status = TerminalTabStatus.disconnected;
      _notifyTabsChanged();
    }
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

    state = state.copyWith(
      tabs: remaining,
      activeTabId: newActiveId,
    );
  }

  void sendInput(String tabId, String data) {
    final tab = state.tabs.firstWhere((t) => t.id == tabId, orElse: () => throw Exception('Tab not found'));
    tab.channel.input(data);
  }

  void resize(String tabId, int cols, int rows) {
    final tab = state.tabs.firstWhere((t) => t.id == tabId, orElse: () => throw Exception('Tab not found'));
    tab.channel.resize(cols, rows);
  }

  void restartTab(String tabId) {
    final tabIndex = state.tabs.indexWhere((t) => t.id == tabId);
    if (tabIndex == -1) return;
    final tab = state.tabs[tabIndex];

    tab.terminal.write('\x1b[2J\x1b[3J\x1b[H');
    tab.isCompleted = false;
    tab.exitCode = null;
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
    final command = switch (provider) {
      'claude' => 'claude --dangerously-skip-permissions /login',
      'cursor' => 'cursor-agent login',
      'codex' => 'codex login --device-auth',
      'opencode' => 'opencode auth login',
      'devin' => 'devin login',
      _ => '$provider login',
    };

    return createTab(
      title: 'Login: $provider',
      projectPath: projectPath,
      provider: provider,
      initialCommand: command,
      isPlainShell: true,
      isCommandMode: true,
      onComplete: onComplete,
    );
  }
}
