import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/utils/path_utils.dart';
import 'package:ddagent_app/features/editor/state/editor_controller.dart';
import 'package:ddagent_app/features/file_tree/state/explorer_git_status.dart';
import 'package:ddagent_app/features/file_tree/state/file_tree_controller.dart';
import 'package:ddagent_app/features/file_tree/view/explorer_tree.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Left dock of the editor: Changed Files (git status, tap → open + diff)
/// above the VS Code-style project explorer.
class EditorDock extends ConsumerStatefulWidget {
  const EditorDock({super.key, required this.projectId, required this.onOpenFile, this.activePath});

  final String projectId;

  /// Open `path` in a tab; `diff: true` also opens the git diff surface.
  final void Function(String path, {bool diff}) onOpenFile;

  /// The active tab's file — revealed and selected in the explorer.
  final String? activePath;

  @override
  ConsumerState<EditorDock> createState() => _EditorDockState();
}

class _EditorDockState extends ConsumerState<EditorDock> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fileTreeProvider.notifier).selectProject(widget.projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final status = ref.watch(gitStatusProvider(widget.projectId)).value;
    final project = ref
        .watch(projectsProvider)
        .projects
        .where((p) => p.projectId == widget.projectId)
        .firstOrNull;
    return Container(
      width: 260,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: c.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (status != null)
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: _ChangedSection(status: status, dock: widget),
              ),
            ),
          Expanded(
            child: ExplorerTree(
              title: project?.displayName ?? '',
              activePath: widget.activePath,
              showOpenInEditor: false,
              onOpenFile: (node) => widget.onOpenFile(node.path),
              // Open tabs follow a renamed/moved file so a save does not
              // recreate it at the old path.
              onEntryRenamed: (oldPath, newPath) =>
                  ref.read(editorProvider.notifier).retarget(widget.projectId, oldPath, newPath),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangedSection extends ConsumerWidget {
  const _ChangedSection({required this.status, required this.dock});

  final Map<String, dynamic> status;
  final EditorDock dock;

  static const _groups = [
    ('staged', LucideIcons.listPlus),
    ('modified', LucideIcons.pencil),
    ('added', LucideIcons.circlePlus),
    ('deleted', LucideIcons.circleMinus),
    ('untracked', LucideIcons.circleHelp),
  ];

  List<String> _paths(String key) => [
    for (final e in status[key] as List? ?? const []) e.toString(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final t = Theme.of(context);
    final i18n = Translations.of(context);
    final total = _groups.fold<int>(0, (sum, g) => sum + _paths(g.$1).length);
    if (total == 0) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, 2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  i18n.common.gitPanel.history.changedFiles,
                  style: t.textTheme.labelSmall?.copyWith(color: c.mutedForeground),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(color: c.muted, borderRadius: AppRadii.borderSm),
                child: Text('$total', style: t.textTheme.labelSmall),
              ),
            ],
          ),
        ),
        for (final g in _groups) ...[
          for (final path in _paths(g.$1))
            _ChangedRow(path: path, icon: g.$2, onTap: () => dock.onOpenFile(path, diff: true)),
        ],
      ],
    );
  }
}

class _ChangedRow extends StatelessWidget {
  const _ChangedRow({required this.path, required this.icon, required this.onTap});

  final String path;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 13, color: c.mutedForeground),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                pathBasename(path),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
