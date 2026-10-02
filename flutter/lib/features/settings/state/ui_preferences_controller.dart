import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// UI preferences — port of `src/hooks/useUiPreferences.ts`. Same flag names
/// and defaults as the web `localStorage.uiPreferences` blob; persisted in
/// the shared `settings` Hive box under the same `uiPreferences` key.
class UiPreferences {
  const UiPreferences({
    this.showRawParameters = false,
    this.showThinking = true,
    this.sendByCtrlEnter = false,
    this.sidebarVisible = true,
    this.focusFollowsPointer = false,
    this.preventSleep = false,
  });

  final bool showRawParameters;
  final bool showThinking;
  final bool sendByCtrlEnter;
  final bool sidebarVisible;
  final bool focusFollowsPointer;
  final bool preventSleep;

  static const defaults = UiPreferences();

  UiPreferences copyWith({
    bool? showRawParameters,
    bool? showThinking,
    bool? sendByCtrlEnter,
    bool? sidebarVisible,
    bool? focusFollowsPointer,
    bool? preventSleep,
  }) => UiPreferences(
    showRawParameters: showRawParameters ?? this.showRawParameters,
    showThinking: showThinking ?? this.showThinking,
    sendByCtrlEnter: sendByCtrlEnter ?? this.sendByCtrlEnter,
    sidebarVisible: sidebarVisible ?? this.sidebarVisible,
    focusFollowsPointer: focusFollowsPointer ?? this.focusFollowsPointer,
    preventSleep: preventSleep ?? this.preventSleep,
  );

  Map<String, dynamic> toJson() => {
    'showRawParameters': showRawParameters,
    'showThinking': showThinking,
    'sendByCtrlEnter': sendByCtrlEnter,
    'sidebarVisible': sidebarVisible,
    'focusFollowsPointer': focusFollowsPointer,
    'preventSleep': preventSleep,
  };

  /// Tolerant parse — mirrors the web `parseBoolean` (accepts bools and
  /// 'true'/'false' strings; unknown keys are ignored).
  static UiPreferences fromJson(Map<dynamic, dynamic> j) {
    bool parse(String key, bool fallback) {
      final v = j[key];
      if (v is bool) return v;
      if (v == 'true') return true;
      if (v == 'false') return false;
      return fallback;
    }

    const d = defaults;
    return UiPreferences(
      showRawParameters: parse('showRawParameters', d.showRawParameters),
      showThinking: parse('showThinking', d.showThinking),
      sendByCtrlEnter: parse('sendByCtrlEnter', d.sendByCtrlEnter),
      sidebarVisible: parse('sidebarVisible', d.sidebarVisible),
      focusFollowsPointer: parse('focusFollowsPointer', d.focusFollowsPointer),
      preventSleep: parse('preventSleep', d.preventSleep),
    );
  }
}

class UiPreferencesController extends Notifier<UiPreferences> {
  static const _boxName = 'settings';
  static const _key = 'uiPreferences';

  @override
  UiPreferences build() {
    if (!Hive.isBoxOpen(_boxName)) return UiPreferences.defaults;
    final raw = Hive.box<dynamic>(_boxName).get(_key);
    return raw is Map ? UiPreferences.fromJson(raw) : UiPreferences.defaults;
  }

  void _save() {
    if (!Hive.isBoxOpen(_boxName)) return;
    unawaited(Hive.box<dynamic>(_boxName).put(_key, state.toJson()));
  }

  void update(UiPreferences Function(UiPreferences) change) {
    state = change(state);
    _save();
  }

  void setFocusFollowsPointer(bool value) => update((p) => p.copyWith(focusFollowsPointer: value));

  /// Web `sidebarVisible` pref — off means focus mode (rail hidden).
  void toggleSidebar() => update((p) => p.copyWith(sidebarVisible: !p.sidebarVisible));
}

final uiPreferencesProvider = NotifierProvider<UiPreferencesController, UiPreferences>(
  UiPreferencesController.new,
);

/// Project list ordering — web stores it in `claude-settings.projectSortOrder`
/// (`'name' | 'date'`, default `'name'`); here it lives in the `settings`
/// Hive box under `projectSortOrder`.
enum ProjectSortOrder {
  name,
  date;

  static ProjectSortOrder parse(Object? value) =>
      value == 'date' ? ProjectSortOrder.date : ProjectSortOrder.name;
}

class ProjectSortOrderController extends Notifier<ProjectSortOrder> {
  static const _boxName = 'settings';
  static const _key = 'projectSortOrder';

  @override
  ProjectSortOrder build() {
    if (!Hive.isBoxOpen(_boxName)) return ProjectSortOrder.name;
    return ProjectSortOrder.parse(Hive.box<dynamic>(_boxName).get(_key));
  }

  Future<void> set(ProjectSortOrder order) async {
    state = order;
    if (Hive.isBoxOpen(_boxName)) {
      await Hive.box<dynamic>(_boxName).put(_key, order.name);
    }
  }
}

final projectSortOrderProvider = NotifierProvider<ProjectSortOrderController, ProjectSortOrder>(
  ProjectSortOrderController.new,
);
