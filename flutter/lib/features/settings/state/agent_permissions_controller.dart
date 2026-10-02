import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Per-provider permission presets — port of the web `localStorage` blobs
/// written by `useSettingsController.saveSettings()`:
/// `claude-settings` (allowedTools/disallowedTools/skipPermissions),
/// `cursor-tools-settings` (allowedCommands/disallowedCommands/skipPermissions)
/// and `<provider>-settings.permissionMode` for codex/opencode/commandcode/devin.
/// The Hive `settings` box stores the decoded JSON under the same key and
/// field names so the semantics stay identical to the web client.
class AgentPermissions {
  const AgentPermissions({
    this.skipPermissions = false,
    this.allowed = const [],
    this.disallowed = const [],
    this.permissionMode = 'default',
  });

  /// claude/cursor only — skip every permission prompt (`--dangerously-skip`
  /// / `-f` equivalents).
  final bool skipPermissions;

  /// `allowedTools` (claude) / `allowedCommands` (cursor).
  final List<String> allowed;

  /// `disallowedTools` (claude) / `disallowedCommands` (cursor).
  final List<String> disallowed;

  /// codex/opencode/commandcode/devin — `default|acceptEdits|bypassPermissions|plan`.
  final String permissionMode;

  AgentPermissions copyWith({
    bool? skipPermissions,
    List<String>? allowed,
    List<String>? disallowed,
    String? permissionMode,
  }) => AgentPermissions(
    skipPermissions: skipPermissions ?? this.skipPermissions,
    allowed: allowed ?? this.allowed,
    disallowed: disallowed ?? this.disallowed,
    permissionMode: permissionMode ?? this.permissionMode,
  );
}

/// Modes each provider's settings page offers — port of
/// `FALLBACK_PERMISSION_MODES` (src/components/chat/constants/permissionModes.ts)
/// restricted to what the settings UI renders.
const agentPermissionModes = <String, List<String>>{
  'codex': ['default', 'acceptEdits', 'bypassPermissions'],
  'opencode': ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
  'commandcode': ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
  'devin': ['default', 'acceptEdits', 'bypassPermissions'],
};

class AgentPermissionsController extends Notifier<AgentPermissions> {
  AgentPermissionsController(this._provider);

  /// One of claude|cursor|codex|opencode|commandcode|devin.
  final String _provider;

  static const _boxName = 'settings';

  static String _storageKey(String provider) => switch (provider) {
    'claude' => 'claude-settings',
    'cursor' => 'cursor-tools-settings',
    _ => '$provider-settings',
  };

  static bool _supportsLists(String provider) =>
      provider == 'claude' || provider == 'cursor';

  /// `allowedTools` vs `allowedCommands` — cursor stores shell commands.
  static String _allowedKey(String provider) =>
      provider == 'cursor' ? 'allowedCommands' : 'allowedTools';

  static String _disallowedKey(String provider) =>
      provider == 'cursor' ? 'disallowedCommands' : 'disallowedTools';

  static List<String> _stringList(Object? value) => [
    for (final e in (value as List?) ?? const [])
      if ('$e'.trim().isNotEmpty) '$e',
  ];

  /// Tolerant parse — mirrors `toCodexPermissionMode`/`toProviderPermissionMode`
  /// (unknown modes fall back to `default`).
  static String _parseMode(String provider, Object? value) {
    final modes = agentPermissionModes[provider] ?? const ['default'];
    final v = value?.toString() ?? 'default';
    return modes.contains(v) ? v : 'default';
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
    final map = decoded;
    return AgentPermissions(
      skipPermissions: map['skipPermissions'] == true,
      allowed: _supportsLists(_provider)
          ? _stringList(map[_allowedKey(_provider)])
          : const [],
      disallowed: _supportsLists(_provider)
          ? _stringList(map[_disallowedKey(_provider)])
          : const [],
      permissionMode: _parseMode(_provider, map['permissionMode']),
    );
  }

  void _save() {
    if (!Hive.isBoxOpen(_boxName)) return;
    final json = <String, dynamic>{
      'permissionMode': state.permissionMode,
      'skipPermissions': state.skipPermissions,
      if (_supportsLists(_provider)) ...{
        _allowedKey(_provider): state.allowed,
        _disallowedKey(_provider): state.disallowed,
      },
      'lastUpdated': DateTime.now().toIso8601String(),
    };
    unawaited(Hive.box<dynamic>(_boxName).put(_storageKey(_provider), json));
  }

  void setSkipPermissions(bool value) {
    state = state.copyWith(skipPermissions: value);
    _save();
  }

  void setAllowed(List<String> value) {
    state = state.copyWith(allowed: value);
    _save();
  }

  void setDisallowed(List<String> value) {
    state = state.copyWith(disallowed: value);
    _save();
  }

  void setPermissionMode(String mode) {
    state = state.copyWith(permissionMode: _parseMode(_provider, mode));
    _save();
  }
}

/// Keyed by provider id (claude|cursor|codex|opencode|commandcode|devin).
final agentPermissionsProvider =
    NotifierProvider.family<
      AgentPermissionsController,
      AgentPermissions,
      String
    >(AgentPermissionsController.new);
