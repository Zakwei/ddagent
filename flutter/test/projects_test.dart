import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:dio/dio.dart';
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

Map<String, dynamic> _routes(List<String> ids, {List<String> archived = const []}) => {
  'GET /api/projects': {
    'projects': [for (final id in ids) _project(id)],
  },
  'GET /api/projects/archived': {
    'projects': [for (final id in archived) _project(id)],
  },
  for (final id in ids) 'GET /api/projects/$id/taskmaster': {'taskmaster': <String, dynamic>{}},
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
      'GET /api/projects/archived': <String, dynamic>{'projects': <dynamic>[]},
      'GET /api/projects/a/taskmaster': <String, dynamic>{'taskmaster': <String, dynamic>{}},
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
}
