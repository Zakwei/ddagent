import 'dart:convert';
import 'dart:math';

import 'package:hive/hive.dart';

/// Multi-pane workspace (port of main-content/utils/splitWorkspace.ts +
/// workspacePanes.ts). Panes are first-class and persisted — the URL never
/// owns a session; a reload restores the exact same workspace.
enum PaneKind { chat, browser, terminal, notes, editor, git }

class SplitPane {
  const SplitPane({
    required this.id,
    required this.kind,
    this.sessionId,
    this.projectId,
    this.url,
    this.filePath,
    this.picker = false,
  });

  final String id;
  final PaneKind kind;
  final String? sessionId;
  final String? projectId;
  final String? url;

  /// Editor pane — the file currently open (web `editorFile` pane state).
  final String? filePath;

  /// Chat pane renders the session picker instead of the chat UI.
  final bool picker;

  SplitPane copyWith({
    String? sessionId,
    String? projectId,
    String? url,
    String? filePath,
    bool? picker,
  }) => SplitPane(
    id: id,
    kind: kind,
    sessionId: sessionId ?? this.sessionId,
    projectId: projectId ?? this.projectId,
    url: url ?? this.url,
    filePath: filePath ?? this.filePath,
    picker: picker ?? this.picker,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'sessionId': ?sessionId,
    'projectId': ?projectId,
    'url': ?url,
    'filePath': ?filePath,
    if (picker) 'picker': true,
  };

  static SplitPane? fromJson(Object? value) {
    if (value is! Map) return null;
    final id = value['id'];
    final kind = PaneKind.values.asNameMap()[value['kind']];
    if (id is! String || id.isEmpty || kind == null) return null;
    String? s(Object? v) => v is String && v.trim().isNotEmpty ? v : null;
    return SplitPane(
      id: id,
      kind: kind,
      sessionId: s(value['sessionId']),
      projectId: s(value['projectId']),
      url: s(value['url']),
      filePath: s(value['filePath']),
      picker: value['picker'] == true,
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

/// What a pane tile should flag: an unanswered question beats "busy".
enum PaneAction { idle, processing, question }

PaneAction paneAction(
  SplitPane pane, {
  required Set<String> processingSessionIds,
  required Set<String> pendingActionSessionIds,
}) {
  if (pane.kind != PaneKind.chat || pane.sessionId == null) {
    return PaneAction.idle;
  }
  if (pendingActionSessionIds.contains(pane.sessionId)) {
    return PaneAction.question;
  }
  if (processingSessionIds.contains(pane.sessionId)) {
    return PaneAction.processing;
  }
  return PaneAction.idle;
}

({String title, String? subtitle, PaneAction action}) splitPaneDisplay(
  SplitPane pane, {
  Map<String, String> sessionTitles = const {},
  Map<String, String> projectNames = const {},
  Set<String> processingSessionIds = const {},
  Set<String> pendingActionSessionIds = const {},
}) {
  final subtitle = pane.projectId == null ? null : projectNames[pane.projectId];
  final title = switch (pane.kind) {
    PaneKind.browser => 'Browser',
    PaneKind.terminal => 'Terminal',
    PaneKind.notes => 'Shared notes',
    PaneKind.editor => 'Editor',
    PaneKind.git => 'Git',
    PaneKind.chat =>
      sessionTitles[pane.sessionId] ??
          (pane.sessionId != null
              ? pane.sessionId!.substring(
                  0,
                  pane.sessionId!.length < 8 ? pane.sessionId!.length : 8,
                )
              : 'Chat'),
  };
  return (
    title: title,
    subtitle: pane.kind == PaneKind.browser
        ? (Uri.tryParse(pane.url ?? '')?.host).let((h) => h == '' ? pane.url : h)
        : subtitle,
    action: paneAction(
      pane,
      processingSessionIds: processingSessionIds,
      pendingActionSessionIds: pendingActionSessionIds,
    ),
  );
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
    this.maximizedPaneId,
  });

  final List<SplitPane> panes;
  final String? activePaneId;

  /// Most recently chosen workspace — the launcher's default project.
  final String? lastUsedProjectId;

  /// Transient (never persisted): the pane currently filling the workspace.
  final String? maximizedPaneId;

  /// Wire/persisted shape — shared with the web client's WorkspaceState so a
  /// workspace_state frame round-trips between Flutter and web untouched.
  Map<String, dynamic> toJson() => {
    'panes': [for (final p in panes) p.toJson()],
    'activePaneId': ?activePaneId,
    'lastUsedProjectId': ?lastUsedProjectId,
  };

  WorkspaceState copyWith({
    List<SplitPane>? panes,
    String? Function()? activePaneId,
    String? Function()? lastUsedProjectId,
    String? Function()? maximizedPaneId,
  }) => WorkspaceState(
    panes: panes ?? this.panes,
    activePaneId: activePaneId != null ? activePaneId() : this.activePaneId,
    lastUsedProjectId: lastUsedProjectId != null ? lastUsedProjectId() : this.lastUsedProjectId,
    maximizedPaneId: maximizedPaneId != null ? maximizedPaneId() : this.maximizedPaneId,
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
    return WorkspaceState(
      panes: panes,
      activePaneId: activeId,
      lastUsedProjectId: last is String && last.isNotEmpty ? last : null,
    );
  }
}

class WorkspaceStorage {
  static const boxName = 'workspace';
  static const _key = 'ddagent_workspace_panes';

  static Box<dynamic> get _box => Hive.box<dynamic>(boxName);

  static WorkspaceState read() {
    try {
      final raw = _box.get(_key);
      if (raw is! String) return const WorkspaceState();
      return WorkspaceState.sanitize(jsonDecode(raw));
    } on Object {
      return const WorkspaceState();
    }
  }

  static Future<void> write(WorkspaceState state) async {
    try {
      await _box.put(_key, jsonEncode(state.toJson()));
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

// ─── Broadcast helpers (port of broadcastSessionUtils.ts) ──────────────────

bool isOrchestratorSession(Map<String, dynamic> session) {
  final provider = session['provider'] ?? session['__provider'];
  return provider == 'orchestrator' || provider == 'mini-orchestrator';
}
