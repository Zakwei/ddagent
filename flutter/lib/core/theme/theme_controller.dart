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
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('settings');
}
