import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/settings/view/settings_screen.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// T48 — settings shell: 12-section registry, compact/expanded nav split,
/// last-opened-section persistence in the `settings` Hive box.
void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    Hive.init('/tmp/ddagent_settings_test');
  });

  setUp(() async {
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
  });

  Widget app(String section, {double width = 1000}) {
    return TranslationProvider(
      child: ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: MediaQuery(
            data: MediaQueryData(size: Size(width, 700)),
            child: SettingsScreen(section: section),
          ),
        ),
      ),
    );
  }

  test('registry mirrors the web SettingsMainTab order', () {
    expect(settingsSections.map((s) => s.id).toList(), [
      'agents',
      'orchestration',
      'appearance',
      'git',
      'api',
      'models',
      'tasks',
      'browser',
      'notifications',
      'quota',
      'workspaces',
      'schedules',
      'about',
    ]);
  });

  test('lastSettingsSection falls back and round-trips', () async {
    final box = Hive.box<dynamic>('settings');
    await box.delete('lastSettingsSection');
    expect(lastSettingsSection(), 'agents');
    await box.put('lastSettingsSection', 'git');
    expect(lastSettingsSection(), 'git');
    // Stale/unknown stored values fall back to the first section.
    await box.put('lastSettingsSection', 'nope');
    expect(lastSettingsSection(), 'agents');
  });

  testWidgets('appearance section mounts language + theme controls', (
    tester,
  ) async {
    await tester.pumpWidget(app('appearance'));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Appearance'), findsWidgets);
    expect(find.byType(DropdownButton<AppLocale>), findsOneWidget);
    expect(find.byType(SegmentedButton<ThemeMode>), findsOneWidget);
    // Nav rail lists all sections at non-compact widths.
    expect(find.text('Notifications'), findsOneWidget);
  });

  testWidgets('section visit persists the last-opened section', (tester) async {
    await tester.pumpWidget(app('about'));
    await tester.pumpAndSettle();
    expect(find.text('About'), findsWidgets);
    expect(Hive.box<dynamic>('settings').get('lastSettingsSection'), 'about');
  });

  testWidgets('compact width switches the rail to pills', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(app('about', width: 360));
    await tester.pumpAndSettle();
    expect(find.byType(ChoiceChip), findsNWidgets(settingsSections.length));
    expect(tester.takeException(), isNull);
  });
}
