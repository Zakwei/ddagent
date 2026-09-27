import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'provider_accounts_repository.freezed.dart';
part 'provider_accounts_repository.g.dart';

@freezed
abstract class ProviderAccount with _$ProviderAccount {
  const factory ProviderAccount({
    required String id,
    String? provider,
    String? label,
    @Default({}) Map<String, dynamic> usage,
  }) = _ProviderAccount;

  factory ProviderAccount.fromJson(Map<String, dynamic> json) => _$ProviderAccountFromJson(json);
}

/// /api/provider-accounts — CRUD + usage. `accountId` from here is passed to
/// session create (see SessionsRepository.createSession).
class ProviderAccountsRepository {
  const ProviderAccountsRepository(this._dio);

  final Dio _dio;

  Future<List<ProviderAccount>> list() =>
      apiCall(() => _dio.get<dynamic>('/api/provider-accounts'), (d) {
        final list = d is List ? d : (d as Map<String, dynamic>)['accounts'] as List? ?? const [];
        return [for (final a in list) ProviderAccount.fromJson(a as Map<String, dynamic>)];
      });

  Future<ProviderAccount> create(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/provider-accounts', data: body),
    (d) => ProviderAccount.fromJson(
      (d as Map<String, dynamic>)['account'] as Map<String, dynamic>? ?? d,
    ),
  );

  Future<ProviderAccount> update(String id, Map<String, dynamic> body) => apiCall(
    () => _dio.patch<dynamic>('/api/provider-accounts/$id', data: body),
    (d) => ProviderAccount.fromJson(
      (d as Map<String, dynamic>)['account'] as Map<String, dynamic>? ?? d,
    ),
  );

  Future<void> delete(String id) =>
      apiCall(() => _dio.delete<dynamic>('/api/provider-accounts/$id'), (_) {});

  Future<Map<String, dynamic>> usage(String id) => apiCall(
    () => _dio.get<dynamic>('/api/provider-accounts/$id/usage'),
    (d) => d as Map<String, dynamic>,
  );
}

final providerAccountsRepositoryProvider = Provider<ProviderAccountsRepository>(
  (ref) => ProviderAccountsRepository(ref.watch(dioProvider)),
);
