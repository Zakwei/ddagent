import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
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

Map<String, dynamic> _msg(String id, String kind, {String? content, int seq = 0}) => {
  'id': id,
  'kind': kind,
  'role': kind == 'text' ? 'assistant' : null,
  'content': ?content,
  'timestamp': '2025-01-01T00:00:${seq.toString().padLeft(2, '0')}',
  'provider': 'claude',
};

/// Real envelope: {success, data:{messages,total,hasMore,offset,limit}}.
Map<String, dynamic> _page(List<Map<String, dynamic>> msgs, {bool hasMore = false}) => {
  'success': true,
  'data': {'messages': msgs, 'total': msgs.length + (hasMore ? 100 : 0), 'hasMore': hasMore},
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
    Hive.init('/tmp/ddagent_test_hive');
    await ChatStorage.init();
  });

  setUp(() {
    ws = FakeWs();
    channel = ChatChannel(ws)..start();
    ChatStorage.writeOfflineQueue('p1', const []);
  });

  tearDown(() => container.dispose());

  Future<void> pump() => Future<void>.delayed(const Duration(milliseconds: 100));

  test('initial load applies latest page; subscribes to the session', () async {
    container = make({
      'GET /api/providers/sessions/s1/messages': _page([
        _msg('m1', 'text', content: 'hello', seq: 1),
        _msg('m2', 'text', content: 'world', seq: 2),
      ]),
    });
    ws.emitState(WsState.open);
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();
    final msgs = container.read(sessionMessagesProvider('s1'));
    expect(msgs.map((m) => m.id), ['m1', 'm2']);
    expect(ws.sent.last['type'], 'chat.subscribe');
    expect(
      container.read(transcriptProvider('s1')).loading,
      isFalse,
    );
  });

  test('tail-walks older pages until 2 text rows', () async {
    var calls = 0;
    container = make({
      'GET /api/providers/sessions/s1/messages': (RequestOptions o) {
        calls++;
        final offset = (o.queryParameters['offset'] as num?)?.toInt() ?? 0;
        if (offset == 0) {
          return _page([_msg('t1', 'tool_use')], hasMore: true);
        }
        return _page([_msg('u1', 'text', content: 'a'), _msg('u2', 'text', content: 'b')]);
      },
    });
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();
    expect(calls, 2);
    expect(container.read(sessionMessagesProvider('s1')).map((m) => m.id), ['u1', 'u2', 't1']);
  });

  test('stream deltas merge into one live row; complete finalizes', () async {
    container = make({'GET /api/providers/sessions/s1/messages': _page(const [])});
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();
    ws.emitFrame({'kind': 'stream_delta', 'sessionId': 's1', 'content': 'hel'});
    ws.emitFrame({'kind': 'stream_delta', 'sessionId': 's1', 'content': 'lo'});
    for (var i = 0; i < 15 && container.read(sessionMessagesProvider('s1')).isEmpty; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    var msgs = container.read(sessionMessagesProvider('s1'));
    expect(msgs.single.kind, 'stream_delta');
    expect(msgs.single.content, 'hello');
    ws.emitFrame({'kind': 'complete', 'sessionId': 's1'});
    await pump();
    msgs = container.read(sessionMessagesProvider('s1'));
    expect(msgs.first.kind, 'text');
    expect(msgs.first.role, 'assistant');
    expect(
      container.read(transcriptProvider('s1')).runStatus,
      'done',
    );
  });

  test('thought_delta lands in the thinking row; error sets status', () async {
    container = make({'GET /api/providers/sessions/s1/messages': _page(const [])});
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();
    ws.emitFrame({'kind': 'thought_delta', 'sessionId': 's1', 'content': 'hmm'});
    for (var i = 0; i < 15 && container.read(sessionMessagesProvider('s1')).isEmpty; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    expect(container.read(sessionMessagesProvider('s1')).single.kind, 'thinking');
    ws.emitFrame({'kind': 'error', 'sessionId': 's1', 'content': 'boom', 'id': 'e1'});
    await pump();
    expect(
      container.read(transcriptProvider('s1')).runStatus,
      'error',
    );
  });

  test('frames for other sessions are ignored; send echoes optimistically', () async {
    container = make({'GET /api/providers/sessions/s1/messages': _page(const [])});
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();
    ws.emitFrame({'kind': 'text', 'sessionId': 'other', 'id': 'x', 'content': 'no'});
    await pump();
    expect(container.read(sessionMessagesProvider('s1')), isEmpty);
    ws.emitState(WsState.open);
    container
        .read(transcriptProvider('s1').notifier)
        .send('hi');
    expect(ws.sent.last['type'], 'chat.send');
    final msgs = container.read(sessionMessagesProvider('s1'));
    expect(msgs.single.isLocalEcho, isTrue);
  });

  test('loadOlder prepends the previous page', () async {
    container = make({
      'GET /api/providers/sessions/s1/messages': (RequestOptions o) {
        final offset = (o.queryParameters['offset'] as num?)?.toInt() ?? 0;
        if (offset == 0) {
          return _page([
            _msg('t', 'text', content: 'a'),
            _msg('t2', 'text', content: 'b'),
          ], hasMore: true);
        }
        return _page([_msg('old', 'text', content: 'older')]);
      },
    });
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();
    await container
        .read(transcriptProvider('s1').notifier)
        .loadOlder();
    expect(container.read(sessionMessagesProvider('s1')).first.id, 'old');
  });

  test('send while offline queues; reconnect flushes queued frames', () async {
    container = make({
      'GET /api/providers/sessions/s1/messages': _page(const []),
      // The offline queue is keyed by projectId, which the controller now
      // resolves from the session row instead of taking as an argument.
      'GET /api/providers/sessions/s1': {
        'session': {'id': 's1', 'projectId': 'p1'},
      },
    });
    container.listen(transcriptProvider('s1'), (_, _) {});
    container.listen(sessionDetailsProvider('s1'), (_, _) {});
    await pump();
    container
        .read(transcriptProvider('s1').notifier)
        .send('hi offline');
    expect(ws.sent, isEmpty);
    final queued = ChatStorage.readOfflineQueue('p1');
    expect(queued.single['content'], 'hi offline');
    expect(queued.single['sessionId'], 's1');
    ws.emitState(WsState.open);
    await pump();
    expect(ws.sent.last['type'], 'chat.send');
    expect(ws.sent.last['content'], 'hi offline');
    expect(ChatStorage.readOfflineQueue('p1'), isEmpty);
  });
}
