import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/theme/typography.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/provider_accounts/state/provider_accounts_controller.dart';
import 'package:ddagent_app/features/system/state/system_providers.dart';
import 'package:ddagent_app/features/terminal/state/terminal_account_profiles.dart';
import 'package:ddagent_app/features/terminal/state/terminal_state.dart';
import 'package:ddagent_app/features/terminal/view/provider_login_dialog.dart';
import 'package:ddagent_app/features/terminal/view/terminal_keymap.dart';
import 'package:ddagent_app/features/terminal/view/terminal_shortcuts_bar.dart';
import 'package:ddagent_app/features/terminal/view/terminal_tab_strip.dart';
import 'package:ddagent_app/features/terminal/view/terminal_theme.dart';
import 'package:ddagent_app/features/terminal/view/terminal_view_wrapper.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Provider profiles offered by the `⌄` dropdown (WT profile list).
const _providerProfiles = ['claude', 'opencode', 'commandcode', 'antigravity', 'cursor', 'devin'];

/// Providers whose named accounts get their own "CLI · account" profiles —
/// every CLI the server's shell bridge can start (Codex included, which has
/// no plain profile of its own in the list above).
const _accountProfileProviders = [
  'claude',
  'codex',
  'opencode',
  'commandcode',
  'antigravity',
  'cursor',
  'devin',
];

/// Dense rows (WT dropdown height) — the default 48px Material rows push a
/// 12-entry menu past a phone's landscape height.
final _menuItemStyle = MenuItemButton.styleFrom(
  minimumSize: const Size(0, 36),
  padding: const EdgeInsets.symmetric(horizontal: 12),
  visualDensity: VisualDensity.compact,
);

class TerminalScreen extends ConsumerStatefulWidget {
  const TerminalScreen({
    super.key,
    this.projectPath,
    this.projectId,
    this.sessionId,
    this.onFileOpen,
    this.hostId = terminalRouteHost,
    this.syncTabs = false,
  });

  /// Which tab row this screen shows — the route's, or a workspace pane's.
  final String hostId;

  /// Mirror this tab row on the account's other devices through the
  /// workspace sync (like the panes themselves). Off where no workspace
  /// exists — the login dialog, widget tests.
  final bool syncTabs;
  final String? projectPath;
  final String? projectId;
  final String? sessionId;
  final void Function(String filePath, int? line)? onFileOpen;

  @override
  ConsumerState<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends ConsumerState<TerminalScreen> {
  /// "Copied!" flash on the copy-output menu entry (web 2s timer).
  bool _copied = false;
  Timer? _copyTimer;
  final _menuController = MenuController();

  /// One pane state per tab (selection, scroll, search survive switching
  /// tabs); the key doubles as the handle the menu and shortcuts call into.
  final _viewKeys = <String, GlobalKey<TerminalViewWrapperState>>{};

  GlobalKey<TerminalViewWrapperState> _viewKeyFor(TerminalTab tab) =>
      _viewKeys.putIfAbsent(tab.id, GlobalKey<TerminalViewWrapperState>.new);

  TerminalViewWrapperState? get _activePane {
    final active = ref.read(terminalControllerProvider).activeTabFor(widget.hostId);
    return active == null ? null : _viewKeys[active.id]?.currentState;
  }

  /// Last tab row exchanged with the workspace (applied or published) — a
  /// differing workspace row is another device's edit, a differing local row
  /// is this device's. Null until the row was first seen or published.
  TerminalHostSpec? _syncedRow;
  bool _applyingSyncedRow = false;

  /// Project picked in the strip's project menu — new tabs open there. Wins
  /// over the route's query params; a pane also stores it as its project.
  String? _pickedProjectId;

  @override
  void initState() {
    super.initState();
    if (widget.syncTabs) {
      ref.listenManual(workspaceProvider, (_, _) => _onWorkspaceChanged());
      // Keyed on the row's shape only — output frames notify the controller
      // on every chunk, and must not re-encode the row each time.
      ref.listenManual(
        terminalControllerProvider.select((s) => _rowShape(s, widget.hostId)),
        (_, _) => _publishLocalRow(),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.syncTabs) {
        _onWorkspaceChanged();
      } else {
        _ensureInitialTab();
      }
    });
  }

  @override
  void dispose() {
    _copyTimer?.cancel();
    super.dispose();
  }

  /// Workspace changed (any field, from any device). Nothing happens before
  /// the server's workspace was read: a row restored from disk may name tabs
  /// closed elsewhere since, and a seeded tab would duplicate another
  /// device's.
  void _onWorkspaceChanged() {
    final workspace = ref.read(workspaceProvider);
    if (!workspace.serverLoaded) return;
    final row = workspace.terminals[widget.hostId];
    if (row == null) {
      // Never opened on any device: announce what this device holds (a tab
      // just moved here), or open the default tab — published by the
      // controller listener.
      if (_syncedRow == null) {
        if (_ctrl.syncedRowFor(widget.hostId).tabs.isEmpty) _ensureInitialTab();
        _publishLocalRow();
      }
      return;
    }
    if (row.encode() == _syncedRow?.encode()) return;
    _syncedRow = row;
    _applyingSyncedRow = true;
    try {
      _ctrl.applySyncedRow(widget.hostId, row);
    } finally {
      _applyingSyncedRow = false;
    }
  }

  static String _rowShape(TerminalState s, String hostId) => [
    s.activeTabFor(hostId)?.syncId,
    for (final tab in s.tabsFor(hostId)) '${tab.syncId}|${tab.renamed}|${tab.title}',
  ].join('\n');

  /// Local tab edit (open, close, rename, reorder, select, move) → the
  /// workspace row, which the workspace sync pushes to the other devices.
  void _publishLocalRow() {
    if (_applyingSyncedRow || !ref.read(workspaceProvider).serverLoaded) return;
    final row = _ctrl.syncedRowFor(widget.hostId);
    if (row.encode() == _syncedRow?.encode()) return;
    if (_syncedRow == null && row.tabs.isEmpty) return;
    _syncedRow = row;
    ref.read(workspaceProvider.notifier).setTerminalHost(widget.hostId, row);
  }

  TerminalController get _ctrl => ref.read(terminalControllerProvider.notifier);

  static String _pathOf(Project project) =>
      (project.fullPath?.isNotEmpty ?? false) ? project.fullPath! : project.path;

  /// The project new tabs open in: the one picked in the strip, else the
  /// pane's / route's, else the last used one, else the first project.
  Project? _currentProject() {
    final projects = ref.read(projectsProvider).projects;
    Project? byId(String? id) =>
        id == null ? null : projects.where((p) => p.projectId == id).firstOrNull;
    final picked = byId(_pickedProjectId);
    if (picked != null) return picked;
    final routePath = widget.projectPath;
    if (routePath != null && routePath.isNotEmpty) {
      return projects.where((p) => _pathOf(p) == routePath || p.path == routePath).firstOrNull;
    }
    // The workspace is only read where it is synced — its controller opens
    // Hive, which widget tests don't set up.
    final lastUsed = widget.syncTabs ? ref.read(workspaceProvider).lastUsedProjectId : null;
    return byId(widget.projectId) ?? byId(lastUsed) ?? projects.firstOrNull;
  }

  /// The project the strip shows: the active tab's own, else where new tabs open.
  Project? _projectShownFor(TerminalTab? tab) {
    final path = tab?.projectPath;
    final own = path == null
        ? null
        : ref
              .read(projectsProvider)
              .projects
              .where((p) => _pathOf(p) == path || p.path == path)
              .firstOrNull;
    return own ?? _currentProject();
  }

  String _resolveProjectPath() {
    if (_pickedProjectId == null &&
        widget.projectPath != null &&
        widget.projectPath!.isNotEmpty) {
      return widget.projectPath!;
    }
    final project = _currentProject();
    return project == null ? '' : _pathOf(project);
  }

  /// Strip's project menu: new tabs of this pane (or of the standalone
  /// terminal) open in [project] from now on, and one opens right away —
  /// running shells keep their directory.
  void _selectProject(Project project) {
    setState(() => _pickedProjectId = project.projectId);
    if (widget.syncTabs) {
      final workspace = ref.read(workspaceProvider.notifier);
      workspace.setLastUsedProjectId(project.projectId);
      if (widget.hostId != terminalRouteHost) {
        workspace.updatePane(widget.hostId, projectId: () => project.projectId);
      }
    }
    _newDefaultTab();
  }

  void _ensureInitialTab() {
    final terminalState = ref.read(terminalControllerProvider);
    if (terminalState.tabsFor(widget.hostId).isEmpty) {
      final t = Translations.of(context);
      final path = _resolveProjectPath();
      _ctrl.createTab(
        title: widget.sessionId != null
            ? t.chat.export.sessionTitle(id: widget.sessionId!)
            : t.terminal.tabs.shellName(index: 1),
        projectPath: path,
        hostId: widget.hostId,
        sessionId: widget.sessionId,
        isPlainShell: widget.sessionId == null,
      );
    }
  }

  /// `+` / Ctrl+Shift+T — the default profile is a plain shell.
  void _newDefaultTab() {
    _ctrl.createTab(projectPath: _resolveProjectPath(), hostId: widget.hostId, isPlainShell: true);
  }

  /// Tab context menu → "Move to new pane": opens a terminal pane in the
  /// workspace and hands the live tab over (same PTY, buffer intact). The
  /// pane needs a project id or it renders the launcher instead of the
  /// terminal; the move is done in the same tick as `openPane`, before the
  /// new pane's `_ensureInitialTab` could spawn an extra shell.
  void _moveTabToNewPane(String tabId) {
    final tab = ref.read(terminalControllerProvider).tabs.where((t) => t.id == tabId).firstOrNull;
    if (tab == null) return;
    final workspace = ref.read(workspaceProvider.notifier);
    final ws = ref.read(workspaceProvider);
    final projectId =
        widget.projectId ??
        ref
            .read(projectsProvider)
            .projects
            .where((p) => p.fullPath == tab.projectPath || p.path == tab.projectPath)
            .firstOrNull
            ?.projectId ??
        WorkspaceStorage.pickProjectId(ws);
    final paneId = workspace.openPane(PaneKind.terminal, projectId: projectId);
    // shortcut: a full workspace (6 panes) is a silent no-op; add a toast if
    // users hit it. The workspace is only read here, not watched in build —
    // its controller opens Hive, which widget tests don't set up.
    if (paneId == null) return;
    _ctrl.moveTab(tabId, toHost: paneId);
    // A maximized source pane would leave the new one offstage.
    if (ws.maximizedPaneId != null) workspace.toggleMaximize(ws.maximizedPaneId!);
    if (widget.hostId == terminalRouteHost) context.go('/workspace');
  }

  /// A provider CLI tab; with [account] the PTY gets that named account's
  /// env overrides, so the CLI runs signed in as that account.
  void _newProviderTab(String provider, {TerminalAccountProfile? account}) {
    _ctrl.createTab(
      projectPath: _resolveProjectPath(),
      hostId: widget.hostId,
      provider: provider,
      isPlainShell: false,
      title: account?.title(_profileLabel(provider)) ?? '$provider CLI',
      env: account?.account.envOverrides,
    );
  }

  /// Agent profiles run *in the shell the user is looking at*: the CLI is
  /// typed into the active tab (`claude …`, or `env K=V … claude` for a named
  /// account; PowerShell: `$env:K=…; claude`), so it starts in that shell's
  /// working directory — and, with [account], signed in as that account.
  /// Only a plain, connected shell can take typed input without it landing
  /// inside some other program; anything else (a running CLI, a one-shot
  /// command, a dead tab, no tab) falls back to a new tab with the same
  /// command and env.
  void _runCliProfile(String provider, TerminalTab? activeTab, {TerminalAccountProfile? account}) {
    final canType =
        activeTab != null &&
        activeTab.status == TerminalTabStatus.connected &&
        activeTab.isPlainShell &&
        !activeTab.isCommandMode;
    if (!canType) {
      _newProviderTab(provider, account: account);
      return;
    }
    final windows = ref.read(serverHealthProvider).value?['platform'] == 'win32';
    final command = terminalAccountCommand(
      provider: provider,
      env: account?.account.envOverrides ?? const {},
      windows: windows,
    );
    _ctrl.sendInput(activeTab.id, '$command\r');
  }

  String _profileLabel(String provider) {
    final t = Translations.of(context).terminal.tabs;
    return switch (provider) {
      'claude' => t.claudeCli,
      'codex' => t.codexCli,
      'opencode' => t.opencodeCli,
      'commandcode' => t.commandCodeCli,
      'antigravity' => t.antigravityCli,
      'cursor' => t.cursorCli,
      'devin' => t.devinCli,
      _ => '$provider CLI',
    };
  }

  void _handleOpenFile(String filePath, int? line) {
    if (widget.onFileOpen != null) {
      widget.onFileOpen!(filePath, line);
    } else {
      final queryParams = <String, String>{'file': filePath};
      if (line != null) queryParams['line'] = line.toString();
      if (widget.projectId != null) {
        queryParams['projectId'] = widget.projectId!;
      }

      context.push(Uri(path: '/editor', queryParameters: queryParams).toString());
    }
  }

  Future<void> _openAuthUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _copyOutput(TerminalTab tab) async {
    final text = _ctrl.copyOutputText(tab.id);
    if (text == null || text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    setState(() => _copied = true);
    _copyTimer?.cancel();
    _copyTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  /// Tab-level commands — from the pane's key handler, the screen-level
  /// fallback handler (focus outside the pane) and the dropdown menu.
  void _runTabCommand(TerminalCommand command, int? index) {
    final active = ref.read(terminalControllerProvider).activeTabFor(widget.hostId);
    switch (command) {
      case TerminalCommand.newTab:
        _newDefaultTab();
      case TerminalCommand.closeTab:
        if (active != null) _ctrl.closeTab(active.id);
      case TerminalCommand.duplicateTab:
        if (active != null) _ctrl.duplicateTab(active.id);
      case TerminalCommand.nextTab:
        _ctrl.selectRelativeTab(1, hostId: widget.hostId);
      case TerminalCommand.previousTab:
        _ctrl.selectRelativeTab(-1, hostId: widget.hostId);
      case TerminalCommand.selectTab:
        if (index != null) _ctrl.selectTabAt(index, hostId: widget.hostId);
      case TerminalCommand.zoomIn:
        if (active != null) _ctrl.zoomIn(active.id);
      case TerminalCommand.zoomOut:
        if (active != null) _ctrl.zoomOut(active.id);
      case TerminalCommand.zoomReset:
        if (active != null) _ctrl.zoomReset(active.id);
      case TerminalCommand.commandMenu:
        _menuController.isOpen ? _menuController.close() : _menuController.open();
      case TerminalCommand.find:
        _activePane?.openSearch();
      case TerminalCommand.copy:
      case TerminalCommand.paste:
      case TerminalCommand.selectAll:
      case TerminalCommand.clearSelection:
      case TerminalCommand.scrollUpLine:
      case TerminalCommand.scrollDownLine:
      case TerminalCommand.scrollUpPage:
      case TerminalCommand.scrollDownPage:
      case TerminalCommand.scrollToTop:
      case TerminalCommand.scrollToBottom:
        _activePane?.runCommand(command, index);
    }
  }

  /// Chords that arrive while focus is outside the pane (connection
  /// overlay, tab strip, key bar) — the pane handles them itself when it
  /// has focus, so only tab-level commands are taken here.
  KeyEventResult _onScreenKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final kb = HardwareKeyboard.instance;
    final binding = resolveTerminalCommand(
      key: event.logicalKey,
      control: kb.isControlPressed,
      shift: kb.isShiftPressed,
      alt: kb.isAltPressed,
      meta: kb.isMetaPressed,
      platform: defaultTargetPlatform,
      hasSelection: false,
    );
    if (binding == null) return KeyEventResult.ignored;
    const tabLevel = {
      TerminalCommand.newTab,
      TerminalCommand.closeTab,
      TerminalCommand.duplicateTab,
      TerminalCommand.nextTab,
      TerminalCommand.previousTab,
      TerminalCommand.selectTab,
      TerminalCommand.zoomIn,
      TerminalCommand.zoomOut,
      TerminalCommand.zoomReset,
      TerminalCommand.commandMenu,
      TerminalCommand.find,
    };
    if (!tabLevel.contains(binding.command)) return KeyEventResult.ignored;
    _runTabCommand(binding.command, binding.index);
    return KeyEventResult.handled;
  }

  bool get _isTouchPlatform =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.fuchsia;

  @override
  Widget build(BuildContext context) {
    final palette = TerminalPalette.of(context);
    final t = Translations.of(context);
    final terminalState = ref.watch(terminalControllerProvider);
    final activeTab = terminalState.activeTabFor(widget.hostId);

    // Right-click is the app's (tab menu, pane copy/paste) — the browser's own
    // menu must not open on top of it.
    return MouseRegion(
      onEnter: (_) {
        if (kIsWeb) unawaited(BrowserContextMenu.disableContextMenu());
      },
      onExit: (_) {
        if (kIsWeb) unawaited(BrowserContextMenu.enableContextMenu());
      },
      child: Focus(
        onKeyEvent: _onScreenKey,
        child: Scaffold(
          backgroundColor: palette.background,
          body: Column(
            children: [
              TerminalTabStrip(
                tabs: terminalState.tabsFor(widget.hostId),
                activeTabId: activeTab?.id,
                onSelect: _ctrl.selectTab,
                onClose: _ctrl.closeTab,
                onReorder: (from, to) => _ctrl.reorderTab(from, to, hostId: widget.hostId),
                onRename: _ctrl.renameTab,
                onDuplicate: _ctrl.duplicateTab,
                onMoveToPane: _moveTabToNewPane,
                onCloseOthers: _ctrl.closeOtherTabs,
                onCloseToRight: _ctrl.closeTabsToRight,
                onNewTab: _newDefaultTab,
                menuController: _menuController,
                menuChildren: _buildMenu(context, terminalState, activeTab),
                trailing: [
                  // Panes and the standalone terminal only — the login
                  // dialog runs in a fixed directory.
                  if (widget.syncTabs)
                    _TerminalProjectMenu(
                      projects: ref.watch(projectsProvider).projects,
                      selected: _projectShownFor(activeTab),
                      onSelected: _selectProject,
                    ),
                  if (activeTab != null)
                    TerminalStripAction(
                      tooltip:
                          '${t.terminal.menu.find}  '
                          '${terminalShortcutLabel(TerminalCommand.find, defaultTargetPlatform)}',
                      icon: LucideIcons.search,
                      onPressed: () => _activePane?.openSearch(),
                    ),
                  TerminalStripAction(
                    tooltip: terminalState.showShortcutsBar
                        ? t.terminal.shortcuts.hideTooltip
                        : t.terminal.shortcuts.showTooltip,
                    icon: LucideIcons.keyboard,
                    active: terminalState.showShortcutsBar,
                    onPressed: _ctrl.toggleShortcutsBar,
                  ),
                ],
              ),

              // Active tab Auth URL banner (if any)
              if (activeTab != null && bestAuthUrl(activeTab.authUrls) != null)
                _buildAuthUrlBanner(bestAuthUrl(activeTab.authUrls)!),

              // Main terminal view or empty state
              Expanded(child: activeTab != null ? _terminalArea(activeTab) : _buildEmptyState()),

              // Touch / keyboard-less key bar
              if (terminalState.showShortcutsBar && activeTab != null)
                TerminalShortcutsBar(
                  latched: terminalState.latchedModifiers,
                  onToggleModifier: _ctrl.toggleLatchedModifier,
                  onSendInput: (input) => _ctrl.sendInput(activeTab.id, input),
                  onPaste: () => _activePane?.paste(),
                  onClear: () => _ctrl.clearTab(activeTab.id),
                  onClose: _ctrl.toggleShortcutsBar,
                  onShowKeyboard: _isTouchPlatform ? () => _activePane?.showSoftKeyboard() : null,
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// The `⌄` dropdown (WT profile menu + the actions the old icon row held).
  List<Widget> _buildMenu(BuildContext context, TerminalState state, TerminalTab? activeTab) {
    final t = Translations.of(context);
    final c = context.appColors;
    final platform = defaultTargetPlatform;
    final connected = activeTab?.status == TerminalTabStatus.connected;

    MenuItemButton entry(
      IconData icon,
      String label, {
      VoidCallback? onTap,
      TerminalCommand? shortcut,
      String? shortcutText,
      Color? iconColor,
    }) {
      final chord =
          shortcutText ?? (shortcut != null ? terminalShortcutLabel(shortcut, platform) : null);
      return MenuItemButton(
        onPressed: onTap,
        style: _menuItemStyle,
        leadingIcon: Icon(icon, size: 15, color: onTap == null ? c.mutedForeground : iconColor),
        trailingIcon: chord == null
            ? null
            : Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Text(
                  chord,
                  style: TextStyle(
                    fontSize: 11,
                    color: c.mutedForeground,
                    fontFamilyFallback: AppFonts.mono,
                  ),
                ),
              ),
        child: Text(label, style: const TextStyle(fontSize: 13)),
      );
    }

    final profileLabel = _profileLabel;
    // Named accounts (Settings → Agents → accounts) become extra profiles:
    // "Claude CLI · Work" starts the CLI with that account's config dir.
    final accountProfiles = terminalAccountProfiles(
      ref.watch(providerAccountsProvider('')).accounts,
      providers: _accountProfileProviders,
    );

    SubmenuButton group(IconData icon, String label, List<Widget> children) => SubmenuButton(
      style: _menuItemStyle,
      leadingIcon: Icon(icon, size: 15),
      menuChildren: children,
      child: Text(label, style: const TextStyle(fontSize: 13)),
    );

    return [
      // Profiles — the default (plain shell) first, like WT's list.
      entry(
        terminalProfileIcon('', isPlainShell: true),
        t.terminal.tabs.plainShell,
        onTap: _newDefaultTab,
        shortcut: TerminalCommand.newTab,
      ),
      for (final provider in _providerProfiles)
        entry(
          terminalProfileIcon(provider, isPlainShell: false),
          profileLabel(provider),
          onTap: () => _runCliProfile(provider, activeTab),
        ),
      if (accountProfiles.isNotEmpty) const Divider(height: 8),
      for (final profile in accountProfiles)
        entry(
          LucideIcons.userRound,
          profile.title(profileLabel(profile.provider)),
          onTap: () => _runCliProfile(profile.provider, activeTab, account: profile),
        ),
      const Divider(height: 8),
      // Pane actions grouped in submenus so the dropdown stays short enough
      // for a phone in landscape.
      if (activeTab != null) ...[
        group(LucideIcons.textCursorInput, t.terminal.menu.edit, [
          entry(
            LucideIcons.search,
            t.terminal.menu.find,
            onTap: () => _activePane?.openSearch(),
            shortcut: TerminalCommand.find,
          ),
          entry(
            _copied ? LucideIcons.check : LucideIcons.copy,
            _copied ? t.chat.shell.actions.copied : t.chat.shell.actions.copyOutputTitle,
            onTap: () => _copyOutput(activeTab),
            iconColor: _copied ? const Color(0xFF16C60C) : null,
          ),
          entry(
            LucideIcons.textSelect,
            t.terminal.menu.selectAll,
            onTap: () => _activePane?.selectAll(),
            shortcut: TerminalCommand.selectAll,
          ),
          entry(
            LucideIcons.clipboardPaste,
            t.settings.terminalShortcuts.paste,
            onTap: () => _activePane?.paste(),
            shortcut: TerminalCommand.paste,
          ),
          entry(
            LucideIcons.eraser,
            t.terminal.actions.clearOutput,
            onTap: () => _ctrl.clearTab(activeTab.id),
          ),
        ]),
        group(LucideIcons.zoomIn, t.terminal.menu.view, [
          entry(
            LucideIcons.zoomIn,
            t.chat.shell.actions.zoomInTitle,
            onTap: activeTab.fontSize < terminalFontSizeMax
                ? () => _ctrl.zoomIn(activeTab.id)
                : null,
            shortcut: TerminalCommand.zoomIn,
          ),
          entry(
            LucideIcons.zoomOut,
            t.chat.shell.actions.zoomOutTitle,
            onTap: activeTab.fontSize > terminalFontSizeMin
                ? () => _ctrl.zoomOut(activeTab.id)
                : null,
            shortcut: TerminalCommand.zoomOut,
          ),
          entry(
            LucideIcons.aLargeSmall,
            t.terminal.menu.zoomReset,
            onTap: activeTab.fontSize != terminalFontSizeDefault
                ? () => _ctrl.zoomReset(activeTab.id)
                : null,
            shortcut: TerminalCommand.zoomReset,
          ),
          entry(
            state.showShortcutsBar ? LucideIcons.keyboardOff : LucideIcons.keyboard,
            t.terminal.menu.keyBar,
            onTap: _ctrl.toggleShortcutsBar,
          ),
        ]),
        group(LucideIcons.squareTerminal, t.terminal.menu.session, [
          entry(
            LucideIcons.copyPlus,
            t.terminal.menu.duplicateTab,
            onTap: () => _ctrl.duplicateTab(activeTab.id),
            shortcut: TerminalCommand.duplicateTab,
          ),
          entry(
            LucideIcons.square,
            t.chat.shell.actions.killTitle,
            onTap: connected ? () => _ctrl.sendInput(activeTab.id, '\x03') : null,
            iconColor: connected ? const Color(0xFFE74856) : null,
          ),
          entry(
            LucideIcons.rotateCcw,
            t.terminal.actions.restartSession,
            onTap: () => _ctrl.restartTab(activeTab.id),
          ),
          if (connected)
            entry(
              LucideIcons.unplug,
              t.chat.shell.actions.disconnect,
              onTap: () => _ctrl.disconnectTab(activeTab.id),
              iconColor: const Color(0xFFE74856),
            )
          else
            entry(
              LucideIcons.plug,
              t.terminal.actions.connect,
              onTap: () => _ctrl.reconnectTab(activeTab.id),
            ),
          entry(
            LucideIcons.x,
            t.terminal.menu.closeTab,
            onTap: () => _ctrl.closeTab(activeTab.id),
            shortcut: TerminalCommand.closeTab,
          ),
        ]),
        const Divider(height: 8),
      ],
      entry(
        LucideIcons.keyRound,
        t.terminal.actions.providerLogin,
        onTap: () => ProviderLoginDialog.show(context: context, projectPath: _resolveProjectPath()),
      ),
      entry(
        LucideIcons.command,
        t.terminal.menu.shortcutsHelp,
        onTap: () => context.go('/settings/shortcuts'),
        shortcut: TerminalCommand.commandMenu,
      ),
    ];
  }

  /// Terminal + overlays (web `relative flex-1`): connection overlay with the
  /// explicit Connect CTA, and the CLI-prompt option chips strip.
  Widget _terminalArea(TerminalTab activeTab) {
    final connected = activeTab.status == TerminalTabStatus.connected;
    // `md:hidden short:!block` — the chips exist for touch/small screens.
    final showChips =
        activeTab.promptOptions != null &&
        connected &&
        (MediaQuery.sizeOf(context).width < 768 || MediaQuery.sizeOf(context).height < 450);

    return Stack(
      children: [
        Positioned.fill(
          child: TerminalViewWrapper(
            // One pane state per tab; the GlobalKey moves to whichever tab is
            // active so the menu/shortcuts always address the visible pane.
            key: _viewKeyFor(activeTab),
            tab: activeTab,
            onFileOpen: _handleOpenFile,
            onTabCommand: _runTabCommand,
          ),
        ),
        if (showChips)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _PromptChipsBar(
              options: activeTab.promptOptions!,
              onAnswer: (input) => _ctrl.answerPrompt(activeTab.id, input),
            ),
          ),
        if (activeTab.status != TerminalTabStatus.connected)
          _ConnectionOverlay(tab: activeTab, onConnect: () => _ctrl.reconnectTab(activeTab.id)),
      ],
    );
  }

  Widget _buildAuthUrlBanner(String authUrl) {
    final colors = Theme.of(context).extension<AppColors>() ?? AppColors.dark;
    final t = Translations.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: colors.primary.withValues(alpha: 0.12),
      child: Row(
        children: [
          Icon(Icons.link, size: 16, color: colors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              t.terminal.authUrl.linkLabel(url: authUrl),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontFamilyFallback: AppFonts.mono,
                color: colors.primary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: () => _openAuthUrl(authUrl),
            icon: const Icon(Icons.open_in_new, size: 14),
            label: Text(t.common.gitPanel.worktrees.open),
            style: TextButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final palette = TerminalPalette.of(context);
    final t = Translations.of(context);
    final fg = palette.tabStripForeground;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.terminal_rounded, size: 48, color: fg.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(
            t.terminal.empty.title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: fg),
          ),
          const SizedBox(height: 8),
          Text(
            t.terminal.empty.description,
            style: TextStyle(fontSize: 13, color: fg.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              _ctrl.createTab(
                title: t.terminal.tabs.shellName(index: 1),
                projectPath: _resolveProjectPath(),
                hostId: widget.hostId,
                isPlainShell: true,
              );
            },
            icon: const Icon(Icons.add),
            label: Text(t.terminal.actions.newShell),
          ),
        ],
      ),
    );
  }
}

/// `ShellConnectionOverlay` port — translucent full-cover layer over the
/// pane: spinner + "Connecting…" while connecting; an explicit Connect CTA
/// (description underneath) once disconnected/exited.
class _ConnectionOverlay extends StatelessWidget {
  const _ConnectionOverlay({required this.tab, required this.onConnect});

  final TerminalTab tab;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final palette = TerminalPalette.of(context);
    final connecting = tab.status == TerminalTabStatus.connecting;
    final description = switch (tab.status) {
      TerminalTabStatus.exited =>
        tab.exitCode != null
            ? t.terminal.overlay.processExitedWithCode(code: tab.exitCode!)
            : t.terminal.overlay.processExited,
      _ =>
        tab.sessionId != null
            ? t.terminal.overlay.resumeSession(title: tab.title)
            : t.terminal.overlay.startSession(path: tab.projectPath),
    };
    final descriptionStyle = TextStyle(
      fontSize: 13,
      height: 1.5,
      color: palette.foreground.withValues(alpha: 0.85),
    );
    return Container(
      color: palette.background.withValues(alpha: 0.9),
      child: Center(
        child: connecting
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFF9F1A5), // Campbell bright yellow
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        t.serverConnect.connecting,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFF9F1A5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(description, textAlign: TextAlign.center, style: descriptionStyle),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton.icon(
                    onPressed: onConnect,
                    icon: const Icon(LucideIcons.rotateCcw, size: 16),
                    label: Text(t.terminal.actions.connect),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF13A10E), // Campbell green
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: descriptionStyle,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// CLI prompt option chips (web `cliPromptOptions` strip) — `N. label`
/// buttons send the digit; the Esc chip sends `\x1b`.
class _PromptChipsBar extends StatelessWidget {
  const _PromptChipsBar({required this.options, required this.onAnswer});

  final List<CliPromptOption> options;
  final void Function(String input) onAnswer;

  @override
  Widget build(BuildContext context) {
    final palette = TerminalPalette.of(context);
    return Container(
      decoration: BoxDecoration(
        color: palette.tabStrip.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: palette.chromeBorder.withValues(alpha: 0.8))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 6,
        children: [
          for (final opt in options)
            Tooltip(
              message: '${opt.number}. ${opt.label}',
              child: Material(
                color: const Color(0xFF3B78FF), // Campbell bright blue
                borderRadius: BorderRadius.circular(4),
                child: InkWell(
                  onTap: () => onAnswer(opt.number),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      '${opt.number}. ${opt.label}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Material(
            color: palette.chrome,
            borderRadius: BorderRadius.circular(4),
            child: InkWell(
              onTap: () => onAnswer('\x1b'),
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Text(
                  'Esc',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: palette.tabStripForeground,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// The strip's project selector: shows the project of the active tab and
/// opens a new tab in the project picked from its menu.
class _TerminalProjectMenu extends StatelessWidget {
  const _TerminalProjectMenu({
    required this.projects,
    required this.selected,
    required this.onSelected,
  });

  final List<Project> projects;
  final Project? selected;
  final ValueChanged<Project> onSelected;

  static String _label(Project p) => p.displayName.isEmpty ? p.projectId : p.displayName;

  @override
  Widget build(BuildContext context) {
    if (projects.isEmpty) return const SizedBox.shrink();
    final palette = TerminalPalette.of(context);
    final colors = context.appColors;
    final t = Translations.of(context);
    final current = selected;
    return PopupMenuButton<Project>(
      tooltip: t.projects.project,
      position: PopupMenuPosition.under,
      onSelected: onSelected,
      itemBuilder: (_) => [
        PopupMenuItem<Project>(
          enabled: false,
          height: 28,
          child: Text(
            t.projects.project,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: colors.mutedForeground,
            ),
          ),
        ),
        for (final project in projects)
          PopupMenuItem<Project>(
            value: project,
            height: 36,
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  child: project.projectId == current?.projectId
                      ? const Icon(LucideIcons.check, size: 14)
                      : null,
                ),
                Flexible(
                  child: Text(
                    _label(project),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.folder, size: 14, color: palette.foreground.withValues(alpha: 0.75)),
            const SizedBox(width: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: Text(
                current == null ? t.projects.project : _label(current),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: palette.foreground.withValues(alpha: 0.75)),
              ),
            ),
            Icon(
              LucideIcons.chevronDown,
              size: 12,
              color: palette.foreground.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}
