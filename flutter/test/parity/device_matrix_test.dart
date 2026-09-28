import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/features/taskmaster/view/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// T40.10 — device matrix: representative widgets must render without
/// overflow/exceptions across phone, small-tablet, tablet and desktop sizes.
void main() {
  const sizes = {
    'phone 360x640': Size(360, 640),
    'foldable 768x1024': Size(768, 1024),
    'tablet 1280x800': Size(1280, 800),
    'desktop 1920x1080': Size(1920, 1080),
  };

  const task = TaskmasterTask(
    id: 7,
    title: 'A very long task title that must ellipsize cleanly on narrow '
        'screens instead of overflowing the row',
    status: 'pending',
    priority: 'high',
  );

  Widget harness(Widget child) => MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: Center(child: SizedBox(child: child))),
      );

  for (final entry in sizes.entries) {
    testWidgets('TaskTile renders at ${entry.key}', (tester) async {
      tester.view.physicalSize = entry.value;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(harness(TaskmasterTaskTile(
        task: task,
        onTap: () {},
        onToggleDone: () {},
        onRun: () {},
      )));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(TaskmasterTaskTile), findsOneWidget);
    });
  }
}
