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
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// A pane restored from another server points at a session this server does
/// not have: the pane explains it and offers the picker, not a raw error.
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

void main() {
  setUpAll(() async {
    final dir = Directory('/tmp/ddagent_transcript_session_missing_test');
    if (dir.existsSync()) dir.deleteSync(recursive: true);
    Hive.init(dir.path);
    await ChatStorage.init();
    await Hive.openBox<dynamic>('settings');
  });

  testWidgets('a session the server does not know shows the missing state with a picker action', (
    tester,
  ) async {
    final dio = Dio(BaseOptions(baseUrl: 'http://test'))
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (o, h) => h.reject(
            DioException(
              requestOptions: o,
              type: DioExceptionType.badResponse,
              response: Response(
                requestOptions: o,
                statusCode: 404,
                data: {
                  'success': false,
                  'error': {'code': 'NOT_FOUND', 'message': 'Session "s-gone" was not found.'},
                },
              ),
            ),
          ),
        ),
      );
    final inbound = StreamController<Map<String, dynamic>>.broadcast();
    final container = ProviderContainer(
      overrides: [
        dioProvider.overrideWithValue(dio),
        chatChannelProvider.overrideWithValue(_Channel(inbound)..start()),
        activityPollerProvider.overrideWith((ref) {}),
        quotaSnapshotProvider.overrideWith((ref) => const Stream<QuotaSnapshot?>.empty()),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await inbound.close();
    });

    var picked = 0;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: TranscriptView(sessionId: 's-gone', onSessionMissing: () => picked++),
            ),
          ),
        ),
      ),
    );
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    final t = AppLocale.en.translations.chat.session.missing;
    expect(find.text(t.message), findsOneWidget);
    expect(find.textContaining('was not found'), findsNothing);
    await tester.tap(find.text(t.action));
    expect(picked, 1);

    // Unmount and let the pane's deferred work (presence, polls) run out.
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(minutes: 1));
  });
}
