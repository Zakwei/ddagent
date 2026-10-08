import 'dart:async';
import 'dart:io';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:ddagent_app/features/chat/view/composer.dart';
import 'package:ddagent_app/features/chat/view/session_subheader.dart';
import 'package:ddagent_app/features/chat/view/transcript_view.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/state/activity_poller.dart';
import 'package:ddagent_app/features/sessions/state/session_activity.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'transcript_test.dart' show FakeWs;

void main() {
  late FakeWs ws;
  late ChatChannel channel;
  late ProviderContainer container;
  late Directory hiveDirectory;
  List<Map<String, dynamic>> history = [];
  Completer<void>? historyGate;
  var recentLoads = 0;

  setUpAll(() async {
    hiveDirectory = await Directory.systemTemp.createTemp('stream_lifecycle_');
    Hive.init(hiveDirectory.path);
    await ChatStorage.init();
    await Hive.openBox<dynamic>('settings');
  });
  tearDownAll(() async {
    await Hive.close();
    await hiveDirectory.delete(recursive: true);
  });
  void initialize() {
    ws = FakeWs();
    channel = ChatChannel(ws);
    history = [];
    historyGate = null;
    recentLoads = 0;
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (o, h) async {
            Map<String, dynamic> data = {};
            if (o.path.endsWith('/messages')) {
              final snapshot = List<Map<String, dynamic>>.of(history);
              await historyGate?.future;
              data = {'messages': snapshot, 'total': snapshot.length, 'hasMore': false};
            } else if (o.path.endsWith('/recent')) {
              recentLoads++;
              data = {'conversations': <dynamic>[]};
            } else if (o.path.endsWith('/s1')) {
              data = {
                'session': {'id': 's1', 'provider': 'claude'},
              };
            }
            h.resolve(Response(requestOptions: o, data: {'success': true, 'data': data}));
          },
        ),
      );
    container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(dio),
        chatChannelProvider.overrideWithValue(channel),
        activityPollerProvider.overrideWith((ref) {}),
        quotaSnapshotProvider.overrideWith((ref) => const Stream<QuotaSnapshot?>.empty()),
      ],
    );
  }

  Future<void> mount(WidgetTester tester) async {
    initialize();
    channel.start();
    tester.view.physicalSize = const Size(1000, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    ws.emitState(WsState.open);
    await tester.pump();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TranslationProvider(
          child: MaterialApp(
            home: Scaffold(body: TranscriptView(sessionId: 's1')),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 120));
    ws.emitFrame({'kind': 'chat_subscribed', 'sessionId': 's1', 'isProcessing': false});
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
  }

  Future<void> cleanup(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
    unawaited(channel.dispose());
    await tester.pump();
  }

  TranscriptController controller() => container.read(transcriptProvider('s1').notifier);
  Future<void> frame(
    WidgetTester tester,
    String run,
    int seq,
    String kind, [
    String? content,
  ]) async {
    ws.emitFrame({
      'sessionId': 's1',
      'runId': run,
      'seq': seq,
      'kind': kind,
      'provider': 'claude',
      'content': ?content,
    });
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 70));
    await tester.pump();
  }

  List<String> answers() => container
      .read(sessionMessagesProvider('s1'))
      .where((m) => m.kind == 'stream_delta' || (m.kind == 'text' && m.role == 'assistant'))
      .map((m) => m.content ?? '')
      .toList();
  void expectRunning(bool running) {
    expect(container.read(transcriptProvider('s1')).runStatus, running ? 'running' : 'done');
    expect(container.read(sessionActivityProvider).containsKey('s1'), running);
    expect(container.read(sessionMessageStoreProvider)['s1']?.status, running ? 'running' : 'done');
  }

  void expectVisible(String text) {
    expect(find.text(text, findRichText: true).hitTestable(), findsOneWidget);
  }

  Future<void> expectIdleUi(WidgetTester tester) async {
    // ActivityIndicator keeps its pill for the 220 ms exit animation.
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump();
    expect(
      find.descendant(of: find.byType(ChatComposer), matching: find.byIcon(Icons.stop)),
      findsNothing,
    );
    expect(find.byIcon(Icons.send), findsOneWidget);
  }

  testWidgets('six simulated idle minutes, expired cursor and reconnect stream visibly', (
    tester,
  ) async {
    await mount(tester);
    controller().send('first');
    await frame(tester, 'r1', 1, 'stream_delta', 'Before idle');
    await frame(tester, 'r1', 2, 'complete');
    expectRunning(false);
    // Controlled widget clock; this does not exercise real backend retention.
    await tester.pump(const Duration(minutes: 6));
    ws.emitState(WsState.reconnecting);
    await tester.pump();
    ws.emitState(WsState.open);
    await tester.pump();
    final subscription = ws.sent.lastWhere((f) => f['type'] == 'chat.subscribe');
    expect((subscription['sessions'] as List).single['runId'], 'r1');
    ws.emitFrame({'kind': 'chat_subscribed', 'sessionId': 's1', 'isProcessing': false});
    await tester.pump();
    expect(channel.cursor('s1').runId, isNull);
    expect(channel.cursor('s1').lastSeq, 0);
    expectRunning(false);
    controller().send('after idle');
    expect(ws.sent[ws.sent.length - 2]['type'], 'chat.subscribe');
    expect(ws.sent.last['type'], 'chat.send');
    expectRunning(true);
    ws.emitFrame({'kind': 'chat_subscribed', 'sessionId': 's1', 'isProcessing': false});
    await tester.pump();
    expectRunning(true);
    await frame(tester, 'r2', 1, 'stream_delta', 'After');
    expectVisible('After');
    expect(answers(), ['Before idle', 'After']);
    await frame(tester, 'r2', 2, 'stream_delta', ' idle');
    expectVisible('After idle');
    await frame(tester, 'r2', 2, 'stream_delta', ' idle');
    await frame(tester, 'r1', 99, 'stream_delta', 'LATE');
    await frame(tester, 'r1', 100, 'complete');
    expectRunning(true);
    await frame(tester, 'r2', 3, 'complete');
    expect(answers(), ['Before idle', 'After idle']);
    expectVisible('After idle');
    expectRunning(false);
    await expectIdleUi(tester);
    await cleanup(tester);
  });

  testWidgets('six simulated idle minutes with the socket still open reattach before send', (
    tester,
  ) async {
    await mount(tester);
    controller().send('before');
    await frame(tester, 'old', 1, 'stream_delta', 'Old response');
    await frame(tester, 'old', 2, 'complete');
    await tester.pump(const Duration(minutes: 6));
    controller().send('after');
    expect(ws.sent[ws.sent.length - 2]['type'], 'chat.subscribe');
    expect(ws.sent.last['type'], 'chat.send');
    ws.emitFrame({'kind': 'chat_subscribed', 'sessionId': 's1', 'isProcessing': false});
    await tester.pump();
    expectRunning(true);
    await frame(tester, 'new', 1, 'stream_delta', 'New');
    expectVisible('New');
    await frame(tester, 'new', 2, 'stream_delta', ' response');
    expectVisible('New response');
    await frame(tester, 'new', 3, 'complete');
    expect(answers(), ['Old response', 'New response']);
    expectRunning(false);
    await expectIdleUi(tester);
    await cleanup(tester);
  });

  testWidgets('reconnect mid-run replays only missing chunks without splitting the live row', (
    tester,
  ) async {
    await mount(tester);
    controller().send('stream');
    await frame(tester, 'r1', 1, 'stream_delta', 'First');
    expectVisible('First');
    ws.emitState(WsState.reconnecting);
    await tester.pump();
    ws.emitState(WsState.open);
    await tester.pump();
    final subscription = ws.sent.lastWhere((f) => f['type'] == 'chat.subscribe');
    expect((subscription['sessions'] as List).single, {
      'sessionId': 's1',
      'runId': 'r1',
      'lastSeq': 1,
    });
    ws.emitFrame({
      'kind': 'chat_subscribed',
      'sessionId': 's1',
      'runId': 'r1',
      'isProcessing': true,
    });
    await frame(tester, 'r1', 1, 'stream_delta', 'First');
    await frame(tester, 'r1', 2, 'stream_delta', ' second');
    expectVisible('First second');
    expect(answers(), ['First second']);
    await frame(tester, 'r1', 3, 'complete');
    expectRunning(false);
    await expectIdleUi(tester);
    await cleanup(tester);
  });

  testWidgets('five Stop cycles isolate late frames and preserve every visible chunk', (
    tester,
  ) async {
    await mount(tester);
    final expected = <String>[];
    for (var i = 0; i < 5; i++) {
      final run = 'stop$i';
      controller().send('prompt $i');
      expectRunning(true);
      if (i.isEven) {
        controller().abort();
        expect(ws.sent.last['type'], 'chat.subscribe');
        expect(ws.sent.where((f) => f['type'] == 'chat.abort').length, i);
        // Ack for the pre-send subscribe, followed by the Stop subscription.
        ws.emitFrame({'kind': 'chat_subscribed', 'sessionId': 's1', 'isProcessing': false});
        ws.emitFrame({
          'kind': 'chat_subscribed',
          'sessionId': 's1',
          'runId': run,
          'isProcessing': true,
        });
        await tester.pump();
        expect(ws.sent.last, {'type': 'chat.abort', 'sessionId': 's1', 'runId': run});
      }
      if (i.isOdd) {
        ws.emitFrame({'kind': 'chat_subscribed', 'sessionId': 's1', 'isProcessing': false});
      }
      await frame(tester, run, 1, 'stream_delta', 'Part $i');
      expectVisible('Part $i');
      await frame(tester, run, 2, 'stream_delta', ' retained');
      expectVisible('Part $i retained');
      if (i.isOdd) {
        await tester.tap(
          find.descendant(of: find.byType(ChatComposer), matching: find.byIcon(Icons.stop)).last,
        );
        expect(ws.sent.last['runId'], run);
      }
      ws.emitFrame({
        'kind': 'complete',
        'sessionId': 's1',
        'runId': run,
        'seq': 3,
        'aborted': true,
        'exitCode': 0,
      });
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 70));
      expected.add('Part $i retained');
      expectRunning(false);
      final next = 'next$i';
      // Retrying the same prompt after Stop is a new turn, even inside the
      // double-submit guard window.
      controller().send('prompt $i');
      expect(ws.sent.where((f) => f['type'] == 'chat.send').length, 2 * i + 2);
      ws.emitFrame({'kind': 'chat_subscribed', 'sessionId': 's1', 'isProcessing': false});
      await frame(tester, next, 1, 'stream_delta', 'Next $i');
      expectVisible('Next $i');
      await frame(tester, run, 4, 'stream_delta', 'WRONG');
      await frame(tester, run, 5, 'stream_replace', 'WRONG');
      await frame(tester, run, 6, 'complete');
      expectRunning(true);
      await frame(tester, next, 2, 'stream_delta', ' complete');
      await frame(tester, next, 2, 'stream_delta', ' complete');
      expectVisible('Next $i complete');
      await frame(tester, next, 3, 'complete');
      expected.add('Next $i complete');
      expect(answers(), expected);
      expectRunning(false);
      await expectIdleUi(tester);
    }
    await cleanup(tester);
  });

  testWidgets('canonical replace and slow completion refresh preserve next stream', (tester) async {
    await mount(tester);
    controller().send('one');
    await frame(tester, 'r1', 1, 'stream_delta', 'draft');
    await frame(tester, 'r1', 2, 'stream_replace', 'Canonical');
    expectVisible('Canonical');
    await frame(tester, 'r1', 3, 'stream_delta', ' answer');
    expectVisible('Canonical answer');
    history = [
      {
        'id': 'persisted',
        'kind': 'text',
        'role': 'assistant',
        'content': 'Canonical answer',
        'provider': 'claude',
        'timestamp': DateTime.now().toIso8601String(),
      },
    ];
    historyGate = Completer<void>();
    await frame(tester, 'r1', 4, 'complete');
    controller().send('two');
    await frame(tester, 'r2', 1, 'stream_delta', 'Second');
    expectVisible('Second');
    historyGate!.complete();
    historyGate = null;
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 70));
    expect(answers(), ['Canonical answer', 'Second']);
    await frame(tester, 'r2', 2, 'stream_delta', ' answer');
    expectVisible('Second answer');
    await frame(tester, 'r2', 3, 'complete');
    expect(answers(), ['Canonical answer', 'Second answer']);
    expectRunning(false);
    await expectIdleUi(tester);
    await cleanup(tester);
  });

  testWidgets('idle reconnect and NO_ACTIVE_RUN settle state; session list reloads', (
    tester,
  ) async {
    await mount(tester);
    container.listen(sessionsProvider((null, null)), (_, _) {});
    await tester.pump();
    await frame(tester, 'r1', 1, 'stream_delta', 'Unfinished');
    final loadsBeforeReconnect = recentLoads;
    ws.emitState(WsState.reconnecting);
    await tester.pump();
    ws.emitState(WsState.open);
    await tester.pump();
    ws.emitFrame({'kind': 'chat_subscribed', 'sessionId': 's1', 'isProcessing': false});
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 450));
    expectRunning(false);
    expect(recentLoads, greaterThan(loadsBeforeReconnect));
    expectVisible('Unfinished');
    controller().send('abort race');
    controller().abort();
    ws.emitFrame({'kind': 'protocol_error', 'sessionId': 's1', 'code': 'NO_ACTIVE_RUN'});
    await tester.pump();
    await tester.pump();
    expectRunning(false);
    await expectIdleUi(tester);
    await cleanup(tester);
  });

  testWidgets('background tasks keep a pill up after the turn completes, without a running turn', (
    tester,
  ) async {
    await mount(tester);
    controller().send('launch agents');
    await frame(tester, 'r1', 1, 'stream_delta', 'Launching');
    await frame(tester, 'r1', 2, 'complete');
    ws.emitFrame({
      'sessionId': 's1',
      'runId': 'r1',
      'seq': 3,
      'kind': 'background_tasks',
      'provider': 'claude',
      'count': 2,
    });
    await tester.pump();
    expectRunning(false);
    expect(find.text('2 background tasks running'), findsOneWidget);
    // Idle composer: the user can keep talking while the agents work.
    expect(find.byIcon(Icons.send), findsOneWidget);

    ws.emitFrame({
      'sessionId': 's1',
      'runId': 'r1',
      'seq': 4,
      'kind': 'background_tasks',
      'provider': 'claude',
      'count': 0,
    });
    await tester.pump();
    expect(find.textContaining('background task'), findsNothing);
    expect(answers(), ['Launching']);
  });
}
