import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/session_activity.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Server-side processing pulse — a 5 s poll of `GET /providers/sessions/running`
/// (web `AppContent.tsx` parity). The websocket already marks a session busy on
/// `status`/`complete`; this covers runs started elsewhere and re-seeds the map
/// after a page reload, where no frame was observed.
const activityPollInterval = Duration(seconds: 5);

/// Compact port of the web `humanizeToolStatus`: a tool_use frame becomes the
/// pill's status line ("Reading foo.ts", "Running `npm test`").
String? _toolStatusText(Object? toolName, Object? toolInput) {
  final name = (toolName ?? '').toString().trim();
  if (name.isEmpty) return null;
  Object? raw = toolInput;
  if (raw is String) {
    try {
      raw = jsonDecode(raw);
    } on Object {
      raw = const {};
    }
  }
  final input = raw is Map ? raw : const <String, dynamic>{};
  final file = (input['file_path'] ?? input['path'] ?? input['file'] ?? '').toString();
  final cmd = (input['command'] ?? input['shell'] ?? '').toString();
  final url = (input['url'] ?? '').toString();
  final query = (input['query'] ?? '').toString();
  String base(String p) => p.split('/').last;

  switch (name.toLowerCase()) {
    case 'task' || 'run_subagent' || 'agent':
      return t.sessions.activity.subagentRunning;
    case 'read' || 'read_file' || 'grep' || 'glob':
      return file.isNotEmpty
          ? t.sessions.activity.readingFile(file: base(file))
          : t.sessions.activity.runningTool(name: name);
    case 'write' || 'write_file' || 'edit' || 'edit_file' || 'applypatch' || 'apply_patch':
      return file.isNotEmpty
          ? t.sessions.activity.editingFile(file: base(file))
          : t.sessions.activity.editingFileGeneric;
    case 'bash' || 'shell' || 'execute_command' || 'run_command':
      if (cmd.isEmpty) return t.sessions.activity.runningShellCommand;
      final short = cmd.length > 48 ? '${cmd.substring(0, 45)}…' : cmd;
      return t.sessions.activity.runningCommand(command: short);
    case 'commit' || 'git_commit':
      return t.sessions.activity.committingChanges;
    case 'push' || 'git_push':
      return t.sessions.activity.pushingBranch;
    case 'webfetch' || 'web_fetch' || 'websearch' || 'web_search':
      if (url.isNotEmpty) return t.sessions.activity.fetchingUrl(url: url);
      if (query.isNotEmpty) {
        final short = query.length > 40 ? '${query.substring(0, 37)}…' : query;
        return t.sessions.activity.searching(query: short);
      }
      return t.sessions.activity.runningTool(name: name);
    default:
      return null;
  }
}

/// Status line a frame contributes to the activity entry — null keeps the
/// previously set one (or the rotating fallback words).
String? _frameStatusText(ServerEvent e) => switch (e.kind) {
  'tool_use' => _toolStatusText(e.raw['toolName'], e.raw['toolInput']),
  'status' => switch (e.raw['text'] ?? e.raw['summary']) {
    'token_budget' || null => null, // control frame, not a user-facing label
    final text => text.toString(),
  },
  _ => null,
};

/// Kinds that mean a run is actively producing work for the session.
/// `stream_end` is intentionally absent — providers emit it at every message
/// boundary (each tool call, each continuation round), so it is not terminal;
/// `error` rows are informational mid-run noise. Only `complete`,
/// `protocol_error` and `session_removed` settle the session back to idle —
/// everything else either re-arms or leaves the entry alone.
const _workFrameKinds = {
  'status',
  'tool_use',
  'tool_result',
  'permission_request',
  'stream_delta',
  'thought_delta',
  'stream_replace',
};

void _onChannelEvent(
  ServerEvent e,
  SessionActivityController activity,
  Map<String, String?> completedRuns,
) {
  final sid = e.sessionId;
  if (sid == null) {
    // No pane owns a sessionless protocol error (INTERNAL_ERROR, role gates)
    // — say it once here instead of dropping it.
    if (e.kind == 'protocol_error') {
      AppToast.global(e.raw['error']?.toString() ?? t.chat.transcript.requestFailed, isError: true);
    }
    return;
  }
  switch (e.kind) {
    case 'complete':
      completedRuns[sid] = e.runId;
      activity.markIdle(sid);
      return;
    case 'protocol_error':
      if (!protocolErrorKeepsRun(e.raw)) activity.markIdle(sid);
      return;
    case 'session_removed':
      activity.markIdle(sid);
      return;
    case 'stream_end' || 'error' || 'permission_cancelled':
      return;
    default:
      if (e.isGateway || e.isBroadcast || !_workFrameKinds.contains(e.kind)) {
        return;
      }
      // Notices are transcript lines that may trail `complete`; a finished
      // run's late ask (background subagent) does not restart it either.
      if (e.kind == 'status' && e.raw['notice'] == true) return;
      if (e.kind == 'permission_request' && e.runId != null && completedRuns[sid] == e.runId) {
        return;
      }
      activity.markProcessing(sid, statusText: _frameStatusText(e));
  }
}

/// Lifetime is tied to a `ref.watch` of this provider; the first watcher starts
/// the loop and the last one to leave stops it.
final activityPollerProvider = Provider<void>((ref) {
  final repo = ref.read(sessionsRepositoryProvider);
  final activity = ref.read(sessionActivityProvider.notifier);
  // Global frame listener: the per-pane transcript controller only sees frames
  // while its session is open — runs keep streaming to this socket after the
  // pane closes (it was the run's writer), so terminal frames still settle the
  // map here instead of relying on the poll's grace window.
  final channel = ref.watch(chatChannelProvider);
  final completedRuns = <String, String?>{};
  final eventsSub = channel.events.listen((e) => _onChannelEvent(e, activity, completedRuns));
  Timer? timer;
  var inFlight = false;

  Future<void> tick() async {
    if (inFlight) return;
    inFlight = true;
    try {
      final running = await repo.running();
      if (!ref.mounted) return;
      activity.sync([
        for (final s in running)
          (
            sessionId: s.sessionId,
            statusText: null,
            canInterrupt: true,
            startedAt: (s.raw['startedAt'] as num?)?.toInt(),
          ),
      ]);
    } on Object {
      // Best-effort — a failed pulse leaves the last known set in place, the
      // same way the websocket-first path would.
    } finally {
      inFlight = false;
    }
  }

  unawaited(tick());
  timer = Timer.periodic(activityPollInterval, (_) => unawaited(tick()));
  ref.onDispose(() {
    timer?.cancel();
    unawaited(eventsSub.cancel());
  });
});
