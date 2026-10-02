import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/network/auth_token_store.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/router/app_router.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/adaptive_scaffold.dart';
import 'package:ddagent_app/main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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

/// chatChannelProvider auto-connects — a real WsClient leaves a reconnect
/// Timer pending and hangs pumpAndSettle.
class _FakeWs extends WsClient {
  _FakeWs() : super(urlBuilder: () async => Uri.parse('ws://t'));

  @override
  Stream<Map<String, dynamic>> get frames => const Stream.empty();
  @override
  Stream<WsState> get states => const Stream.empty();
  @override
  WsState get state => WsState.closed;

  @override
  Future<void> connect() async {}
}

/// _AppRail reads sessionsProvider → dio; answer everything with an empty
/// success payload.
Dio _fakeDio() => Dio(BaseOptions(baseUrl: 'http://t'))
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (o, h) => h.resolve(
        Response(
          requestOptions: o,
          data: {
            'success': true,
            'data': {'conversations': <dynamic>[], 'total': 0, 'hasMore': false},
          },
        ),
      ),
    ),
  );

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

  testWidgets('compact width shows a hamburger drawer, routes to /projects', (tester) async {
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
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dioProvider.overrideWithValue(_fakeDio()),
          chatChannelProvider.overrideWithValue(ChatChannel(_FakeWs())),
        ],
        child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Projects'), findsWidgets);
    // Web `MobileNavMenu` parity — no bottom bar and no dedicated top row;
    // the hamburger rides in the screen's own header.
    expect(find.byType(NavigationBar), findsNothing);
    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pumpAndSettle();
    expect(find.text('Navigation'), findsOneWidget);
    expect(find.text('Sessions'), findsWidgets);
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
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dioProvider.overrideWithValue(_fakeDio()),
          chatChannelProvider.overrideWithValue(ChatChannel(_FakeWs())),
        ],
        child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    // The rail is the custom _AppRail (icon rail), not a Material
    // NavigationRail — assert on its Panel destination instead.
    expect(find.byTooltip('Panel'), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
