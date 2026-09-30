import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/chat/state/composer_controller.dart';
import 'package:ddagent_app/features/chat/view/composer.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Must equal the record the widget builds internally (projectPath unset).
const _arg = (
  sessionId: 's1',
  projectId: 'p1',
  provider: 'claude',
  projectPath: null,
);

/// chatChannelProvider auto-connects — a real WsClient would leave a
/// reconnect Timer pending and hang FakeTimer; this one never connects.
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

Dio _fakeDio() {
  final dio = Dio(BaseOptions(baseUrl: 'http://t'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (o, h) {
        final data = switch (o.path) {
          '/api/providers/claude/models' => {
            'models': [
              {
                'id': 'm1',
                'label': 'M1',
                'effort': {
                  'values': ['low', 'high'],
                },
              },
            ],
          },
          '/api/providers/claude/sessions/s1/active-model' => {'id': 'm1'},
          '/api/provider-accounts' => {'accounts': const <dynamic>[]},
          '/api/queue' => {'messages': const <Map<String, dynamic>>[]},
          '/api/commands/list' => {'commands': const <Map<String, dynamic>>[]},
          '/api/assets/files' => {
            'attachments': [
              {'name': 'note.txt', 'size': 2048, 'mimeType': 'text/plain'},
            ],
          },
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

Widget _app({double width = 1000, bool dense = false}) => ProviderScope(
  overrides: [
    dioProvider.overrideWithValue(_fakeDio()),
    chatChannelProvider.overrideWithValue(ChatChannel(_FakeWs())..start()),
  ],
  child: MaterialApp(
    theme: AppTheme.ocChat(),
    home: MediaQuery(
      data: MediaQueryData(size: Size(width, 800)),
      child: Scaffold(
        // Bottom-anchored like the real chat view — the model menu's max
        // height derives from the composer box's top edge.
        body: Align(
          alignment: Alignment.bottomCenter,
          child: ChatComposer(sessionId: 's1', projectId: 'p1', dense: dense),
        ),
      ),
    ),
  ),
);

void main() {
  setUpAll(() async {
    Hive.init('/tmp/ddagent_composer_ui_hive');
    await ChatStorage.init();
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
  });

  setUp(() {
    ChatStorage.writeDraft(ChatStorage.draftKey(sessionId: 's1'), '');
  });

  testWidgets('desktop: `>` caret, submit hint, attach tool, model pill', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    // .oc-input-caret
    expect(find.text('>'), findsOneWidget);
    // .oc-submit-hint (hidden lg:inline-block → visible on wide panes)
    expect(find.text('Enter to send • / commands'), findsOneWidget);
    expect(find.byTooltip('Attach file'), findsOneWidget);
    // model pill shows the resolved label
    expect(find.text('M1'), findsOneWidget);

    // PromptInputSubmit: 40x40, disabled while the draft is empty.
    IconButton send() => tester.widget<IconButton>(
      find.ancestor(
        of: find.byIcon(Icons.send),
        matching: find.byType(IconButton),
      ),
    );
    expect(send().onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'hello');
    await tester.pump();
    // Hint fades out while a draft is present (opacity 0, still laid out).
    expect(send().onPressed, isNotNull);
  });

  testWidgets('compact: hint hidden, toolbar collapses under +', (
    tester,
  ) async {
    await tester.pumpWidget(_app(width: 400));
    await tester.pumpAndSettle();

    expect(find.text('Enter to send • / commands'), findsNothing);
    expect(find.byTooltip('Attach file'), findsNothing);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('>'), findsOneWidget);
    // Web mobile keeps the model chip in the footer (permission follows the
    // capability matrix; the fake state has no modes, so it stays hidden).
    expect(
      find.byTooltip('Select model and reasoning effort'),
      findsOneWidget,
    );

    // MobileComposerActionSheet parity — `+` opens attach + options.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Attach file'), findsOneWidget);
  });

  testWidgets('model menu: reasoning, expandable model section, search', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    // Trigger chip — the active model's label.
    await tester.tap(find.text('M1'));
    await tester.pumpAndSettle();
    // ComposerMenuSurface: Reasoning rows first, model section collapsed.
    expect(find.text('Reasoning'), findsOneWidget);
    expect(find.text('Default'), findsOneWidget);
    expect(find.text('Search models...'), findsNothing);

    // Collapsible row carries the active model's label and a right chevron —
    // expand it via the chevron's row (the trigger chip has no chevron).
    final expander = find.ancestor(
      of: find.byIcon(LucideIcons.chevronRight),
      matching: find.byType(InkWell),
    );
    await tester.tap(expander);
    await tester.pumpAndSettle();
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Free'), findsWidgets);
    expect(find.text('Paid'), findsOneWidget);
    expect(find.text('Search models...'), findsOneWidget);
    expect(find.text('Model'), findsOneWidget);

    // Search filters the list — no model matches 'zzz'.
    final field = find.ancestor(
      of: find.text('Search models...'),
      matching: find.byType(TextField),
    );
    await tester.enterText(field, 'zzz');
    await tester.pumpAndSettle();
    expect(find.text('No models found.'), findsOneWidget);

    // Tap outside — the surface closes.
    await tester.tapAt(const Offset(20, 20));
    await tester.pumpAndSettle();
    expect(find.text('Reasoning'), findsNothing);
  });

  testWidgets('attachment chip shows name+size and removes on ×', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(ChatComposer)),
    );
    // Real async (dio upload) — must run outside the fake-async zone.
    await tester.runAsync(
      () => container.read(composerProvider(_arg).notifier).attach(
        'note.txt',
        const [1, 2, 3],
        isImage: false,
      ),
    );
    await tester.pump();

    expect(find.text('note.txt'), findsOneWidget);
    expect(find.text('2 KB'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pump();
    expect(find.text('note.txt'), findsNothing);
  });
}
