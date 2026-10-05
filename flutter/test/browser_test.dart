import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/browser_view_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/browser/view/browser_use_panel.dart';
import 'package:ddagent_app/features/browser/view/web_browser_pane.dart';
import 'package:ddagent_app/features/browser_use/data/browser_use_repository.dart';
import 'package:ddagent_app/features/browser_use/state/browser_use_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBrowserRepo extends BrowserUseRepository {
  _FakeBrowserRepo() : super(Dio());

  final calls = <String>[];
  bool available = false;
  bool emptySessions = false;
  Object? opError;

  @override
  Future<BrowserUseStatus> status() async => BrowserUseStatus(
    enabled: true,
    available: available,
    runtime: 'chromium',
    playwrightInstalled: available,
    chromiumInstalled: available,
    sessionCount: 2,
    message: available ? 'Runtime ready' : 'Install needed',
  );

  @override
  Future<List<BrowserUseSession>> sessions() async => emptySessions
      ? const []
      : const [
          BrowserUseSession(
            id: 's1',
            status: 'ready',
            url: 'https://example.com/app',
            title: 'Test App',
          ),
          BrowserUseSession(id: 's2', status: 'stopped', url: 'https://example.com/docs'),
        ];

  @override
  Future<BrowserUseStatus> installRuntime() async {
    calls.add('install');
    available = true;
    return status();
  }

  @override
  Future<void> stopSession(String id) async {
    if (opError != null) throw opError!;
    calls.add('stop:$id');
  }

  @override
  Future<void> deleteSession(String id) async {
    if (opError != null) throw opError!;
    calls.add('delete:$id');
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
  Future<void> close() async => _statesCtl.add(WsState.closed);

  void emit(Map<String, dynamic> raw) => _framesCtl.add(raw);
}

extension on WidgetTester {
  Future<void> emitAndPump(_FakeWs ws, Map<String, dynamic> raw) async {
    await runAsync(() async {
      ws.emit(raw);
      await Future<void>.delayed(Duration.zero);
    });
    await pump();
  }
}

// 1x1 valid PNG image standing in for a decoded frame in tests.
final _testFramePng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

void main() {
  group('1. Testy jednostkowe BrowserUseController', () {
    late _FakeBrowserRepo repo;
    late ProviderContainer container;

    setUp(() {
      repo = _FakeBrowserRepo();
      container = ProviderContainer(
        overrides: [browserUseRepositoryProvider.overrideWithValue(repo)],
      );
      container.listen(browserUseProvider, (_, _) {});
    });

    tearDown(() => container.dispose());

    test('modele dekodują status oraz sesje z JSON', () {
      final status = BrowserUseStatus.fromJson({
        'enabled': true,
        'available': true,
        'runtime': 'chromium',
        'playwrightInstalled': true,
        'chromiumInstalled': true,
        'sessionCount': 3,
        'message': 'OK',
      });
      expect(status.enabled, isTrue);
      expect(status.available, isTrue);
      expect(status.runtime, 'chromium');
      expect(status.sessionCount, 3);
      expect(status.message, 'OK');

      final activeSession = BrowserUseSession.fromJson({
        'id': 'sess-1',
        'status': 'ready',
        'url': 'https://github.com',
        'title': 'GitHub',
      });
      expect(activeSession.id, 'sess-1');
      expect(activeSession.isRunning, isTrue);

      final stoppedSession = BrowserUseSession.fromJson({'id': 'sess-2', 'status': 'stopped'});
      expect(stoppedSession.isRunning, isFalse);
    });

    test('refresh pobiera status runtime oraz listę sesji', () async {
      await container.read(browserUseProvider.notifier).refresh();
      final state = container.read(browserUseProvider);

      expect(state.sessions.length, 2);
      expect(state.runtimeReady, isFalse);
      expect(state.status?.sessionCount, 2);
    });

    test('installRuntime uruchamia instalację i aktualizuje status na gotowy', () async {
      final success = await container.read(browserUseProvider.notifier).installRuntime();
      expect(success, isTrue);
      expect(repo.calls, contains('install'));

      await Future<void>.delayed(Duration.zero);
      final state = container.read(browserUseProvider);
      expect(state.status?.available, isTrue);
      expect(state.runtimeReady, isTrue);
    });

    test('stopSession oraz deleteSession wywołują odpowiednie metody repozytorium', () async {
      final ctrl = container.read(browserUseProvider.notifier);
      final stopped = await ctrl.stopSession('s1');
      final deleted = await ctrl.deleteSession('s2');

      expect(stopped, isTrue);
      expect(deleted, isTrue);
      expect(repo.calls, containsAll(['stop:s1', 'delete:s2']));
    });

    test('błąd operacji ustawia komunikat w error i resetuje flagę busy', () async {
      final ctrl = container.read(browserUseProvider.notifier);
      repo.opError = const ServerError('Failed to stop browser session', 500);

      final result = await ctrl.stopSession('s1');
      expect(result, isFalse);

      final state = container.read(browserUseProvider);
      expect(state.busy, isFalse);
      expect(state.error, 'Failed to stop browser session');
    });
  });

  group('2. Testy BrowserViewChannel', () {
    late _FakeWs ws;
    late BrowserViewChannel channel;

    setUp(() {
      ws = _FakeWs();
      channel = BrowserViewChannel(ws)..start();
    });

    tearDown(() async {
      await channel.dispose();
    });

    test('odbieranie ramek: frame, navigation, ready, error', () async {
      final receivedFrames = <BrowserViewFrame>[];
      final sub = channel.frames.listen(receivedFrames.add);

      ws.emit({'type': 'ready', 'sessionId': 'session-xyz'});
      ws.emit({'type': 'frame', 'data': 'base64-data', 'width': 1024, 'height': 768});
      ws.emit({
        'type': 'navigation',
        'url': 'https://flutter.dev',
        'title': 'Flutter Dev',
        'canGoBack': true,
        'canGoForward': false,
        'loading': false,
      });
      ws.emit({'type': 'error', 'error': 'Browser crashed'});

      await Future<void>.delayed(Duration.zero);

      expect(receivedFrames.length, 4);

      // 1. ready
      expect(receivedFrames[0].isReady, isTrue);
      expect(receivedFrames[0].sessionId, 'session-xyz');

      // 2. frame
      expect(receivedFrames[1].isFrame, isTrue);
      expect(receivedFrames[1].raw['width'], 1024);
      expect(receivedFrames[1].raw['height'], 768);

      // 3. navigation
      expect(receivedFrames[2].isNavigation, isTrue);
      expect(receivedFrames[2].raw['url'], 'https://flutter.dev');
      expect(receivedFrames[2].raw['title'], 'Flutter Dev');
      expect(receivedFrames[2].raw['canGoBack'], isTrue);

      // 4. error
      expect(receivedFrames[3].isError, isTrue);
      expect(receivedFrames[3].error, 'Browser crashed');

      await sub.cancel();
    });

    test('wysyłanie poleceń nawigacji', () {
      channel.startView(url: 'https://example.com', width: 1280, height: 720);
      expect(ws.sent.last, {
        'type': 'start',
        'url': 'https://example.com',
        'width': 1280,
        'height': 720,
      });

      channel.navigate('https://dart.dev');
      expect(ws.sent.last, {'type': 'navigate', 'url': 'https://dart.dev'});

      channel.back();
      expect(ws.sent.last, {'type': 'back'});

      channel.forward();
      expect(ws.sent.last, {'type': 'forward'});

      channel.reload();
      expect(ws.sent.last, {'type': 'reload'});

      channel.stop();
      expect(ws.sent.last, {'type': 'stop'});

      channel.resizeView(1920, 1080);
      expect(ws.sent.last, {'type': 'resize', 'width': 1920, 'height': 1080});

      channel.closeView();
      expect(ws.sent.last, {'type': 'close'});
    });

    test('wysyłanie zdarzeń myszy z prawidłowymi parametrami', () {
      // move
      channel.mouse('move', x: 0.45, y: 0.55);
      expect(ws.sent.last, {'type': 'mouse', 'event': 'move', 'x': 0.45, 'y': 0.55});

      // down
      channel.mouse('down', x: 0.2, y: 0.8, button: 'left');
      expect(ws.sent.last, {
        'type': 'mouse',
        'event': 'down',
        'x': 0.2,
        'y': 0.8,
        'button': 'left',
      });

      // up
      channel.mouse('up', x: 0.2, y: 0.8, button: 'left');
      expect(ws.sent.last, {'type': 'mouse', 'event': 'up', 'x': 0.2, 'y': 0.8, 'button': 'left'});

      // wheel
      channel.mouse('wheel', x: 0.5, y: 0.5, deltaY: 100.0);
      expect(ws.sent.last, {
        'type': 'mouse',
        'event': 'wheel',
        'x': 0.5,
        'y': 0.5,
        'deltaY': 100.0,
      });
    });

    test('wysyłanie zdarzeń klawiatury z kodem klawisza i modyfikatorami CDP', () {
      // keydown Enter
      channel.key('down', key: 'Enter', code: 'Enter', keyCode: 13);
      expect(ws.sent.last, {
        'type': 'key',
        'event': 'down',
        'key': 'Enter',
        'code': 'Enter',
        'keyCode': 13,
      });

      // keyup znak 'a' z wciśniętym Ctrl (modifier 2)
      channel.key('up', key: 'a', code: 'KeyA', keyCode: 65, text: 'a', modifiers: 2);
      expect(ws.sent.last, {
        'type': 'key',
        'event': 'up',
        'key': 'a',
        'code': 'KeyA',
        'keyCode': 65,
        'text': 'a',
        'modifiers': 2,
      });
    });
  });

  group('3. Testy widgetowe WebBrowserPane & RemoteBrowserView', () {
    late _FakeWs ws;
    late BrowserViewChannel channel;

    Widget buildApp({String? url, ValueChanged<String>? onUrlChange}) => TranslationProvider(
      child: ProviderScope(
        overrides: [browserViewChannelProvider.overrideWithValue(channel)],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: WebBrowserPane(url: url, onUrlChange: onUrlChange),
          ),
        ),
      ),
    );

    setUp(() {
      ws = _FakeWs();
      channel = BrowserViewChannel(ws)..start();
    });

    testWidgets('renderowanie kontrolek paska nawigacji i inicjalizacja połączenia', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp(url: 'https://ddagent.local'));
      await tester.pumpAndSettle();

      // Kontrolki nawigacyjne
      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Komunikat łączenia
      expect(find.text('Connecting to browser…'), findsOneWidget);

      // Start wysłany przez kanał WS
      expect(ws.sent, contains(predicate<Map<String, dynamic>>((m) => m['type'] == 'start')));

      // Serwer odpowiada 'ready'
      await tester.emitAndPump(ws, {'type': 'ready', 'sessionId': 'sess-100'});
      await tester.pumpAndSettle();
      expect(find.text('Connecting to browser…'), findsNothing);
    });

    testWidgets('wprowadzenie adresu URL i submit wysyła navigate oraz wywołuje onUrlChange', (
      tester,
    ) async {
      String? changedUrl;
      await tester.pumpWidget(buildApp(onUrlChange: (u) => changedUrl = u));
      await tester.pumpAndSettle();
      await tester.emitAndPump(ws, {'type': 'ready', 'sessionId': 'sess-100'});
      await tester.pumpAndSettle();

      // Wpisanie adresu bez protokołu https
      await tester.enterText(find.byType(TextField), 'google.com');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // Normalizacja do https://
      expect(
        ws.sent,
        contains(
          predicate<Map<String, dynamic>>(
            (m) => m['type'] == 'navigate' && m['url'] == 'https://google.com',
          ),
        ),
      );

      // Symulacja potwierdzenia nawigacji z serwera
      await tester.emitAndPump(ws, {
        'type': 'navigation',
        'url': 'https://google.com',
        'title': 'Google',
      });
      await tester.pumpAndSettle();
      expect(changedUrl, 'https://google.com');
    });

    testWidgets('ramka nawigacji aktualizuje tytuł oraz włącza przyciski wstecz i odśwież', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await tester.emitAndPump(ws, {'type': 'ready', 'sessionId': 'sess-100'});

      await tester.emitAndPump(ws, {
        'type': 'navigation',
        'url': 'https://pub.dev',
        'title': 'Dart packages',
        'canGoBack': true,
        'canGoForward': false,
        'loading': false,
      });
      await tester.pumpAndSettle();

      expect(find.text('Dart packages'), findsOneWidget);

      // Przycisk wstecz staje się aktywny
      final backButton = tester.widget<IconButton>(
        find.ancestor(of: find.byIcon(Icons.arrow_back), matching: find.byType(IconButton)),
      );
      expect(backButton.onPressed, isNotNull);

      await tester.tap(find.byIcon(Icons.arrow_back));
      expect(ws.sent, contains(predicate<Map<String, dynamic>>((m) => m['type'] == 'back')));

      // Przycisk odśwież wysyła reload
      await tester.tap(find.byIcon(Icons.refresh));
      expect(ws.sent, contains(predicate<Map<String, dynamic>>((m) => m['type'] == 'reload')));
    });

    testWidgets('renderowanie klatki JPEG i wysyłanie znormalizowanych kliknięć myszy', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      await tester.emitAndPump(ws, {'type': 'ready', 'sessionId': 'sess-100'});

      // Emisja klatki
      await tester.emitAndPump(ws, {
        'type': 'frame',
        'data': base64Encode(_testFramePng),
        'width': 800,
        'height': 600,
      });
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget);

      // Kliknięcie w centrum widoku klatki
      final center = tester.getCenter(find.byType(Image));
      await tester.tapAt(center);
      await tester.pumpAndSettle();

      final mouseDownEvents = ws.sent.where((m) => m['type'] == 'mouse' && m['event'] == 'down');
      expect(mouseDownEvents, isNotEmpty);

      // Znormalizowana współrzędna x powinna oscylować wokół 0.5
      final lastDown = mouseDownEvents.last;
      expect((lastDown['x'] as num).abs() - 0.5, inInclusiveRange(-0.15, 0.15));
      expect(lastDown['button'], 'left');

      final mouseUpEvents = ws.sent.where((m) => m['type'] == 'mouse' && m['event'] == 'up');
      expect(mouseUpEvents, isNotEmpty);
    });

    testWidgets('błąd krytyczny przeglądarki wyświetla komunikat i przycisk Retry', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.emitAndPump(ws, {
        'type': 'error',
        'error': 'Remote browser process exited unexpectedly',
      });
      await tester.pumpAndSettle();

      expect(find.text('Remote browser process exited unexpectedly'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });

  group('4. Testy widgetowe BrowserUsePanel', () {
    late _FakeBrowserRepo repo;

    Widget buildPanel() => TranslationProvider(
      child: ProviderScope(
        overrides: [browserUseRepositoryProvider.overrideWithValue(repo)],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: BrowserUsePanel()),
        ),
      ),
    );

    setUp(() {
      repo = _FakeBrowserRepo();
    });

    testWidgets('nagłówek z badgem runtime, liczniki i lista sesji w aside', (tester) async {
      await tester.pumpWidget(buildPanel());
      await tester.pumpAndSettle();

      // Header + runtime badge (enabled, ale runtime nie jest gotowy)
      expect(find.text('Browser'), findsOneWidget);
      expect(find.text('Setup required'), findsOneWidget);

      // Pasek liczników
      expect(find.text('1 active / 2 total'), findsOneWidget);

      // Aside: lista sesji + metadane wybranej (domyślnie pierwsza)
      expect(find.text('Sessions'), findsOneWidget);
      expect(find.text('2 total'), findsOneWidget);
      expect(find.text('Test App'), findsWidgets);
      expect(find.text('Status'), findsOneWidget);
      expect(find.text('ready'), findsWidgets);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Temporary'), findsOneWidget);
    });

    testWidgets('wybór sesji, stop oraz delete z confirm dialogiem', (tester) async {
      await tester.pumpWidget(buildPanel());
      await tester.pumpAndSettle();

      // Stop z karty meta wybranej sesji (s1 jest running)
      await tester.tap(find.text('Stop').first);
      await tester.pumpAndSettle();
      expect(repo.calls, contains('stop:s1'));

      // Delete otwiera dialog potwierdzenia
      await tester.tap(find.text('Delete').first);
      await tester.pumpAndSettle();
      expect(find.text('Delete browser session?'), findsOneWidget);
      await tester.tap(find.widgetWithText(AppButton, 'Delete').last);
      await tester.pumpAndSettle();
      expect(repo.calls, contains('delete:s1'));

      // Wybór drugiej sesji przełącza widok
      await tester.tap(find.text('example.com').first);
      await tester.pumpAndSettle();
      expect(find.text('stopped'), findsWidgets);
    });

    testWidgets('pusty stan: install runtime + karty promptów', (tester) async {
      repo.emptySessions = true;
      await tester.pumpWidget(buildPanel());
      await tester.pumpAndSettle();

      expect(find.text('No browser sessions yet'), findsOneWidget);
      expect(find.text('Runtime setup required'), findsOneWidget);
      expect(find.text('Prompt'), findsNWidgets(2));

      await tester.tap(find.text('Install Runtime'));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('install'));
    });
  });
}
