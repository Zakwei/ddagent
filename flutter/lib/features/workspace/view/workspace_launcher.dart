import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shown inside a pane with no workspace binding yet (port of
/// WorkspaceLauncher.tsx): pick a project to bind the pane, or jump to
/// Projects to create one. The last-used project floats to the top.
class WorkspaceLauncher extends ConsumerWidget {
  const WorkspaceLauncher({
    super.key,
    required this.lastUsedProjectId,
    required this.onSelectProject,
  });

  final String? lastUsedProjectId;
  final void Function(String projectId) onSelectProject;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Theme.of(context);
    final c = context.appColors;
    final projects = ref.watch(projectsProvider).projects;
    final ordered = [...projects];
    if (lastUsedProjectId != null) {
      ordered.sort(
        (a, b) =>
            (b.projectId == lastUsedProjectId ? 1 : 0) - (a.projectId == lastUsedProjectId ? 1 : 0),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: c.muted.withValues(alpha: 0.5),
                  borderRadius: AppRadii.borderLg,
                ),
                child: Icon(Icons.folder_outlined, color: c.mutedForeground),
              ),
              const SizedBox(height: AppSpacing.md),
              Text('Choose a workspace', style: t.textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Pick a workspace for this pane, or create a new one.',
                textAlign: TextAlign.center,
                style: t.textTheme.bodySmall?.copyWith(color: c.mutedForeground),
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final p in ordered)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: InkWell(
                    borderRadius: AppRadii.borderMd,
                    onTap: () => onSelectProject(p.projectId),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: c.border),
                        borderRadius: AppRadii.borderMd,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.folder_outlined, size: 14, color: c.mutedForeground),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              p.displayName.isEmpty ? p.projectId : p.displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Flexible(
                            child: Text(
                              p.fullPath ?? p.path,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.textTheme.labelSmall?.copyWith(color: c.mutedForeground),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              InkWell(
                borderRadius: AppRadii.borderMd,
                onTap: () => context.go('/projects'),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: c.border, style: BorderStyle.solid),
                    borderRadius: AppRadii.borderMd,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 14, color: c.mutedForeground),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Create workspace',
                        style: t.textTheme.bodySmall?.copyWith(color: c.mutedForeground),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
