import 'dart:convert';
import 'dart:math';

import 'package:hive/hive.dart';

/// Multi-pane workspace (port of main-content/utils/splitWorkspace.ts +
/// workspacePanes.ts). Panes are first-class and persisted — the URL never
/// owns a session; a reload restores the exact same workspace.
enum PaneKind { chat, browser, terminal, preview, notes, editor, git }

class SplitPane {
  const SplitPane({
    required this.id,
    required this.kind,
    this.sessionId,
    this.projectId,
    this.url,
    this.picker = false,
  });

  final String id;
  final PaneKind kind;
  final String? sessionId;
  final String? projectId;
  final String? url;

  /// Chat pane renders the session picker instead of the chat UI.
  final bool picker;

  SplitPane copyWith({
    String? sessionId,
    String? projectId,
    String? url,
    bool? picker,
  }) => SplitPane(
    id: id,
    kind: kind,
    sessionId: sessionId ?? this.sessionId,
    projectId: projectId ?? this.projectId,
    url: url ?? this.url,
    picker: picker ?? this.picker,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind.name,
    'sessionId': ?sessionId,
    'projectId': ?projectId,
    'url': ?url,
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

String createPaneId() =>
    'split-pane-${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}-'
    '${(++_paneIdCounter).toRadixString(36)}-'
    '${_rand.nextInt(1 << 32).toRadixString(36).padLeft(7, '0').substring(0, 6)}';

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

List<SplitPane> reorderSplitPanes(
  List<SplitPane> panes,
  String fromId,
  int toIndex,
) {
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
    PaneKind.preview => 'Preview',
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
        ? (Uri.tryParse(
            pane.url ?? '',
          )?.host).let((h) => h == '' ? pane.url : h)
        : subtitle,
    action: paneAction(
      pane,
      processingSessionIds: processingSessionIds,
      pendingActionSessionIds: pendingActionSessionIds,
    ),
  );
}

String? cleanupMaximizedPaneId(String? maximizedId, List<SplitPane> panes) =>
    maximizedId != null && !panes.any((p) => p.id == maximizedId)
    ? null
    : maximizedId;

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

  WorkspaceState copyWith({
    List<SplitPane>? panes,
    String? Function()? activePaneId,
    String? Function()? lastUsedProjectId,
    String? Function()? maximizedPaneId,
  }) => WorkspaceState(
    panes: panes ?? this.panes,
    activePaneId: activePaneId != null ? activePaneId() : this.activePaneId,
    lastUsedProjectId: lastUsedProjectId != null
        ? lastUsedProjectId()
        : this.lastUsedProjectId,
    maximizedPaneId: maximizedPaneId != null
        ? maximizedPaneId()
        : this.maximizedPaneId,
  );

  static WorkspaceState sanitize(Object? value) {
    if (value is! Map) return const WorkspaceState();
    final raw = value['panes'];
    final panes = raw is List
        ? [for (final p in raw) ?SplitPane.fromJson(p)]
              .take(maxSplitPanes)
              .toList()
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
      await _box.put(
        _key,
        jsonEncode({
          'panes': [for (final p in state.panes) p.toJson()],
          'activePaneId': ?state.activePaneId,
          'lastUsedProjectId': ?state.lastUsedProjectId,
        }),
      );
    } on Object {
      // Storage unavailable — the workspace simply will not persist.
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

bool isOrchestratorSession(Map<String, dynamic> session) =>
    (session['provider'] ?? session['__provider']) == 'orchestrator';
