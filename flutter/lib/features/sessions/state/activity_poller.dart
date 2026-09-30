import 'dart:async';

import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/session_activity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Server-side processing pulse — a 5 s poll of `GET /providers/sessions/running`
/// (web `AppContent.tsx` parity). The websocket already marks a session busy on
/// `status`/`complete`; this covers runs started elsewhere and re-seeds the map
/// after a page reload, where no frame was observed.
const activityPollInterval = Duration(seconds: 5);

/// Lifetime is tied to a `ref.watch` of this provider; the first watcher starts
/// the loop and the last one to leave stops it.
final activityPollerProvider = Provider<void>((ref) {
  final repo = ref.read(sessionsRepositoryProvider);
  Timer? timer;
  var inFlight = false;

  Future<void> tick() async {
    if (inFlight) return;
    inFlight = true;
    try {
      final running = await repo.running();
      if (!ref.mounted) return;
      ref
          .read(sessionActivityProvider.notifier)
          .sync([
            for (final s in running)
              (
                sessionId: s.sessionId,
                statusText: null,
                canInterrupt: true,
                startedAt: null,
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
  ref.onDispose(() => timer?.cancel());
});
