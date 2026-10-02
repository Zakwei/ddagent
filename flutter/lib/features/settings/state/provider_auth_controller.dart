import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Auth status of one CLI provider — port of `ProviderAuthStatus`
/// (src/components/provider-auth/types.ts) and `useProviderAuthStatus`.
class ProviderAuthStatus {
  const ProviderAuthStatus({this.authenticated = false, this.email, this.method, this.error});

  final bool authenticated;
  final String? email;

  /// `api_key` means env-var credentials — the web hides the Login button then.
  final String? method;
  final String? error;

  factory ProviderAuthStatus.fromJson(Map<String, dynamic> json) => ProviderAuthStatus(
    authenticated: json['authenticated'] == true,
    email: json['email']?.toString(),
    method: json['method']?.toString(),
    error: json['error']?.toString(),
  );
}

/// `GET /api/providers/{provider}/auth/status` — one future per provider, so
/// the agent pills and the account card share a single in-flight request.
/// AsyncValue loading/error states map to the web's `loading`/`error` fields;
/// `ref.invalidate(providerAuthStatusProvider(p))` re-checks after a login.
final providerAuthStatusProvider = FutureProvider.autoDispose.family<ProviderAuthStatus, String>((
  ref,
  provider,
) async {
  final json = await ref.read(sessionsRepositoryProvider).authStatus(provider);
  return ProviderAuthStatus.fromJson(json);
});
