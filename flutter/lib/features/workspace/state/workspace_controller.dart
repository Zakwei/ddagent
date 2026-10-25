import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_sync.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// Persistent split workspace (port of useSplitWorkspace): panes survive
/// reloads, `maximizedPaneId` is transient and never persisted. Also mirrors
/// the workspace to the server so the account's other devices see the same
/// open panes (see WorkspaceSync for the protocol).
class WorkspaceController extends Notifier<WorkspaceState> {
  static const _resumeProbeTimeout = Duration(seconds: 4);

  WorkspaceSync? _sync;
  ChatChannel? _channel;
  Timer? _resumeProbe;
  String? _deviceId;
  String _serverUrl = '';
  StreamSubscription<ServerEvent>? _eventsSub;
  StreamSubscription<WsState>? _statesSub;

  @override
  WorkspaceState build() {
    // Rebuilt on a server switch: each server has its own saved layout.
    _serverUrl = ref.watch(serverBaseUrlProvider);
    final WorkspaceState initial;
    if (!Hive.isBoxOpen(WorkspaceStorage.boxName)) {
      unawaited(Hive.openBox<dynamic>(WorkspaceStorage.boxName));
      initial = const WorkspaceState();
    } else {
      initial = WorkspaceStorage.read(_serverUrl);
    }
    _wireSync();
    return initial;
  }

  /// Binds the /ws channel: re-fetch on every open, apply inbound states, and
  /// push local mutations through [_set]'s debounced schedulePush.
  void _wireSync() {
    final channel = ref.read(chatChannelProvider);
    _channel = channel;
    _sync = WorkspaceSync(
      // deviceId is informational on the wire (echo tagging); the resolved id
      // lands async from Hive — a boot placeholder is harmless meanwhile.
      deviceId: () => _deviceId ?? 'flutter-boot',
      getState: () => state,
      applyRemote: _applyRemote,
      send: channel.sendFrame,
      // Transient flag only — nothing to persist or push.
      onLoaded: () {
        if (!state.serverLoaded) state = state.copyWith(serverLoaded: true);
      },
    );
    _eventsSub = channel.events.listen((e) => _sync?.handleFrame(e.raw));
    _statesSub = channel.states.listen((s) {
      if (s == WsState.open) _sync?.requestSnapshot();
    });
    if (channel.wsState == WsState.open) _sync?.requestSnapshot();
    unawaited(WorkspaceStorage.deviceId().then((id) => _deviceId = id));
    ref.onDispose(() {
      _resumeProbe?.cancel();
      _sync?.dispose();
      unawaited(_eventsSub?.cancel());
      unawaited(_statesSub?.cancel());
    });
  }

  /// App going to the background (tab hidden, APK paused): send a pending
  /// debounced edit now — a suspended app may never fire the timer.
  void onAppBackgrounded() => _sync?.flush();

  /// App back in the foreground: the server's workspace wins, so re-read it.
  /// A socket that slept with the device may look open but be dead — if the
  /// snapshot doesn't arrive promptly, force a reconnect (whose open re-reads).
  void onAppResumed() {
    final channel = _channel;
    final sync = _sync;
    if (channel == null || sync == null) return;
    _resumeProbe?.cancel();
    if (channel.wsState != WsState.open) {
      channel.reconnectNow();
      return;
    }
    sync.requestSnapshot();
    _resumeProbe = Timer(_resumeProbeTimeout, () {
      if (sync.awaitingSnapshot) channel.reconnectNow();
    });
  }

  /// Remote workspace from another device — sanitized upstream by the sync
  /// controller; only the transient maximize flag needs a local cleanup.
  void _applyRemote(WorkspaceState next) {
    _set(
      next.copyWith(
        maximizedPaneId: () => cleanupMaximizedPaneId(state.maximizedPaneId, next.panes),
        serverLoaded: true,
      ),
    );
  }

  void _set(WorkspaceState next) {
    state = next;
    unawaited(WorkspaceStorage.write(next, _serverUrl));
    _sync?.schedulePush();
  }

  void setActivePaneId(String? id) {
    if (state.activePaneId == id) return;
    _set(state.copyWith(activePaneId: () => id));
  }

  void setLastUsedProjectId(String? id) {
    if (state.lastUsedProjectId == id) return;
    _set(state.copyWith(lastUsedProjectId: () => id));
  }

  /// Add a pane and focus it. Kind-specific fields ride on `pane`.
  /// Returns the new pane's id, or null when the workspace is full.
  String? openPane(
    PaneKind kind, {
    String? sessionId,
    String? projectId,
    String? url,
    String? filePath,
    String? device,
  }) {
    if (!canAddSplitPane(state.panes)) return null;
    final pane = SplitPane(
      id: createPaneId(),
      kind: kind,
      sessionId: sessionId,
      projectId: projectId,
      url: url,
      filePath: filePath,
      device: device,
    );
    _set(state.copyWith(panes: addSplitPane(state.panes, pane), activePaneId: () => pane.id));
    return pane.id;
  }

  void removePane(String id) {
    final closedIndex = state.panes.indexWhere((p) => p.id == id);
    if (closedIndex < 0) return;
    final next = removeSplitPane(state.panes, id);
    // Focus the neighbor sliding into the closed slot, not pane 0.
    final active = state.activePaneId == id
        ? (next.isEmpty ? null : next[closedIndex < next.length ? closedIndex : next.length - 1].id)
        : state.activePaneId;
    _set(
      state.copyWith(
        panes: next,
        activePaneId: () => active,
        terminals: WorkspaceState.terminalHostsFor(state.terminals, next),
        maximizedPaneId: () => cleanupMaximizedPaneId(state.maximizedPaneId, next),
      ),
    );
  }

  /// A terminal host's tab row changed on this device.
  void setTerminalHost(String hostId, TerminalHostSpec row) {
    if (state.terminals[hostId]?.encode() == row.encode()) return;
    _set(
      state.copyWith(
        terminals: WorkspaceState.terminalHostsFor({...state.terminals, hostId: row}, state.panes),
      ),
    );
  }

  void updatePane(
    String id, {
    String? Function()? sessionId,
    String? Function()? projectId,
    String? Function()? url,
    String? Function()? filePath,
    String? Function()? device,
  }) {
    final next = updateSplitPane(
      state.panes,
      id,
      (p) => p.copyWith(
        sessionId: sessionId,
        projectId: projectId,
        url: url,
        filePath: filePath,
        device: device,
      ),
    );
    _set(state.copyWith(panes: next));
  }

  /// Chat → file open (web `openFileInEditor`): focuses an existing editor
  /// pane bound to the same project, else splits a new editor pane.
  void openFileInEditor(String? projectId, String filePath) {
    for (final p in state.panes) {
      if (p.kind == PaneKind.editor && p.projectId == projectId) {
        updatePane(p.id, filePath: () => filePath);
        _set(state.copyWith(activePaneId: () => p.id));
        return;
      }
    }
    openPane(PaneKind.editor, projectId: projectId, filePath: filePath);
  }

  /// Opens an agent session as a terminal tab running its CLI with
  /// `--resume`. A tab already showing the session is focused instead (a
  /// second one would attach the same PTY). Otherwise the tab goes to the
  /// active terminal pane, else the first one, else a new pane — or, in a
  /// full workspace, the standalone terminal. The tab is added to the synced
  /// row, so the host's terminal screen attaches it (now or once mounted)
  /// and the account's other devices see it too. Returns the host the tab
  /// is in, or null when that row is full. [newPane] skips the existing
  /// panes (side-by-side compare).
  String? openSessionTab({
    required String sessionId,
    required String provider,
    required String projectPath,
    String? projectId,
    String? title,
    bool newPane = false,
  }) {
    for (final MapEntry(key: host, value: row) in state.terminals.entries) {
      final open = row.tabs.where((tab) => tab.sessionId == sessionId).firstOrNull;
      if (open == null) continue;
      setTerminalHost(host, TerminalHostSpec(tabs: row.tabs, activeTabId: open.id));
      _focusHost(host);
      return host;
    }

    final terminals = [
      for (final p in state.panes)
        if (p.kind == PaneKind.terminal) p,
    ];
    final host =
        (newPane ? null : terminals.where((p) => p.id == state.activePaneId).firstOrNull?.id) ??
        (newPane ? null : terminals.firstOrNull?.id) ??
        openPane(PaneKind.terminal, projectId: projectId) ??
        terminalRouteHost;
    final row = state.terminals[host] ?? const TerminalHostSpec();
    if (row.tabs.length >= maxSyncedTerminalTabs) return null;
    final tab = TerminalTabSpec(
      id: newTerminalTabSyncId(),
      title: title ?? '',
      projectPath: projectPath,
      provider: provider,
      isPlainShell: false,
      sessionId: sessionId,
    );
    setTerminalHost(host, TerminalHostSpec(tabs: [...row.tabs, tab], activeTabId: tab.id));
    _focusHost(host);
    return host;
  }

  /// Brings a terminal pane forward — focused, and not hidden behind
  /// another pane's maximized view.
  void _focusHost(String host) {
    if (host == terminalRouteHost) return;
    setActivePaneId(host);
    final maximized = state.maximizedPaneId;
    if (maximized != null && maximized != host) toggleMaximize(maximized);
  }

  void reorderPanes(String fromId, int toIndex) {
    _set(state.copyWith(panes: reorderSplitPanes(state.panes, fromId, toIndex)));
  }

  void toggleMaximize(String id) {
    _set(state.copyWith(maximizedPaneId: () => state.maximizedPaneId == id ? null : id));
  }

  bool get canAdd => canAddSplitPane(state.panes);
}

final workspaceProvider = NotifierProvider<WorkspaceController, WorkspaceState>(
  WorkspaceController.new,
);
