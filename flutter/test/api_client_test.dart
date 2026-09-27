import 'dart:convert';
import 'dart:typed_data';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/auth_token_store.dart';
import 'package:ddagent_app/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

/// Scriptable adapter: returns queued responses, records requests.
class FakeAdapter implements HttpClientAdapter {
  final List<ResponseBody Function(RequestOptions)> queue = [];
  final List<RequestOptions> requests = [];

  void respond({
    int status = 200,
    Object data = const {},
    Map<String, List<String>> headers = const {},
  }) {
    queue.add(
      (_) => ResponseBody.fromString(
        jsonEncode(data),
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
          ...headers,
        },
      ),
    );
  }

  void failTransport() {
    queue.add(
      (_) =>
          throw DioException.connectionError(requestOptions: RequestOptions(), reason: 'offline'),
    );
  }

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? _, Future<void>? _) async {
    requests.add(options);
    return queue.removeAt(0)(options);
  }

  @override
  void close({bool force = false}) {}
}

// Valid JWT shape: header.payload.signature (payload carries iat/exp).
String _jwt(int iat, int exp) {
  String enc(Object o) => base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');
  return '${enc({'alg': 'none'})}.${enc({'iat': iat, 'exp': exp})}.sig';
}

void main() {
  late FakeAdapter adapter;
  late AuthTokenStore tokens;
  late Dio dio;

  setUp(() {
    adapter = FakeAdapter();
    tokens = AuthTokenStore(storage: _MemorySecureStorage());
    dio = buildDio(tokens, baseUrl: 'http://test');
    dio.httpClientAdapter = adapter;
  });

  test('attaches Bearer + x-api-key headers', () async {
    await tokens.store(_jwt(1, 9999999999));
    adapter.respond();
    await dio.get<dynamic>('/x', options: Options(headers: {'x-api-key': 'k'}));
    expect(adapter.requests.single.headers['Authorization'], startsWith('Bearer '));
    expect(adapter.requests.single.headers['x-api-key'], 'k');
  });

  test('captures X-Refreshed-Token into the store', () async {
    final newToken = _jwt(10, 9999999999);
    adapter.respond(
      headers: {
        'x-refreshed-token': [newToken],
      },
    );
    await dio.get<dynamic>('/x');
    expect(await tokens.token, newToken);
  });

  test('rejects malformed X-Refreshed-Token', () async {
    await tokens.store(_jwt(1, 9999999999));
    final before = await tokens.token;
    adapter.respond(
      headers: {
        'x-refreshed-token': ['not-a-jwt'],
      },
    );
    await dio.get<dynamic>('/x');
    expect(await tokens.token, before);
  });

  test('X-Auth-Error clears the session', () async {
    await tokens.store(_jwt(1, 9999999999));
    adapter.respond(
      status: 401,
      headers: {
        'x-auth-error': ['expired'],
      },
    );
    await expectLater(dio.get<dynamic>('/x'), throwsA(isA<DioException>()));
    expect(await tokens.token, isNull);
  });

  test('retries idempotent requests once on transport error', () async {
    adapter.failTransport();
    adapter.respond(data: {'ok': true});
    final res = await dio.get<dynamic>('/x');
    expect(res.data['ok'], true);
    expect(adapter.requests.length, 2);
  });

  test('error mapping: 401/403/500/network', () {
    expect(
      mapDioError(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(requestOptions: RequestOptions(), statusCode: 401),
        ),
      ),
      isA<AuthError>(),
    );
    expect(
      mapDioError(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(requestOptions: RequestOptions(), statusCode: 403),
        ),
      ),
      isA<ForbiddenError>(),
    );
    expect(
      mapDioError(
        DioException(
          requestOptions: RequestOptions(),
          response: Response(
            requestOptions: RequestOptions(),
            statusCode: 500,
            data: {'error': 'boom'},
          ),
        ),
      ),
      isA<ServerError>(),
    );
    expect(
      mapDioError(DioException.connectionError(requestOptions: RequestOptions(), reason: 'x')),
      isA<NetworkError>(),
    );
  });

  test('jwt claims: expiry skew + refresh delay', () {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    expect(AuthTokenStore.isExpired(_jwt(now - 7200, now - 120)), isTrue);
    // Inside the 60 s skew window an expired token still reads as valid.
    expect(AuthTokenStore.isExpired(_jwt(now - 100, now - 30)), isFalse);
    expect(AuthTokenStore.isExpired(_jwt(now - 100, now + 3600)), isFalse);
    expect(
      AuthTokenStore.refreshDelay(_jwt(now, now + 100))!.inMilliseconds,
      greaterThanOrEqualTo(0),
    );
    expect(AuthTokenStore.isValidJwtShape('a.b.c'), isTrue);
    expect(AuthTokenStore.isValidJwtShape('nope'), isFalse);
  });
}

/// In-memory stand-in so tests don't hit platform keychains.
class _MemorySecureStorage implements SecureKv {
  final _map = <String, String>{};

  @override
  Future<String?> read(String key) async => _map[key];

  @override
  Future<void> write(String key, String value) async => _map[key] = value;

  @override
  Future<void> delete(String key) async => _map.remove(key);
}
