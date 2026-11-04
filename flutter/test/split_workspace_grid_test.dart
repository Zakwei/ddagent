import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/workspace/state/pane_layout.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/split_workspace_grid.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Regression guard: the drag wrapper used to read the mutable `tile`
/// variable from its own builder, so every pane that was draggable
/// (i.e. every layout with 2+ panes) recursed into itself until the
/// render pass blew the stack and the whole grid turned into an error box.
void main() {
  Future<List<Object>> pumpGrid(WidgetTester tester, int paneCount) async {
    final errors = <Object>[];
    final previous = FlutterError.onError;
    FlutterError.onError = (details) => errors.add(details.exception);
    addTearDown(() => FlutterError.onError = previous);

    final panes = [
      for (var i = 0; i < paneCount; i++) SplitPane(id: 'pane-$i', kind: PaneKind.terminal),
    ];
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: SplitWorkspaceGrid(
              panes: panes,
              activePaneId: 'pane-0',
              onClosePane: (_) {},
              renderPane: (pane, isActive) =>
                  ColoredBox(color: const Color(0xFFEEEEEE), child: SizedBox.expand()),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    return errors;
  }

  testWidgets('two panes render without exceptions', (tester) async {
    final errors = await pumpGrid(tester, 2);
    expect(errors, isEmpty);
  });

  testWidgets('four panes render without exceptions', (tester) async {
    final errors = await pumpGrid(tester, 4);
    expect(errors, isEmpty);
  });

  /// Desktop grid with a key-carrying body per pane, reporting new layouts.
  Future<List<PaneLayout>> pumpDesktop(
    WidgetTester tester, {
    List<String> ids = const ['pane-0', 'pane-1'],
    PaneLayout? layout,
  }) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final changes = <PaneLayout>[];
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: SplitWorkspaceGrid(
              panes: [for (final id in ids) SplitPane(id: id, kind: PaneKind.terminal)],
              layout: layout,
              paneTitle: (pane) => pane.id,
              onClosePane: (_) {},
              onToggleMaximizePane: (_) {},
              onLayoutChanged: changes.add,
              renderPane: (pane, _) => _Body(key: ValueKey('body-${pane.id}')),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return changes;
  }

  Future<void> dragHeader(WidgetTester tester, String from, Offset to) async {
    final g = await tester.startGesture(
      tester.getCenter(find.text(from)),
      kind: PointerDeviceKind.mouse,
    );
    final start = tester.getCenter(find.text(from));
    for (var i = 1; i <= 12; i++) {
      await g.moveTo(Offset.lerp(start, to, i / 12)!);
      await tester.pump(const Duration(milliseconds: 16));
    }
    await g.up();
    await tester.pumpAndSettle();
  }

  testWidgets('dropping a header on the bottom edge of a pane splits it there', (tester) async {
    final changes = await pumpDesktop(tester);
    final target = tester.getRect(find.byKey(const ValueKey('body-pane-1')));
    await dragHeader(tester, 'pane-0', Offset(target.center.dx, target.bottom - 20));
    expect(changes.single.toJson(), {
      'axis': 'column',
      'children': [
        {'pane': 'pane-1'},
        {'pane': 'pane-0'},
      ],
      'weights': [500, 500],
    });
  });

  testWidgets('dropping on the centre swaps the panes', (tester) async {
    final changes = await pumpDesktop(tester, ids: ['pane-0', 'pane-1', 'pane-2']);
    final target = tester.getRect(find.byKey(const ValueKey('body-pane-2')));
    await dragHeader(tester, 'pane-0', target.center);
    expect(layoutLeafOrder(changes.single), ['pane-2', 'pane-1', 'pane-0']);
  });

  testWidgets('a sash drag resizes once, on release', (tester) async {
    final changes = await pumpDesktop(tester);
    final left = tester.getRect(find.byKey(const ValueKey('body-pane-0')));
    final g = await tester.startGesture(Offset(left.right + 5, left.center.dy));
    for (var i = 0; i < 10; i++) {
      await g.moveBy(const Offset(-20, 0));
      await tester.pump();
    }
    expect(changes, isEmpty, reason: 'live drag stays local');
    expect(
      tester.getRect(find.byKey(const ValueKey('body-pane-0'))).width,
      lessThan(left.width - 150),
    );
    await g.up();
    await tester.pumpAndSettle();
    final split = changes.single as PaneSplit;
    expect(split.weights.first, lessThan(400));
  });

  testWidgets('a pane keeps its state when it is docked elsewhere', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    var layout = autoPaneLayout(['pane-0', 'pane-1', 'pane-2'])!;
    late StateSetter rebuild;
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                rebuild = setState;
                return SplitWorkspaceGrid(
                  panes: [
                    for (final id in layoutLeafOrder(layout))
                      SplitPane(id: id, kind: PaneKind.terminal),
                  ],
                  layout: layout,
                  paneTitle: (pane) => pane.id,
                  onClosePane: (_) {},
                  onLayoutChanged: (next) => rebuild(() => layout = next),
                  renderPane: (pane, _) => _Body(key: ValueKey('body-${pane.id}')),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final before = tester.state(find.byKey(const ValueKey('body-pane-0')));
    final target = tester.getRect(find.byKey(const ValueKey('body-pane-2')));
    await dragHeader(tester, 'pane-0', Offset(target.center.dx, target.bottom - 20));
    expect(layout, isA<PaneSplit>());
    expect((layout as PaneSplit).children.last, isA<PaneSplit>(), reason: 'docked under pane-2');
    expect(identical(tester.state(find.byKey(const ValueKey('body-pane-0'))), before), isTrue);
  });

  test('drop zones: nearest edge within 30%, else centre', () {
    expect(paneDropZoneAt(0.1, 0.5), PaneDropZone.left);
    expect(paneDropZoneAt(0.9, 0.5), PaneDropZone.right);
    expect(paneDropZoneAt(0.5, 0.05), PaneDropZone.top);
    expect(paneDropZoneAt(0.6, 0.8), PaneDropZone.bottom);
    expect(paneDropZoneAt(0.5, 0.5), PaneDropZone.center);
  });

  testWidgets('compact tab of a finished background pane turns green', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    Widget grid(String activeId) => TranslationProvider(
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SplitWorkspaceGrid(
            panes: const [
              SplitPane(id: 'pane-0', kind: PaneKind.terminal),
              SplitPane(id: 'pane-1', kind: PaneKind.terminal),
            ],
            activePaneId: activeId,
            finishedPaneIds: const {'pane-1'},
            paneTitle: (pane) => pane.id,
            onClosePane: (_) {},
            renderPane: (_, _) => const SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.pumpWidget(grid('pane-0'));
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    // The selected tab never shows the finished state.
    await tester.pumpWidget(grid('pane-1'));
    expect(find.byIcon(Icons.check_circle), findsNothing);
  });

  testWidgets('compact tab waiting on the user turns amber over green', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: SplitWorkspaceGrid(
              panes: const [
                SplitPane(id: 'pane-0', kind: PaneKind.terminal),
                SplitPane(id: 'pane-1', kind: PaneKind.terminal),
              ],
              activePaneId: 'pane-0',
              finishedPaneIds: const {'pane-1'},
              actionPaneIds: const {'pane-1'},
              paneTitle: (pane) => pane.id,
              onClosePane: (_) {},
              renderPane: (_, _) => const SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
    expect(find.byIcon(LucideIcons.triangleAlert), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsNothing);
  });
}

/// Stateful stand-in for a pane body (terminal, browser stream).
class _Body extends StatefulWidget {
  const _Body({super.key});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  @override
  Widget build(BuildContext context) =>
      const ColoredBox(color: Color(0xFFEEEEEE), child: SizedBox.expand());
}
