import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Which sessions are actively processing a request — single source of truth
/// for the activity indicator / abort button (port of useSessionProtection).
class SessionActivity {
  const SessionActivity({this.statusText, this.canInterrupt = true, required this.startedAt});

  /// Provider-supplied status line; null renders the default label.
  final String? statusText;
  final bool canInterrupt;

  /// Client clock when this request was first marked processing — drives the
  /// elapsed display and the stale `chat_subscribed` idle-ack guard.
  final int startedAt;
}

class SessionActivityController extends Notifier<Map<String, SessionActivity>> {
  /// Locally-marked sessions survive a sync for this long — a subscribe ack
  /// emitted before the send can't instantly unmark a fresh request.
  static const localActivityGraceMs = 10 * 1000;

  @override
  Map<String, SessionActivity> build() => {};

  /// [startedAt] lets a caller anchor the timer on the server-reported run
  /// start (`chat_subscribed` ack, `/sessions/running` poll) instead of the
  /// moment this client happened to observe the first frame.
  void markProcessing(String? sessionId, {String? statusText, bool? canInterrupt, int? startedAt}) {
    if (sessionId == null) return;
    final existing = state[sessionId];
    final next = SessionActivity(
      statusText: statusText ?? existing?.statusText,
      canInterrupt: canInterrupt ?? existing?.canInterrupt ?? true,
      startedAt:
          existing?.startedAt ??
          (startedAt != null && startedAt > 0 ? startedAt : DateTime.now().millisecondsSinceEpoch),
    );
    if (existing != null &&
        existing.statusText == next.statusText &&
        existing.canInterrupt == next.canInterrupt) {
      return;
    }
    state = {...state, sessionId: next};
  }

  /// `ifStartedBefore` guards stale idle acks: an ack emitted before a newer
  /// request started must not clear it.
  void markIdle(String? sessionId, {int? ifStartedBefore}) {
    if (sessionId == null) return;
    final existing = state[sessionId];
    if (existing == null) return;
    if (ifStartedBefore != null && existing.startedAt >= ifStartedBefore) {
      return;
    }
    state = {...state}..remove(sessionId);
  }

  /// Merge an authoritative processing-session list (subscribe ack) — local
  /// marks younger than the grace window survive absence in the snapshot.
  void sync(
    Iterable<({String sessionId, String? statusText, bool? canInterrupt, int? startedAt})> sessions,
  ) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final incoming = {for (final s in sessions) s.sessionId: s};
    final next = <String, SessionActivity>{};
    for (final s in sessions) {
      final existing = state[s.sessionId];
      final startedAt = s.startedAt != null && s.startedAt! > 0
          ? s.startedAt!
          : existing?.startedAt ?? now;
      next[s.sessionId] = SessionActivity(
        statusText: s.statusText ?? existing?.statusText,
        canInterrupt: s.canInterrupt ?? existing?.canInterrupt ?? true,
        startedAt: startedAt,
      );
    }
    for (final e in state.entries) {
      if (!incoming.containsKey(e.key) && now - e.value.startedAt < localActivityGraceMs) {
        next[e.key] = e.value;
      }
    }
    state = next;
  }

  bool isProcessing(String sessionId) => state.containsKey(sessionId);
}

final sessionActivityProvider =
    NotifierProvider<SessionActivityController, Map<String, SessionActivity>>(
      SessionActivityController.new,
    );

/// One task running in the background, as the server describes it — the
/// agent's own description ("Run the checkout tests") and its kind
/// (`local_bash`, `local_agent`, …; null when unknown).
class BackgroundTask {
  const BackgroundTask({required this.id, required this.description, this.type});

  factory BackgroundTask.fromJson(Map<String, dynamic> json) => BackgroundTask(
    id: json['id']?.toString() ?? '',
    description: json['description']?.toString() ?? '',
    type: json['type']?.toString(),
  );

  final String id;
  final String description;
  final String? type;
}

/// Background tasks (subagents, background shells, workflows) still running
/// per session, from the server's `background_tasks` frames. They can outlive
/// the turn that started them, so this is independent of [SessionActivity]:
/// a session can be idle (no turn running) and still have work going on.
/// Servers before 0.8.14 send only a count, so [tasks] can be shorter than it.
class BackgroundTasksController
    extends Notifier<Map<String, ({int count, List<BackgroundTask> tasks})>> {
  @override
  Map<String, ({int count, List<BackgroundTask> tasks})> build() => {};

  void set(String? sessionId, int count, List<BackgroundTask> tasks) {
    if (sessionId == null) return;
    if (count <= 0) {
      if (state.containsKey(sessionId)) state = {...state}..remove(sessionId);
      return;
    }
    state = {...state, sessionId: (count: count, tasks: tasks)};
  }
}

final backgroundTasksProvider =
    NotifierProvider<
      BackgroundTasksController,
      Map<String, ({int count, List<BackgroundTask> tasks})>
    >(BackgroundTasksController.new);
