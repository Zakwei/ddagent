import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/chat/view/composer.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Repro for the double user bubble: count `local_*` echoes per gesture.
class _FakeWs extends WsClient {
  _FakeWs() : super(urlBuilder: () async => Uri.parse('ws://t'));

  final _frames = StreamController<Map<String, dynamic>>.broadcast();
  final _states = StreamController<WsState>.broadcast();
  final sent = <Map<String, dynamic>>[];

  @override
  Stream<Map<String, dynamic>> get frames => _frames.stream;
  @override
  Stream<WsState> get states => _states.stream;
  @override
  WsState get state => WsState.closed;

  @override
  Future<void> connect() async {}

  @override
  void send(Map<String, dynamic> frame) {
    // Never "open": send() lands in the offline queue, but appendLocalEcho
    // still runs — exactly the visible path we are counting.
    sent.add(frame);
    throw StateError('WebSocket is not open');
  }
}

Dio _fakeDio() {
  final dio = Dio(BaseOptions(baseUrl: 'http://t'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (o, h) {
        final data = switch (o.path) {
          '/api/providers/claude/models' => {'models': <dynamic>[]},
          '/api/providers/claude/sessions/s1/active-model' =>
            <String, dynamic>{},
          '/api/provider-accounts' => {'accounts': const <dynamic>[]},
          '/api/queue' => {'messages': const <Map<String, dynamic>>[]},
          '/api/commands/list' => {
            'builtIn': const <dynamic>[],
            'custom': const <dynamic>[],
          },
          '/api/providers/claude/skills' => {'skills': const <dynamic>[]},
          '/api/providers/sessions/recent' => {
            'conversations': const <Map<String, dynamic>>[],
          },
          '/api/file-tree/projects/p1/files' => const <dynamic>[],
          '/api/taskmaster/tasks/p1' => {'tasks': const <dynamic>[]},
          '/api/assets/files' => {'attachments': const <dynamic>[]},
          _ => <String, dynamic>{},
        };
        h.resolve(
          Response(requestOptions: o, data: {'success': true, 'data': data}),
        );
      },
    ),
  );
  return dio;
}

void main() {
  late _FakeWs ws;

  setUpAll(() async {
    Hive.init('/tmp/ddagent_send_dispatch_hive');
    await ChatStorage.init();
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
  });

  setUp(() => ws = _FakeWs());

  Widget app() => TranslationProvider(
    child: ProviderScope(
      overrides: [
        dioProvider.overrideWithValue(_fakeDio()),
        chatChannelProvider.overrideWithValue(ChatChannel(ws)..start()),
      ],
      child: MaterialApp(
        theme: AppTheme.ocChat(),
        home: const MediaQuery(
          data: MediaQueryData(size: Size(1000, 800)),
          child: Scaffold(
            body: Align(
              alignment: Alignment.bottomCenter,
              child: ChatComposer(
                sessionId: 's1',
                projectId: 'p1',
                provider: 'claude',
              ),
            ),
          ),
        ),
      ),
    ),
  );

  int localEchoes(WidgetTester tester) {
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ChatComposer)),
    );
    final slot = container.read(sessionMessageStoreProvider)['s1'];
    final locals = (slot?.realtimeMessages ?? const [])
        .where((m) => m.isLocalEcho)
        .toList();
    for (final m in locals) {
      // ignore: avoid_print
      print('local echo: ${m.id} ${m.timestamp}');
    }
    return locals.length;
  }

  testWidgets('one Enter press → exactly one local echo', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    final field = find.byType(TextField);
    await tester.enterText(field, 'hello one');
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump(const Duration(milliseconds: 100));

    expect(localEchoes(tester), 1, reason: 'Enter fired _send() twice');
  });

  testWidgets('one send-button tap → exactly one local echo', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    final field = find.byType(TextField);
    await tester.enterText(field, 'hello tap');
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.send));
    await tester.pump(const Duration(milliseconds: 100));

    expect(localEchoes(tester), 1, reason: 'Button tap fired _send() twice');
  });

  testWidgets('Enter then fast second Enter → still one echo', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();
    final field = find.byType(TextField);
    await tester.enterText(field, 'hello double');
    await tester.pumpAndSettle();

    // Two key events in the same frame — the input must be cleared by the
    // first synchronous send before the second reads it.
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump(const Duration(milliseconds: 100));

    expect(localEchoes(tester), 1, reason: 'rapid double Enter double-sent');
  });
}
