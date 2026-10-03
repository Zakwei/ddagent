import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_nav_menu.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/browser/view/web_browser_pane.dart';
import 'package:ddagent_app/features/chat/state/pending_permissions.dart';
import 'package:ddagent_app/features/chat/view/transcript_view.dart';
import 'package:ddagent_app/features/editor/view/editor_screen.dart';
import 'package:ddagent_app/features/git/view/git_screen.dart';
import 'package:ddagent_app/features/orchestrator/state/orchestrator_controller.dart';
import 'package:ddagent_app/features/preview/view/preview_pane.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/activity_poller.dart';
import 'package:ddagent_app/features/sessions/state/session_activity.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/shared_context/view/shared_notes_pane.dart';
import 'package:ddagent_app/features/terminal/view/terminal_screen.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/features/workspace/view/pane_header_metrics.dart';
import 'package:ddagent_app/features/workspace/view/pane_session_header.dart';
import 'package:ddagent_app/features/workspace/view/session_picker.dart';
import 'package:ddagent_app/features/workspace/view/split_workspace_grid.dart';
import 'package:ddagent_app/features/workspace/view/workspace_dialogs.dart';
import 'package:ddagent_app/features/workspace/view/workspace_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Multi-pane workspace (T19, port of MainContent.tsx): toolbar +
/// SplitWorkspaceGrid + overview/broadcast dialogs. Pane bodies other than
/// chat are placeholders until T20–T31 land.
class WorkspaceScreen extends ConsumerStatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  ConsumerState<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends ConsumerState<WorkspaceScreen> {
  bool _overviewOpen = false;
  bool _broadcastOpen = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  /// Escape restores the split layout — unless a dialog route owns the key.
  bool _onKey(KeyEvent e) {
    if (e is! KeyDownEvent || e.logicalKey != LogicalKeyboardKey.escape || !mounted) {
      return false;
    }
    if (_overviewOpen || _broadcastOpen || ModalRoute.of(context)?.isCurrent != true) {
      return false;
    }
    final ws = ref.read(workspaceProvider);
    final maxId = ws.maximizedPaneId;
    if (maxId == null || !ws.panes.any((p) => p.id == maxId)) return false;
    ref.read(workspaceProvider.notifier).toggleMaximize(maxId);
    return false; // never consume — let fields still see the key
  }

  String? get _defaultProjectId {
    final s = ref.read(workspaceProvider);
    return WorkspaceStorage.pickProjectId(s);
  }

  void _addChat() {
    ref
        .read(workspaceProvider.notifier)
        .openPane(PaneKind.chat, projectId: _defaultProjectId, picker: true);
  }

  /// "Sessions" toolbar action: retarget the focused chat pane to picker
  /// state rather than stacking a fresh tile.
  void _browseSessions() {
    final ws = ref.read(workspaceProvider);
    final ctrl = ref.read(workspaceProvider.notifier);
    for (final p in ws.panes) {
      if (p.id == ws.activePaneId && p.kind == PaneKind.chat) {
        ctrl.updatePane(p.id, picker: true);
        return;
      }
    }
    ctrl.openPane(PaneKind.chat, projectId: _defaultProjectId, picker: true);
  }

  void _add(PaneKind kind) {
    ref.read(workspaceProvider.notifier).openPane(kind, projectId: _defaultProjectId);
  }

  Map<String, String> _sessionTitles(List<Session> sessions) => {
    for (final s in sessions) s.sessionId: s.displayTitle,
  };

  Map<String, String> _projectNames(ProjectsState p) => {
    for (final pr in p.projects) pr.projectId: pr.displayName,
  };

  @override
  Widget build(BuildContext context) {
    final ws = ref.watch(workspaceProvider);
    final ctrl = ref.read(workspaceProvider.notifier);
    final sessions = ref.watch(sessionsProvider(_scope)).sessions;
    final projects = ref.watch(projectsProvider);
    // Keep the server's running-session pulse alive while the workspace is
    // mounted (web AppContent polls /sessions/running every 5 s).
    ref.watch(activityPollerProvider);
    final processingIds = ref.watch(sessionActivityProvider).keys.toSet();
    final pendingIds = ref.watch(pendingPermissionSessionsProvider);

    // An empty workspace renders nothing, which makes "new session"
    // unreachable — seed one chat pane in picker state so the session list
    // is the first thing on screen (React AppContent.tsx:311).
    if (ws.panes.isEmpty && !projects.loading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && ref.read(workspaceProvider).panes.isEmpty) {
          ref.read(workspaceProvider.notifier).openPane(PaneKind.chat, picker: true);
        }
      });
    }

    // paneSessionAudit parity — a persisted pane bound to an archived
    // session would mount a dead chat; resolve unknown ids once and reset
    // those panes to the picker.
    if (!projects.loading) {
      final known = <String>{
        for (final p in projects.projects)
          for (final s in p.sessions) (s['id'] ?? s['sessionId'] ?? '').toString(),
        for (final s in sessions) s.sessionId,
      };
      final unknown = [
        for (final p in ws.panes)
          if (p.kind == PaneKind.chat &&
              p.sessionId != null &&
              !known.contains(p.sessionId) &&
              !_auditedSessions.contains(p.sessionId))
            p,
      ];
      if (unknown.isNotEmpty) {
        for (final p in unknown) {
          _auditedSessions.add(p.sessionId!);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(_auditPanes(unknown));
        });
      }
    }

    final sessionTitles = _sessionTitles(sessions);
    final projectNames = _projectNames(projects);
    ({String title, String? subtitle, PaneAction action}) display(SplitPane p) => splitPaneDisplay(
      p,
      sessionTitles: sessionTitles,
      projectNames: projectNames,
      processingSessionIds: processingIds,
      pendingActionSessionIds: pendingIds,
    );

    final overviewPanes = [for (final p in ws.panes) (pane: p, display: display(p))];

    return Scaffold(
      body: Column(
        children: [
          _controls(
            canAdd: ctrl.canAdd,
            overviewPanes: overviewPanes,
            activePaneId: ws.activePaneId,
            onSelectPane: (id) {
              ctrl.setActivePaneId(id);
              setState(() => _overviewOpen = false);
            },
          ),
          Expanded(
            child: SplitWorkspaceGrid(
              panes: ws.panes,
              activePaneId: ws.activePaneId,
              onActivatePane: ctrl.setActivePaneId,
              onClosePane: ctrl.removePane,
              onReorderPanes: ctrl.reorderPanes,
              maximizedPaneId: ws.maximizedPaneId,
              onToggleMaximizePane: ctrl.toggleMaximize,
              paneTitle: (p) => display(p).title,
              renderPaneHeaderContent: (p) => _headerContent(p, display(p), sessions, projects),
              renderPane: (p, isActive) => _paneBody(p, isActive, sessions, processingIds),
            ),
          ),
        ],
      ),
    );
  }

  static const _scope = (null, null);

  /// Session ids already checked against sessionDetails (paneSessionAudit).
  final _auditedSessions = <String>{};

  /// Unknown session ids resolve once; `isArchived` clears the pane back to
  /// the picker. Failed lookups leave the pane alone.
  Future<void> _auditPanes(List<SplitPane> panes) async {
    for (final pane in panes) {
      final id = pane.sessionId;
      if (id == null) continue;
      try {
        final details = await ref.read(sessionsRepositoryProvider).details(id);
        if (!mounted) return;
        if (details.isArchived) {
          ref
              .read(workspaceProvider.notifier)
              .updatePane(pane.id, sessionId: () => null, picker: true);
        }
      } on Object {
        // Lookup failed: leave the pane alone.
      }
    }
  }

  Future<void> _openOverview(
    List<({SplitPane pane, ({String title, String? subtitle, PaneAction action}) display})>
    overviewPanes,
    ValueChanged<String> onSelectPane,
  ) async {
    setState(() => _overviewOpen = true);
    await SplitOverviewDialog.show(
      context,
      activePaneId: ref.read(workspaceProvider).activePaneId,
      onSelectPane: onSelectPane,
      panes: [
        for (final e in overviewPanes)
          OverviewPaneInfo(
            pane: e.pane,
            title: e.display.title,
            subtitle: e.display.subtitle,
            action: e.display.action,
          ),
      ],
    );
    if (mounted) setState(() => _overviewOpen = false);
  }

  Future<void> _openBroadcast() async {
    setState(() => _broadcastOpen = true);
    await BroadcastDialog.show(context, sessions: ref.read(sessionsProvider(_scope)).sessions);
    if (mounted) setState(() => _broadcastOpen = false);
  }

  // ─── Toolbar (port of SplitWorkspaceControls.tsx) ─────────────────────────

  Widget _controls({
    required bool canAdd,
    required List<({SplitPane pane, ({String title, String? subtitle, PaneAction action}) display})>
    overviewPanes,
    required String? activePaneId,
    required ValueChanged<String> onSelectPane,
  }) {
    final c = context.appColors;
    final m = topBarMetrics(context);
    final compact = context.breakpoint.isCompact;
    Widget btn(IconData icon, String tip, VoidCallback? onPressed) => IconButton(
      tooltip: tip,
      onPressed: onPressed,
      icon: Icon(icon, size: m.icon, color: c.mutedForeground),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tightFor(width: m.hit, height: m.hit),
    );
    final buttons = <Widget>[
      const AppNavMenuButton(),
      btn(LucideIcons.messageSquarePlus, 'Add chat pane', canAdd ? _addChat : null),
      btn(LucideIcons.history, 'Open session list', _browseSessions),
      btn(
        LucideIcons.globe,
        'Add browser pane',
        // One remote Chromium stream per workspace — the server ignores a
        // second `start` on the shared /browser-view socket, so a second
        // pane would only fight over the same page.
        canAdd && !ref.watch(workspaceProvider).panes.any((p) => p.kind == PaneKind.browser)
            ? () => _add(PaneKind.browser)
            : null,
      ),
      btn(LucideIcons.terminal, 'Add terminal pane', canAdd ? () => _add(PaneKind.terminal) : null),
      btn(
        LucideIcons.monitorPlay,
        'Add preview pane',
        canAdd ? () => _add(PaneKind.preview) : null,
      ),
      btn(
        // React uses NotebookPen for the shared-notes pane button.
        LucideIcons.notebookPen,
        'Add shared-notes pane',
        canAdd ? () => _add(PaneKind.notes) : null,
      ),
      btn(LucideIcons.code, 'Add editor pane', canAdd ? () => _add(PaneKind.editor) : null),
      btn(LucideIcons.gitBranch, 'Add git pane', canAdd ? () => _add(PaneKind.git) : null),
      btn(LucideIcons.megaphone, 'Broadcast to sessions', _openBroadcast),
      // Compact overflows the 40px targets, so the row scrolls instead of
      // clamping; the Spacer only makes sense on the non-scrolling row.
      if (!compact) const Spacer(),
      btn(
        LucideIcons.layoutGrid,
        'Show all panes',
        () => _openOverview(overviewPanes, onSelectPane),
      ),
      // Focus mode — web hides this on `sm:` (desktop-only); it toggles
      // the rail via the persisted sidebarVisible pref.
      if (!compact)
        btn(
          ref.watch(uiPreferencesProvider).sidebarVisible
              ? LucideIcons.maximize2
              : LucideIcons.minimize2,
          'Focus Mode (Ctrl+Shift+F)',
          () => ref.read(uiPreferencesProvider.notifier).toggleSidebar(),
        ),
    ];
    final row = Row(spacing: 4, children: buttons);
    return Container(
      height: m.barHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.5))),
      ),
      child: compact ? SingleChildScrollView(scrollDirection: Axis.horizontal, child: row) : row,
    );
  }

  // ─── Pane header content (port of renderPaneHeaderContent) ────────────────

  Widget _headerContent(
    SplitPane pane,
    ({String title, String? subtitle, PaneAction action}) display,
    List<Session> sessions,
    ProjectsState projects,
  ) {
    final t = Theme.of(context);
    final c = context.appColors;
    final style = t.textTheme.labelSmall?.copyWith(color: c.mutedForeground);
    if (pane.kind != PaneKind.chat || pane.sessionId == null || pane.picker) {
      return Text(display.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: style);
    }
    Session? session;
    for (final s in sessions) {
      if (s.sessionId == pane.sessionId) session = s;
    }
    final projectName = pane.projectId == null ? null : projectNamesOf(projects)[pane.projectId];
    return PaneSessionHeader(
      sessionId: pane.sessionId!,
      title: session?.displayTitle ?? display.title,
      projectName: projectName,
      provider: session?.provider,
      action: display.action,
      onChangeSession: () => ref.read(workspaceProvider.notifier).updatePane(pane.id, picker: true),
      onChangeWorkspace: () => unawaited(
        _changeWorkspace(
          pane,
          enabled: display.action != PaneAction.processing && display.action != PaneAction.question,
        ),
      ),
      onRename: (name) => _renameSession(pane.sessionId!, name),
      onArchive: () => _archiveSession(pane.sessionId!),
      onDelete: () => _deleteSession(pane.sessionId!),
      // Back-to-orchestration rebinds this pane to the parent session.
      onNavigateToSession: (targetId) => ref
          .read(workspaceProvider.notifier)
          .updatePane(pane.id, sessionId: () => targetId, picker: false),
    );
  }

  static Map<String, String> projectNamesOf(ProjectsState p) => {
    for (final pr in p.projects) pr.projectId: pr.displayName,
  };

  /// SessionWorkspaceDialog parity — rebind the session to another project
  /// path (disabled mid-run / while awaiting permission).
  Future<void> _changeWorkspace(SplitPane pane, {required bool enabled}) async {
    if (!enabled) {
      AppToast.error(context, 'Finish the run before changing workspace');
      return;
    }
    final field = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Change workspace',
        content: AppInput(controller: field, autofocus: true, hint: '/path/to/project'),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          AppButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Save')),
        ],
      ),
    );
    final path = field.text.trim();
    field.dispose();
    if (saved != true || path.isEmpty || !mounted) return;
    final err = await ref
        .read(sessionsProvider(_scope).notifier)
        .changeWorkspace(pane.sessionId!, path);
    if (!mounted) return;
    if (err != null) {
      AppToast.error(context, err);
      return;
    }
    AppToast.show(context, 'Workspace changed');
  }

  Future<void> _renameSession(String id, String name) async {
    final err = await ref.read(sessionsProvider(_scope).notifier).rename(id, name);
    if (!mounted) return;
    if (err != null) AppToast.error(context, err);
  }

  Future<void> _archiveSession(String id) async {
    // Web SessionActionsMenu confirms archive (same dialog as delete, gentler
    // copy) before calling the API.
    final ok = await AppDialog.confirm(
      context,
      title: 'Archive session?',
      message: 'Archive keeps the session out of the active list while preserving its history.',
      confirmLabel: 'Archive session',
    );
    if (!ok) return;
    final err = await ref.read(sessionsProvider(_scope).notifier).archive(id);
    if (!mounted) return;
    if (err != null) {
      AppToast.error(context, err);
    } else {
      AppToast.show(context, 'Session archived');
    }
  }

  Future<void> _deleteSession(String id) async {
    final ok = await AppDialog.confirm(
      context,
      title: 'Delete session?',
      message: 'Removes the session and its transcript. Cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (!ok) return;
    final err = await ref.read(sessionsProvider(_scope).notifier).hardDelete(id);
    if (!mounted) return;
    if (err != null) {
      AppToast.error(context, err);
    } else {
      AppToast.show(context, 'Session deleted');
    }
  }

  // ─── Pane bodies (port of renderChatWorkspacePane) ────────────────────────

  Widget _paneBody(
    SplitPane pane,
    bool isActive,
    List<Session> sessions,
    Set<String> processingIds,
  ) {
    final ws = ref.read(workspaceProvider);
    final projects = ref.read(projectsProvider);
    final ctrl = ref.read(workspaceProvider.notifier);

    switch (pane.kind) {
      case PaneKind.browser:
        return WebBrowserPane(
          url: pane.url,
          onUrlChange: (u) => ctrl.updatePane(pane.id, url: () => u),
        );
      case PaneKind.editor:
        if (pane.projectId == null) {
          return WorkspaceLauncher(
            lastUsedProjectId: ws.lastUsedProjectId,
            onSelectProject: (pid) {
              ctrl.setLastUsedProjectId(pid);
              ctrl.updatePane(pane.id, projectId: () => pid);
            },
          );
        }
        return EditorScreen(projectId: pane.projectId, filePath: pane.filePath);
      case PaneKind.terminal:
        if (pane.projectId == null) {
          return WorkspaceLauncher(
            lastUsedProjectId: ws.lastUsedProjectId,
            onSelectProject: (pid) {
              ctrl.setLastUsedProjectId(pid);
              ctrl.updatePane(pane.id, projectId: () => pid);
            },
          );
        }
        return TerminalScreen(projectId: pane.projectId, sessionId: pane.sessionId);
      case PaneKind.git:
        if (pane.projectId == null) {
          return WorkspaceLauncher(
            lastUsedProjectId: ws.lastUsedProjectId,
            onSelectProject: (pid) {
              ctrl.setLastUsedProjectId(pid);
              ctrl.updatePane(pane.id, projectId: () => pid);
            },
          );
        }
        return GitScreen(projectId: pane.projectId);
      case PaneKind.preview:
        if (pane.projectId == null) {
          return WorkspaceLauncher(
            lastUsedProjectId: ws.lastUsedProjectId,
            onSelectProject: (pid) {
              ctrl.setLastUsedProjectId(pid);
              ctrl.updatePane(pane.id, projectId: () => pid);
            },
          );
        }
        return PreviewPane(
          projectPath: ref
              .watch(projectsProvider)
              .projects
              .where((p) => p.projectId == pane.projectId)
              .firstOrNull
              ?.path,
        );
      case PaneKind.notes:
        // No workspace binding = dead tile → the launcher (same as web).
        if (pane.projectId == null) {
          return WorkspaceLauncher(
            lastUsedProjectId: ws.lastUsedProjectId,
            onSelectProject: (pid) {
              ctrl.setLastUsedProjectId(pid);
              ctrl.updatePane(pane.id, projectId: () => pid);
            },
          );
        }
        return SharedNotesPane(projectId: pane.projectId);
      case PaneKind.chat:
        break;
    }

    if (pane.picker || pane.sessionId == null) {
      final openIds = boundChatSessionIds(ws.panes)..remove(pane.sessionId);
      return SessionPickerPane(
        projectId: pane.projectId,
        openSessionIds: openIds,
        processingSessionIds: processingIds,
        canCancel: pane.sessionId != null,
        allowOrchestrator: pane.projectId != null,
        onCancel: pane.sessionId != null ? () => ctrl.updatePane(pane.id, picker: false) : null,
        onSelectSession: (s) => ctrl.updatePane(
          pane.id,
          sessionId: () => s.sessionId,
          projectId: () => s.projectId ?? pane.projectId,
          picker: false,
        ),
        // Draft-extras workspace card — rebinds this pane to the project.
        onSelectWorkspace: (pid) => ctrl.updatePane(pane.id, projectId: () => pid),
        onNewChat: (provider, {accountId}) =>
            unawaited(_createSession(pane, provider, accountId: accountId)),
      );
    }

    // TranscriptView renders its own Scaffold+AppBar — embedded as the pane
    // body per the minimal-viable embedding allowed by the spec.
    return TranscriptView(
      sessionId: pane.sessionId!,
      projectId: pane.projectId,
      // Status strip shows the pane's workspace path (old pane header).
      projectPath: projects.projects.where((p) => p.projectId == pane.projectId).firstOrNull?.path,
      // `[data-split-rows="2"]` parity — two-row grids collapse the
      // subheader to a slim strip.
      dense: getSplitLayout(ws.panes.length).rows >= 2,
      // Web `onFileOpen` — chat links open a split editor pane, not a route.
      onOpenFile: (path) => ctrl.openFileInEditor(pane.projectId, path),
    );
  }

  Future<void> _createSession(SplitPane pane, String provider, {String? accountId}) async {
    try {
      if (provider == 'orchestrator') {
        // Panes carry only projectId — resolve the path from the loaded
        // projects list (required by POST /api/orchestrator/sessions).
        final projects = ref.read(projectsProvider).projects;
        final path = [
          for (final p in projects)
            if (p.projectId == pane.projectId) p.path,
        ].firstOrNull;
        if (path == null || path.isEmpty) {
          throw StateError('Unknown project path');
        }
        final sessionId = await createOrchestratorSession(ref, projectPath: path);
        if (!mounted) return;
        ref
            .read(workspaceProvider.notifier)
            .updatePane(pane.id, sessionId: () => sessionId, picker: false);
        return;
      }
      // POST /api/providers/sessions requires projectPath, not projectId —
      // resolve it from the loaded projects list (fullPath ?? path, web
      // parity with useChatComposerState).
      final projects = ref.read(projectsProvider).projects;
      final projectPath = [
        for (final p in projects)
          if (p.projectId == pane.projectId) p.fullPath ?? p.path,
      ].firstOrNull;
      if (projectPath == null || projectPath.isEmpty) {
        throw StateError('Unknown project path');
      }
      final s = await ref.read(sessionsRepositoryProvider).createSession({
        'provider': provider,
        'projectPath': projectPath,
        if (accountId != null && accountId.isNotEmpty) 'accountId': accountId,
      });
      if (!mounted) return;
      ref
          .read(workspaceProvider.notifier)
          .updatePane(pane.id, sessionId: () => s.sessionId, picker: false);
    } on Object catch (e) {
      if (mounted) AppToast.error(context, 'Failed to create session: $e');
    }
  }
}
