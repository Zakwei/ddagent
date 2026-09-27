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
  const ServerError(super.message, this.code);

  final int code;

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
    final message = body is Map
        ? (body['error'] ?? body['message'] ?? '').toString()
        : '';
    final status = response.statusCode ?? 0;
    if (status == 401) {
      return AuthError(message.isEmpty ? 'Unauthorized' : message);
    }
    if (status == 403) {
      return ForbiddenError(message.isEmpty ? 'Forbidden' : message);
    }
    return ServerError(message.isEmpty ? 'HTTP $status' : message, status);
  }
  return NetworkError(e.message ?? 'Network error');
}

/// Convenience: unwraps a Dio call into `T` or throws an [AppError].
Future<T> apiCall<T>(
  Future<Response<dynamic>> Function() call,
  T Function(dynamic data) decode,
) async {
  try {
    final response = await call();
    return decode(response.data);
  } on DioException catch (e) {
    throw mapDioError(e);
  }
}
