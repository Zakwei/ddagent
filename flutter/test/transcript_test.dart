import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/state/activity_poller.dart';
import 'package:ddagent_app/features/sessions/state/session_activity.dart';
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
    expect(container.read(transcriptProvider('s1')).loading, isFalse);
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
    expect(container.read(transcriptProvider('s1')).runStatus, 'done');
  });

  test('activity: status marks processing, complete marks idle, ack seeds it', () async {
    container = make({'GET /api/providers/sessions/s1/messages': _page(const [])});
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();
    expect(container.read(sessionActivityProvider).containsKey('s1'), isFalse);

    // A live `status` frame flips the session into the processing map — this
    // is what drives the activity pill above the composer.
    ws.emitFrame({'kind': 'status', 'sessionId': 's1'});
    await pump();
    expect(container.read(sessionActivityProvider)['s1'], isNotNull);

    ws.emitFrame({'kind': 'complete', 'sessionId': 's1'});
    await pump();
    expect(container.read(sessionActivityProvider).containsKey('s1'), isFalse);
  });

  test('activity: subscribe ack seeds processing after a reload', () async {
    container = make({'GET /api/providers/sessions/s1/messages': _page(const [])});
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();
    // No live frame was observed — the ack is the only signal.
    ws.emitFrame({
      'kind': 'chat_subscribed',
      'sessionId': 's1',
      'isProcessing': true,
      'startedAt': 12345,
    });
    await pump();
    final entry = container.read(sessionActivityProvider)['s1'];
    expect(entry, isNotNull);
    // The elapsed timer anchors on the server's run start, not the ack's
    // arrival — otherwise a reload mid-run would reset the displayed time.
    expect(entry!.startedAt, 12345);
  });

  test('activity: stream_end and error are not terminal — only complete is', () async {
    container = make({'GET /api/providers/sessions/s1/messages': _page(const [])});
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();
    ws.emitFrame({'kind': 'status', 'sessionId': 's1'});
    await pump();
    expect(container.read(sessionActivityProvider).containsKey('s1'), isTrue);
    final startedAt = container.read(sessionActivityProvider)['s1']!.startedAt;

    // Providers emit stream_end at every message boundary (before each
    // tool call, between continuation rounds) — the run continues and the
    // pill must not flicker or restart its timer.
    ws.emitFrame({'kind': 'stream_end', 'sessionId': 's1'});
    await pump();
    final entry = container.read(sessionActivityProvider)['s1'];
    expect(entry, isNotNull);
    expect(entry!.startedAt, startedAt);
    expect(container.read(transcriptProvider('s1')).runStatus, 'running');

    // Mid-run error rows (stderr noise, failed tool output) are
    // informational — they neither idle the session nor flip the composer.
    ws.emitFrame({'kind': 'error', 'sessionId': 's1', 'content': 'stderr noise', 'id': 'e1'});
    await pump();
    expect(container.read(sessionActivityProvider).containsKey('s1'), isTrue);
    expect(container.read(transcriptProvider('s1')).runStatus, 'running');

    ws.emitFrame({'kind': 'complete', 'sessionId': 's1'});
    await pump();
    expect(container.read(sessionActivityProvider).containsKey('s1'), isFalse);
    expect(container.read(transcriptProvider('s1')).runStatus, 'done');
  });

  test('activity: work frames re-arm the map after an idle gap', () async {
    container = make({'GET /api/providers/sessions/s1/messages': _page(const [])});
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();
    ws.emitFrame({'kind': 'status', 'sessionId': 's1'});
    await pump();
    expect(container.read(sessionActivityProvider).containsKey('s1'), isTrue);
    ws.emitFrame({'kind': 'complete', 'sessionId': 's1'});
    await pump();
    expect(container.read(sessionActivityProvider).containsKey('s1'), isFalse);
    // A tool_use frame arriving afterwards (e.g. a replayed run on a freshly
    // subscribed pane) re-arms the indicator — it is live work.
    ws.emitFrame({
      'kind': 'tool_use',
      'sessionId': 's1',
      'toolName': 'Read',
      'toolInput': {'file_path': '/x/a.ts'},
      'id': 't1',
    });
    await pump();
    expect(container.read(sessionActivityProvider).containsKey('s1'), isTrue);
  });

  test('activity: protocol_error settles idle without a phantom row', () async {
    container = make({'GET /api/providers/sessions/s1/messages': _page(const [])});
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();
    ws.emitFrame({'kind': 'status', 'sessionId': 's1'});
    await pump();
    ws.emitFrame({
      'kind': 'protocol_error',
      'sessionId': 's1',
      'code': 'NO_ACTIVE_RUN',
      'error': 'no active run',
    });
    await pump();
    expect(container.read(sessionActivityProvider).containsKey('s1'), isFalse);
    // NO_ACTIVE_RUN is the benign abort race — no error row lands.
    expect(container.read(sessionMessagesProvider('s1')), isEmpty);
  });

  test('activity: global listener settles sessions with no open transcript', () async {
    container = make({
      'GET /api/providers/sessions/running': {
        'success': true,
        'data': {'sessions': <dynamic>[]},
      },
    });
    container.listen(activityPollerProvider, (_, _) {});
    await pump();
    container.read(sessionActivityProvider.notifier).markProcessing('s9');
    expect(container.read(sessionActivityProvider).containsKey('s9'), isTrue);
    // The pane for s9 is closed, so no transcript controller sees this
    // frame — the channel-level listener must still settle the map.
    ws.emitFrame({'kind': 'complete', 'sessionId': 's9'});
    await pump();
    expect(container.read(sessionActivityProvider).containsKey('s9'), isFalse);
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
    // An error row on an idle session surfaces the error state; mid-run
    // errors keep 'running' (covered by the stream_end test above).
    ws.emitFrame({'kind': 'complete', 'sessionId': 's1'});
    await pump();
    ws.emitFrame({'kind': 'error', 'sessionId': 's1', 'content': 'boom', 'id': 'e1'});
    await pump();
    expect(container.read(transcriptProvider('s1')).runStatus, 'error');
  });

  test('frames for other sessions are ignored; send echoes optimistically', () async {
    container = make({'GET /api/providers/sessions/s1/messages': _page(const [])});
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();
    ws.emitFrame({'kind': 'text', 'sessionId': 'other', 'id': 'x', 'content': 'no'});
    await pump();
    expect(container.read(sessionMessagesProvider('s1')), isEmpty);
    ws.emitState(WsState.open);
    container.read(transcriptProvider('s1').notifier).send('hi');
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
    await container.read(transcriptProvider('s1').notifier).loadOlder();
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
    container.read(transcriptProvider('s1').notifier).send('hi offline');
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

  test('loadAll pulls every remaining page in one go', () async {
    container = make({
      'GET /api/providers/sessions/s1/messages': (RequestOptions o) {
        final offset = (o.queryParameters['offset'] as num?)?.toInt() ?? 0;
        if (offset == 0) {
          // Two text rows up front so initial load doesn't tail-walk.
          return _page([
            _msg('n1', 'text', content: 'a'),
            _msg('n2', 'text', content: 'b'),
          ], hasMore: true);
        }
        if (offset == 2) {
          return _page([_msg('o1', 'text', content: 'c')], hasMore: true);
        }
        return _page([_msg('o2', 'text', content: 'd')]);
      },
    });
    container.listen(transcriptProvider('s1'), (_, _) {});
    await pump();
    await container.read(transcriptProvider('s1').notifier).loadAll();
    expect(container.read(sessionMessagesProvider('s1')).map((m) => m.id), [
      'o2',
      'o1',
      'n1',
      'n2',
    ]);
    expect(container.read(transcriptProvider('s1')).allLoaded, isTrue);
  });

  test('offline queue count surfaces after project resolves; clear drops it', () async {
    await ChatStorage.writeOfflineQueue('p1', const [
      {'sessionId': 's1', 'content': 'parked'},
      {'sessionId': 'other', 'content': 'not mine'},
    ]);
    container = make({
      'GET /api/providers/sessions/s1/messages': _page(const []),
      'GET /api/providers/sessions/s1': {
        'session': {'id': 's1', 'projectId': 'p1'},
      },
    });
    container.listen(transcriptProvider('s1'), (_, _) {});
    container.listen(sessionDetailsProvider('s1'), (_, _) {});
    await pump();
    expect(container.read(transcriptProvider('s1')).offlineCount, 1);
    await container.read(transcriptProvider('s1').notifier).clearOfflineQueue();
    expect(container.read(transcriptProvider('s1')).offlineCount, 0);
    // Other sessions' entries survive the clear.
    expect(ChatStorage.readOfflineQueue('p1').single['sessionId'], 'other');
  });
}
