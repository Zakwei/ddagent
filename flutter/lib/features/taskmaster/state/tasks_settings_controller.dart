import 'dart:async';

import 'package:ddagent_app/features/taskmaster/data/taskmaster_models.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Global "tasks UI" toggle — port of `TasksSettingsContext.jsx`, which
/// persists `tasks-enabled` in localStorage (default `true`). Same key name
/// in the shared `settings` Hive box.
class TasksEnabledController extends Notifier<bool> {
  static const _boxName = 'settings';
  static const _key = 'tasks-enabled';

  @override
  bool build() {
    if (!Hive.isBoxOpen(_boxName)) return true;
    final stored = Hive.box<dynamic>(_boxName).get(_key);
    return stored is bool ? stored : true;
  }

  Future<void> set(bool enabled) async {
    state = enabled;
    if (Hive.isBoxOpen(_boxName)) {
      await Hive.box<dynamic>(_boxName).put(_key, enabled);
    }
  }
}

final tasksEnabledProvider = NotifierProvider<TasksEnabledController, bool>(
  TasksEnabledController.new,
);

/// `GET /api/taskmaster/installation-status` — one-shot check for the
/// settings card (the web tab reads it once on mount via the context).
final taskmasterInstallStatusProvider =
    FutureProvider.autoDispose<TaskmasterConfig>((ref) async {
      final res = await ref
          .watch(taskmasterRepositoryProvider)
          .installationStatus();
      return TaskmasterConfig.fromJson(res);
    });
