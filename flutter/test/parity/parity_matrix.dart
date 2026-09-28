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
  ParityEntry(source: ParitySource.web, key: 'app', status: ParityStatus.full, flutterPath: 'lib/core/router/app_router.dart'),
  ParityEntry(source: ParitySource.web, key: 'auth', status: ParityStatus.full, flutterPath: 'lib/features/auth'),
  ParityEntry(source: ParitySource.web, key: 'browser-use', status: ParityStatus.full, flutterPath: 'lib/features/browser_use'),
  ParityEntry(source: ParitySource.web, key: 'chat', status: ParityStatus.full, flutterPath: 'lib/features/chat'),
  ParityEntry(source: ParitySource.web, key: 'code-editor', status: ParityStatus.full, flutterPath: 'lib/features/editor'),
  ParityEntry(
    source: ParitySource.web,
    key: 'command-palette',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/commands',
    note: 'Slash-command list/execute shipped; fuzzy palette overlay UI not ported.',
  ),
  ParityEntry(source: ParitySource.web, key: 'file-tree', status: ParityStatus.full, flutterPath: 'lib/features/file_tree'),
  ParityEntry(source: ParitySource.web, key: 'git-panel', status: ParityStatus.full, flutterPath: 'lib/features/git'),
  ParityEntry(
    source: ParitySource.web,
    key: 'islands',
    status: ParityStatus.notApplicable,
    note: 'React server islands — no counterpart in a Flutter client.',
  ),
  ParityEntry(source: ParitySource.web, key: 'kanban', status: ParityStatus.full, flutterPath: 'lib/features/kanban'),
  ParityEntry(
    source: ParitySource.web,
    key: 'llm-provider-logo',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/provider_accounts',
    note: 'Provider identities carried via provider_accounts; dedicated logo widget unported.',
  ),
  ParityEntry(source: ParitySource.web, key: 'main-content', status: ParityStatus.full, flutterPath: 'lib/features/workspace'),
  ParityEntry(
    source: ParitySource.web,
    key: 'mcp',
    status: ParityStatus.missing,
    note: 'MCP server management UI not ported (status is read-only via taskmaster config).',
  ),
  ParityEntry(source: ParitySource.web, key: 'onboarding', status: ParityStatus.full, flutterPath: 'lib/features/onboarding'),
  ParityEntry(source: ParitySource.web, key: 'prd-editor', status: ParityStatus.full, flutterPath: 'lib/features/taskmaster/view/prd_editor_dialog.dart'),
  ParityEntry(source: ParitySource.web, key: 'preview', status: ParityStatus.full, flutterPath: 'lib/features/preview'),
  ParityEntry(
    source: ParitySource.web,
    key: 'project-creation-wizard',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/projects',
    note: 'Create-project dialog exists; multi-step wizard (templates/walkthrough) simplified.',
  ),
  ParityEntry(source: ParitySource.web, key: 'provider-auth', status: ParityStatus.full, flutterPath: 'lib/features/provider_accounts'),
  ParityEntry(
    source: ParitySource.web,
    key: 'quick-settings-panel',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/settings',
    note: 'Folded into the settings screen; no floating quick panel.',
  ),
  ParityEntry(source: ParitySource.web, key: 'quota', status: ParityStatus.full, flutterPath: 'lib/features/quota'),
  ParityEntry(
    source: ParitySource.web,
    key: 'settings',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/settings',
    note: 'Locale/theme/account prefs shipped; per-tab parity tracked in the settings section below.',
  ),
  ParityEntry(source: ParitySource.web, key: 'shared-notes', status: ParityStatus.full, flutterPath: 'lib/features/shared_context/view/shared_notes_pane.dart'),
  ParityEntry(source: ParitySource.web, key: 'shell', status: ParityStatus.full, flutterPath: 'lib/core/widgets/adaptive_scaffold.dart'),
  ParityEntry(source: ParitySource.web, key: 'sidebar', status: ParityStatus.full, flutterPath: 'lib/core/widgets/adaptive_scaffold.dart'),
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
  ParityEntry(source: ParitySource.web, key: 'task-master', status: ParityStatus.full, flutterPath: 'lib/features/taskmaster'),
  ParityEntry(source: ParitySource.web, key: 'web-browser', status: ParityStatus.full, flutterPath: 'lib/features/browser'),

  // ─── Mobile `mobile/src/screens/*` (20 screens) ───────────────────────
  ParityEntry(source: ParitySource.mobile, key: 'BoardScreen', status: ParityStatus.full, flutterPath: 'lib/features/kanban/view/kanban_screen.dart'),
  ParityEntry(source: ParitySource.mobile, key: 'ChatScreen', status: ParityStatus.full, flutterPath: 'lib/features/chat'),
  ParityEntry(source: ParitySource.mobile, key: 'EditorScreen', status: ParityStatus.full, flutterPath: 'lib/features/editor'),
  ParityEntry(source: ParitySource.mobile, key: 'FileTreeScreen', status: ParityStatus.full, flutterPath: 'lib/features/file_tree'),
  ParityEntry(source: ParitySource.mobile, key: 'LoginScreen', status: ParityStatus.full, flutterPath: 'lib/features/auth'),
  ParityEntry(source: ParitySource.mobile, key: 'OnboardingScreen', status: ParityStatus.full, flutterPath: 'lib/features/onboarding'),
  ParityEntry(source: ParitySource.mobile, key: 'ProjectsScreen', status: ParityStatus.full, flutterPath: 'lib/features/projects'),
  ParityEntry(source: ParitySource.mobile, key: 'QuotaScreen', status: ParityStatus.full, flutterPath: 'lib/features/quota/view/quota_screen.dart'),
  ParityEntry(source: ParitySource.mobile, key: 'RecentScreen', status: ParityStatus.full, flutterPath: 'lib/features/sessions'),
  ParityEntry(source: ParitySource.mobile, key: 'ServerConnectScreen', status: ParityStatus.full, flutterPath: 'lib/features/server_connect'),
  ParityEntry(source: ParitySource.mobile, key: 'SessionsScreen', status: ParityStatus.full, flutterPath: 'lib/features/sessions'),
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
  ParityEntry(source: ParitySource.mobile, key: 'SetupScreen', status: ParityStatus.full, flutterPath: 'lib/features/onboarding'),
  ParityEntry(source: ParitySource.mobile, key: 'SourceControlScreen', status: ParityStatus.full, flutterPath: 'lib/features/git/view/git_screen.dart'),
  ParityEntry(source: ParitySource.mobile, key: 'TasksScreen', status: ParityStatus.full, flutterPath: 'lib/features/taskmaster/view/taskmaster_screen.dart'),
  ParityEntry(source: ParitySource.mobile, key: 'TerminalScreen', status: ParityStatus.full, flutterPath: 'lib/features/terminal'),
  ParityEntry(source: ParitySource.mobile, key: 'WebScreen', status: ParityStatus.full, flutterPath: 'lib/features/browser'),
  ParityEntry(source: ParitySource.mobile, key: 'WorkspaceScreen', status: ParityStatus.full, flutterPath: 'lib/features/workspace'),
  ParityEntry(
    source: ParitySource.mobile,
    key: 'settings/',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/settings',
    note: 'Mobile settings tab screens map onto the Flutter settings feature.',
  ),

  // ─── Settings main tabs `SETTINGS_MAIN_TABS` (12) ─────────────────────
  ParityEntry(source: ParitySource.settings, key: 'general', status: ParityStatus.partial, flutterPath: 'lib/features/user', note: 'Account/profile prefs via user feature.'),
  ParityEntry(source: ParitySource.settings, key: 'agents', status: ParityStatus.partial, flutterPath: 'lib/features/orchestrator', note: 'Provider/agent config covered by orchestrator + provider_accounts.'),
  ParityEntry(source: ParitySource.settings, key: 'orchestration', status: ParityStatus.full, flutterPath: 'lib/features/orchestrator'),
  ParityEntry(source: ParitySource.settings, key: 'appearance', status: ParityStatus.full, flutterPath: 'lib/features/settings/ui/language_picker.dart', note: 'Theme + locale.'),
  ParityEntry(source: ParitySource.settings, key: 'workspaces', status: ParityStatus.full, flutterPath: 'lib/features/workspace'),
  ParityEntry(source: ParitySource.settings, key: 'git', status: ParityStatus.full, flutterPath: 'lib/features/git'),
  ParityEntry(source: ParitySource.settings, key: 'api', status: ParityStatus.partial, flutterPath: 'lib/features/auth', note: 'Token connect flow exists; token management tab not ported.'),
  ParityEntry(source: ParitySource.settings, key: 'tasks', status: ParityStatus.full, flutterPath: 'lib/features/taskmaster'),
  ParityEntry(source: ParitySource.settings, key: 'browser', status: ParityStatus.full, flutterPath: 'lib/features/browser_use', note: 'Runtime install + session settings.'),
  ParityEntry(source: ParitySource.settings, key: 'notifications', status: ParityStatus.full, flutterPath: 'lib/features/notifications'),
  ParityEntry(source: ParitySource.settings, key: 'schedules', status: ParityStatus.full, flutterPath: 'lib/features/scheduler'),
  ParityEntry(
    source: ParitySource.settings,
    key: 'about',
    status: ParityStatus.partial,
    flutterPath: 'lib/features/settings',
    note: 'Version/changelog section not yet ported.',
  ),
];
