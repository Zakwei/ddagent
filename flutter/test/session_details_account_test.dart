import 'dart:async';

import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeWs extends WsClient {
  _FakeWs() : super(urlBuilder: () async => Uri.parse('ws://t'));

  final _frames = StreamController<Map<String, dynamic>>.broadcast();
  final _states = StreamController<WsState>.broadcast();

  @override
  Stream<Map<String, dynamic>> get frames => _frames.stream;
  @override
  Stream<WsState> get states => _states.stream;
  @override
  WsState get state => WsState.open;
  @override
  void send(Map<String, dynamic> frame) {}
  @override
  Future<void> connect() async {}
  @override
  Future<void> close() async {}
  @override
  Future<void> dispose() async {
    await _frames.close();
    await _states.close();
  }

  void emitFrame(Map<String, dynamic> f) => _frames.add(f);
}

/// Serves the session row with whatever account the server has it on now.
class _FakeSessions extends SessionsRepository {
  _FakeSessions() : super(Dio());

  String accountId = 'acc-1';
  int loads = 0;

  @override
  Future<Session> details(String sessionId) async {
    loads++;
    return Session.fromApi({'id': sessionId, 'provider': 'claude', 'accountId': accountId});
  }
}

void main() {
  test('session details follow a limit auto-switch to another account', () async {
    final ws = _FakeWs();
    final channel = ChatChannel(ws)..start();
    final sessions = _FakeSessions();
    final container = ProviderContainer(
      overrides: [
        chatChannelProvider.overrideWithValue(channel),
        sessionsRepositoryProvider.overrideWithValue(sessions),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await ws.dispose();
    });
    final sub = container.listen(sessionDetailsProvider('s1'), (_, _) {});
    addTearDown(sub.close);

    expect((await container.read(sessionDetailsProvider('s1').future)).raw['accountId'], 'acc-1');

    // A transcript-watcher upsert on the same account must not refetch.
    ws.emitFrame({
      'kind': 'session_upserted',
      'sessionId': 's1',
      'session': {'id': 's1', 'accountId': 'acc-1'},
    });
    await pumpEventQueue();
    expect(sessions.loads, 1);

    // The server moved the session: the details reload with the new account.
    sessions.accountId = 'acc-2';
    ws.emitFrame({
      'kind': 'session_upserted',
      'sessionId': 's1',
      'session': {'id': 's1', 'accountId': 'acc-2'},
    });
    await pumpEventQueue();
    expect(sessions.loads, 2);
    expect((await container.read(sessionDetailsProvider('s1').future)).raw['accountId'], 'acc-2');
  });
}
