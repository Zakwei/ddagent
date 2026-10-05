import 'dart:io';

import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/update_badge.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/settings/view/quick_settings_sheet.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:ddagent_app/features/system/state/update_controller.dart';
import 'package:ddagent_app/features/workspace/view/session_quick_switcher.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

/// Skips the real controller's WS subscription + HTTP load.
class _FakeSessions extends SessionsController {
  _FakeSessions() : super((null, null));

  @override
  SessionsState build() => const SessionsState(
    loading: false,
    sessions: [
      Session(sessionId: 's-alpha', summary: 'Alpha task'),
      Session(sessionId: 's-beta', summary: 'Beta task', isArchived: true),
    ],
  );
}

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
      expect(find.text('Update'), findsOneWidget);
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

  group('session quick switcher — T59', () {
    testWidgets('lists sessions and navigates to /chat/:id on tap', (tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, _) => Scaffold(
              body: Builder(
                builder: (context) => TextButton(
                  onPressed: () => showSessionQuickSwitcher(context),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
          GoRoute(path: '/chat/:id', builder: (_, s) => Text('CHAT:${s.pathParameters['id']}')),
        ],
      );

      await tester.pumpWidget(
        TranslationProvider(
          child: ProviderScope(
            overrides: [sessionsProvider((null, null)).overrideWith(_FakeSessions.new)],
            child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Alpha task'), findsOneWidget);
      expect(find.text('Beta task'), findsNothing); // archived filtered

      await tester.tap(find.text('Alpha task'));
      await tester.pumpAndSettle();
      expect(find.text('CHAT:s-alpha'), findsOneWidget);
    });
  });
}
