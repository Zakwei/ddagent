import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/split_workspace_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
      for (var i = 0; i < paneCount; i++) SplitPane(id: 'pane-$i', kind: PaneKind.chat),
    ];
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SplitWorkspaceGrid(
            panes: panes,
            activePaneId: 'pane-0',
            onClosePane: (_) {},
            onReorderPanes: (_, _) {},
            renderPane: (pane, isActive) =>
                ColoredBox(color: const Color(0xFFEEEEEE), child: SizedBox.expand()),
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

  testWidgets('trailing drag handle still reorders panes', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    String? moved;
    int? target;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SplitWorkspaceGrid(
            panes: const [
              SplitPane(id: 'pane-0', kind: PaneKind.chat),
              SplitPane(id: 'pane-1', kind: PaneKind.chat),
            ],
            paneTitle: (pane) => pane.id,
            onClosePane: (_) {},
            onReorderPanes: (id, index) {
              moved = id;
              target = index;
            },
            renderPane: (_, _) => const SizedBox.expand(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final handle = find.byType(Draggable<SplitPane>).first;
    expect(
      tester.getRect(handle).left,
      greaterThanOrEqualTo(tester.getRect(find.text('pane-0')).right),
    );
    final gesture = await tester.startGesture(tester.getCenter(handle));
    await gesture.moveBy(const Offset(10, 0));
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.text('pane-1')));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(moved, 'pane-0');
    expect(target, 1);
    expect(tester.takeException(), isNull);
  });
}
