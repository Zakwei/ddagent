import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/chat/state/composer_controller.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FakeWs extends WsClient {
  FakeWs() : super(urlBuilder: () async => Uri.parse('ws://t'));

  final sent = <Map<String, dynamic>>[];
  final _frames = StreamController<Map<String, dynamic>>.broadcast();
  final _states = StreamController<WsState>.broadcast();
  WsState _state = WsState.closed;

  @override
  Stream<Map<String, dynamic>> get frames => _frames.stream;
  @override
  Stream<WsState> get states => _states.stream;
  @override
  WsState get state => _state;

  @override
  void send(Map<String, dynamic> frame) {
    if (_state != WsState.open) throw StateError('WebSocket is not open');
    sent.add(frame);
  }

  void emitState(WsState s) {
    _state = s;
    _states.add(s);
  }

  @override
  Future<void> connect() async {}
  @override
  Future<void> close() async => _state = WsState.closed;
  @override
  Future<void> dispose() async {
    await _frames.close();
    await _states.close();
  }
}

void main() {
  late FakeWs ws;
  late ProviderContainer container;
  final posted = <Map<String, dynamic>>[];
  final requests = <String>[];

  const arg = (sessionId: 's1', projectId: 'p1', provider: 'claude', projectPath: '/p');

  Dio fakeDio() {
    final dio = Dio(BaseOptions(baseUrl: 'http://t'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          requests.add('${o.method} ${o.path}');
          if (o.method == 'POST') {
            posted.add({'path': o.path, 'data': o.data});
          }
          // A long provider turn holds send-now past Dio's receive timeout —
          // the request fails even though the server already dispatched.
          if (o.method == 'POST' && o.path.endsWith('/send-now')) {
            h.reject(DioException(requestOptions: o, type: DioExceptionType.receiveTimeout), true);
            return;
          }
          final data = switch (o.path) {
            '/api/providers/claude/models' => {
              'models': [
                {
                  'id': 'm1',
                  'label': 'M1',
                  'effort': {
                    'values': ['low', 'high'],
                  },
                },
              ],
            },
            '/api/providers/claude/sessions/s1/active-model' => {'id': 'm1'},
            '/api/provider-accounts' => {
              'accounts': [
                {'id': 'a1', 'provider': 'claude', 'label': 'Main'},
              ],
            },
            '/api/queue' when o.method == 'GET' => {'messages': const <Map<String, dynamic>>[]},
            '/api/commands/list' => {
              'builtIn': const <Map<String, dynamic>>[],
              'custom': [
                {
                  'name': '/clear',
                  'path': '/x/clear.md',
                  'description': 'Clear',
                  'namespace': 'project',
                },
              ],
            },
            _ => <String, dynamic>{},
          };
          h.resolve(Response(requestOptions: o, data: {'success': true, 'data': data}));
        },
      ),
    );
    return dio;
  }

  ProviderContainer make() => ProviderContainer(
    overrides: [
      dioProvider.overrideWithValue(fakeDio()),
      chatChannelProvider.overrideWithValue(ChatChannel(ws)..start()),
    ],
  );

  setUpAll(() async {
    Hive.init('/tmp/ddagent_composer_hive');
    await ChatStorage.init();
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
  });

  setUp(() {
    posted.clear();
    requests.clear();
    ws = FakeWs();
    ChatStorage.writeDraft(ChatStorage.draftKey(sessionId: 's1'), '');
    final prefs = Hive.box<dynamic>('settings');
    unawaited(prefs.delete('pinned_files_p1'));
    unawaited(prefs.delete('favorite_models_claude'));
  });

  tearDown(() => container.dispose());

  Future<void> pump() => Future<void>.delayed(const Duration(milliseconds: 100));

  test('loads models/accounts/commands; restores draft', () async {
    container = make();
    unawaited(ChatStorage.writeDraft(ChatStorage.draftKey(sessionId: 's1'), 'draft text'));
    container.listen(composerProvider(arg), (_, _) {});
    // Phase-2 (accounts/queue/slash) resolves after the phase-1 paint; poll
    // rather than a fixed pump so the test doesn't flake under suite load.
    for (var i = 0; i < 100; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      if (container.read(composerProvider(arg)).accounts.isNotEmpty) break;
    }
    final s = container.read(composerProvider(arg));
    expect(s.input, 'draft text');
    expect(s.models.single['id'], 'm1');
    expect(s.activeModel, 'm1');
    expect(s.accounts.single.id, 'a1');
    expect(s.slashCommands.single['name'], '/clear');
    expect(s.effortValues('claude'), ['low', 'high']);
  });

  test('send builds options (model/effort/permission/account) and clears draft', () async {
    container = make();
    container.listen(composerProvider(arg), (_, _) {});
    ws.emitState(WsState.open);
    await pump();
    final c = container.read(composerProvider(arg).notifier);
    c
      ..selectAccount('a1')
      ..selectPermissionMode('plan')
      ..setInput('hello');
    await c.selectEffort('high');
    await c.send();
    final frame = ws.sent.last;
    expect(frame['type'], 'chat.send');
    expect(frame['sessionId'], 's1');
    expect(frame['options'], {
      'model': 'm1',
      'effort': 'high',
      'permissionMode': 'plan',
      'language': 'en',
      'accountId': 'a1',
    });
    expect(container.read(composerProvider(arg)).input, '');
    expect(ChatStorage.readDraft(ChatStorage.draftKey(sessionId: 's1')), '');
    // set-permission-mode went out over WS
    expect(ws.sent.any((f) => f['type'] == 'chat.set-permission-mode'), isTrue);
  });

  test('send while running enqueues into the server queue', () async {
    container = make();
    container.listen(composerProvider(arg), (_, _) {});
    await pump();
    final c = container.read(composerProvider(arg).notifier)..setInput('queued msg');
    await c.send(running: true);
    final post = posted.firstWhere((p) => p['path'] == '/api/queue');
    expect((post['data'] as Map)['sessionId'], 's1');
    expect((post['data'] as Map)['content'], 'queued msg');
  });

  test('sendNow refreshes the queue even when the request times out', () async {
    container = make();
    container.listen(composerProvider(arg), (_, _) {});
    await pump();
    // Must not throw out of the button handler, and must still re-read the
    // queue afterwards so the card does not look frozen.
    await container.read(composerProvider(arg).notifier).sendNow('7');
    expect(requests, contains('POST /api/queue/7/send-now'));
    final at = requests.indexOf('POST /api/queue/7/send-now');
    expect(requests.sublist(at), contains('GET /api/queue'));
  });

  test('abort without a known run does not send an unscoped Stop', () async {
    container = make();
    ws.emitState(WsState.open);
    await pump();
    container.read(chatChannelProvider).abort('s1');
    expect(ws.sent.where((frame) => frame['type'] == 'chat.abort'), isEmpty);
  });

  test('abort forwards chat.abort; pinned files prefix the content', () async {
    container = make();
    container.listen(composerProvider(arg), (_, _) {});
    ws.emitState(WsState.open);
    await pump();
    final c = container.read(composerProvider(arg).notifier)
      ..pinFile('lib/a.dart')
      ..setInput('check it');
    await c.send();
    expect(ws.sent.last['content'], 'Pinned files:\n- lib/a.dart\n\ncheck it');
    ws._frames.add({'kind': 'status', 'sessionId': 's1', 'runId': 'run-1', 'seq': 1});
    await pump();
    c.abort();
    expect(ws.sent.last['type'], 'chat.abort');
    expect(ws.sent.last['runId'], 'run-1');
  });
}
