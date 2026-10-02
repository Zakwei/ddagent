import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/chat/state/composer_controller.dart';
import 'package:ddagent_app/features/chat/view/composer.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// Must equal the record the widget builds internally (projectPath unset).
const _arg = (sessionId: 's1', projectId: 'p1', provider: 'claude', projectPath: null);

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
          // `/list` answers {builtIn, custom} + provider /skills merge.
          '/api/commands/list' => {
            'builtIn': [
              {
                'name': '/help',
                'description': 'Show help documentation',
                'namespace': 'builtin',
                'metadata': {'type': 'builtin'},
              },
            ],
            'custom': [
              {
                'name': '/deploy',
                'description': 'Deploy the app',
                'namespace': 'project',
                'metadata': const <String, dynamic>{},
              },
            ],
          },
          '/api/providers/claude/skills' => {
            'skills': [
              {
                'command': '/review-pr',
                'description': 'Review a pull request',
                'name': 'review-pr',
                'scope': 'plugin',
              },
            ],
          },
          '/api/commands/execute' => {'type': 'builtin'},
          '/api/providers/sessions/recent' => {'conversations': const <Map<String, dynamic>>[]},
          '/api/file-tree/projects/p1/files' => [
            {
              'name': 'src',
              'path': 'src',
              'type': 'directory',
              'children': [
                {'name': 'app.dart', 'path': 'src/app.dart', 'type': 'file'},
              ],
            },
          ],
          '/api/taskmaster/tasks/p1' => {
            'tasks': [
              {'id': 7, 'title': 'Fix the bug', 'status': 'open'},
            ],
          },
          '/api/assets/files' => {
            'attachments': [
              {'name': 'note.txt', 'size': 2048, 'mimeType': 'text/plain'},
            ],
          },
          _ => <String, dynamic>{},
        };
        h.resolve(Response(requestOptions: o, data: {'success': true, 'data': data}));
      },
    ),
  );
  return dio;
}

Widget _app({double width = 1000, bool dense = false}) => TranslationProvider(
  child: ProviderScope(
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
    // Command-usage history persists on disk — clear it so the Frequent
    // group doesn't leak in from an earlier run.
    Hive.box<dynamic>('settings').delete('command_history_p1');
  });

  testWidgets('desktop: `>` caret, submit hint, attach tool, model pill', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    // .oc-input-caret
    expect(find.text('>'), findsOneWidget);
    // .oc-submit-hint (hidden lg:inline-block → visible on wide panes)
    expect(find.text('Enter to send • / commands'), findsOneWidget);
    expect(find.byTooltip('Attach files'), findsOneWidget);
    // model pill shows the resolved label
    expect(find.text('M1'), findsOneWidget);

    // PromptInputSubmit: 40x40, disabled while the draft is empty.
    IconButton send() => tester.widget<IconButton>(
      find.ancestor(of: find.byIcon(Icons.send), matching: find.byType(IconButton)),
    );
    expect(send().onPressed, isNull);

    await tester.enterText(find.byType(TextField), 'hello');
    await tester.pump();
    // Hint fades out while a draft is present (opacity 0, still laid out).
    expect(send().onPressed, isNotNull);
  });

  testWidgets('compact: hint hidden, toolbar collapses under +', (tester) async {
    await tester.pumpWidget(_app(width: 400));
    await tester.pumpAndSettle();

    expect(find.text('Enter to send • / commands'), findsNothing);
    expect(find.byTooltip('Attach files'), findsNothing);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('>'), findsOneWidget);
    // Web mobile keeps the model chip in the footer (permission follows the
    // capability matrix; the fake state has no modes, so it stays hidden).
    expect(find.byTooltip('Select model and reasoning effort'), findsOneWidget);

    // MobileComposerActionSheet parity — `+` opens attach + options.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Attach files'), findsOneWidget);
  });

  testWidgets('model menu: reasoning, expandable model section, search', (tester) async {
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

  testWidgets('slash menu: groups, filter, keyboard, insert vs execute', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final field = find.byType(TextField);
    await tester.enterText(field, '/');
    await tester.pumpAndSettle();

    // Grouped namespaces with counts — builtin / skills / project.
    expect(find.text('BUILT-IN COMMANDS'), findsOneWidget);
    expect(find.text('SKILLS'), findsOneWidget);
    expect(find.text('PROJECT COMMANDS'), findsOneWidget);
    expect(find.text('/help'), findsOneWidget);
    expect(find.text('/review-pr'), findsOneWidget);
    expect(find.text('/deploy'), findsOneWidget);

    // Prefix filter: '/he' keeps only /help (a single group → no header).
    await tester.enterText(field, '/he');
    await tester.pumpAndSettle();
    expect(find.text('/help'), findsOneWidget);
    expect(find.text('/deploy'), findsNothing);
    expect(find.text('BUILT-IN COMMANDS'), findsNothing);

    // Enter on the built-in executes it (fixture returns type:builtin → the
    // input clears) and the menu closes.
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text('/help'), findsNothing);
    expect(tester.widget<TextField>(field).controller?.text ?? '', isEmpty);

    // A skill command INSERTS its name instead of executing.
    await tester.enterText(field, '/rev');
    await tester.pumpAndSettle();
    expect(find.text('/review-pr'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(field).controller?.text, '/review-pr ');

    // Enter with the menu closed falls through to send — the draft clears.
    // (The send marks the session processing, so the activity pill animates
    // forever: settle would never return. A bounded pump is enough here.)
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.widget<TextField>(field).controller?.text ?? '', isEmpty);
  });

  testWidgets('slash menu: arrows select a row, Escape closes', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    final field = find.byType(TextField);
    await tester.enterText(field, '/');
    await tester.pumpAndSettle();

    // ArrowDown selects the first filtered row — the Enter-hint chip and the
    // primary left bar appear only on the selected row.
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(find.byIcon(LucideIcons.cornerDownLeft), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('/help'), findsNothing);

    // No-match query → the web's empty state.
    await tester.enterText(field, '/zzz');
    await tester.pumpAndSettle();
    expect(find.text('No commands available'), findsOneWidget);
  });

  testWidgets('mention menu: styled rows, insert, arrow select', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    final field = find.byType(TextField);

    await tester.enterText(field, '@app');
    await tester.pumpAndSettle();
    // File row: basename title, mono subtitle path, FILE badge.
    expect(find.text('app.dart'), findsOneWidget);
    expect(find.text('src/app.dart'), findsOneWidget);
    expect(find.text('FILE'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(tester.widget<TextField>(field).controller?.text, '@src/app.dart ');
  });

  testWidgets('attachment chip shows name+size and removes on ×', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(tester.element(find.byType(ChatComposer)));
    // Real async (dio upload) — must run outside the fake-async zone.
    await tester.runAsync(
      () => container.read(composerProvider(_arg).notifier).attach('note.txt', const [
        1,
        2,
        3,
      ], isImage: false),
    );
    await tester.pump();

    expect(find.text('note.txt'), findsOneWidget);
    expect(find.text('2 KB'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pump();
    expect(find.text('note.txt'), findsNothing);
  });
}
