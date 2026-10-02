import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/settings/data/settings_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Server-side notification preferences — port of the web
/// `NotificationPreferencesState`
/// (`src/components/settings/types/types.ts` + `useSettingsController.ts`).
/// `channels` covers inApp/webPush/desktop/sound plus the messenger channels
/// (telegram/discord) the server auto-syncs from registered endpoints;
/// `events` gates which agent events notify at all.
class NotificationPreferences {
  const NotificationPreferences({
    this.inApp = true,
    this.webPush = false,
    this.desktop = false,
    this.sound = true,
    this.telegram = false,
    this.discord = false,
    this.actionRequired = true,
    this.stop = true,
    this.error = true,
  });

  final bool inApp;
  final bool webPush;
  final bool desktop;
  final bool sound;
  final bool telegram;
  final bool discord;
  final bool actionRequired;
  final bool stop;
  final bool error;

  static const defaults = NotificationPreferences();

  /// Tolerant parse — mirrors `normalizeNotificationPreferences`: unknown or
  /// missing keys fall back to the web defaults, non-bools are ignored.
  static NotificationPreferences fromJson(Map<String, dynamic> j) {
    final channels = j['channels'] as Map? ?? const {};
    final events = j['events'] as Map? ?? const {};
    bool pick(Map<dynamic, dynamic> m, String key, bool fallback) {
      final v = m[key];
      return v is bool ? v : fallback;
    }

    const d = defaults;
    return NotificationPreferences(
      inApp: pick(channels, 'inApp', d.inApp),
      webPush: pick(channels, 'webPush', d.webPush),
      desktop: pick(channels, 'desktop', d.desktop),
      sound: pick(channels, 'sound', d.sound),
      telegram: pick(channels, 'telegram', d.telegram),
      discord: pick(channels, 'discord', d.discord),
      actionRequired: pick(events, 'actionRequired', d.actionRequired),
      stop: pick(events, 'stop', d.stop),
      error: pick(events, 'error', d.error),
    );
  }

  NotificationPreferences copyWithChannel(String channel, bool value) {
    return NotificationPreferences(
      inApp: channel == 'inApp' ? value : inApp,
      webPush: channel == 'webPush' ? value : webPush,
      desktop: channel == 'desktop' ? value : desktop,
      sound: channel == 'sound' ? value : sound,
      telegram: channel == 'telegram' ? value : telegram,
      discord: channel == 'discord' ? value : discord,
      actionRequired: actionRequired,
      stop: stop,
      error: error,
    );
  }

  NotificationPreferences copyWithEvent(String event, bool value) {
    return NotificationPreferences(
      inApp: inApp,
      webPush: webPush,
      desktop: desktop,
      sound: sound,
      telegram: telegram,
      discord: discord,
      actionRequired: event == 'actionRequired' ? value : actionRequired,
      stop: event == 'stop' ? value : stop,
      error: event == 'error' ? value : error,
    );
  }

  Map<String, dynamic> toJson() => {
    'channels': {
      'inApp': inApp,
      'webPush': webPush,
      'desktop': desktop,
      'sound': sound,
      'telegram': telegram,
      'discord': discord,
    },
    'events': {'actionRequired': actionRequired, 'stop': stop, 'error': error},
  };
}

class NotificationPreferencesState {
  const NotificationPreferencesState({
    this.prefs = NotificationPreferences.defaults,
    this.loaded = false,
    this.saving = false,
    this.error,
  });

  final NotificationPreferences prefs;
  final bool loaded;
  final bool saving;
  final String? error;
}

/// GET/PUT `/api/settings/notification-preferences`. Edits apply immediately
/// (the web auto-saves via debounce) and roll back on failure.
class NotificationPreferencesController extends Notifier<NotificationPreferencesState> {
  SettingsRepository get _repo => ref.read(settingsRepositoryProvider);

  @override
  NotificationPreferencesState build() {
    unawaited(_load());
    return const NotificationPreferencesState();
  }

  Future<void> _load() async {
    try {
      final res = await _repo.notificationPreferences();
      if (!ref.mounted) return;
      final prefs = res['preferences'];
      state = NotificationPreferencesState(
        prefs: prefs is Map
            ? NotificationPreferences.fromJson(Map<String, dynamic>.from(prefs))
            : NotificationPreferences.defaults,
        loaded: true,
      );
    } on AppError catch (e) {
      if (ref.mounted) {
        state = NotificationPreferencesState(
          prefs: NotificationPreferences.defaults,
          loaded: true,
          error: e.message,
        );
      }
    }
  }

  /// Optimistic channel/event flip + PUT; returns the error message on
  /// failure (state rolled back) or null on success.
  Future<String?> _save(NotificationPreferences next) async {
    final previous = state.prefs;
    state = NotificationPreferencesState(prefs: next, loaded: true, saving: true);
    try {
      await _repo.saveNotificationPreferences(next.toJson());
      if (!ref.mounted) return null;
      state = NotificationPreferencesState(prefs: next, loaded: true);
      return null;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = NotificationPreferencesState(prefs: previous, loaded: true, error: e.message);
      }
      return e.message;
    }
  }

  Future<String?> setChannel(String channel, bool value) =>
      _save(state.prefs.copyWithChannel(channel, value));

  Future<String?> setEvent(String event, bool value) =>
      _save(state.prefs.copyWithEvent(event, value));
}

final notificationPreferencesProvider =
    NotifierProvider<NotificationPreferencesController, NotificationPreferencesState>(
      NotificationPreferencesController.new,
    );
