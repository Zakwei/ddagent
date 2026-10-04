import 'dart:io';
import 'dart:ui' show PointerDeviceKind;

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

SessionMessage _message(String id, {String? content}) => SessionMessage(
  id: id,
  sessionId: 's1',
  timestamp: '2025-01-01T00:00:00Z',
  provider: 'claude',
  kind: 'text',
  role: 'assistant',
  content: content ?? 'message $id',
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
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final dir = Directory('/tmp/ddagent_tap_scroll_repro');
    if (dir.existsSync()) dir.deleteSync(recursive: true);
    Hive.init(dir.path);
    await ChatStorage.init();
    await Hive.openBox<dynamic>('settings');
  });

  late ProviderContainer container;
  late SessionMessageStore store;

  Widget app() => UncontrolledProviderScope(
    container: container,
    child: TranslationProvider(
      child: MaterialApp(
        home: Scaffold(body: TranscriptView(sessionId: 's1')),
      ),
    ),
  );

  setUp(() async {
    await ChatStorage.init();
    container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(_dio()),
        chatChannelProvider.overrideWithValue(_Channel()),
        activityPollerProvider.overrideWith((ref) {}),
        quotaSnapshotProvider.overrideWith((ref) => const Stream<QuotaSnapshot?>.empty()),
      ],
    );
    store = container.read(sessionMessageStoreProvider.notifier);
  });

  tearDown(() => container.dispose());

  final list = find.byType(ScrollablePositionedList);

  double tailBottom(WidgetTester tester) {
    final els = find
        .descendant(
          of: list,
          matching: find.byWidgetPredicate((w) => w is SizedBox && w.height == 16.0),
        )
        .evaluate();
    if (els.isEmpty) return -1;
    return tester.getRect(find.byElementPredicate((e) => e == els.last)).bottom;
  }

  testWidgets('plain tap on message text while pinned does not move the transcript', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(app());
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    for (var i = 0; i < 30; i++) {
      store.appendRealtime('s1', _message('m$i', content: 'row $i ${'x ' * 20}'));
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));

    // Confirm settled & pinned.
    tester.binding.focusManager.primaryFocus?.unfocus();
    await tester.pump(const Duration(milliseconds: 100));
    expect(tailBottom(tester), tester.getRect(list).bottom);

    double dyOf(String s) {
      final f = find.textContaining(s, findRichText: true);
      return f.evaluate().isEmpty ? -1 : tester.getTopLeft(f.first).dy;
    }

    // A plain tap on an assistant message (pointer down+up, no drag).
    // EditableText (SelectableText) used to reveal the caret here and nudge
    // the whole list ~one row; SelectionArea + plain Text must not.
    final target = find.textContaining('row 29', findRichText: true).first;
    for (var i = 0; i < 4; i++) {
      await tester.tap(target, warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(dyOf('row 25'), 449.0);
    expect(dyOf('row 28'), 629.0);
    expect(dyOf('row 29'), 689.0);
    expect(tailBottom(tester), tester.getRect(list).bottom);
    expect(tester.takeException(), isNull);
  });

  testWidgets('drag on message text selects via the region', (tester) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(app());
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    for (var i = 0; i < 30; i++) {
      store.appendRealtime('s1', _message('m$i', content: 'row $i ${'x ' * 20}'));
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));
    tester.binding.focusManager.primaryFocus?.unfocus();
    await tester.pump(const Duration(milliseconds: 100));

    final p1 = tester.getCenter(find.textContaining('row 28', findRichText: true).first);
    final p2 = tester.getCenter(find.textContaining('row 29', findRichText: true).first);
    // Desktop path: mouse-drag selects text (touch-drag would scroll).
    await tester.dragFrom(p1, p2 - p1, kind: PointerDeviceKind.mouse);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final region = tester.state<SelectableRegionState>(find.byType(SelectableRegion));
    expect(region.selectionEndpoints, isNotEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('taps on padding and mid-viewport text do not move the list', (tester) async {
    tester.view.physicalSize = const Size(900, 900);
    tester.view.devicePixelRatio = 1;
    await tester.pumpWidget(app());
    await tester.pump(const Duration(milliseconds: 120));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    for (var i = 0; i < 30; i++) {
      store.appendRealtime('s1', _message('m$i', content: 'row $i ${'x ' * 20}'));
    }
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));
    tester.binding.focusManager.primaryFocus?.unfocus();
    await tester.pump(const Duration(milliseconds: 100));

    double dyOf(String s) {
      final f = find.textContaining(s, findRichText: true);
      return f.evaluate().isEmpty ? -1 : tester.getTopLeft(f.first).dy;
    }

    final listTop = tester.getRect(list).top;
    await tester.tapAt(Offset(8, listTop + 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(dyOf('row 25'), 449.0);
    expect(dyOf('row 29'), 689.0);
    expect(tailBottom(tester), tester.getRect(list).bottom);

    await tester.tapAt(const Offset(8, 700));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(dyOf('row 25'), 449.0);
    expect(dyOf('row 29'), 689.0);

    final mid = find.textContaining('row 26', findRichText: true);
    await tester.tap(mid.first, warnIfMissed: false);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(dyOf('row 25'), 449.0);
    expect(dyOf('row 29'), 689.0);
    expect(tailBottom(tester), tester.getRect(list).bottom);
    expect(tester.takeException(), isNull);
  });
}
