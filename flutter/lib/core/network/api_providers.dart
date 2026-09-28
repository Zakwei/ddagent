import 'package:ddagent_app/core/config/env.dart';
import 'package:ddagent_app/core/network/auth_token_store.dart';
import 'package:ddagent_app/core/network/dio_client.dart';
import 'package:ddagent_app/features/server_connect/data/server_profiles.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authTokenStoreProvider = Provider<AuthTokenStore>((ref) => AuthTokenStore());

/// Session-expired signal — UI layer listens and routes to login.
final sessionExpiredProvider = StreamProvider<void>(
  (ref) => ref.watch(authTokenStoreProvider).onSessionExpired,
);

/// Dio bound to the currently configured server — the active saved profile
/// or the --dart-define default. Empty string means "not configured yet".
final serverBaseUrlProvider = Provider<String>(
  (ref) => ref.watch(serverProfilesProvider).activeUrl ?? Env.defaultServerUrl,
);

final dioProvider = Provider<Dio>(
  (ref) => buildDio(ref.watch(authTokenStoreProvider), baseUrl: ref.watch(serverBaseUrlProvider)),
);
