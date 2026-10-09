import 'dart:convert';
import 'dart:io';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/network/auth_token_store.dart';
import 'package:ddagent_app/features/auth/view/auth_screens.dart';
import 'package:ddagent_app/features/server_connect/view/server_connect_screen.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:ddagent_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _MemKv implements SecureKv {
  final _map = <String, String>{};

  @override
  Future<String?> read(String key) async => _map[key];

  @override
  Future<void> write(String key, String value) async => _map[key] = value;

  @override
  Future<void> delete(String key) async => _map.remove(key);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // The binding stubs every HttpClient with 400s — the probe needs the real
  // loopback server below.
  setUpAll(() async {
    HttpOverrides.global = null;
    Hive.init('/tmp/ddagent_test_hive_connect');
    await Hive.openBox<dynamic>('settings');
  });
  tearDownAll(() => Hive.box<dynamic>('settings').clear());

  // Regression: boot without a JWT lands on /connect?from=/projects. Connecting
  // used to go straight to `from`, which the auth guard bounced back to
  // /connect — same screen state, so the button spun forever.
  testWidgets('connect without a JWT goes to /login and keeps from', (tester) async {
    final server = (await tester.runAsync(() async {
      final server = await HttpServer.bind('127.0.0.1', 0);
      server.listen((req) async {
        req.response
          ..headers.contentType = ContentType.json
          ..write(jsonEncode({'needsSetup': false, 'hasUsers': true}));
        await req.response.close();
      });
      return server;
    }))!;
    addTearDown(() => server.close(force: true));
    final url = 'http://127.0.0.1:${server.port}';
    // A saved active server (as after any earlier session) makes the guard
    // send a token-less boot to /connect?from=/projects.
    await tester.runAsync(() => Hive.box<dynamic>('settings').put('activeServerUrl', url));

    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          overrides: [authTokenStoreProvider.overrideWithValue(AuthTokenStore(storage: _MemKv()))],
          child: const DdagentApp(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ServerConnectScreen), findsOneWidget);
    final connectRouter = GoRouter.of(tester.element(find.byType(ServerConnectScreen)));
    expect(connectRouter.state.uri.queryParameters['from'], '/projects');

    await tester.enterText(find.byType(TextField), url);
    await tester.runAsync(() async {
      await tester.tap(find.text('Connect').last);
      await Future<void>.delayed(const Duration(milliseconds: 500));
    });
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    final router = GoRouter.of(tester.element(find.byType(LoginScreen)));
    expect(router.state.uri.queryParameters['from'], '/projects');
    // Let in-flight Dio requests' timeout timers expire before teardown.
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pump(const Duration(seconds: 31));
  });
}
