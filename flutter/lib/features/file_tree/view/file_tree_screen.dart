import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_context_menu.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/core/widgets/subpage_header.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/features/file_tree/state/file_tree_controller.dart';
import 'package:ddagent_app/features/file_tree/view/file_viewer.dart';
import 'package:ddagent_app/features/file_tree/view/folder_browser.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/projects/view/project_menu_button.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Extension → icon subset of fileIcons.ts (the 200+ Lucide map collapses to
/// ~25 Material equivalents + a generic fallback).
({IconData icon, Color color}) fileIcon(String name) {
  final dot = name.lastIndexOf('.');
  final ext = dot < 0 ? '' : name.substring(dot + 1).toLowerCase();
  const amber = Colors.amber;
  const blue = Colors.blue;
  const green = Colors.green;
  const orange = Colors.deepOrange;
  const grey = Colors.blueGrey;
  return switch (ext) {
    'dart' => (icon: Icons.code, color: blue),
    'js' || 'jsx' || 'mjs' || 'cjs' => (icon: Icons.javascript, color: amber),
    'ts' || 'tsx' || 'mts' => (icon: Icons.code, color: blue),
    'py' || 'pyw' || 'ipynb' => (icon: Icons.code, color: green),
    'rs' || 'go' || 'c' || 'cpp' || 'h' => (icon: Icons.settings_suggest, color: orange),
    'rb' || 'java' || 'kt' || 'swift' || 'php' => (icon: Icons.code, color: orange),
    'json' || 'yaml' || 'yml' || 'toml' || 'xml' => (icon: Icons.data_object, color: grey),
    'md' || 'txt' || 'rtf' => (icon: Icons.description_outlined, color: grey),
    'html' || 'css' || 'scss' => (icon: Icons.language, color: blue),
    'sh' || 'bash' || 'zsh' || 'ps1' => (icon: Icons.terminal, color: green),
    'png' ||
    'jpg' ||
    'jpeg' ||
    'gif' ||
    'svg' ||
    'webp' ||
    'ico' ||
    'bmp' => (icon: Icons.image_outlined, color: Colors.purple),
    'zip' || 'tar' || 'gz' || '7z' || 'rar' => (icon: Icons.archive_outlined, color: amber),
    'pdf' => (icon: Icons.picture_as_pdf_outlined, color: Colors.red),
    'mp3' || 'wav' || 'ogg' || 'flac' => (icon: Icons.music_note_outlined, color: Colors.pink),
    'mp4' || 'mov' || 'mkv' || 'webm' => (icon: Icons.videocam_outlined, color: Colors.red),
    'sql' || 'db' || 'sqlite' => (icon: Icons.storage_outlined, color: blue),
    'env' || 'lock' || 'pem' || 'key' => (icon: Icons.lock_outline, color: grey),
    _ => (icon: Icons.insert_drive_file_outlined, color: grey),
  };
}

String _basename(String path) {
  final trimmed = path.endsWith('/') ? path.substring(0, path.length - 1) : path;
  final i = trimmed.lastIndexOf('/');
  return i < 0 ? trimmed : trimmed.substring(i + 1);
}

String _dirname(String path) {
  final i = path.lastIndexOf('/');
  return i <= 0 ? '/' : path.substring(0, i);
}

// file-tree/constants/constants.ts parity.
const _kMaxUploadCount = 20;
const _kMaxUploadBytes = 200 * 1024 * 1024;

/// T20 Files screen — tree + viewer parity with
/// src/components/file-tree/view/FilesPage.tsx.
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
    // build so leaving/returning to Files keeps the opened pane + query.
    final ui = ref.read(fileTreeUiProvider);
    _search.text = ui.query;
    if (ui.openPath != null && ui.openProjectId == ref.read(fileTreeProvider).projectId) {
      _openNode = FileTreeNode(
        name: _basename(ui.openPath!),
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
    _restoreSearch();
  }

  /// Re-runs a content search left open in the tab — the query survived in
  /// [fileTreeUiProvider] but the async results did not.
  void _restoreSearch() {
    final query = ref.read(fileTreeUiProvider).query;
    if (query.trim().isEmpty || ref.read(fileTreeProvider).projectId == null) {
      return;
    }
    unawaited(_runSearch(query));
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
    final compact = context.breakpoint.isCompact;
    // Images + compact layout open as dialogs; wide layout uses the side pane.
    if (compact || isImageFile(node.name)) {
      openFileNode(context, projectId: _projectId, node: node, asDialog: true);
    } else {
      setState(() => _openNode = node);
      ref.read(fileTreeUiProvider.notifier).openFile(_projectId, node.path);
    }
  }

  /// Reveal a content-search hit: expand ancestors, open the file.
  void _openMatch(FileSearchMatch match) {
    final node = FileTreeNode(name: _basename(match.path), path: match.path, isDirectory: false);
    final ancestors = <String>[];
    var dir = _dirname(match.path);
    while (dir.isNotEmpty && dir != '/') {
      ancestors.add(dir);
      dir = _dirname(dir);
    }
    ref.read(fileTreeProvider.notifier).expandDirectories(ancestors);
    _open(node);
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
                leading: const Icon(Icons.folder_outlined, size: 18),
                title: Text(d.isEmpty ? '(project root)' : d),
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

  /// OS drag-drop onto the tree (web useFileTreeUpload parity — count/size
  /// guards match MAX_FILE_UPLOAD_COUNT/SIZE). Drops always land at the
  /// project root; folder targeting stays on the picker flow.
  Future<void> _onDroppedFiles(List<XFile> dropped) async {
    if (dropped.isEmpty) {
      return;
    }
    if (dropped.length > _kMaxUploadCount) {
      AppToast.show(
        context,
        'You can upload up to $_kMaxUploadCount files at once.',
        isError: true,
      );
      return;
    }
    final files = <({String name, List<int> bytes})>[];
    for (final f in dropped) {
      if (await f.length() > _kMaxUploadBytes) {
        if (mounted) {
          AppToast.show(context, '${f.name} is larger than 200MB.', isError: true);
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

  Future<void> _createEntry(FileTreeNode? parent, String type) async {
    final t = Translations.of(context);
    final nameController = TextEditingController();
    final name = await AppDialog.show<String>(
      context,
      title: type == 'directory' ? 'New folder' : 'New file',
      content: AppInput(controller: nameController, hint: 'Name', autofocus: true),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => AppDialog.pop(context),
          child: Text(t.chat.orchestrator.summary.cancelTasks),
        ),
        AppButton(
          onPressed: () => AppDialog.pop(context, nameController.text.trim()),
          child: Text(t.common.buttons.create),
        ),
      ],
    );
    if (name == null || name.isEmpty || !mounted) {
      return;
    }
    final err = await ref
        .read(fileTreeProvider.notifier)
        .createEntry(parentPath: parent?.path ?? '', type: type, name: name);
    if (err != null && mounted) {
      AppToast.show(context, err, isError: true);
    }
  }

  Future<void> _rename(FileTreeNode node) async {
    final t = Translations.of(context);
    final nameController = TextEditingController(text: node.name);
    final name = await AppDialog.show<String>(
      context,
      title: t.fileTree.titles.rename(name: node.name),
      content: AppInput(controller: nameController, hint: t.fileTree.newName, autofocus: true),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => AppDialog.pop(context),
          child: Text(t.chat.orchestrator.summary.cancelTasks),
        ),
        AppButton(
          onPressed: () => AppDialog.pop(context, nameController.text.trim()),
          child: Text(t.common.fileOperations.rename),
        ),
      ],
    );
    if (name == null || name.isEmpty || name == node.name || !mounted) {
      return;
    }
    final err = await ref
        .read(fileTreeProvider.notifier)
        .renameEntry(oldPath: node.path, newName: name);
    if (!mounted) {
      return;
    }
    if (err != null) {
      AppToast.show(context, err, isError: true);
    } else if (_openNode?.path == node.path) {
      setState(() => _openNode = null);
      ref.read(fileTreeUiProvider.notifier).closeFile();
    }
  }

  Future<void> _delete(FileTreeNode node) async {
    final t = Translations.of(context);
    final ok = await AppDialog.confirm(
      context,
      title: t.fileTree.titles.delete(name: node.name),
      message:
          'Delete ${node.isDirectory ? 'folder' : 'file'} "${node.path}"? '
          'This cannot be undone.',
      confirmLabel: 'Delete',
    );
    if (!ok || !mounted) {
      return;
    }
    final err = await ref
        .read(fileTreeProvider.notifier)
        .deleteEntry(path: node.path, type: node.isDirectory ? 'directory' : 'file');
    if (!mounted) {
      return;
    }
    if (err != null) {
      AppToast.show(context, err, isError: true);
    } else if (_openNode != null && _openNode!.path.startsWith(node.path)) {
      setState(() => _openNode = null);
      ref.read(fileTreeUiProvider.notifier).closeFile();
    }
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

  List<AppMenuItem> _menuItems(FileTreeNode node) {
    final t = Translations.of(context);
    return [
      if (!node.isDirectory) ...[
        AppMenuItem(
          label: t.common.gitPanel.worktrees.open,
          icon: Icons.open_in_new,
          onTap: () => _open(node),
        ),
        AppMenuItem(
          label: t.common.fileOperations.openInEditor,
          icon: Icons.edit_note,
          onTap: () => context.go(
            '/editor?projectId=$_projectId'
            '&file=${Uri.encodeQueryComponent(node.path)}',
          ),
        ),
      ],
      if (node.isDirectory) ...[
        AppMenuItem(
          label: t.chat.fileOperations.newFile,
          icon: Icons.note_add_outlined,
          onTap: () => _createEntry(node, 'file'),
        ),
        AppMenuItem(
          label: t.common.fileOperations.newFolder,
          icon: Icons.create_new_folder_outlined,
          onTap: () => _createEntry(node, 'directory'),
        ),
        AppMenuItem(
          label: t.fileTree.uploadHere,
          icon: Icons.upload_outlined,
          onTap: () => _upload(node.path),
        ),
      ],
      AppMenuItem(
        label: t.common.fileOperations.copyPath,
        icon: Icons.copy_outlined,
        onTap: () {
          Clipboard.setData(ClipboardData(text: node.path));
          AppToast.show(context, t.common.fileTree.toast.pathCopied);
        },
      ),
      if (!node.isDirectory)
        AppMenuItem(
          label: t.common.buttons.download,
          icon: Icons.download_outlined,
          onTap: () => downloadFile(context, ref, projectId: _projectId, node: node),
        ),
      AppMenuItem(
        label: t.common.fileOperations.rename,
        icon: Icons.edit_outlined,
        onTap: () => _rename(node),
      ),
      AppMenuItem(
        label: t.common.buttons.delete,
        icon: Icons.delete_outline,
        destructive: true,
        onTap: () => _delete(node),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fileTreeProvider);
    final viewMode = ref.watch(fileTreeViewModeProvider);
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
        _restoreSearch();
      });
    }

    final recentOnly = ref.watch(fileTreeRecentOnlyProvider);
    final respectGitignore = ref.watch(fileTreeRespectGitignoreProvider);
    final base = recentOnly
        ? filterFileTreeByModified(state.roots, DateTime.now().subtract(kFileTreeRecentWindow))
        : state.roots;
    final roots = _search.text.isEmpty ? base : filterFileTree(base, _search.text.toLowerCase());
    final visible = flattenVisible(
      roots,
      _search.text.isEmpty ? state.expanded : collectExpandedDirectoryPaths(roots),
    );

    if (!_scrollRestored && _search.text.isEmpty && !state.loading && visible.isNotEmpty) {
      _scheduleScrollRestore();
    }

    final tree = _buildTree(state, viewMode, visible);

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
                selected: projects.where((p) => p.projectId == state.projectId).firstOrNull,
                onSelected: (p) => ref.read(fileTreeProvider.notifier).selectProject(p.projectId),
              ),
          ],
        ),
        _TreeToolbar(
          search: _search,
          searching: _searching,
          projectId: state.projectId,
          viewMode: viewMode,
          uploading: state.uploading,
          loading: state.loading,
          onRefresh: () => ref.read(fileTreeProvider.notifier).refresh(),
          onUpload: _pickUploadTarget,
          onNewFile: () => _createEntry(null, 'file'),
          onNewFolder: () => _createEntry(null, 'directory'),
          onCollapseAll: () => ref.read(fileTreeProvider.notifier).collapseAll(),
          onSearchChanged: (q) {
            setState(() {});
            ref.read(fileTreeUiProvider.notifier).setQuery(q);
            if (q.trim().isNotEmpty) {
              _runSearch(q);
            } else {
              setState(() => _searchResult = null);
            }
          },
          onSearchSubmitted: _runSearch,
          onCloseSearch: () {
            _search.clear();
            ref.read(fileTreeUiProvider.notifier).setQuery('');
            setState(() => _searchResult = null);
          },
          onViewMode: (m) => ref.read(fileTreeViewModeProvider.notifier).set(m),
          recentOnly: recentOnly,
          onToggleRecentOnly: () => ref.read(fileTreeRecentOnlyProvider.notifier).toggle(),
          respectGitignore: respectGitignore,
          onToggleRespectGitignore: () {
            ref.read(fileTreeRespectGitignoreProvider.notifier).toggle();
            unawaited(ref.read(fileTreeProvider.notifier).refresh());
          },
        ),
        Expanded(
          child: DropTarget(
            onDragEntered: (_) => setState(() => _dragOver = true),
            onDragExited: (_) => setState(() => _dragOver = false),
            onDragDone: (details) {
              setState(() => _dragOver = false);
              unawaited(_onDroppedFiles(details.files));
            },
            child: Stack(
              children: [
                Positioned.fill(
                  child: _searchResult != null || _searching
                      ? _SearchResults(
                          result: _searchResult,
                          searching: _searching,
                          onTap: _openMatch,
                        )
                      : compact || _openNode == null
                      ? tree
                      : Row(
                          children: [
                            Expanded(flex: 2, child: tree),
                            const VerticalDivider(width: 1),
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(AppSpacing.md),
                                child: FileViewerPane(
                                  key: ValueKey(_openNode!.path),
                                  projectId: _projectId,
                                  node: _openNode!,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                if (_dragOver) const _DropOverlay(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTree(FileTreeState state, FileTreeViewMode viewMode, List<FlatNode> visible) {
    final t = Translations.of(context);
    if (state.projectId == null) {
      return Center(child: Text(t.chat.shell.selectProject.title));
    }
    if (state.loading && state.roots.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.roots.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(state.error!, style: TextStyle(color: context.appColors.destructive)),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              variant: AppButtonVariant.ghost,
              onPressed: () => ref.read(fileTreeProvider.notifier).refresh(),
              child: Text(t.chat.session.messages.retry),
            ),
          ],
        ),
      );
    }
    if (visible.isEmpty) {
      return Center(child: Text(t.fileTree.noFiles));
    }
    return ListView.builder(
      controller: _scroll,
      itemCount: visible.length,
      itemBuilder: (context, i) {
        final flat = visible[i];
        return _NodeRow(
          flat: flat,
          viewMode: viewMode,
          expanded: state.expanded.contains(flat.node.path),
          selected: _openNode?.path == flat.node.path,
          menuItems: _menuItems(flat.node),
          onTap: () {
            if (flat.node.isDirectory) {
              ref.read(fileTreeProvider.notifier).toggleDirectory(flat.node.path);
            } else {
              _open(flat.node);
            }
          },
        );
      },
    );
  }
}

/// Translucent "Drop files to upload" veil shown while a drag hovers the
/// tree (web `isDragOver` overlay parity).
class _DropOverlay extends StatelessWidget {
  const _DropOverlay();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
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
                  Text(
                    'Drop files to upload',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.primary,
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

/// 28×28 ghost icon button — `h-7 w-7 p-0` from the old FileTreeHeader.
class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.tooltip,
    this.onTap,
    this.active = false,
    this.busy = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final bool active;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.borderMd,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: active ? c.primary : null,
            borderRadius: AppRadii.borderMd,
          ),
          child: Center(
            child: busy
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: c.mutedForeground),
                  )
                : Icon(icon, size: 14, color: active ? c.primaryForeground : c.foreground),
          ),
        ),
      ),
    );
  }
}

/// FileTree toolbar — parity with FileTreeHeader.tsx:
/// `border-b px-3 pb-2 pt-3` → title row (Files + action buttons + view modes)
/// then the search bar (h-8, search icon left, clear X right).
class _TreeToolbar extends StatelessWidget {
  const _TreeToolbar({
    required this.search,
    required this.searching,
    required this.projectId,
    required this.viewMode,
    required this.uploading,
    required this.loading,
    required this.onRefresh,
    required this.onUpload,
    required this.onNewFile,
    required this.onNewFolder,
    required this.onCollapseAll,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onCloseSearch,
    required this.onViewMode,
    required this.recentOnly,
    required this.onToggleRecentOnly,
    required this.respectGitignore,
    required this.onToggleRespectGitignore,
  });

  final TextEditingController search;
  final bool searching;
  final String? projectId;
  final FileTreeViewMode viewMode;
  final bool uploading;
  final bool loading;
  final VoidCallback onRefresh;
  final VoidCallback onUpload;
  final VoidCallback onNewFile;
  final VoidCallback onNewFolder;
  final VoidCallback onCollapseAll;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onCloseSearch;
  final ValueChanged<FileTreeViewMode> onViewMode;
  final bool recentOnly;
  final VoidCallback onToggleRecentOnly;
  final bool respectGitignore;
  final VoidCallback onToggleRespectGitignore;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final canEdit = projectId != null;
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border)),
      ),
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: AppSpacing.sm,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                i18n.common.tabs.files,
                style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              _IconBtn(
                tooltip: i18n.common.fileTree.context.upload,
                icon: LucideIcons.upload,
                busy: uploading,
                onTap: canEdit && !uploading ? onUpload : null,
              ),
              _IconBtn(
                tooltip: i18n.chat.fileOperations.newFile,
                icon: LucideIcons.fileText,
                onTap: canEdit ? onNewFile : null,
              ),
              _IconBtn(
                tooltip: i18n.common.fileOperations.newFolder,
                icon: LucideIcons.folderPlus,
                onTap: canEdit ? onNewFolder : null,
              ),
              _IconBtn(
                tooltip: i18n.common.buttons.refresh,
                icon: LucideIcons.refreshCw,
                busy: loading,
                onTap: canEdit ? onRefresh : null,
              ),
              _IconBtn(
                tooltip: i18n.common.fileTree.collapseAll,
                icon: LucideIcons.chevronDown,
                onTap: canEdit ? onCollapseAll : null,
              ),
              Container(
                width: 1,
                height: 16,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                color: c.border,
              ),
              for (final (mode, icon, tip) in [
                (FileTreeViewMode.simple, LucideIcons.list, 'Simple view'),
                (FileTreeViewMode.compact, LucideIcons.eye, 'Compact view'),
                (FileTreeViewMode.detailed, LucideIcons.tableProperties, 'Detailed view'),
              ])
                _IconBtn(
                  tooltip: tip,
                  icon: icon,
                  active: viewMode == mode,
                  onTap: () => onViewMode(mode),
                ),
              _IconBtn(
                tooltip: recentOnly
                    ? 'Show all files (recent only is on)'
                    : 'Recent only (last 7 days)',
                icon: LucideIcons.calendarClock,
                active: recentOnly,
                onTap: onToggleRecentOnly,
              ),
              _IconBtn(
                tooltip: respectGitignore
                    ? i18n.fileTree.showGitignoredFiles
                    : i18n.fileTree.hideGitignoredFiles,
                icon: LucideIcons.eyeOff,
                active: !respectGitignore,
                onTap: canEdit ? onToggleRespectGitignore : null,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: 32,
            child: TextField(
              controller: search,
              onChanged: onSearchChanged,
              onSubmitted: onSearchSubmitted,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                isDense: true,
                hintText: i18n.fileTree.search.hint,
                hintStyle: TextStyle(color: c.mutedForeground, fontSize: 14),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.sm),
                  child: Icon(LucideIcons.search, size: 14, color: c.mutedForeground),
                ),
                prefixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                suffixIcon: search.text.isEmpty
                    ? null
                    : GestureDetector(
                        onTap: onCloseSearch,
                        child: Icon(LucideIcons.x, size: 12, color: c.mutedForeground),
                      ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One rendered tree row: indent guides, expand chevron, icon, name, and
/// (detailed) size + modified columns. Long-press/right-click → context menu.
class _NodeRow extends StatelessWidget {
  const _NodeRow({
    required this.flat,
    required this.viewMode,
    required this.expanded,
    required this.selected,
    required this.menuItems,
    required this.onTap,
  });

  final FlatNode flat;
  final FileTreeViewMode viewMode;
  final bool expanded;
  final bool selected;
  final List<AppMenuItem> menuItems;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final node = flat.node;
    final dense = viewMode != FileTreeViewMode.simple;
    final icon = node.isDirectory
        ? Icon(
            expanded ? Icons.folder_open : Icons.folder_outlined,
            size: 16,
            color: Colors.amber.shade700,
          )
        : Icon(fileIcon(node.name).icon, size: 16, color: fileIcon(node.name).color);
    final nameStyle = TextStyle(
      fontSize: dense ? 12.5 : 14,
      fontStyle: node.isSymlink ? FontStyle.italic : null,
    );

    return AppContextMenu(
      items: menuItems,
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: selected ? c.secondary : null,
          padding: EdgeInsets.symmetric(vertical: dense ? 2 : 6, horizontal: AppSpacing.sm),
          child: Row(
            children: [
              // Indent guide lines, one per depth level.
              for (var i = 0; i < flat.depth; i++)
                Container(
                  width: 16,
                  height: dense ? 20 : 24,
                  decoration: BoxDecoration(
                    border: Border(left: BorderSide(color: c.border)),
                  ),
                ),
              SizedBox(
                width: 16,
                child: node.isDirectory
                    ? Icon(
                        expanded ? Icons.expand_more : Icons.chevron_right,
                        size: 16,
                        color: c.mutedForeground,
                      )
                    : null,
              ),
              icon,
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(node.name, style: nameStyle, overflow: TextOverflow.ellipsis),
              ),
              if (viewMode == FileTreeViewMode.detailed && !node.isDirectory) ...[
                SizedBox(
                  width: 64,
                  child: Text(
                    formatFileSize(node.size),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(
                  width: 56,
                  child: Text(
                    formatModified(node.modified),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Content-search results: `path:line:col` + snippet (FileTreeSearchResults
/// parity).
class _SearchResults extends StatelessWidget {
  const _SearchResults({required this.result, required this.searching, required this.onTap});

  final FileSearchResult? result;
  final bool searching;
  final ValueChanged<FileSearchMatch> onTap;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    if (result == null) {
      return Center(
        child: searching ? const CircularProgressIndicator() : Text(t.fileTree.search.prompt),
      );
    }
    final matches = result!.matches;
    if (matches.isEmpty) {
      return Center(child: Text(t.fileTree.search.noMatches));
    }
    return Column(
      children: [
        if (result!.truncated)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Text(
              t.fileTree.search.resultsTruncated,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, i) {
              final m = matches[i];
              return ListTile(
                dense: true,
                leading: Icon(fileIcon(m.path).icon, size: 16, color: fileIcon(m.path).color),
                title: Text(
                  '${m.path}:${m.line}:${m.column}',
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(m.text, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () => onTap(m),
              );
            },
          ),
        ),
      ],
    );
  }
}
