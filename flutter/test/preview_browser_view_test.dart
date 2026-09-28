import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/network/auth_token_store.dart';
import 'package:ddagent_app/core/realtime/browser_view_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/browser/view/remote_browser_view.dart';
import 'package:ddagent_app/features/preview/data/preview_repository.dart';
import 'package:ddagent_app/features/preview/view/preview_pane.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeKv implements SecureKv {
  _FakeKv([this.v]);
  String? v;
  @override
  Future<String?> read(String key) async => v;
  @override
  Future<void> write(String key, String value) async => v = value;
  @override
  Future<void> delete(String key) async => v = null;
}

class _FakePreviewRepo extends PreviewRepository {
  _FakePreviewRepo() : super(Dio());

  List<ListeningPort> rows = const [
    ListeningPort(port: 3000, address: '127.0.0.1', processName: 'vite'),
    ListeningPort(port: 8080, address: '0.0.0.0'),
  ];
  Object? failure;

  @override
  Future<List<ListeningPort>> ports({String? projectPath}) async {
    if (failure != null) throw failure!;
    return rows;
  }
}

class _FakeWs extends WsClient {
  _FakeWs() : super(urlBuilder: () async => Uri.parse('ws://test'));

  final sent = <Map<String, dynamic>>[];
  final _framesCtl = StreamController<Map<String, dynamic>>.broadcast();
  final _statesCtl = StreamController<WsState>.broadcast();

  @override
  Stream<Map<String, dynamic>> get frames => _framesCtl.stream;
  @override
  Stream<WsState> get states => _statesCtl.stream;

  @override
  void send(Map<String, dynamic> frame) => sent.add(frame);

  @override
  Future<void> connect() async => _statesCtl.add(WsState.open);
  @override
  Future<void> close() async {}

  void emit(Map<String, dynamic> raw) => _framesCtl.add(raw);
}

extension on WidgetTester {
  /// Broadcast controllers dispatch on the real event loop — `runAsync` lets
  /// the queued frame reach the widget, then a pump rebuilds it.
  Future<void> emitAndPump(_FakeWs ws, Map<String, dynamic> raw) async {
    await runAsync(() async {
      ws.emit(raw);
      await Future<void>.delayed(Duration.zero);
    });
    await pump();
  }
}

Widget _previewApp(_FakePreviewRepo repo) => ProviderScope(
  overrides: [
    previewRepositoryProvider.overrideWithValue(repo),
    serverBaseUrlProvider.overrideWithValue('http://srv:10087'),
    authTokenStoreProvider.overrideWithValue(
      AuthTokenStore(storage: _FakeKv('a.b.c')),
    ),
  ],
  child: MaterialApp(
    theme: AppTheme.light(),
    home: const Scaffold(body: PreviewPane()),
  ),
);

// 1x1 white PNG — decodable bytes standing in for a JPEG frame in tests.
final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

void main() {
  group('PreviewPane', () {
    testWidgets('lists detected ports and selects the first', (tester) async {
      await tester.pumpWidget(_previewApp(_FakePreviewRepo()));
      await tester.pumpAndSettle();
      expect(find.text(':3000 — vite'), findsOneWidget);
      await tester.tap(find.text(':3000 — vite'));
      await tester.pumpAndSettle();
      expect(find.text(':8080'), findsOneWidget);
      // Non-web platform → embed fallback hint with the proxy URL.
      expect(
        find.text('Embedded preview is available on the web build'),
        findsOneWidget,
      );
      expect(
        find.text('http://srv:10087/api/preview/3000/?token=a.b.c'),
        findsOneWidget,
      );
    });

    testWidgets('empty state when no servers are detected', (tester) async {
      final repo = _FakePreviewRepo()..rows = const [];
      await tester.pumpWidget(_previewApp(repo));
      await tester.pumpAndSettle();
      expect(find.text('No dev servers detected'), findsWidgets);
    });

    testWidgets('error state shows retry', (tester) async {
      final repo = _FakePreviewRepo()
        ..rows = const []
        ..failure = const ServerError('boom', 500);
      await tester.pumpWidget(_previewApp(repo));
      await tester.pumpAndSettle();
      expect(find.text('Retry'), findsOneWidget);
      // Retry clears the failure path — a successful refresh re-lists ports.
      repo
        ..failure = null
        ..rows = const [ListeningPort(port: 3000)];
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();
      expect(find.text(':3000'), findsWidgets);
    });
  });

  group('RemoteBrowserView', () {
    late _FakeWs ws;
    late BrowserViewChannel channel;

    Widget app({String? url}) => ProviderScope(
      overrides: [browserViewChannelProvider.overrideWithValue(channel)],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: RemoteBrowserView(url: url)),
      ),
    );

    setUp(() {
      ws = _FakeWs();
      channel = BrowserViewChannel(ws)..start();
    });

    testWidgets('connects, sends start and renders ready state', (
      tester,
    ) async {
      await tester.pumpWidget(app(url: 'https://example.com'));
      await tester.pumpAndSettle();
      expect(
        ws.sent,
        contains(predicate<Map<String, dynamic>>((m) => m['type'] == 'start')),
      );
      await tester.emitAndPump(ws, {'type': 'ready', 'sessionId': 's1'});
      await tester.pumpAndSettle();
      expect(find.text('Connecting to browser…'), findsNothing);
    });

    testWidgets('navigation frames drive the toolbar', (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.emitAndPump(ws, {'type': 'ready', 'sessionId': 's1'});
      await tester.emitAndPump(ws, {
        'type': 'navigation',
        'url': 'https://dart.dev',
        'title': 'Dart',
        'canGoBack': true,
        'canGoForward': false,
        'loading': false,
      });
      await tester.pumpAndSettle();
      expect(find.text('Dart'), findsOneWidget);
      final back = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.arrow_back),
          matching: find.byType(IconButton),
        ),
      );
      expect(back.onPressed, isNotNull);
      await tester.tap(find.byIcon(Icons.arrow_back));
      expect(
        ws.sent,
        contains(predicate<Map<String, dynamic>>((m) => m['type'] == 'back')),
      );
    });

    testWidgets('decodes frames and forwards normalized pointer events', (
      tester,
    ) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.emitAndPump(ws, {'type': 'ready', 'sessionId': 's1'});
      await tester.emitAndPump(ws, {
        'type': 'frame',
        'data': base64Encode(_png),
        'width': 800,
        'height': 600,
      });
      await tester.pumpAndSettle();
      expect(find.byType(Image), findsOneWidget);

      final center = tester.getCenter(find.byType(Image));
      await tester.tapAt(center);
      await tester.pumpAndSettle();
      final down = ws.sent.where(
        (m) => m['type'] == 'mouse' && m['event'] == 'down',
      );
      expect(down, isNotEmpty);
      // Center of the frame normalizes to ~0.5.
      expect((down.last['x']! as num).abs() - 0.5, inInclusiveRange(-0.1, 0.1));
      expect(down.last['button'], 'left');
      expect(ws.sent.where((m) => m['event'] == 'up'), isNotEmpty);
    });

    testWidgets('address submit navigates', (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.emitAndPump(ws, {'type': 'ready', 'sessionId': 's1'});
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'dart.dev');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(
        ws.sent,
        contains(
          predicate<Map<String, dynamic>>(
            (m) => m['type'] == 'navigate' && m['url'] == 'https://dart.dev',
          ),
        ),
      );
    });

    testWidgets('fatal error stops the loop and offers retry', (tester) async {
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      await tester.emitAndPump(ws, {
        'type': 'error',
        'error': 'concurrent view cap reached',
      });
      await tester.pumpAndSettle();
      expect(find.text('concurrent view cap reached'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
