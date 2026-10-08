import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/settings/view/sections/about_section.dart';
import 'package:ddagent_app/features/settings/view/settings_screen.dart';
import 'package:ddagent_app/features/system/data/app_update_channel.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:ddagent_app/features/system/state/system_providers.dart';
import 'package:ddagent_app/features/system/state/update_controller.dart'
    show appUpdateChannelProvider, appVersionProvider;
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// T48 — settings shell: section registry, compact/expanded nav split,
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
      'mini-orchestration',
      'appearance',
      'git',
      'api',
      'tools',
      'notifications',
      'workspaces',
      'shortcuts',
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

  testWidgets('appearance section mounts language + theme controls', (tester) async {
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
    // Assert on the mounted section, not its nav label: with 14 sections the
    // rail's lazy list can keep the last item out of the built window.
    expect(find.byType(AboutSection), findsOneWidget);
    expect(Hive.box<dynamic>('settings').get('lastSettingsSection'), 'about');
  });

  testWidgets('restart button opens the confirmation dialog', (tester) async {
    tester.view.physicalSize = const Size(1200, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    // Stub the About page's network providers so the changelog spinner does not
    // animate forever (pumpAndSettle would never complete).
    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          overrides: [
            releasesProvider.overrideWith((ref) async => <Release>[]),
            serverHealthProvider.overrideWith((ref) async => {'status': 'ok', 'version': '0.0.0'}),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const MediaQuery(
              data: MediaQueryData(size: Size(1200, 2600)),
              child: SettingsScreen(section: 'about'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final restart = find.text('Restart');
    expect(restart, findsWidgets);
    await tester.tap(restart.first);
    await tester.pumpAndSettle();

    expect(
      find.text('Restart the DDAgent server? Active sessions will be interrupted.'),
      findsOneWidget,
    );
  });

  testWidgets('restart shows progress until a new server process answers', (tester) async {
    tester.view.physicalSize = const Size(1200, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repo = _FakeSystemRepository();
    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          overrides: [
            releasesProvider.overrideWith((ref) async => <Release>[]),
            serverHealthProvider.overrideWith((ref) async => {'status': 'ok', 'version': '0.0.0'}),
            systemRepositoryProvider.overrideWithValue(repo),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const MediaQuery(
              data: MediaQueryData(size: Size(1200, 2600)),
              child: SettingsScreen(section: 'about'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Restart').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Restart').last); // confirm
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('Waiting for the server to come back'), findsOneWidget);
    expect(repo.restarted, isTrue);

    // Old process still up, then down twice, then the new one answers.
    for (var i = 0; i < 4; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
    expect(find.text('The server is back — version 0.9.0.'), findsOneWidget);

    // Native clients close the dialog on their own after a short pause.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.textContaining('The server is back'), findsNothing);
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

  testWidgets('mobile App updates section reports the APK version, not the server', (tester) async {
    tester.view.physicalSize = const Size(1200, 2600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      TranslationProvider(
        child: ProviderScope(
          overrides: [
            releasesProvider.overrideWith((ref) async => <Release>[]),
            // Server is far behind — irrelevant on a phone; the APK is what counts.
            serverHealthProvider.overrideWith((ref) async => {'status': 'ok', 'version': '0.0.1'}),
            latestReleaseProvider.overrideWith(
              (ref) async => const Release(tagName: 'v9.9.9', assets: <ReleaseAsset>[]),
            ),
            appUpdateChannelProvider.overrideWithValue(AppUpdateChannel.android),
            appVersionProvider.overrideWith((ref) async => '1.0.0'),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const MediaQuery(
              data: MediaQueryData(size: Size(1200, 2600)),
              child: SettingsScreen(section: 'about'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('App update v9.9.9 available — tap Update to install it on this device.'),
      findsOneWidget,
    );
    expect(find.textContaining('system installer'), findsOneWidget);
  });

  for (final android in [false, true]) {
    testWidgets('a newer release offers its own Update button (${android ? 'app' : 'server'})', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1200, 2600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        TranslationProvider(
          child: ProviderScope(
            overrides: [
              releasesProvider.overrideWith((ref) async => <Release>[]),
              serverHealthProvider.overrideWith(
                (ref) async => {'status': 'ok', 'version': android ? '9.9.9' : '0.0.1'},
              ),
              latestReleaseProvider.overrideWith(
                (ref) async => const Release(
                  tagName: 'v9.9.9',
                  assets: [
                    ReleaseAsset(
                      name: 'ddagent-flutter-android-v9.9.9.apk',
                      downloadUrl: 'https://example.com/app.apk',
                    ),
                  ],
                ),
              ),
              appUpdateChannelProvider.overrideWithValue(
                android ? AppUpdateChannel.android : AppUpdateChannel.unsupported,
              ),
              appVersionProvider.overrideWith((ref) async => '1.0.0'),
            ],
            child: MaterialApp(
              theme: AppTheme.light(),
              home: const MediaQuery(
                data: MediaQueryData(size: Size(1200, 2600)),
                child: SettingsScreen(section: 'about'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final update = find.widgetWithText(AppButton, android ? 'Update app' : 'Update server');
      expect(update, findsOneWidget);
      await tester.tap(update);
      await tester.pumpAndSettle();
      expect(
        find.textContaining(
          android ? 'Install DDAgent v9.9.9 on this device?' : 'Update to v9.9.9?',
        ),
        findsOneWidget,
      );
    });
  }
}

/// Health answers with the old process, fails while it is down, then reports a
/// new `startedAt` — the sequence a watchdog restart produces.
class _FakeSystemRepository extends SystemRepository {
  _FakeSystemRepository() : super(Dio());

  bool restarted = false;
  int _healthCalls = 0;

  @override
  Future<bool> restart() async => restarted = true;

  @override
  Future<Map<String, dynamic>> health() async {
    _healthCalls += 1;
    if (!restarted || _healthCalls == 2) {
      return {'status': 'ok', 'version': '0.8.11', 'startedAt': 'old'};
    }
    if (_healthCalls <= 4) throw Exception('connection refused');
    return {'status': 'ok', 'version': '0.9.0', 'startedAt': 'new'};
  }
}
