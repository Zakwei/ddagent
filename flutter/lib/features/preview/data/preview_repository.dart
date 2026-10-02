import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `GET /api/preview/ports` row — a socket listening on localhost attributed
/// to a project via the process cwd.
class ListeningPort {
  const ListeningPort({
    required this.port,
    this.address = '',
    this.pid,
    this.processName,
    this.cwd,
  });

  final int port;
  final String address;
  final int? pid;
  final String? processName;
  final String? cwd;

  static ListeningPort fromJson(Map<String, dynamic> json) => ListeningPort(
    port: (json['port'] as num?)?.toInt() ?? 0,
    address: json['address']?.toString() ?? '',
    pid: (json['pid'] as num?)?.toInt(),
    processName: json['processName']?.toString(),
    cwd: json['cwd']?.toString(),
  );
}

/// /api/preview — port discovery (the proxy itself is a plain HTTP mount, no
/// API wrapper needed).
class PreviewRepository {
  const PreviewRepository(this._dio);

  final Dio _dio;

  Future<List<ListeningPort>> ports({String? projectPath}) => apiCall(
    () => _dio.get<dynamic>('/api/preview/ports', queryParameters: {'projectPath': ?projectPath}),
    (d) {
      final list = d is List ? d : (d as Map<String, dynamic>)['ports'] as List? ?? const [];
      return [
        for (final p in list)
          if (p is Map) ListeningPort.fromJson(Map<String, dynamic>.from(p)),
      ];
    },
  );
}

final previewRepositoryProvider = Provider<PreviewRepository>(
  (ref) => PreviewRepository(ref.watch(dioProvider)),
);
