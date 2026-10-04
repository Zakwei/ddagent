import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/skills/data/skill_models.dart';
import 'package:ddagent_app/features/skills/data/skills_formatting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Skills list state — port of the `useProviderSkills` return value (dialog
/// open/queued state lives in the view).
class ProviderSkillsState {
  const ProviderSkillsState({
    this.skills = const [],
    this.targets = const [],
    this.selectedProjectPath,
    this.isLoading = false,
    this.isLoadingProjectScopes = false,
    this.loadError,
    this.deleteError,
  });

  /// Global skills plus the skills of the currently [selectedProjectPath].
  final List<ProviderSkill> skills;

  /// Every project available as a per-project scan target, sorted by path.
  final List<SkillProjectTarget> targets;

  /// Path of the project whose skills are merged into [skills]; null when no
  /// project is selected (only global skills are loaded).
  final String? selectedProjectPath;
  final bool isLoading;

  /// True while the selected project's scope is being scanned after the
  /// global list ("Scanning project skills...").
  final bool isLoadingProjectScopes;
  final String? loadError;
  final String? deleteError;

  ProviderSkillsState copyWith({
    List<ProviderSkill>? skills,
    List<SkillProjectTarget>? targets,
    String? selectedProjectPath,
    bool clearSelectedProjectPath = false,
    bool? isLoading,
    bool? isLoadingProjectScopes,
    String? Function()? loadError,
    String? Function()? deleteError,
  }) => ProviderSkillsState(
    skills: skills ?? this.skills,
    targets: targets ?? this.targets,
    selectedProjectPath: clearSelectedProjectPath
        ? null
        : (selectedProjectPath ?? this.selectedProjectPath),
    isLoading: isLoading ?? this.isLoading,
    isLoadingProjectScopes: isLoadingProjectScopes ?? this.isLoadingProjectScopes,
    loadError: loadError != null ? loadError() : this.loadError,
    deleteError: deleteError != null ? deleteError() : this.deleteError,
  );
}

/// `useProviderSkills` — global skills load first so the list paints quickly,
/// then the selected project's scoped skills (`?workspacePath=`) merge in.
/// Only one project is scanned at a time (chosen via [selectProject]); a
/// 5-min per-provider/project cache makes switches cheap.
class ProviderSkillsController extends Notifier<ProviderSkillsState> {
  ProviderSkillsController(this.provider);

  /// Provider id — `claude`, `cursor`, `codex`, `opencode`, `commandcode`, `antigravity` or `devin`.
  final String provider;

  static const _cacheTtl = Duration(minutes: 5);
  static final _cache = <String, ({List<ProviderSkill> skills, DateTime at})>{};

  List<SkillProjectTarget> _targets = const [];
  String? _selectedPath;
  String _cacheKey = '';
  int _loadId = 0;

  SessionsRepository get _repo => ref.read(sessionsRepositoryProvider);

  @override
  ProviderSkillsState build() {
    // Rebuild only when the project path/displayName set changes — plain
    // `watch(projectsProvider)` would refetch on every sidebar delta (same
    // select the MCP controller uses).
    ref.watch(
      projectsProvider.select(
        (s) => s.projects.map((p) => '${p.fullPath ?? p.path}${p.displayName}').join('|'),
      ),
    );
    _targets = _projectTargets(ref.read(projectsProvider).projects);
    // Keep the chosen project across sidebar deltas; fall back to the first
    // target when it disappeared or none was picked yet.
    _selectedPath = _resolveSelection(_targets, _selectedPath);
    _cacheKey = _cacheKeyFor(provider, _selectedPath);
    unawaited(Future.microtask(refresh));
    return ProviderSkillsState(
      targets: _targets,
      selectedProjectPath: _selectedPath,
      isLoading: true,
    );
  }

  static String? _resolveSelection(List<SkillProjectTarget> targets, String? current) {
    if (current != null) {
      for (final t in targets) {
        if (t.path == current) return current;
      }
    }
    return targets.isEmpty ? null : targets.first.path;
  }

  /// `createProjectTargets` — dedupe on `fullPath || path`, sorted by path.
  static List<SkillProjectTarget> _projectTargets(List<Project> projects) {
    final seen = <String>{};
    final targets = <SkillProjectTarget>[];
    for (final p in projects) {
      final path = (p.fullPath?.isNotEmpty ?? false) ? p.fullPath! : p.path;
      if (path.isEmpty || !seen.add(path)) continue;
      targets.add(
        SkillProjectTarget(
          projectId: p.projectId,
          displayName: p.displayName.isNotEmpty ? p.displayName : p.projectId,
          path: path,
        ),
      );
    }
    targets.sort((a, b) => a.path.compareTo(b.path));
    return targets;
  }

  /// `getCacheKey` — `provider:selectedPath` (empty suffix = global only), so
  /// switching between projects reuses each project's cached scan.
  static String _cacheKeyFor(String provider, String? selectedPath) =>
      '$provider:${selectedPath ?? ''}';

  /// The [SkillProjectTarget] matching [_selectedPath], if any.
  SkillProjectTarget? _selectedTarget() {
    final path = _selectedPath;
    if (path == null) return null;
    for (final t in _targets) {
      if (t.path == path) return t;
    }
    return null;
  }

  /// Pick the project whose skills are scanned alongside the global list.
  /// Passing null shows global skills only.
  Future<void> selectProject(String? path) async {
    if (_selectedPath == path) return;
    _selectedPath = path;
    _cacheKey = _cacheKeyFor(provider, _selectedPath);
    await refresh();
  }

  /// `clearProviderSkillCache` — drop every cached key for this provider.
  static void _clearCache(String provider) =>
      _cache.removeWhere((k, _) => k.startsWith('$provider:'));

  Future<void> refresh({bool force = false}) async {
    final loadId = ++_loadId;
    final cached = _cache[_cacheKey];
    final fresh = cached != null && DateTime.now().difference(cached.at) < _cacheTtl && !force;
    if (fresh) {
      state = state.copyWith(
        skills: cached.skills,
        targets: _targets,
        selectedProjectPath: _selectedPath,
        clearSelectedProjectPath: _selectedPath == null,
        isLoading: false,
        isLoadingProjectScopes: false,
      );
      return;
    }

    var next = cached != null && !force ? cached.skills : <ProviderSkill>[];
    state = state.copyWith(
      skills: next,
      targets: _targets,
      selectedProjectPath: _selectedPath,
      clearSelectedProjectPath: _selectedPath == null,
      isLoading: force || cached == null,
      isLoadingProjectScopes: false,
      loadError: () => null,
    );

    String? firstError;

    // Global skills first — the visible list paints before the selected
    // project's scope is scanned (web `refreshSkills` ordering).
    try {
      final global = await _fetch();
      if (_loadId != loadId || !ref.mounted) return;
      next = mergeProviderSkills(next, global);
      state = state.copyWith(skills: next);
    } on AppError catch (e) {
      firstError = e.message;
    }
    if (_loadId != loadId || !ref.mounted) return;
    state = state.copyWith(isLoading: false);

    // Only the selected project is scanned, so project switches stay cheap.
    final target = _selectedTarget();
    if (target == null) {
      final finalSkills = sortProviderSkills(next);
      _cache[_cacheKey] = (skills: finalSkills, at: DateTime.now());
      state = state.copyWith(skills: finalSkills, loadError: () => firstError);
      return;
    }

    state = state.copyWith(isLoadingProjectScopes: true);
    try {
      final scoped = await _fetch(target);
      if (_loadId != loadId || !ref.mounted) return;
      next = mergeProviderSkills(next, scoped);
    } on AppError catch (e) {
      firstError ??= e.message;
    }
    if (_loadId != loadId || !ref.mounted) return;

    final finalSkills = sortProviderSkills(next);
    _cache[_cacheKey] = (skills: finalSkills, at: DateTime.now());
    state = state.copyWith(
      skills: finalSkills,
      isLoadingProjectScopes: false,
      loadError: () => firstError,
    );
  }

  Future<List<ProviderSkill>> _fetch([SkillProjectTarget? project]) async {
    final rows = await _repo.skills(
      provider,
      workspacePath: switch (project) {
        final t? when t.path.isNotEmpty => t.path,
        _ => null,
      },
    );
    return [for (final s in rows) ProviderSkill.fromApi(provider, s, project: project)];
  }

  /// `addSkills` — POST `{entries}`, then a forced refresh (the install
  /// replaces the list). Returns null on success, otherwise the message the
  /// dialog renders as `submitError`.
  Future<String?> addSkills(List<Map<String, dynamic>> entries) async {
    try {
      await _repo.addSkill(provider, {'entries': entries});
      _clearCache(provider);
      await refresh(force: true);
      return null;
    } on AppError catch (e) {
      return e.message;
    }
  }

  /// `deleteSkill` — removes the whole managed directory; `deleteError`
  /// renders inline like the web hook's.
  Future<void> delete(String directoryName) async {
    state = state.copyWith(deleteError: () => null);
    try {
      await _repo.deleteSkill(provider, directoryName);
      _clearCache(provider);
      await refresh(force: true);
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(deleteError: () => e.message);
    }
  }

  /// `moveSkill` — relocates a managed skill between the global and a project
  /// scope, then forces a refresh. Returns null on success, otherwise the
  /// message the move dialog renders inline. The source workspace is taken
  /// from the skill's stamped project path so the backend can validate a
  /// project-scoped source directory.
  Future<String?> move({
    required ProviderSkill skill,
    required bool toProject,
    String? targetWorkspacePath,
  }) async {
    try {
      await _repo.moveSkill(
        provider,
        sourcePath: skill.sourcePath,
        toProject: toProject,
        targetWorkspacePath: toProject ? targetWorkspacePath : null,
        sourceWorkspacePath: skill.scope.isProjectScoped
            ? (skill.projectPath ?? _selectedPath)
            : null,
      );
      _clearCache(provider);
      await refresh(force: true);
      return null;
    } on AppError catch (e) {
      return e.message;
    }
  }
}

/// Keyed by provider id; autoDispose matches the settings tab remount.
final providerSkillsProvider = NotifierProvider.autoDispose
    .family<ProviderSkillsController, ProviderSkillsState, String>(ProviderSkillsController.new);
