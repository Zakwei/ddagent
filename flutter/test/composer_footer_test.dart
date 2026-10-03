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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// chatChannelProvider auto-connects — this socket never does, so no
/// reconnect Timer is left pending for FakeTimer to trip on. The frame
/// controller stays exposed so tests can simulate a running session.
class _FakeWs extends WsClient {
  _FakeWs() : super(urlBuilder: () async => Uri.parse('ws://t'));

  final inbound = StreamController<Map<String, dynamic>>.broadcast();
  final _states = StreamController<WsState>.broadcast();

  @override
  Stream<Map<String, dynamic>> get frames => inbound.stream;
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
          '/api/providers/claude/models' => {'models': const <Map<String, dynamic>>[]},
          '/api/providers/claude/sessions/s1/active-model' => {'id': 'm1'},
          '/api/provider-accounts' => {'accounts': const <dynamic>[]},
          '/api/queue' => {'messages': const <Map<String, dynamic>>[]},
          '/api/commands/list' => {
            'builtIn': [
              {
                'name': '/help',
                'description': 'Show help documentation',
                'namespace': 'builtin',
                'metadata': {'type': 'builtin'},
              },
            ],
            'custom': const <Map<String, dynamic>>[],
          },
          '/api/providers/claude/skills' => {'skills': const <dynamic>[]},
          '/api/providers/sessions/recent' => {'conversations': const <Map<String, dynamic>>[]},
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

/// [paneWidth] forces a narrow composer inside a wide window — the app
/// breakpoint follows MediaQuery, so a small split pane still lays out the
/// desktop footer where the send button used to be pushed off the edge.
Widget _app({_FakeWs? ws, double width = 1000, double? paneWidth, bool dense = false}) =>
    TranslationProvider(
      child: ProviderScope(
        overrides: [
          dioProvider.overrideWithValue(_fakeDio()),
          chatChannelProvider.overrideWithValue(ChatChannel(ws ?? _FakeWs())..start()),
        ],
        child: MaterialApp(
          theme: AppTheme.ocChat(),
          home: MediaQuery(
            data: MediaQueryData(size: Size(width, 800)),
            child: Scaffold(
              body: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: paneWidth,
                  child: ChatComposer(sessionId: 's1', projectId: 'p1', dense: dense),
                ),
              ),
            ),
          ),
        ),
      ),
    );

/// The prompt box — the bordered Container the TextField lives in.
Finder _promptBox() => find.ancestor(
  of: find.byType(TextField),
  matching: find.byWidgetPredicate(
    (w) =>
        w is Container &&
        w.decoration is BoxDecoration &&
        (w.decoration! as BoxDecoration).border != null,
  ),
);

/// Face-agnostic: `_SendButton` is keyed, every face is an IconButton inside.
Finder _sendButton() => find.descendant(
  of: find.byKey(const ValueKey('composer-send')),
  matching: find.byType(IconButton),
);

/// The horizontal clip viewport of the option bar — its right edge is the
/// visible right end of the options, regardless of inner scroll content.
Finder _optionBarViewport() => find.byWidgetPredicate(
  (w) => w is SingleChildScrollView && w.scrollDirection == Axis.horizontal,
);

void _expectSendPinnedRight(WidgetTester tester) {
  // No overflow / layout exception surfaced during the last pump.
  expect(tester.takeException(), isNull);

  final send = tester.getRect(_sendButton());
  final box = tester.getRect(_promptBox());
  // PromptInputSubmit pinned to the footer's right inner edge — the 1px
  // border plus the footer's px-3 put the button's right edge 13px inside
  // the box outline.
  expect(send.right, moreOrLessEquals(box.right - 13, epsilon: 0.5));
  expect(send.top, greaterThanOrEqualTo(box.top));
  expect(send.bottom, lessThanOrEqualTo(box.bottom));

  // No collision: the option bar's visible viewport ends strictly left of
  // the button (the inner row's spacing:4 separates them).
  final options = tester.getRect(_optionBarViewport());
  expect(send.left, greaterThanOrEqualTo(options.right));
  expect(send.overlaps(options), isFalse);
}

void main() {
  setUpAll(() async {
    Hive.init('/tmp/ddagent_composer_footer_hive');
    await ChatStorage.init();
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
  });

  setUp(() {
    ChatStorage.writeDraft(ChatStorage.draftKey(sessionId: 's1'), '');
    Hive.box<dynamic>('settings').delete('command_history_p1');
  });

  testWidgets('wide view: send pinned right, hint lists / and @ with tooltip', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    const hint = 'Enter to send • Shift+Enter newline • / commands • @ files';
    expect(find.text(hint), findsOneWidget);
    // The one-line 224px hint can ellipsize — a tooltip carries the full text.
    expect(find.byTooltip(hint), findsOneWidget);
    // Localized label on the submit button.
    expect(find.byTooltip('Send'), findsOneWidget);

    _expectSendPinnedRight(tester);
  });

  testWidgets('compact: real 400px pane keeps the button at the right edge', (tester) async {
    await tester.pumpWidget(_app(width: 400, paneWidth: 400));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.add), findsOneWidget); // compact `+` tools
    expect(tester.getSize(_promptBox()).width, 400);
    _expectSendPinnedRight(tester);
  });

  testWidgets('narrow pane in wide window: no overflow, send stays put', (tester) async {
    await tester.pumpWidget(_app(paneWidth: 340));
    await tester.pumpAndSettle();

    expect(tester.getSize(_promptBox()).width, 340);
    _expectSendPinnedRight(tester);
  });

  testWidgets('dense variant: hint hidden, send still pinned right', (tester) async {
    await tester.pumpWidget(_app(dense: true));
    await tester.pumpAndSettle();

    expect(find.textContaining('to send'), findsNothing);
    _expectSendPinnedRight(tester);
  });

  testWidgets('empty vs multiline draft: button edge unchanged, no overlap', (tester) async {
    for (final paneWidth in <double?>[null, 340]) {
      await tester.pumpWidget(_app(paneWidth: paneWidth));
      await tester.pumpAndSettle();
      _expectSendPinnedRight(tester);
      final emptyRight = tester.getRect(_sendButton()).right;

      await tester.enterText(find.byType(TextField), 'l1\nl2\nl3\nl4');
      await tester.pumpAndSettle();

      _expectSendPinnedRight(tester);
      expect(tester.getRect(_sendButton()).right, emptyRight);

      // The grown editor does not swallow the footer row: the send button
      // still sits strictly below the text field, not on top of it.
      final send = tester.getRect(_sendButton());
      final field = tester.getRect(find.byType(TextField));
      expect(send.top, greaterThanOrEqualTo(field.bottom));
    }
  });

  testWidgets('running session: stop and queue faces stay pinned right', (tester) async {
    final ws = _FakeWs();
    await tester.pumpWidget(_app(ws: ws));
    await tester.pumpAndSettle();

    // A `status` frame flips runStatus → the submit face becomes Stop.
    ws.inbound.add({'kind': 'status', 'sessionId': 's1'});
    await tester.pump();
    await tester.pump();
    expect(find.descendant(of: _sendButton(), matching: find.byIcon(Icons.stop)), findsOneWidget);
    _expectSendPinnedRight(tester);

    // Running + draft → the queue face; still pinned and collision-free.
    await tester.enterText(find.byType(TextField), 'next message');
    await tester.pump();
    expect(
      find.descendant(of: _sendButton(), matching: find.byIcon(Icons.arrow_upward)),
      findsOneWidget,
    );
    _expectSendPinnedRight(tester);
  });
}
