import 'package:ddagent_app/core/platform/instance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// ThemeMode selection persisted in the shared `settings` Hive box
/// (`key: themeMode`, values: system|light|dark) — same box later tasks
/// use for other user prefs.
class ThemeModeController extends Notifier<ThemeMode> {
  static const _boxName = 'settings';
  static const _key = 'themeMode';

  @override
  ThemeMode build() => _read();

  ThemeMode _read() {
    if (!Hive.isBoxOpen(_boxName)) return ThemeMode.system;
    return switch (Hive.box<dynamic>(_boxName).get(_key)) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await Hive.box<dynamic>(_boxName).put(_key, mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

/// Call once before runApp: opens the Hive boxes the app needs.
Future<void> initStorage() async {
  await Hive.initFlutter(instanceStorageSubdir());
  // settings, chat (drafts + offline queue), workspace (split-pane layout).
  for (final name in const ['settings', 'chat', 'workspace']) {
    try {
      await Hive.openBox<dynamic>(name);
    } on Object {
      // Another app process holds this box's lock (a second plain launch) —
      // run on an in-memory box instead of leaving every reader to throw.
      await Hive.openBox<dynamic>(name, bytes: Uint8List(0));
    }
  }
}
