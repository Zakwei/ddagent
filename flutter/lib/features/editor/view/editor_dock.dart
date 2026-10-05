import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/state/file_tree_controller.dart';
import 'package:ddagent_app/features/git/data/git_repository.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Project git status for the Changed Files dock section — null when the
/// project isn't a repository (status 400 NOT_A_GIT_REPOSITORY) or the call
/// failed; the section hides itself rather than erroring.
final gitStatusProvider = FutureProvider.autoDispose.family<Map<String, dynamic>?, String>((
  ref,
  projectId,
) async {
  try {
    return await ref.read(gitRepositoryProvider).status(projectId);
  } on Object {
    return null;
  }
});

/// Left dock of the editor: Changed Files (git status, tap → open + diff)
/// on top of the project file tree for quick switching.
class EditorDock extends ConsumerStatefulWidget {
  const EditorDock({super.key, required this.projectId, required this.onOpenFile});

  final String projectId;

  /// Open `path` in a tab; `diff: true` also opens the git diff surface.
  final void Function(String path, {bool diff}) onOpenFile;

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
    final t = Theme.of(context);
    final i18n = Translations.of(context);
    final status = ref.watch(gitStatusProvider(widget.projectId)).value;
    final tree = ref.watch(fileTreeProvider);
    return Container(
      width: 240,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: c.border)),
      ),
      child: ListView(
        children: [
          if (status != null) _ChangedSection(status: status, dock: widget),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, 2),
            child: Text(
              i18n.common.tabs.files,
              style: t.textTheme.labelSmall?.copyWith(color: c.mutedForeground),
            ),
          ),
          if (tree.loading && tree.roots.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Center(
                child: SizedBox.square(
                  dimension: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            for (final f in tree.visible) _FileRow(f: f, dock: widget),
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
    ('staged', Icons.add_task),
    ('modified', Icons.edit_outlined),
    ('added', Icons.add_circle_outline),
    ('deleted', Icons.remove_circle_outline),
    ('untracked', Icons.help_outline),
  ];

  List<String> _paths(String key) => [
    for (final e in status[key] as List? ?? const []) e.toString(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final t = Theme.of(context);
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
                  'Changed files',
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
                path.split('/').last,
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

class _FileRow extends ConsumerWidget {
  const _FileRow({required this.f, required this.dock});

  final FlatNode f;
  final EditorDock dock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final n = f.node;
    return InkWell(
      onTap: () => n.isDirectory
          ? ref.read(fileTreeProvider.notifier).toggleDirectory(n.path)
          : dock.onOpenFile(n.path),
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md + f.depth * 12,
          right: AppSpacing.sm,
          top: 4,
          bottom: 4,
        ),
        child: Row(
          children: [
            Icon(
              n.isDirectory
                  ? (ref.read(fileTreeProvider).expanded.contains(n.path)
                        ? Icons.expand_more
                        : Icons.chevron_right)
                  : Icons.insert_drive_file_outlined,
              size: 13,
              color: c.mutedForeground,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                n.name,
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
