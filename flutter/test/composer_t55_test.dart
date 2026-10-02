import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/chat/view/composer.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// chatChannelProvider auto-connects — a real WsClient would leave a
/// reconnect Timer pending; this one never connects (closed socket → sends
/// fall back to the offline queue, which is exactly what T55 tests need).
class _FakeWs extends WsClient {
  _FakeWs() : super(urlBuilder: () async => Uri.parse('ws://t'));

  final _frames = StreamController<Map<String, dynamic>>.broadcast();
  final _states = StreamController<WsState>.broadcast();

  @override
  Stream<Map<String, dynamic>> get frames => _frames.stream;
  @override
  Stream<WsState> get states => _states.stream;
  @override
  WsState get state => WsState.closed;

  @override
  Future<void> connect() async {}
}

/// Mutable queue rows so `send-now`/`edit`/`delete` behave like the server —
/// the next GET returns what is left.
final _serverQueue = <Map<String, dynamic>>[];

Dio _fakeDio() {
  final dio = Dio(BaseOptions(baseUrl: 'http://t'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (o, h) {
        if (o.method == 'DELETE' && o.path.startsWith('/api/queue/')) {
          final id = o.path.split('/').last;
          _serverQueue.removeWhere((m) => '${m['id']}' == id);
          h.resolve(
            Response(requestOptions: o, data: {'success': true, 'data': <String, dynamic>{}}),
          );
          return;
        }
        final data = switch (o.path) {
          '/api/providers/claude/models' => {'models': const <Map<String, dynamic>>[]},
          '/api/providers/claude/sessions/s1/active-model' => {'id': 'm1'},
          '/api/provider-accounts' => {'accounts': const <dynamic>[]},
          '/api/queue' => {'messages': List.of(_serverQueue)},
          '/api/commands/list' => {
            'builtIn': const <Map<String, dynamic>>[],
            'custom': const <Map<String, dynamic>>[],
          },
          '/api/providers/claude/skills' => {'skills': const <dynamic>[]},
          '/api/providers/sessions/recent' => {'conversations': const <Map<String, dynamic>>[]},
          '/api/providers/sessions/s1' => {
            'session': {'id': 's1', 'projectId': 'p1'},
          },
          '/api/providers/sessions/s1/messages' => {
            'messages': const <Map<String, dynamic>>[],
            'total': 0,
            'hasMore': false,
          },
          '/api/file-tree/projects/p1/files' => const <dynamic>[],
          '/api/assets/files' => {'attachments': const <dynamic>[]},
          '/api/taskmaster/tasks/p1' => {'tasks': const <dynamic>[]},
          _ => <String, dynamic>{},
        };
        h.resolve(Response(requestOptions: o, data: {'success': true, 'data': data}));
      },
    ),
  );
  return dio;
}

Widget _app() => TranslationProvider(
  child: ProviderScope(
    overrides: [
      dioProvider.overrideWithValue(_fakeDio()),
      chatChannelProvider.overrideWithValue(ChatChannel(_FakeWs())..start()),
    ],
    child: MaterialApp(
      theme: AppTheme.ocChat(),
      home: const MediaQuery(
        data: MediaQueryData(size: Size(1000, 800)),
        child: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: ChatComposer(sessionId: 's1', projectId: 'p1'),
          ),
        ),
      ),
    ),
  ),
);

/// Runs [body] in the real async zone — widget callbacks that write to Hive
/// (`setInput`→writeDraft, `send`→enqueueOffline, `clearOfflineQueue`) issue
/// real IO whose serialized write chain cannot complete under the fake zone;
/// a parked write would wedge the NEXT test's awaited box.put.
Future<void> _realZone(WidgetTester tester, Future<void> Function() body) => tester.runAsync(body);

void main() {
  setUpAll(() async {
    Hive.init('/tmp/ddagent_composer_t55_hive');
    await ChatStorage.init();
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
  });

  setUp(() async {
    _serverQueue.clear();
    await ChatStorage.writeDraft(ChatStorage.draftKey(sessionId: 's1'), '');
    await ChatStorage.writeOfflineQueue('p1', const []);
    unawaited(Hive.box<dynamic>('settings').delete('uiPreferences'));
    unawaited(Hive.box<dynamic>('settings').delete('command_history_p1'));
  });

  testWidgets('queued card: status label, attachment count, edit restores input', (tester) async {
    await _realZone(tester, () async {
      _serverQueue.add({
        'id': 7,
        'content': 'hold this',
        'status': 'queued',
        'options': {
          'attachments': [
            {'name': 'a.png'},
            {'name': 'b.png'},
          ],
        },
      });
      await tester.pumpWidget(_app());
      // Real zone: give the init's dio chains real event-loop turns.
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await tester.pump();
      await tester.pump();

      expect(find.text('Queued · Will send when this finishes'), findsOneWidget);
      expect(find.text('hold this'), findsOneWidget);
      expect(find.text('2 files attached'), findsOneWidget);
      expect(find.byTooltip('Send now'), findsOneWidget);
      expect(find.byTooltip('Edit queued message'), findsOneWidget);
      expect(find.byTooltip('Delete queued message'), findsOneWidget);

      await tester.tap(find.byTooltip('Edit queued message'));
      await tester.pump(const Duration(milliseconds: 300));
      // Let editQueued's real IO (draft write + queue DELETE) land.
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await tester.pump();
      // Content restored into the composer; the queued row is deleted.
      expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, 'hold this');
      expect(find.byTooltip('Send now'), findsNothing);
      expect(_serverQueue, isEmpty);
    });
  });

  testWidgets('failed queued row disables nothing but swaps the status text', (tester) async {
    _serverQueue.add({
      'id': 9,
      'content': 'retry me',
      'status': 'failed',
      'options': const <String, dynamic>{},
    });
    await tester.pumpWidget(_app());
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Queued · Failed to send'), findsOneWidget);
    // Send-now stays enabled for failed rows (only 'sending' disables).
    final sendBtn = tester.widget<IconButton>(
      find.ancestor(of: find.byTooltip('Send now'), matching: find.byType(IconButton)),
    );
    expect(sendBtn.onPressed, isNotNull);
  });

  testWidgets('offline queue card shows count and Cancel clears storage', (tester) async {
    await _realZone(tester, () async {
      await ChatStorage.writeOfflineQueue('p1', const [
        {'sessionId': 's1', 'content': 'parked one'},
        {'sessionId': 's1', 'content': 'parked two'},
        {'sessionId': 'other', 'content': 'not mine'},
      ]);
      await tester.pumpWidget(_app());
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await tester.pump();
      await tester.pump();

      expect(
        find.text('2 messages queued offline — will send automatically when reconnected'),
        findsOneWidget,
      );

      await tester.tap(find.text('Cancel'));
      // Let the real Hive write land, then rebuild.
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await tester.pump();
      expect(find.textContaining('queued offline'), findsNothing);
      expect(ChatStorage.readOfflineQueue('p1').single['sessionId'], 'other');
    });
  });

  testWidgets('sendByCtrlEnter: Enter newlines, Ctrl+Enter sends', (tester) async {
    await _realZone(tester, () async {
      await Hive.box<dynamic>('settings').put('uiPreferences', {'sendByCtrlEnter': true});
      await tester.pumpWidget(_app());
      await Future<void>.delayed(const Duration(milliseconds: 300));
      await tester.pump();

      expect(find.text('Ctrl+Enter to send • / commands'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'hi');
      await tester.pump();
      // Plain Enter inserts a newline instead of sending.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, 'hi\n');

      // Ctrl+Enter sends — the closed socket parks it in the offline queue.
      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, '');
      expect(find.textContaining('queued offline'), findsOneWidget);
    });
  });
}
