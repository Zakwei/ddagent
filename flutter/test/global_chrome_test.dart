import 'dart:io';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/adaptive_scaffold.dart';
import 'package:ddagent_app/core/widgets/update_badge.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/settings/view/quick_settings_sheet.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:ddagent_app/features/system/state/update_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class _FakeSystemRepo extends SystemRepository {
  _FakeSystemRepo({this.release, this.version = '1.0.0'}) : super(Dio());

  final Release? release;
  final String version;

  @override
  Future<Release?> latestRelease() async => release;

  @override
  Future<Map<String, dynamic>> health() async => {'version': version};
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

Widget _app(Widget child) => TranslationProvider(
  child: ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    ),
  ),
);

Widget _badgeApp(SystemRepository repo) => TranslationProvider(
  child: ProviderScope(
    overrides: [systemRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: const Scaffold(body: UpdateBadge()),
    ),
  ),
);

void main() {
  group('version helpers — T59', () {
    test('compareVersions orders numeric dot versions', () {
      expect(compareVersions('1.2.0', '1.10.0'), isNegative);
      expect(compareVersions('2.0.0', '1.9.9'), isPositive);
      expect(compareVersions('1.2', '1.2.0'), 0);
      expect(compareVersions('1.2.1', '1.2'), isPositive);
    });

    test('normalizeVersion strips the v prefix', () {
      expect(normalizeVersion('v1.4.0'), '1.4.0');
      expect(normalizeVersion('1.4.0'), '1.4.0');
    });

    testWidgets('badge hidden when up-to-date, visible when behind', (tester) async {
      await tester.pumpWidget(
        _badgeApp(
          _FakeSystemRepo(
            release: const Release(tagName: 'v9.9.9'),
            version: '9.9.9',
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(LucideIcons.circleArrowUp), findsNothing);

      await tester.pumpWidget(
        _badgeApp(
          _FakeSystemRepo(
            release: const Release(tagName: 'v1.3.0'),
            version: '1.2.0',
          ),
        ),
      );
      // The badge dot pulses forever — pumpAndSettle can't settle.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byIcon(LucideIcons.circleArrowUp), findsOneWidget);

      await tester.tap(find.byIcon(LucideIcons.circleArrowUp));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('Update server'), findsOneWidget);
      expect(find.textContaining('v1.3.0'), findsWidgets);
    });
  });

  group('quick settings — T59', () {
    setUpAll(() async {
      Hive.init(Directory.systemTemp.createTempSync('hive_chrome').path);
      await Hive.openBox<dynamic>('settings');
    });

    setUp(() async {
      await Hive.box<dynamic>('settings').clear();
    });

    testWidgets('toggles flip uiPreferences', (tester) async {
      await tester.pumpWidget(_app(const QuickSettingsDialog()));
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(QuickSettingsDialog));
      final container = ProviderScope.containerOf(context);

      expect(container.read(uiPreferencesProvider).showThinking, isTrue);
      await tester.tap(find.text('Show thinking'));
      await tester.pumpAndSettle();
      expect(container.read(uiPreferencesProvider).showThinking, isFalse);

      expect(container.read(uiPreferencesProvider).sendByCtrlEnter, isFalse);
      await tester.tap(find.text('Send with Ctrl+Enter'));
      await tester.pumpAndSettle();
      expect(container.read(uiPreferencesProvider).sendByCtrlEnter, isTrue);
    });
  });

  group('global shortcuts — session quick switcher removed', () {
    setUpAll(() async {
      Hive.init(Directory.systemTemp.createTempSync('hive_chrome_keys').path);
      if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
    });

    testWidgets('Ctrl+K no longer opens a dialog; Ctrl+Shift+K still opens the palette', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final router = GoRouter(
        initialLocation: '/projects',
        routes: [
          ShellRoute(
            builder: (_, _, child) => AdaptiveScaffold(child: child),
            routes: [GoRoute(path: '/projects', builder: (_, _) => const Text('Projects'))],
          ),
        ],
      );
      await tester.pumpWidget(
        TranslationProvider(
          child: ProviderScope(
            overrides: [
              dioProvider.overrideWithValue(_fakeDio()),
              chatChannelProvider.overrideWithValue(ChatChannel(_FakeWs())),
            ],
            child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final routes = find.byWidgetPredicate((w) => w is ModalBarrier);
      final baseline = routes.evaluate().length;

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
      expect(routes.evaluate().length, baseline);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
      await tester.pumpAndSettle();
      expect(routes.evaluate().length, greaterThan(baseline));
    });
  });
}
