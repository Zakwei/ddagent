import 'dart:convert';
import 'dart:typed_data';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/network/auth_token_store.dart';
import 'package:ddagent_app/features/auth/state/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

String _jwt(int iat, int exp) {
  String enc(Object o) => base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');
  return '${enc({'alg': 'none'})}.${enc({'iat': iat, 'exp': exp})}.sig';
}

class _MemKv implements SecureKv {
  final _map = <String, String>{};
  @override
  Future<String?> read(String key) async => _map[key];
  @override
  Future<void> write(String key, String value) async => _map[key] = value;
  @override
  Future<void> delete(String key) async => _map.remove(key);
}

class _Adapter implements HttpClientAdapter {
  final List<ResponseBody Function(RequestOptions)> queue = [];

  void respond({int status = 200, Object data = const {}}) {
    queue.add(
      (_) => ResponseBody.fromString(
        jsonEncode(data),
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      ),
    );
  }

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? _, Future<void>? _) async =>
      queue.removeAt(0)(o);

  @override
  void close({bool force = false}) {}
}

ProviderContainer _container(AuthTokenStore tokens, _Adapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'http://test'));
  dio.httpClientAdapter = adapter;
  return ProviderContainer(
    overrides: [
      authTokenStoreProvider.overrideWithValue(tokens),
      dioProvider.overrideWithValue(dio),
    ],
  );
}

Map<String, dynamic> _session() => {
  'token': _jwt(1, 9999999999),
  'user': {'id': 1, 'username': 'alice'},
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('checkStatus: needsSetup short-circuits to setup state', () async {
    final adapter = _Adapter()..respond(data: {'needsSetup': true});
    final c = _container(AuthTokenStore(storage: _MemKv()), adapter);
    addTearDown(c.dispose);
    c.read(authControllerProvider);
    await pumpEventQueue();
    final s = c.read(authControllerProvider);
    expect(s.needsSetup, isTrue);
    expect(s.isLoading, isFalse);
  });

  test('checkStatus: stored token rehydrates the user', () async {
    final tokens = AuthTokenStore(storage: _MemKv());
    await tokens.store(_jwt(1, 9999999999));
    final adapter = _Adapter()
      ..respond(data: {'needsSetup': false})
      ..respond(data: _session());
    final c = _container(tokens, adapter);
    addTearDown(c.dispose);
    c.read(authControllerProvider);
    await pumpEventQueue();
    expect(c.read(authControllerProvider).user?.username, 'alice');
  });

  test('checkStatus: 401 on /auth/user clears the session', () async {
    final tokens = AuthTokenStore(storage: _MemKv());
    await tokens.store(_jwt(1, 9999999999));
    final adapter = _Adapter()
      ..respond(data: {'needsSetup': false})
      ..respond(status: 401, data: {'error': 'expired'});
    final c = _container(tokens, adapter);
    addTearDown(c.dispose);
    c.read(authControllerProvider);
    await pumpEventQueue();
    final s = c.read(authControllerProvider);
    expect(s.user, isNull);
    expect(await tokens.token, isNull);
  });

  test('login stores the token and exposes the user', () async {
    final tokens = AuthTokenStore(storage: _MemKv());
    final adapter = _Adapter()
      ..respond(data: {'needsSetup': false}) // auto checkStatus
      ..respond(data: _session());
    final c = _container(tokens, adapter);
    addTearDown(c.dispose);
    // Prime the controller without a status check consuming the queue.
    final notifier = c.read(authControllerProvider.notifier);
    await pumpEventQueue();
    final err = await notifier.login('alice', 'pw');
    expect(err, isNull);
    expect(c.read(authControllerProvider).user?.username, 'alice');
    expect(await tokens.token, isNotNull);
  });

  test('login failure surfaces a typed error', () async {
    final adapter = _Adapter()
      ..respond(data: {'needsSetup': false})
      ..respond(status: 401, data: {'error': 'bad creds'});
    final c = _container(AuthTokenStore(storage: _MemKv()), adapter);
    addTearDown(c.dispose);
    final notifier = c.read(authControllerProvider.notifier);
    await pumpEventQueue();
    final err = await notifier.login('x', 'y');
    expect(err, isA<AuthError>());
    expect(c.read(authControllerProvider).user, isNull);
  });

  test('logout clears token and user', () async {
    final tokens = AuthTokenStore(storage: _MemKv());
    await tokens.store(_jwt(1, 9999999999));
    final adapter = _Adapter()
      ..respond(data: {'needsSetup': false})
      ..respond(data: _session()); // auto checkStatus → /auth/user
    final c = _container(tokens, adapter);
    addTearDown(c.dispose);
    final notifier = c.read(authControllerProvider.notifier);
    await pumpEventQueue();
    adapter.respond(); // POST /auth/logout
    await notifier.logout();
    expect(await tokens.token, isNull);
    expect(c.read(authControllerProvider).user, isNull);
  });

  test('session-expired signal drops the user', () async {
    final tokens = AuthTokenStore(storage: _MemKv());
    await tokens.store(_jwt(1, 9999999999));
    final adapter = _Adapter()
      ..respond(data: {'needsSetup': false})
      ..respond(data: _session());
    final c = _container(tokens, adapter);
    addTearDown(c.dispose);
    c.read(authControllerProvider);
    await pumpEventQueue();
    expect(c.read(authControllerProvider).user, isNotNull);
    await tokens.expire(); // X-Auth-Error path
    await pumpEventQueue();
    expect(c.read(authControllerProvider).user, isNull);
  });
}
