import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_spinner.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/file_tree/view/folder_browser.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/settings/view/sections/settings_section_layout.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Workspaces section — port of
/// `workspaces-settings/WorkspacesSettingsTab.tsx`: workspace list,
/// "Add workspace" (path + optional name — the web's clone-repository branch
/// of `ProjectCreationWizard` isn't ported; the Projects screen clone dialog
/// covers that flow), and remove-with-confirm that also drops panes pointing
/// at the removed project.
class WorkspacesSection extends ConsumerWidget {
  const WorkspacesSection({super.key});

  Future<void> _deleteProject(BuildContext context, WidgetRef ref, Project project) async {
    final t = Translations.of(context).settings.workspaces;
    final confirmed = await AppDialog.confirm(
      context,
      title: t.deleteTitle,
      message:
          '${t.deleteConfirm} ${project.displayName.isNotEmpty ? project.displayName : project.projectId}',
      confirmLabel: t.remove,
    );
    if (!confirmed || !context.mounted) return;

    final error = await ref.read(projectsProvider.notifier).archive(project.projectId);
    if (error != null) {
      if (context.mounted) AppToast.error(context, error);
      return;
    }
    // Panes persist projectId/sessionId — drop references to the removed
    // workspace (same cleanup convention as the web tab).
    final workspace = ref.read(workspaceProvider.notifier);
    for (final pane in ref.read(workspaceProvider).panes) {
      if (pane.projectId == project.projectId) {
        workspace.updatePane(pane.id, projectId: () => null, sessionId: () => null);
      }
    }
    if (ref.read(workspaceProvider).lastUsedProjectId == project.projectId) {
      workspace.setLastUsedProjectId(null);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context).settings.workspaces;
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final state = ref.watch(projectsProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        SettingsSectionBlock(
          title: t.title,
          icon: LucideIcons.folderCog,
          description: t.description,
          children: [
            AppCard(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: InkWell(
                borderRadius: AppRadii.borderMd,
                onTap: () => unawaited(
                  showDialog<void>(context: context, builder: (_) => const _AddWorkspaceDialog()),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  decoration: BoxDecoration(
                    border: Border.all(color: c.border.withValues(alpha: 0.6)),
                    borderRadius: AppRadii.borderMd,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: AppSpacing.sm,
                    children: [
                      Icon(LucideIcons.folderPlus, size: 16, color: c.mutedForeground),
                      Text(t.create, style: tt.bodyMedium?.copyWith(color: c.mutedForeground)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            if (state.loading && state.projects.isEmpty)
              const Center(
                child: Padding(padding: EdgeInsets.all(AppSpacing.lg), child: AppSpinner()),
              )
            else
              for (final project in state.projects)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      spacing: AppSpacing.md,
                      children: [
                        Icon(LucideIcons.folder, size: 16, color: c.mutedForeground),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.displayName.isNotEmpty
                                    ? project.displayName
                                    : project.projectId,
                                style: tt.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                project.fullPath ?? project.path,
                                style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: t.remove,
                          visualDensity: VisualDensity.compact,
                          icon: Icon(LucideIcons.trash2, size: 16, color: c.mutedForeground),
                          onPressed: () => unawaited(_deleteProject(context, ref, project)),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ],
    );
  }
}

/// "Add workspace" dialog — the local-path branch of the web
/// `ProjectCreationWizard` (path input + server filesystem browse + optional
/// display name → `POST /api/projects/create-project`).
class _AddWorkspaceDialog extends ConsumerStatefulWidget {
  const _AddWorkspaceDialog();

  @override
  ConsumerState<_AddWorkspaceDialog> createState() => _AddWorkspaceDialogState();
}

class _AddWorkspaceDialogState extends ConsumerState<_AddWorkspaceDialog> {
  final _path = TextEditingController();
  final _name = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _path.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _browse() async {
    final picked = await FolderBrowserDialog.pick(
      context,
      initialPath: _path.text.trim().isEmpty ? null : _path.text.trim(),
    );
    if (picked != null) _path.text = picked;
  }

  Future<void> _create() async {
    if (_path.text.trim().isEmpty) {
      setState(() => _error = 'Path is required');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    final error = await ref
        .read(projectsProvider.notifier)
        .create(
          _path.text.trim(),
          customName: _name.text.trim().isEmpty ? null : _name.text.trim(),
        );
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _busy = false;
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Translations.of(context).settings.workspaces;
    return AppDialog(
      title: t.create,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            spacing: AppSpacing.xs,
            children: [
              Expanded(
                child: AppInput(controller: _path, hint: 'Project path', autofocus: true),
              ),
              IconButton(
                tooltip: 'Browse',
                icon: const Icon(Icons.folder_open),
                onPressed: () => unawaited(_browse()),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppInput(controller: _name, hint: 'Display name (optional)'),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(_error!, style: TextStyle(color: c.destructive)),
          ],
        ],
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.cancel),
        ),
        AppButton(
          onPressed: _busy ? null : () => unawaited(_create()),
          loading: _busy,
          child: Text(t.create),
        ),
      ],
    );
  }
}
