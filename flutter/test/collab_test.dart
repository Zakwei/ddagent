import 'dart:async';

import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/collab/role.dart';
import 'package:ddagent_app/features/collab/state/presence_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory /ws stand-in: records outbound frames and lets the test drive
/// inbound frames and connection state.
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
  void send(Map<String, dynamic> frame) => sent.add(frame);

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

void main() {
  test('roleAtLeast ranks viewer < member < owner', () {
    expect(roleAtLeast('owner', 'member'), isTrue);
    expect(roleAtLeast('member', 'owner'), isFalse);
    expect(roleAtLeast('viewer', 'viewer'), isTrue);
    expect(roleAtLeast(null, 'viewer'), isFalse);
    expect(roleAtLeast('bogus', 'viewer'), isFalse);
  });

  group('presence', () {
    late FakeWs ws;
    late ChatChannel channel;
    late ProviderContainer container;

    setUp(() {
      ws = FakeWs();
      channel = ChatChannel(ws)..start();
      container = ProviderContainer(overrides: [chatChannelProvider.overrideWithValue(channel)]);
    });

    tearDown(() => container.dispose());

    test('announces viewing on open, clears on dispose', () async {
      final sub = container.listen(presenceProvider((kind: 'board', id: 'p1')), (_, _) {});
      sub.read();
      ws.emitState(WsState.open);
      await Future<void>.delayed(Duration.zero);
      expect(ws.sent.last, {
        'type': 'presence',
        'viewing': {'kind': 'board', 'id': 'p1'},
      });
      container.dispose();
      expect(ws.sent.last, {'type': 'presence'});
    });

    test('presence-roster broadcast updates the roster', () async {
      final sub = container.listen(presenceProvider((kind: 'board', id: 'p1')), (_, _) {});
      sub.read();
      ws.emitState(WsState.open);
      ws.emitFrame({
        'kind': 'presence-roster',
        'users': [
          {
            'userId': 1,
            'username': 'ann',
            'viewing': {'kind': 'board', 'id': 'p1'},
          },
          {'userId': 2, 'username': 'bob', 'viewing': null},
          {'bogus': true},
        ],
      });
      await Future<void>.delayed(Duration.zero);
      final roster = container.read(presenceProvider((kind: 'board', id: 'p1')));
      expect(roster.map((e) => e.username), ['ann', 'bob']);
      expect(roster.first.viewing, (kind: 'board', id: 'p1'));
      expect(roster[1].viewing, isNull);
    });

    test('disconnect clears the stale roster; reconnect re-announces', () async {
      final sub = container.listen(presenceProvider((kind: 'session', id: 's1')), (_, _) {});
      sub.read();
      ws.emitState(WsState.open);
      ws.emitFrame({
        'kind': 'presence-roster',
        'users': [
          {'userId': 1, 'username': 'ann'},
        ],
      });
      await Future<void>.delayed(Duration.zero);
      expect(container.read(presenceProvider((kind: 'session', id: 's1'))), hasLength(1));
      ws.emitState(WsState.reconnecting);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(presenceProvider((kind: 'session', id: 's1'))), isEmpty);
      ws.emitState(WsState.open);
      await Future<void>.delayed(Duration.zero);
      expect(ws.sent.last['viewing'], {'kind': 'session', 'id': 's1'});
    });
  });
}
