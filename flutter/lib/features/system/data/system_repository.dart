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

/// One filesystem on the server and which of its directories live on it
/// (`app` code, `data` database, `workspace` root) — `GET /api/system/disk`.
class DiskVolume {
  const DiskVolume({
    required this.locations,
    required this.totalBytes,
    required this.freeBytes,
    required this.low,
  });

  factory DiskVolume.fromJson(Map<String, dynamic> json) => DiskVolume(
    locations: [
      for (final l in json['locations'] as List)
        (kind: (l as Map)['kind'] as String, path: l['path'] as String),
    ],
    totalBytes: (json['totalBytes'] as num).toInt(),
    freeBytes: (json['freeBytes'] as num).toInt(),
    low: json['low'] == true,
  );

  final List<({String kind, String path})> locations;
  final int totalBytes;
  final int freeBytes;

  /// Server-side threshold (under 5 GB or 10% free) — drives the alarm banner.
  final bool low;
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

  /// The server answers `/update` only after `git pull && npm install && npm
  /// run build` (or a tarball download) has finished — minutes, not seconds.
  /// The app-wide 10 s connect / 30 s receive timeouts cut that short: on web
  /// Dio cannot see the TCP connect, so an empty-body POST that gets no
  /// headers within `connectTimeout` is reported as a *connection* timeout
  /// even though the server is busy updating. These requests get their own
  /// budget instead.
  static const updateTimeout = Duration(minutes: 20);

  static Options get _longRunning => Options(
    connectTimeout: updateTimeout,
    sendTimeout: updateTimeout,
    receiveTimeout: updateTimeout,
  );

  /// Triggers the server self-update. The reply says what happened:
  /// `restarting` (the server exits and its launcher brings the new version
  /// up), `staged` (a release tarball was downloaded for the next start),
  /// `upToDate`, and `webError` when the hosted web client failed to update.
  Future<Map<String, dynamic>> update() => apiCall(
    () => _dio.post<dynamic>('/api/system/update', options: _longRunning),
    (d) => d as Map<String, dynamic>? ?? const {},
  );

  /// Replaces the web client this server hosts with the newest release.
  Future<Map<String, dynamic>> updateWeb() => apiCall(
    () => _dio.post<dynamic>('/api/system/update-web', options: _longRunning),
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

  /// Free/total space of the disks holding the server code, data and workspaces.
  Future<List<DiskVolume>> diskUsage() => apiCall(
    () => _dio.get<dynamic>('/api/system/disk'),
    (d) => [
      for (final v in (d as Map<String, dynamic>)['volumes'] as List)
        DiskVolume.fromJson(v as Map<String, dynamic>),
    ],
  );

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
