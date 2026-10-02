import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/settings/data/api_credentials_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for Settings → API & Tokens — port of `useCredentialsSettings.ts`
/// (api-keys + GitHub token credentials, loading flag, one-time new-key).
class ApiCredentialsState {
  const ApiCredentialsState({
    this.apiKeys = const [],
    this.githubCredentials = const [],
    this.loading = true,
    this.newlyCreatedKey,
  });

  final List<ApiKeyEntry> apiKeys;
  final List<GithubCredentialEntry> githubCredentials;
  final bool loading;

  /// Full key shown once in the save-it-now alert after creation.
  final CreatedApiKey? newlyCreatedKey;

  ApiCredentialsState copyWith({
    List<ApiKeyEntry>? apiKeys,
    List<GithubCredentialEntry>? githubCredentials,
    bool? loading,
    CreatedApiKey? Function()? newlyCreatedKey,
  }) => ApiCredentialsState(
    apiKeys: apiKeys ?? this.apiKeys,
    githubCredentials: githubCredentials ?? this.githubCredentials,
    loading: loading ?? this.loading,
    newlyCreatedKey: newlyCreatedKey != null ? newlyCreatedKey() : this.newlyCreatedKey,
  );
}

class ApiCredentialsController extends Notifier<ApiCredentialsState> {
  ApiCredentialsRepository get _repo => ref.read(apiCredentialsRepositoryProvider);

  @override
  ApiCredentialsState build() {
    unawaited(Future.microtask(refresh));
    return const ApiCredentialsState();
  }

  Future<void> refresh() async {
    try {
      final (keys, credentials) = await (_repo.apiKeys(), _repo.githubCredentials()).wait;
      if (!ref.mounted) return;
      state = state.copyWith(apiKeys: keys, githubCredentials: credentials, loading: false);
    } on AppError {
      if (ref.mounted) state = state.copyWith(loading: false);
    }
  }

  /// Returns null on success, otherwise the error message to surface.
  Future<String?> createApiKey(String keyName) async {
    final name = keyName.trim();
    if (name.isEmpty) return 'empty';
    try {
      final created = await _repo.createApiKey(name);
      if (!ref.mounted) return null;
      if (created != null) {
        state = state.copyWith(newlyCreatedKey: () => created);
      }
      await refresh();
      return null;
    } on AppError catch (e) {
      return e.message;
    }
  }

  Future<String?> deleteApiKey(String keyId) => _run(() => _repo.deleteApiKey(keyId));

  Future<String?> toggleApiKey(ApiKeyEntry key) =>
      _run(() => _repo.toggleApiKey(key.id, !key.isActive));

  Future<String?> createGithubCredential({
    required String name,
    required String token,
    String description = '',
  }) async {
    if (name.trim().isEmpty || token.trim().isEmpty) return 'empty';
    try {
      await _repo.createGithubCredential(
        name: name.trim(),
        token: token.trim(),
        description: description.trim(),
      );
      await refresh();
      return null;
    } on AppError catch (e) {
      return e.message;
    }
  }

  Future<String?> deleteGithubCredential(String credentialId) =>
      _run(() => _repo.deleteCredential(credentialId));

  Future<String?> toggleGithubCredential(GithubCredentialEntry credential) =>
      _run(() => _repo.toggleCredential(credential.id, !credential.isActive));

  void dismissNewlyCreatedKey() {
    state = state.copyWith(newlyCreatedKey: () => null);
  }

  Future<String?> _run(Future<void> Function() call) async {
    try {
      await call();
      await refresh();
      return null;
    } on AppError catch (e) {
      return e.message;
    }
  }
}

final apiCredentialsProvider = NotifierProvider<ApiCredentialsController, ApiCredentialsState>(
  ApiCredentialsController.new,
);
