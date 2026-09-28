import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/quota/data/quota_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuotaState {
  const QuotaState({
    this.snapshot,
    this.config,
    this.fleet,
    this.histories = const {},
    this.refreshing = false,
    this.savingConfig = false,
    this.loading = false,
    this.error,
  });

  final QuotaSnapshot? snapshot;
  final QuotaConfig? config;
  final FleetSnapshot? fleet;
  final Map<String, AccountHistory> histories;
  final bool refreshing;
  final bool savingConfig;
  final bool loading;
  final String? error;

  List<QuotaAccount> get accounts => snapshot?.accounts ?? const [];

  QuotaState copyWith({
    QuotaSnapshot? Function()? snapshot,
    QuotaConfig? Function()? config,
    FleetSnapshot? Function()? fleet,
    Map<String, AccountHistory>? histories,
    bool? refreshing,
    bool? savingConfig,
    bool? loading,
    String? Function()? error,
  }) =>
      QuotaState(
        snapshot: snapshot != null ? snapshot() : this.snapshot,
        config: config != null ? config() : this.config,
        fleet: fleet != null ? fleet() : this.fleet,
        histories: histories ?? this.histories,
        refreshing: refreshing ?? this.refreshing,
        savingConfig: savingConfig ?? this.savingConfig,
        loading: loading ?? this.loading,
        error: error != null ? error() : this.error,
      );
}

class QuotaController extends Notifier<QuotaState> {
  QuotaRepository get _repo => ref.read(quotaRepositoryProvider);

  @override
  QuotaState build() {
    // Deferred — `state` is unavailable while build() is still running.
    unawaited(Future.microtask(load));
    return const QuotaState(loading: true);
  }

  void clearError() => state = state.copyWith(error: () => null);

  /// First load — snapshot + config + fleet in parallel (each best-effort so
  /// one failing endpoint doesn't blank the whole screen).
  Future<void> load() async {
    state = state.copyWith(loading: true, error: () => null);
    await Future.wait([
      _loadSnapshot(false),
      _loadConfig(),
      _loadFleet(),
    ]);
    if (ref.mounted) state = state.copyWith(loading: false);
  }

  /// POST /refresh — forces providers to re-read, updates the snapshot only.
  Future<bool> refresh() async {
    if (state.refreshing) return false;
    state = state.copyWith(refreshing: true, error: () => null);
    try {
      final res = await _repo.refresh();
      if (!ref.mounted) return true;
      state = state.copyWith(
        snapshot: () => QuotaSnapshot.fromJson(res),
        refreshing: false,
      );
      return true;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(refreshing: false, error: () => e.message);
      }
      return false;
    }
  }

  Future<void> _loadSnapshot(bool forced) async {
    try {
      final res = forced ? await _repo.refresh() : await _repo.snapshot();
      if (ref.mounted) {
        state = state.copyWith(snapshot: () => QuotaSnapshot.fromJson(res));
      }
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
    }
  }

  Future<void> _loadConfig() async {
    try {
      final res = await _repo.config();
      if (ref.mounted) {
        state = state.copyWith(config: () => QuotaConfig.fromJson(res));
      }
    } on AppError catch (_) {}
  }

  Future<void> _loadFleet() async {
    try {
      final res = await _repo.agents();
      if (ref.mounted) {
        state = state.copyWith(fleet: () => FleetSnapshot.fromJson(res));
      }
    } on AppError catch (_) {}
  }

  /// Sparkline series for one account (cached; force=false keeps the cache).
  Future<AccountHistory?> loadHistory(String accountId,
      {int? limit, bool force = false}) async {
    if (!force && state.histories.containsKey(accountId)) {
      return state.histories[accountId];
    }
    try {
      final res = await _repo.history(accountId, limit: limit);
      final history = AccountHistory(
        accountId: accountId,
        points: [for (final p in res) QuotaHistoryPoint.fromJson(p)],
      );
      if (ref.mounted) {
        state = state.copyWith(
          histories: {...state.histories, accountId: history},
        );
      }
      return history;
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
      return null;
    }
  }

  /// PUT /api/quota/config — saves poller/alerting config, updates state.
  Future<bool> saveConfig(QuotaConfig config) async {
    if (state.savingConfig) return false;
    state = state.copyWith(savingConfig: true, error: () => null);
    try {
      await _repo.saveConfig(config.toJson());
      if (!ref.mounted) return true;
      state = state.copyWith(config: () => config, savingConfig: false);
      return true;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(savingConfig: false, error: () => e.message);
      }
      return false;
    }
  }
}

final quotaProvider = NotifierProvider<QuotaController, QuotaState>(
  QuotaController.new,
);

// ─── Usage chart ──────────────────────────────────────────────────────────

const usagePeriods = ['24h', '7d', '30d', 'all'];
const usageGroupBys = ['provider', 'model', 'agent', 'tool'];

class UsageChartState {
  const UsageChartState({
    this.period = '7d',
    this.groupBy = 'provider',
    this.summary,
    this.loading = false,
    this.error,
  });

  final String period;
  final String groupBy;
  final UsageSummary? summary;
  final bool loading;
  final String? error;

  UsageChartState copyWith({
    String? period,
    String? groupBy,
    UsageSummary? Function()? summary,
    bool? loading,
    String? Function()? error,
  }) =>
      UsageChartState(
        period: period ?? this.period,
        groupBy: groupBy ?? this.groupBy,
        summary: summary != null ? summary() : this.summary,
        loading: loading ?? this.loading,
        error: error != null ? error() : this.error,
      );
}

class UsageChartController extends Notifier<UsageChartState> {
  QuotaRepository get _repo => ref.read(quotaRepositoryProvider);

  @override
  UsageChartState build() {
    // Deferred — `state` is unavailable while build() is still running.
    unawaited(Future.microtask(load));
    return const UsageChartState(loading: true);
  }

  void clearError() => state = state.copyWith(error: () => null);

  Future<void> load() async {
    state = state.copyWith(loading: true, error: () => null);
    try {
      final res = await _repo.usage(
        period: state.period,
        groupBy: state.groupBy,
      );
      if (!ref.mounted) return;
      state = state.copyWith(
        summary: () => UsageSummary.fromJson(res),
        loading: false,
      );
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(loading: false, error: () => e.message);
      }
    }
  }

  void setPeriod(String period) {
    if (period == state.period || !usagePeriods.contains(period)) return;
    state = state.copyWith(period: period);
    unawaited(load());
  }

  void setGroupBy(String groupBy) {
    if (groupBy == state.groupBy || !usageGroupBys.contains(groupBy)) return;
    state = state.copyWith(groupBy: groupBy);
    unawaited(load());
  }
}

final usageChartProvider =
    NotifierProvider<UsageChartController, UsageChartState>(
  UsageChartController.new,
);
