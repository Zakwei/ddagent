import 'package:ddagent_app/features/workspace/state/finished_panes.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const panes = [
    SplitPane(id: 'pane-0', kind: PaneKind.chat, sessionId: 's0'),
    SplitPane(id: 'pane-1', kind: PaneKind.chat, sessionId: 's1'),
    SplitPane(id: 'pane-2', kind: PaneKind.chat, sessionId: 's2'),
    SplitPane(id: 'pane-3', kind: PaneKind.chat),
  ];

  Set<String> resolve({
    Set<String> local = const {},
    Set<String> turnFinished = const {},
    Set<String> processing = const {},
    Set<String> background = const {},
  }) => resolveFinishedPaneIds(
    panes: panes,
    locallyFinishedPaneIds: local,
    turnFinishedSessionIds: turnFinished,
    processingSessionIds: processing,
    backgroundTaskSessionIds: background,
  );

  test('a finished idle pane is flagged from either source', () {
    expect(resolve(local: {'pane-0'}), {'pane-0'});
    expect(resolve(turnFinished: {'s1'}), {'pane-1'});
    expect(resolve(local: {'pane-0'}, turnFinished: {'s1'}), {'pane-0', 'pane-1'});
  });

  test('a processing session is never finished', () {
    expect(resolve(local: {'pane-0'}, turnFinished: {'s0'}, processing: {'s0'}), isEmpty);
  });

  test('background tasks keep the pane unfinished until they settle', () {
    // Claude sends `complete` while its background subagents still run.
    expect(resolve(local: {'pane-0'}, turnFinished: {'s0'}, background: {'s0'}), isEmpty);
    expect(resolve(turnFinished: {'s0', 's1'}, background: {'s0'}), {'pane-1'});
    // The `background_tasks` count dropping to zero flips the pane green.
    expect(resolve(turnFinished: {'s0'}), {'pane-0'});
  });

  test('panes without a session are ignored', () {
    expect(resolve(local: {'pane-3'}), isEmpty);
  });
}
