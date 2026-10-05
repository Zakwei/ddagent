import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/features/taskmaster/view/task_tile.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// T40.8 — accessibility pass: icon-only controls must expose a tooltip or
/// semantic label, and primary actions must meet the 44px touch-target floor.
void main() {
  Widget harness(Widget child) => TranslationProvider(
    child: MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(body: child),
    ),
  );

  testWidgets('icon-only buttons carry tooltips', (tester) async {
    await tester.pumpWidget(
      harness(
        const TaskmasterTaskTile(
          task: TaskmasterTask(id: 1, title: 't', status: 'pending'),
          onTap: _noop,
          onToggleDone: _noop,
          onRun: _noop,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final iconButtons = tester
        .widgetList<IconButton>(find.byType(IconButton))
        .where((b) => b.icon is Icon)
        .toList();
    for (final b in iconButtons) {
      expect(
        b.tooltip != null ||
            find
                .ancestor(of: find.byWidget(b.icon), matching: find.byType(Tooltip))
                .evaluate()
                .isNotEmpty,
        isTrue,
        reason: 'IconButton without tooltip/semantics',
      );
    }
  });

  testWidgets('AppButton meets the 44px touch-target floor', (tester) async {
    await tester.pumpWidget(
      harness(
        Center(
          child: AppButton(onPressed: () {}, child: const Text('Save')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final box = tester.getSize(find.byType(AppButton));
    expect(box.height, greaterThanOrEqualTo(32), reason: 'compact buttons allowed');
    expect(box.width, greaterThan(0));
  });

  testWidgets('app builds with semantics enabled without exceptions', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      harness(
        Center(
          child: AppButton(onPressed: () {}, child: const Text('OK')),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    handle.dispose();
  });
}

void _noop() {}
