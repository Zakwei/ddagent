import 'dart:convert';
import 'dart:math';

import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:hive/hive.dart';

/// Multi-pane workspace (port of main-content/utils/splitWorkspace.ts +
/// workspacePanes.ts). Panes are first-class and persisted — the URL never
/// owns a session; a reload restores the exact same workspace. Agents run as
/// CLIs in terminal panes — there is no chat pane any more.
enum PaneKind { browser, terminal, notes, editor, git, preview }

class SplitPane {
  const SplitPane({
    required this.id,
    required this.kind,
    this.sessionId,
    this.projectId,
    this.url,
    this.filePath,
    this.device,
  });

  final String id;
  final PaneKind kind;
  final String? sessionId;
  final String? projectId;
  final String? url;

  /// Editor pane — the file currently open (web `editorFile` pane state).
  final String? filePath;

  /// Preview pane — the device preset id the app is framed in (see the
  /// server's app-preview device catalog). `null` = follow the target.
  final String? device;

  /// Fields are thunks so a field can be cleared: `url: () => null`.
  SplitPane copyWith({
    String? Function()? sessionId,
    String? Function()? projectId,
    String? Function()? url,
    String? Function()? filePath,
    String? Function()? device,
  }) => SplitPane(
    id: id,
    kind: kind,
    sessionId: sessionId != null ? sessionId() : this.sessionId,
    projectId: projectId != null ? projectId() : this.projectId,
    url: url != null ? url() : this.url,
    filePath: filePath != null ? filePath() : this.filePath,
    device: device != null ? device() : this.device,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'sessionId': ?sessionId,
    'projectId': ?projectId,
    'url': ?url,
    'filePath': ?filePath,
    'device': ?device,
  };

  static SplitPane? fromJson(Object? value) {
    if (value is! Map) return null;
    final id = value['id'];
    String? s(Object? v) => v is String && v.trim().isNotEmpty ? v : null;
    // A chat pane saved before panes went terminal-only: one bound to a
    // session becomes a terminal pane that resumes it in its CLI (the
    // terminal opens that tab when the pane has no tab row yet); an unbound
    // one (the old session picker) is dropped.
    final legacyChat = value['kind'] == 'chat';
    if (legacyChat && s(value['sessionId']) == null) return null;
    final kind = legacyChat ? PaneKind.terminal : PaneKind.values.asNameMap()[value['kind']];
    if (id is! String || id.isEmpty || kind == null) return null;
    return SplitPane(
      id: id,
      kind: kind,
      sessionId: s(value['sessionId']),
      projectId: s(value['projectId']),
      url: s(value['url']),
      filePath: s(value['filePath']),
      device: s(value['device']),
    );
  }
}

const maxSplitPanes = 6;

({int columns, int rows}) getSplitLayout(int paneCount) {
  if (paneCount <= 1) return (columns: 1, rows: 1);
  if (paneCount == 2) return (columns: 2, rows: 1);
  if (paneCount == 3) return (columns: 3, rows: 1);
  if (paneCount == 4) return (columns: 2, rows: 2);
  return (columns: 3, rows: 2);
}

int _paneIdCounter = 0;
final _rand = Random();

/// Upper bound for the random pane-id suffix. Must stay within
/// `Random.nextInt`'s contract (0 < max ≤ 2^32) — `1 << 32` truncates to 0
/// under dart2js, which made `nextInt` throw and silently killed every
/// "add pane" tap on the web build.
const kPaneIdSpace = 1 << 30;

String createPaneId() =>
    'split-pane-${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}-'
    '${(++_paneIdCounter).toRadixString(36)}-'
    '${_rand.nextInt(kPaneIdSpace).toRadixString(36).padLeft(7, '0').substring(0, 6)}';

bool canAddSplitPane(List<SplitPane> panes) => panes.length < maxSplitPanes;

List<SplitPane> addSplitPane(List<SplitPane> panes, SplitPane pane) {
  if (!canAddSplitPane(panes)) return panes;
  return [...panes, pane];
}

List<SplitPane> removeSplitPane(List<SplitPane> panes, String paneId) =>
    panes.where((p) => p.id != paneId).toList();

List<SplitPane> updateSplitPane(
  List<SplitPane> panes,
  String paneId,
  SplitPane Function(SplitPane) patch,
) => [for (final p in panes) p.id == paneId ? patch(p) : p];

List<SplitPane> reorderSplitPanes(List<SplitPane> panes, String fromId, int toIndex) {
  final from = panes.indexWhere((p) => p.id == fromId);
  if (from < 0) return panes;
  final clamped = toIndex.clamp(0, panes.length - 1);
  if (clamped == from) return panes;
  final next = [...panes];
  final moved = next.removeAt(from);
  next.insert(clamped, moved);
  return next;
}

/// What a pane tile should flag: a CLI in one of the pane's terminal tabs
/// waiting for the user to pick an option.
enum PaneAction { idle, question }

/// Localized display name of a pane kind.
String paneKindLabel(PaneKind kind) => switch (kind) {
  PaneKind.browser => t.workspace.paneTitle.browser,
  PaneKind.terminal => t.workspace.paneTitle.terminal,
  PaneKind.notes => t.workspace.paneTitle.notes,
  PaneKind.editor => t.workspace.paneTitle.editor,
  PaneKind.git => t.workspace.paneTitle.git,
  PaneKind.preview => t.workspace.paneTitle.preview,
};

/// [questionPaneIds]: panes with a terminal tab showing a CLI prompt.
({String title, String? subtitle, PaneAction action}) splitPaneDisplay(
  SplitPane pane, {
  Map<String, String> projectNames = const {},
  Set<String> questionPaneIds = const {},
}) {
  final subtitle = pane.projectId == null ? null : projectNames[pane.projectId];
  return (
    title: paneKindLabel(pane.kind),
    subtitle: pane.kind == PaneKind.browser || pane.kind == PaneKind.preview
        ? (Uri.tryParse(pane.url ?? '')?.host).let((h) => h == '' ? pane.url : h)
        : subtitle,
    action: questionPaneIds.contains(pane.id) ? PaneAction.question : PaneAction.idle,
  );
}

/// Host of the tabs shown on the standalone `/terminal` screen (and the
/// provider-login dialog). Workspace terminal panes use their pane id, so
/// every pane owns its own tab row and a tab can move between them.
const terminalRouteHost = 'route';

/// Upper bound of synced tabs per tab row — keeps the workspace payload far
/// below the server's 64KB cap.
const maxSyncedTerminalTabs = 24;

/// A tab id unique across the account's devices — also the tab's PTY key,
/// so it stays within the server's safe session-id alphabet.
String newTerminalTabSyncId() =>
    'tab-${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}-'
    '${_rand.nextInt(kPaneIdSpace).toRadixString(36)}';

/// One terminal tab as the account's devices share it: enough to attach to
/// the same server PTY and show the same strip entry, nothing live (buffer,
/// socket, zoom stay per device). One-shot command tabs are never synced —
/// restoring one would re-run the install/login.
class TerminalTabSpec {
  const TerminalTabSpec({
    required this.id,
    required this.title,
    required this.projectPath,
    this.renamed = false,
    this.provider = 'claude',
    this.isPlainShell = true,
    this.sessionId,
    this.ptySessionId,
  });

  /// Stable across devices (unlike the per-process local tab id).
  final String id;
  final String title;
  final bool renamed;
  final String projectPath;
  final String provider;
  final bool isPlainShell;

  /// Agent session the tab resumes.
  final String? sessionId;

  /// The tab's own PTY key on the server — every device attaches to it.
  final String? ptySessionId;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    if (renamed) 'renamed': true,
    'projectPath': projectPath,
    'provider': provider,
    'isPlainShell': isPlainShell,
    'sessionId': ?sessionId,
    'ptySessionId': ?ptySessionId,
  };

  static TerminalTabSpec? fromJson(Object? value) {
    if (value is! Map) return null;
    String? s(Object? v) => v is String && v.trim().isNotEmpty ? v : null;
    final id = s(value['id']);
    final projectPath = value['projectPath'];
    if (id == null || projectPath is! String) return null;
    return TerminalTabSpec(
      id: id,
      title: s(value['title']) ?? '',
      renamed: value['renamed'] == true,
      projectPath: projectPath,
      provider: s(value['provider']) ?? 'claude',
      isPlainShell: value['isPlainShell'] != false,
      sessionId: s(value['sessionId']),
      ptySessionId: s(value['ptySessionId']),
    );
  }
}

/// The synced tab row of one terminal host ([terminalRouteHost] or a
/// terminal pane id). An empty row is meaningful: the user closed every tab.
class TerminalHostSpec {
  const TerminalHostSpec({this.tabs = const [], this.activeTabId});

  final List<TerminalTabSpec> tabs;
  final String? activeTabId;

  Map<String, dynamic> toJson() => {
    'tabs': [for (final tab in tabs) tab.toJson()],
    'activeTabId': ?activeTabId,
  };

  /// Drops malformed and duplicate tabs; the active id always names a tab
  /// (or is null for an empty row), so every device derives the same value.
  static TerminalHostSpec fromJson(Object? value) {
    if (value is! Map) return const TerminalHostSpec();
    final raw = value['tabs'];
    final seen = <String>{};
    final tabs = [
      if (raw is List)
        for (final entry in raw)
          if (TerminalTabSpec.fromJson(entry) case final tab? when seen.add(tab.id)) tab,
    ].take(maxSyncedTerminalTabs).toList();
    return TerminalHostSpec(tabs: tabs, activeTabId: _validActive(value['activeTabId'], tabs));
  }

  static String? _validActive(Object? wanted, List<TerminalTabSpec> tabs) =>
      tabs.any((t) => t.id == wanted) ? wanted as String : tabs.firstOrNull?.id;

  String encode() => jsonEncode(toJson());
}

String? cleanupMaximizedPaneId(String? maximizedId, List<SplitPane> panes) =>
    maximizedId != null && !panes.any((p) => p.id == maximizedId) ? null : maximizedId;

extension<T> on T {
  R let<R>(R Function(T) f) => f(this);
}

// ─── Persistence ───────────────────────────────────────────────────────────

/// Persisted workspace descriptor (port of WorkspaceState).
class WorkspaceState {
  const WorkspaceState({
    this.panes = const [],
    this.activePaneId,
    this.lastUsedProjectId,
    this.terminals = const {},
    this.maximizedPaneId,
    this.serverLoaded = false,
  });

  final List<SplitPane> panes;
  final String? activePaneId;

  /// Most recently chosen workspace — the launcher's default project.
  final String? lastUsedProjectId;

  /// Terminal tab rows by host ([terminalRouteHost] or a terminal pane id).
  /// A host with no entry has never been opened; it gets a default tab.
  final Map<String, TerminalHostSpec> terminals;

  /// Transient (never persisted): the pane currently filling the workspace.
  final String? maximizedPaneId;

  /// Transient: the server's workspace has been read in this app run. Until
  /// then terminal tabs are neither attached nor seeded — a restored-from-disk
  /// row is a guess, and a seeded tab would duplicate another device's.
  final bool serverLoaded;

  /// Wire/persisted shape — shared with the web client's WorkspaceState so a
  /// workspace_state frame round-trips between Flutter and web untouched.
  Map<String, dynamic> toJson() => {
    'panes': [for (final p in panes) p.toJson()],
    'activePaneId': ?activePaneId,
    'lastUsedProjectId': ?lastUsedProjectId,
    // Sorted, so equal rows always serialize alike (sync compares JSON).
    if (terminals.isNotEmpty)
      'terminals': {
        for (final host in terminals.keys.toList()..sort()) host: terminals[host]!.toJson(),
      },
  };

  WorkspaceState copyWith({
    List<SplitPane>? panes,
    String? Function()? activePaneId,
    String? Function()? lastUsedProjectId,
    Map<String, TerminalHostSpec>? terminals,
    String? Function()? maximizedPaneId,
    bool? serverLoaded,
  }) => WorkspaceState(
    panes: panes ?? this.panes,
    activePaneId: activePaneId != null ? activePaneId() : this.activePaneId,
    lastUsedProjectId: lastUsedProjectId != null ? lastUsedProjectId() : this.lastUsedProjectId,
    terminals: terminals ?? this.terminals,
    maximizedPaneId: maximizedPaneId != null ? maximizedPaneId() : this.maximizedPaneId,
    serverLoaded: serverLoaded ?? this.serverLoaded,
  );

  static WorkspaceState sanitize(Object? value) {
    if (value is! Map) return const WorkspaceState();
    final raw = value['panes'];
    final panes = raw is List
        ? [for (final p in raw) ?SplitPane.fromJson(p)].take(maxSplitPanes).toList()
        : <SplitPane>[];
    final active = value['activePaneId'];
    final activeId = active is String && panes.any((p) => p.id == active)
        ? active
        : (panes.isEmpty ? null : panes.first.id);
    final last = value['lastUsedProjectId'];
    final rawTerminals = value['terminals'];
    return WorkspaceState(
      panes: panes,
      activePaneId: activeId,
      lastUsedProjectId: last is String && last.isNotEmpty ? last : null,
      terminals: rawTerminals is Map
          ? terminalHostsFor({
              for (final MapEntry(:key, :value) in rawTerminals.entries)
                if (key is String) key: TerminalHostSpec.fromJson(value),
            }, panes)
          : const {},
    );
  }

  /// Keeps the rows of hosts that still exist: the `/terminal` screen and
  /// open terminal panes. A closed pane takes its row with it.
  static Map<String, TerminalHostSpec> terminalHostsFor(
    Map<String, TerminalHostSpec> terminals,
    List<SplitPane> panes,
  ) {
    final hosts = {
      terminalRouteHost,
      for (final p in panes)
        if (p.kind == PaneKind.terminal) p.id,
    };
    return {
      for (final MapEntry(:key, :value) in terminals.entries)
        if (hosts.contains(key)) key: value,
    };
  }
}

class WorkspaceStorage {
  static const boxName = 'workspace';

  /// One saved layout per server: panes hold that server's session and
  /// project ids, which mean nothing on another one ("Session … was not
  /// found" after switching). The former single key is not migrated — it
  /// cannot tell which server it came from, and workspace-sync restores the
  /// layout from the server on connect anyway.
  static String _key(String serverUrl) => 'ddagent_workspace_panes@$serverUrl';

  static Box<dynamic> get _box => Hive.box<dynamic>(boxName);

  static WorkspaceState read(String serverUrl) {
    try {
      final raw = _box.get(_key(serverUrl));
      if (raw is! String) return const WorkspaceState();
      return WorkspaceState.sanitize(jsonDecode(raw));
    } on Object {
      return const WorkspaceState();
    }
  }

  static Future<void> write(WorkspaceState state, String serverUrl) async {
    try {
      await _box.put(_key(serverUrl), jsonEncode(state.toJson()));
    } on Object {
      // Storage unavailable — the workspace simply will not persist.
    }
  }

  /// Stable per-install id for workspace-sync (`originDeviceId` on wire). Same
  /// storage key as the web client (`localStorage['ddagent_device_id']`).
  static const _deviceIdKey = 'ddagent_device_id';

  static Future<String> deviceId() async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox<dynamic>(boxName);
      }
      final existing = _box.get(_deviceIdKey);
      if (existing is String && existing.isNotEmpty) return existing;
      final id =
          'flutter-${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}-'
          '${_rand.nextInt(kPaneIdSpace).toRadixString(36)}';
      await _box.put(_deviceIdKey, id);
      return id;
    } on Object {
      return 'flutter-unknown';
    }
  }

  /// Project the app should restore: focused pane wins, then any bound pane,
  /// then the launcher's last choice (port of pickWorkspaceProjectId).
  static String? pickProjectId(WorkspaceState s) {
    for (final p in s.panes) {
      if (p.id == s.activePaneId && p.projectId != null) return p.projectId;
    }
    for (final p in s.panes) {
      if (p.projectId != null) return p.projectId;
    }
    return s.lastUsedProjectId;
  }
}
