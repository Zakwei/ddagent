import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Compact project selector used inside `SubpageHeader` on board/tasks/files/
/// git/quota pages — mirrors the old web `ActionMenu` trigger:
/// `h-7 gap-1 px-2 font-semibold`, folder icon + name + chevron.
class ProjectMenuButton extends StatelessWidget {
  const ProjectMenuButton({
    super.key,
    required this.projects,
    required this.selected,
    required this.onSelected,
    this.header = 'Project',
    this.allWorkspacesLabel,
    this.icon = LucideIcons.folder,
  });

  final List<Project> projects;
  final Project? selected;
  final ValueChanged<Project> onSelected;

  /// Menu header label (old UI shows the section name, e.g. 'Files').
  final String header;

  /// When set, the menu prepends a synthetic "all workspaces" entry whose
  /// [Project.projectId] equals this label's sentinel (caller decides).
  final String? allWorkspacesLabel;
  final IconData icon;

  String _label(Project p) =>
      p.displayName.isEmpty ? p.projectId : p.displayName;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return PopupMenuButton<Project>(
      tooltip: header,
      position: PopupMenuPosition.under,
      offset: const Offset(0, 4),
      onSelected: onSelected,
      itemBuilder: (ctx) => [
        PopupMenuItem<Project>(
          enabled: false,
          height: 28,
          child: Text(
            header,
            style: TextStyle(color: c.mutedForeground, fontSize: 12),
          ),
        ),
        for (final p in projects)
          PopupMenuItem<Project>(
            value: p,
            height: 36,
            child: Text(
              _label(p),
              style: TextStyle(color: c.foreground, fontSize: 13),
            ),
          ),
      ],
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: c.mutedForeground),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: Text(
                selected == null ? header : _label(selected!),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: c.foreground,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(LucideIcons.chevronDown, size: 14, color: c.mutedForeground),
          ],
        ),
      ),
    );
  }
}
