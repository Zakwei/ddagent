import 'package:ddagent_app/core/config/env.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/widgets/adaptive_scaffold.dart';
import 'package:ddagent_app/core/widgets/app_nav_menu.dart';
import 'package:ddagent_app/features/auth/state/auth_controller.dart';
import 'package:ddagent_app/features/auth/view/auth_screens.dart';
import 'package:ddagent_app/features/browser/view/web_browser_screen.dart';
import 'package:ddagent_app/features/chat/view/transcript_view.dart';
import 'package:ddagent_app/features/editor/view/editor_screen.dart';
import 'package:ddagent_app/features/file_tree/view/file_tree_screen.dart';
import 'package:ddagent_app/features/git/view/git_screen.dart';
import 'package:ddagent_app/features/kanban/view/kanban_screen.dart';
import 'package:ddagent_app/features/knowledge/view/knowledge_screen.dart';
import 'package:ddagent_app/features/mcp/view/mcp_servers_screen.dart';
import 'package:ddagent_app/features/onboarding/view/onboarding_screen.dart';
import 'package:ddagent_app/features/projects/view/projects_screen.dart';
import 'package:ddagent_app/features/quota/view/quota_screen.dart';
import 'package:ddagent_app/features/scheduler/view/scheduler_screen.dart';
import 'package:ddagent_app/features/server_connect/data/server_profiles.dart';
import 'package:ddagent_app/features/server_connect/state/local_server_controller.dart';
import 'package:ddagent_app/features/server_connect/view/server_connect_screen.dart';
import 'package:ddagent_app/features/sessions/view/sessions_screen.dart';
import 'package:ddagent_app/features/settings/view/settings_screen.dart';
import 'package:ddagent_app/features/shared_context/view/shared_notes_pane.dart';
import 'package:ddagent_app/features/skills/view/skills_screen.dart';
import 'package:ddagent_app/features/taskmaster/view/taskmaster_screen.dart';
import 'package:ddagent_app/features/terminal/view/terminal_screen.dart';
import 'package:ddagent_app/features/workspace/view/workspace_screen.dart';
import 'package:ddagent_app/features/worktrees/view/worktrees_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// External deep-link scheme shared with the RN mobile client —
/// `ddagent://chat/<sessionId>`, `ddagent://sessions/<projectId>` etc.
/// (`ddagent-app://` is only the internal Electron bundle protocol.)
const kDeepLinkScheme = 'ddagent';

/// Route names — stable identifiers for `context.goNamed`.
abstract final class Routes {
  static const login = 'login';
  static const setup = 'setup';
  static const connect = 'connect';
  static const onboarding = 'onboarding';
  static const projects = 'projects';
  static const sessions = 'sessions';
  static const workspace = 'workspace';
  static const recent = 'recent';
  static const chat = 'chat';
  static const board = 'board';
  static const tasks = 'tasks';
  static const files = 'files';
  static const editor = 'editor';
  static const terminal = 'terminal';
  static const git = 'git';
  static const quota = 'quota';
  static const scheduler = 'scheduler';
  static const mcp = 'mcp';
  static const skills = 'skills';
  static const knowledge = 'knowledge';
  static const worktrees = 'worktrees';
  static const notes = 'notes';
  static const web = 'web';
  static const browser = 'browser';
  static const settings = 'settings';
}

/// Paths reachable without a JWT: server connect + onboarding/setup flow.
const _publicPaths = {'/login', '/setup', '/connect', '/onboarding'};

/// Placeholder body for routes whose feature UI lands in later tasks.
/// Keeps the route table + navigation usable end-to-end today.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title, this.actions = const []});

  final String title;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // No header of its own, so on compact the drawer hamburger rides in a
        // small top row (web pages carry `onMenuClick` for the same reason).
        if (context.breakpoint.isCompact)
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppNavMenuButton(),
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ),
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        if (actions.isNotEmpty) ...[const SizedBox(height: 16), ...actions],
      ],
    ),
  );
}

/// Auth guard: without a stored JWT any in-app path redirects to /connect
/// with the intended location in `?from=` so login can restore it.
final routerProvider = Provider<GoRouter>((ref) {
  final tokens = ref.watch(authTokenStoreProvider);
  return GoRouter(
    initialLocation: '/projects',
    redirect: (context, state) async {
      var path = state.uri.path;
      // ddagent://chat/42 arrives as host=chat, path=/42 — fold host into
      // the path like the RN linking config's screen mapping.
      final remapped = state.uri.scheme == kDeepLinkScheme && state.uri.host.isNotEmpty
          ? '/${state.uri.host}$path${state.uri.query.isEmpty ? '' : '?${state.uri.query}'}'
          : null;
      if (remapped != null) path = remapped;
      // Embedded/platform builds are served by the sidecar — no auth gate;
      // the connect/login/setup screens are unreachable there.
      if (Env.embedded) {
        const authPaths = {'/connect', '/login', '/setup'};
        return authPaths.contains(path) ? '/projects' : remapped;
      }
      // No server configured → connect screen first.
      final profilesState = ref.read(serverProfilesProvider);
      if (profilesState.activeUrl == null && Env.defaultServerUrl.isEmpty && path != '/connect') {
        return '/connect';
      }
      // Active profile is the on-device server → make sure it's running
      // before any API call can fire. Idempotent and shared across callers.
      final activeProfile = profilesState.profiles
          .where((p) => p.url == profilesState.activeUrl)
          .firstOrNull;
      if (activeProfile?.isLocal ?? false) {
        await ref.read(localServerProvider.notifier).ensureRunning();
      }
      final auth = ref.read(authControllerProvider);
      // First-run servers need the owner registration before anything else.
      if (auth.needsSetup && path != '/setup') {
        return '/setup';
      }
      final isPublic = _publicPaths.contains(path);
      final token = await tokens.token;
      if (token == null && !isPublic) {
        return '/connect?from=${Uri.encodeComponent(path)}';
      }
      // Authenticated but onboarding not completed → gate into the wizard.
      if (token != null && !auth.onboardingDone && path != '/onboarding') {
        return '/onboarding';
      }
      // /connect stays reachable while authenticated — it doubles as the
      // server switcher (local ↔ remote), not only a first-run screen.
      if (token != null && isPublic && path != '/onboarding' && path != '/connect') {
        return '/projects';
      }
      return remapped;
    },
    routes: [
      GoRoute(path: '/login', name: Routes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: '/setup', name: Routes.setup, builder: (_, _) => const SetupScreen()),
      GoRoute(
        path: '/connect',
        name: Routes.connect,
        builder: (_, _) => const ServerConnectScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: Routes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      // Everything below renders inside the adaptive shell.
      ShellRoute(
        builder: (_, _, child) => AdaptiveScaffold(child: child),
        routes: [
          GoRoute(
            path: '/projects',
            name: Routes.projects,
            builder: (_, _) => const ProjectsScreen(),
          ),
          GoRoute(
            path: '/sessions',
            name: Routes.sessions,
            builder: (_, s) => SessionsScreen(
              projectId: s.uri.queryParameters['projectId'],
              projectPath: s.uri.queryParameters['projectPath'],
            ),
          ),
          GoRoute(
            path: '/workspace',
            name: Routes.workspace,
            builder: (_, _) => const WorkspaceScreen(),
          ),
          GoRoute(path: '/recent', name: Routes.recent, builder: (_, _) => const RecentScreen()),
          GoRoute(
            path: '/chat/:id',
            name: Routes.chat,
            builder: (_, s) => TranscriptView(
              sessionId: s.pathParameters['id'] ?? '',
              projectId: s.uri.queryParameters['projectId'],
              projectPath: s.uri.queryParameters['projectPath'],
              // Draft `/chat/new` carries the provider/account the user picked
              // in the provider dialog so the composer mounts on the right one.
              initialProvider: s.uri.queryParameters['provider'],
              initialAccountId: s.uri.queryParameters['accountId'],
              standalone: true,
            ),
          ),
          GoRoute(
            path: '/board',
            name: Routes.board,
            builder: (_, s) => KanbanScreen(projectId: s.uri.queryParameters['projectId']),
          ),
          GoRoute(
            path: '/tasks',
            name: Routes.tasks,
            builder: (_, s) => TaskmasterScreen(projectId: s.uri.queryParameters['projectId']),
          ),
          GoRoute(
            path: '/files',
            name: Routes.files,
            builder: (_, s) => FileTreeScreen(
              projectId: s.uri.queryParameters['projectId'],
              projectPath: s.uri.queryParameters['projectPath'],
            ),
          ),
          GoRoute(
            path: '/editor',
            name: Routes.editor,
            builder: (_, s) => EditorScreen(
              projectId: s.uri.queryParameters['projectId'],
              filePath: s.uri.queryParameters['file'],
            ),
          ),
          GoRoute(
            path: '/terminal',
            name: Routes.terminal,
            builder: (_, s) => TerminalScreen(
              projectId: s.uri.queryParameters['projectId'],
              projectPath: s.uri.queryParameters['projectPath'],
              sessionId: s.uri.queryParameters['sessionId'],
            ),
          ),
          GoRoute(
            path: '/git',
            name: Routes.git,
            builder: (_, s) =>
                GitScreen(projectId: s.uri.queryParameters['projectId'], standalone: true),
          ),
          GoRoute(path: '/quota', name: Routes.quota, builder: (_, _) => const QuotaScreen()),
          GoRoute(
            path: '/scheduler',
            name: Routes.scheduler,
            builder: (_, _) => const SchedulerScreen(),
          ),
          GoRoute(path: '/mcp', name: Routes.mcp, builder: (_, _) => const McpServersScreen()),
          GoRoute(path: '/skills', name: Routes.skills, builder: (_, _) => const SkillsScreen()),
          GoRoute(
            path: '/knowledge',
            name: Routes.knowledge,
            builder: (_, _) => const KnowledgeScreen(),
          ),
          GoRoute(
            path: '/worktrees',
            name: Routes.worktrees,
            builder: (_, s) => WorktreesScreen(projectId: s.uri.queryParameters['projectId']),
          ),
          GoRoute(
            path: '/notes',
            name: Routes.notes,
            builder: (_, s) => SharedNotesScreen(projectId: s.uri.queryParameters['projectId']),
          ),
          GoRoute(
            path: '/web',
            name: Routes.web,
            builder: (_, s) => WebBrowserScreen(url: s.uri.queryParameters['url']),
          ),
          GoRoute(
            path: '/browser',
            name: Routes.browser,
            builder: (_, _) => const BrowserUseScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: Routes.settings,
            // Bare /settings reopens the last-used section; the guard keeps
            // deep links to /settings/:section from bouncing through it.
            redirect: (_, s) =>
                s.uri.path == '/settings' ? '/settings/${lastSettingsSection()}' : null,
            routes: [
              GoRoute(
                path: ':section',
                redirect: (_, s) =>
                    settingsSectionFor(s.pathParameters['section']) == null ? '/settings' : null,
                builder: (_, s) => SettingsScreen(section: s.pathParameters['section']!),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
