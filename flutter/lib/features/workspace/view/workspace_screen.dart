import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_nav_menu.dart';
import 'package:ddagent_app/features/browser/view/web_browser_pane.dart';
import 'package:ddagent_app/features/editor/view/editor_screen.dart';
import 'package:ddagent_app/features/git/view/git_screen.dart';
import 'package:ddagent_app/features/preview/state/app_preview_controller.dart';
import 'package:ddagent_app/features/preview/view/app_preview_pane.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/shared_context/view/shared_notes_pane.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/terminal_screen.dart';
import 'package:ddagent_app/features/terminal/view/terminal_view_wrapper.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/features/workspace/view/pane_header_metrics.dart';
import 'package:ddagent_app/features/workspace/view/split_workspace_grid.dart';
import 'package:ddagent_app/features/workspace/view/workspace_dialogs.dart';
import 'package:ddagent_app/features/workspace/view/workspace_launcher.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Multi-pane workspace (port of MainContent.tsx): toolbar +
/// SplitWorkspaceGrid + overview dialog. Agents run as CLIs in terminal
/// panes — each pane owns a tab row — next to browser, preview, notes,
/// editor and git panes.
class WorkspaceScreen extends ConsumerStatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  ConsumerState<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends ConsumerState<WorkspaceScreen> {
  bool _overviewOpen = false;

  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
    // The listener in build only sees changes made while this screen is up:
    // a pane closed meanwhile (on another device, while this one showed
    // another route) would keep its tabs and sockets forever.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(terminalControllerProvider.notifier).closeHostsExcept(_terminalHosts());
    });
  }

  Set<String> _terminalHosts() => {
    for (final p in ref.read(workspaceProvider).panes)
      if (p.kind == PaneKind.terminal) p.id,
  };

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  /// Escape restores the split layout — unless a dialog route owns the key.
  /// A focused terminal keeps it: Esc cancels the agent's turn there.
  bool _onKey(KeyEvent e) {
    if (e is! KeyDownEvent || e.logicalKey != LogicalKeyboardKey.escape || !mounted) {
      return false;
    }
    if (_overviewOpen || ModalRoute.of(context)?.isCurrent != true) return false;
    final ws = ref.read(workspaceProvider);
    final maxId = ws.maximizedPaneId;
    if (maxId == null || !ws.panes.any((p) => p.id == maxId)) return false;
    final maxPane = ws.panes.firstWhere((p) => p.id == maxId);
    if (maxPane.kind == PaneKind.terminal && TerminalViewWrapperState.hasKeyboardFocus) {
      return false;
    }
    ref.read(workspaceProvider.notifier).toggleMaximize(maxId);
    return false; // never consume — let fields still see the key
  }

  String? get _defaultProjectId => WorkspaceStorage.pickProjectId(ref.read(workspaceProvider));

  void _add(PaneKind kind) {
    ref.read(workspaceProvider.notifier).openPane(kind, projectId: _defaultProjectId);
  }

  Map<String, String> _projectNames(ProjectsState p) => {
    for (final pr in p.projects) pr.projectId: pr.displayName,
  };

  /// Terminal panes with a tab whose CLI shows a pick-an-option prompt (a
  /// permission or question from the agent).
  /// Each terminal pane's visible tab title (`host\ttitle` lines — a
  /// string, so output frames that leave the titles alone don't rebuild).
  static String _activeTabTitles(TerminalState s) => [
    for (final host in {for (final tab in s.tabs) tab.hostId})
      '$host\t${s.activeTabFor(host)?.displayTitle ?? ''}',
  ].join('\n');

  static Set<String> _questionHosts(TerminalState s) => {
    for (final tab in s.tabs)
      if (tab.promptOptions != null && tab.status == TerminalTabStatus.connected) tab.hostId,
  };

  /// Terminal panes with a tab that rang the bell (an agent CLI finishing
  /// its turn) since the user last looked at it.
  static Set<String> _bellHosts(TerminalState s) => {
    for (final tab in s.tabs)
      if (tab.bell) tab.hostId,
  };

  @override
  Widget build(BuildContext context) {
    final ws = ref.watch(workspaceProvider);
    final ctrl = ref.read(workspaceProvider.notifier);
    final projects = ref.watch(projectsProvider);
    // Keeps the preview registry mirrored so an agent's `preview_open` MCP
    // call opens / retargets a preview pane while the workspace is on screen.
    ref.watch(appPreviewControllerProvider);
    final questionHosts = ref.watch(terminalControllerProvider.select(_questionHosts));
    final tabTitles = {
      for (final line in ref.watch(terminalControllerProvider.select(_activeTabTitles)).split('\n'))
        if (line.split('\t') case [final host, final title] when title.isNotEmpty) host: title,
    };
    final bellHosts = ref.watch(terminalControllerProvider.select(_bellHosts));

    // Focusing a pane (or leaving it) means its visible tab has been seen.
    ref.listen(workspaceProvider.select((s) => s.activePaneId), (prev, next) {
      final terminal = ref.read(terminalControllerProvider.notifier);
      for (final id in [prev, next]) {
        if (id != null) terminal.acknowledgeBell(id);
      }
    });
    // A terminal pane closed here or on another device takes its tabs along.
    ref.listen(
      workspaceProvider.select(
        (s) => [
          for (final p in s.panes)
            if (p.kind == PaneKind.terminal) p.id,
        ].join('\n'),
      ),
      (_, next) =>
          ref.read(terminalControllerProvider.notifier).closeHostsExcept(next.split('\n').toSet()),
    );

    // An empty workspace renders nothing — seed one terminal pane so a
    // shell (and the agent profiles in its menu) is the first thing on
    // screen.
    if (ws.panes.isEmpty && !projects.loading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && ref.read(workspaceProvider).panes.isEmpty) {
          _add(PaneKind.terminal);
        }
      });
    }

    final projectNames = _projectNames(projects);
    ({String title, String? subtitle, PaneAction action}) display(SplitPane p) =>
        splitPaneDisplay(p, projectNames: projectNames, questionPaneIds: questionHosts);

    return Scaffold(
      body: Column(
        children: [
          _controls(
            canAdd: ctrl.canAdd,
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
              finishedPaneIds: bellHosts,
              actionPaneIds: questionHosts,
              // Compact mode's pane strip names a terminal pane by the tab it
              // shows — "Terminal" twice tells the panes apart from nothing.
              paneTitle: (p) => tabTitles[p.id] ?? display(p).title,
              renderPaneHeaderContent: (p, actions) =>
                  _headerContent(display(p), actions, finished: bellHosts.contains(p.id)),
              renderPane: _paneBody,
            ),
          ),
        ],
      ),
    );
  }

  /// Watched from the overview dialog's own route — a snapshot taken at open
  /// time would never show an agent asking.
  List<OverviewPaneInfo> _overviewPanes(WidgetRef r) {
    final projectNames = _projectNames(r.watch(projectsProvider));
    final questionHosts = r.watch(terminalControllerProvider.select(_questionHosts));
    final bellHosts = r.watch(terminalControllerProvider.select(_bellHosts));
    return [
      for (final p in r.watch(workspaceProvider).panes)
        if (splitPaneDisplay(p, projectNames: projectNames, questionPaneIds: questionHosts)
            case final d)
          OverviewPaneInfo(
            pane: p,
            title: d.title,
            subtitle: d.subtitle,
            action: d.action,
            finished: bellHosts.contains(p.id),
          ),
    ];
  }

  Future<void> _openOverview(ValueChanged<String> onSelectPane) async {
    setState(() => _overviewOpen = true);
    await SplitOverviewDialog.show(context, onSelectPane: onSelectPane, panes: _overviewPanes);
    if (mounted) setState(() => _overviewOpen = false);
  }

  // ─── Toolbar (port of SplitWorkspaceControls.tsx) ─────────────────────────

  Widget _controls({required bool canAdd, required ValueChanged<String> onSelectPane}) {
    final c = context.appColors;
    final m = topBarMetrics(context);
    final compact = context.breakpoint.isCompact;
    final i18n = Translations.of(context);
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
      btn(
        LucideIcons.terminal,
        i18n.chat.splitWorkspace.addTerminal,
        canAdd ? () => _add(PaneKind.terminal) : null,
      ),
      btn(
        LucideIcons.globe,
        i18n.chat.splitWorkspace.addBrowser,
        // One remote Chromium stream per workspace — the server ignores a
        // second `start` on the shared /browser-view socket, so a second
        // pane would only fight over the same page.
        canAdd && !ref.watch(workspaceProvider).panes.any((p) => p.kind == PaneKind.browser)
            ? () => _add(PaneKind.browser)
            : null,
      ),
      btn(
        LucideIcons.monitorSmartphone,
        i18n.chat.splitWorkspace.addPreview,
        canAdd ? () => _add(PaneKind.preview) : null,
      ),
      btn(
        // React uses NotebookPen for the shared-notes pane button.
        LucideIcons.notebookPen,
        i18n.chat.splitWorkspace.addNotes,
        canAdd ? () => _add(PaneKind.notes) : null,
      ),
      btn(
        LucideIcons.code,
        i18n.workspace.addEditorPane,
        canAdd ? () => _add(PaneKind.editor) : null,
      ),
      btn(
        LucideIcons.gitBranch,
        i18n.workspace.addGitPane,
        canAdd ? () => _add(PaneKind.git) : null,
      ),
      // Compact overflows the 40px targets, so the row scrolls instead of
      // clamping; the Spacer only makes sense on the non-scrolling row.
      if (!compact) const Spacer(),
      btn(
        LucideIcons.layoutGrid,
        i18n.chat.splitWorkspace.overview,
        () => _openOverview(onSelectPane),
      ),
      // Focus mode — web hides this on `sm:` (desktop-only); it toggles
      // the rail via the persisted sidebarVisible pref.
      if (!compact)
        btn(
          ref.watch(uiPreferencesProvider).sidebarVisible
              ? LucideIcons.maximize2
              : LucideIcons.minimize2,
          i18n.chat.splitWorkspace.focusMode,
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

  /// Header: title · project. On the grid it also carries the pane's flag —
  /// the amber "question" / green "finished" (bell) the compact pane strip
  /// shows (a question outranks finished, it blocks the agent); compact
  /// leaves them to that strip and the visible pane's answer chips.
  Widget _headerContent(
    ({String title, String? subtitle, PaneAction action}) display,
    List<Widget> actions, {
    bool finished = false,
  }) {
    final t = Theme.of(context);
    final c = context.appColors;
    final i18n = Translations.of(context);
    final style = t.textTheme.labelSmall?.copyWith(color: c.mutedForeground);
    final subtitle = display.subtitle;
    final flag = context.breakpoint.isCompact
        ? null
        : display.action == PaneAction.question
        ? (Icons.warning_amber_rounded, _questionColor, i18n.chat.splitOverview.question)
        : finished
        ? (Icons.check_circle, _finishedColor, i18n.chat.sessionPicker.unread)
        : null;
    return Row(
      children: [
        if (flag case (final icon, final color, final tooltip))
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.xs),
            child: Tooltip(
              message: tooltip,
              child: Icon(icon, size: 14, color: color),
            ),
          ),
        Flexible(
          child: Text(display.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: style),
        ),
        if (subtitle != null && subtitle.isNotEmpty)
          Flexible(
            child: Text(
              ' · $subtitle',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style?.copyWith(color: c.mutedForeground.withValues(alpha: 0.7)),
            ),
          ),
        const Spacer(),
        ...actions,
      ],
    );
  }

  /// Same hues as the compact pane strip's flags.
  static const _questionColor = Color(0xFFF59E0B);
  static const _finishedColor = Color(0xFF10B981);

  // ─── Pane bodies (port of renderChatWorkspacePane) ────────────────────────

  Widget _paneBody(SplitPane pane, bool isActive) {
    final ws = ref.read(workspaceProvider);
    final ctrl = ref.read(workspaceProvider.notifier);
    // No workspace binding = dead tile → the launcher (same as web). A
    // terminal pane that already has a tab row (a session opened into it)
    // or resumes a session (a migrated chat pane) runs its tabs in their own
    // directories and needs none.
    final unbound =
        pane.projectId == null &&
        !(pane.kind == PaneKind.terminal &&
            (pane.sessionId != null || ws.terminals.containsKey(pane.id))) &&
        pane.kind != PaneKind.browser &&
        pane.kind != PaneKind.preview;
    if (unbound) {
      return WorkspaceLauncher(
        lastUsedProjectId: ws.lastUsedProjectId,
        onSelectProject: (pid) {
          ctrl.setLastUsedProjectId(pid);
          ctrl.updatePane(pane.id, projectId: () => pid);
        },
      );
    }

    return switch (pane.kind) {
      PaneKind.browser => WebBrowserPane(
        url: pane.url,
        onUrlChange: (u) => ctrl.updatePane(pane.id, url: () => u),
      ),
      // Keyed by pane id: each preview pane owns its own Chromium stream.
      PaneKind.preview => AppPreviewPane(key: ValueKey('preview-${pane.id}'), pane: pane),
      PaneKind.editor => EditorScreen(projectId: pane.projectId, filePath: pane.filePath),
      // Keyed + hosted by pane id: each pane owns its own tab row. A pane
      // migrated from a session pane resumes that session in its first tab.
      PaneKind.terminal => TerminalScreen(
        key: ValueKey('terminal-${pane.id}'),
        hostId: pane.id,
        projectId: pane.projectId,
        sessionId: pane.sessionId,
        syncTabs: true,
        // File links in agent output split an editor pane, not a route.
        onFileOpen: (path, _) => ctrl.openFileInEditor(pane.projectId, path),
      ),
      PaneKind.git => GitScreen(projectId: pane.projectId),
      PaneKind.notes => SharedNotesPane(projectId: pane.projectId),
    };
  }
}
