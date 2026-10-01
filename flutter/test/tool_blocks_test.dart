import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/chat/view/tool_blocks.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

SessionMessage _m(
  String id,
  String kind, {
  String? toolName,
  String? toolId,
  String? parent,
  dynamic toolInput,
  Map<String, dynamic>? toolResult,
  bool isError = false,
}) => SessionMessage(
  id: id,
  sessionId: 's',
  timestamp: 't$id',
  provider: 'claude',
  kind: kind,
  toolName: toolName,
  toolId: toolId,
  parentToolUseId: parent,
  toolInput: toolInput,
  toolResult: toolResult,
  isError: isError,
);

void main() {
  group('toolDisplayMode', () {
    test('hidden/one-line/collapsible/plan buckets', () {
      // T56 — todo/task tools render (TodoListContent/TaskListContent).
      expect(toolDisplayMode('todo_write'), ToolDisplay.collapsible);
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

    test('runs of >=3 of the same tool collapse into ToolGroup', () {
      final g = groupToolRuns([
        _m('1', 'text'),
        _m('2', 'tool_use', toolName: 'bash', toolId: 'a'),
        _m('3', 'tool_result', toolId: 'a'),
        _m('4', 'tool_use', toolName: 'bash', toolId: 'b'),
        _m('5', 'tool_result', toolId: 'b'),
        _m('6', 'tool_use', toolName: 'bash', toolId: 'c'),
        _m('7', 'tool_result', toolId: 'c'),
        _m('8', 'text'),
      ]);
      expect(g.rows.length, 3);
      final grp = g.rows[1];
      expect(grp, isA<ToolGroup>());
      expect((grp as ToolGroup).messages.length, 6);
    });

    test('mixed tools never share a group (web resolves the run name)', () {
      final g = groupToolRuns([
        _m('1', 'tool_use', toolName: 'bash', toolId: 'a'),
        _m('2', 'tool_use', toolName: 'read_file', toolId: 'b'),
        _m('3', 'tool_use', toolName: 'read_file', toolId: 'c'),
        _m('4', 'tool_use', toolName: 'read_file', toolId: 'd'),
      ]);
      // bash stays flat; the three read_file rows collapse.
      expect((g.rows[0] as SessionMessage).id, '1');
      expect(g.rows[1], isA<ToolGroup>());
      expect((g.rows[1] as ToolGroup).messages.length, 3);
    });

    test('file-edit tools stay visible outside groups (ungroupable)', () {
      final g = groupToolRuns([
        _m('1', 'tool_use', toolName: 'bash', toolId: 'a'),
        _m('2', 'tool_use', toolName: 'edit_file', toolId: 'b'),
        _m('3', 'tool_use', toolName: 'read_file', toolId: 'c'),
        _m('4', 'tool_use', toolName: 'read_file', toolId: 'd'),
        _m('5', 'tool_use', toolName: 'read_file', toolId: 'e'),
        _m('6', 'tool_result'),
      ]);
      // edit_file is a hard boundary: bash before it stays flat, the three
      // read_file rows after it collapse.
      expect((g.rows[0] as SessionMessage).id, '1');
      expect((g.rows[1] as SessionMessage).id, '2');
      expect(g.rows[2], isA<ToolGroup>());
      expect((g.rows[2] as ToolGroup).messages.length, 4);
    });

    test('thinking rows do not split a tool run', () {
      final g = groupToolRuns([
        _m('1', 'tool_use', toolName: 'bash', toolId: 'a'),
        _m('2', 'thinking'),
        _m('3', 'tool_use', toolName: 'bash', toolId: 'b'),
        _m('4', 'tool_result', toolId: 'b'),
        _m('5', 'tool_use', toolName: 'bash', toolId: 'c'),
        _m('6', 'tool_result', toolId: 'c'),
      ]);
      // Thinking stays as its own row; the same-tool rows still collapse.
      expect((g.rows[0] as SessionMessage).id, '2');
      final grp = g.rows[1] as ToolGroup;
      expect(grp.messages.map((m) => m.id), ['1', '3', '4', '5', '6']);
    });

    test('subagent parent with children is not grouped', () {
      final g = groupToolRuns([
        _m('p', 'tool_use', toolName: 'task', toolId: 't1'),
        _m('c', 'tool_use', toolName: 'bash', parent: 't1'),
        _m('1', 'tool_use', toolName: 'bash', toolId: 'a'),
        _m('2', 'tool_use', toolName: 'bash', toolId: 'b'),
        _m('3', 'tool_use', toolName: 'bash', toolId: 'c'),
      ]);
      expect((g.rows[0] as SessionMessage).id, 'p');
      expect(g.rows[1], isA<ToolGroup>());
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

  group('oc tool rows', () {
    test('resolveToolName folds title verbs onto canonical tools', () {
      expect(resolveToolName('Edit file'), 'edit_file');
      expect(resolveToolName('Wrote ./src/a.ts'), 'write_file');
      expect(resolveToolName('read_file'), 'read_file');
      expect(resolveToolName('Bash'), 'bash');
      // Unknown descriptive titles stay as-is (web Default config).
      expect(resolveToolName('Ran grep'), 'Ran grep');
    });

    test('ocToolGlyph mirrors OC_TOOL_ICONS', () {
      expect(ocToolGlyph('Bash'), r'$');
      expect(ocToolGlyph('read_file'), '→');
      expect(ocToolGlyph('write_file'), '←');
      expect(ocToolGlyph('Edit_File'), '←');
      expect(ocToolGlyph('grep'), '✱');
      expect(ocToolGlyph('web_search'), '◈');
      expect(ocToolGlyph('unknown_thing'), '⚙');
    });

    test('toolStatusFor: running → completed/error', () {
      expect(
        toolStatusFor(_m('a', 'tool_use', toolName: 'bash')),
        ToolStatus.running,
      );
      expect(
        toolStatusFor(
          _m('b', 'tool_use', toolName: 'bash', toolResult: {'content': 'ok'}),
        ),
        ToolStatus.completed,
      );
      expect(
        toolStatusFor(
          _m(
            'c',
            'tool_use',
            toolName: 'bash',
            toolResult: {'exitCode': 2, 'content': 'fail'},
          ),
        ),
        ToolStatus.error,
      );
      expect(
        toolStatusFor(_m('d', 'tool_use', toolName: 'bash', isError: true)),
        ToolStatus.error,
      );
    });

    // ProviderScope: tool rows watch uiPreferencesProvider for the
    // `showRawParameters` pref (defaults when no Hive box is open).
    Widget app(Widget child, {bool dark = true}) => ProviderScope(
      child: MaterialApp(
        theme: dark ? AppTheme.ocChat() : AppTheme.light(),
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );

    testWidgets(
      r'bash row: card, $ glyph, Running badge, lines count, expand → output',
      (tester) async {
        final msg = _m(
          't1',
          'tool_use',
          toolName: 'bash',
          toolInput: {'command': 'ls -la', 'description': 'list files'},
          toolResult: {'content': 'a\nb\nc\nd'},
        );
        await tester.pumpWidget(
          app(ToolUseTile(message: msg, childrenMap: const {})),
        );

        // Completed bash with output → card, no status badge (web passes
        // `status` only when not completed), "4 lines".
        expect(find.text(r'$'), findsOneWidget);
        expect(find.text('ls -la'), findsOneWidget);
        expect(find.text('Completed'), findsNothing);
        expect(find.text('4 lines'), findsOneWidget);
        expect(find.text('a\nb\nc\nd'), findsNothing);

        await tester.tap(find.text('ls -la'));
        await tester.pump();
        expect(find.text('a\nb\nc\nd'), findsOneWidget);
      },
    );

    testWidgets('running tool shows spinner, no badge', (tester) async {
      final msg = _m(
        't2',
        'tool_use',
        toolName: 'bash',
        toolInput: {'command': 'sleep 5'},
      );
      await tester.pumpWidget(
        app(ToolUseTile(message: msg, childrenMap: const {})),
      );
      // status derived as running → spinner, never a badge.
      expect(find.byType(CircularProgressIndicator), findsWidgets);
      expect(find.text('Running'), findsNothing);
    });

    testWidgets('read row: one-line `→` glyph, expand shows result', (
      tester,
    ) async {
      final msg = _m(
        't3',
        'tool_use',
        toolName: 'read_file',
        toolInput: {'path': 'lib/a.dart'},
        toolResult: {'content': 'file body'},
      );
      await tester.pumpWidget(
        app(ToolUseTile(message: msg, childrenMap: const {})),
      );
      expect(find.text('→'), findsOneWidget);
      expect(find.text('Read lib/a.dart'), findsOneWidget);
      await tester.tap(find.text('Read lib/a.dart'));
      await tester.pump();
      expect(find.text('file body'), findsOneWidget);
    });

    testWidgets('long output collapses with "Show N more lines"', (
      tester,
    ) async {
      final out = List.generate(20, (i) => 'line $i').join('\n');
      final msg = _m(
        't4',
        'tool_use',
        toolName: 'bash',
        toolInput: {'command': 'seq 20'},
        toolResult: {'content': out},
      );
      await tester.pumpWidget(
        app(ToolUseTile(message: msg, childrenMap: const {})),
      );
      await tester.tap(find.text('seq 20'));
      await tester.pump();
      expect(find.text('Show 8 more lines'), findsOneWidget);
      await tester.tap(find.text('Show 8 more lines'));
      await tester.pump();
      expect(find.text('Show less'), findsOneWidget);
    });

    testWidgets('light theme renders badge + card', (tester) async {
      final msg = _m(
        't5',
        'tool_use',
        toolName: 'bash',
        toolInput: {'command': 'true'},
        toolResult: {'content': 'ok'},
      );
      await tester.pumpWidget(
        app(ToolUseTile(message: msg, childrenMap: const {}), dark: false),
      );
      // Completed rows carry no badge — only the card styling remains.
      expect(find.text('Completed'), findsNothing);
      expect(find.text('true'), findsOneWidget);
    });
  });

  group('T56 renderers', () {
    Widget app(Widget child) => ProviderScope(
      child: MaterialApp(
        theme: AppTheme.ocChat(),
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );

    testWidgets('todo_write expands into the TodoListContent rows', (
      tester,
    ) async {
      final msg = _m(
        'tw',
        'tool_use',
        toolName: 'todo_write',
        toolInput: {
          'todos': [
            {'content': 'First task', 'status': 'completed'},
            {'content': 'Second task', 'status': 'in_progress'},
          ],
        },
        toolResult: {'content': 'ok'},
      );
      await tester.pumpWidget(
        app(ToolUseTile(message: msg, childrenMap: const {})),
      );
      expect(find.text('Updating todo list'), findsOneWidget);
      expect(find.text('First task'), findsNothing);
      await tester.tap(find.text('Updating todo list'));
      await tester.pump();
      expect(find.text('First task'), findsOneWidget);
      expect(find.text('Second task'), findsOneWidget);
      expect(find.text('Todo list updated'), findsOneWidget);
    });

    testWidgets('tasklist renders parsed #id status rows', (tester) async {
      final msg = _m(
        'tl',
        'tool_use',
        toolName: 'tasklist',
        toolResult: {
          'content': '#1 [completed] Setup repo\n#2 [in_progress] Wire API\n',
        },
      );
      await tester.pumpWidget(
        app(ToolUseTile(message: msg, childrenMap: const {})),
      );
      await tester.tap(find.text('Tasks listing tasks'));
      await tester.pump();
      expect(find.text('#1'), findsOneWidget);
      expect(find.text('Setup repo'), findsOneWidget);
      expect(find.text('1/2 completed'), findsOneWidget);
    });

    testWidgets('grep filenames render as clickable basenames', (tester) async {
      String? opened;
      final msg = _m(
        'g',
        'tool_use',
        toolName: 'grep',
        toolInput: {'pattern': 'foo'},
        toolResult: {
          'content': 'src/a.dart\nlib/deep/b.dart',
          'toolUseResult': {
            'filenames': ['src/a.dart', 'lib/deep/b.dart'],
          },
        },
      );
      await tester.pumpWidget(
        app(
          ToolUseTile(
            message: msg,
            childrenMap: const {},
            onFileOpen: (p) => opened = p,
          ),
        ),
      );
      // Raw result text is replaced by the file list.
      await tester.tap(find.textContaining('foo'));
      await tester.pump();
      expect(find.text('a.dart'), findsOneWidget);
      expect(find.text('b.dart'), findsOneWidget);
      await tester.tap(find.text('b.dart'));
      await tester.pump();
      expect(opened, 'lib/deep/b.dart');
    });

    testWidgets('edit_file title click opens the file', (tester) async {
      String? opened;
      final msg = _m(
        'e',
        'tool_use',
        toolName: 'edit_file',
        toolInput: {'path': 'lib/x.dart', 'diff': '@@ -1 +1 @@'},
        toolResult: {'content': 'ok'},
      );
      await tester.pumpWidget(
        app(
          ToolUseTile(
            message: msg,
            childrenMap: const {},
            onFileOpen: (p) => opened = p,
          ),
        ),
      );
      await tester.tap(find.text('edit lib/x.dart'));
      await tester.pump();
      expect(opened, 'lib/x.dart');
    });
  });
}
