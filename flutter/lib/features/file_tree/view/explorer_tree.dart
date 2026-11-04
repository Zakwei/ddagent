import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/utils/path_utils.dart';
import 'package:ddagent_app/core/widgets/app_context_menu.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/file_tree/data/explorer_rows.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/state/explorer_git_status.dart';
import 'package:ddagent_app/features/file_tree/state/file_tree_controller.dart';
import 'package:ddagent_app/features/file_tree/view/file_icons.dart';
import 'package:ddagent_app/features/file_tree/view/file_viewer.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// VS Code-style explorer over [fileTreeProvider]: a collapsible project
/// section with hover actions, 22px rows with twisties, compact folders,
/// indent guides, git decorations, inline create/rename and full keyboard
/// navigation. Shared by the Files tab and the editor's side dock.
class ExplorerTree extends ConsumerStatefulWidget {
  const ExplorerTree({
    super.key,
    required this.title,
    required this.onOpenFile,
    this.activePath,
    this.filter = '',
    this.scrollController,
    this.showDetails = false,
    this.showOpenInEditor = true,
    this.moreActions = const [],
    this.onUploadTo,
    this.onEntryRenamed,
    this.onEntryDeleted,
  });

  /// Section header label — the project name.
  final String title;

  /// Called for a file row on click / Enter / Space and after inline create.
  final ValueChanged<FileTreeNode> onOpenFile;

  /// File shown by the host (open editor / viewer pane); it is revealed and
  /// selected whenever it changes (VS Code `explorer.autoReveal`).
  final String? activePath;

  /// Name filter: keeps matches plus their ancestors, everything expanded.
  final String filter;
  final ScrollController? scrollController;

  /// Size + modified columns on file rows.
  final bool showDetails;

  /// Adds "Open in Editor" to the file context menu (off inside the editor).
  final bool showOpenInEditor;

  /// Items for the section's "…" menu (view toggles, upload, …).
  final List<AppMenuItem> moreActions;

  /// Enables "Upload here" for a directory path (`''` = project root).
  final ValueChanged<String>? onUploadTo;
  final void Function(String oldPath, String newPath)? onEntryRenamed;
  final ValueChanged<String>? onEntryDeleted;

  @override
  ConsumerState<ExplorerTree> createState() => _ExplorerTreeState();
}

/// An inline name box: a new entry inside [parentPath] (`''` = root) or a
/// rename of [renaming].
class _InlineEdit {
  const _InlineEdit.create(this.parentPath, this.type) : renaming = null;
  _InlineEdit.rename(FileTreeNode this.renaming)
    : parentPath = pathDirname(renaming.path),
      type = renaming.isDirectory ? 'directory' : 'file';

  final String parentPath;
  final String type;
  final FileTreeNode? renaming;
}

class _ExplorerTreeState extends ConsumerState<ExplorerTree> {
  final _focus = FocusNode(debugLabel: 'explorer');
  final _editFocus = FocusNode(debugLabel: 'explorer-edit');
  final _editText = TextEditingController();
  ScrollController? _ownScroll;

  String? _selected;
  _InlineEdit? _edit;
  String? _editError;
  bool _editHadFocus = false;
  bool _collapsed = false;
  bool _hovered = false;
  String? _pendingReveal;

  /// Rows as last rendered — keyboard handling indexes into these.
  List<_Item> _items = const [];

  Map<String, dynamic>? _decoStatus;
  List<FileTreeNode>? _decoRoots;
  GitDecorations _deco = GitDecorations.empty;

  ScrollController get _scroll => widget.scrollController ?? (_ownScroll ??= ScrollController());

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    _editFocus.addListener(_onEditFocusChange);
    _editText.addListener(_validateEdit);
    if (widget.activePath != null) {
      _pendingReveal = widget.activePath;
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryReveal());
    }
  }

  @override
  void didUpdateWidget(ExplorerTree old) {
    super.didUpdateWidget(old);
    if (widget.activePath != old.activePath && widget.activePath != null) {
      _pendingReveal = widget.activePath;
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryReveal());
    }
  }

  @override
  void dispose() {
    _focus.dispose();
    _editFocus.dispose();
    _editText.dispose();
    _ownScroll?.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (mounted) setState(() {});
  }

  void _onEditFocusChange() {
    if (_editFocus.hasFocus) {
      _editHadFocus = true;
    } else if (_editHadFocus && _edit != null) {
      // VS Code commits the name box when it loses focus.
      unawaited(_commitEdit(fromBlur: true));
    }
  }

  double get _rowHeight => context.breakpoint.isCompact ? 32 : 22;
  double get _indent => context.breakpoint.isCompact ? 12 : 8;

  FileTreeState get _tree => ref.read(fileTreeProvider);
  FileTreeController get _ctrl => ref.read(fileTreeProvider.notifier);
  String? get _root => explorerProjectRoot(_tree.roots);

  // ── reveal / selection ────────────────────────────────────────────────

  void _tryReveal() {
    final path = _pendingReveal;
    final root = _root;
    if (!mounted || path == null || root == null) {
      return;
    }
    if (explorerRelativePath(path, root) == null) {
      _pendingReveal = null;
      return;
    }
    _pendingReveal = null;
    _ctrl.expandDirectories(explorerAncestors(path, root: root));
    setState(() => _selected = path);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToPath(path));
  }

  void _scrollToPath(String path) {
    final i = _items.indexWhere((it) => it.row?.path == path);
    if (i >= 0) {
      _scrollToIndex(i);
    }
  }

  void _scrollToIndex(int i) {
    if (!mounted || !_scroll.hasClients) {
      return;
    }
    final pos = _scroll.position;
    final top = i * _rowHeight;
    final bottom = top + _rowHeight;
    if (top < pos.pixels) {
      _scroll.jumpTo(top.clamp(0, pos.maxScrollExtent));
    } else if (bottom > pos.pixels + pos.viewportDimension) {
      _scroll.jumpTo((bottom - pos.viewportDimension).clamp(0, pos.maxScrollExtent));
    }
  }

  int get _selectedIndex => _selected == null
      ? -1
      : _items.indexWhere((it) => it.row != null && it.row!.path == _selected);

  void _select(int i) {
    if (i < 0 || i >= _items.length || _items[i].row == null) {
      return;
    }
    setState(() => _selected = _items[i].row!.path);
    _scrollToIndex(i);
  }

  void _activate(ExplorerRow row) {
    _focus.requestFocus();
    setState(() => _selected = row.path);
    if (row.node.isDirectory) {
      _ctrl.toggleDirectory(row.path);
    } else {
      widget.onOpenFile(row.node);
    }
  }

  // ── keyboard ──────────────────────────────────────────────────────────

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (_edit != null || (event is! KeyDownEvent && event is! KeyRepeatEvent)) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    final rows = [for (final it in _items) it.row].nonNulls.toList();
    if (rows.isEmpty) {
      return KeyEventResult.ignored;
    }
    final i = _selectedIndex;
    final row = i >= 0 ? _items[i].row : null;
    final expanded = ref.read(fileTreeProvider).expanded;

    if (key == LogicalKeyboardKey.arrowDown) {
      _select(i < 0 ? 0 : (i + 1).clamp(0, _items.length - 1));
    } else if (key == LogicalKeyboardKey.arrowUp) {
      _select(i < 0 ? 0 : (i - 1).clamp(0, _items.length - 1));
    } else if (key == LogicalKeyboardKey.home) {
      _select(0);
    } else if (key == LogicalKeyboardKey.end) {
      _select(_items.length - 1);
    } else if (key == LogicalKeyboardKey.arrowRight && row != null) {
      if (row.node.isDirectory) {
        if (!expanded.contains(row.path) && widget.filter.isEmpty) {
          _ctrl.toggleDirectory(row.path);
        } else if (i + 1 < _items.length && _items[i + 1].depth > row.depth) {
          _select(i + 1);
        }
      }
    } else if (key == LogicalKeyboardKey.arrowLeft && row != null) {
      if (row.node.isDirectory && expanded.contains(row.path) && widget.filter.isEmpty) {
        _ctrl.toggleDirectory(row.path);
      } else {
        // No inline box is open here, so _items and rows share indices.
        final parent = explorerParentIndex(rows, i);
        if (parent >= 0) {
          _select(parent);
        }
      }
    } else if ((key == LogicalKeyboardKey.enter ||
            key == LogicalKeyboardKey.numpadEnter ||
            key == LogicalKeyboardKey.space) &&
        row != null) {
      _activate(row);
    } else if (key == LogicalKeyboardKey.f2 && row != null) {
      _startRename(row.node);
    } else if ((key == LogicalKeyboardKey.delete ||
            (key == LogicalKeyboardKey.backspace && HardwareKeyboard.instance.isMetaPressed)) &&
        row != null) {
      unawaited(_delete(row.node));
    } else if (key == LogicalKeyboardKey.escape) {
      setState(() => _selected = null);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  // ── inline create / rename ────────────────────────────────────────────

  /// Folder a new entry goes into: the selected folder, else the selected
  /// file's folder, else the project root.
  String _createTarget() {
    final sel = _selected;
    if (sel == null) {
      return '';
    }
    final node = findExplorerNode(_tree.roots, sel);
    if (node == null) {
      return '';
    }
    final dir = node.isDirectory ? node.path : pathDirname(node.path);
    return dir == _root ? '' : dir;
  }

  void _startCreate(String type, {String? parent}) {
    final target = parent ?? _createTarget();
    if (target.isNotEmpty) {
      final root = _root;
      _ctrl.expandDirectories([target, ...explorerAncestors(target, root: root)]);
    }
    _beginEdit(_InlineEdit.create(target, type), '');
  }

  void _startRename(FileTreeNode node) {
    _beginEdit(_InlineEdit.rename(node), node.name);
    final dot = node.name.lastIndexOf('.');
    _editText.selection = TextSelection(
      baseOffset: 0,
      extentOffset: !node.isDirectory && dot > 0 ? dot : node.name.length,
    );
  }

  void _beginEdit(_InlineEdit edit, String text) {
    _collapsed = false;
    _edit = edit;
    _editError = null;
    _editHadFocus = false;
    _editText.text = text;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _edit != edit) {
        return;
      }
      _editFocus.requestFocus();
      final i = _items.indexWhere((it) => it.edit != null || it.row?.node == edit.renaming);
      if (i >= 0) {
        _scrollToIndex(i);
      }
    });
  }

  String? _validationError(_InlineEdit edit, String raw) {
    final t = Translations.of(context);
    final name = raw.trim();
    if (name.isEmpty) {
      return edit.renaming == null ? null : t.fileTree.nameRequired;
    }
    if (edit.renaming != null && name.toLowerCase() == edit.renaming!.name.toLowerCase()) {
      return null;
    }
    final parent = edit.renaming == null ? edit.parentPath : pathDirname(edit.renaming!.path);
    final siblings = explorerSiblingNames(_tree.roots, parent == _root ? '' : parent);
    return siblings.contains(name.toLowerCase()) ? t.fileTree.nameExists(name: name) : null;
  }

  void _validateEdit() {
    final edit = _edit;
    if (edit == null) {
      return;
    }
    final err = _validationError(edit, _editText.text);
    if (err != _editError) {
      setState(() => _editError = err);
    }
  }

  void _cancelEdit() {
    setState(() {
      _edit = null;
      _editError = null;
    });
    _focus.requestFocus();
  }

  Future<void> _commitEdit({bool fromBlur = false}) async {
    final edit = _edit;
    if (edit == null) {
      return;
    }
    final name = _editText.text.trim();
    final renaming = edit.renaming;
    if (name.isEmpty || (renaming != null && name == renaming.name)) {
      _cancelEdit();
      return;
    }
    if (_validationError(edit, name) != null) {
      if (fromBlur) {
        _cancelEdit();
      }
      return; // Enter on an invalid name keeps the box open, like VS Code.
    }
    setState(() {
      _edit = null;
      _editError = null;
    });
    if (!fromBlur) {
      _focus.requestFocus();
    }
    final String? err;
    final String newPath;
    if (renaming != null) {
      newPath = explorerJoin(pathDirname(renaming.path), name);
      err = await _ctrl.renameEntry(oldPath: renaming.path, newName: name);
    } else {
      final dir = edit.parentPath.isEmpty ? (_root ?? '') : edit.parentPath;
      newPath = dir.isEmpty ? name : explorerJoin(dir, name);
      err = await _ctrl.createEntry(parentPath: edit.parentPath, type: edit.type, name: name);
    }
    if (!mounted) {
      return;
    }
    if (err != null) {
      AppToast.show(context, err, isError: true);
      return;
    }
    setState(() => _selected = newPath);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToPath(newPath));
    if (renaming != null) {
      widget.onEntryRenamed?.call(renaming.path, newPath);
    } else if (edit.type == 'file') {
      widget.onOpenFile(FileTreeNode(name: name, path: newPath, isDirectory: false));
    }
  }

  Future<void> _delete(FileTreeNode node) async {
    final t = Translations.of(context);
    final ok = await AppDialog.confirm(
      context,
      title: t.fileTree.titles.delete(name: node.name),
      message: node.isDirectory
          ? t.fileTree.deleteFolderConfirm(path: node.path)
          : t.fileTree.deleteFileConfirm(path: node.path),
      confirmLabel: t.common.buttons.delete,
    );
    if (!ok || !mounted) {
      return;
    }
    // Keep the keyboard position: select the neighbour that takes its place.
    final i = _selectedIndex;
    final err = await _ctrl.deleteEntry(
      path: node.path,
      type: node.isDirectory ? 'directory' : 'file',
    );
    if (!mounted) {
      return;
    }
    if (err != null) {
      AppToast.show(context, err, isError: true);
      return;
    }
    _focus.requestFocus();
    widget.onEntryDeleted?.call(node.path);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && i >= 0 && _items.isNotEmpty) {
        _select(i.clamp(0, _items.length - 1));
      }
    });
  }

  void _refreshGit() {
    final pid = _tree.projectId;
    if (pid != null) {
      ref.invalidate(gitStatusProvider(pid));
    }
  }

  Future<void> _refresh() async {
    _refreshGit();
    await _ctrl.refresh();
  }

  // ── menus ─────────────────────────────────────────────────────────────

  void _copy(String text) {
    final t = Translations.of(context);
    unawaited(Clipboard.setData(ClipboardData(text: text)));
    AppToast.show(context, t.common.fileTree.toast.pathCopied);
  }

  List<AppMenuItem> _rowMenu(FileTreeNode node) {
    final t = Translations.of(context);
    final pid = _tree.projectId ?? '';
    final root = _root;
    final rel = root == null ? null : explorerRelativePath(node.path, root);
    return [
      if (!node.isDirectory) ...[
        AppMenuItem(
          label: t.common.gitPanel.worktrees.open,
          icon: LucideIcons.externalLink,
          onTap: () => widget.onOpenFile(node),
        ),
        if (widget.showOpenInEditor)
          AppMenuItem(
            label: t.common.fileOperations.openInEditor,
            icon: LucideIcons.notebookPen,
            onTap: () =>
                context.go('/editor?projectId=$pid&file=${Uri.encodeQueryComponent(node.path)}'),
          ),
      ] else ...[
        AppMenuItem(
          label: t.common.fileTree.context.newFile,
          icon: LucideIcons.filePlus,
          onTap: () => _startCreate('file', parent: node.path),
        ),
        AppMenuItem(
          label: t.common.fileTree.context.newFolder,
          icon: LucideIcons.folderPlus,
          onTap: () => _startCreate('directory', parent: node.path),
        ),
        if (widget.onUploadTo != null)
          AppMenuItem(
            label: t.fileTree.uploadHere,
            icon: LucideIcons.upload,
            onTap: () => widget.onUploadTo!(node.path),
          ),
      ],
      AppMenuItem(
        label: t.common.fileTree.context.copyPath,
        icon: LucideIcons.copy,
        dividerBefore: true,
        onTap: () => _copy(node.path),
      ),
      if (rel != null)
        AppMenuItem(
          label: t.fileTree.copyRelativePath,
          icon: LucideIcons.copy,
          onTap: () => _copy(rel),
        ),
      if (!node.isDirectory)
        AppMenuItem(
          label: t.common.buttons.download,
          icon: LucideIcons.download,
          onTap: () => downloadFile(context, ref, projectId: pid, node: node),
        ),
      AppMenuItem(
        label: t.common.fileTree.context.rename,
        icon: LucideIcons.pencil,
        dividerBefore: true,
        onTap: () => _startRename(node),
      ),
      AppMenuItem(
        label: t.common.fileTree.context.delete,
        icon: LucideIcons.trash2,
        destructive: true,
        onTap: () => _delete(node),
      ),
    ];
  }

  List<AppMenuItem> _blankMenu() {
    final t = Translations.of(context);
    return [
      AppMenuItem(
        label: t.common.fileTree.context.newFile,
        icon: LucideIcons.filePlus,
        onTap: () => _startCreate('file', parent: ''),
      ),
      AppMenuItem(
        label: t.common.fileTree.context.newFolder,
        icon: LucideIcons.folderPlus,
        onTap: () => _startCreate('directory', parent: ''),
      ),
      if (widget.onUploadTo != null)
        AppMenuItem(
          label: t.common.fileTree.context.upload,
          icon: LucideIcons.upload,
          onTap: () => widget.onUploadTo!(''),
        ),
      AppMenuItem(
        label: t.common.buttons.refresh,
        icon: LucideIcons.refreshCw,
        dividerBefore: true,
        onTap: _refresh,
      ),
      AppMenuItem(
        label: t.common.fileTree.collapseAll,
        icon: LucideIcons.copyMinus,
        onTap: _ctrl.collapseAll,
      ),
    ];
  }

  // ── build ─────────────────────────────────────────────────────────────

  GitDecorations _decorations(Map<String, dynamic>? status, List<FileTreeNode> roots) {
    if (!identical(status, _decoStatus) || !identical(roots, _decoRoots)) {
      _decoStatus = status;
      _decoRoots = roots;
      final root = explorerProjectRoot(roots);
      _deco = status == null || root == null
          ? GitDecorations.empty
          : GitDecorations.fromStatus(status, explorerRelativePaths(roots, root));
    }
    return _deco;
  }

  List<_Item> _buildItems(List<ExplorerRow> rows) {
    final edit = _edit;
    final items = [for (final r in rows) _Item(row: r, depth: r.depth)];
    if (edit == null || edit.renaming != null) {
      return items;
    }
    if (edit.parentPath.isEmpty) {
      return [_Item(edit: edit, depth: 0), ...items];
    }
    final at = items.indexWhere((it) => it.row!.path == edit.parentPath);
    if (at < 0) {
      return [_Item(edit: edit, depth: 0), ...items];
    }
    return [
      ...items.sublist(0, at + 1),
      _Item(edit: edit, depth: items[at].depth + 1),
      ...items.sublist(at + 1),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final state = ref.watch(fileTreeProvider);
    final recentOnly = ref.watch(fileTreeRecentOnlyProvider);
    final status = state.projectId == null
        ? null
        : ref.watch(gitStatusProvider(state.projectId!)).value;

    ref.listen(fileTreeProvider.select((s) => s.roots), (_, _) {
      if (_pendingReveal != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _tryReveal());
      }
    });

    final query = widget.filter.trim().toLowerCase();
    final base = recentOnly
        ? filterFileTreeByModified(state.roots, DateTime.now().subtract(kFileTreeRecentWindow))
        : state.roots;
    final roots = query.isEmpty ? base : filterFileTree(base, query);
    final expanded = query.isEmpty ? state.expanded : collectExpandedDirectoryPaths(roots);
    final rows = buildExplorerRows(roots, expanded);
    _items = _buildItems(rows);
    final deco = _decorations(status, state.roots);
    final root = explorerProjectRoot(state.roots);
    final compact = context.breakpoint.isCompact;
    final showActions = compact || _hovered || _focus.hasFocus || _editFocus.hasFocus;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            title: widget.title.isEmpty ? t.fileTree.explorer : widget.title,
            collapsed: _collapsed,
            showActions: showActions && state.projectId != null,
            loading: state.loading,
            moreActions: widget.moreActions,
            onToggle: () => setState(() => _collapsed = !_collapsed),
            onNewFile: () => _startCreate('file'),
            onNewFolder: () => _startCreate('directory'),
            onRefresh: _refresh,
            onCollapseAll: _ctrl.collapseAll,
          ),
          if (_editError != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
              color: c.destructive.withValues(alpha: 0.15),
              child: Text(_editError!, style: TextStyle(fontSize: 12, color: c.destructive)),
            ),
          if (!_collapsed) Expanded(child: _body(state, root, deco, expanded, query)),
        ],
      ),
    );
  }

  Widget _body(
    FileTreeState state,
    String? root,
    GitDecorations deco,
    Set<String> expanded,
    String query,
  ) {
    final t = Translations.of(context);
    final c = context.appColors;
    if (state.projectId == null) {
      return _Message(t.chat.shell.selectProject.title);
    }
    if (state.loading && state.roots.isEmpty) {
      return const Center(
        child: SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (state.error != null && state.roots.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.error!, style: TextStyle(color: c.destructive, fontSize: 12)),
            TextButton(onPressed: _refresh, child: Text(t.chat.session.messages.retry)),
          ],
        ),
      );
    }
    final rowHeight = _rowHeight;
    // Rows have their own menu; a held right-click reaches both detectors,
    // so the blank-area menu only answers below the last row.
    bool onRow(Offset local) =>
        _scroll.hasClients && ((local.dy + _scroll.offset) / rowHeight).floor() < _items.length;
    void blankMenu(Offset local, Offset global) {
      if (!onRow(local)) {
        unawaited(AppContextMenu.show(context, global, _blankMenu()));
      }
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _focus.requestFocus,
      onSecondaryTapDown: (d) => blankMenu(d.localPosition, d.globalPosition),
      onLongPressStart: (d) => blankMenu(d.localPosition, d.globalPosition),
      child: Focus(
        focusNode: _focus,
        onKeyEvent: _onKey,
        child: _items.isEmpty
            ? _Message(t.fileTree.noFiles)
            : Scrollbar(
                controller: _scroll,
                child: ListView.builder(
                  controller: _scroll,
                  itemExtent: rowHeight,
                  padding: EdgeInsets.only(bottom: rowHeight * 2),
                  itemCount: _items.length,
                  itemBuilder: (context, i) {
                    final it = _items[i];
                    final row = it.row;
                    if (row == null) {
                      return _RowView(
                        depth: it.depth,
                        rowHeight: rowHeight,
                        indent: _indent,
                        showGuides: _hovered,
                        isDirectory: it.edit!.type == 'directory',
                        expanded: false,
                        iconName: '',
                        editor: _editField(),
                      );
                    }
                    final node = row.node;
                    final rel = root == null ? null : explorerRelativePath(node.path, root);
                    final renaming = _edit?.renaming?.path == node.path;
                    return _RowView(
                      key: ValueKey(node.path),
                      depth: row.depth,
                      rowHeight: rowHeight,
                      indent: _indent,
                      showGuides: _hovered,
                      isDirectory: node.isDirectory,
                      expanded: expanded.contains(node.path),
                      iconName: node.name,
                      label: row.label,
                      highlight: query,
                      italic: node.isSymlink,
                      selected: _selected == node.path,
                      focused: _focus.hasFocus,
                      decoration: rel == null ? null : deco.of(rel, isDirectory: node.isDirectory),
                      details: widget.showDetails && !node.isDirectory
                          ? (formatFileSize(node.size), formatModified(node.modified))
                          : null,
                      editor: renaming ? _editField() : null,
                      onTap: () => _activate(row),
                      onMenu: (pos) {
                        _focus.requestFocus();
                        setState(() => _selected = node.path);
                        unawaited(AppContextMenu.show(context, pos, _rowMenu(node)));
                      },
                    );
                  },
                ),
              ),
      ),
    );
  }

  Widget _editField() {
    final c = context.appColors;
    return CallbackShortcuts(
      bindings: {const SingleActivator(LogicalKeyboardKey.escape): _cancelEdit},
      child: TextField(
        controller: _editText,
        focusNode: _editFocus,
        autofocus: true,
        maxLines: 1,
        style: TextStyle(fontSize: 13, color: c.foreground),
        cursorWidth: 1,
        // Non-null keeps focus on Enter, so an invalid name leaves the box
        // open instead of committing through the blur path.
        onEditingComplete: () {},
        onSubmitted: (_) => _commitEdit(),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
          filled: true,
          fillColor: c.background,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: _editError != null ? c.destructive : c.primary),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: _editError != null ? c.destructive : c.primary),
          ),
        ),
      ),
    );
  }
}

class _Item {
  const _Item({this.row, this.edit, required this.depth});

  final ExplorerRow? row;
  final _InlineEdit? edit;
  final int depth;
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.md),
    child: Text(text, style: TextStyle(fontSize: 12, color: context.appColors.mutedForeground)),
  );
}

/// Collapsible project section header — `▾ PROJECT` with the New File /
/// New Folder / Refresh / Collapse All / … actions VS Code reveals on hover.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.collapsed,
    required this.showActions,
    required this.loading,
    required this.moreActions,
    required this.onToggle,
    required this.onNewFile,
    required this.onNewFolder,
    required this.onRefresh,
    required this.onCollapseAll,
  });

  final String title;
  final bool collapsed;
  final bool showActions;
  final bool loading;
  final List<AppMenuItem> moreActions;
  final VoidCallback onToggle;
  final VoidCallback onNewFile;
  final VoidCallback onNewFolder;
  final VoidCallback onRefresh;
  final VoidCallback onCollapseAll;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Translations.of(context);
    return InkWell(
      onTap: onToggle,
      child: SizedBox(
        height: 26,
        child: Row(
          children: [
            const SizedBox(width: 2),
            Icon(
              collapsed ? LucideIcons.chevronRight : LucideIcons.chevronDown,
              size: 16,
              color: c.foreground,
            ),
            const SizedBox(width: 2),
            Expanded(
              child: Text(
                title.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: c.foreground,
                ),
              ),
            ),
            if (loading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: SizedBox.square(
                  dimension: 12,
                  child: CircularProgressIndicator(strokeWidth: 1.5, color: c.mutedForeground),
                ),
              ),
            if (showActions) ...[
              _HeaderAction(
                icon: LucideIcons.filePlus,
                tooltip: t.common.fileTree.context.newFile,
                onTap: onNewFile,
              ),
              _HeaderAction(
                icon: LucideIcons.folderPlus,
                tooltip: t.common.fileTree.context.newFolder,
                onTap: onNewFolder,
              ),
              _HeaderAction(
                icon: LucideIcons.refreshCw,
                tooltip: t.common.buttons.refresh,
                onTap: onRefresh,
              ),
              _HeaderAction(
                icon: LucideIcons.copyMinus,
                tooltip: t.common.fileTree.collapseAll,
                onTap: onCollapseAll,
              ),
              if (moreActions.isNotEmpty)
                Builder(
                  builder: (ctx) => _HeaderAction(
                    icon: LucideIcons.ellipsis,
                    tooltip: t.fileTree.moreActions,
                    onTap: () {
                      final box = ctx.findRenderObject()! as RenderBox;
                      final pos = box.localToGlobal(Offset(0, box.size.height));
                      unawaited(AppContextMenu.show(ctx, pos, moreActions));
                    },
                  ),
                ),
              const SizedBox(width: 4),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({required this.icon, required this.tooltip, required this.onTap});

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.borderSm,
        child: SizedBox.square(
          dimension: 22,
          child: Icon(icon, size: 15, color: context.appColors.foreground),
        ),
      ),
    );
  }
}

/// VS Code SCM colours (gitDecoration.* defaults for dark / light themes).
Color gitDecorationColor(GitDecoration d, Brightness b) {
  final dark = b == Brightness.dark;
  return switch (d) {
    GitDecoration.modified => dark ? const Color(0xFFE2C08D) : const Color(0xFF895503),
    GitDecoration.added ||
    GitDecoration.untracked => dark ? const Color(0xFF73C991) : const Color(0xFF007100),
    GitDecoration.deleted => dark ? const Color(0xFFC74E39) : const Color(0xFFAD0707),
  };
}

/// One 22px explorer row (or the inline name box in its place).
class _RowView extends StatefulWidget {
  const _RowView({
    super.key,
    required this.depth,
    required this.rowHeight,
    required this.indent,
    required this.showGuides,
    required this.isDirectory,
    required this.expanded,
    required this.iconName,
    this.label = '',
    this.highlight = '',
    this.italic = false,
    this.selected = false,
    this.focused = false,
    this.decoration,
    this.details,
    this.editor,
    this.onTap,
    this.onMenu,
  });

  final int depth;
  final double rowHeight;
  final double indent;
  final bool showGuides;
  final bool isDirectory;
  final bool expanded;
  final String iconName;
  final String label;
  final String highlight;
  final bool italic;
  final bool selected;
  final bool focused;
  final GitDecoration? decoration;
  final (String, String)? details;
  final Widget? editor;
  final VoidCallback? onTap;
  final ValueChanged<Offset>? onMenu;

  @override
  State<_RowView> createState() => _RowViewState();
}

class _RowViewState extends State<_RowView> {
  bool _hover = false;

  static const _leftPad = 8.0;
  static const _twistie = 16.0;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final w = widget;
    final brightness = Theme.of(context).brightness;
    final decoColor = w.decoration == null ? null : gitDecorationColor(w.decoration!, brightness);
    final fg = decoColor ?? c.foreground;

    final Color? bg;
    if (w.selected && w.focused) {
      bg = c.primary.withValues(alpha: 0.22);
    } else if (w.selected) {
      bg = c.foreground.withValues(alpha: 0.10);
    } else if (_hover) {
      bg = c.foreground.withValues(alpha: 0.05);
    } else {
      bg = null;
    }

    final guideWidth = _leftPad + w.depth * w.indent;
    final file = fileIcon(w.iconName);
    final content = Row(
      children: [
        SizedBox(
          width: guideWidth,
          height: w.rowHeight,
          child: w.showGuides && w.depth > 0
              ? CustomPaint(
                  painter: _GuidePainter(
                    depth: w.depth,
                    indent: w.indent,
                    leftPad: _leftPad,
                    color: c.border,
                  ),
                )
              : null,
        ),
        SizedBox(
          width: _twistie,
          child: w.isDirectory
              ? Icon(
                  w.expanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
                  size: 16,
                  color: c.foreground.withValues(alpha: 0.8),
                )
              : null,
        ),
        if (!w.isDirectory) ...[
          Icon(file.icon, size: 15, color: file.color),
          const SizedBox(width: 6),
        ] else
          const SizedBox(width: 2),
        Expanded(
          child:
              w.editor ??
              _Label(
                text: w.label,
                highlight: w.highlight,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.2,
                  color: fg,
                  fontStyle: w.italic ? FontStyle.italic : null,
                  decoration: w.decoration == GitDecoration.deleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
        ),
        if (w.editor == null && w.details != null) ...[
          SizedBox(
            width: 60,
            child: Text(
              w.details!.$1,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 11, color: c.mutedForeground),
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(
              w.details!.$2,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 11, color: c.mutedForeground),
            ),
          ),
        ],
        if (w.editor == null && decoColor != null)
          SizedBox(
            width: 20,
            child: w.isDirectory
                ? Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: decoColor, shape: BoxShape.circle),
                    ),
                  )
                : Text(
                    w.decoration!.letter,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: decoColor),
                  ),
          ),
        const SizedBox(width: 8),
      ],
    );

    if (w.editor != null) {
      return Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: content);
    }
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: w.onTap,
        onSecondaryTapDown: w.onMenu == null ? null : (d) => w.onMenu!(d.globalPosition),
        onLongPressStart: w.onMenu == null ? null : (d) => w.onMenu!(d.globalPosition),
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            border: w.selected && w.focused
                ? Border.all(color: c.primary.withValues(alpha: 0.8))
                : null,
          ),
          child: content,
        ),
      ),
    );
  }
}

/// Row label with the filter match highlighted (VS Code list highlight).
class _Label extends StatelessWidget {
  const _Label({required this.text, required this.highlight, required this.style});

  final String text;
  final String highlight;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final at = highlight.isEmpty ? -1 : text.toLowerCase().indexOf(highlight);
    if (at < 0) {
      return Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, style: style);
    }
    final c = context.appColors;
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: text.substring(0, at)),
          TextSpan(
            text: text.substring(at, at + highlight.length),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              backgroundColor: c.primary.withValues(alpha: 0.25),
            ),
          ),
          TextSpan(text: text.substring(at + highlight.length)),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Thin vertical indent guides, one per ancestor level.
class _GuidePainter extends CustomPainter {
  const _GuidePainter({
    required this.depth,
    required this.indent,
    required this.leftPad,
    required this.color,
  });

  final int depth;
  final double indent;
  final double leftPad;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    for (var i = 0; i < depth; i++) {
      // Under the centre of the ancestor's twistie.
      final x = leftPad + i * indent + 8 - 0.5;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_GuidePainter old) =>
      old.depth != depth || old.indent != indent || old.color != color || old.leftPad != leftPad;
}
