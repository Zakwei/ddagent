import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SessionsState {
  const SessionsState({
    this.sessions = const [],
    this.loading = true,
    this.showArchived = false,
    this.error,
  });

  final List<Session> sessions;
  final bool loading;
  final bool showArchived;
  final String? error;

  SessionsState copyWith({
    List<Session>? sessions,
    bool? loading,
    bool? showArchived,
    String? Function()? error,
  }) => SessionsState(
    sessions: sessions ?? this.sessions,
    loading: loading ?? this.loading,
    showArchived: showArchived ?? this.showArchived,
    error: error != null ? error() : this.error,
  );
}

/// Sessions for one project scope (`null` = global, backs /sessions and the
/// pinned set). WS session events debounce-reload the list.
class SessionsController extends Notifier<SessionsState> {
  SessionsController(this._scope);

  final (String?, String?) _scope;

  Timer? _reloadDebounce;
  StreamSubscription<dynamic>? _eventsSub;
  bool _loaded = false;

  SessionsRepository get _repo => ref.read(sessionsRepositoryProvider);
  ProjectsRepository get _projects => ref.read(projectsRepositoryProvider);

  @override
  SessionsState build() {
    _eventsSub?.cancel();
    _eventsSub = ref.read(chatChannelProvider).events.listen((e) {
      if (e.kind == 'session_upserted' ||
          e.kind == 'session_removed' ||
          e.kind == 'websocket_reconnected') {
        _reloadDebounce?.cancel();
        _reloadDebounce = Timer(const Duration(milliseconds: 400), () => unawaited(load()));
      }
    });
    ref.onDispose(() {
      unawaited(_eventsSub?.cancel());
      _reloadDebounce?.cancel();
    });
    if (!_loaded) {
      _loaded = true;
      Future(load);
    }
    return const SessionsState();
  }

  Future<void> load() async {
    try {
      final (projectId, projectPath) = _scope;
      List<Session> list;
      if (state.showArchived) {
        // Endpoint is global — scope it back to this project (mobile parity).
        final all = await _repo.archived();
        list = [
          for (final s in all)
            if (projectId == null ||
                s.projectId == null ||
                s.projectId == projectId ||
                (projectPath != null && s.projectPath == projectPath))
              s,
        ];
      } else if (projectId != null) {
        final page = await _projects.sessions(projectId, limit: 50);
        list = [for (final m in page.sessions) Session.fromApi(m)];
      } else {
        list = (await _repo.recent(limit: 100)).sessions;
      }
      if (!ref.mounted) return;
      state = state.copyWith(sessions: list, loading: false, error: () => null);
    } on Object catch (e) {
      if (!ref.mounted) return;
      state = state.copyWith(loading: false, error: () => e is AppError ? e.message : '$e');
    }
  }

  Future<void> toggleArchived() async {
    state = state.copyWith(showArchived: !state.showArchived, loading: true);
    await load();
  }

  /// Optimistic rename; reload on failure.
  Future<String?> rename(String sessionId, String summary) async {
    state = state.copyWith(
      sessions: [
        for (final s in state.sessions)
          if (s.sessionId == sessionId)
            s.copyWith(raw: {...s.raw, 'summary': summary}, summary: summary)
          else
            s,
      ],
    );
    try {
      await _repo.rename(sessionId, summary);
      return null;
    } on AppError catch (e) {
      await load();
      return e.message;
    }
  }

  Future<String?> archive(String sessionId) => _mutate(() => _repo.delete(sessionId));

  Future<String?> restore(String sessionId) => _mutate(() => _repo.restore(sessionId));

  Future<String?> hardDelete(String sessionId) =>
      _mutate(() => _repo.delete(sessionId, hardDelete: true));

  Future<String?> changeWorkspace(String sessionId, String projectPath) =>
      _mutate(() => _repo.changeWorkspace(sessionId, projectPath));

  Future<String?> _mutate(Future<void> Function() call) async {
    try {
      await call();
      await load();
      return null;
    } on AppError catch (e) {
      return e.message;
    }
  }

  /// Pin state is a local preference (mobile uses AsyncStorage; Hive here).
  static const _pinKey = 'pinnedSessions';

  bool isPinned(String sessionId) =>
      Hive.isBoxOpen('settings') &&
      ((Hive.box<dynamic>('settings').get(_pinKey) as List?)?.contains(sessionId) ?? false);

  /// Returns true when the session got pinned.
  bool togglePin(String sessionId) {
    if (!Hive.isBoxOpen('settings')) return false;
    final box = Hive.box<dynamic>('settings');
    final list = [...?((box.get(_pinKey) as List?)?.cast<String>())];
    final pinned = !list.contains(sessionId);
    if (pinned) {
      list.add(sessionId);
    } else {
      list.remove(sessionId);
    }
    unawaited(box.put(_pinKey, list));
    // Rebuild sorting — copyWith triggers listeners with the same sessions.
    state = state.copyWith(sessions: [...state.sessions]);
    return pinned;
  }

  List<Session> sorted(List<Session> list) {
    int rank(Session s) {
      final t = DateTime.tryParse(s.updatedAt ?? '')?.millisecondsSinceEpoch ?? 0;
      return -t;
    }

    final sortedList = [...list]..sort((a, b) => rank(a).compareTo(rank(b)));
    return [...sortedList]..sort((a, b) {
      final pa = isPinned(a.sessionId);
      final pb = isPinned(b.sessionId);
      if (pa != pb) return pa ? -1 : 1;
      return 0;
    });
  }
}

final sessionsProvider =
    NotifierProvider.family<SessionsController, SessionsState, (String?, String?)>(
      SessionsController.new,
    );

/// Session metadata by id — the chat pane resolves the provider (and the
/// model the run uses) from here, like the web's `selectedSession`, so the
/// banner/composer never have to guess from the first transcript row.
final sessionDetailsProvider = FutureProvider.family<Session, String>(
  (ref, sessionId) => ref.watch(sessionsRepositoryProvider).details(sessionId),
);
