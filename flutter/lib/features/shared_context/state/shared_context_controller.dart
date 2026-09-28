import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/shared_context/data/shared_context_models.dart';
import 'package:ddagent_app/features/shared_context/data/shared_context_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SharedContextState {
  const SharedContextState({
    this.projectId,
    this.document,
    this.content = '',
    this.savedContent = '',
    this.updatedAt,
    this.isDirty = false,
    this.loading = false,
    this.saving = false,
    this.error,
  });

  final String? projectId;
  final SharedContextDocument? document;
  final String content;
  final String savedContent;
  final String? updatedAt;
  final bool isDirty;
  final bool loading;
  final bool saving;
  final String? error;

  SharedContextState copyWith({
    String? Function()? projectId,
    SharedContextDocument? Function()? document,
    String? content,
    String? savedContent,
    String? Function()? updatedAt,
    bool? isDirty,
    bool? loading,
    bool? saving,
    String? Function()? error,
  }) =>
      SharedContextState(
        projectId: projectId != null ? projectId() : this.projectId,
        document: document != null ? document() : this.document,
        content: content ?? this.content,
        savedContent: savedContent ?? this.savedContent,
        updatedAt: updatedAt != null ? updatedAt() : this.updatedAt,
        isDirty: isDirty ?? this.isDirty,
        loading: loading ?? this.loading,
        saving: saving ?? this.saving,
        error: error != null ? error() : this.error,
      );
}

class SharedContextController extends Notifier<SharedContextState> {
  SharedContextController(this._projectId);

  final String? _projectId;

  SharedContextRepository get _repo => ref.read(sharedContextRepositoryProvider);

  @override
  SharedContextState build() {
    final pid = _projectId;
    if (pid != null && pid.isNotEmpty) {
      unawaited(Future.microtask(() => load(pid)));
      return SharedContextState(projectId: pid, loading: true);
    }
    return const SharedContextState();
  }

  void clearError() => state = state.copyWith(error: () => null);

  Future<void> load(String projectId) async {
    state = state.copyWith(loading: true, error: () => null);
    try {
      final doc = await _repo.get(projectId);
      if (!ref.mounted) return;
      state = state.copyWith(
        projectId: () => projectId,
        document: () => doc,
        content: doc.content,
        savedContent: doc.content,
        updatedAt: () => doc.updatedAt,
        isDirty: false,
        loading: false,
      );
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(loading: false, error: () => e.message);
      }
    } on Exception catch (e) {
      if (ref.mounted) {
        state = state.copyWith(loading: false, error: () => e.toString());
      }
    }
  }

  void updateContent(String text) {
    final dirty = text != state.savedContent;
    state = state.copyWith(
      content: text,
      isDirty: dirty,
    );
  }

  Future<bool> save() async {
    final pid = state.projectId ?? _projectId;
    if (pid == null || pid.isEmpty || state.saving) return false;

    state = state.copyWith(saving: true, error: () => null);
    try {
      final updated = await _repo.put(pid, state.content);
      if (!ref.mounted) return true;
      state = state.copyWith(
        document: () => updated,
        savedContent: updated.content,
        updatedAt: () => updated.updatedAt,
        isDirty: false,
        saving: false,
      );
      return true;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(saving: false, error: () => e.message);
      }
      return false;
    } on Exception catch (e) {
      if (ref.mounted) {
        state = state.copyWith(saving: false, error: () => e.toString());
      }
      return false;
    }
  }
}

final sharedContextProvider = NotifierProvider.family<
    SharedContextController, SharedContextState, String?>(
  SharedContextController.new,
);
