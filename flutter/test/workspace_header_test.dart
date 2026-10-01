import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/orchestrator/data/orchestrator_repository.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/pane_session_header.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _FakeOrchestratorRepo extends OrchestratorRepository {
  _FakeOrchestratorRepo({this.parent}) : super(Dio());

  final String? parent;

  @override
  Future<String?> parentSession(String sessionId) async => parent;
}

Widget _headerApp({required Widget child, OrchestratorRepository? repo}) =>
    TranslationProvider(
      child: ProviderScope(
        overrides: [
          if (repo != null)
            orchestratorRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(body: child),
        ),
      ),
    );

Widget _header({
  PaneAction action = PaneAction.idle,
  String provider = 'claude',
  ValueChanged<String>? onNavigate,
  VoidCallback? onArchive,
  VoidCallback? onDelete,
}) => PaneSessionHeader(
  sessionId: 'child-1',
  title: 'Delegated run',
  provider: provider,
  action: action,
  onChangeSession: () {},
  onChangeWorkspace: () {},
  onRename: (_) {},
  onArchive: onArchive ?? () {},
  onDelete: onDelete ?? () {},
  onNavigateToSession: onNavigate,
);

void main() {
  group('PaneSessionHeader — T57', () {
    testWidgets('delegated session shows back-to-orchestration arrow', (
      tester,
    ) async {
      String? navigated;
      await tester.pumpWidget(
        _headerApp(
          repo: _FakeOrchestratorRepo(parent: 'parent-9'),
          child: _header(onNavigate: (id) => navigated = id),
        ),
      );
      await tester.pumpAndSettle();

      final back = find.byTooltip('Back to orchestration');
      expect(back, findsOneWidget);
      await tester.tap(back);
      expect(navigated, 'parent-9');
    });

    testWidgets('no parent → no back button; orchestrator provider skipped', (
      tester,
    ) async {
      await tester.pumpWidget(
        _headerApp(
          repo: _FakeOrchestratorRepo(),
          child: _header(onNavigate: (_) {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byTooltip('Back to orchestration'), findsNothing);

      // Orchestrator roots never query the parent endpoint.
      await tester.pumpWidget(
        _headerApp(
          repo: _FakeOrchestratorRepo(parent: 'p'),
          child: _header(provider: 'orchestrator', onNavigate: (_) {}),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byTooltip('Back to orchestration'), findsNothing);
    });

    testWidgets('archive/delete/workspace disabled while processing', (
      tester,
    ) async {
      await tester.pumpWidget(
        _headerApp(child: _header(action: PaneAction.processing)),
      );
      // The processing spinner animates forever — pumpAndSettle can't settle.
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pump(const Duration(milliseconds: 400));

      PopupMenuItem<String> item(String text) => tester.widget(
        find.ancestor(
          of: find.text(text),
          matching: find.byType(PopupMenuItem<String>),
        ),
      );
      expect(item('Archive').enabled, isFalse);
      expect(item('Delete permanently').enabled, isFalse);
      expect(item('Change workspace').enabled, isFalse);
      expect(item('Rename').enabled, isTrue);
      expect(item('Change session').enabled, isTrue);
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
