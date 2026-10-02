import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/browser_use/data/browser_use_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BrowserUseState {
  const BrowserUseState({
    this.status,
    this.sessions = const [],
    this.loading = false,
    this.busy = false,
    this.error,
  });

  final BrowserUseStatus? status;
  final List<BrowserUseSession> sessions;
  final bool loading;
  final bool busy;
  final String? error;

  bool get runtimeReady => status?.available ?? false;

  BrowserUseState copyWith({
    BrowserUseStatus? Function()? status,
    List<BrowserUseSession>? sessions,
    bool? loading,
    bool? busy,
    String? Function()? error,
  }) => BrowserUseState(
    status: status != null ? status() : this.status,
    sessions: sessions ?? this.sessions,
    loading: loading ?? this.loading,
    busy: busy ?? this.busy,
    error: error != null ? error() : this.error,
  );
}

class BrowserUseController extends Notifier<BrowserUseState> {
  BrowserUseRepository get _repo => ref.read(browserUseRepositoryProvider);

  @override
  BrowserUseState build() {
    unawaited(refresh());
    return const BrowserUseState(loading: true);
  }

  void clearError() => state = state.copyWith(error: () => null);

  Future<void> refresh() async {
    try {
      final results = await Future.wait([_repo.status(), _repo.sessions()]);
      if (!ref.mounted) return;
      state = state.copyWith(
        status: () => results[0] as BrowserUseStatus,
        sessions: results[1] as List<BrowserUseSession>,
        loading: false,
      );
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(loading: false, error: () => e.message);
      }
    }
  }

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

  /// Long-running install — refresh() after covers the updated readiness.
  Future<bool> installRuntime() async {
    if (state.busy) return false;
    state = state.copyWith(busy: true, error: () => null);
    try {
      final status = await _repo.installRuntime();
      if (!ref.mounted) return true;
      state = state.copyWith(status: () => status, busy: false);
      unawaited(refresh());
      return status.available;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, error: () => e.message);
      }
      return false;
    }
  }

  Future<bool> stopSession(String sessionId) => _mutate(() => _repo.stopSession(sessionId));

  Future<bool> deleteSession(String sessionId) => _mutate(() => _repo.deleteSession(sessionId));
}

final browserUseProvider = NotifierProvider<BrowserUseController, BrowserUseState>(
  BrowserUseController.new,
);

/// `GET /api/browser-use/settings` → `enabled` — gates the nav entry for the
/// agent-browser page the same way `shouldShowBrowserTab` gates the web tab.
/// Invalidated by the settings section after a save.
final browserUseEnabledProvider = FutureProvider<bool>((ref) async {
  try {
    final res = await ref.watch(browserUseRepositoryProvider).settings();
    return (res['settings'] as Map?)?['enabled'] == true;
  } on Object {
    return false;
  }
});
