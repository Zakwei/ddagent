import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/view/project_menu_button.dart';
import 'package:ddagent_app/features/skills/data/skill_models.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Submit callback for [MoveSkillDialog] — returns null on success, otherwise
/// the message rendered inline as the dialog error.
typedef SkillMoveSubmit = Future<String?> Function({
  required bool toProject,
  String? targetWorkspacePath,
});

/// "Move skill" dialog — relocates a managed skill between the provider's
/// global skill root and a project's skill directory. Moving into a project
/// asks which project via the shared [ProjectMenuButton].
class MoveSkillDialog extends StatefulWidget {
  const MoveSkillDialog({
    super.key,
    required this.skill,
    required this.projects,
    required this.selectedProjectPath,
    required this.toProject,
    required this.onSubmit,
  });

  final ProviderSkill skill;

  /// Projects offered when [toProject] is true.
  final List<Project> projects;

  /// Currently scoped project path, preselected as the destination target.
  final String? selectedProjectPath;

  /// true = move into a project (project picker shown), false = move to global.
  final bool toProject;
  final SkillMoveSubmit onSubmit;

  /// Resolves to true when the skill was moved — the caller toasts.
  static Future<bool> show(
    BuildContext context, {
    required ProviderSkill skill,
    required List<Project> projects,
    required String? selectedProjectPath,
    required bool toProject,
    required SkillMoveSubmit onSubmit,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => MoveSkillDialog(
        skill: skill,
        projects: projects,
        selectedProjectPath: selectedProjectPath,
        toProject: toProject,
        onSubmit: onSubmit,
      ),
    );
    return result ?? false;
  }

  @override
  State<MoveSkillDialog> createState() => _MoveSkillDialogState();
}

class _MoveSkillDialogState extends State<MoveSkillDialog> {
  Project? _target;
  String? _submitError;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.toProject) {
      _target = _initialProject();
    }
  }

  /// Workspace path a project is addressed by — mirrors the controller's
  /// `fullPath || path` resolution.
  String _projectPath(Project project) =>
      (project.fullPath?.isNotEmpty ?? false) ? project.fullPath! : project.path;

  Project? _initialProject() {
    final selected = widget.selectedProjectPath;
    if (selected != null) {
      for (final project in widget.projects) {
        if (_projectPath(project) == selected) return project;
      }
    }
    return widget.projects.isEmpty ? null : widget.projects.first;
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _submitError = null;
    });
    final error = await widget.onSubmit(
      toProject: widget.toProject,
      targetWorkspacePath: widget.toProject && _target != null ? _projectPath(_target!) : null,
    );
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _submitting = false;
      _submitError = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final label = widget.skill.command.isNotEmpty ? widget.skill.command : widget.skill.name;

    return AppDialog(
      title: t.skills.moveSkill(name: label),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.toProject) ...[
              Text(
                t.skills.moveDialog.toProjectHint,
                style: tt.bodySmall?.copyWith(color: c.mutedForeground),
              ),
              const SizedBox(height: AppSpacing.md),
              if (widget.projects.isEmpty)
                Text(t.skills.empty.noProjects, style: tt.bodySmall?.copyWith(color: c.destructive))
              else
                ProjectMenuButton(
                  projects: widget.projects,
                  selected: _target,
                  header: t.skills.projectLabel,
                  onSelected: (project) => setState(() => _target = project),
                ),
            ] else
              Text(
                t.skills.moveDialog.toGlobalHint,
                style: tt.bodySmall?.copyWith(color: c.mutedForeground),
              ),
            if (_submitError != null) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: c.destructive.withValues(alpha: 0.08),
                  border: Border.all(color: c.destructive.withValues(alpha: 0.4)),
                  borderRadius: AppRadii.borderLg,
                ),
                child: Text(_submitError!, style: tt.bodySmall?.copyWith(color: c.destructive)),
              ),
            ],
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
          child: Text(t.common.buttons.cancel),
        ),
        AppButton(
          size: AppButtonSize.sm,
          onPressed: _submitting || (widget.toProject && _target == null)
              ? null
              : () => unawaited(_submit()),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_submitting)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                const Icon(LucideIcons.arrowRightLeft, size: 14),
              const SizedBox(width: AppSpacing.xs),
              Text(
                widget.toProject
                    ? t.skills.moveDialog.moveToProject
                    : t.skills.moveDialog.moveToGlobal,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
