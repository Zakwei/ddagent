import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/orchestrator/data/orchestrator_repository.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:ddagent_app/features/sessions/view/provider_logo.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/pane_header_metrics.dart';
import 'package:ddagent_app/features/workspace/view/pane_session_header.dart';
import 'package:ddagent_app/features/workspace/view/split_workspace_grid.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class _FakeOrchestratorRepo extends OrchestratorRepository {
  _FakeOrchestratorRepo({this.parent}) : super(Dio());

  final String? parent;

  @override
  Future<String?> parentSession(String sessionId) async => parent;
}

class _FakeSessions extends SessionsRepository {
  _FakeSessions() : super(Dio());

  @override
  Future<List<Map<String, dynamic>>> changedFiles(String sessionId) async => [];
}

Widget _headerApp({required Widget child, OrchestratorRepository? repo}) => TranslationProvider(
  child: ProviderScope(
    overrides: [
      orchestratorRepositoryProvider.overrideWithValue(repo ?? _FakeOrchestratorRepo()),
      sessionsRepositoryProvider.overrideWithValue(_FakeSessions()),
      sessionMessagesProvider.overrideWith((ref, sessionId) => []),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    ),
  ),
);

Widget _header({
  String title = 'Delegated run',
  String? projectName,
  List<Widget> trailingActions = const [],
  VoidCallback? onChangeSession,
  PaneAction action = PaneAction.idle,
  String provider = 'claude',
  ValueChanged<String>? onNavigate,
  VoidCallback? onArchive,
  VoidCallback? onDelete,
}) => PaneSessionHeader(
  sessionId: 'child-1',
  title: title,
  projectName: projectName,
  trailingActions: trailingActions,
  provider: provider,
  action: action,
  onChangeSession: onChangeSession ?? () {},
  onChangeWorkspace: () {},
  onRename: (_) {},
  onArchive: onArchive ?? () {},
  onDelete: onDelete ?? () {},
  onNavigateToSession: onNavigate,
);

void main() {
  group('PaneSessionHeader — T57', () {
    testWidgets('delegated session shows back-to-orchestration arrow', (tester) async {
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

    testWidgets('no parent → no back button; orchestrator provider skipped', (tester) async {
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

    testWidgets('archive/delete/workspace disabled while processing', (tester) async {
      await tester.pumpWidget(_headerApp(child: _header(action: PaneAction.processing)));
      // The processing spinner animates forever — pumpAndSettle can't settle.
      await tester.pump(const Duration(milliseconds: 100));

      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pump(const Duration(milliseconds: 400));

      PopupMenuItem<String> item(String text) => tester.widget(
        find.ancestor(of: find.text(text), matching: find.byType(PopupMenuItem<String>)),
      );
      expect(item('Archive').enabled, isFalse);
      expect(item('Delete permanently').enabled, isFalse);
      expect(item('Change workspace').enabled, isFalse);
      expect(item('Rename').enabled, isTrue);
      // The history icon next to the menu switches sessions — no duplicate here.
      expect(find.text('Change session'), findsNothing);
    });

    testWidgets('compact header grows the tap targets to 40px', (tester) async {
      await tester.pumpWidget(
        _headerApp(
          child: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: _header(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // more_vert sits in its own 40x40 box on compact.
      final box = tester.getSize(find.byIcon(Icons.more_vert));
      expect(box.width, greaterThanOrEqualTo(40));
      expect(box.height, greaterThanOrEqualTo(40));
    });

    for (final width in [240.0, 400.0, 700.0, 1200.0]) {
      for (final longTitle in [false, true]) {
        testWidgets('session header geometry at $width with long title=$longTitle', (tester) async {
          tester.view.physicalSize = Size(width, 800);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.reset);
          final title = longTitle ? List.filled(30, 'Very long session title').join(' ') : 'Run';
          final panes = [
            const SplitPane(id: 'pane-0', kind: PaneKind.chat),
            if (width >= 600) const SplitPane(id: 'pane-1', kind: PaneKind.chat),
          ];
          String? navigated;
          String? closed;
          String? maximized;
          var switched = false;
          await tester.pumpWidget(
            _headerApp(
              repo: _FakeOrchestratorRepo(parent: 'parent-9'),
              child: SplitWorkspaceGrid(
                panes: panes,
                onClosePane: (id) => closed = id,
                onToggleMaximizePane: (id) => maximized = id,
                onReorderPanes: (_, _) {},
                renderPane: (_, _) => const SizedBox.expand(),
                renderPaneHeaderContent: (pane, actions) => pane.id == 'pane-0'
                    ? _header(
                        title: title,
                        projectName: 'Workspace must be hidden',
                        trailingActions: actions,
                        onNavigate: (id) => navigated = id,
                        onChangeSession: () => switched = true,
                      )
                    : Row(children: [const Spacer(), ...actions]),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(find.text('Workspace must be hidden'), findsNothing);
          final header = find.byType(PaneSessionHeader);
          Finder inside(Finder finder) => find.descendant(of: header, matching: finder);
          final bounds = tester.getRect(header);
          final textFinder = find.text(title);
          final textRect = tester.getRect(textFinder);
          final text = tester.widget<Text>(textFinder);
          expect(text.maxLines, 1);
          expect(text.overflow, TextOverflow.ellipsis);
          expect(tester.renderObject<RenderParagraph>(textFinder).didExceedMaxLines, longTitle);

          final controls = [
            inside(find.byTooltip('Back to orchestration')),
            inside(find.byTooltip('Export chat')),
            inside(find.byTooltip('Review changed files')),
            inside(find.byTooltip('Search transcript')),
            inside(find.byTooltip('Switch session')),
            inside(find.byType(PopupMenuButton<String>)).last,
            if (width >= 600) inside(find.byType(Draggable<SplitPane>)),
            if (width >= 600) inside(find.byTooltip('Maximize pane')),
            inside(find.byTooltip('Close pane')),
          ];
          final hit = width < 600 ? 40.0 : 28.0;
          final rects = controls.map(tester.getRect).toList();
          for (var i = 0; i < rects.length; i++) {
            final rect = rects[i];
            expect(rect.size, Size(hit, hit), reason: 'control $i at $width');
            expect(rect.left, greaterThanOrEqualTo(bounds.left));
            expect(rect.right, lessThanOrEqualTo(bounds.right));
            expect(rect.top, greaterThanOrEqualTo(bounds.top));
            expect(rect.bottom, lessThanOrEqualTo(bounds.bottom));
            expect(rect.overlaps(textRect), isFalse);
            for (final other in rects.take(i)) {
              expect(rect.overlaps(other), isFalse);
            }
          }
          // Both moved controls follow the title; narrow layouts put the
          // actions on trailing, wrapped rows, preserving their hit areas.
          final wraps = rects.first.top >= textRect.bottom;
          if (wraps) {
            expect(textRect.right, closeTo(bounds.right, 0.01));
          } else {
            expect(textRect.right, closeTo(rects.first.left, 0.01));
          }
          expect(rects.last.right, closeTo(bounds.right, 0.01));
          expect(
            textRect.left,
            closeTo(tester.getRect(inside(find.byType(ProviderLogo))).right + 4, 0.01),
          );

          final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
          await mouse.addPointer(location: const Offset(0, 790));
          await mouse.moveTo(textRect.center);
          await tester.pump();
          expect(inside(find.byIcon(LucideIcons.pencil)), findsOneWidget);
          final pencil = tester.getRect(inside(find.byIcon(LucideIcons.pencil)));
          expect(tester.getRect(textFinder).right, closeTo(pencil.left - 4, 0.01));
          expect(pencil.right, closeTo(textRect.right, 0.01));
          expect(tester.takeException(), isNull);
          await mouse.removePointer();
          await tester.pump();

          await tester.tap(controls[0]);
          expect(navigated, 'parent-9');
          await tester.tap(inside(find.byTooltip('Switch session')));
          expect(switched, isTrue);
          if (width >= 600) {
            await tester.tap(inside(find.byTooltip('Maximize pane')));
            expect(maximized, 'pane-0');
          }
          await tester.tap(inside(find.byTooltip('Close pane')));
          expect(closed, 'pane-0');
          await tester.tap(inside(find.byTooltip('Export chat')));
          await tester.pumpAndSettle();
          expect(find.text('Markdown (.md)'), findsOneWidget);
          await tester.tapAt(const Offset(0, 700));
          await tester.pumpAndSettle();
          await tester.tap(inside(find.byTooltip('Review changed files')));
          await tester.pumpAndSettle();
          expect(inside(find.byTooltip('Back to chat')), findsOneWidget);
          await tester.tap(inside(find.byTooltip('Back to chat')));
          await tester.pumpAndSettle();
          await tester.tap(inside(find.byTooltip('Search transcript')));
          await tester.pumpAndSettle();
          expect(inside(find.byType(TextField)), findsOneWidget);
          expect(tester.takeException(), isNull);
          expect(
            tester.getRect(inside(find.byType(TextField))).right,
            lessThanOrEqualTo(tester.getRect(header).right),
          );
          await tester.enterText(inside(find.byType(TextField)), 'no match');
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          final searchControls = [
            ...controls.where((finder) => finder != controls[3]),
            inside(find.byTooltip('Previous match')),
            inside(find.byTooltip('Next match')),
            inside(find.byTooltip('Close search')),
          ];
          for (final control in searchControls) {
            expect(tester.getSize(control), Size(hit, hit));
          }
          final searchRects = [
            ...searchControls.map(tester.getRect),
            tester.getRect(inside(find.byType(TextField))),
            tester.getRect(inside(find.text('0 of 0'))),
          ];
          final searchBounds = tester.getRect(header);
          for (var i = 0; i < searchRects.length; i++) {
            final rect = searchRects[i];
            expect(rect.left, greaterThanOrEqualTo(searchBounds.left));
            expect(rect.right, lessThanOrEqualTo(searchBounds.right));
            expect(rect.bottom, lessThanOrEqualTo(searchBounds.bottom));
            expect(rect.overlaps(tester.getRect(textFinder)), isFalse);
            for (final other in searchRects.take(i)) {
              expect(rect.overlaps(other), isFalse);
            }
          }
          await tester.tap(inside(find.byTooltip('Close search')));
          await tester.pumpAndSettle();
          expect(inside(find.byType(TextField)), findsNothing);
          expect(tester.takeException(), isNull);
        });
      }
    }

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
