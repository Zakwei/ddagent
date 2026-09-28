import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_repository.freezed.dart';
part 'user_repository.g.dart';

@freezed
abstract class GitConfig with _$GitConfig {
  const factory GitConfig({String? gitName, String? gitEmail}) = _GitConfig;

  factory GitConfig.fromJson(Map<String, dynamic> json) => _$GitConfigFromJson(json);
}

@freezed
abstract class OnboardingStatus with _$OnboardingStatus {
  const factory OnboardingStatus({@Default(false) bool completed}) = _OnboardingStatus;

  factory OnboardingStatus.fromJson(Map<String, dynamic> json) => _$OnboardingStatusFromJson(json);
}

/// /api/user — git identity + onboarding flag.
class UserRepository {
  const UserRepository(this._dio);

  final Dio _dio;

  Future<GitConfig> gitConfig() => apiCall(
    () => _dio.get<dynamic>('/api/user/git-config'),
    (d) => GitConfig.fromJson(d as Map<String, dynamic>),
  );

  Future<void> updateGitConfig({required String gitName, required String gitEmail}) => apiCall(
    () => _dio.post<dynamic>(
      '/api/user/git-config',
      data: {'gitName': gitName, 'gitEmail': gitEmail},
    ),
    (_) {},
  );

  /// Server shape: `{hasCompletedOnboarding: bool}`.
  Future<OnboardingStatus> onboardingStatus() => apiCall(
    () => _dio.get<dynamic>('/api/user/onboarding-status'),
    (d) =>
        OnboardingStatus(completed: (d as Map<String, dynamic>)['hasCompletedOnboarding'] == true),
  );

  Future<void> completeOnboarding() =>
      apiCall(() => _dio.post<dynamic>('/api/user/complete-onboarding'), (_) {});
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(ref.watch(dioProvider)),
);
