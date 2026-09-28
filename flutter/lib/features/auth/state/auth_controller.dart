import 'dart:async';

import 'package:ddagent_app/core/config/env.dart';
import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/network/auth_token_store.dart';
import 'package:ddagent_app/features/auth/data/auth_repository.dart';
import 'package:ddagent_app/features/user/data/user_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Auth session state — port of AuthContext.tsx (user/needsSetup/isLoading
/// + login/register/logout + mid-life token refresh).
class AuthState {
  const AuthState({
    this.user,
    this.isLoading = false,
    this.needsSetup = false,
    this.onboardingDone = true,
  });

  final AuthUser? user;
  final bool isLoading;

  /// Server has no owner account yet — route to /setup instead of /login.
  final bool needsSetup;

  /// `hasCompletedOnboarding` — fail-open true so a transient status
  /// failure never blocks access (web parity). Gate: /onboarding route.
  final bool onboardingDone;

  bool get authenticated => user != null;
}

class AuthController extends Notifier<AuthState> {
  Timer? _refreshTimer;
  AppLifecycleListener? _lifecycle;
  bool _statusChecked = false;

  @override
  AuthState build() {
    final tokens = ref.watch(authTokenStoreProvider);
    final expiredSub = tokens.onSessionExpired.listen((_) {
      // X-Auth-Error cleared the token — drop the user so the router guard
      // bounces to /login (toast is shown by the app listener).
      state = AuthState(needsSetup: state.needsSetup);
    });
    final refreshedSub = tokens.onTokenRefreshed.listen(_scheduleRefresh);
    ref.onDispose(() {
      _refreshTimer?.cancel();
      _lifecycle?.dispose();
      unawaited(expiredSub.cancel());
      unawaited(refreshedSub.cancel());
    });
    if (Env.embedded) {
      // Platform build: sidecar serves the UI — no auth screens at all.
      return const AuthState(user: AuthUser(id: 0, username: 'platform-user'));
    }
    if (!_statusChecked) {
      _statusChecked = true;
      // Deferred: state must not be mutated inside build.
      Future(checkStatus);
    }
    return const AuthState(isLoading: true);
  }

  /// GET /auth/status → needsSetup short-circuit; then rehydrate the user
  /// when a stored token is still accepted by the server.
  Future<void> checkStatus() async {
    final repo = ref.read(authRepositoryProvider);
    try {
      final status = await repo.status();
      if (status.needsSetup) {
        state = const AuthState(needsSetup: true);
        return;
      }
      final token = await ref.read(authTokenStoreProvider).token;
      if (token == null) {
        state = const AuthState();
        return;
      }
      final user = await repo.currentUser();
      _scheduleRefresh(token);
      _watchLifecycle();
      state = AuthState(user: user, onboardingDone: await _readOnboarding());
    } on AuthError {
      await ref.read(authTokenStoreProvider).clear();
      state = const AuthState();
    } on AppError {
      // Server unreachable — keep the stored token; retry on next launch.
      state = const AuthState();
    }
  }

  /// Returns null on success, otherwise the error to display.
  Future<AppError?> login(String username, String password) =>
      _run(() => ref.read(authRepositoryProvider).login(username, password));

  Future<AppError?> register(String username, String password, {String? inviteToken}) => _run(
    () => ref.read(authRepositoryProvider).register(username, password, inviteToken: inviteToken),
  );

  Future<AppError?> _run(Future<AuthUser> Function() call) async {
    state = AuthState(needsSetup: state.needsSetup, isLoading: true);
    try {
      final user = await call();
      final token = await ref.read(authTokenStoreProvider).token;
      if (token != null) {
        _scheduleRefresh(token);
        _watchLifecycle();
      }
      state = AuthState(user: user, onboardingDone: await _readOnboarding());
      return null;
    } on AppError catch (e) {
      state = AuthState(needsSetup: state.needsSetup);
      return e;
    }
  }

  /// Fail-open read of /user/onboarding-status.
  Future<bool> _readOnboarding() async {
    try {
      return (await ref.read(userRepositoryProvider).onboardingStatus()).completed;
    } on AppError {
      return true;
    }
  }

  /// POST /user/complete-onboarding — releases the /onboarding gate.
  Future<void> completeOnboarding() async {
    await ref.read(userRepositoryProvider).completeOnboarding();
    state = AuthState(user: state.user, onboardingDone: true);
  }

  /// Logout clears the stored token silently — the session-expired toast
  /// fires only on server-forced expiry (X-Auth-Error → expire()).
  Future<void> logout() async {
    _refreshTimer?.cancel();
    await ref.read(authRepositoryProvider).logout();
    state = AuthState(needsSetup: state.needsSetup);
  }

  /// Mid-life refresh, parity with the web client: the server also slides
  /// the token via X-Refreshed-Token headers, so failures are transient.
  Future<void> refreshSession() async {
    if (Env.embedded || state.user == null) return;
    try {
      await ref.read(authRepositoryProvider).refresh();
    } on AppError {
      // Transient failure must not sign the user out.
    }
  }

  void _scheduleRefresh(String token) {
    _refreshTimer?.cancel();
    final delay = AuthTokenStore.refreshDelay(token);
    if (delay != null) _refreshTimer = Timer(delay, () => unawaited(refreshSession()));
  }

  /// Refresh on app resume when the token is already past the mid-life point
  /// (web parity: focus + visibilitychange listeners).
  void _watchLifecycle() {
    _lifecycle ??= AppLifecycleListener(onResume: () => unawaited(_refreshIfDue()));
  }

  Future<void> _refreshIfDue() async {
    final token = await ref.read(authTokenStoreProvider).token;
    if (token == null) return;
    final delay = AuthTokenStore.refreshDelay(token);
    if (delay != null && delay <= Duration.zero) await refreshSession();
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);
