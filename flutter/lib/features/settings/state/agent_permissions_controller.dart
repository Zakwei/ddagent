import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Per-provider permission presets — the default permission mode new sessions
/// of each agent start in. The Hive `settings` box stores a JSON map under
/// `claude-settings`, `cursor-tools-settings` or `<provider>-settings` (the
/// original web `localStorage` keys) with a `permissionMode` field.
class AgentPermissions {
  const AgentPermissions({this.permissionMode = 'default'});

  /// One of the provider's [providerPermissionModesProvider] modes.
  final String permissionMode;
}

/// Offline fallback for [providerPermissionModesProvider] — a snapshot of the
/// backend `provider-capabilities.service.ts` `permissionModes` table.
const agentPermissionModes = <String, List<String>>{
  'claude': ['default', 'auto', 'acceptEdits', 'bypassPermissions', 'plan'],
  'cursor': ['default', 'bypassPermissions', 'plan'],
  'codex': ['default', 'acceptEdits', 'bypassPermissions'],
  'opencode': ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
  'commandcode': ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
  'antigravity': ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
  'devin': ['default', 'auto', 'acceptEdits', 'bypassPermissions', 'plan'],
};

/// Modes a provider's settings page offers — the server's capability matrix
/// (`GET /api/providers/:provider/capabilities`), else the snapshot above.
final providerPermissionModesProvider = FutureProvider.family<List<String>, String>((
  ref,
  provider,
) async {
  try {
    final caps = await ref.read(sessionsRepositoryProvider).capabilities(provider);
    final modes = [for (final m in caps['permissionModes'] as List? ?? const []) '$m'];
    if (modes.isNotEmpty) return modes;
  } on Object {
    // Offline / older server — fall back to the snapshot.
  }
  return agentPermissionModes[provider] ?? const ['default'];
});

/// Every mode any provider knows — stored picks are validated against this,
/// since the per-provider list now comes from the server.
const _knownModes = {'default', 'auto', 'acceptEdits', 'bypassPermissions', 'plan'};

class AgentPermissionsController extends Notifier<AgentPermissions> {
  AgentPermissionsController(this._provider);

  /// One of claude|cursor|codex|opencode|commandcode|antigravity|devin.
  final String _provider;

  static const _boxName = 'settings';

  static String _storageKey(String provider) => switch (provider) {
    'claude' => 'claude-settings',
    'cursor' => 'cursor-tools-settings',
    _ => '$provider-settings',
  };

  /// Tolerant parse — mirrors `toCodexPermissionMode`/`toProviderPermissionMode`
  /// (unknown modes fall back to `default`).
  static String _parseMode(String provider, Object? value) {
    final v = value?.toString() ?? 'default';
    return _knownModes.contains(v) ? v : 'default';
  }

  @override
  AgentPermissions build() {
    if (!Hive.isBoxOpen(_boxName)) return const AgentPermissions();
    // Stored as a decoded JSON map; a legacy String blob still parses.
    Object? decoded = Hive.box<dynamic>(_boxName).get(_storageKey(_provider));
    if (decoded is String) {
      try {
        decoded = jsonDecode(decoded);
      } on Object {
        decoded = null;
      }
    }
    if (decoded is! Map<Object?, Object?>) return const AgentPermissions();
    // Legacy claude/cursor blobs carried a skip-permissions toggle next to an
    // always-`default` mode — treat it as bypass until a mode is picked
    // (saving a mode drops the legacy field).
    final legacyBypass =
        decoded['skipPermissions'] == true && (decoded['permissionMode'] ?? 'default') == 'default';
    return AgentPermissions(
      permissionMode: legacyBypass
          ? _parseMode(_provider, 'bypassPermissions')
          : _parseMode(_provider, decoded['permissionMode']),
    );
  }

  void setPermissionMode(String mode) {
    state = AgentPermissions(permissionMode: _parseMode(_provider, mode));
    if (!Hive.isBoxOpen(_boxName)) return;
    unawaited(
      Hive.box<dynamic>(_boxName).put(_storageKey(_provider), <String, dynamic>{
        'permissionMode': state.permissionMode,
        'lastUpdated': DateTime.now().toIso8601String(),
      }),
    );
  }
}

/// Keyed by provider id (claude|cursor|codex|opencode|commandcode|antigravity|devin).
final agentPermissionsProvider =
    NotifierProvider.family<AgentPermissionsController, AgentPermissions, String>(
      AgentPermissionsController.new,
    );
