// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GitConfig _$GitConfigFromJson(Map<String, dynamic> json) => _GitConfig(
  gitName: json['gitName'] as String?,
  gitEmail: json['gitEmail'] as String?,
);

Map<String, dynamic> _$GitConfigToJson(_GitConfig instance) =>
    <String, dynamic>{
      'gitName': instance.gitName,
      'gitEmail': instance.gitEmail,
    };

_OnboardingStatus _$OnboardingStatusFromJson(Map<String, dynamic> json) =>
    _OnboardingStatus(completed: json['completed'] as bool? ?? false);

Map<String, dynamic> _$OnboardingStatusToJson(_OnboardingStatus instance) =>
    <String, dynamic>{'completed': instance.completed};
