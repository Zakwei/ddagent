import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// One open editor tab — keyed by `projectId:path` so the same file in two
/// projects stays distinct.
class EditorTab {
  const EditorTab({
    required this.id,
    required this.projectId,
    required this.path,
    this.content = '',
    this.savedContent = '',
    this.loading = false,
    this.error,
  });

  final String id;
  final String projectId;
  final String path;

  /// Buffer as edited; [savedContent] is the last loaded/saved baseline.
  final String content;
  final String savedContent;
  final bool loading;
  final AppError? error;

  bool get isDirty => content != savedContent;

  /// File name for the tab label.
  String get name => path.split('/').last;

  EditorTab copyWith({
    String? content,
    String? savedContent,
    bool? loading,
    AppError? Function()? error,
  }) => EditorTab(
    id: id,
    projectId: projectId,
    path: path,
    content: content ?? this.content,
    savedContent: savedContent ?? this.savedContent,
    loading: loading ?? this.loading,
    error: error != null ? error() : this.error,
  );
}

class EditorState {
  const EditorState({this.tabs = const [], this.activeId});

  final List<EditorTab> tabs;
  final String? activeId;

  EditorTab? get active {
    for (final t in tabs) {
      if (t.id == activeId) return t;
    }
    return tabs.isEmpty ? null : tabs.last;
  }

  /// True when any tab holds unsaved edits — drives the reload/leave guard.
  bool get hasUnsavedChanges => tabs.any((t) => t.isDirty);

  EditorState copyWith({List<EditorTab>? tabs, String? Function()? activeId}) =>
      EditorState(
        tabs: tabs ?? this.tabs,
        activeId: activeId != null ? activeId() : this.activeId,
      );
}

/// Multi-tab editor state (T21): open/activate/close tabs, dirty tracking,
/// save/reload through FileTreeRepository. The discard-confirm dialog lives
/// in [confirmCloseTab] — the controller itself never shows UI.
class EditorController extends Notifier<EditorState> {
  @override
  EditorState build() => const EditorState();

  static String tabId(String projectId, String path) => '$projectId:$path';

  EditorTab? _tab(String id) {
    for (final t in state.tabs) {
      if (t.id == id) return t;
    }
    return null;
  }

  void _replace(EditorTab tab) {
    state = state.copyWith(
      tabs: [
        for (final t in state.tabs)
          if (t.id == tab.id) tab else t,
      ],
    );
  }

  /// Open a file in a tab (or activate the existing one) and load content.
  /// [load] = false skips the text fetch — for image/media/binary tabs that
  /// only render a preview widget.
  Future<void> open(String projectId, String path, {bool load = true}) async {
    final id = tabId(projectId, path);
    if (_tab(id) != null) {
      activate(id);
      return;
    }
    final tab = EditorTab(
      id: id,
      projectId: projectId,
      path: path,
      loading: load,
    );
    state = state.copyWith(tabs: [...state.tabs, tab], activeId: () => id);
    if (load) await _load(tab);
  }

  Future<void> _load(EditorTab tab) async {
    try {
      final text = await ref
          .read(fileTreeRepositoryProvider)
          .readFile(tab.projectId, tab.path);
      if (!ref.mounted) return;
      _replace(
        tab.copyWith(
          content: text,
          savedContent: text,
          loading: false,
          error: () => null,
        ),
      );
    } on AppError catch (e) {
      if (ref.mounted) _replace(tab.copyWith(loading: false, error: () => e));
    }
  }

  void activate(String id) {
    if (_tab(id) != null && state.activeId != id) {
      state = state.copyWith(activeId: () => id);
    }
  }

  /// Closes the tab without checking dirt — the view calls
  /// [confirmCloseTab] first. Falls back to the last remaining tab.
  void close(String id) {
    final tabs = state.tabs.where((t) => t.id != id).toList();
    state = state.copyWith(
      tabs: tabs,
      activeId: () => state.activeId == id
          ? (tabs.isEmpty ? null : tabs.last.id)
          : state.activeId,
    );
  }

  /// Buffer update from the editor widget — dirty is derived, not stored.
  void updateContent(String id, String content) {
    final tab = _tab(id);
    if (tab == null || tab.content == content) return;
    _replace(tab.copyWith(content: content));
  }

  /// Reload the file from disk, discarding local edits.
  Future<void> reload(String id) async {
    final tab = _tab(id);
    if (tab == null) return;
    _replace(tab.copyWith(loading: true, error: () => null));
    await _load(tab);
  }

  Future<bool> save(String id) async {
    final tab = _tab(id);
    if (tab == null || !tab.isDirty) return true;
    try {
      await ref
          .read(fileTreeRepositoryProvider)
          .saveFile(tab.projectId, tab.path, tab.content);
      if (!ref.mounted) return true;
      _replace(tab.copyWith(savedContent: tab.content, error: () => null));
      return true;
    } on AppError catch (e) {
      if (ref.mounted) _replace(tab.copyWith(error: () => e));
      return false;
    }
  }

  /// Save every dirty tab — returns false when any save failed.
  Future<bool> saveAll() async {
    var ok = true;
    for (final t in state.tabs) {
      if (t.isDirty && !await save(t.id)) ok = false;
    }
    return ok;
  }
}

/// 'Discard changes?' gate — resolves true when the tab may close (clean,
/// or the user confirmed discarding). Shared by tab-close and route-leave.
Future<bool> confirmCloseTab(BuildContext context, EditorTab tab) async {
  if (!tab.isDirty) return true;
  final discard = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Unsaved changes in ${tab.name}'),
      content: const Text('Discard unsaved changes?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Discard'),
        ),
      ],
    ),
  );
  return discard ?? false;
}

final editorProvider = NotifierProvider<EditorController, EditorState>(
  EditorController.new,
);

/// Editor preferences persisted in the shared `settings` Hive box.
class EditorSettings {
  const EditorSettings({
    this.fontSize = 13.0,
    this.wordWrap = true,
    this.tabSize = 2,
    this.minimap = true,
  });

  final double fontSize;
  final bool wordWrap;
  final int tabSize;
  final bool minimap;

  EditorSettings copyWith({
    double? fontSize,
    bool? wordWrap,
    int? tabSize,
    bool? minimap,
  }) => EditorSettings(
    fontSize: fontSize ?? this.fontSize,
    wordWrap: wordWrap ?? this.wordWrap,
    tabSize: tabSize ?? this.tabSize,
    minimap: minimap ?? this.minimap,
  );
}

class EditorSettingsController extends Notifier<EditorSettings> {
  static const _key = 'editor_settings';
  static Box<dynamic> get _box => Hive.box<dynamic>('settings');

  @override
  EditorSettings build() {
    final raw = _box.get(_key);
    if (raw is Map) {
      return EditorSettings(
        fontSize: (raw['fontSize'] as num?)?.toDouble() ?? 13.0,
        wordWrap: raw['wordWrap'] != false,
        tabSize: (raw['tabSize'] as num?)?.toInt() ?? 2,
        minimap: raw['minimap'] != false,
      );
    }
    return const EditorSettings();
  }

  void _save() => unawaited(
    _box.put(_key, {
      'fontSize': state.fontSize,
      'wordWrap': state.wordWrap,
      'tabSize': state.tabSize,
      'minimap': state.minimap,
    }),
  );

  void setFontSize(double v) {
    state = state.copyWith(fontSize: v.clamp(8.0, 32.0));
    _save();
  }

  void setWordWrap(bool v) {
    state = state.copyWith(wordWrap: v);
    _save();
  }

  void setTabSize(int v) {
    state = state.copyWith(tabSize: v);
    _save();
  }

  void toggleMinimap() {
    state = state.copyWith(minimap: !state.minimap);
    _save();
  }
}

final editorSettingsProvider =
    NotifierProvider<EditorSettingsController, EditorSettings>(
      EditorSettingsController.new,
    );
