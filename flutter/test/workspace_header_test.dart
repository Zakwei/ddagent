import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/workspace/view/pane_header_metrics.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

Widget _headerApp({required Widget child}) => TranslationProvider(
  child: ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    ),
  ),
);

void main() {
  group('pane header metrics — T57', () {
    testWidgets('top-toolbar metrics grow on compact only', (tester) async {
      late BuildContext compact;
      late BuildContext desktop;
      await tester.pumpWidget(
        _headerApp(
          child: Builder(
            builder: (ctx) {
              compact = ctx;
              return const SizedBox();
            },
          ),
        ),
      );
      // The test view is 800x600 → compact is false by default; assert the
      // desktop row, then re-pump at a phone width.
      expect(topBarMetrics(compact).hit, 28);

      await tester.pumpWidget(
        _headerApp(
          child: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: Builder(
              builder: (ctx) {
                desktop = ctx;
                return const SizedBox();
              },
            ),
          ),
        ),
      );
      expect(topBarMetrics(desktop).hit, 40);
      expect(topBarMetrics(desktop).barHeight, 48);
    });
  });

  group('UiPreferences — focus mode (T57)', () {
    setUpAll(() async {
      Hive.init('/tmp/hive_ws_header_test');
      await Hive.openBox<dynamic>('settings');
    });

    tearDownAll(() async => Hive.close());

    test('toggleSidebar flips and persists sidebarVisible', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(uiPreferencesProvider).sidebarVisible, isTrue);
      container.read(uiPreferencesProvider.notifier).toggleSidebar();
      expect(container.read(uiPreferencesProvider).sidebarVisible, isFalse);

      final stored = Hive.box<dynamic>('settings').get('uiPreferences') as Map;
      expect(stored['sidebarVisible'], isFalse);

      container.read(uiPreferencesProvider.notifier).toggleSidebar();
      expect(container.read(uiPreferencesProvider).sidebarVisible, isTrue);
    });
  });
}
