import 'dart:async';

import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// Persistent split workspace (port of useSplitWorkspace): panes survive
/// reloads, `maximizedPaneId` is transient and never persisted.
class WorkspaceController extends Notifier<WorkspaceState> {
  @override
  WorkspaceState build() {
    if (!Hive.isBoxOpen(WorkspaceStorage.boxName)) {
      unawaited(Hive.openBox<dynamic>(WorkspaceStorage.boxName));
      return const WorkspaceState();
    }
    return WorkspaceStorage.read();
  }

  void _set(WorkspaceState next) {
    state = next;
    unawaited(WorkspaceStorage.write(next));
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
  void openPane(
    PaneKind kind, {
    String? sessionId,
    String? projectId,
    String? url,
    String? filePath,
    bool picker = false,
  }) {
    if (!canAddSplitPane(state.panes)) return;
    final pane = SplitPane(
      id: createPaneId(),
      kind: kind,
      sessionId: sessionId,
      projectId: projectId,
      url: url,
      filePath: filePath,
      picker: picker,
    );
    _set(
      state.copyWith(
        panes: addSplitPane(state.panes, pane),
        activePaneId: () => pane.id,
      ),
    );
  }

  void removePane(String id) {
    final closedIndex = state.panes.indexWhere((p) => p.id == id);
    if (closedIndex < 0) return;
    final next = removeSplitPane(state.panes, id);
    // Focus the neighbor sliding into the closed slot, not pane 0.
    final active = state.activePaneId == id
        ? (next.isEmpty
              ? null
              : next[closedIndex < next.length ? closedIndex : next.length - 1]
                    .id)
        : state.activePaneId;
    _set(
      state.copyWith(
        panes: next,
        activePaneId: () => active,
        maximizedPaneId: () =>
            cleanupMaximizedPaneId(state.maximizedPaneId, next),
      ),
    );
  }

  void updatePane(
    String id, {
    String? Function()? sessionId,
    String? Function()? projectId,
    String? Function()? url,
    String? Function()? filePath,
    bool? picker,
  }) {
    final next = updateSplitPane(
      state.panes,
      id,
      (p) => p.copyWith(
        sessionId: sessionId != null ? sessionId() : p.sessionId,
        projectId: projectId != null ? projectId() : p.projectId,
        url: url != null ? url() : p.url,
        filePath: filePath != null ? filePath() : p.filePath,
        picker: picker ?? p.picker,
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

  void reorderPanes(String fromId, int toIndex) {
    _set(
      state.copyWith(panes: reorderSplitPanes(state.panes, fromId, toIndex)),
    );
  }

  void toggleMaximize(String id) {
    _set(
      state.copyWith(
        maximizedPaneId: () => state.maximizedPaneId == id ? null : id,
      ),
    );
  }

  bool get canAdd => canAddSplitPane(state.panes);
}

final workspaceProvider = NotifierProvider<WorkspaceController, WorkspaceState>(
  WorkspaceController.new,
);
