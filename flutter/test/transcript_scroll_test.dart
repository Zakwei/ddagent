import 'dart:io';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/chat/state/transcript_tools_controller.dart';
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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  String sessionId = 's1',
  String? content,
  String kind = 'text',
}) => SessionMessage(
  id: id,
  sessionId: sessionId,
  timestamp: '2025-01-01T00:00:00Z',
  provider: 'claude',
  kind: kind,
  role: 'assistant',
  content: content ?? 'message $id',
);

Dio _dio({List<dynamic> Function()? messagesPage}) =>
    Dio(BaseOptions(baseUrl: 'http://test'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) => handler.resolve(
            Response(
              requestOptions: options,
              data: options.path.endsWith('/messages')
                  ? {
                      'success': true,
                      'data': {
                        // offset 0 is the initial/latest tail fetch; older pages
                        // come back only when the caller pages backwards.
                        'messages': (options.queryParameters['offset'] ?? 0) == 0
                            ? <dynamic>[]
                            : messagesPage?.call() ?? <dynamic>[],
                        'total': 0,
                        // Keep hasMore true so the "load older" chrome row stays —
                        // removing it would shift the whole list in screen space.
                        'hasMore': (options.queryParameters['offset'] ?? 0) != 0,
                      },
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
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final dir = Directory('/tmp/ddagent_transcript_scroll_test');
    if (dir.existsSync()) dir.deleteSync(recursive: true);
    Hive.init(dir.path);
    await ChatStorage.init();
    await Hive.openBox<dynamic>('settings');
  });

  late ProviderContainer container;
  late SessionMessageStore store;
  List<dynamic> messagesPage = [];

  Widget app(String sessionId) => UncontrolledProviderScope(
    container: container,
    child: TranslationProvider(
      child: MaterialApp(
        home: Scaffold(body: TranscriptView(sessionId: sessionId)),
      ),
    ),
  );

  Future<void> mount(WidgetTester tester, {String sessionId = 's1', double width = 900}) async {
    tester.view.physicalSize = Size(width, 900);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(app(sessionId));
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }

  setUp(() async {
    await ChatStorage.init();
    messagesPage = [];
    container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(_dio(messagesPage: () => messagesPage)),
        chatChannelProvider.overrideWithValue(_Channel()),
        // The widget only watches this provider; keep the polling timer out of
        // widget tests so frame-idle assertions reflect transcript work.
        activityPollerProvider.overrideWith((ref) {}),
        quotaSnapshotProvider.overrideWith((ref) => const Stream<QuotaSnapshot?>.empty()),
      ],
    );
    store = container.read(sessionMessageStoreProvider.notifier);
  });

  tearDown(() => container.dispose());

  final list = find.byType(ScrollablePositionedList);

  /// The transcript's last item is a fixed 16px tail row; while pinned the
  /// correction loop jumpTo's it so its trailing edge sits at the viewport
  /// bottom. Rendered text alone can come from the row cache, so measure the
  /// tail row's actual screen coordinates.
  void expectTailPinned(WidgetTester tester) {
    final tail = find
        .descendant(
          of: list,
          matching: find.byWidgetPredicate((w) => w is SizedBox && w.height == 16.0),
        )
        .evaluate()
        .last;
    final tailBottom = tester.getRect(find.byElementPredicate((e) => e == tail)).bottom;
    // jumpTo alignment has sub-percent precision (~3px at 760px viewport) —
    // any real detach is hundreds of pixels off.
    expect(tailBottom, moreOrLessEquals(tester.getRect(list).bottom, epsilon: 6));
  }

  testWidgets('stays pinned for appended rows, streaming growth and resize', (tester) async {
    await mount(tester);
    // Fill past the viewport so pinning is observable: while pinned the jump
    // button is hidden and the tail row hugs the viewport's bottom edge.
    for (var i = 0; i < 20; i++) {
      store.appendRealtime('s1', _message('pin$i', content: 'pin row $i\n' * 3));
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(FloatingActionButton), findsNothing);
    expectTailPinned(tester);

    // Streaming deltas update the SAME row in place — the tail must keep
    // following as that row grows taller.
    store.updateStreaming('s1', 'chunk', 'claude');
    await tester.pump();
    store.updateStreaming('s1', List.filled(60, 'streamed text').join(' '), 'claude');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(FloatingActionButton), findsNothing);
    expectTailPinned(tester);

    // Status churn (stop/complete/resume) rebuilds the pane — still pinned.
    for (final status in ['stopped', 'completed', 'running']) {
      store.setStatus('s1', status);
      await tester.pump();
      expectTailPinned(tester);
    }
    expect(find.byType(FloatingActionButton), findsNothing);

    // Shrinking the viewport realigns the tail instead of detaching.
    tester.view.physicalSize = const Size(900, 760);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(FloatingActionButton), findsNothing);
    expectTailPinned(tester);

    // Closing the live row and appending after it — still pinned.
    store.finalizeStreaming('s1');
    store.appendRealtime('s1', _message('three'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(FloatingActionButton), findsNothing);
    expectTailPinned(tester);
  });

  testWidgets('expanding a thinking block keeps pin and detached anchor', (tester) async {
    await mount(tester);
    for (var i = 0; i < 35; i++) {
      store.appendRealtime(
        's1',
        _message(
          'think$i',
          kind: 'thinking',
          content: 'thought body $i ${List.filled(40, 'x').join(' ')}',
        ),
      );
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final label = find.text('Thought for a few seconds');
    expect(label, findsWidgets);

    // Only a fully-on-screen label is safely tappable — a clipped row's
    // center can sit outside the viewport and silently miss the InkWell.
    Element firstFullyVisible() {
      final bounds = tester.getRect(list);
      return label.evaluate().firstWhere((e) {
        final r = tester.getRect(find.byElementPredicate((x) => x == e));
        return r.top >= bounds.top && r.bottom <= bounds.bottom;
      });
    }

    // Pinned: expanding a row grows the transcript; the tail must realign
    // instead of leaving the expanded content clipped.
    await tester.tap(find.byElementPredicate((e) => e == firstFullyVisible()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('thought body', findRichText: true), findsWidgets);
    expect(find.byType(FloatingActionButton), findsNothing);
    expectTailPinned(tester);

    // Collapse it back so the detach lands on a predictable anchor.
    await tester.tap(find.byElementPredicate((e) => e == firstFullyVisible()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Detached: expanding a row BELOW the anchored first-visible row grows
    // content downward — the anchor's top edge must not move.
    await tester.drag(list, const Offset(0, 450));
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsOneWidget);
    final anchorDy = tester.getTopLeft(label.first).dy;
    await tester.tap(find.byElementPredicate((e) => e == firstFullyVisible()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.getTopLeft(label.first).dy, anchorDy);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('user scroll up detaches; bottom drag reattaches persistently', (tester) async {
    await mount(tester);
    for (var i = 0; i < 30; i++) {
      store.appendRealtime('s1', _message('m$i', content: 'line $i\n' * 4));
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(FloatingActionButton), findsNothing);

    // Positive dy drags content down — the viewport moves toward OLDER rows.
    await tester.drag(find.byType(ScrollablePositionedList), const Offset(0, 350));
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // New rows while detached: stay detached and count as unread.
    store.appendRealtime('s1', _message('while-detached'));
    await tester.pump();
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(
      find.descendant(of: find.byType(FloatingActionButton), matching: find.text('1')),
      findsOneWidget,
    );
    expect(find.text('message while-detached'), findsNothing);

    // Negative dy drags content up — past the bottom edge reattaches.
    await tester.drag(find.byType(ScrollablePositionedList), const Offset(0, -3000));
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.text('message while-detached'), findsOneWidget);

    // The reattach is sticky: later appends stay followed, not just the jump.
    store.appendRealtime('s1', _message('later'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.text('message later'), findsOneWidget);
  });

  testWidgets('detached reading retains visible message while rows update', (tester) async {
    await mount(tester);
    for (var i = 0; i < 35; i++) {
      store.appendRealtime('s1', _message('read$i', content: 'readable row $i'));
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.drag(find.byType(ScrollablePositionedList), const Offset(0, 450));
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsOneWidget);
    final before = find.textContaining('read');
    expect(before, findsWidgets);
    final visibleBefore = tester.getTopLeft(before.first).dy;
    store.appendRealtime('s1', _message('new-row'));
    await tester.pump();
    expect(find.text('readable row 0'), findsNothing);
    expect(tester.getTopLeft(before.first).dy, visibleBefore);
  });

  testWidgets('search pauses corrections, jumps to matches, then resumes', (tester) async {
    await mount(tester);
    for (var i = 0; i < 24; i++) {
      store.appendRealtime('s1', _message('find$i', content: 'needle$i body\n' * 3));
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    final tools = container.read(transcriptToolsProvider('s1').notifier);
    tools.openSearch();
    await tester.pump();

    // A match jump really moves the viewport, even though corrections pause.
    tools.onQueryChanged('needle');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('needle0'), findsWidgets);
    tools.goToMatch(10);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('needle10'), findsWidgets);
    expect(find.textContaining('needle23'), findsNothing);

    // Corrections stay paused while the box is open — no drift to the tail.
    store.appendRealtime('s1', _message('during-search'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('message during-search'), findsNothing);

    // Closing resumes the persistent follow: the tail realigns and the
    // jump button never appears.
    tools.closeSearch();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.text('message during-search'), findsOneWidget);
    store.appendRealtime('s1', _message('after-search'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.text('message after-search'), findsOneWidget);
  });

  testWidgets('load-older keeps the detached anchor; session switch resets', (tester) async {
    // An older page exists on the server; the /messages fetch returns it.
    messagesPage = [
      {
        'id': 'older',
        'timestamp': '2024-12-31T00:00:00Z',
        'provider': 'claude',
        'kind': 'text',
        'role': 'assistant',
        'content': 'older page row',
      },
    ];
    await mount(tester);
    // Seed the 20 rows as a persisted server page — loadOlder pages with
    // offset = serverMessages.length, so realtime rows alone would fetch
    // offset 0 (the tail endpoint).
    store.applyLatestPage(
      's1',
      [for (var i = 0; i < 20; i++) _message('switch$i', content: 'switch row $i\n' * 3)],
      total: 21,
      hasMore: true,
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.drag(find.byType(ScrollablePositionedList), const Offset(0, 350));
    await tester.pumpAndSettle();
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // The real _loadOlder path captures the first visible row; after the
    // prepend lands the anchored row must sit at the same viewport offset.
    // Row content renders through markdown (Text.rich/RichText), so match
    // rich text and re-find the same row by its row number.
    final anchorFinder = find.textContaining('switch row', findRichText: true);
    expect(anchorFinder, findsWidgets);
    String plainOf(Widget w) {
      if (w is Text) return w.data ?? w.textSpan?.toPlainText() ?? '';
      if (w is SelectableText) return w.data ?? w.textSpan?.toPlainText() ?? '';
      if (w is EditableText) return w.controller.text;
      if (w is RichText) return w.text.toPlainText();
      return '';
    }

    final anchorPattern = RegExp(r'switch row \d+');
    final anchorElement = anchorFinder.evaluate().firstWhere(
      (e) => anchorPattern.hasMatch(plainOf(e.widget)),
    );
    final anchorKey = anchorPattern.firstMatch(plainOf(anchorElement.widget))!.group(0)!;
    final anchorDy = tester.getTopLeft(find.byElementPredicate((e) => e == anchorElement)).dy;
    await tester.tap(find.text('Load older messages'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump();
    expect(container.read(sessionMessagesProvider('s1')).first.id, 'older');
    expect(
      tester.getTopLeft(find.textContaining(anchorKey, findRichText: true).first).dy,
      anchorDy,
    );
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Session switch: the detach state and any pending correction must not
    // leak into s2 — the new session follows its own tail.
    store.appendRealtime('s1', _message('trigger'));
    await tester.pump();
    await tester.pumpWidget(app('s2'));
    await tester.pump(const Duration(milliseconds: 120));
    for (var i = 0; i < 25; i++) {
      store.appendRealtime('s2', _message('s2-$i', sessionId: 's2', content: 'other row $i\n' * 3));
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.textContaining('other row 24'), findsWidgets);

    // Detach s2, then unmount mid-interaction: callbacks pending at dispose
    // die with the generation guard instead of firing on a dead state.
    await tester.drag(find.byType(ScrollablePositionedList), const Offset(0, 350));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.takeException(), isNull);
  });

  testWidgets('queued correction is invalidated by session switch and dispose', (tester) async {
    await mount(tester);
    for (var i = 0; i < 30; i++) {
      store.appendRealtime('s1', _message('q$i', content: 'queued row $i\n' * 4));
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // While FOLLOWING, a fresh append misaligns the tail: the positions
    // listener queues a post-frame correction (deferred to the NEXT frame),
    // so a scheduled frame proves a callback is in flight — not yet run.
    store.appendRealtime('s1', _message('pending', content: 'pending row\n' * 10));
    await tester.pump();
    expect(tester.binding.hasScheduledFrame, isTrue);

    // Switching sessions mid-queue bumps the scroll generation; the stale
    // callback must return without jumpTo-ing s2's fresh controller.
    await tester.pumpWidget(app('s2'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    for (var i = 0; i < 30; i++) {
      store.appendRealtime('s2', _message('s2-$i', sessionId: 's2', content: 'queued s2 $i\n' * 3));
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(FloatingActionButton), findsNothing);
    expectTailPinned(tester);
    expect(tester.takeException(), isNull);

    // The same queue, invalidated by dispose instead of a session swap —
    // the pending callback must hit the mounted/generation guard.
    store.appendRealtime(
      's2',
      _message('pending2', sessionId: 's2', content: 'pending again\n' * 10),
    );
    await tester.pump();
    expect(tester.binding.hasScheduledFrame, isTrue);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('settled transcript stops requesting frames', (tester) async {
    await mount(tester);
    store.appendRealtime('s1', _message('stable'));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    // The composer's focused input blinks on a Timer — that's ambient frame
    // scheduling, not transcript work. Drop focus so the only remaining
    // scheduler would be the correction loop.
    tester.binding.focusManager.primaryFocus?.unfocus();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    // The correction loop must terminate once the tail is aligned — a
    // perpetual ensureVisualUpdate would keep a frame scheduled forever.
    expect(tester.binding.hasScheduledFrame, isFalse);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(tester.binding.hasScheduledFrame, isFalse);
    expect(tester.takeException(), isNull);
  });
}
