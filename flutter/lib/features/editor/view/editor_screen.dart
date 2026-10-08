import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/utils/path_utils.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/editor/data/editor_file_kind.dart';
import 'package:ddagent_app/features/editor/state/editor_controller.dart';
import 'package:ddagent_app/features/editor/view/code_editor.dart';
import 'package:ddagent_app/features/editor/view/editor_diff_view.dart';
import 'package:ddagent_app/features/editor/view/editor_dock.dart';
import 'package:ddagent_app/features/editor/view/editor_preview.dart';
import 'package:ddagent_app/features/file_tree/data/file_saver.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `/editor` screen: multi-tab code editor. Opens `?projectId=&file=` deep
/// links, renders text tabs in [CodeEditor], markdown with an edit/preview
/// toggle, images/media/binaries through [EditorPreview], and an optional
/// git diff/merge surface per tab.
class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key, this.projectId, this.filePath});

  final String? projectId;
  final String? filePath;

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  final _focus = FocusNode();
  String? _openedKey;
  bool _diffOpen = false;
  bool _dockOpen = true;
  final _previewOn = <String>{};

  /// Project the dock + deep links bind to; falls back to the first project.
  String? get _pid =>
      widget.projectId ?? ref.read(projectsProvider).projects.firstOrNull?.projectId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _openFromRoute());
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EditorScreen old) {
    super.didUpdateWidget(old);
    if (old.filePath != widget.filePath || old.projectId != widget.projectId) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _openFromRoute());
    }
  }

  void _openFromRoute() {
    final file = widget.filePath;
    if (file == null || file.isEmpty) return;
    final pid = _pid;
    if (pid == null) return;
    final key = '$pid:$file';
    if (key == _openedKey) return;
    _openedKey = key;
    _openFile(pid, file);
  }

  /// Dock/deep-link open — binary kinds skip the text fetch; `diff` opens
  /// the git diff surface for textual files.
  void _openFile(String projectId, String path, {bool diff = false}) {
    final kind = editorFileKind(path);
    ref.read(editorProvider.notifier).open(projectId, path, load: editorKindNeedsContent(kind));
    if (diff && (kind == EditorFileKind.text || kind == EditorFileKind.markdown)) {
      setState(() => _diffOpen = true);
    }
  }

  Future<void> _saveActive() async {
    final tab = ref.read(editorProvider).active;
    if (tab == null) return;
    final t = Translations.of(context);
    final ok = await ref.read(editorProvider.notifier).save(tab.id);
    if (mounted) {
      AppToast.show(
        context,
        ok ? t.codeEditor.toasts.savedFile(name: tab.name) : t.codeEditor.toasts.saveFailed,
        isError: !ok,
      );
    }
  }

  Future<void> _saveAll() async {
    final t = Translations.of(context);
    final ok = await ref.read(editorProvider.notifier).saveAll();
    if (mounted) {
      AppToast.show(
        context,
        ok ? t.codeEditor.toasts.allSaved : t.codeEditor.toasts.someSavesFailed,
        isError: !ok,
      );
    }
  }

  Future<void> _closeActive() async {
    final tab = ref.read(editorProvider).active;
    if (tab == null) return;
    if (await confirmCloseTab(context, tab)) {
      ref.read(editorProvider.notifier).close(tab.id);
    }
  }

  void _cycleTab(int dir) {
    final state = ref.read(editorProvider);
    if (state.tabs.length < 2) return;
    final i = state.tabs.indexWhere((t) => t.id == state.active?.id);
    final next = state.tabs[(i + dir) % state.tabs.length];
    ref.read(editorProvider.notifier).activate(next.id);
  }

  Future<void> _closeTab(EditorTab tab) async {
    if (await confirmCloseTab(context, tab)) {
      ref.read(editorProvider.notifier).close(tab.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorProvider);
    final settings = ref.watch(editorSettingsProvider);
    final tab = state.active;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyS, control: true): _saveActive,
        const SingleActivator(LogicalKeyboardKey.keyS, meta: true): _saveActive,
        const SingleActivator(LogicalKeyboardKey.keyS, control: true, shift: true): _saveAll,
        const SingleActivator(LogicalKeyboardKey.keyS, meta: true, shift: true): _saveAll,
        const SingleActivator(LogicalKeyboardKey.keyW, control: true): _closeActive,
        const SingleActivator(LogicalKeyboardKey.keyW, meta: true): _closeActive,
        const SingleActivator(LogicalKeyboardKey.tab, control: true): () => _cycleTab(1),
        const SingleActivator(LogicalKeyboardKey.tab, control: true, shift: true): () =>
            _cycleTab(-1),
        const SingleActivator(LogicalKeyboardKey.pageDown, control: true): () => _cycleTab(1),
        const SingleActivator(LogicalKeyboardKey.pageUp, control: true): () => _cycleTab(-1),
      },
      child: Focus(
        focusNode: _focus,
        autofocus: true,
        child: Column(
          children: [
            _TabStrip(
              state: state,
              onActivate: (id) => ref.read(editorProvider.notifier).activate(id),
              onClose: _closeTab,
            ),
            const Divider(height: 1),
            _Toolbar(
              tab: tab,
              diffOpen: _diffOpen,
              dockOpen: _dockOpen,
              previewOn: tab != null && _previewOn.contains(tab.id),
              settings: settings,
              onToggleDock: _pid == null ? null : () => setState(() => _dockOpen = !_dockOpen),
              onToggleDiff: () => setState(() => _diffOpen = !_diffOpen),
              onTogglePreview: tab == null
                  ? null
                  : () => setState(() {
                      if (!_previewOn.remove(tab.id)) _previewOn.add(tab.id);
                    }),
              onSave: tab != null && tab.isDirty ? _saveActive : null,
              onSaveAll: state.hasUnsavedChanges ? _saveAll : null,
              onReload: tab == null ? null : () => ref.read(editorProvider.notifier).reload(tab.id),
              onDownload: tab == null ? null : () => _downloadTab(tab),
              onHtmlPreview: tab == null
                  ? null
                  : () => unawaited(previewHtmlFile(_fileName(tab.path), tab.content)),
            ),
            const Divider(height: 1),
            Expanded(
              child: Row(
                children: [
                  if (_dockOpen && _pid != null)
                    EditorDock(
                      projectId: _pid!,
                      onOpenFile: (path, {diff = false}) => _openFile(_pid!, path, diff: diff),
                    ),
                  Expanded(child: _body(tab, settings)),
                ],
              ),
            ),
            _Footer(tab: tab),
          ],
        ),
      ),
    );
  }

  static String _fileName(String path) => pathBasename(path);

  /// web handleDownload — saves the current buffer (unsaved edits included).
  Future<void> _downloadTab(EditorTab tab) async {
    final t = Translations.of(context);
    final path = await downloadText(_fileName(tab.path), tab.content);
    if (path != null && mounted) {
      AppToast.show(context, t.codeEditor.toasts.savedTo(path: path));
    }
  }

  Widget _body(EditorTab? tab, EditorSettings settings) {
    if (tab == null) {
      return const _EmptyState();
    }
    final t = Translations.of(context);
    final kind = editorFileKind(tab.path);
    if (tab.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (tab.error != null) {
      return _ErrorBody(
        message: tab.error!.message,
        onRetry: () => ref.read(editorProvider.notifier).reload(tab.id),
      );
    }
    switch (kind) {
      case EditorFileKind.image:
      case EditorFileKind.media:
      case EditorFileKind.binary:
        return EditorPreview(kind: kind, projectId: tab.projectId, path: tab.path);
      case EditorFileKind.markdown:
        if (_previewOn.contains(tab.id)) {
          return EditorPreview(
            kind: kind,
            projectId: tab.projectId,
            path: tab.path,
            content: tab.content,
          );
        }
      case EditorFileKind.text:
    }
    if (_diffOpen) {
      return EditorDiffView(
        key: ValueKey('diff:${tab.id}'),
        tab: tab,
        onClose: () => setState(() => _diffOpen = false),
        onApply: (merged) {
          ref.read(editorProvider.notifier).updateContent(tab.id, merged);
          setState(() => _diffOpen = false);
          AppToast.show(context, t.codeEditor.toasts.mergeApplied);
        },
        onDiscarded: () {
          setState(() => _diffOpen = false);
          // Discard deleted the file on disk when untracked; for tracked
          // files reload picks up the restored HEAD content.
          ref.read(editorProvider.notifier).reload(tab.id);
        },
      );
    }
    return CodeEditor(
      key: ValueKey(tab.id),
      content: tab.content,
      language: editorLanguage(tab.path),
      fontSize: settings.fontSize,
      tabSize: settings.tabSize,
      wordWrap: settings.wordWrap,
      minimap: settings.minimap,
      onChanged: (text) => ref.read(editorProvider.notifier).updateContent(tab.id, text),
    );
  }
}

class _TabStrip extends StatelessWidget {
  const _TabStrip({required this.state, required this.onActivate, required this.onClose});

  final EditorState state;
  final ValueChanged<String> onActivate;
  final ValueChanged<EditorTab> onClose;

  @override
  Widget build(BuildContext context) {
    if (state.tabs.isEmpty) return const SizedBox(height: 4);
    final colors = context.appColors;
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        children: [
          for (final tab in state.tabs)
            _TabChip(
              tab: tab,
              active: tab.id == state.active?.id,
              onTap: () => onActivate(tab.id),
              onClose: () => onClose(tab),
              colors: colors,
            ),
        ],
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
    required this.tab,
    required this.active,
    required this.onTap,
    required this.onClose,
    required this.colors,
  });

  final EditorTab tab;
  final bool active;
  final VoidCallback onTap;
  final VoidCallback onClose;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2, color: active ? colors.primary : Colors.transparent),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tab.isDirty)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(Icons.circle, size: 7, color: colors.primary),
              ),
            Text(
              tab.name,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: active ? colors.foreground : colors.mutedForeground),
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: onClose,
              borderRadius: AppRadii.borderMd,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(Icons.close, size: 13, color: colors.mutedForeground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.tab,
    required this.diffOpen,
    required this.dockOpen,
    required this.previewOn,
    required this.settings,
    required this.onToggleDock,
    required this.onToggleDiff,
    required this.onTogglePreview,
    required this.onSave,
    required this.onSaveAll,
    required this.onReload,
    required this.onDownload,
    required this.onHtmlPreview,
  });

  final EditorTab? tab;
  final bool diffOpen;
  final bool dockOpen;
  final bool previewOn;
  final EditorSettings settings;
  final VoidCallback? onToggleDock;
  final VoidCallback onToggleDiff;
  final VoidCallback? onTogglePreview;
  final VoidCallback? onSave;
  final VoidCallback? onSaveAll;
  final VoidCallback? onReload;
  final VoidCallback? onDownload;
  final VoidCallback? onHtmlPreview;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final t = Translations.of(context);
    final kind = tab == null ? null : editorFileKind(tab!.path);
    final isHtml = tab != null && RegExp(r'\.html?$', caseSensitive: false).hasMatch(tab!.path);
    final isTextual = kind == EditorFileKind.text || kind == EditorFileKind.markdown;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      child: Row(
        children: [
          IconButton(
            tooltip: t.codeEditor.toolbar.toggleDock,
            visualDensity: VisualDensity.compact,
            icon: Icon(
              Icons.view_sidebar_outlined,
              size: 18,
              color: dockOpen ? colors.primary : null,
            ),
            onPressed: onToggleDock,
          ),
          Expanded(
            child: Text(
              tab?.path ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.mutedForeground),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (kind == EditorFileKind.markdown)
            IconButton(
              tooltip: previewOn
                  ? t.codeEditor.actions.editMarkdown
                  : t.codeEditor.actions.previewMarkdown,
              visualDensity: VisualDensity.compact,
              icon: Icon(previewOn ? Icons.edit_outlined : Icons.visibility_outlined, size: 18),
              onPressed: onTogglePreview,
            ),
          if (isTextual)
            IconButton(
              tooltip: t.codeEditor.toolbar.diffMerge,
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.difference_outlined,
                size: 18,
                color: diffOpen ? colors.primary : null,
              ),
              onPressed: onToggleDiff,
            ),
          if (isHtml)
            IconButton(
              tooltip: t.codeEditor.toolbar.previewInBrowser,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.visibility_outlined, size: 18),
              onPressed: onHtmlPreview,
            ),
          if (isTextual)
            IconButton(
              tooltip: t.codeEditor.toolbar.reload,
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.refresh, size: 18),
              onPressed: onReload,
            ),
          IconButton(
            tooltip: t.common.buttons.download,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.download_outlined, size: 18),
            onPressed: onDownload,
          ),
          AppButton(
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.sm,
            onPressed: onSaveAll,
            child: Text(t.codeEditor.actions.saveAll),
          ),
          const SizedBox(width: 4),
          AppButton(
            size: AppButtonSize.sm,
            onPressed: onSave,
            child: Text(t.codeEditor.actions.save),
          ),
          const _SettingsMenu(),
        ],
      ),
    );
  }
}

class _SettingsMenu extends ConsumerWidget {
  const _SettingsMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(editorSettingsProvider);
    final c = ref.read(editorSettingsProvider.notifier);
    final t = Translations.of(context);
    return PopupMenuButton<String>(
      tooltip: t.codeEditor.toolbar.settings,
      icon: const Icon(Icons.settings_outlined, size: 18),
      onSelected: (v) {
        switch (v) {
          case 'wrap':
            c.setWordWrap(!s.wordWrap);
          case 'minimap':
            c.toggleMinimap();
          case 'tab':
            c.setTabSize(s.tabSize >= 8 ? 2 : s.tabSize * 2);
          case 'smaller':
            c.setFontSize(s.fontSize - 1);
          case 'bigger':
            c.setFontSize(s.fontSize + 1);
        }
      },
      itemBuilder: (_) => [
        CheckedPopupMenuItem(
          value: 'wrap',
          checked: s.wordWrap,
          child: Text(t.settings.appearance.wordWrap),
        ),
        CheckedPopupMenuItem(
          value: 'minimap',
          checked: s.minimap,
          child: Text(t.codeEditor.settings.minimap),
        ),
        PopupMenuItem(
          value: 'tab',
          child: Text(t.codeEditor.settings.tabSize(size: s.tabSize)),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'smaller',
          child: Text(t.codeEditor.settings.fontSizeDecrease(size: s.fontSize.toInt())),
        ),
        PopupMenuItem(value: 'bigger', child: Text(t.codeEditor.settings.fontSizeIncrease)),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.tab});

  final EditorTab? tab;

  @override
  Widget build(BuildContext context) {
    if (tab == null) return const SizedBox.shrink();
    final colors = context.appColors;
    final t = Translations.of(context);
    final lines = '\n'.allMatches(tab!.content).length + 1;
    final lang = editorLanguage(tab!.path) ?? t.codeEditor.footer.plainText;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 3),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Text(
        '$lang · ${t.codeEditor.footer.lineCount(count: lines)}'
        '${tab!.isDirty ? ' · ${t.codeEditor.footer.modified}' : ''}',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.mutedForeground),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final t = Translations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit_note, size: 48, color: colors.mutedForeground),
          const SizedBox(height: AppSpacing.sm),
          Text(t.codeEditor.emptyState.title, style: Theme.of(context).textTheme.titleSmall),
          Text(
            t.codeEditor.emptyState.hint,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colors.mutedForeground),
          ),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: TextStyle(color: context.appColors.destructive)),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: onRetry,
            child: Text(t.chat.session.messages.retry),
          ),
        ],
      ),
    );
  }
}
