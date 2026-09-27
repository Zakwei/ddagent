import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/quota — snapshots, refresh, config, per-account history, usage
/// aggregation, agents fleet.
class QuotaRepository {
  const QuotaRepository(this._dio);

  final Dio _dio;

  Map<String, dynamic> _unwrap(dynamic d) {
    final map = d as Map<String, dynamic>;
    return (map['data'] as Map<String, dynamic>?) ?? map;
  }

  Future<Map<String, dynamic>> snapshot() =>
      apiCall(() => _dio.get<dynamic>('/api/quota'), _unwrap);

  Future<Map<String, dynamic>> refresh() =>
      apiCall(() => _dio.post<dynamic>('/api/quota/refresh'), _unwrap);

  Future<Map<String, dynamic>> config() =>
      apiCall(() => _dio.get<dynamic>('/api/quota/config'), _unwrap);

  Future<void> saveConfig(Map<String, dynamic> body) =>
      apiCall(() => _dio.put<dynamic>('/api/quota/config', data: body), (_) {});

  Future<List<Map<String, dynamic>>> history(String accountId, {int? limit}) => apiCall(
    () => _dio.get<dynamic>(
      '/api/quota/accounts/$accountId/history',
      queryParameters: {'limit': ?limit},
    ),
    (d) {
      final inner = _unwrap(d);
      final list = inner['history'] as List? ?? inner['snapshots'] as List? ?? const [];
      return [for (final h in list) h as Map<String, dynamic>];
    },
  );

  Future<Map<String, dynamic>> usage({required String period, required String groupBy}) => apiCall(
    () => _dio.get<dynamic>(
      '/api/quota/usage',
      queryParameters: {'period': period, 'groupBy': groupBy},
    ),
    _unwrap,
  );

  Future<Map<String, dynamic>> agents() =>
      apiCall(() => _dio.get<dynamic>('/api/quota/agents'), _unwrap);
}

final quotaRepositoryProvider = Provider<QuotaRepository>(
  (ref) => QuotaRepository(ref.watch(dioProvider)),
);
