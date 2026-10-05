import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/features/taskmaster/view/task_tile.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// T40.7 — visual parity: golden screenshots pin the shared card/tile chrome
/// so a redesign can't silently drift from the web look. Regenerate with
/// `flutter test --update-goldens test/parity/golden_test.dart`.
void main() {
  Widget harness(Widget child, ThemeData theme) => TranslationProvider(
    child: MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(child: SizedBox(width: 380, child: child)),
      ),
    ),
  );

  const task = TaskmasterTask(
    id: 42,
    title: 'Refactor parity harness',
    status: 'pending',
    priority: 'high',
    dependencies: [1, 2],
  );

  testWidgets('TaskTile golden — light', (tester) async {
    await tester.pumpWidget(
      harness(
        TaskmasterTaskTile(task: task, onTap: () {}, onToggleDone: () {}, onRun: () {}),
        AppTheme.light(),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(TaskmasterTaskTile),
      matchesGoldenFile('goldens/task_tile_light.png'),
    );
  });

  testWidgets('TaskTile golden — dark', (tester) async {
    await tester.pumpWidget(
      harness(
        TaskmasterTaskTile(task: task, onTap: () {}, onToggleDone: () {}, onRun: () {}),
        AppTheme.dark(),
      ),
    );
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(TaskmasterTaskTile),
      matchesGoldenFile('goldens/task_tile_dark.png'),
    );
  });
}
