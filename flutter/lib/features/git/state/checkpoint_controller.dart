import 'dart:async';

import 'package:ddagent_app/features/git/data/git_models.dart';
import 'package:ddagent_app/features/git/data/git_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Composer-scoped checkpoint state for the "Undo AI run" control — a lighter
/// sibling of [GitController] (which is project-panel scoped and refreshes the
/// whole git view). Mirrors the web `useGitCheckpoints` hook.
class CheckpointState {
  const CheckpointState({this.last, this.creating = false, this.undo = UndoState.idle, this.error});

  /// Snapshot taken before the most recent AI turn, if any.
  final GitCheckpoint? last;
  final bool creating;
  final UndoState undo;
  final String? error;

  /// The button only appears once a snapshot exists (web parity).
  bool get hasCheckpoint => last != null;

  CheckpointState copyWith({
    GitCheckpoint? last,
    bool? creating,
    UndoState? undo,
    String? Function()? error,
  }) => CheckpointState(
    last: last ?? this.last,
    creating: creating ?? this.creating,
    undo: undo ?? this.undo,
    error: error != null ? error() : this.error,
  );
}

enum UndoState { idle, restoring, restored, failed }

/// How long the "Undone" confirmation stays visible before the button returns.
const _restoredTimeout = Duration(seconds: 4);

class CheckpointController extends Notifier<CheckpointState> {
  CheckpointController(this._projectId);

  final String? _projectId;
  Timer? _restoredTimer;

  @override
  CheckpointState build() {
    ref.onDispose(() => _restoredTimer?.cancel());
    return const CheckpointState();
  }

  /// Snapshot before an AI turn — never throws; a failed checkpoint must not
  /// block the turn, it only records [error].
  Future<void> create({String? label}) async {
    final pid = _projectId;
    if (pid == null) return;
    _restoredTimer?.cancel();
    state = state.copyWith(creating: true, undo: UndoState.idle, error: () => null);
    try {
      final res = await ref.read(gitRepositoryProvider).checkpoint(pid, label: label);
      final raw = res['checkpoint'];
      if (res['success'] != true || raw is! Map<String, dynamic>) {
        throw Exception('${res['error'] ?? 'Failed to create checkpoint'}');
      }
      state = state.copyWith(creating: false, last: GitCheckpoint.fromJson(raw));
    } on Object catch (e) {
      state = state.copyWith(creating: false, error: () => '$e');
    }
  }

  /// Restores the working tree to the last snapshot. A newer checkpoint from
  /// another pane is surface-checked first (web `undoLastAiRun`).
  Future<void> undoLast() async {
    final pid = _projectId;
    final checkpoint = state.last;
    if (pid == null || checkpoint == null) return;

    state = state.copyWith(undo: UndoState.restoring, error: () => null);
    try {
      final list = await ref.read(gitRepositoryProvider).checkpoints(pid);
      final rows = (list['checkpoints'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .toList();
      final newest = rows.isEmpty ? null : GitCheckpoint.fromJson(rows.first);
      // Split panes share one repo: a newer checkpoint means restoring ours
      // would wipe that work too. The caller confirms via [shouldConfirm].
      if (newest != null && newest.ref != checkpoint.ref) {
        state = state.copyWith(undo: UndoState.idle, error: () => 'newer-checkpoint');
        return;
      }
      await _restore(pid, checkpoint.ref);
    } on Object catch (e) {
      state = state.copyWith(undo: UndoState.failed, error: () => '$e');
    }
  }

  /// Restore as confirmed by the user after [undoLast] reported
  /// `newer-checkpoint`.
  Future<void> forceUndo() async {
    final pid = _projectId;
    final checkpoint = state.last;
    if (pid == null || checkpoint == null) return;
    state = state.copyWith(undo: UndoState.restoring, error: () => null);
    try {
      await _restore(pid, checkpoint.ref);
    } on Object catch (e) {
      state = state.copyWith(undo: UndoState.failed, error: () => '$e');
    }
  }

  Future<void> _restore(String pid, String checkpointRef) async {
    final res = await ref.read(gitRepositoryProvider).checkpointRestore(pid, checkpointRef);
    if (res['success'] != true) {
      throw Exception('${res['error'] ?? 'Failed to restore checkpoint'}');
    }
    state = state.copyWith(undo: UndoState.restored);
    _restoredTimer?.cancel();
    _restoredTimer = Timer(_restoredTimeout, () {
      if (ref.mounted) state = state.copyWith(undo: UndoState.idle);
    });
  }

  void clearError() => state = state.copyWith(error: () => null);
}

/// Composer-scoped, keyed by project id (null = no project → inert).
final checkpointProvider = NotifierProvider.family<CheckpointController, CheckpointState, String?>(
  CheckpointController.new,
);
