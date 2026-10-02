import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/scheduler/data/scheduler_models.dart';
import 'package:ddagent_app/features/scheduler/data/scheduler_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchedulerState {
  const SchedulerState({
    this.jobs = const [],
    this.runs = const {},
    this.cronPreview,
    this.cronError,
    this.previewLoading = false,
    this.loading = false,
    this.busy = false,
    this.error,
  });

  final List<SchedulerJob> jobs;

  /// Run history per schedule id — lazily loaded, survives list refreshes.
  final Map<String, List<SchedulerRun>> runs;
  final CronPreview? cronPreview;
  final String? cronError;
  final bool previewLoading;
  final bool loading;
  final bool busy;
  final String? error;

  SchedulerState copyWith({
    List<SchedulerJob>? jobs,
    Map<String, List<SchedulerRun>>? runs,
    CronPreview? Function()? cronPreview,
    String? Function()? cronError,
    bool? previewLoading,
    bool? loading,
    bool? busy,
    String? Function()? error,
  }) => SchedulerState(
    jobs: jobs ?? this.jobs,
    runs: runs ?? this.runs,
    cronPreview: cronPreview != null ? cronPreview() : this.cronPreview,
    cronError: cronError != null ? cronError() : this.cronError,
    previewLoading: previewLoading ?? this.previewLoading,
    loading: loading ?? this.loading,
    busy: busy ?? this.busy,
    error: error != null ? error() : this.error,
  );
}

class SchedulerController extends Notifier<SchedulerState> {
  /// Debounce window for the create-dialog cron preview.
  static const previewDebounce = Duration(milliseconds: 400);

  Timer? _previewTimer;
  int _previewSeq = 0;

  SchedulerRepository get _repo => ref.read(schedulerRepositoryProvider);

  @override
  SchedulerState build() {
    ref.onDispose(() => _previewTimer?.cancel());
    unawaited(Future.microtask(refresh));
    return const SchedulerState(loading: true);
  }

  void clearError() => state = state.copyWith(error: () => null);

  Future<void> refresh() async {
    try {
      final rows = await _repo.list();
      if (!ref.mounted) return;
      state = state.copyWith(
        jobs: [for (final j in rows) SchedulerJob.fromJson(j)],
        loading: false,
      );
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(loading: false, error: () => e.message);
      }
    }
  }

  // ─── Cron preview (debounced; server materializes nextRunAt) ───────────

  /// Called on every keystroke — validates locally first, then asks the
  /// server for the next fire time after [previewDebounce].
  void previewCron(String expr) {
    _previewTimer?.cancel();
    final seq = ++_previewSeq;
    if (expr.trim().isEmpty) {
      state = state.copyWith(cronPreview: () => null, cronError: () => null, previewLoading: false);
      return;
    }
    final local = validateCron(expr);
    if (local != null) {
      state = state.copyWith(
        cronPreview: () => null,
        cronError: () => local,
        previewLoading: false,
      );
      return;
    }
    state = state.copyWith(previewLoading: true, cronError: () => null);
    _previewTimer = Timer(previewDebounce, () async {
      try {
        final res = await _repo.preview(expr.trim());
        if (!ref.mounted || seq != _previewSeq) return;
        state = state.copyWith(cronPreview: () => CronPreview.fromJson(res), previewLoading: false);
      } on AppError catch (e) {
        if (!ref.mounted || seq != _previewSeq) return;
        state = state.copyWith(
          cronPreview: () => null,
          cronError: () => e.message,
          previewLoading: false,
        );
      }
    });
  }

  // ─── CRUD ──────────────────────────────────────────────────────────────

  Future<bool> _mutate(Future<void> Function() op) async {
    if (state.busy) return false;
    state = state.copyWith(busy: true, error: () => null);
    try {
      await op();
      if (!ref.mounted) return true;
      state = state.copyWith(busy: false);
      unawaited(refresh());
      return true;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, error: () => e.message);
      }
      return false;
    }
  }

  Future<bool> createJob(Map<String, dynamic> body) => _mutate(() => _repo.create(body));

  Future<bool> updateJob(String id, Map<String, dynamic> body) =>
      _mutate(() => _repo.update(id, body));

  Future<bool> deleteJob(String id) => _mutate(() => _repo.delete(id));

  Future<bool> toggleEnabled(String id, bool enabled) => updateJob(id, {'enabled': enabled});

  /// Fires the schedule immediately — response carries the updated schedule
  /// and the run lands in history, so refresh both.
  Future<bool> runNow(String id) => _mutate(() async {
    await _repo.runNow(id);
    unawaited(loadRuns(id, force: true));
  });

  // ─── Run history ───────────────────────────────────────────────────────

  Future<void> loadRuns(String scheduleId, {bool force = false}) async {
    if (!force && state.runs.containsKey(scheduleId)) return;
    try {
      final rows = await _repo.runs(scheduleId);
      if (!ref.mounted) return;
      state = state.copyWith(
        runs: {
          ...state.runs,
          scheduleId: [for (final r in rows) SchedulerRun.fromJson(r)],
        },
      );
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
    }
  }
}

final schedulerProvider = NotifierProvider<SchedulerController, SchedulerState>(
  SchedulerController.new,
);
