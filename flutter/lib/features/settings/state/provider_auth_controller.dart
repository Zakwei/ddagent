import 'dart:async';

import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ambient/default CLI login. `email` may also be a credential-store username;
/// it never identifies one of the separately configured provider accounts.
class ProviderAuthStatus {
  ProviderAuthStatus({
    this.installed = true,
    this.authenticated = false,
    String? email,
    this.method,
    this.error,
  }) : email = authenticated ? _identity(email) : null;

  /// Whether the provider CLI binary is present on the host. Unknown status
  /// (older servers that omit the field) defaults to installed so the install
  /// card is never shown spuriously.
  final bool installed;
  final bool authenticated;
  final String? email;
  final String? method;
  final String? error;

  bool get hasRealIdentity => email != null;

  // Older servers used credential-source descriptions in the identity field.
  static const _legacyLabels = {
    'authenticated',
    'auth token',
    'api key auth',
    'configured via settings.json',
    'oauth token (long-lived)',
    'logged in',
    'command code account',
    'provider credentials',
    'google account',
    'windsurf api key',
    'environment api key',
    'devin config',
  };

  static String? _identity(String? value) {
    final identity = value?.trim();
    if (identity == null || identity.isEmpty) return null;
    final lower = identity.toLowerCase();
    if (_legacyLabels.contains(lower) ||
        lower.endsWith(' credentials') ||
        RegExp(r'^[A-Z][A-Z0-9_]*_API_KEY$').hasMatch(identity.toUpperCase())) {
      return null;
    }
    return identity;
  }

  factory ProviderAuthStatus.fromJson(Map<String, dynamic> json) => ProviderAuthStatus(
    installed: json['installed'] as bool? ?? true,
    authenticated: json['authenticated'] == true,
    email: json['email'] is String ? json['email'] as String : null,
    method: json['method'] is String ? json['method'] as String : null,
    error: json['error'] is String ? json['error'] as String : null,
  );
}

/// Explicit loading/error states discard the previous account. A FutureProvider
/// retains its last data during refresh, which is unsuitable for login identity.
class ProviderAuthController extends Notifier<AsyncValue<ProviderAuthStatus>> {
  ProviderAuthController(this.provider);

  final String provider;

  @override
  AsyncValue<ProviderAuthStatus> build() {
    final repository = ref.watch(sessionsRepositoryProvider);
    var active = true;
    ref.onDispose(() => active = false);

    Future<void> load() async {
      try {
        final json = await repository.authStatus(provider);
        if (active) state = AsyncData(ProviderAuthStatus.fromJson(json));
      } on Object catch (error, stack) {
        if (active) state = AsyncError(error, stack);
      }
    }

    unawaited(load());
    return const AsyncLoading();
  }
}

/// One request per provider shared by pills and the default account card.
/// Invalidate after login/logout or a manual refresh; late responses from a
/// disposed request cannot restore an old identity.
final providerAuthStatusProvider = NotifierProvider.autoDispose
    .family<ProviderAuthController, AsyncValue<ProviderAuthStatus>, String>(
      ProviderAuthController.new,
    );
