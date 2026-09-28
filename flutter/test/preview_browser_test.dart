import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/network/auth_token_store.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/browser/view/browser_use_panel.dart';
import 'package:ddagent_app/features/browser_use/data/browser_use_repository.dart';
import 'package:ddagent_app/features/browser_use/state/browser_use_controller.dart';
import 'package:ddagent_app/features/preview/data/preview_repository.dart';
import 'package:ddagent_app/features/preview/state/preview_controller.dart';
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
    ListeningPort(port: 3000, address: '127.0.0.1', pid: 1),
    ListeningPort(port: 8080, address: '0.0.0.0', pid: 2),
  ];

  @override
  Future<List<ListeningPort>> ports({String? projectPath}) async {
    calls.add(projectPath);
    return rows;
  }
}

class _FakeBrowserRepo extends BrowserUseRepository {
  _FakeBrowserRepo() : super(Dio());

  final calls = <String>[];
  bool available = false;
  Object? opError;

  @override
  Future<BrowserUseStatus> status() async => BrowserUseStatus(
        enabled: true,
        available: available,
        runtime: 'chromium',
        playwrightInstalled: available,
        chromiumInstalled: available,
        sessionCount: 1,
        message: available ? 'ok' : 'install needed',
      );

  @override
  Future<List<BrowserUseSession>> sessions() async => const [
        BrowserUseSession(id: 's1', status: 'ready', url: 'https://x'),
        BrowserUseSession(id: 's2', status: 'stopped'),
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

void main() {
  group('PreviewController', () {
    late _FakePreviewRepo repo;
    late ProviderContainer c;

    setUp(() {
      repo = _FakePreviewRepo();
      c = ProviderContainer(
        overrides: [
          previewRepositoryProvider.overrideWithValue(repo),
          serverBaseUrlProvider.overrideWithValue('http://srv:10087'),
          authTokenStoreProvider.overrideWithValue(
            AuthTokenStore(storage: _FakeKv('a.b.c')),
          ),
        ],
      );
      c.listen(previewProvider('/p1'), (_, _) {});
    });

    tearDown(() => c.dispose());

    test('ListeningPort dekoduje wiersz', () {
      final p = ListeningPort.fromJson({'port': 5432, 'pid': 9, 'cwd': '/x'});
      expect(p.port, 5432);
      expect(p.cwd, '/x');
    });

    test('refresh pobiera porty z filtrem projectPath i auto-select', () async {
      await c.read(previewProvider('/p1').notifier).refresh();
      final s = c.read(previewProvider('/p1'));
      expect(repo.calls, contains('/p1'));
      expect(s.ports.length, 2);
      expect(s.selectedPort?.port, 3000);
    });

    test('selectPort przełącza, refresh utrzymuje wybór', () async {
      final ctrl = c.read(previewProvider('/p1').notifier);
      await ctrl.refresh();
      ctrl.selectPort(8080);
      expect(c.read(previewProvider('/p1')).selectedPort?.port, 8080);
      await ctrl.refresh();
      expect(c.read(previewProvider('/p1')).selectedPort?.port, 8080);
    });

    test('zniknięcie portu wybiera pierwszy dostępny', () async {
      final ctrl = c.read(previewProvider('/p1').notifier);
      await ctrl.refresh();
      ctrl.selectPort(8080);
      repo.rows = const [ListeningPort(port: 3000, address: 'x')];
      await ctrl.refresh();
      expect(c.read(previewProvider('/p1')).selectedPort?.port, 3000);
    });

    test('proxyUrl dodaje token do reverse-proxy', () async {
      final ctrl = c.read(previewProvider('/p1').notifier);
      await ctrl.refresh();
      final uri = await ctrl.proxyUrl();
      expect(uri.toString(), 'http://srv:10087/api/preview/3000/?token=a.b.c');
    });
  });

  group('BrowserUseController', () {
    late _FakeBrowserRepo repo;
    late ProviderContainer c;

    setUp(() {
      repo = _FakeBrowserRepo();
      c = ProviderContainer(
        overrides: [browserUseRepositoryProvider.overrideWithValue(repo)],
      );
      c.listen(browserUseProvider, (_, _) {});
    });

    tearDown(() => c.dispose());

    test('modele dekodują status i sesje', () {
      final s = BrowserUseStatus.fromJson({
        'enabled': true,
        'available': true,
        'sessionCount': 2,
      });
      expect(s.available, isTrue);
      expect(s.sessionCount, 2);
      final sess = BrowserUseSession.fromJson({
        'id': 'x',
        'status': 'ready',
        'url': 'https://a',
      });
      expect(sess.isRunning, isTrue);
    });

    test('refresh ładuje status i sesje', () async {
      await c.read(browserUseProvider.notifier).refresh();
      final s = c.read(browserUseProvider);
      expect(s.sessions.length, 2);
      expect(s.runtimeReady, isFalse); // repo.available = false
    });

    test('installRuntime ustawia status z odpowiedzi', () async {
      final ok = await c.read(browserUseProvider.notifier).installRuntime();
      expect(ok, isTrue);
      expect(repo.calls, contains('install'));
      await Future<void>.delayed(Duration.zero);
      expect(c.read(browserUseProvider).status!.available, isTrue);
    });

    test('stopSession i deleteSession wywołują repo', () async {
      final ctrl = c.read(browserUseProvider.notifier);
      await ctrl.stopSession('s1');
      await ctrl.deleteSession('s2');
      expect(repo.calls, containsAll(['stop:s1', 'delete:s2']));
    });

    test('błąd mutacji ustawia error i zwalnia busy', () async {
      final ctrl = c.read(browserUseProvider.notifier);
      repo.opError = const ServerError('fail', 400);
      expect(await ctrl.stopSession('s1'), isFalse);
      final s = c.read(browserUseProvider);
      expect(s.busy, isFalse);
      expect(s.error, 'fail');
    });

    testWidgets('BrowserUsePanel — lista sesji, stop/delete, install', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            browserUseRepositoryProvider.overrideWithValue(repo),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: BrowserUsePanel()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Install button while runtime unavailable.
      expect(find.byKey(const Key('browser-use-install')), findsOneWidget);
      await tester.tap(find.byKey(const Key('browser-use-install')));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('install'));

      // Sessions with stop/delete controls.
      expect(find.text('https://x'), findsWidgets); // title fallback + url row
      await tester.tap(find.byKey(const Key('browser-use-stop-s1')));
      await tester.tap(find.byKey(const Key('browser-use-delete-s2')));
      expect(repo.calls, containsAll(['stop:s1', 'delete:s2']));
    });
  });
}
