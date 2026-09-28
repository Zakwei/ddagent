import 'package:ddagent_app/features/chat/view/tool_blocks.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/features/taskmaster/state/taskmaster_controller.dart';
import 'package:flutter_test/flutter_test.dart';

/// T40.5/9 — benchmark harness: hot paths must stay inside generous budgets
/// (these are smoke budgets, not precise perf numbers — they catch order-of-
/// magnitude regressions).
void main() {
  test('groupToolRuns handles 5k messages under 1s', () {
    final msgs = [
      for (var i = 0; i < 5000; i++)
        SessionMessage(
          id: 'm$i',
          sessionId: 's',
          timestamp: DateTime.fromMillisecondsSinceEpoch(i).toIso8601String(),
          provider: 'claude',
          kind: 'tool_use',
          toolName: 'read',
          toolId: 't$i',
        ),
    ];
    final sw = Stopwatch()..start();
    final grouped = groupToolRuns(msgs);
    sw.stop();
    expect(grouped.rows, isNotEmpty);
    expect(sw.elapsedMilliseconds, lessThan(1000));
  });

  test('filteredTasks over 2k tasks stays under 500ms', () {
    final state = TaskmasterState(
      tasks: [
        for (var i = 0; i < 2000; i++)
          TaskmasterTask(
            id: i,
            title: 'task $i alpha',
            status: i.isEven ? 'pending' : 'done',
            priority: ['high', 'medium', 'low'][i % 3],
          ),
      ],
    );
    final sw = Stopwatch()..start();
    final out = state.copyWith(searchQuery: 'alpha').filteredTasks;
    sw.stop();
    expect(out.length, 2000);
    expect(sw.elapsedMilliseconds, lessThan(500));
  });

  test('nextTask resolves dependencies across a large board', () {
    final state = TaskmasterState(
      tasks: [
        for (var i = 1; i <= 500; i++)
          TaskmasterTask(
            id: i,
            status: i == 1 ? 'done' : 'pending',
            dependencies: i == 1 ? const [] : [i - 1],
          ),
      ],
    );
    expect(state.nextTask?.idText, '2');
  });
}
