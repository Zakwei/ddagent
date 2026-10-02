import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:ddagent_app/features/orchestrator/view/orchestrator_cards.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'transcript_test.dart' show FakeWs;

// Keep the real channel/controller/store/card path, replacing only the socket
// transport and HTTP boundary. The pane is mounted once per test.
class _OpenSession extends ConsumerWidget {
  const _OpenSession();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(transcriptProvider('s1'));
    final messages = ref.watch(sessionMessagesProvider('s1'));
    return Column(
      children: [
        for (final message in messages)
          if (message.context?['orchestratorKind'] != null)
            OrchestratorCard(key: ValueKey(message.id), message: message, sessionId: 's1'),
      ],
    );
  }
}

void main() {
  setUpAll(() async {
    Hive.init('/tmp/ddagent_test_hive_orchestrator_live');
    await ChatStorage.init();
  });

  late FakeWs ws;
  late ChatChannel channel;
  late ProviderContainer container;
  late int historyRequests;
  late List<Map<String, dynamic>> persistedTasks;

  void setup() {
    ws = FakeWs();
    channel = ChatChannel(ws)..start();
    historyRequests = 0;
    persistedTasks = [];
    final dio = Dio(BaseOptions(baseUrl: 'http://t'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final history = options.path.endsWith('/messages');
          if (history) historyRequests++;
          handler.resolve(
            Response(
              requestOptions: options,
              data: {
                'success': true,
                'data': history
                    ? {
                        'messages': [
                          {
                            'id': 'summary',
                            'kind': 'status',
                            'provider': 'orchestrator',
                            'timestamp': '2026-01-01T00:00:00Z',
                            'context': {'orchestratorKind': 'summary', 'text': 'Ready'},
                          },
                          ...persistedTasks,
                        ],
                        'total': 1 + persistedTasks.length,
                        'hasMore': false,
                      }
                    : {
                        'session': {'id': 's1', 'provider': 'orchestrator'},
                      },
              },
            ),
          );
        },
      ),
    );
    container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(dio),
        chatChannelProvider.overrideWithValue(channel),
      ],
    );
  }

  tearDown(() async {
    container.dispose();
    await channel.dispose();
  });

  Future<void> mount(WidgetTester tester) async {
    setup();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TranslationProvider(
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: SingleChildScrollView(child: _OpenSession())),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> deliver(WidgetTester tester, Map<String, dynamic> frame) async {
    ws.emitFrame(frame);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 100));
  }

  Map<String, dynamic> milestone(String status, int seq, {String runId = 'r1'}) => {
    'kind': 'status',
    'sessionId': 's1',
    'provider': 'orchestrator',
    'runId': runId,
    'seq': seq,
    'timestamp': '2026-01-01T00:00:${seq.toString().padLeft(2, '0')}Z',
    'context': {'orchestratorKind': 'taskmaster', 'taskId': '7', 'status': status},
  };

  for (final sequenced in [true, false]) {
    testWidgets(
      'open session retains successive ${sequenced ? 'sequenced' : 'unsequenced'} ID-less task statuses',
      (tester) async {
        await mount(tester);
        final pane = tester.element(find.byType(_OpenSession));
        final seen = <ServerEvent>[];
        final subscription = channel.events.listen(seen.add);
        addTearDown(subscription.cancel);
        final statuses = ['pending', 'in-progress', 'done'];
        for (var i = 0; i < statuses.length; i++) {
          final frame = milestone(statuses[i], i + 1);
          if (!sequenced) {
            frame.remove('runId');
            frame.remove('seq');
            frame['id'] = '';
          }
          await deliver(tester, frame);
          expect(find.text(statuses[i]), findsOneWidget);
          final rows = container.read(sessionMessagesProvider('s1'));
          expect(
            rows
                .where((m) => m.context?['orchestratorKind'] == 'taskmaster')
                .map((m) => m.context!['status']),
            statuses.take(i + 1),
          );
          expect(rows.map((m) => m.id).toSet().length, rows.length);
          expect(tester.element(find.byType(_OpenSession)), same(pane));
        }
        expect(seen, hasLength(3));
        expect(historyRequests, 1); // No completion, refresh or reopening.
        if (sequenced) {
          await deliver(tester, milestone('in-progress', 2));
          expect(seen, hasLength(3)); // Replay rejected at the real channel.
          expect(find.text('done'), findsOneWidget);
          await deliver(tester, milestone('blocked', 1, runId: 'r2'));
          expect(find.text('blocked'), findsOneWidget);
          expect(seen, hasLength(4));
        }
      },
    );
  }

  testWidgets('batched milestones retain explicit IDs and reconcile persisted echoes', (
    tester,
  ) async {
    await mount(tester);
    final frames = [
      milestone('pending', 1),
      milestone('in-progress', 2),
      {...milestone('done', 3), 'id': 'explicit-done'},
    ];
    for (final frame in frames) {
      ws.emitFrame(frame);
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();
    final rows = container.read(sessionMessagesProvider('s1'));
    expect(
      rows
          .where((m) => m.context?['orchestratorKind'] == 'taskmaster')
          .map((m) => m.context!['status']),
      ['pending', 'in-progress', 'done'],
    );
    expect(rows.map((m) => m.id), contains('explicit-done'));
    persistedTasks = [
      for (var i = 0; i < frames.length; i++)
        {...frames[i], 'id': 'persisted-$i'}
          ..remove('runId')
          ..remove('seq'),
    ];
    await deliver(tester, {'kind': 'complete', 'sessionId': 's1', 'runId': 'r1', 'seq': 4});
    expect(historyRequests, 2);
    final tasks = container
        .read(sessionMessagesProvider('s1'))
        .where((m) => m.context?['orchestratorKind'] == 'taskmaster');
    expect(tasks.map((m) => m.id), ['persisted-0', 'persisted-1', 'persisted-2']);
    expect(find.text('done'), findsOneWidget);
  });

  testWidgets('mounted summary controls follow successive session runs', (tester) async {
    await mount(tester);
    final summary = tester.element(find.byKey(const ValueKey('summary')));
    expect(find.text('Run next task'), findsOneWidget);
    await deliver(tester, {...milestone('started', 1), 'sessionId': 'other'});
    expect(find.text('Run next task'), findsOneWidget);
    for (final runId in ['r1', 'r2']) {
      await deliver(tester, milestone('started', 1, runId: runId));
      expect(find.text('Working on tasks…'), findsOneWidget);
      expect(find.text('Run next task'), findsNothing);
      await deliver(tester, milestone('done', 2, runId: runId));
      expect(find.text('Working on tasks…'), findsOneWidget);
      await deliver(tester, {'kind': 'complete', 'sessionId': 's1', 'runId': runId, 'seq': 3});
      expect(find.text('Working on tasks…'), findsNothing);
      expect(find.text('Run next task'), findsOneWidget);
      expect(tester.element(find.byKey(const ValueKey('summary'))), same(summary));
    }
  });
}
