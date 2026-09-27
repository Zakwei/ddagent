import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/network/auth_token_store.dart';
import 'package:ddagent_app/core/router/app_router.dart';
import 'package:ddagent_app/core/widgets/adaptive_scaffold.dart';
import 'package:ddagent_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// In-memory SecureKv so tests don't hit the platform secure-storage channel.
class _MemKv implements SecureKv {
  final _map = <String, String>{};

  @override
  Future<String?> read(String key) async => _map[key];

  @override
  Future<void> write(String key, String value) async => _map[key] = value;

  @override
  Future<void> delete(String key) async => _map.remove(key);
}

Future<void> _initHive() async {
  Hive.init('/tmp/ddagent_test_hive');
  if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(_initHive);

  testWidgets('App boots, redirects to /connect without JWT', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authTokenStoreProvider.overrideWithValue(AuthTokenStore(storage: _MemKv()))],
        child: const DdagentApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Connect'), findsWidgets);
  });

  testWidgets('compact width shows bottom nav, routes to /projects', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: '/projects',
      routes: [
        ShellRoute(
          builder: (_, _, child) => AdaptiveScaffold(child: child),
          routes: [
            GoRoute(
              path: '/projects',
              builder: (_, _) => const PlaceholderPage(title: 'Projects'),
            ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(theme: ThemeData(), routerConfig: router));
    await tester.pumpAndSettle();
    expect(find.text('Projects'), findsWidgets);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('wide width shows NavigationRail', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final router = GoRouter(
      initialLocation: '/projects',
      routes: [
        ShellRoute(
          builder: (_, _, child) => AdaptiveScaffold(child: child),
          routes: [
            GoRoute(
              path: '/projects',
              builder: (_, _) => const PlaceholderPage(title: 'Projects'),
            ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(theme: ThemeData(), routerConfig: router));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);
  });
}
