import 'package:ddagent_app/features/chat/view/tool_blocks.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:flutter_test/flutter_test.dart';

SessionMessage _m(String id, String kind, {String? toolName, String? toolId, String? parent}) =>
    SessionMessage(
      id: id,
      sessionId: 's',
      timestamp: 't$id',
      provider: 'claude',
      kind: kind,
      toolName: toolName,
      toolId: toolId,
      parentToolUseId: parent,
    );

void main() {
  group('toolDisplayMode', () {
    test('hidden/one-line/collapsible/plan buckets', () {
      expect(toolDisplayMode('todo_write'), ToolDisplay.hidden);
      expect(toolDisplayMode('exit_plan_mode'), ToolDisplay.plan);
      expect(toolDisplayMode('read_file'), ToolDisplay.oneLine);
      expect(toolDisplayMode('web_search'), ToolDisplay.oneLine);
      expect(toolDisplayMode('bash'), ToolDisplay.collapsible);
      expect(toolDisplayMode('edit_file'), ToolDisplay.collapsible);
      expect(toolDisplayMode(null), ToolDisplay.collapsible);
    });
  });

  group('groupToolRuns', () {
    test('runs of <3 stay flat', () {
      final g = groupToolRuns([
        _m('1', 'text'),
        _m('2', 'tool_use', toolName: 'bash', toolId: 'a'),
        _m('3', 'tool_result'),
        _m('4', 'text'),
      ]);
      expect(g.rows.length, 4);
      expect(g.rows.whereType<ToolGroup>(), isEmpty);
    });

    test('runs of >=3 collapse into ToolGroup', () {
      final g = groupToolRuns([
        _m('1', 'text'),
        _m('2', 'tool_use', toolName: 'bash', toolId: 'a'),
        _m('3', 'tool_use', toolName: 'read_file', toolId: 'b'),
        _m('4', 'tool_result'),
        _m('5', 'tool_result'),
        _m('6', 'text'),
      ]);
      expect(g.rows.length, 3);
      final grp = g.rows[1];
      expect(grp, isA<ToolGroup>());
      expect((grp as ToolGroup).messages.length, 4);
    });

    test('subagent children nest under parent toolId', () {
      final g = groupToolRuns([
        _m('p', 'tool_use', toolName: 'task', toolId: 't1'),
        _m('c1', 'tool_use', toolName: 'bash', parent: 't1'),
        _m('c2', 'tool_result', parent: 't1'),
        _m('x', 'text'),
      ]);
      expect(g.children['t1']!.map((m) => m.id), ['c1', 'c2']);
      // parent + text only — children are not top-level rows.
      expect(g.rows.map((r) => (r as SessionMessage).id), ['p', 'x']);
    });
  });
}
