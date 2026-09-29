import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
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

  void emit(Map<String, dynamic> frame) => _frames.add(frame);
}

void main() {
  late _FakeWs ws;

  /// REST token-usage 404s (provider-native sessions) — the gauge must still
  /// light up from the live `token_budget` status frame.
  Dio fakeDio() {
    final dio = Dio(BaseOptions(baseUrl: 'http://t'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          h.reject(
            DioException(
              requestOptions: o,
              response: Response(requestOptions: o, statusCode: 404),
            ),
          );
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

  setUp(() {
    ws = _FakeWs();
  });

  test('live token_budget frame feeds the context gauge; other sessions ignored', () async {
    final container = make();
    addTearDown(container.dispose);

    final sub = container.listen(contextUsageProvider('s1'), (_, _) {});
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(sub.read(), isNull, reason: 'no budget before any frame / REST 404');

    ws.emit({
      'kind': 'status',
      'text': 'token_budget',
      'sessionId': 's2',
      'tokenBudget': {'used': 900, 'total': 1000},
    });
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(sub.read(), isNull, reason: 'frame for another session must not leak');

    ws.emit({
      'kind': 'status',
      'text': 'token_budget',
      'sessionId': 's1',
      'tokenBudget': {'used': 73515, 'total': 1048576},
    });
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(sub.read()?.used, 73515);
    expect(sub.read()?.total, 1048576);
    expect(sub.read()?.contextPercent, 7);
  });
}
