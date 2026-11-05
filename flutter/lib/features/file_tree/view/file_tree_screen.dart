import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/utils/path_utils.dart';
import 'package:ddagent_app/core/widgets/app_context_menu.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/core/widgets/subpage_header.dart';
import 'package:ddagent_app/features/editor/state/editor_controller.dart';
import 'package:ddagent_app/features/file_tree/data/explorer_rows.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/features/file_tree/state/file_tree_controller.dart';
import 'package:ddagent_app/features/file_tree/view/explorer_tree.dart';
import 'package:ddagent_app/features/file_tree/view/file_icons.dart';
import 'package:ddagent_app/features/file_tree/view/file_viewer.dart';
import 'package:ddagent_app/features/file_tree/view/folder_browser.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/projects/view/project_menu_button.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

// file-tree/constants/constants.ts parity.
const _kMaxUploadCount = 20;
const _kMaxUploadBytes = 200 * 1024 * 1024;

/// Files tab laid out like VS Code: a resizable explorer side bar (name
/// filter on type, content search on Enter) next to the editor area that
/// shows the opened file. Compact layouts show only the explorer and open
/// files in dialogs.
class FileTreeScreen extends ConsumerStatefulWidget {
  const FileTreeScreen({super.key, this.projectId, this.projectPath});

  final String? projectId;
  final String? projectPath;

  @override
  ConsumerState<FileTreeScreen> createState() => _FileTreeScreenState();
}

class _FileTreeScreenState extends ConsumerState<FileTreeScreen> {
  final _search = TextEditingController();
  final _scroll = ScrollController();
  FileTreeNode? _openNode;
  bool _searching = false;
  FileSearchResult? _searchResult;
  bool _autoSelected = false;
  bool _dragOver = false;
  bool _scrollRestored = false;

  @override
  void initState() {
    super.initState();
    // Restore the tab context saved in [fileTreeUiProvider] before the first
    // build so leaving/returning to Files keeps the opened pane + filter.
    final ui = ref.read(fileTreeUiProvider);
    _search.text = ui.query;
    if (ui.openPath != null && ui.openProjectId == ref.read(fileTreeProvider).projectId) {
      _openNode = FileTreeNode(
        name: pathBasename(ui.openPath!),
        path: ui.openPath!,
        isDirectory: false,
      );
    }
    _scroll.addListener(_persistScrollOffset);
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureProject());
  }

  void _persistScrollOffset() {
    if (_scroll.hasClients) {
      ref.read(fileTreeUiProvider.notifier).setScrollOffset(_scroll.offset);
    }
  }

  void _ensureProject() {
    final id = widget.projectId;
    if (id != null) {
      ref.read(fileTreeProvider.notifier).selectProject(id);
    } else {
      // Deep-link without projectId: default to the first project once known.
      final first = ref.read(projectsProvider).projects.firstOrNull?.projectId;
      if (first != null) {
        _autoSelected = true;
        ref.read(fileTreeProvider.notifier).selectProject(first);
      }
    }
  }

  /// Jumps the tree back to the offset saved before the tab was left, once
  /// the list has rows to scroll.
  void _scheduleScrollRestore() {
    final target = ref.read(fileTreeUiProvider).scrollOffset;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _scrollRestored || !_scroll.hasClients) {
        return;
      }
      _scrollRestored = true;
      if (target > 0) {
        _scroll.jumpTo(target.clamp(0.0, _scroll.position.maxScrollExtent));
      }
    });
  }

  @override
  void dispose() {
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  String get _projectId => ref.read(fileTreeProvider).projectId ?? '';

  void _open(FileTreeNode node) {
    if (context.breakpoint.isCompact) {
      // A phone opens the full-screen editor (tabs, explorer slide-over) the
      // way VS Code goes from the explorer to the file; Back returns here.
      unawaited(
        context.push(
          Uri(
            path: '/editor',
            queryParameters: {'projectId': _projectId, 'file': node.path},
          ).toString(),
        ),
      );
    } else if (isImageFile(node.name)) {
      openFileNode(context, projectId: _projectId, node: node, asDialog: true);
    } else {
      setState(() => _openNode = node);
      ref.read(fileTreeUiProvider.notifier).openFile(_projectId, node.path);
    }
  }

  void _closeFile() {
    setState(() => _openNode = null);
    ref.read(fileTreeUiProvider.notifier).closeFile();
  }

  /// Reveal a content-search hit: expand ancestors, open the file.
  void _openMatch(FileSearchMatch match) {
    final node = FileTreeNode(name: pathBasename(match.path), path: match.path, isDirectory: false);
    ref.read(fileTreeProvider.notifier).expandDirectories(explorerAncestors(match.path));
    _open(node);
  }

  void _onFilterChanged(String q) {
    ref.read(fileTreeUiProvider.notifier).setQuery(q);
    // Typing filters names; content results belong to the last Enter.
    setState(() => _searchResult = null);
  }

  void _clearFilter() {
    _search.clear();
    ref.read(fileTreeUiProvider.notifier).setQuery('');
    setState(() {
      _searchResult = null;
      _searching = false;
    });
  }

  Future<void> _runSearch(String query) async {
    final q = query.trim();
    if (q.isEmpty) {
      setState(() {
        _searchResult = null;
        _searching = false;
      });
      return;
    }
    setState(() => _searching = true);
    try {
      final res = await ref.read(fileTreeRepositoryProvider).search(_projectId, q, limit: 100);
      if (mounted) {
        setState(() {
          _searchResult = res;
          _searching = false;
        });
      }
    } on AppError catch (e) {
      if (mounted) {
        setState(() => _searching = false);
        AppToast.show(context, e.message, isError: true);
      }
    }
  }

  Future<void> _pickUploadTarget() async {
    final dirPath = await _pickDirectoryDialog();
    if (dirPath == null) {
      return;
    }
    await _upload(dirPath);
  }

  /// Choose a target directory among the loaded tree nodes.
  Future<String?> _pickDirectoryDialog() {
    final t = Translations.of(context);
    final dirs = <String>{''};
    void walk(List<FileTreeNode> nodes) {
      for (final n in nodes) {
        if (n.isDirectory) {
          dirs.add(n.path);
          walk(n.children);
        }
      }
    }

    walk(ref.read(fileTreeProvider).roots);
    return AppDialog.show<String>(
      context,
      title: t.fileTree.uploadTo,
      content: SizedBox(
        width: 420,
        height: 320,
        child: ListView(
          children: [
            for (final d in dirs)
              ListTile(
                dense: true,
                leading: const Icon(LucideIcons.folder, size: 18),
                title: Text(d.isEmpty ? t.fileTree.projectRoot : d),
                onTap: () => AppDialog.pop(context, d),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _upload(String targetPath) async {
    final picked = await FilePicker.pickFiles();
    if (picked.isEmpty || !mounted) {
      return;
    }
    final files = <({String name, List<int> bytes})>[];
    for (final f in picked) {
      final bytes = await f.xFile.readAsBytes();
      files.add((name: f.name, bytes: bytes));
    }
    if (!mounted) {
      return;
    }
    await _sendUpload(targetPath, files);
  }

  /// OS drag-drop onto the explorer (web useFileTreeUpload parity — count/
  /// size guards match MAX_FILE_UPLOAD_COUNT/SIZE). Drops always land at the
  /// project root; folder targeting stays on the picker flow.
  Future<void> _onDroppedFiles(List<XFile> dropped) async {
    if (dropped.isEmpty) {
      return;
    }
    final t = Translations.of(context);
    if (dropped.length > _kMaxUploadCount) {
      AppToast.show(context, t.fileTree.uploadLimitCount(count: _kMaxUploadCount), isError: true);
      return;
    }
    final files = <({String name, List<int> bytes})>[];
    for (final f in dropped) {
      if (await f.length() > _kMaxUploadBytes) {
        if (mounted) {
          AppToast.show(context, t.fileTree.fileTooLarge(name: f.name), isError: true);
        }
        return;
      }
      files.add((name: f.name, bytes: await f.readAsBytes()));
    }
    if (!mounted) {
      return;
    }
    await _sendUpload('', files);
  }

  Future<void> _sendUpload(String targetPath, List<({String name, List<int> bytes})> files) async {
    final t = Translations.of(context);
    final err = await ref.read(fileTreeProvider.notifier).uploadFiles(targetPath, files);
    if (!mounted) {
      return;
    }
    AppToast.show(
      context,
      err ?? t.fileTree.uploadedCount(count: files.length),
      isError: err != null,
    );
  }

  Future<void> _browsePath() async {
    final t = Translations.of(context);
    final picked = await FolderBrowserDialog.pick(context);
    if (picked == null || !mounted) {
      return;
    }
    // Cross-workspace: a picked path selects the matching registered project.
    final projects = ref.read(projectsProvider).projects;
    for (final p in projects) {
      if (p.path == picked || p.fullPath == picked) {
        ref.read(fileTreeProvider.notifier).selectProject(p.projectId);
        return;
      }
    }
    AppToast.show(context, t.fileTree.notRegisteredProject(path: picked), isError: true);
  }

  List<AppMenuItem> _moreActions({
    required FileTreeViewMode viewMode,
    required bool recentOnly,
    required bool respectGitignore,
  }) {
    final t = Translations.of(context);
    return [
      AppMenuItem(
        label: t.common.fileTree.context.upload,
        icon: LucideIcons.upload,
        onTap: _pickUploadTarget,
      ),
      AppMenuItem(
        label: t.fileTree.showDetails,
        checked: viewMode == FileTreeViewMode.detailed,
        dividerBefore: true,
        onTap: () => ref
            .read(fileTreeViewModeProvider.notifier)
            .set(
              viewMode == FileTreeViewMode.detailed
                  ? FileTreeViewMode.compact
                  : FileTreeViewMode.detailed,
            ),
      ),
      AppMenuItem(
        label: t.common.fileTree.showRecentOnly,
        checked: recentOnly,
        onTap: () => ref.read(fileTreeRecentOnlyProvider.notifier).toggle(),
      ),
      AppMenuItem(
        label: t.fileTree.showGitignoredFiles,
        checked: !respectGitignore,
        onTap: () {
          ref.read(fileTreeRespectGitignoreProvider.notifier).toggle();
          unawaited(ref.read(fileTreeProvider.notifier).refresh());
        },
      ),
      AppMenuItem(
        label: t.fileTree.browseServerFilesystem,
        icon: LucideIcons.folderOpen,
        dividerBefore: true,
        onTap: _browsePath,
      ),
    ];
  }

  void _onEntryRenamed(String oldPath, String newPath) {
    // Editor tabs (kept across tabs of the app) follow the file too.
    ref.read(editorProvider.notifier).retarget(_projectId, oldPath, newPath);
    final open = _openNode?.path;
    if (open != null && (open == oldPath || open.startsWith('$oldPath${_sep(oldPath)}'))) {
      final moved = newPath + open.substring(oldPath.length);
      _open(FileTreeNode(name: pathBasename(moved), path: moved, isDirectory: false));
    }
  }

  void _onEntryDeleted(String path) {
    final open = _openNode?.path;
    if (open != null && (open == path || open.startsWith('$path${_sep(path)}'))) {
      _closeFile();
    }
  }

  static String _sep(String path) => path.contains('/') ? '/' : r'\';

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fileTreeProvider);
    final viewMode = ref.watch(fileTreeViewModeProvider);
    final recentOnly = ref.watch(fileTreeRecentOnlyProvider);
    final respectGitignore = ref.watch(fileTreeRespectGitignoreProvider);
    final projects = ref.watch(projectsProvider).projects;
    final compact = context.breakpoint.isCompact;
    final t = Translations.of(context);

    // Late auto-select when the projects list arrives after first frame.
    if (!_autoSelected &&
        widget.projectId == null &&
        state.projectId == null &&
        projects.isNotEmpty) {
      _autoSelected = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(fileTreeProvider.notifier).selectProject(projects.first.projectId);
      });
    }

    if (!_scrollRestored && _search.text.isEmpty && !state.loading && state.roots.isNotEmpty) {
      _scheduleScrollRestore();
    }

    final sidebarWidth = ref.watch(fileTreeSidebarWidthProvider);
    final project = projects.where((p) => p.projectId == state.projectId).firstOrNull;
    final showingSearch = _searchResult != null || _searching;

    final sidebar = DropTarget(
      onDragEntered: (_) => setState(() => _dragOver = true),
      onDragExited: (_) => setState(() => _dragOver = false),
      onDragDone: (details) {
        setState(() => _dragOver = false);
        unawaited(_onDroppedFiles(details.files));
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FilterBar(
                  controller: _search,
                  searching: _searching,
                  onChanged: _onFilterChanged,
                  onSubmitted: _runSearch,
                  onClear: _clearFilter,
                ),
                Expanded(
                  child: showingSearch
                      ? _SearchResults(
                          result: _searchResult,
                          searching: _searching,
                          root: explorerProjectRoot(state.roots),
                          onTap: _openMatch,
                          onClose: () => setState(() => _searchResult = null),
                        )
                      : ExplorerTree(
                          title: project?.displayName ?? '',
                          filter: _search.text,
                          scrollController: _scroll,
                          activePath: _openNode?.path,
                          showDetails: viewMode == FileTreeViewMode.detailed,
                          onOpenFile: _open,
                          onUploadTo: _upload,
                          onEntryRenamed: _onEntryRenamed,
                          onEntryDeleted: _onEntryDeleted,
                          moreActions: _moreActions(
                            viewMode: viewMode,
                            recentOnly: recentOnly,
                            respectGitignore: respectGitignore,
                          ),
                        ),
                ),
              ],
            ),
          ),
          if (_dragOver) const _DropOverlay(),
        ],
      ),
    );

    return Column(
      children: [
        SubpageHeader(
          icon: LucideIcons.folder,
          title: t.common.tabs.files,
          trailing: [
            _IconBtn(
              tooltip: t.fileTree.browseServerFilesystem,
              icon: LucideIcons.folderOpen,
              onTap: _browsePath,
            ),
          ],
          children: [
            if (projects.isNotEmpty)
              ProjectMenuButton(
                projects: projects,
                selected: project,
                onSelected: (p) => ref.read(fileTreeProvider.notifier).selectProject(p.projectId),
              ),
          ],
        ),
        Expanded(
          child: compact
              ? sidebar
              : LayoutBuilder(
                  builder: (context, box) {
                    final max = (box.maxWidth - 240).clamp(kMinFileTreeSidebarWidth, 900.0);
                    final width = sidebarWidth.clamp(kMinFileTreeSidebarWidth, max);
                    return Row(
                      children: [
                        SizedBox(width: width, child: sidebar),
                        _Sash(
                          onDrag: (dx) => ref
                              .read(fileTreeSidebarWidthProvider.notifier)
                              .set((width + dx).clamp(kMinFileTreeSidebarWidth, max)),
                          onDragEnd: () => ref
                              .read(fileTreeSidebarWidthProvider.notifier)
                              .set(width, persist: true),
                        ),
                        Expanded(
                          child: _openNode == null
                              ? const _EmptyEditor()
                              : Padding(
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  child: FileViewerPane(
                                    key: ValueKey(_openNode!.path),
                                    projectId: _projectId,
                                    node: _openNode!,
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// The drag handle between the side bar and the editor area (VS Code sash):
/// a 1px border that turns into a highlighted 4px bar on hover/drag.
class _Sash extends StatefulWidget {
  const _Sash({required this.onDrag, required this.onDragEnd});

  final ValueChanged<double> onDrag;
  final VoidCallback onDragEnd;

  @override
  State<_Sash> createState() => _SashState();
}

class _SashState extends State<_Sash> {
  bool _hover = false;
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final lit = _hover || _dragging;
    return MouseRegion(
      cursor: SystemMouseCursors.resizeColumn,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (_) => setState(() => _dragging = true),
        onHorizontalDragUpdate: (d) => widget.onDrag(d.delta.dx),
        onHorizontalDragEnd: (_) {
          setState(() => _dragging = false);
          widget.onDragEnd();
        },
        child: SizedBox(
          width: 5,
          child: Center(
            child: AnimatedContainer(
              duration: AppMotion.hover,
              width: lit ? 4 : 1,
              color: lit ? c.primary : c.border,
            ),
          ),
        ),
      ),
    );
  }
}

/// Editor area placeholder while no file is open.
class _EmptyEditor extends StatelessWidget {
  const _EmptyEditor();

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Translations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.files, size: 72, color: c.mutedForeground.withValues(alpha: 0.25)),
          const SizedBox(height: AppSpacing.md),
          Text(t.fileTree.noFileOpen, style: TextStyle(fontSize: 13, color: c.mutedForeground)),
        ],
      ),
    );
  }
}

/// Slim filter box on top of the explorer: typing filters names, Enter runs
/// a content search.
class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.controller,
    required this.searching,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final bool searching;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final i18n = Translations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, 4),
      child: SizedBox(
        height: 28,
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) => TextField(
            controller: controller,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              isDense: true,
              hintText: i18n.fileTree.search.hint,
              hintStyle: TextStyle(color: c.mutedForeground, fontSize: 12),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 6),
                child: searching
                    ? Padding(
                        padding: const EdgeInsets.all(8),
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: c.mutedForeground,
                        ),
                      )
                    : Icon(LucideIcons.search, size: 13, color: c.mutedForeground),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              suffixIcon: value.text.isEmpty
                  ? null
                  : InkWell(
                      onTap: onClear,
                      child: Icon(LucideIcons.x, size: 13, color: c.mutedForeground),
                    ),
              suffixIconConstraints: const BoxConstraints(minWidth: 26, minHeight: 26),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }
}

/// Translucent "Drop files to upload" veil shown while a drag hovers the
/// explorer (web `isDragOver` overlay parity).
class _DropOverlay extends StatelessWidget {
  const _DropOverlay();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final t = Translations.of(context);
    return Positioned.fill(
      child: IgnorePointer(
        child: ColoredBox(
          color: colors.primary.withValues(alpha: 0.12),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.primary, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.upload, size: 18, color: colors.primary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      t.common.fileTree.dropToUpload,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: colors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 28×28 ghost icon button for the page header.
class _IconBtn extends StatelessWidget {
  const _IconBtn({required this.icon, required this.tooltip, this.onTap});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.borderMd,
        child: SizedBox.square(dimension: 28, child: Icon(icon, size: 14, color: c.foreground)),
      ),
    );
  }
}

/// Content-search results grouped per file like VS Code's Search view:
/// a file header (icon, name, folder, hit count) over its matching lines.
class _SearchResults extends StatelessWidget {
  const _SearchResults({
    required this.result,
    required this.searching,
    required this.root,
    required this.onTap,
    required this.onClose,
  });

  final FileSearchResult? result;
  final bool searching;
  final String? root;
  final ValueChanged<FileSearchMatch> onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    if (result == null) {
      return Center(
        child: searching
            ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
            : Text(t.fileTree.search.prompt),
      );
    }
    final groups = <String, List<FileSearchMatch>>{};
    for (final m in result!.matches) {
      groups.putIfAbsent(m.path, () => []).add(m);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: onClose,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
            child: Row(
              children: [
                Icon(LucideIcons.arrowLeft, size: 14, color: c.mutedForeground),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    t.fileTree.closeSearch,
                    style: TextStyle(fontSize: 12, color: c.mutedForeground),
                  ),
                ),
                if (result!.truncated)
                  Text(
                    t.fileTree.search.resultsTruncated,
                    style: TextStyle(fontSize: 11, color: c.mutedForeground),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: groups.isEmpty
              ? Center(child: Text(t.fileTree.search.noMatches))
              : ListView(
                  children: [
                    for (final MapEntry(key: path, value: matches) in groups.entries) ...[
                      _SearchFileRow(path: path, root: root, count: matches.length),
                      for (final m in matches) _SearchLineRow(match: m, onTap: () => onTap(m)),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _SearchFileRow extends StatelessWidget {
  const _SearchFileRow({required this.path, required this.root, required this.count});

  final String path;
  final String? root;
  final int count;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final icon = fileIcon(path);
    final rel = root == null ? null : explorerRelativePath(path, root!);
    final dir = pathDirname(rel ?? path);
    return SizedBox(
      height: 22,
      child: Row(
        children: [
          const SizedBox(width: AppSpacing.sm),
          Icon(icon.icon, size: 15, color: icon.color),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              pathBasename(path),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: c.foreground),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              dir,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: c.mutedForeground),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(color: c.muted, borderRadius: BorderRadius.circular(9)),
            child: Text('$count', style: TextStyle(fontSize: 11, color: c.foreground)),
          ),
        ],
      ),
    );
  }
}

class _SearchLineRow extends StatelessWidget {
  const _SearchLineRow({required this.match, required this.onTap});

  final FileSearchMatch match;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 22,
        child: Row(
          children: [
            const SizedBox(width: 30),
            Expanded(
              child: Text(
                match.text.trim(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: c.foreground),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Text(
                '${match.line}',
                style: TextStyle(fontSize: 11, color: c.mutedForeground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
