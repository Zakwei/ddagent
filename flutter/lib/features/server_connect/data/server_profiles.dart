import 'dart:convert';
import 'dart:io';

import 'package:ddagent_app/core/config/env.dart';
import 'package:ddagent_app/core/platform/instance.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Normalizes user input into a base URL (adds https://, strips trailing /).
/// Port of mobile/src/lib/server-url.ts.
String normalizeServerUrl(String raw) {
  var url = raw.trim();
  if (url.isEmpty) return '';
  if (!RegExp('^https?://', caseSensitive: false).hasMatch(url)) url = 'https://$url';
  return url.replaceAll(RegExp(r'/+$'), '');
}

/// WS base for a given http(s) server URL.
String wsBaseFor(String base) =>
    base.replaceFirst(RegExp('^http:'), 'ws:').replaceFirst(RegExp('^https:'), 'wss:');

class ServerProfile {
  const ServerProfile({required this.url, this.name = '', this.isLocal = false});

  final String url;
  final String name;

  /// Server runs on this device (spawned by the app) — the router guard
  /// asks the local-server controller to make sure it is up before use.
  final bool isLocal;

  String get label => name.isEmpty ? url : name;

  Map<String, dynamic> toJson() => {'url': url, 'name': name, 'isLocal': isLocal};

  factory ServerProfile.fromJson(Map<String, dynamic> j) => ServerProfile(
    url: j['url'] as String? ?? '',
    name: j['name'] as String? ?? '',
    isLocal: j['isLocal'] as bool? ?? false,
  );
}

class ServerProfilesState {
  const ServerProfilesState({
    this.profiles = const [],
    this.activeUrl,
    this.lastUrl,
    this.defaultUrl,
  });

  final List<ServerProfile> profiles;

  /// Currently selected server — null means "not configured" (remote UI
  /// must show the connect screen; embedded builds never hit this path).
  final String? activeUrl;

  /// Server the stored JWT belongs to (last one connected) — may differ from
  /// [activeUrl] while the startup picker shows, which leaves that null.
  final String? lastUrl;

  /// Server connected automatically at startup instead of showing the picker.
  final String? defaultUrl;

  ServerProfilesState copyWith({List<ServerProfile>? profiles, String? activeUrl}) =>
      ServerProfilesState(
        profiles: profiles ?? this.profiles,
        activeUrl: activeUrl,
        lastUrl: activeUrl ?? lastUrl,
        defaultUrl: defaultUrl,
      );
}

/// Saved remote-server profiles (multi-server equivalent of the RN client's
/// remoteServers list). Persisted in the `settings` Hive box.
class ServerProfilesController extends Notifier<ServerProfilesState> {
  static const _profilesKey = 'serverProfiles';
  static const _activeKey = 'activeServerUrl';
  static const _defaultKey = 'defaultServerUrl';

  /// Desktop starts on the server picker unless a default server is set.
  /// Overridable for tests (which run on a desktop host).
  @visibleForTesting
  static bool pickAtStartup =
      !kIsWeb && (Platform.isLinux || Platform.isWindows || Platform.isMacOS);

  Box<dynamic> get _box => Hive.box<dynamic>('settings');

  @override
  ServerProfilesState build() {
    if (!Hive.isBoxOpen('settings')) {
      // Tests without storage: fall back to the dart-define default.
      return ServerProfilesState(
        activeUrl: Env.defaultServerUrl.isEmpty ? null : Env.defaultServerUrl,
      );
    }
    final raw = _box.get(_profilesKey) as String?;
    final profiles = <ServerProfile>[
      if (raw != null)
        for (final e in jsonDecode(raw) as List<dynamic>)
          ServerProfile.fromJson(Map<String, dynamic>.from(e as Map)),
    ];
    // A window pinned to a server (own storage) always starts on that server,
    // even if it was switched elsewhere last time.
    final pinned = pinnedServerUrl;
    if (pinned != null && !profiles.any((p) => p.url == pinned)) {
      profiles.add(ServerProfile(url: pinned, isLocal: pinnedServerIsLocal));
    }
    final last = _box.get(_activeKey) as String?;
    final def = _box.get(_defaultKey) as String?;
    final defaultUrl = profiles.any((p) => p.url == def) ? def : null;
    if (pinned == null && pickAtStartup) {
      // Null active → the router guard opens /connect (the picker).
      return ServerProfilesState(
        profiles: profiles,
        activeUrl: defaultUrl,
        lastUrl: last,
        defaultUrl: defaultUrl,
      );
    }
    var active = pinned ?? last;
    // First launch: seed from --dart-define or the first saved profile.
    active ??= Env.defaultServerUrl.isNotEmpty ? Env.defaultServerUrl : null;
    active ??= profiles.isEmpty ? null : profiles.first.url;
    return ServerProfilesState(
      profiles: profiles,
      activeUrl: active,
      lastUrl: last,
      defaultUrl: defaultUrl,
    );
  }

  /// Marks [url] as the startup server; null (or the current default) clears it.
  Future<void> toggleDefault(String url) async {
    final next = state.defaultUrl == url ? null : url;
    if (Hive.isBoxOpen('settings')) {
      if (next == null) {
        await _box.delete(_defaultKey);
      } else {
        await _box.put(_defaultKey, next);
      }
    }
    state = ServerProfilesState(
      profiles: state.profiles,
      activeUrl: state.activeUrl,
      lastUrl: state.lastUrl,
      defaultUrl: next,
    );
  }

  /// Adds (or selects) a profile and persists it.
  Future<void> select(String rawUrl, {String name = '', bool isLocal = false}) async {
    final url = normalizeServerUrl(rawUrl);
    if (url.isEmpty) return;
    final profiles = [...state.profiles];
    final idx = profiles.indexWhere((p) => p.url == url);
    if (idx == -1) {
      profiles.add(ServerProfile(url: url, name: name, isLocal: isLocal));
    } else if (profiles[idx].isLocal != isLocal ||
        (name.isNotEmpty && profiles[idx].name != name)) {
      profiles[idx] = ServerProfile(
        url: url,
        name: name.isEmpty ? profiles[idx].name : name,
        isLocal: isLocal,
      );
    }
    if (Hive.isBoxOpen('settings')) {
      await _box.put(_profilesKey, jsonEncode([for (final p in profiles) p.toJson()]));
      await _box.put(_activeKey, url);
    }
    state = state.copyWith(profiles: profiles, activeUrl: url);
  }

  Future<void> remove(String url) async {
    final profiles = state.profiles.where((p) => p.url != url).toList();
    var active = state.activeUrl;
    if (active == url) {
      active = profiles.isEmpty ? null : profiles.first.url;
    }
    if (state.defaultUrl == url) await toggleDefault(url);
    if (Hive.isBoxOpen('settings')) {
      await _box.put(_profilesKey, jsonEncode([for (final p in profiles) p.toJson()]));
      if (active == null) {
        await _box.delete(_activeKey);
      } else {
        await _box.put(_activeKey, active);
      }
    }
    state = state.copyWith(profiles: profiles, activeUrl: active);
  }
}

final serverProfilesProvider = NotifierProvider<ServerProfilesController, ServerProfilesState>(
  ServerProfilesController.new,
);

/// GET /api/auth/status on a bare client — verifies the URL is a DDAgent
/// server without touching the authed Dio instance (port of testConnection).
Future<({bool ok, String? error})> probeServer(String raw) async {
  final base = normalizeServerUrl(raw);
  if (base.isEmpty) return (ok: false, error: t.serverConnect.enterUrl);
  try {
    final res = await Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ),
    ).get<dynamic>('$base/api/auth/status');
    return res.statusCode == 200
        ? (ok: true, error: null)
        : (ok: false, error: t.serverConnect.httpStatus(code: res.statusCode ?? 0));
  } on DioException catch (e) {
    return (ok: false, error: e.message ?? t.serverConnect.networkError);
  } on Object catch (e) {
    // Malformed URL / parse failures never surface as DioException — treat
    // them as a failed probe instead of letting the throw escape the caller.
    return (ok: false, error: '$e');
  }
}
