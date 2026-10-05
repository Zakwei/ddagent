import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/network/auth_token_store.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/preview/data/preview_repository.dart';
import 'package:ddagent_app/features/preview/state/preview_controller.dart';
import 'package:ddagent_app/features/preview/view/preview_pane.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
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

  final calls = <String?>[];
  List<ListeningPort> rows = const [
    ListeningPort(port: 3000, address: '127.0.0.1', processName: 'vite', pid: 1, cwd: '/p1'),
    ListeningPort(port: 8080, address: '0.0.0.0', processName: 'node', pid: 2, cwd: '/p1'),
  ];
  Object? failure;

  @override
  Future<List<ListeningPort>> ports({String? projectPath}) async {
    calls.add(projectPath);
    if (failure != null) throw failure!;
    return rows;
  }
}

Widget _buildPreviewPaneApp(_FakePreviewRepo repo, {String? projectPath}) => TranslationProvider(
  child: ProviderScope(
    overrides: [
      previewRepositoryProvider.overrideWithValue(repo),
      serverBaseUrlProvider.overrideWithValue('http://srv:10087'),
      authTokenStoreProvider.overrideWithValue(AuthTokenStore(storage: _FakeKv('token-123'))),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: PreviewPane(projectPath: projectPath)),
    ),
  ),
);

void main() {
  group('1. Testy jednostkowe PreviewController', () {
    late _FakePreviewRepo repo;
    late ProviderContainer container;

    setUp(() {
      repo = _FakePreviewRepo();
      container = ProviderContainer(
        overrides: [
          previewRepositoryProvider.overrideWithValue(repo),
          serverBaseUrlProvider.overrideWithValue('http://srv:10087'),
          authTokenStoreProvider.overrideWithValue(
            AuthTokenStore(storage: _FakeKv('test-jwt-token')),
          ),
        ],
      );
      container.listen(previewProvider('/p1'), (_, _) {});
    });

    tearDown(() => container.dispose());

    test('ListeningPort dekoduje pola z JSON', () {
      final port = ListeningPort.fromJson({
        'port': 5432,
        'address': '127.0.0.1',
        'processName': 'postgres',
        'pid': 99,
        'cwd': '/projects/db',
      });

      expect(port.port, 5432);
      expect(port.address, '127.0.0.1');
      expect(port.processName, 'postgres');
      expect(port.pid, 99);
      expect(port.cwd, '/projects/db');
    });

    test('refresh pobiera porty z filtrem projectPath i automatycznie wybiera pierwszy', () async {
      await container.read(previewProvider('/p1').notifier).refresh();
      final state = container.read(previewProvider('/p1'));

      expect(repo.calls, contains('/p1'));
      expect(state.ports.length, 2);
      expect(state.selectedPort?.port, 3000);
      expect(state.selectedPort?.processName, 'vite');
      expect(state.loading, isFalse);
      expect(state.error, isNull);
    });

    test('selectPort przełącza port, a kolejny refresh utrzymuje wybór', () async {
      final ctrl = container.read(previewProvider('/p1').notifier);
      await ctrl.refresh();

      ctrl.selectPort(8080);
      expect(container.read(previewProvider('/p1')).selectedPort?.port, 8080);

      await ctrl.refresh();
      expect(container.read(previewProvider('/p1')).selectedPort?.port, 8080);
    });

    test('zniknięcie wybranego portu przywraca pierwszy dostępny lub null', () async {
      final ctrl = container.read(previewProvider('/p1').notifier);
      await ctrl.refresh();
      ctrl.selectPort(8080);

      repo.rows = const [ListeningPort(port: 3000, address: '127.0.0.1')];
      await ctrl.refresh();
      expect(container.read(previewProvider('/p1')).selectedPort?.port, 3000);

      repo.rows = const [];
      await ctrl.refresh();
      expect(container.read(previewProvider('/p1')).selectedPort, isNull);
    });

    test('obsługa błędów API podczas refresh ustawia stan error i loading = false', () async {
      final ctrl = container.read(previewProvider('/p1').notifier);
      repo.failure = const ServerError('Failed to scan ports', 500);

      await ctrl.refresh();
      final state = container.read(previewProvider('/p1'));

      expect(state.loading, isFalse);
      expect(state.error, 'Failed to scan ports');
    });

    test('proxyUrl buduje poprawny URL proxy z tokenem uwierzytelniającym', () async {
      final ctrl = container.read(previewProvider('/p1').notifier);
      await ctrl.refresh();

      final defaultUrl = await ctrl.proxyUrl();
      expect(defaultUrl.toString(), 'http://srv:10087/api/preview/3000/?token=test-jwt-token');

      final customUrl = await ctrl.proxyUrl(port: 8080, path: '/app/index.html');
      expect(
        customUrl.toString(),
        'http://srv:10087/api/preview/8080/app/index.html?token=test-jwt-token',
      );

      final withQuery = await ctrl.proxyUrl(port: 8080, path: '/test?mode=dark');
      expect(
        withQuery.toString(),
        'http://srv:10087/api/preview/8080/test?mode=dark&token=test-jwt-token',
      );
    });
  });

  group('2. Testy widgetowe PreviewPane', () {
    testWidgets('renderowanie listy wykrytych portów i domyślny wybór', (tester) async {
      final repo = _FakePreviewRepo();
      await tester.pumpWidget(_buildPreviewPaneApp(repo, projectPath: '/p1'));
      await tester.pumpAndSettle();

      expect(find.text(':3000 — vite'), findsOneWidget);
      expect(find.byIcon(Icons.public), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.open_in_new), findsOneWidget);

      // Desktop fallback informuje o proxy URL
      expect(find.text('Embedded preview is available on the web build'), findsOneWidget);
      expect(find.text('http://srv:10087/api/preview/3000/?token=token-123'), findsOneWidget);
    });

    testWidgets('zmiana wybranego portu w kontrolce dropdown', (tester) async {
      final repo = _FakePreviewRepo();
      await tester.pumpWidget(_buildPreviewPaneApp(repo, projectPath: '/p1'));
      await tester.pumpAndSettle();

      expect(find.text(':3000 — vite'), findsOneWidget);

      // Otwórz dropdown i wybierz port 8080
      await tester.tap(find.text(':3000 — vite'));
      await tester.pumpAndSettle();

      expect(find.text(':8080 — node'), findsWidgets);
      await tester.tap(find.text(':8080 — node').last);
      await tester.pumpAndSettle();

      expect(find.text('http://srv:10087/api/preview/8080/?token=token-123'), findsOneWidget);
    });

    testWidgets('pusty stan gdy brak aktywnych dev serwerów', (tester) async {
      final repo = _FakePreviewRepo()..rows = const [];
      await tester.pumpWidget(_buildPreviewPaneApp(repo, projectPath: '/p1'));
      await tester.pumpAndSettle();

      expect(find.text('No dev servers detected'), findsWidgets);
      expect(find.byIcon(Icons.public_off), findsOneWidget);
      expect(find.textContaining('Start a dev server (npm run dev'), findsOneWidget);
    });

    testWidgets('stan błędu renderuje komunikat i przycisk Retry', (tester) async {
      final repo = _FakePreviewRepo()
        ..rows = const []
        ..failure = const ServerError('Connection to preview service failed', 503);

      await tester.pumpWidget(_buildPreviewPaneApp(repo, projectPath: '/p1'));
      await tester.pumpAndSettle();

      expect(find.text('Connection to preview service failed'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);

      // Ponowna próba po naprawie błędu
      repo
        ..failure = null
        ..rows = const [ListeningPort(port: 5173, processName: 'vite')];

      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      expect(find.text(':5173 — vite'), findsOneWidget);
    });

    testWidgets('kliknięcie ikony odświeżenia przeładowuje podgląd', (tester) async {
      final repo = _FakePreviewRepo();
      await tester.pumpWidget(_buildPreviewPaneApp(repo, projectPath: '/p1'));
      await tester.pumpAndSettle();

      final refreshBtn = find.byTooltip('Reload preview');
      expect(refreshBtn, findsOneWidget);

      await tester.tap(refreshBtn);
      await tester.pumpAndSettle();

      expect(find.text(':3000 — vite'), findsOneWidget);
    });
  });
}
