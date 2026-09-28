import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Dio _fakeDio(Map<String, dynamic> routes) {
  final dio = Dio(BaseOptions(baseUrl: 'http://t'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (o, h) {
        var res = routes['${o.method} ${o.path}'];
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

Map<String, dynamic> _session(String id, {String? projectId, Map<String, dynamic>? extra}) => {
  'id': id,
  'summary': 'Session $id',
  'provider': 'claude',
  ?'projectId': projectId,
  ...?extra,
};

ProviderContainer _container(Map<String, dynamic> routes) {
  final c = ProviderContainer(
    overrides: [
      dioProvider.overrideWithValue(_fakeDio(routes)),
      chatChannelProvider.overrideWithValue(
        ChatChannel(WsClient(urlBuilder: () async => Uri.parse('ws://t'))),
      ),
    ],
  );
  addTearDown(c.dispose);
  return c;
}

Future<void> _loaded(ProviderContainer c, (String?, String?) scope) async {
  c.listen(sessionsProvider(scope), (_, _) {});
  for (var i = 0; i < 500; i++) {
    if (!c.read(sessionsProvider(scope)).loading) return;
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }
  throw StateError('sessions never loaded');
}

void main() {
  test('loads project-scoped sessions', () async {
    final c = _container({
      'GET /api/projects/p1/sessions': {
        'sessions': [_session('s1'), _session('s2')],
        'sessionMeta': {'total': 2, 'hasMore': false},
      },
    });
    await _loaded(c, ('p1', null));
    expect(c.read(sessionsProvider(('p1', null))).sessions.map((s) => s.sessionId), ['s1', 's2']);
  });

  test('global scope falls back to recent()', () async {
    final c = _container({
      'GET /api/providers/sessions/recent': {
        'sessions': [_session('r1')],
      },
    });
    await _loaded(c, (null, null));
    expect(c.read(sessionsProvider((null, null))).sessions.single.sessionId, 'r1');
  });

  test('archived list is scoped back to the project', () async {
    final c = _container({
      'GET /api/projects/p1/sessions': {
        'sessions': [_session('s1', projectId: 'p1')],
      },
      'GET /api/providers/sessions/archived': {
        'sessions': [_session('a1', projectId: 'p1'), _session('a2', projectId: 'p2')],
      },
    });
    await _loaded(c, ('p1', null));
    await c.read(sessionsProvider(('p1', null)).notifier).toggleArchived();
    expect(c.read(sessionsProvider(('p1', null))).sessions.map((s) => s.sessionId), ['a1']);
  });

  test('rename is optimistic, rolls back on failure', () async {
    final c = _container({
      'GET /api/projects/p1/sessions': {
        'sessions': [_session('s1')],
      },
      'PUT /api/providers/sessions/s1': Exception('boom'),
    });
    await _loaded(c, ('p1', null));
    final err = await c.read(sessionsProvider(('p1', null)).notifier).rename('s1', 'New name');
    expect(err, isNotNull);
    // Reload after failure restores server state.
    expect(c.read(sessionsProvider(('p1', null))).sessions.single.displayTitle, 'Session s1');
  });

  test('delete removes the session after confirm', () async {
    var deleted = false;
    final c = _container({
      'GET /api/projects/p1/sessions': () => {
        'sessions': [if (!deleted) _session('s1')],
      },
      'DELETE /api/providers/sessions/s1': () {
        deleted = true;
        return <String, dynamic>{};
      },
    });
    await _loaded(c, ('p1', null));
    expect(await c.read(sessionsProvider(('p1', null)).notifier).hardDelete('s1'), isNull);
    expect(c.read(sessionsProvider(('p1', null))).sessions, isEmpty);
  });

  test('isUnread follows lastViewedAt vs lastActivity', () {
    Session mk(Map<String, dynamic> extra) => Session.fromApi(_session('s', extra: extra));
    expect(mk({'lastActivity': '2024-01-02T00:00:00Z'}).isUnread, isTrue);
    expect(
      mk({'lastActivity': '2024-01-02T00:00:00Z', 'lastViewedAt': '2024-01-03T00:00:00Z'}).isUnread,
      isFalse,
    );
    expect(
      mk({'lastActivity': '2024-01-02T00:00:00Z', 'lastViewedAt': '2024-01-01T00:00:00Z'}).isUnread,
      isTrue,
    );
    expect(
      mk({'lastActivity': '2024-01-02T00:00:00Z', 'lastViewedAt': null, 'isRunning': true})
          .isUnread,
      isFalse,
    );
  });
}
