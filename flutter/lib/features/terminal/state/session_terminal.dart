import 'dart:async';

import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Providers whose sessions the server's shell bridge can resume in their
/// own CLI (`claude --resume`, `codex resume`, `opencode --session` …).
const terminalResumableProviders = {
  'claude',
  'codex',
  'opencode',
  'commandcode',
  'antigravity',
  'cursor',
  'devin',
};

/// How long a deep link waits for the server's workspace before adding its
/// tab — a tab added to the disk copy would be overwritten by the server's.
const _workspaceLoadTimeout = Duration(seconds: 5);

/// Opens an agent session as a terminal tab resuming it in its CLI — the
/// way every "open session" link (board, scheduler, palette, deep links)
/// works now that sessions have no chat view. Returns the route showing the
/// tab (`/workspace` or `/terminal`) or a localized error. Widgets pass
/// `ProviderScope.containerOf(context)`; [newPane] opens the tab in a pane
/// of its own.
Future<({String? route, String? error})> openSessionInTerminal(
  ProviderContainer container,
  String sessionId, {
  bool newPane = false,
}) async {
  final Session session;
  try {
    session = await container.read(sessionsRepositoryProvider).details(sessionId);
  } on Object catch (e) {
    return (route: null, error: t.terminal.openSession.failed(error: '$e'));
  }
  final provider = session.provider ?? 'claude';
  final projectPath = session.projectFullPath ?? session.projectPath;
  if (!terminalResumableProviders.contains(provider)) {
    return (route: null, error: t.terminal.openSession.notResumable);
  }
  if (projectPath == null || projectPath.isEmpty) {
    return (route: null, error: t.workspace.unknownProjectPath);
  }

  await _workspaceLoaded(container);
  final host = container
      .read(workspaceProvider.notifier)
      .openSessionTab(
        sessionId: session.sessionId,
        provider: provider,
        projectPath: projectPath,
        projectId: session.projectId,
        title: session.displayTitle,
        newPane: newPane,
      );
  if (host == null) return (route: null, error: t.terminal.openSession.full);
  return (route: host == terminalRouteHost ? '/terminal' : '/workspace', error: null);
}

Future<void> _workspaceLoaded(ProviderContainer container) async {
  if (container.read(workspaceProvider).serverLoaded) return;
  final loaded = Completer<void>();
  final sub = container.listen(workspaceProvider.select((s) => s.serverLoaded), (_, next) {
    if (next && !loaded.isCompleted) loaded.complete();
  });
  try {
    await loaded.future.timeout(_workspaceLoadTimeout, onTimeout: () {});
  } finally {
    sub.close();
  }
}
