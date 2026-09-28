import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/network/auth_token_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_repository.freezed.dart';
part 'auth_repository.g.dart';

@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({required int id, required String username, String? role}) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);
}

@freezed
abstract class AuthStatus with _$AuthStatus {
  const factory AuthStatus({required bool needsSetup, @Default(false) bool authenticated}) =
      _AuthStatus;

  factory AuthStatus.fromJson(Map<String, dynamic> json) => _$AuthStatusFromJson(json);
}

/// /api/auth — public endpoints + session lifecycle (token stored via store).
class AuthRepository {
  const AuthRepository(this._dio, this._tokens);

  final Dio _dio;
  final AuthTokenStore _tokens;

  Future<AuthStatus> status() => apiCall(() => _dio.get<dynamic>('/api/auth/status'), (d) {
    final map = d as Map<String, dynamic>;
    // Server shape: {needsSetup, hasUsers, installMode...} — tolerate extras.
    return AuthStatus(
      needsSetup: map['needsSetup'] == true || map['hasUsers'] == false,
      authenticated: map['authenticated'] == true,
    );
  });

  /// Stores the returned JWT; returns the logged-in user.
  Future<AuthUser> login(String username, String password) => apiCall(
    () => _dio.post<dynamic>('/api/auth/login', data: {'username': username, 'password': password}),
    (d) async {
      final map = d as Map<String, dynamic>;
      final token = map['token'] as String?;
      await _tokens.store(token);
      // Login/register responses omit role — it lives in the JWT claims.
      return AuthUser.fromJson({
        ...map['user'] as Map<String, dynamic>,
        'role': ?(token == null ? null : AuthTokenStore.roleOf(token)),
      });
    },
  ).then((f) => f); // flatten Future<AuthUser> inside decode

  Future<AuthUser> register(String username, String password, {String? inviteToken}) => apiCall(
    () => _dio.post<dynamic>(
      '/api/auth/register',
      data: {'username': username, 'password': password, 'inviteToken': ?inviteToken},
    ),
    (d) async {
      final map = d as Map<String, dynamic>;
      final token = map['token'] as String?;
      await _tokens.store(token);
      return AuthUser.fromJson({
        ...map['user'] as Map<String, dynamic>,
        'role': ?(token == null ? null : AuthTokenStore.roleOf(token)),
      });
    },
  ).then((f) => f);

  Future<AuthUser> currentUser() => apiCall(
    () => _dio.get<dynamic>('/api/auth/user'),
    (d) => AuthUser.fromJson((d as Map<String, dynamic>)['user'] as Map<String, dynamic>),
  );

  Future<void> refresh() => apiCall(() => _dio.post<dynamic>('/api/auth/refresh'), (d) async {
    await _tokens.store((d as Map<String, dynamic>)['token'] as String?);
  }).then((_) {});

  Future<void> logout() async {
    try {
      await _dio.post<dynamic>('/api/auth/logout');
    } on DioException {
      // Server unreachable — still drop the local session.
    }
    await _tokens.clear();
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(dioProvider), ref.watch(authTokenStoreProvider)),
);
