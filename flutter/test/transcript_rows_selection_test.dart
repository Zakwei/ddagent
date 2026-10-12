import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/chat/view/session_subheader.dart';
import 'package:ddagent_app/features/chat/view/transcript_view.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/sessions/state/activity_poller.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _Ws extends WsClient {
  _Ws() : super(urlBuilder: () async => Uri.parse('ws://test'));

  @override
  Stream<Map<String, dynamic>> get frames => const Stream.empty();
  @override
  Stream<WsState> get states => const Stream.empty();
  @override
  WsState get state => WsState.closed;
  @override
  Future<void> connect() async {}
}

class _Channel extends ChatChannel {
  _Channel() : super(_Ws());
  @override
  Future<void> connect() async {}
}

SessionMessage _message(
  String id, {
  required String kind,
  String? role,
  String? content,
  String? text,
  String? summary,
  String? status,
  String? toolName,
  String? toolId,
  Map<String, dynamic>? toolInput,
  Map<String, dynamic>? toolResult,
}) => SessionMessage(
  id: id,
  sessionId: 's1',
  timestamp: '2025-01-01T00:00:00Z',
  provider: 'claude',
  kind: kind,
  role: role,
  content: content,
  text: text,
  summary: summary,
  status: status,
  toolName: toolName,
  toolId: toolId,
  toolInput: toolInput,
  toolResult: toolResult,
);

Dio _dio() => Dio(BaseOptions(baseUrl: 'http://test'))
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) => handler.resolve(
        Response(
          requestOptions: options,
          data: options.path.endsWith('/messages')
              ? {
                  'success': true,
                  'data': {'messages': <dynamic>[], 'total': 0, 'hasMore': false},
                }
              : options.path.contains('voice')
              ? {'success': true, 'data': <String, dynamic>{}}
              : {
                  'success': true,
                  'data': {
                    'session': {'id': 's1', 'provider': 'claude'},
                  },
                },
        ),
      ),
    ),
  );

void main() {
  setUpAll(() async {
    Hive.init('/tmp/ddagent_transcript_rows_selection_test'); // path ignored on web
    await ChatStorage.init();
    await Hive.openBox<dynamic>('settings');
  });

  // Every readable row of the pane — not just assistant prose — is part of
  // the selection region: inline code, thinking, subagent output, task
  // notices, status lines.
  testWidgets('muted transcript rows are selectable and copyable', (tester) async {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.contextMenu, (_) async => null);
    String? clip;
    messenger.setMockMethodCallHandler(SystemChannels.platform, (c) async {
      if (c.method == 'Clipboard.setData') clip = (c.arguments as Map)['text'] as String?;
      return null;
    });
    final container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(_dio()),
        chatChannelProvider.overrideWithValue(_Channel()),
        activityPollerProvider.overrideWith((ref) {}),
        quotaSnapshotProvider.overrideWith((ref) => const Stream<QuotaSnapshot?>.empty()),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TranslationProvider(
          child: const MaterialApp(
            home: Scaffold(body: TranscriptView(sessionId: 's1')),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    final store = container.read(sessionMessageStoreProvider.notifier);
    store.appendRealtime(
      's1',
      _message(
        'm1',
        kind: 'text',
        role: 'assistant',
        content: 'ANCHOR prose\n\n- `CODE-ITEM: 4 tests`\n- `CODE-TWO: 1 test`\n',
      ),
    );
    store.appendRealtime(
      's1',
      _message('m2', kind: 'thinking', role: 'assistant', content: '- THINK-ITEM one\n- two'),
    );
    store.appendRealtime(
      's1',
      _message(
        'm3',
        kind: 'tool_use',
        role: 'assistant',
        toolName: 'Agent',
        toolId: 't3',
        toolInput: {'description': 'AGENT-DESC run e2e'},
        toolResult: {'content': '- AGENT-RESULT: 4 tests'},
      ),
    );
    store.appendRealtime(
      's1',
      _message(
        'm4',
        kind: 'task_notification',
        role: 'assistant',
        content: 'TASK-TITLE',
        status: 'completed',
        summary: '- TASK-SUMMARY line',
      ),
    );
    store.appendRealtime(
      's1',
      _message('m5', kind: 'status', role: 'assistant', text: 'STATUS-NOTICE line'),
    );
    // The positioned list lays the new rows out one frame after the store
    // notifies; selecting before that trips the region's selectable bookkeeping.
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);

    // Expand the collapsed rows so their text is on screen.
    for (final finder in [
      find.byIcon(Icons.account_tree_outlined),
      find.text('Thought for a few seconds'),
    ]) {
      expect(finder, findsOneWidget);
      await tester.tap(finder);
      await tester.pump(const Duration(milliseconds: 400));
    }
    expect(tester.takeException(), isNull);

    BuildContext inside() => tester.element(find.textContaining('ANCHOR', findRichText: true));
    Actions.invoke(inside(), const SelectAllTextIntent(SelectionChangedCause.keyboard));
    await tester.pump();
    Actions.invoke(inside(), CopySelectionTextIntent.copy);
    await tester.pump();
    final copied = clip ?? '';
    final missing = [
      for (final part in [
        'ANCHOR prose',
        'CODE-ITEM: 4 tests',
        'CODE-TWO',
        'THINK-ITEM',
        'AGENT-DESC',
        'AGENT-RESULT',
        'TASK-TITLE',
        'TASK-SUMMARY',
        'STATUS-NOTICE',
      ])
        if (!copied.contains(part)) part,
    ];
    expect(missing, isEmpty, reason: 'copied: $copied');
    expect(tester.takeException(), isNull);
  }, variant: const TargetPlatformVariant({TargetPlatform.linux}));
}
