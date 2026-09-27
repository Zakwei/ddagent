import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/widgets/adaptive_scaffold.dart';
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
  static const recent = 'recent';
  static const chat = 'chat';
  static const board = 'board';
  static const tasks = 'tasks';
  static const files = 'files';
  static const editor = 'editor';
  static const terminal = 'terminal';
  static const git = 'git';
  static const quota = 'quota';
  static const web = 'web';
  static const settings = 'settings';
}

/// Paths reachable without a JWT: server connect + onboarding/setup flow.
const _publicPaths = {'/login', '/setup', '/connect', '/onboarding'};

/// Placeholder body for routes whose feature UI lands in later tasks.
/// Keeps the route table + navigation usable end-to-end today.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) =>
      Center(child: Text(title, style: Theme.of(context).textTheme.titleLarge));
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
      final isPublic = _publicPaths.contains(path);
      final token = await tokens.token;
      if (token == null && !isPublic) {
        return '/connect?from=${Uri.encodeComponent(path)}';
      }
      if (token != null && isPublic && path != '/onboarding') {
        return '/projects';
      }
      return remapped;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: Routes.login,
        builder: (_, _) => const PlaceholderPage(title: 'Login'),
      ),
      GoRoute(
        path: '/setup',
        name: Routes.setup,
        builder: (_, _) => const PlaceholderPage(title: 'Setup'),
      ),
      GoRoute(
        path: '/connect',
        name: Routes.connect,
        builder: (_, _) => const PlaceholderPage(title: 'Connect'),
      ),
      GoRoute(
        path: '/onboarding',
        name: Routes.onboarding,
        builder: (_, _) => const PlaceholderPage(title: 'Onboarding'),
      ),
      // Everything below renders inside the adaptive shell.
      ShellRoute(
        builder: (_, _, child) => AdaptiveScaffold(child: child),
        routes: [
          GoRoute(
            path: '/projects',
            name: Routes.projects,
            builder: (_, _) => const PlaceholderPage(title: 'Projects'),
          ),
          GoRoute(
            path: '/sessions',
            name: Routes.sessions,
            builder: (_, _) => const PlaceholderPage(title: 'Sessions'),
          ),
          GoRoute(
            path: '/recent',
            name: Routes.recent,
            builder: (_, _) => const PlaceholderPage(title: 'Recent'),
          ),
          GoRoute(
            path: '/chat/:id',
            name: Routes.chat,
            builder: (_, s) => PlaceholderPage(title: 'Chat ${s.pathParameters['id']}'),
          ),
          GoRoute(
            path: '/board',
            name: Routes.board,
            builder: (_, _) => const PlaceholderPage(title: 'Board'),
          ),
          GoRoute(
            path: '/tasks',
            name: Routes.tasks,
            builder: (_, _) => const PlaceholderPage(title: 'Tasks'),
          ),
          GoRoute(
            path: '/files',
            name: Routes.files,
            builder: (_, _) => const PlaceholderPage(title: 'Files'),
          ),
          GoRoute(
            path: '/editor',
            name: Routes.editor,
            builder: (_, _) => const PlaceholderPage(title: 'Editor'),
          ),
          GoRoute(
            path: '/terminal',
            name: Routes.terminal,
            builder: (_, _) => const PlaceholderPage(title: 'Terminal'),
          ),
          GoRoute(
            path: '/git',
            name: Routes.git,
            builder: (_, _) => const PlaceholderPage(title: 'Git'),
          ),
          GoRoute(
            path: '/quota',
            name: Routes.quota,
            builder: (_, _) => const PlaceholderPage(title: 'Quota'),
          ),
          GoRoute(
            path: '/web',
            name: Routes.web,
            builder: (_, _) => const PlaceholderPage(title: 'Web'),
          ),
          GoRoute(
            path: '/settings',
            name: Routes.settings,
            builder: (_, _) => const PlaceholderPage(title: 'Settings'),
            routes: [
              GoRoute(
                path: ':section',
                builder: (_, s) =>
                    PlaceholderPage(title: 'Settings: ${s.pathParameters['section']}'),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
