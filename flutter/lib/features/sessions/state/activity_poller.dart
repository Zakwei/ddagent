import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/session_activity.dart';
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
      return 'Subagent running';
    case 'read' || 'read_file' || 'grep' || 'glob':
      return file.isNotEmpty ? 'Reading ${base(file)}' : 'Running $name';
    case 'write' || 'write_file' || 'edit' || 'edit_file' || 'applypatch' || 'apply_patch':
      return file.isNotEmpty ? 'Editing ${base(file)}' : 'Editing a file';
    case 'bash' || 'shell' || 'execute_command' || 'run_command':
      if (cmd.isEmpty) return 'Running a shell command';
      final short = cmd.length > 48 ? '${cmd.substring(0, 45)}…' : cmd;
      return 'Running `$short`';
    case 'commit' || 'git_commit':
      return 'Committing changes';
    case 'push' || 'git_push':
      return 'Pushing branch';
    case 'webfetch' || 'web_fetch' || 'websearch' || 'web_search':
      if (url.isNotEmpty) return 'Fetching $url';
      if (query.isNotEmpty) {
        final short = query.length > 40 ? '${query.substring(0, 37)}…' : query;
        return 'Searching “$short”';
      }
      return 'Running $name';
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

void _onChannelEvent(ServerEvent e, SessionActivityController activity) {
  final sid = e.sessionId;
  if (sid == null) return;
  switch (e.kind) {
    case 'complete' || 'protocol_error' || 'session_removed':
      activity.markIdle(sid);
      return;
    case 'stream_end' || 'error' || 'permission_cancelled':
      return;
    default:
      if (e.isGateway || e.isBroadcast || !_workFrameKinds.contains(e.kind)) {
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
  final eventsSub = channel.events.listen((e) => _onChannelEvent(e, activity));
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
