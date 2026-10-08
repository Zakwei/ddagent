import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_repository.freezed.dart';
part 'system_repository.g.dart';

@freezed
abstract class Release with _$Release {
  const factory Release({
    required String tagName,
    String? name,
    String? body,
    String? publishedAt,
    String? htmlUrl,
    @Default(<ReleaseAsset>[]) List<ReleaseAsset> assets,
  }) = _Release;

  factory Release.fromJson(Map<String, dynamic> json) => _$ReleaseFromJson(json);
}

/// One downloadable file attached to a release. The Android client looks for
/// the `.apk` asset to install a newer build of itself.
@freezed
abstract class ReleaseAsset with _$ReleaseAsset {
  const factory ReleaseAsset({required String name, required String downloadUrl, int? size}) =
      _ReleaseAsset;

  factory ReleaseAsset.fromJson(Map<String, dynamic> json) => _$ReleaseAssetFromJson(json);
}

/// /api/system — releases feed, self-update, restart.
class SystemRepository {
  const SystemRepository(this._dio);

  final Dio _dio;

  Future<Release?> latestRelease() =>
      apiCall(() => _dio.get<dynamic>('/api/system/latest-release'), (d) {
        // Server shape: {release: {...}} — no success/data envelope.
        final release = (d as Map<String, dynamic>?)?['release'];
        return release is Map<String, dynamic> ? Release.fromJson(release) : null;
      });

  Future<List<Release>> releases() => apiCall(() => _dio.get<dynamic>('/api/system/releases'), (d) {
    final list = d is List ? d : (d as Map<String, dynamic>)['releases'] as List? ?? const [];
    return [for (final r in list) Release.fromJson(r as Map<String, dynamic>)];
  });

  /// Triggers the server self-update. The reply says what happened:
  /// `restarting` (the server exits and its launcher brings the new version
  /// up), `staged` (a release tarball was downloaded for the next start),
  /// `upToDate`, and `webError` when the hosted web client failed to update.
  Future<Map<String, dynamic>> update() => apiCall(
    () => _dio.post<dynamic>('/api/system/update'),
    (d) => d as Map<String, dynamic>? ?? const {},
  );

  /// Replaces the web client this server hosts with the newest release.
  Future<Map<String, dynamic>> updateWeb() => apiCall(
    () => _dio.post<dynamic>('/api/system/update-web'),
    (d) => d as Map<String, dynamic>? ?? const {},
  );

  /// What the server can update from the UI — `{installMode, server:
  /// {canUpdate, method, supervised}, web: {hosted, version}}`. Null for
  /// servers older than 0.8.13, which don't report it.
  Future<Map<String, dynamic>?> updateInfo() async {
    try {
      return await apiCall(
        () => _dio.get<dynamic>('/api/system/update-info'),
        (d) => d as Map<String, dynamic>?,
      );
    } on Object {
      return null;
    }
  }

  /// Restarts the server process; the connection drops — callers should treat
  /// a transport error here as "restart in progress", not failure.
  /// Returns the `{restarting}` flag — false means the server runs unmanaged
  /// (no systemd/watchdog) and won't come back on its own.
  Future<bool> restart() => apiCall(
    () => _dio.post<dynamic>('/api/system/restart'),
    (d) => (d as Map<String, dynamic>?)?['restarting'] == true,
  );

  /// `GET /health` (unauthenticated root route) — `{status, version,
  /// installMode}`; also the "server is back" probe after [restart].
  Future<Map<String, dynamic>> health() =>
      apiCall(() => _dio.get<dynamic>('/health'), (d) => d as Map<String, dynamic>? ?? const {});
}

final systemRepositoryProvider = Provider<SystemRepository>(
  (ref) => SystemRepository(ref.watch(dioProvider)),
);
