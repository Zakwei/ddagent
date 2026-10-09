import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';

/// Unified error for the API layer. HTTP only — WS/SSE errors are wrapped
/// by their own transports into the same type.
sealed class AppError implements Exception {
  const AppError(this.message);

  final String message;

  /// HTTP status if this came from a response, else null.
  int? get statusCode => null;

  @override
  String toString() => '$runtimeType: $message';
}

/// 401 — token rejected/expired. UI should drop to the login flow.
class AuthError extends AppError {
  const AuthError(super.message);

  @override
  int? get statusCode => 401;
}

/// 403 — authenticated but insufficient role (owner/member/viewer).
class ForbiddenError extends AppError {
  const ForbiddenError(super.message);

  @override
  int? get statusCode => 403;
}

/// Any other non-2xx response (4xx/5xx), message from the server when present.
class ServerError extends AppError {
  const ServerError(super.message, this.code, [this.errorCode]);

  final int code;

  /// Server error envelope code (`{error:{code,message}}`), e.g.
  /// 'RUN_IN_PROGRESS' — lets callers distinguish same-status failures.
  final String? errorCode;

  @override
  int? get statusCode => code;
}

/// No connectivity / timeout / DNS — the server may simply be offline.
class NetworkError extends AppError {
  const NetworkError(super.message);
}

AppError mapDioError(DioException e) {
  final response = e.response;
  if (response != null) {
    final body = response.data;
    final err = body is Map ? body['error'] : null;
    final message = err is Map
        ? (err['message'] ?? '').toString()
        : (err ?? (body is Map ? body['message'] : null) ?? '').toString();
    final errorCode = err is Map ? err['code']?.toString() : null;
    final status = response.statusCode ?? 0;
    if (status == 401) {
      return AuthError(message.isEmpty ? t.common.messages.unauthorized : message);
    }
    if (status == 403) {
      return ForbiddenError(message.isEmpty ? t.common.errors.forbidden : message);
    }
    return ServerError(message.isEmpty ? 'HTTP $status' : message, status, errorCode);
  }
  return NetworkError(e.message ?? t.common.messages.networkError);
}

/// Convenience: unwraps a Dio call into `T` or throws an [AppError].
///
/// Decode failures (unexpected payload shape → TypeError/cast errors) are
/// mapped to [ServerError] too: callers only catch [AppError], so a raw throw
/// would skip their loading/busy reset and leave the UI spinning forever.
Future<T> apiCall<T>(Future<Response<dynamic>> Function() call, T Function(dynamic data) decode) =>
    apiCallAsync(call, (data) async => decode(data));

/// [apiCall] for decoders that await (e.g. persisting a returned token) —
/// their failures (secure-storage PlatformException, …) map to [AppError].
Future<T> apiCallAsync<T>(
  Future<Response<dynamic>> Function() call,
  Future<T> Function(dynamic data) decode,
) async {
  final dynamic data;
  try {
    final response = await call();
    var body = response.data;
    // Server envelope: {success: true, data: {...}} — unwrap so decoders see
    // the payload directly (bare lists and raw shapes pass through).
    if (body is Map && body['success'] == true && body.containsKey('data')) {
      body = body['data'];
    }
    data = body;
  } on DioException catch (e) {
    throw mapDioError(e);
  }
  try {
    return await decode(data);
  } on AppError {
    rethrow;
  } on Object catch (e) {
    throw ServerError('$e', 0);
  }
}
