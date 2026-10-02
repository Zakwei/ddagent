import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
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

  void emitFrame(Map<String, dynamic> f) => _frames.add(f);
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

Dio _fakeDio(Map<String, dynamic> routes) {
  final dio = Dio(BaseOptions(baseUrl: 'http://t'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (o, h) {
        var res = routes['${o.method} ${o.path}'];
        if (res is Function) res = res(o);
        h.resolve(Response(requestOptions: o, data: res));
      },
    ),
  );
  return dio;
}

Map<String, dynamic> _page(List<Map<String, dynamic>> msgs) => {
  'success': true,
  'data': {'messages': msgs, 'total': msgs.length, 'hasMore': false},
};

Map<String, dynamic> _userEcho(String id, String content, int seq) => {
  'id': id,
  'kind': 'text',
  'role': 'user',
  'content': content,
  'sessionId': 's1',
  'timestamp': DateTime.now().toUtc().toIso8601String(),
  'provider': 'devin',
  'seq': seq,
  'runId': 'r1',
};

void main() {
  late FakeWs ws;
  late ChatChannel channel;
  late ProviderContainer container;

  ProviderContainer make(Map<String, dynamic> routes) => ProviderContainer(
    overrides: [
      dioProvider.overrideWithValue(_fakeDio(routes)),
      chatChannelProvider.overrideWithValue(channel),
    ],
  );

  setUpAll(() async {
    Hive.init('/tmp/ddagent_repro_hive');
    await ChatStorage.init();
  });
  setUp(() {
    ws = FakeWs();
    channel = ChatChannel(ws)..start();
    ChatStorage.writeOfflineQueue('p1', const []);
  });
  tearDown(() => container.dispose());

  Future<void> pump() =>
      Future<void>.delayed(const Duration(milliseconds: 120));

  List<String> dump() => [
    for (final m in container.read(sessionMessagesProvider('s1')))
      '${m.id}:${m.kind}:${m.role}',
  ];

  test('send + devin user echo collapses to one row', () async {
    container = make({
      'GET /api/providers/sessions/s1/messages': _page(const []),
    });
    ws.emitState(WsState.open);
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();

    container.read(transcriptProvider('s1').notifier).send('hello world');
    await pump();
    print('after send: ${dump()}');

    ws.emitFrame(_userEcho('text_srv1', 'hello world', 1));
    await pump();
    print('after echo: ${dump()}');
    expect(
      container
          .read(sessionMessagesProvider('s1'))
          .where((m) => m.isUserText)
          .length,
      1,
    );
  });

  test('identical re-send inside the guard window is suppressed', () async {
    container = make({
      'GET /api/providers/sessions/s1/messages': _page(const []),
    });
    ws.emitState(WsState.open);
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();

    final ctrl = container.read(transcriptProvider('s1').notifier);
    ctrl.send('hello world');
    ctrl.send('hello world'); // double-fire — same text, same window
    await pump();
    ws.emitFrame(_userEcho('text_srv1', 'hello world', 1));
    await pump();
    print('double-send result: ${dump()}');
    final userRows = container
        .read(sessionMessagesProvider('s1'))
        .where((m) => m.isUserText)
        .length;
    expect(userRows, 1, reason: 'second identical send must not add a row');
    expect(
      ws.sent.where((f) => f['type'] == 'chat.send').length,
      1,
      reason: 'second identical send must not dispatch another frame',
    );
  });

  test('different text re-send inside the window still sends', () async {
    container = make({
      'GET /api/providers/sessions/s1/messages': _page(const []),
    });
    ws.emitState(WsState.open);
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();

    final ctrl = container.read(transcriptProvider('s1').notifier);
    ctrl.send('hello world');
    ctrl.send('a different follow-up');
    await pump();
    expect(
      ws.sent.where((f) => f['type'] == 'chat.send').length,
      2,
      reason: 'distinct prompts are real turns, not double-fires',
    );
  });

  test('complete refetch reclaims an orphan local echo', () async {
    var persisted = false;
    container = make({
      'GET /api/providers/sessions/s1/messages': (RequestOptions _) {
        return _page(
          persisted
              ? [
                  {
                    'id': 'text_srv1',
                    'kind': 'text',
                    'role': 'user',
                    'content': 'hello world',
                    'timestamp': DateTime.now().toUtc().toIso8601String(),
                    'provider': 'devin',
                  },
                ]
              : const [],
        );
      },
    });
    ws.emitState(WsState.open);
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();

    container.read(transcriptProvider('s1').notifier).send('hello world');
    // Simulate any earlier glitch that left a second optimistic row — the
    // pre-fix double-send path that produced the visible duplicate.
    container
        .read(sessionMessageStoreProvider.notifier)
        .appendLocalEcho('s1', 'hello world', 'devin');
    ws.emitFrame(_userEcho('text_srv1', 'hello world', 1));
    await pump();
    expect(
      container
          .read(sessionMessagesProvider('s1'))
          .where((m) => m.isUserText)
          .length,
      2,
      reason: 'precondition: orphan local survives mid-run',
    );

    persisted = true;
    ws.emitFrame({
      'kind': 'complete',
      'sessionId': 's1',
      'runId': 'r1',
      'seq': 9,
      'success': true,
    });
    await pump();
    print('after complete: ${dump()}');
    expect(
      container
          .read(sessionMessagesProvider('s1'))
          .where((m) => m.isUserText)
          .length,
      1,
      reason: 'the persisted tail must reclaim the orphan echo on complete',
    );
  });

  test(
    'send → REST page lands WITH persisted row → echo → still one?',
    () async {
      var sent = false;
      container = make({
        'GET /api/providers/sessions/s1/messages': (RequestOptions o) {
          // History read resolves AFTER the send — by then the row is
          // persisted server-side, so the page carries it.
          return _page(
            sent
                ? [
                    {
                      'id': 'text_srv1',
                      'kind': 'text',
                      'role': 'user',
                      'content': 'hello world',
                      'timestamp': DateTime.now().toUtc().toIso8601String(),
                      'provider': 'devin',
                    },
                  ]
                : const [],
          );
        },
      });
      ws.emitState(WsState.open);
      container.listen(transcriptProvider('s1'), (_, _) {});
      // send BEFORE loadInitial resolves
      container.read(transcriptProvider('s1').notifier).send('hello world');
      sent = true;
      await pump();
      print('send+late REST: ${dump()}');
      ws.emitFrame(_userEcho('text_srv1', 'hello world', 1));
      await pump();
      print('after echo: ${dump()}');
      final n = container
          .read(sessionMessagesProvider('s1'))
          .where((m) => m.isUserText)
          .length;
      print('user rows: $n');
      expect(n, 1);
    },
  );

  test('reconnect replay re-emits same echo — still one', () async {
    container = make({
      'GET /api/providers/sessions/s1/messages': _page(const []),
    });
    ws.emitState(WsState.open);
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();
    container.read(transcriptProvider('s1').notifier).send('hello world');
    ws.emitFrame(_userEcho('text_srv1', 'hello world', 1));
    await pump();
    print('before reconnect: ${dump()}');
    // Reconnect → resubscribe → server replays the run (same ids/seqs).
    ws.emitState(WsState.reconnecting);
    ws.emitState(WsState.open);
    ws.emitFrame(_userEcho('text_srv1', 'hello world', 1));
    await pump();
    print('after replay: ${dump()}');
    final n = container
        .read(sessionMessagesProvider('s1'))
        .where((m) => m.isUserText)
        .length;
    print('user rows: $n');
    expect(n, 1);
  });

  test(
    'new run subscribe ack reseeds cursor → full replay of old run user turn',
    () async {
      container = make({
        'GET /api/providers/sessions/s1/messages': _page(const []),
      });
      ws.emitState(WsState.open);
      container.listen(transcriptProvider('s1'), (_, _) {});
      await pump();
      // subscribe ack for run r1 then live frames
      ws.emitFrame({
        'kind': 'chat_subscribed',
        'sessionId': 's1',
        'runId': 'r1',
      });
      container.read(transcriptProvider('s1').notifier).send('hello world');
      ws.emitFrame(_userEcho('text_srv1', 'hello world', 1));
      await pump();
      print('mid-run: ${dump()}');
      // Pane re-subscribes (provider rebuild): ack reseeds cursor → replay
      // of seq>0 for run r1 → userTurn again with same id.
      channel.subscribe(['s1']);
      ws.emitFrame({
        'kind': 'chat_subscribed',
        'sessionId': 's1',
        'runId': 'r1',
      });
      ws.emitFrame(_userEcho('text_srv1', 'hello world', 1));
      await pump();
      print('after resub+replay: ${dump()}');
      final n = container
          .read(sessionMessagesProvider('s1'))
          .where((m) => m.isUserText)
          .length;
      print('user rows: $n');
      expect(n, 1);
    },
  );
}
