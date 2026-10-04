import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/knowledge/data/knowledge_models.dart';
import 'package:ddagent_app/features/knowledge/data/knowledge_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Knowledge-base state: dashboard counters plus every entity list, one
/// project filter shared by the memories/rules tabs (`null` = all projects).
class KnowledgeState {
  const KnowledgeState({
    this.loading = false,
    this.busy = false,
    this.error,
    this.stats = const KbStats(memories: 0, rules: 0, skills: 0, personal: 0, connections: 0),
    this.memories = const [],
    this.rules = const [],
    this.skills = const [],
    this.personal = const [],
    this.tags = const [],
    this.projectFilter,
    this.tagFilter,
    this.contextTokens = 0,
    this.contextBudget = 4000,
  });

  final bool loading;
  final bool busy;
  final String? error;
  final KbStats stats;
  final List<KbMemory> memories;
  final List<KbRule> rules;
  final List<KbSkill> skills;
  final List<KbPersonal> personal;
  final List<KbTag> tags;

  /// `null` = every project (global entries included); otherwise a project id.
  final String? projectFilter;

  /// `null` = every memory; otherwise only memories carrying this tag.
  final String? tagFilter;

  /// Estimated tokens the `<knowledge>` block costs for [projectFilter], and its
  /// budget — shown in the dashboard so critical entries can be curated.
  final int contextTokens;
  final int contextBudget;

  KnowledgeState copyWith({
    bool? loading,
    bool? busy,
    String? Function()? error,
    KbStats? stats,
    List<KbMemory>? memories,
    List<KbRule>? rules,
    List<KbSkill>? skills,
    List<KbPersonal>? personal,
    List<KbTag>? tags,
    String? Function()? projectFilter,
    String? Function()? tagFilter,
    int? contextTokens,
    int? contextBudget,
  }) => KnowledgeState(
    loading: loading ?? this.loading,
    busy: busy ?? this.busy,
    error: error != null ? error() : this.error,
    stats: stats ?? this.stats,
    memories: memories ?? this.memories,
    rules: rules ?? this.rules,
    skills: skills ?? this.skills,
    personal: personal ?? this.personal,
    tags: tags ?? this.tags,
    projectFilter: projectFilter != null ? projectFilter() : this.projectFilter,
    tagFilter: tagFilter != null ? tagFilter() : this.tagFilter,
    contextTokens: contextTokens ?? this.contextTokens,
    contextBudget: contextBudget ?? this.contextBudget,
  );
}

/// Loads and mutates the knowledge base. Mutations return `null` on success or
/// the error message to surface in the form dialog.
class KnowledgeController extends Notifier<KnowledgeState> {
  KnowledgeRepository get _repo => ref.read(knowledgeRepositoryProvider);

  @override
  KnowledgeState build() {
    unawaited(Future.microtask(refresh));
    return const KnowledgeState(loading: true);
  }

  Future<void> setProjectFilter(String? projectId) async {
    state = state.copyWith(projectFilter: () => projectId);
    await refresh();
  }

  Future<void> setTagFilter(String? tag) async {
    state = state.copyWith(tagFilter: () => tag);
    await refresh();
  }

  Future<void> refresh() async {
    state = state.copyWith(
      loading: state.memories.isEmpty && state.rules.isEmpty,
      error: () => null,
    );
    try {
      final projectId = state.projectFilter;
      final results = await Future.wait([
        _repo.stats(),
        _repo.memories(
          projectId: projectId,
          includeGlobal: projectId != null,
          tag: state.tagFilter,
        ),
        _repo.rules(projectId: projectId, includeGlobal: projectId != null),
        _repo.skills(),
        _repo.personal(),
        _repo.tags(),
        _repo.contextPreview(projectId),
      ]);
      if (!ref.mounted) return;
      final preview = results[6] as Map<String, dynamic>;
      state = state.copyWith(
        loading: false,
        stats: results[0] as KbStats,
        memories: results[1] as List<KbMemory>,
        rules: results[2] as List<KbRule>,
        skills: results[3] as List<KbSkill>,
        personal: results[4] as List<KbPersonal>,
        tags: results[5] as List<KbTag>,
        contextTokens: (preview['estimatedTokens'] as num?)?.toInt() ?? 0,
        contextBudget: (preview['tokenBudget'] as num?)?.toInt() ?? 4000,
        error: () => null,
      );
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(loading: false, error: () => e.message);
    }
  }

  Future<String?> _run(Future<void> Function() call) async {
    state = state.copyWith(busy: true, error: () => null);
    try {
      await call();
      await refresh();
      if (ref.mounted) state = state.copyWith(busy: false);
      return null;
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(busy: false, error: () => e.message);
      return e.message;
    }
  }

  Future<String?> saveMemory({String? id, required Map<String, dynamic> body}) => _run(() async {
    if (id == null) {
      await _repo.createMemory(body);
    } else {
      await _repo.updateMemory(id, body);
    }
  });

  Future<String?> deleteMemory(String id) => _run(() => _repo.deleteMemory(id));

  Future<String?> saveRule({String? id, required Map<String, dynamic> body}) => _run(() async {
    if (id == null) {
      await _repo.createRule(body);
    } else {
      await _repo.updateRule(id, body);
    }
  });

  Future<String?> deleteRule(String id) => _run(() => _repo.deleteRule(id));

  Future<String?> saveSkill({String? id, required Map<String, dynamic> body}) => _run(() async {
    if (id == null) {
      await _repo.createSkill(body);
    } else {
      await _repo.updateSkill(id, body);
    }
  });

  Future<String?> deleteSkill(String id) => _run(() => _repo.deleteSkill(id));

  Future<String?> savePersonal({String? id, required Map<String, dynamic> body}) => _run(() async {
    if (id == null) {
      await _repo.createPersonal(body);
    } else {
      await _repo.updatePersonal(id, body);
    }
  });

  Future<String?> deletePersonal(String id) => _run(() => _repo.deletePersonal(id));

  Future<String?> deleteTag(int id) => _run(() => _repo.deleteTag(id));

  Future<List<KbSearchResult>> search(String query, {KnowledgeEntityType? type}) =>
      _repo.search(query, entityType: type?.wire);

  Future<String?> linkEntities({
    required String sourceId,
    required String sourceType,
    required String targetId,
    required String targetType,
    String relationship = 'related',
  }) => _run(
    () => _repo.createConnection({
      'sourceId': sourceId,
      'sourceType': sourceType,
      'targetId': targetId,
      'targetType': targetType,
      'relationship': relationship,
    }),
  );

  Future<String?> deleteConnection(String id) => _run(() => _repo.deleteConnection(id));

  /// Scans a project and returns a human-readable summary (or the error).
  Future<String?> scanProject(String projectId) async {
    try {
      await _repo.scan(projectId);
      await refresh();
      return null;
    } on AppError catch (e) {
      return e.message;
    }
  }
}

final knowledgeControllerProvider = NotifierProvider<KnowledgeController, KnowledgeState>(
  KnowledgeController.new,
);
