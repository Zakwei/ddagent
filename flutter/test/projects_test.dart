import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/sse_client.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/projects/view/projects_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Dio _fakeDio(Map<String, dynamic> routes) {
  final dio = Dio(BaseOptions(baseUrl: 'http://t'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (o, h) {
        final key = '${o.method} ${o.path}';
        var res = routes[key];
        if (res is Function) res = res();
        if (res is Exception) {
          h.reject(
            DioException(
              requestOptions: o,
              response: Response(
                requestOptions: o,
                statusCode: 500,
                data: {'error': res.toString()},
              ),
            ),
          );
        } else {
          h.resolve(Response(requestOptions: o, data: res));
        }
      },
    ),
  );
  return dio;
}

ProviderContainer _container(Map<String, dynamic> routes) => ProviderContainer(
  overrides: [
    dioProvider.overrideWithValue(_fakeDio(routes)),
    chatChannelProvider.overrideWithValue(
      ChatChannel(WsClient(urlBuilder: () async => Uri.parse('ws://t'))),
    ),
  ],
)..listen(projectsProvider, (_, _) {});

Map<String, dynamic> _project(String id, {bool starred = false}) => {
  'projectId': id,
  'path': '/w/$id',
  'displayName': 'Proj $id',
  'isStarred': starred,
  'isArchived': false,
  'sessionMeta': {'total': 0, 'sessions': <dynamic>[]},
};

Map<String, dynamic> _routes(
  List<String> ids, {
  List<String> archived = const [],
}) => {
  'GET /api/projects': {
    'projects': [for (final id in ids) _project(id)],
  },
  // Real server envelope: {success: true, data: {projects: [...]}}.
  'GET /api/projects/archived': {
    'success': true,
    'data': {
      'projects': [for (final id in archived) _project(id)],
    },
  },
  for (final id in ids)
    'GET /api/projects/$id/taskmaster': {'taskmaster': <String, dynamic>{}},
};

Future<void> _loaded(ProviderContainer c, {int min = 1}) async {
  for (var i = 0; i < 500; i++) {
    final s = c.read(projectsProvider);
    if (!s.loading && s.projects.length >= min) return;
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }
  throw StateError('projects never loaded');
}

void main() {
  test('loads projects and archived lists', () async {
    final c = _container(_routes(['a', 'b'], archived: ['old']));
    await _loaded(c, min: 2);
    final s = c.read(projectsProvider);
    expect(s.projects.map((p) => p.projectId), ['a', 'b']);
    expect(s.archived.single.projectId, 'old');
    c.dispose();
  });

  test('toggleStar is optimistic and persists', () async {
    final c = _container({
      ..._routes(['a']),
      'POST /api/projects/a/toggle-star': <String, dynamic>{'isStarred': true},
    });
    await _loaded(c);
    await c.read(projectsProvider.notifier).toggleStar('a');
    expect(c.read(projectsProvider).projects.single.isStarred, isTrue);
    c.dispose();
  });

  test('toggleStar reloads list on failure', () async {
    final c = _container({
      ..._routes(['a']),
      'POST /api/projects/a/toggle-star': Exception('boom'),
    });
    await _loaded(c);
    await c.read(projectsProvider.notifier).toggleStar('a');
    expect(c.read(projectsProvider).projects.single.isStarred, isFalse);
    c.dispose();
  });

  test('archive removes project after server confirms', () async {
    var archived = false;
    final c = _container({
      'GET /api/projects': () => {
        'projects': [if (!archived) _project('a')],
      },
      'GET /api/projects/archived': <String, dynamic>{
        'success': true,
        'data': <String, dynamic>{'projects': <dynamic>[]},
      },
      'GET /api/projects/a/taskmaster': <String, dynamic>{
        'taskmaster': <String, dynamic>{},
      },
      'DELETE /api/projects/a': () {
        archived = true;
        return <String, dynamic>{};
      },
    });
    await _loaded(c);
    expect(await c.read(projectsProvider.notifier).archive('a'), isNull);
    expect(c.read(projectsProvider).projects, isEmpty);
    c.dispose();
  });
  group('CreateProjectDialog — wizard (T62.1)', () {
    testWidgets(
      'krok 1 wymaga ścieżki; krok 2 pokazuje review i tworzy projekt',
      (t) async {
        final sse = _FakeSse();
        var created = false;
        final routes = _screenRoutes()
          ..['POST /api/projects/create-project'] = () {
            created = true;
            return {'project': _project('new')};
          };
        await _openWizard(t, sse, routes);

        expect(find.text('Create New Project'), findsOneWidget);
        expect(find.text('Configure'), findsOneWidget);

        // Next bez ścieżki → walidacja
        await t.tap(find.text('Next'));
        await t.pump();
        expect(find.text('Please provide a workspace path'), findsOneWidget);

        await t.enterText(_fields.first, '/w/new');
        await t.tap(find.text('Next'));
        await t.pumpAndSettle();

        // Review step
        expect(find.text('Review Your Configuration'), findsOneWidget);
        expect(find.text('Path:'), findsOneWidget);
        expect(find.text('/w/new'), findsOneWidget);
        expect(
          find.textContaining('added to your project list'),
          findsOneWidget,
        );
        expect(find.text('Create Project'), findsOneWidget);

        await t.tap(find.text('Create Project'));
        await t.pumpAndSettle();
        expect(created, isTrue);
        expect(find.text('Create New Project'), findsNothing);
        expect(sse.calls, isEmpty); // no clone — plain create
      },
    );

    testWidgets(
      'GitHub URL → karta auth z stored-token picker i auto-selekcją',
      (t) async {
        final sse = _FakeSse()
          ..events = const [
            SseEvent(data: {'type': 'complete'}),
          ];
        final routes = _screenRoutes(
          tokens: [
            {'id': '7', 'credential_name': 'gh main', 'is_active': true},
            {'id': '8', 'credential_name': 'old', 'is_active': false},
          ],
        );
        await _openWizard(t, sse, routes);

        final fields = _fields;
        await t.enterText(fields.at(0), '/w/clone');
        await t.enterText(fields.at(2), 'https://github.com/org/repo');
        await t.pumpAndSettle();

        // Auth card with stored tokens — only the active one listed.
        expect(find.text('GitHub Authentication (Optional)'), findsOneWidget);
        expect(find.text('Stored Token'), findsOneWidget);
        expect(find.text('New Token'), findsOneWidget);
        expect(find.text('None (Public)'), findsOneWidget);
        expect(find.text('gh main'), findsOneWidget); // auto-selected
        expect(find.text('old'), findsNothing);

        await t.tap(find.text('Next'));
        await t.pumpAndSettle();
        expect(find.text('Clone From:'), findsOneWidget);
        expect(find.text('Authentication:'), findsOneWidget);
        expect(find.text('Using stored token: gh main'), findsOneWidget);

        await t.tap(find.text('Create Project'));
        await t.pumpAndSettle();
        expect(sse.calls, hasLength(1));
        expect(sse.calls.single!['githubTokenId'], '7');
        expect(sse.calls.single!['path'], '/w/clone');
        expect(find.text('Create New Project'), findsNothing);
      },
    );

    testWidgets('tryb New Token wysyła newGithubToken; ssh url pomija kartę', (
      t,
    ) async {
      final sse = _FakeSse()
        ..events = const [
          SseEvent(data: {'type': 'complete'}),
        ];
      final routes = _screenRoutes(
        tokens: [
          {'id': '7', 'credential_name': 'gh main', 'is_active': true},
        ],
      );
      await _openWizard(t, sse, routes);

      var fields = _fields;
      await t.enterText(fields.at(0), '/w/clone2');
      await t.enterText(fields.at(2), 'https://github.com/org/repo');
      await t.pumpAndSettle();

      await t.tap(find.text('New Token'));
      await t.pumpAndSettle();
      await t.enterText(_fields.last, 'ghp_secret');

      await t.tap(find.text('Next'));
      await t.pumpAndSettle();
      expect(find.text('Using provided token'), findsOneWidget);

      await t.tap(find.text('Create Project'));
      await t.pumpAndSettle();
      expect(sse.calls.single!['newGithubToken'], 'ghp_secret');
      expect(sse.calls.single!['githubTokenId'], isNull);

      // SSH URL — no auth card, review says 'SSH Key'.
      await t.tap(find.byTooltip('New project'));
      await t.pumpAndSettle();
      fields = _fields;
      await t.enterText(fields.at(0), '/w/ssh');
      await t.enterText(fields.at(2), 'git@github.com:org/repo.git');
      await t.pumpAndSettle();
      expect(find.text('GitHub Authentication (Optional)'), findsNothing);

      await t.tap(find.text('Next'));
      await t.pumpAndSettle();
      expect(find.text('SSH Key'), findsOneWidget);
    });

    testWidgets('brak tokenów → pole opcjonalne dla public repo', (t) async {
      final sse = _FakeSse();
      await _openWizard(t, sse, _screenRoutes());

      final fields = _fields;
      await t.enterText(fields.at(0), '/w/pub');
      await t.enterText(fields.at(2), 'https://github.com/org/repo');
      await t.pumpAndSettle();

      expect(find.textContaining('Public repositories'), findsOneWidget);
      expect(
        find.text('GitHub Token (Optional for Public Repos)'),
        findsOneWidget,
      );
      expect(find.text('Stored Token'), findsNothing);

      // Empty token → 'No authentication' in review.
      await t.tap(find.text('Next'));
      await t.pumpAndSettle();
      expect(find.text('No authentication'), findsOneWidget);
    });
  });
}

// ─── T62.1 — project-creation wizard (review step + stored token picker) ────

class _FakeSse extends SseClient {
  _FakeSse() : super(Dio());

  final calls = <Map<String, dynamic>?>[];
  List<SseEvent> events = const [];

  @override
  Stream<SseEvent> stream(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? body,
    String method = 'GET',
    CancelToken? cancelToken,
  }) async* {
    calls.add(queryParameters);
    for (final e in events) {
      yield e;
    }
  }
}

Map<String, dynamic> _screenRoutes({
  List<Map<String, dynamic>> tokens = const [],
}) => {
  'GET /api/projects': {'projects': <dynamic>[]},
  'GET /api/projects/archived': {
    'success': true,
    'data': {'projects': <dynamic>[]},
  },
  'GET /api/settings/credentials': {'credentials': tokens},
  'POST /api/projects/create-project': {'project': _project('new')},
};

Widget _screenApp(Map<String, dynamic> routes, _FakeSse sse) => ProviderScope(
  overrides: [
    dioProvider.overrideWithValue(_fakeDio(routes)),
    sseClientProvider.overrideWithValue(sse),
    chatChannelProvider.overrideWithValue(
      ChatChannel(WsClient(urlBuilder: () async => Uri.parse('ws://t'))),
    ),
  ],
  child: MaterialApp(theme: AppTheme.light(), home: const ProjectsScreen()),
);

Future<void> _openWizard(
  WidgetTester t,
  _FakeSse sse,
  Map<String, dynamic> routes,
) async {
  t.view.physicalSize = const Size(1100, 900);
  t.view.devicePixelRatio = 1;
  addTearDown(t.view.reset);
  await t.pumpWidget(_screenApp(routes, sse));
  await t.pumpAndSettle();
  await t.tap(find.byTooltip('New project'));
  await t.pumpAndSettle();
}

Finder get _fields =>
    find.descendant(of: find.byType(Dialog), matching: find.byType(TextField));
