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
      for (var i = 0; i < paneCount; i++)
        SplitPane(id: 'pane-$i', kind: PaneKind.chat),
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
            renderPane: (pane, isActive) => ColoredBox(
              color: const Color(0xFFEEEEEE),
              child: SizedBox.expand(),
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
}
