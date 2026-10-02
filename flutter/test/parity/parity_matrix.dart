/// Feature-parity matrix (T40): every feature of the legacy app (web
/// `src/components/*` — 28 groups, mobile `mobile/src/screens/*` — 20
/// screens, `src/components/settings` main tabs — 12) mapped to its Flutter
/// counterpart under `lib/`.
///
/// Status semantics:
/// - [ParityStatus.full] — feature exists and matches the contract/UX.
/// - [ParityStatus.partial] — subset shipped; the gap is named in `note`.
/// - [ParityStatus.deferred] — consciously postponed (documented gap).
/// - [ParityStatus.missing] — no Flutter implementation yet.
/// - [ParityStatus.notApplicable] — web/Electron-specific, no port needed.
///
/// `flutterPath` must point at an existing file/dir under `lib/` for every
/// non-missing entry — the parity test asserts it.
library;

enum ParityStatus { full, partial, deferred, missing, notApplicable }

enum ParitySource { web, mobile, settings }

class ParityEntry {
  const ParityEntry({
    required this.source,
    required this.key,
    required this.status,
    this.flutterPath,
    this.note = '',
  });

  final ParitySource source;

  /// Source artifact key: component dir, screen file or settings tab id.
  final String key;
  final ParityStatus status;
  final String? flutterPath;
  final String note;
}

const parityMatrix = <ParityEntry>[
  // ─── Web `src/components/*` (28 groups) ───────────────────────────────
  ParityEntry(
    source: ParitySource.web,
    key: 'app',
    status: ParityStatus.full,
    flutterPath: 'lib/core/router/app_router.dart',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'auth',
    status: ParityStatus.full,
    flutterPath: 'lib/features/auth',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'browser-use',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/browser_use',
    note: 'Panel widget exists but is never mounted (no route/pane kind) + no session detail view + no enable toggle.',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'chat',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/chat',
    note: 'Missing: builtin slash-command result modals, model library, offline-queue card UI, todo tool renderers, file-open affordances, attachment download, composer prefs (sendByCtrlEnter/showThinking/showRawParameters), camera capture.',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'code-editor',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/editor',
    note: 'Missing: file download button, HTML preview in new window, fullscreen toggle.',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'command-palette',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/commands',
    note: 'Slash-command list/execute shipped; fuzzy palette overlay UI not ported.',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'file-tree',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/file_tree',
    note: 'Missing: OS drag-and-drop upload (picker only).',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'git-panel',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/git',
    note: 'Missing: History view (commit list + graph + per-commit diff), some destructive-op confirms, FileStatusLegend.',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'islands',
    status: ParityStatus.notApplicable,
    note: 'React server islands — no counterpart in a Flutter client.',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'kanban',
    status: ParityStatus.full,
    flutterPath: 'lib/features/kanban',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'llm-provider-logo',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/provider_accounts',
    note: 'Provider identities carried via provider_accounts; dedicated logo widget unported.',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'main-content',
    status: ParityStatus.full,
    flutterPath: 'lib/features/workspace',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'mcp',
    status: ParityStatus.missing,
    note: 'MCP server management UI not ported (status is read-only via taskmaster config).',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'onboarding',
    status: ParityStatus.full,
    flutterPath: 'lib/features/onboarding',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'prd-editor',
    status: ParityStatus.full,
    flutterPath: 'lib/features/taskmaster/view/prd_editor_dialog.dart',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'preview',
    status: ParityStatus.full,
    flutterPath: 'lib/features/preview',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'project-creation-wizard',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/projects',
    note: 'Create-project dialog exists; multi-step wizard (templates/walkthrough) simplified.',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'provider-auth',
    status: ParityStatus.full,
    flutterPath: 'lib/features/provider_accounts',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'quick-settings-panel',
    status: ParityStatus.missing,
    note: 'No floating quick panel and no settings screen (/settings = placeholder) — prefs toggles have no UI surface.',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'quota',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/quota',
    note: 'Missing: Control Center Overview section (KPIs, active tasks, alerts).',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'settings',
    status: ParityStatus.missing,
    note: '/settings and /settings/:section are PlaceholderPage — only a data repository + unused LanguagePicker exist. Per-tab detail below.',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'shared-notes',
    status: ParityStatus.full,
    flutterPath: 'lib/features/shared_context/view/shared_notes_pane.dart',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'shell',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/terminal',
    note: 'Missing: disconnect/copy-output/zoom buttons, CLI prompt option chips, connect overlay CTA, focusFollowsPointer.',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'sidebar',
    status: ParityStatus.partial,
    flutterPath: 'lib/core/widgets/adaptive_scaffold.dart',
    note: 'Missing: update badge + dialog, restart-required indicator, tasks rail gating, global shortcuts (Ctrl+K, Alt+digit, focus mode).',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'skills',
    status: ParityStatus.missing,
    note: 'Skill management UI not ported.',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'standalone-shell',
    status: ParityStatus.notApplicable,
    note: 'Electron-specific window shell — superseded by native Flutter shells.',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'task-master',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/taskmaster',
    note: 'Missing: help modal; setup modal partial.',
  ),
  ParityEntry(
    source: ParitySource.web,
    key: 'web-browser',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/browser',
    note: 'RemoteBrowserView widget is complete but /web route is a PlaceholderPage — unreachable standalone.',
  ),

  // ─── Mobile `mobile/src/screens/*` (20 screens) ───────────────────────
  ParityEntry(
    source: ParitySource.mobile,
    key: 'BoardScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/kanban/view/kanban_screen.dart',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'ChatScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/chat',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'EditorScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/editor',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'FileTreeScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/file_tree',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'LoginScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/auth',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'OnboardingScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/onboarding',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'ProjectsScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/projects',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'QuotaScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/quota/view/quota_screen.dart',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'RecentScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/sessions',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'ServerConnectScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/server_connect',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'SessionsScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/sessions',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'SettingsScreen',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/settings',
    note: 'See per-tab parity below.',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'SettingsTabs',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/settings',
    note: 'See per-tab parity below.',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'SetupScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/onboarding',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'SourceControlScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/git/view/git_screen.dart',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'TasksScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/taskmaster/view/taskmaster_screen.dart',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'TerminalScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/terminal',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'WebScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/browser',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'WorkspaceScreen',
    status: ParityStatus.full,
    flutterPath: 'lib/features/workspace',
  ),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'settings/',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/settings',
    note: 'Mobile settings tab screens map onto the Flutter settings feature.',
  ),

  // ─── Settings main tabs `SETTINGS_MAIN_TABS` (12) ─────────────────────
  // NOTE: no settings screen exists — /settings is a PlaceholderPage. Only
  // quota + schedules ship as standalone screens reachable outside settings.
  ParityEntry(
    source: ParitySource.settings,
    key: 'general',
    status: ParityStatus.missing,
    note: 'No settings UI; user feature has only data layer.',
  ),
  ParityEntry(
    source: ParitySource.settings,
    key: 'agents',
    status: ParityStatus.missing,
    note: 'ProviderAccounts repo exists, no UI (only composer account picker).',
  ),
  ParityEntry(
    source: ParitySource.settings,
    key: 'orchestration',
    status: ParityStatus.missing,
    note: 'Config GET/PUT repo exists; no settings UI.',
  ),
  ParityEntry(
    source: ParitySource.settings,
    key: 'appearance',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/settings/ui/language_picker.dart',
    note: 'ThemeModeController + LanguagePicker exist but picker has zero call sites; no toggles for editor prefs/voice/focus.',
  ),
  ParityEntry(
    source: ParitySource.settings,
    key: 'workspaces',
    status: ParityStatus.missing,
    note: 'No workspace management screen.',
  ),
  ParityEntry(
    source: ParitySource.settings,
    key: 'git',
    status: ParityStatus.missing,
    note: 'git-config API used only in onboarding; no post-onboarding editor.',
  ),
  ParityEntry(
    source: ParitySource.settings,
    key: 'api',
    status: ParityStatus.missing,
    note: 'API keys + GitHub creds + STT config: repo methods exist, unused.',
  ),
  ParityEntry(
    source: ParitySource.settings,
    key: 'tasks',
    status: ParityStatus.missing,
    note: 'No global tasksEnabled toggle.',
  ),
  ParityEntry(
    source: ParitySource.settings,
    key: 'browser',
    status: ParityStatus.missing,
    note: 'GET/PUT settings repo method unwired; no enable toggle.',
  ),
  ParityEntry(
    source: ParitySource.settings,
    key: 'notifications',
    status: ParityStatus.missing,
    note: 'Repository only — no UI at all.',
  ),
  ParityEntry(
    source: ParitySource.settings,
    key: 'schedules',
    status: ParityStatus.full,
    flutterPath: 'lib/features/scheduler',
    note: 'Relocated to standalone /scheduler screen.',
  ),
  ParityEntry(
    source: ParitySource.settings,
    key: 'about',
    status: ParityStatus.missing,
    note: 'Version/changelog/update-check/restart not ported; latestRelease() is dead code.',
  ),
];
