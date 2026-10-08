import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One named provider account row — mirrors the web `ProviderAccount`
/// (src/hooks/useProviderAccounts.ts). The shared freezed model drops
/// `envOverrides`/`isDefault`, so the settings UI parses the raw payload here.
class ProviderAccountEntry {
  const ProviderAccountEntry({
    required this.id,
    required this.provider,
    required this.label,
    required this.envOverrides,
    required this.isDefault,
  });

  final String id;
  final String provider;
  final String label;
  final Map<String, String> envOverrides;
  final bool isDefault;

  factory ProviderAccountEntry.fromJson(Map<String, dynamic> json) => ProviderAccountEntry(
    id: '${json['id']}',
    provider: json['provider']?.toString() ?? '',
    label: json['label']?.toString() ?? '',
    envOverrides: {
      for (final e in (json['envOverrides'] as Map? ?? const {}).entries)
        e.key.toString(): '${e.value}',
    },
    isDefault: json['isDefault'] == true,
  );
}

/// Token/cost rollup of one account (`GET /provider-accounts/:id/usage`).
class AccountUsage {
  const AccountUsage({required this.totalTokens, this.costUsd});

  final int totalTokens;
  final double? costUsd;
}

class ProviderAccountsState {
  const ProviderAccountsState({
    this.accounts = const [],
    this.loading = false,
    this.busy = false,
    this.error,
    this.usageById = const {},
  });

  final List<ProviderAccountEntry> accounts;
  final bool loading;

  /// Serializes add/remove/make-default like the web `busy` flag.
  final bool busy;
  final String? error;
  final Map<String, AccountUsage> usageById;

  ProviderAccountsState copyWith({
    List<ProviderAccountEntry>? accounts,
    bool? loading,
    bool? busy,
    String? Function()? error,
    Map<String, AccountUsage>? usageById,
  }) => ProviderAccountsState(
    accounts: accounts ?? this.accounts,
    loading: loading ?? this.loading,
    busy: busy ?? this.busy,
    error: error != null ? error() : this.error,
    usageById: usageById ?? this.usageById,
  );
}

/// Named-account CRUD for one provider — `''` fetches every provider's rows
/// (the orchestration candidate pool groups them by `provider`).
class ProviderAccountsController extends Notifier<ProviderAccountsState> {
  ProviderAccountsController(this._provider);

  /// Provider id (`claude`, `codex`, …) or `''` for all providers.
  final String _provider;

  @override
  ProviderAccountsState build() {
    unawaited(Future.microtask(refresh));
    return const ProviderAccountsState(loading: true);
  }

  Future<void> refresh() async {
    try {
      final data = await apiCall(
        () => ref
            .read(dioProvider)
            .get<dynamic>(
              '/api/provider-accounts',
              queryParameters: {if (_provider.isNotEmpty) 'provider': _provider},
            ),
        (d) => d,
      );
      if (!ref.mounted) return;
      final list = data is Map ? data['accounts'] as List? : data as List?;
      state = state.copyWith(
        accounts: [
          for (final a in list ?? const [])
            ProviderAccountEntry.fromJson(Map<String, dynamic>.from(a as Map)),
        ],
        loading: false,
        error: () => null,
      );
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(loading: false, error: () => e.message);
      }
    }
  }

  /// Returns null on success, otherwise the error to surface — same contract
  /// as the api-credentials controller.
  Future<String?> add(String label) => _run(
    () => apiCall(
      () => ref
          .read(dioProvider)
          .post<dynamic>(
            '/api/provider-accounts',
            data: {'provider': _provider, 'label': label.trim()},
          ),
      (_) {},
    ),
  );

  Future<String?> remove(String id) => _run(
    () =>
        apiCall(() => ref.read(dioProvider).delete<dynamic>('/api/provider-accounts/$id'), (_) {}),
  );

  Future<String?> makeDefault(String id) => _run(
    () => apiCall(
      () => ref
          .read(dioProvider)
          .patch<dynamic>('/api/provider-accounts/$id', data: {'isDefault': true}),
      (_) {},
    ),
  );

  /// Best-effort like the web — a failed usage call just keeps the button.
  Future<void> loadUsage(String id) async {
    try {
      final data = await apiCall(
        () => ref.read(dioProvider).get<dynamic>('/api/provider-accounts/$id/usage'),
        (d) => d,
      );
      if (!ref.mounted) return;
      final usage = data is Map ? data['usage'] : null;
      if (usage is Map) {
        final cost = usage['costUsd'];
        state = state.copyWith(
          usageById: {
            ...state.usageById,
            id: AccountUsage(
              totalTokens: (usage['totalTokens'] as num?)?.toInt() ?? 0,
              costUsd: cost is num ? cost.toDouble() : null,
            ),
          },
        );
      }
    } on Object {
      // Quota display is best-effort — the row just keeps the load button.
    }
  }

  Future<String?> _run(Future<void> Function() call) async {
    state = state.copyWith(busy: true, error: () => null);
    try {
      await call();
      await refresh();
      if (ref.mounted) state = state.copyWith(busy: false);
      return null;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, error: () => e.message);
      }
      return e.message;
    }
  }
}

/// Keyed by provider id; `''` lists every provider's accounts.
final providerAccountsProvider = NotifierProvider.autoDispose
    .family<ProviderAccountsController, ProviderAccountsState, String>(
      ProviderAccountsController.new,
    );

/// Limit auto-switch preference (`/api/provider-accounts/settings`): when a
/// session's account runs out of its usage limit, the server moves it to
/// another account of the SAME agent that still has headroom — even over a
/// manual pick. One server-wide flag, off by default.
class AccountAutoSwitchController extends AsyncNotifier<bool> {
  static bool _parse(dynamic data) {
    final settings = data is Map ? data['settings'] : null;
    return settings is Map && settings['autoSwitchOnLimit'] == true;
  }

  @override
  Future<bool> build() =>
      apiCall(() => ref.read(dioProvider).get<dynamic>('/api/provider-accounts/settings'), _parse);

  /// Optimistic toggle; reverts and returns the error message when saving fails.
  Future<String?> setEnabled(bool value) async {
    final previous = state.value ?? false;
    state = AsyncData(value);
    try {
      final saved = await apiCall(
        () => ref
            .read(dioProvider)
            .put<dynamic>('/api/provider-accounts/settings', data: {'autoSwitchOnLimit': value}),
        _parse,
      );
      if (ref.mounted) state = AsyncData(saved);
      return null;
    } on AppError catch (e) {
      if (ref.mounted) state = AsyncData(previous);
      return e.message;
    }
  }
}

final accountAutoSwitchProvider =
    AsyncNotifierProvider.autoDispose<AccountAutoSwitchController, bool>(
      AccountAutoSwitchController.new,
    );
