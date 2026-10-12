import 'package:ddagent_app/features/workspace/state/split_workspace.dart';

/// Panes whose agent is done — their compact tab turns green.
///
/// A pane counts as finished when its session's turn ended (locally observed
/// processing → idle, or the server's persisted `turnFinishedAt`) and the
/// session is idle. Work that outlives the turn (Claude background subagents
/// and shells, reported through `background_tasks`) keeps the pane out of the
/// set: the agent is still busy, and its follow-up turn starts once that work
/// settles.
Set<String> resolveFinishedPaneIds({
  required List<SplitPane> panes,
  required Set<String> locallyFinishedPaneIds,
  required Set<String> turnFinishedSessionIds,
  required Set<String> processingSessionIds,
  required Set<String> backgroundTaskSessionIds,
}) {
  bool idle(String? sessionId) =>
      sessionId != null &&
      !processingSessionIds.contains(sessionId) &&
      !backgroundTaskSessionIds.contains(sessionId);
  return {
    for (final p in panes)
      if (idle(p.sessionId) &&
          (locallyFinishedPaneIds.contains(p.id) || turnFinishedSessionIds.contains(p.sessionId)))
        p.id,
  };
}
