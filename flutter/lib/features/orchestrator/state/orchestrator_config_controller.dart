import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/features/orchestrator/data/orchestrator_config.dart';
import 'package:ddagent_app/features/orchestrator/data/orchestrator_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for Settings → Orchestration — port of `useOrchestratorConfig.ts`:
/// loads the config once, keeps a local draft plus the saved snapshot for
/// dirty tracking, persists via `PUT /api/orchestrator/config`.
class OrchestratorConfigState {
  const OrchestratorConfigState({
    this.draft,
    this.saved,
    this.loading = true,
    this.loadFailed = false,
    this.saving = false,
    this.error,
    this.savedNotice = false,
  });

  /// Edited copy shown in the UI — null until the first load lands.
  final OrchestratorConfigData? draft;

  /// Last config the server confirmed (for dirty tracking + discard).
  final OrchestratorConfigData? saved;
  final bool loading;
  final bool loadFailed;
  final bool saving;
  final String? error;
  final bool savedNotice;

  /// Web parity: `JSON.stringify(config) !== JSON.stringify(savedConfig)`.
  bool get dirty {
    final d = draft;
    final s = saved;
    if (d == null || s == null) return false;
    return jsonEncode(d.toJson()) != jsonEncode(s.toJson());
  }

  OrchestratorConfigState copyWith({
    OrchestratorConfigData? Function()? draft,
    OrchestratorConfigData? Function()? saved,
    bool? loading,
    bool? loadFailed,
    bool? saving,
    String? Function()? error,
    bool? savedNotice,
  }) => OrchestratorConfigState(
    draft: draft != null ? draft() : this.draft,
    saved: saved != null ? saved() : this.saved,
    loading: loading ?? this.loading,
    loadFailed: loadFailed ?? this.loadFailed,
    saving: saving ?? this.saving,
    error: error != null ? error() : this.error,
    savedNotice: savedNotice ?? this.savedNotice,
  );
}

class OrchestratorConfigController extends Notifier<OrchestratorConfigState> {
  OrchestratorRepository get _repo => ref.read(orchestratorRepositoryProvider);

  @override
  OrchestratorConfigState build() {
    unawaited(Future.microtask(load));
    return const OrchestratorConfigState();
  }

  Future<void> load() async {
    state = state.copyWith(loading: true, loadFailed: false);
    try {
      final data = await _repo.config();
      if (!ref.mounted) return;
      final raw = data['config'];
      final config = raw is Map
          ? OrchestratorConfigData.fromJson(Map<String, dynamic>.from(raw))
          : throw const FormatException('missing config');
      state = state.copyWith(
        draft: () => config,
        saved: () => config,
        loading: false,
        error: () => null,
        savedNotice: false,
      );
    } on Object {
      if (ref.mounted) {
        state = state.copyWith(loading: false, loadFailed: true);
      }
    }
  }

  /// Applies [recipe] to the draft — the only mutation path, mirroring the
  /// web `update()` hook.
  void update(OrchestratorConfigData Function(OrchestratorConfigData) recipe) {
    final current = state.draft;
    if (current == null) return;
    state = state.copyWith(draft: () => recipe(current), savedNotice: false);
  }

  /// PUT the draft; the server-validated config replaces both copies.
  Future<void> save() async {
    final draft = state.draft;
    if (draft == null || state.saving) return;
    state = state.copyWith(saving: true, error: () => null, savedNotice: false);
    try {
      // repo.saveConfig() discards the body — PUT here directly so the
      // server-validated config replaces both draft and snapshot.
      final data = await apiCall(
        () => ref
            .read(dioProvider)
            .put<dynamic>('/api/orchestrator/config', data: {'config': draft.toJson()}),
        (d) => d,
      );
      if (!ref.mounted) return;
      final raw = data is Map ? data['config'] : null;
      final confirmed = raw is Map
          ? OrchestratorConfigData.fromJson(Map<String, dynamic>.from(raw))
          : draft;
      state = state.copyWith(
        draft: () => confirmed,
        saved: () => confirmed,
        saving: false,
        savedNotice: true,
      );
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(saving: false, error: () => e.message);
      }
    }
  }

  void discard() {
    final saved = state.saved;
    if (saved == null) return;
    state = state.copyWith(draft: () => saved, error: () => null, savedNotice: false);
  }
}

/// Settings-section scoped: leaving the tab drops the draft like the React
/// tab unmount does.
final orchestratorConfigProvider =
    NotifierProvider.autoDispose<OrchestratorConfigController, OrchestratorConfigState>(
      OrchestratorConfigController.new,
    );
