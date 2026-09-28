import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// JWT store backed by flutter_secure_storage — port of src/utils/api.js.
///
/// - accepts only the issued-JWT shape (3 base64url segments); an injected
///   `X-Refreshed-Token` must never overwrite a valid token
/// - the server is the authority on expiry; we never discard a token on the
///   client clock (60 s skew only affects local "expired" *indicators*)
/// Minimal KV abstraction over secure storage (testable without a keychain).
abstract interface class SecureKv {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class _SecureStorageKv implements SecureKv {
  const _SecureStorageKv(this._inner);

  final FlutterSecureStorage _inner;

  @override
  Future<String?> read(String key) => _inner.read(key: key);
  @override
  Future<void> write(String key, String value) => _inner.write(key: key, value: value);
  @override
  Future<void> delete(String key) => _inner.delete(key: key);
}

class AuthTokenStore {
  AuthTokenStore({SecureKv? storage})
    : _storage = storage ?? _SecureStorageKv(const FlutterSecureStorage());

  static const _key = 'auth-token';
  static const expirySkew = Duration(seconds: 60);

  final SecureKv _storage;
  String? _cached;

  final _refreshed = StreamController<String>.broadcast();
  final _expired = StreamController<void>.broadcast();

  /// Fired when a new token is stored (login, refresh, X-Refreshed-Token).
  Stream<String> get onTokenRefreshed => _refreshed.stream;

  /// Fired when the session is dropped (X-Auth-Error / logout) → UI relogin.
  Stream<void> get onSessionExpired => _expired.stream;

  static bool isValidJwtShape(String? token) =>
      token != null && RegExp(r'^[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+$').hasMatch(token);

  static Map<String, dynamic>? readPayload(String token) {
    if (!isValidJwtShape(token)) return null;
    try {
      final payload = token.split('.')[1];
      final normalized = base64Url.normalize(payload);
      final decoded = jsonDecode(utf8.decode(base64Url.decode(normalized)));
      return decoded is Map ? Map<String, dynamic>.from(decoded) : null;
    } on FormatException {
      return null;
    }
  }

  /// Collab role claim (`viewer`/`member`/`owner`) — present on JWTs issued
  /// by auth.middleware; absent on legacy tokens.
  static String? roleOf(String token) => readPayload(token)?['role'] as String?;

  static ({int issuedAtMs, int expiresAtMs})? readClaims(String token) {
    final decoded = readPayload(token);
    if (decoded == null || decoded['iat'] is! num || decoded['exp'] is! num) {
      return null;
    }
    return (
      issuedAtMs: (decoded['iat'] as num).toInt() * 1000,
      expiresAtMs: (decoded['exp'] as num).toInt() * 1000,
    );
  }

  /// Local expiry check for UI indicators only — never used to gate requests.
  static bool isExpired(String token) {
    final claims = readClaims(token);
    if (claims == null) return false;
    return DateTime.now().millisecondsSinceEpoch >= claims.expiresAtMs + expirySkew.inMilliseconds;
  }

  /// Delay until the mid-life refresh point (server refreshes via header too).
  static Duration? refreshDelay(String token) {
    final claims = readClaims(token);
    if (claims == null) return null;
    final refreshAt = claims.issuedAtMs + ((claims.expiresAtMs - claims.issuedAtMs) ~/ 2);
    return Duration(
      milliseconds: (refreshAt - DateTime.now().millisecondsSinceEpoch).clamp(0, 1 << 31),
    );
  }

  Future<String?> get token async => _cached ??= await _storage.read(_key);

  /// Returns false (and stores nothing) for malformed tokens.
  Future<bool> store(String? token) async {
    if (!isValidJwtShape(token)) return false;
    _cached = token;
    await _storage.write(_key, token!);
    _refreshed.add(token);
    return true;
  }

  /// Drop the stored token silently (user-initiated logout).
  Future<void> clear() async {
    _cached = null;
    await _storage.delete(_key);
  }

  /// Server-forced expiry (X-Auth-Error) — same as [clear] but notifies
  /// [onSessionExpired] so the UI can toast + redirect to login.
  Future<void> expire() async {
    await clear();
    _expired.add(null);
  }

  /// `?token=` query used by SSE/WS transports that cannot send headers.
  Future<String?> tokenQueryParam() async {
    final t = await token;
    return t == null ? null : 'token=$t';
  }
}
