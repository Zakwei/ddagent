import 'dart:async';
import 'dart:convert';

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
    this.isLoading = false,
    this.isLoadingProjectScopes = false,
    this.loadError,
    this.deleteError,
  });

  final List<ProviderSkill> skills;
  final bool isLoading;

  /// True while per-project scope fetches stream in after the global list
  /// (web `isLoadingProjectScopes` → "Scanning project skills...").
  final bool isLoadingProjectScopes;
  final String? loadError;
  final String? deleteError;

  ProviderSkillsState copyWith({
    List<ProviderSkill>? skills,
    bool? isLoading,
    bool? isLoadingProjectScopes,
    String? Function()? loadError,
    String? Function()? deleteError,
  }) => ProviderSkillsState(
    skills: skills ?? this.skills,
    isLoading: isLoading ?? this.isLoading,
    isLoadingProjectScopes:
        isLoadingProjectScopes ?? this.isLoadingProjectScopes,
    loadError: loadError != null ? loadError() : this.loadError,
    deleteError: deleteError != null ? deleteError() : this.deleteError,
  );
}

/// `useProviderSkills` — global skills load first so the list paints quickly;
/// per-project scopes (`?workspacePath=`) merge in as each resolves. A 5-min
/// module cache (`SKILLS_CACHE_TTL_MS` parity) makes provider switches cheap.
class ProviderSkillsController extends Notifier<ProviderSkillsState> {
  ProviderSkillsController(this.provider);

  /// Provider id — `claude`, `cursor`, `codex`, `opencode`, `commandcode`, `antigravity` or `devin`.
  final String provider;

  static const _cacheTtl = Duration(minutes: 5);
  static final _cache = <String, ({List<ProviderSkill> skills, DateTime at})>{};

  List<SkillProjectTarget> _targets = const [];
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
        (s) => s.projects
            .map((p) => '${p.fullPath ?? p.path}${p.displayName}')
            .join('|'),
      ),
    );
    _targets = _projectTargets(ref.read(projectsProvider).projects);
    _cacheKey = _cacheKeyFor(provider, _targets);
    unawaited(Future.microtask(refresh));
    return const ProviderSkillsState(isLoading: true);
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

  /// `getCacheKey` — `provider:JSON.stringify(targets)`.
  static String _cacheKeyFor(
    String provider,
    List<SkillProjectTarget> targets,
  ) =>
      '$provider:${jsonEncode([
        for (final t in targets) {'projectId': t.projectId, 'displayName': t.displayName, 'path': t.path},
      ])}';

  /// `clearProviderSkillCache` — drop every cached key for this provider.
  static void _clearCache(String provider) =>
      _cache.removeWhere((k, _) => k.startsWith('$provider:'));

  Future<void> refresh({bool force = false}) async {
    final loadId = ++_loadId;
    final cached = _cache[_cacheKey];
    final fresh =
        cached != null &&
        DateTime.now().difference(cached.at) < _cacheTtl &&
        !force;
    if (fresh) {
      state = ProviderSkillsState(skills: cached.skills);
      return;
    }

    var next = cached != null && !force ? cached.skills : <ProviderSkill>[];
    state = ProviderSkillsState(
      skills: next,
      isLoading: force || cached == null,
    );

    String? firstError;

    // Global skills first — the visible list paints before project scopes are
    // scanned (web `refreshSkills` ordering).
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

    if (_targets.isEmpty) {
      final finalSkills = sortProviderSkills(next);
      _cache[_cacheKey] = (skills: finalSkills, at: DateTime.now());
      state = state.copyWith(skills: finalSkills, loadError: () => firstError);
      return;
    }

    state = state.copyWith(isLoadingProjectScopes: true);
    // Merge each project's skills as its fetch resolves instead of waiting
    // for the slowest workspace scan.
    await Future.wait([
      for (final target in _targets)
        () async {
          try {
            final scoped = await _fetch(target);
            if (_loadId != loadId || !ref.mounted) return;
            next = mergeProviderSkills(next, scoped);
            state = state.copyWith(skills: next);
          } on AppError catch (e) {
            firstError ??= e.message;
          }
        }(),
    ]);
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
    return [
      for (final s in rows)
        ProviderSkill.fromApi(provider, s, project: project),
    ];
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
}

/// Keyed by provider id; autoDispose matches the settings tab remount.
final providerSkillsProvider = NotifierProvider.autoDispose
    .family<ProviderSkillsController, ProviderSkillsState, String>(
      ProviderSkillsController.new,
    );
