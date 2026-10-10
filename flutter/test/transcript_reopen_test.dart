import 'dart:async';
import 'dart:io';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/features/chat/view/session_subheader.dart';
import 'package:ddagent_app/features/chat/view/transcript_view.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/state/activity_poller.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Closing a chat pane only unmounts its view — the transcript controller is
/// not auto-disposed and keeps receiving frames. Reopening the session in a
/// pane must still show its history, whatever happened to it meanwhile.
class _Ws extends WsClient {
  _Ws(this.inbound) : super(urlBuilder: () async => Uri.parse('ws://test'));

  final StreamController<Map<String, dynamic>> inbound;

  @override
  Stream<Map<String, dynamic>> get frames => inbound.stream;
  @override
  Stream<WsState> get states => const Stream.empty();
  @override
  WsState get state => WsState.closed;
  @override
  Future<void> connect() async {}
}

class _Channel extends ChatChannel {
  _Channel(StreamController<Map<String, dynamic>> inbound) : super(_Ws(inbound));
  @override
  Future<void> connect() async {}
}

Map<String, dynamic> _row(int i) => {
  'id': 'm$i',
  'timestamp': '2025-01-01T00:00:00Z',
  'provider': 'claude',
  'kind': 'text',
  'role': i.isEven ? 'user' : 'assistant',
  'content': 'hello row $i',
};

void main() {
  setUpAll(() async {
    final dir = Directory('/tmp/ddagent_transcript_reopen_test');
    if (dir.existsSync()) dir.deleteSync(recursive: true);
    Hive.init(dir.path);
    await ChatStorage.init();
    await Hive.openBox<dynamic>('settings');
  });

  late StreamController<Map<String, dynamic>> inbound;
  late ProviderContainer container;
  // The server answers with an empty, "authoritative" page while true — what
  // a transient read (file mid-rewrite, row not re-indexed yet) looks like.
  var emptyPage = false;

  // `/messages` calls with the history they answered, oldest first.
  final requests = <bool>[];

  Dio dio() => Dio(BaseOptions(baseUrl: 'http://test'))
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (o, h) {
          final isMessages = o.path.endsWith('/messages');
          if (isMessages) requests.add(emptyPage);
          h.resolve(
            Response(
              requestOptions: o,
              data: isMessages
                  ? {
                      'success': true,
                      'data': {
                        'messages': emptyPage
                            ? <dynamic>[]
                            : [for (var i = 0; i < 30; i++) _row(i)],
                        'total': emptyPage ? 0 : 4000,
                        'hasMore': !emptyPage,
                      },
                    }
                  : {
                      'success': true,
                      'data': {
                        'session': {'id': 's1', 'provider': 'claude'},
                      },
                    },
            ),
          );
        },
      ),
    );

  // Built inside each test body: a channel listening from `setUp` would sit
  // outside the test's fake-async zone and never see the frames it adds.
  void createContainer() {
    emptyPage = false;
    requests.clear();
    inbound = StreamController<Map<String, dynamic>>.broadcast();
    container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(dio()),
        chatChannelProvider.overrideWithValue(_Channel(inbound)..start()),
        activityPollerProvider.overrideWith((ref) {}),
        quotaSnapshotProvider.overrideWith((ref) => const Stream<QuotaSnapshot?>.empty()),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await inbound.close();
    });
  }

  Widget app({required bool open}) => UncontrolledProviderScope(
    container: container,
    child: TranslationProvider(
      child: MaterialApp(
        home: Scaffold(body: open ? const TranscriptView(sessionId: 's1') : const SizedBox()),
      ),
    ),
  );

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  Finder lastRow() => find.textContaining('hello row 29', findRichText: true);

  Future<void> openThenClose(WidgetTester tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    createContainer();
    await tester.pumpWidget(app(open: true));
    await settle(tester);
    expect(lastRow(), findsOneWidget);
    await tester.pumpWidget(app(open: false));
    await settle(tester);
  }

  testWidgets('an empty refresh page while the pane is closed keeps the history', (tester) async {
    await openThenClose(tester);

    // The file watcher's upsert refreshes the closed pane's tail.
    emptyPage = true;
    inbound.add({'kind': 'session_upserted', 'sessionId': 's1', 'provider': 'claude'});
    await settle(tester);
    expect(requests.last, isTrue, reason: 'the closed pane refreshed its tail');
    expect(container.read(sessionMessagesProvider('s1')), isNotEmpty);
    emptyPage = false;

    await tester.pumpWidget(app(open: true));
    await settle(tester);
    expect(lastRow(), findsOneWidget);
  });

  testWidgets('reopening a session whose history was dropped refetches it', (tester) async {
    await openThenClose(tester);

    container
        .read(sessionMessageStoreProvider.notifier)
        .replaceServerMessages('s1', const [], total: 0, hasMore: false);

    await tester.pumpWidget(app(open: true));
    await settle(tester);
    expect(lastRow(), findsOneWidget);
  });
}
