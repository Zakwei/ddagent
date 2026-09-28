import 'package:ddagent_app/core/config/env.dart';
import 'package:ddagent_app/core/network/auth_token_store.dart';
import 'package:dio/dio.dart';

/// Dio configured for the ddagent API:
/// - baseUrl from the server profile (`--dart-define=DEFAULT_SERVER_URL`)
/// - `Authorization: Bearer <jwt>` + optional `x-api-key` gate header
/// - captures `X-Refreshed-Token` response header into the token store
/// - `X-Auth-Error` response header → session expiry → relogin flow
/// - one transparent retry for idempotent requests on transport errors
Dio buildDio(AuthTokenStore tokens, {String? baseUrl}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl ?? Env.defaultServerUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );
  dio.interceptors.add(AuthInterceptor(dio, tokens));
  return dio;
}

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._dio, this._tokens);

  final Dio _dio;
  final AuthTokenStore _tokens;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _tokens.token;
    if (token != null && !options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    if (Env.apiKey.isNotEmpty && !options.headers.containsKey('x-api-key')) {
      options.headers['x-api-key'] = Env.apiKey;
    }
    handler.next(options);
  }

  @override
  Future<void> onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) async {
    final refreshed = response.headers.value('x-refreshed-token');
    if (refreshed != null) await _tokens.store(refreshed);
    if (response.headers.value('x-auth-error') != null) await _tokens.expire();
    handler.next(response);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final retried = err.requestOptions.extra['_retried'] == true;
    final transport = switch (err.type) {
      DioExceptionType.connectionError ||
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => true,
      _ => false,
    };
    final idempotent = const {
      'GET',
      'HEAD',
      'OPTIONS',
      'PUT',
      'DELETE',
    }.contains(err.requestOptions.method);
    if (transport && idempotent && !retried) {
      err.requestOptions.extra['_retried'] = true;
      try {
        handler.resolve(await _dio.fetch<dynamic>(err.requestOptions));
        return;
      } on DioException catch (retryError) {
        handler.next(retryError);
        return;
      }
    }
    if (err.response?.headers.value('x-auth-error') != null) {
      await _tokens.expire();
    }
    handler.next(err);
  }
}
