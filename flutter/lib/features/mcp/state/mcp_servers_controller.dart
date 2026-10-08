import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/mcp/data/mcp_constants.dart';
import 'package:ddagent_app/features/mcp/data/mcp_formatting.dart';
import 'package:ddagent_app/features/mcp/data/mcp_models.dart';
import 'package:ddagent_app/features/mcp/data/mcp_repository.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Server list state — port of the `useMcpServers` return value (minus the
/// modal open/close flags, which live in the view as dialogs).
class McpServersState {
  const McpServersState({
    this.servers = const [],
    this.isLoading = false,
    this.isLoadingProjectScopes = false,
    this.loadError,
    this.deleteError,
  });

  final List<McpServer> servers;
  final bool isLoading;

  /// True while project/local scope files still load in the background — the
  /// user scope already rendered (web `isLoadingProjectScopes`).
  final bool isLoadingProjectScopes;
  final String? loadError;
  final String? deleteError;

  McpServersState copyWith({
    List<McpServer>? servers,
    bool? isLoading,
    bool? isLoadingProjectScopes,
    String? Function()? loadError,
    String? Function()? deleteError,
  }) => McpServersState(
    servers: servers ?? this.servers,
    isLoading: isLoading ?? this.isLoading,
    isLoadingProjectScopes: isLoadingProjectScopes ?? this.isLoadingProjectScopes,
    loadError: loadError != null ? loadError() : this.loadError,
    deleteError: deleteError != null ? deleteError() : this.deleteError,
  );
}

/// `useMcpServers` — per-provider server list. User scope loads first so the
/// list paints quickly; project/local scopes are appended as their per-project
/// fetches resolve. A 30s module cache (`mcpServersCache` parity) keeps
/// provider-tab switches from refetching every project config file.
class McpServersController extends Notifier<McpServersState> {
  McpServersController(this.provider);

  /// Provider id — `claude`, `cursor`, `codex`, `opencode`, `commandcode`, `antigravity` or `devin`.
  final String provider;

  static const _cacheTtl = Duration(seconds: 30);
  static final _cache = <String, ({List<McpServer> servers, DateTime at})>{};

  List<McpProjectTarget> _targets = const [];
  String _cacheKey = '';
  int _loadId = 0;

  McpRepository get _repo => ref.read(mcpRepositoryProvider);

  @override
  McpServersState build() {
    // Rebuild only when the project path/displayName set changes — plain
    // `watch(projectsProvider)` would refetch on every sidebar delta.
    ref.watch(
      projectsProvider.select(
        (s) => s.projects.map((p) => '${p.fullPath ?? p.path}${p.displayName}').join('|'),
      ),
    );
    _targets = _projectTargets(ref.read(projectsProvider).projects);
    _cacheKey = mcpCacheKey(provider, _targets);
    unawaited(Future.microtask(refresh));
    return const McpServersState(isLoading: true);
  }

  /// `createProjectTargets` — dedupe on `fullPath || path`, id = projectId.
  static List<McpProjectTarget> _projectTargets(List<Project> projects) {
    final seen = <String>{};
    final targets = <McpProjectTarget>[];
    for (final p in projects) {
      final path = (p.fullPath?.isNotEmpty ?? false) ? p.fullPath! : p.path;
      if (path.isEmpty || !seen.add(path)) continue;
      targets.add(
        McpProjectTarget(
          name: p.projectId,
          displayName: p.displayName.isNotEmpty ? p.displayName : p.projectId,
          path: path,
        ),
      );
    }
    return targets;
  }

  /// Merge incoming scope results into [existing] — one entry per server
  /// identity, sorted (`replaceScopedServers`/`mergeServers` parity).
  static List<McpServer> _replaceScoped(
    List<McpServer> existing,
    List<McpServer> incoming,
    McpScope scope, {
    String? workspacePath,
  }) {
    final remaining = [
      for (final s in existing)
        if (s.scope != scope || (s.workspacePath ?? '') != (workspacePath ?? '')) s,
    ];
    final byId = {for (final s in remaining) s.identity: s};
    for (final s in incoming) {
      byId[s.identity] = s;
    }
    return sortMcpServers(byId.values.toList());
  }

  Future<void> refresh({bool force = false}) async {
    final loadId = ++_loadId;
    final cached = _cache[_cacheKey];
    final fresh = cached != null && DateTime.now().difference(cached.at) < _cacheTtl && !force;
    if (fresh) {
      state = McpServersState(servers: cached.servers);
      return;
    }

    var next = cached != null && !force ? cached.servers : <McpServer>[];
    state = McpServersState(servers: next, isLoading: cached == null);

    final scopes = mcpSupportedScopes(provider);
    String? firstError;

    // User scope first — the visible list paints before project config files
    // are scanned (web `refreshServers` ordering).
    if (scopes.contains(McpScope.user)) {
      try {
        final userServers = await _repo.servers(provider, McpScope.user);
        if (_loadId != loadId || !ref.mounted) return;
        next = _replaceScoped(next, userServers, McpScope.user);
        state = state.copyWith(servers: next);
      } on AppError catch (e) {
        firstError = e.message;
      }
    }
    if (_loadId != loadId || !ref.mounted) return;
    state = state.copyWith(isLoading: false);

    final requests = <(McpScope, McpProjectTarget)>[
      for (final target in _targets) ...[
        if (scopes.contains(McpScope.project)) (McpScope.project, target),
        if (scopes.contains(McpScope.local)) (McpScope.local, target),
      ],
    ];
    if (requests.isEmpty) {
      final finalServers = sortMcpServers(next);
      _cache[_cacheKey] = (servers: finalServers, at: DateTime.now());
      state = state.copyWith(servers: finalServers, loadError: () => firstError);
      return;
    }

    state = state.copyWith(isLoadingProjectScopes: true);
    // Update the list as each project scope resolves instead of waiting for
    // the slowest config file.
    await Future.wait([
      for (final (scope, target) in requests)
        () async {
          try {
            final scoped = await _repo.servers(provider, scope, project: target);
            if (_loadId != loadId || !ref.mounted) return;
            next = _replaceScoped(next, scoped, scope, workspacePath: target.path);
            state = state.copyWith(servers: next);
          } on AppError catch (e) {
            firstError ??= e.message;
          }
        }(),
    ]);
    if (_loadId != loadId || !ref.mounted) return;

    final finalServers = sortMcpServers(next);
    _cache[_cacheKey] = (servers: finalServers, at: DateTime.now());
    state = state.copyWith(
      servers: finalServers,
      isLoadingProjectScopes: false,
      loadError: () => firstError,
    );
  }

  /// `didServerIdentityChange` — rename/scope/workspace edits delete the old
  /// config entry after the new one is written.
  static bool _identityChanged(McpServer editing, Map<String, dynamic> p) =>
      editing.name != p['name'] ||
      editing.scope.wire != p['scope'] ||
      (editing.workspacePath ?? '') != ((p['workspacePath'] as String?) ?? '');

  /// `submitForm` — returns null on success, otherwise the error message the
  /// form dialog renders as `submitError`.
  Future<String?> submit(Map<String, dynamic> payload, {McpServer? editing}) async {
    if (payload['scope'] != McpScope.user.wire &&
        ((payload['workspacePath'] as String?) ?? '').isEmpty) {
      return t.mcp.servers.selectProjectRequired;
    }
    try {
      await _repo.upsert(provider, payload);
      if (editing != null && _identityChanged(editing, payload)) {
        await _repo.delete(provider, editing);
      }
      _cache.remove(_cacheKey);
      await refresh(force: true);
      return null;
    } on AppError catch (e) {
      return e.message;
    }
  }

  /// `submitGlobalForm` — writes to every provider, so the whole cache goes.
  /// Partial failures come back as one joined message (web
  /// `formatGlobalAddFailures`).
  Future<String?> submitGlobal(Map<String, dynamic> payload) async {
    if (payload['scope'] == McpScope.local.wire) {
      return t.mcp.servers.globalScopeUnsupported;
    }
    if (payload['scope'] != McpScope.user.wire &&
        ((payload['workspacePath'] as String?) ?? '').isEmpty) {
      return t.mcp.servers.selectProjectRequired;
    }
    try {
      final results = await _repo.saveGlobal(payload);
      _cache.clear();
      await refresh(force: true);
      final failures = [
        for (final r in results)
          if (!r.created) r,
      ];
      if (failures.isEmpty) return null;
      return t.mcp.servers.globalAddFailed(
        details: failures
            .map(
              (f) =>
                  '${mcpProviderName(f.provider)}: '
                  '${f.error ?? t.common.messages.unknownError}',
            )
            .join('; '),
      );
    } on AppError catch (e) {
      return e.message;
    }
  }

  /// Delete after the view's confirm dialog — `deleteError` renders inline in
  /// the list like the web; returns nothing else to toast on failure.
  Future<void> delete(McpServer server) async {
    state = state.copyWith(deleteError: () => null);
    try {
      await _repo.delete(provider, server);
      _cache.remove(_cacheKey);
      await refresh(force: true);
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(deleteError: () => e.message);
    }
  }
}

/// Keyed by provider id; autoDispose matches the settings tab remount.
final mcpServersProvider = NotifierProvider.autoDispose
    .family<McpServersController, McpServersState, String>(McpServersController.new);
