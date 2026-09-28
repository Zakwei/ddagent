import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_context_menu.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/features/file_tree/state/file_tree_controller.dart';
import 'package:ddagent_app/features/file_tree/view/file_viewer.dart';
import 'package:ddagent_app/features/file_tree/view/folder_browser.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    'rs' ||
    'go' ||
    'c' ||
    'cpp' ||
    'h' => (icon: Icons.settings_suggest, color: orange),
    'rb' ||
    'java' ||
    'kt' ||
    'swift' ||
    'php' => (icon: Icons.code, color: orange),
    'json' ||
    'yaml' ||
    'yml' ||
    'toml' ||
    'xml' => (icon: Icons.data_object, color: grey),
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
    'zip' ||
    'tar' ||
    'gz' ||
    '7z' ||
    'rar' => (icon: Icons.archive_outlined, color: amber),
    'pdf' => (icon: Icons.picture_as_pdf_outlined, color: Colors.red),
    'mp3' ||
    'wav' ||
    'ogg' ||
    'flac' => (icon: Icons.music_note_outlined, color: Colors.pink),
    'mp4' ||
    'mov' ||
    'mkv' ||
    'webm' => (icon: Icons.videocam_outlined, color: Colors.red),
    'sql' || 'db' || 'sqlite' => (icon: Icons.storage_outlined, color: blue),
    'env' ||
    'lock' ||
    'pem' ||
    'key' => (icon: Icons.lock_outline, color: grey),
    _ => (icon: Icons.insert_drive_file_outlined, color: grey),
  };
}

String _basename(String path) {
  final trimmed = path.endsWith('/')
      ? path.substring(0, path.length - 1)
      : path;
  final i = trimmed.lastIndexOf('/');
  return i < 0 ? trimmed : trimmed.substring(i + 1);
}

String _dirname(String path) {
  final i = path.lastIndexOf('/');
  return i <= 0 ? '/' : path.substring(0, i);
}

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
  FileTreeNode? _openNode;
  bool _searching = false;
  FileSearchResult? _searchResult;
  bool _autoSelected = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureProject());
  }

  void _ensureProject() {
    final id = widget.projectId;
    if (id != null) {
      ref.read(fileTreeProvider.notifier).selectProject(id);
      return;
    }
    // Deep-link without projectId: default to the first project once known.
    final first = ref.read(projectsProvider).projects.firstOrNull?.projectId;
    if (first != null) {
      _autoSelected = true;
      ref.read(fileTreeProvider.notifier).selectProject(first);
    }
  }

  @override
  void dispose() {
    _search.dispose();
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
    }
  }

  /// Reveal a content-search hit: expand ancestors, open the file.
  void _openMatch(FileSearchMatch match) {
    final node = FileTreeNode(
      name: _basename(match.path),
      path: match.path,
      isDirectory: false,
    );
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
      final res = await ref
          .read(fileTreeRepositoryProvider)
          .search(_projectId, q, limit: 100);
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
      title: 'Upload to',
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
                onTap: () => Navigator.of(context).pop(d),
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
    final err = await ref
        .read(fileTreeProvider.notifier)
        .uploadFiles(targetPath, files);
    if (!mounted) {
      return;
    }
    AppToast.show(
      context,
      err ?? 'Uploaded ${files.length} file(s)',
      isError: err != null,
    );
  }

  Future<void> _createEntry(FileTreeNode? parent, String type) async {
    final nameController = TextEditingController();
    final name = await AppDialog.show<String>(
      context,
      title: type == 'directory' ? 'New folder' : 'New file',
      content: AppInput(
        controller: nameController,
        hint: 'Name',
        autofocus: true,
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          onPressed: () =>
              Navigator.of(context).pop(nameController.text.trim()),
          child: const Text('Create'),
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
    final nameController = TextEditingController(text: node.name);
    final name = await AppDialog.show<String>(
      context,
      title: 'Rename ${node.name}',
      content: AppInput(
        controller: nameController,
        hint: 'New name',
        autofocus: true,
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          onPressed: () =>
              Navigator.of(context).pop(nameController.text.trim()),
          child: const Text('Rename'),
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
    }
  }

  Future<void> _delete(FileTreeNode node) async {
    final ok = await AppDialog.confirm(
      context,
      title: 'Delete ${node.name}',
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
        .deleteEntry(
          path: node.path,
          type: node.isDirectory ? 'directory' : 'file',
        );
    if (!mounted) {
      return;
    }
    if (err != null) {
      AppToast.show(context, err, isError: true);
    } else if (_openNode != null && _openNode!.path.startsWith(node.path)) {
      setState(() => _openNode = null);
    }
  }

  Future<void> _browsePath() async {
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
    AppToast.show(context, 'Not a registered project: $picked', isError: true);
  }

  List<AppMenuItem> _menuItems(FileTreeNode node) => [
    if (!node.isDirectory) ...[
      AppMenuItem(
        label: 'Open',
        icon: Icons.open_in_new,
        onTap: () => _open(node),
      ),
      AppMenuItem(
        label: 'Open in editor',
        icon: Icons.edit_note,
        onTap: () => context.go(
          '/editor?projectId=$_projectId'
          '&file=${Uri.encodeQueryComponent(node.path)}',
        ),
      ),
    ],
    if (node.isDirectory) ...[
      AppMenuItem(
        label: 'New file',
        icon: Icons.note_add_outlined,
        onTap: () => _createEntry(node, 'file'),
      ),
      AppMenuItem(
        label: 'New folder',
        icon: Icons.create_new_folder_outlined,
        onTap: () => _createEntry(node, 'directory'),
      ),
      AppMenuItem(
        label: 'Upload here',
        icon: Icons.upload_outlined,
        onTap: () => _upload(node.path),
      ),
    ],
    AppMenuItem(
      label: 'Copy path',
      icon: Icons.copy_outlined,
      onTap: () {
        Clipboard.setData(ClipboardData(text: node.path));
        AppToast.show(context, 'Path copied');
      },
    ),
    if (!node.isDirectory)
      AppMenuItem(
        label: 'Download',
        icon: Icons.download_outlined,
        onTap: () =>
            downloadFile(context, ref, projectId: _projectId, node: node),
      ),
    AppMenuItem(
      label: 'Rename',
      icon: Icons.edit_outlined,
      onTap: () => _rename(node),
    ),
    AppMenuItem(
      label: 'Delete',
      icon: Icons.delete_outline,
      destructive: true,
      onTap: () => _delete(node),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fileTreeProvider);
    final viewMode = ref.watch(fileTreeViewModeProvider);
    final projects = ref.watch(projectsProvider).projects;
    final compact = context.breakpoint.isCompact;

    // Late auto-select when the projects list arrives after first frame.
    if (!_autoSelected &&
        widget.projectId == null &&
        state.projectId == null &&
        projects.isNotEmpty) {
      _autoSelected = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(fileTreeProvider.notifier)
            .selectProject(projects.first.projectId);
      });
    }

    final roots = _search.text.isEmpty
        ? state.roots
        : filterFileTree(state.roots, _search.text.toLowerCase());
    final visible = flattenVisible(
      roots,
      _search.text.isEmpty
          ? state.expanded
          : collectExpandedDirectoryPaths(roots),
    );

    final tree = _buildTree(state, viewMode, visible);

    return Column(
      children: [
        _Header(
          search: _search,
          searching: _searching,
          projects: projects,
          projectId: state.projectId,
          viewMode: viewMode,
          uploading: state.uploading,
          onProjectChanged: (id) =>
              ref.read(fileTreeProvider.notifier).selectProject(id),
          onBrowse: _browsePath,
          onRefresh: () => ref.read(fileTreeProvider.notifier).refresh(),
          onUpload: _pickUploadTarget,
          onNewFile: () => _createEntry(null, 'file'),
          onNewFolder: () => _createEntry(null, 'directory'),
          onSearchChanged: (q) {
            setState(() {});
            if (q.trim().isNotEmpty) {
              _runSearch(q);
            } else {
              setState(() => _searchResult = null);
            }
          },
          onSearchSubmitted: _runSearch,
          onCloseSearch: () {
            _search.clear();
            setState(() => _searchResult = null);
          },
          onViewMode: (m) => ref.read(fileTreeViewModeProvider.notifier).set(m),
        ),
        const Divider(height: 1),
        Expanded(
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
      ],
    );
  }

  Widget _buildTree(
    FileTreeState state,
    FileTreeViewMode viewMode,
    List<FlatNode> visible,
  ) {
    if (state.projectId == null) {
      return const Center(child: Text('Select a project'));
    }
    if (state.loading && state.roots.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.error != null && state.roots.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              state.error!,
              style: TextStyle(color: context.appColors.destructive),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              variant: AppButtonVariant.ghost,
              onPressed: () => ref.read(fileTreeProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (visible.isEmpty) {
      return const Center(child: Text('No files'));
    }
    return ListView.builder(
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
              ref
                  .read(fileTreeProvider.notifier)
                  .toggleDirectory(flat.node.path);
            } else {
              _open(flat.node);
            }
          },
        );
      },
    );
  }
}

/// Toolbar: project selector, browse, new file/folder, upload, refresh,
/// view-mode toggle, name-filter + content-search field.
class _Header extends StatelessWidget {
  const _Header({
    required this.search,
    required this.searching,
    required this.projects,
    required this.projectId,
    required this.viewMode,
    required this.uploading,
    required this.onProjectChanged,
    required this.onBrowse,
    required this.onRefresh,
    required this.onUpload,
    required this.onNewFile,
    required this.onNewFolder,
    required this.onSearchChanged,
    required this.onSearchSubmitted,
    required this.onCloseSearch,
    required this.onViewMode,
  });

  final TextEditingController search;
  final bool searching;
  final List<Project> projects;
  final String? projectId;
  final FileTreeViewMode viewMode;
  final bool uploading;
  final ValueChanged<String> onProjectChanged;
  final VoidCallback onBrowse;
  final VoidCallback onRefresh;
  final VoidCallback onUpload;
  final VoidCallback onNewFile;
  final VoidCallback onNewFolder;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onSearchSubmitted;
  final VoidCallback onCloseSearch;
  final ValueChanged<FileTreeViewMode> onViewMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          SizedBox(
            width: 220,
            child: DropdownButtonFormField<String>(
              initialValue: projects.any((p) => p.projectId == projectId)
                  ? projectId
                  : null,
              decoration: const InputDecoration(
                isDense: true,
                hintText: 'Project',
              ),
              items: [
                for (final p in projects)
                  DropdownMenuItem(
                    value: p.projectId,
                    child: Text(p.displayName),
                  ),
              ],
              onChanged: (id) {
                if (id != null) {
                  onProjectChanged(id);
                }
              },
            ),
          ),
          IconButton(
            tooltip: 'Browse server filesystem',
            icon: const Icon(Icons.folder_open, size: 18),
            onPressed: onBrowse,
          ),
          IconButton(
            tooltip: 'New file',
            icon: const Icon(Icons.note_add_outlined, size: 18),
            onPressed: projectId == null ? null : onNewFile,
          ),
          IconButton(
            tooltip: 'New folder',
            icon: const Icon(Icons.create_new_folder_outlined, size: 18),
            onPressed: projectId == null ? null : onNewFolder,
          ),
          IconButton(
            tooltip: 'Upload',
            icon: uploading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.upload_outlined, size: 18),
            onPressed: projectId == null || uploading ? null : onUpload,
          ),
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh, size: 18),
            onPressed: projectId == null ? null : onRefresh,
          ),
          PopupMenuButton<FileTreeViewMode>(
            tooltip: 'View mode',
            icon: const Icon(Icons.view_list_outlined, size: 18),
            initialValue: viewMode,
            onSelected: onViewMode,
            itemBuilder: (_) => [
              for (final m in FileTreeViewMode.values)
                PopupMenuItem(
                  value: m,
                  child: Row(
                    children: [
                      if (m == viewMode)
                        const Icon(Icons.check, size: 16)
                      else
                        const SizedBox(width: 16),
                      const SizedBox(width: AppSpacing.sm),
                      Text(m.name),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(
            width: 260,
            child: AppInput(
              controller: search,
              hint: 'Filter names / Enter to search contents',
              onChanged: onSearchChanged,
              onSubmitted: onSearchSubmitted,
            ),
          ),
          if (searching)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
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
        : Icon(
            fileIcon(node.name).icon,
            size: 16,
            color: fileIcon(node.name).color,
          );
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
          padding: EdgeInsets.symmetric(
            vertical: dense ? 2 : 6,
            horizontal: AppSpacing.sm,
          ),
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
                child: Text(
                  node.name,
                  style: nameStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (viewMode == FileTreeViewMode.detailed &&
                  !node.isDirectory) ...[
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
  const _SearchResults({
    required this.result,
    required this.searching,
    required this.onTap,
  });

  final FileSearchResult? result;
  final bool searching;
  final ValueChanged<FileSearchMatch> onTap;

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return Center(
        child: searching
            ? const CircularProgressIndicator()
            : const Text('Type a query and press Enter'),
      );
    }
    final matches = result!.matches;
    if (matches.isEmpty) {
      return const Center(child: Text('No matches'));
    }
    return Column(
      children: [
        if (result!.truncated)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Text(
              'Results truncated',
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
                leading: Icon(
                  fileIcon(m.path).icon,
                  size: 16,
                  color: fileIcon(m.path).color,
                ),
                title: Text(
                  '${m.path}:${m.line}:${m.column}',
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  m.text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => onTap(m),
              );
            },
          ),
        ),
      ],
    );
  }
}
