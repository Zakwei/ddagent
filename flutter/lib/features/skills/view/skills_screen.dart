import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/core/widgets/subpage_header.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/projects/view/project_menu_button.dart';
import 'package:ddagent_app/features/sessions/view/provider_logo.dart';
import 'package:ddagent_app/features/skills/data/skill_models.dart';
import 'package:ddagent_app/features/skills/data/skills_constants.dart';
import 'package:ddagent_app/features/skills/data/skills_formatting.dart';
import 'package:ddagent_app/features/skills/state/provider_skills_controller.dart';
import 'package:ddagent_app/features/skills/view/add_skill_dialog.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Standalone skills screen — provider pills on top (Agents-section selector
/// parity), then [ProviderSkillsPane]. Exposed as a public widget so a route
/// (`/skills`) or any caller can mount it.
class SkillsScreen extends ConsumerStatefulWidget {
  const SkillsScreen({super.key, this.initialProvider});

  /// Provider shown first — defaults to the first of [kSkillProviders].
  final String? initialProvider;

  @override
  ConsumerState<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends ConsumerState<SkillsScreen> {
  late String _provider = widget.initialProvider ?? kSkillProviders.first;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SubpageHeader(icon: LucideIcons.fileCode2, title: t.settings.tabs.skills),
            Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: c.border)),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final provider in kSkillProviders)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: _ProviderPill(
                          provider: provider,
                          selected: _provider == provider,
                          onTap: () => setState(() => _provider = provider),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                children: [ProviderSkillsPane(provider: _provider)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Provider pill — compact variant of the Agents-tab `_AgentPill`.
class _ProviderPill extends StatelessWidget {
  const _ProviderPill({required this.provider, required this.selected, required this.onTap});

  final String provider;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: AppRadii.borderMd,
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppMotion.base,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: selected ? c.background : Colors.transparent,
          borderRadius: AppRadii.borderMd,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProviderLogo(provider: provider, size: 16),
            const SizedBox(width: AppSpacing.sm),
            Text(
              skillProviderName(provider),
              style: tt.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: selected ? c.foreground : c.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Per-provider skills browser — port of `ProviderSkills.tsx`. Embeddable
/// body (no Scaffold): the settings Agents tab mounts it inside its category
/// `ListView`, the standalone screen wraps it itself.
class ProviderSkillsPane extends ConsumerStatefulWidget {
  const ProviderSkillsPane({super.key, required this.provider});

  /// Provider id — `claude`, `cursor`, `codex`, `opencode`, `commandcode`, `antigravity` or `devin`.
  final String provider;

  @override
  ConsumerState<ProviderSkillsPane> createState() => _ProviderSkillsPaneState();
}

class _ProviderSkillsPaneState extends ConsumerState<ProviderSkillsPane> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  bool _justInstalled = false;
  Timer? _justInstalledTimer;

  /// false = "Global" scope mode (user/plugin/admin/system skills), true =
  /// "Projects" scope mode (repo/project skills of the selected project).
  bool _projectsMode = false;

  @override
  void dispose() {
    _justInstalledTimer?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  String get _providerName => skillProviderName(widget.provider);

  /// Workspace path a project is scanned by — mirrors the controller's
  /// `fullPath || path` resolution.
  String _projectPath(Project project) =>
      (project.fullPath?.isNotEmpty ?? false) ? project.fullPath! : project.path;

  Project? _projectFor(List<Project> projects, String? path) {
    if (path == null) return null;
    for (final project in projects) {
      if (_projectPath(project) == path) return project;
    }
    return null;
  }

  Future<void> _openAdd() async {
    final saved = await AddSkillDialog.show(
      context,
      provider: widget.provider,
      onSubmit: (entries) =>
          ref.read(providerSkillsProvider(widget.provider).notifier).addSkills(entries),
    );
    if (!mounted) return;
    setState(() => _justInstalled = saved);
    // The web clears `saveStatus` after 6 s, hiding the success chip.
    _justInstalledTimer?.cancel();
    if (saved) {
      _justInstalledTimer = Timer(const Duration(seconds: 6), () {
        if (mounted) setState(() => _justInstalled = false);
      });
      // Chip → toast too (MCP parity).
      AppToast.show(context, Translations.of(context).settings.saveStatus.success);
    }
  }

  /// `pendingDeleteSkill` dialog — deleting removes the whole directory from
  /// the provider's managed root, so it requires confirmation.
  Future<void> _confirmDelete(ProviderSkill skill, String directoryName) async {
    final t = Translations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: 'Delete ${skill.command.isNotEmpty ? skill.command : skill.name}?',
        content: Text(
          'This removes the $directoryName directory from '
          '$_providerName\'s managed skills directory. This cannot be undone.',
        ),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.common.buttons.cancel),
          ),
          AppButton(
            variant: AppButtonVariant.destructive,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.common.buttons.delete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(providerSkillsProvider(widget.provider).notifier).delete(directoryName);
    if (!mounted) return;
    if (ref.read(providerSkillsProvider(widget.provider)).deleteError == null) {
      AppToast.show(context, t.settings.saveStatus.success);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final state = ref.watch(providerSkillsProvider(widget.provider));
    final projects = ref.watch(projectsProvider).projects;
    final selectedProject = _projectFor(projects, state.selectedProjectPath);
    // Split the merged list: Project mode = repo/project scopes, Global mode =
    // everything else (user/plugin/admin/system).
    final modeSkills = [
      for (final skill in state.skills)
        if (skill.scope.isProjectScoped == _projectsMode) skill,
    ];
    final filtered = filterSkills(modeSkills, _query);
    final grouped = groupSkillsByScope(filtered);
    final error = state.deleteError ?? state.loadError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header — fileCode2 tile + title/description.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: c.muted.withValues(alpha: 0.2),
                border: Border.all(color: c.border.withValues(alpha: 0.7)),
                borderRadius: AppRadii.borderLg,
              ),
              child: Icon(LucideIcons.fileCode2, size: 16, color: c.mutedForeground),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.settings.tabs.skills, style: tt.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Manage $_providerName skills from local files, complete '
                    'folders, and project-aware locations.',
                    style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Search + Add + Refresh row.
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420, minWidth: 200),
              child: SizedBox(
                height: 36,
                width: 420,
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'Search skills...',
                    hintStyle: TextStyle(color: c.mutedForeground, fontSize: 14),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: AppSpacing.sm),
                      child: Icon(LucideIcons.search, size: 14, color: c.mutedForeground),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear skill search',
                            icon: Icon(LucideIcons.x, size: 14, color: c.mutedForeground),
                            onPressed: () => setState(() {
                              _searchCtrl.clear();
                              _query = '';
                            }),
                          ),
                  ),
                ),
              ),
            ),
            AppButton(
              size: AppButtonSize.sm,
              onPressed: () => unawaited(_openAdd()),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(LucideIcons.plus, size: 14),
                  SizedBox(width: AppSpacing.xs),
                  Text('Add Skill'),
                ],
              ),
            ),
            AppButton(
              variant: AppButtonVariant.outline,
              size: AppButtonSize.sm,
              onPressed: state.isLoading || state.isLoadingProjectScopes
                  ? null
                  : () => ref
                        .read(providerSkillsProvider(widget.provider).notifier)
                        .refresh(force: true),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.isLoading || state.isLoadingProjectScopes)
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    const Icon(LucideIcons.refreshCw, size: 14),
                  const SizedBox(width: AppSpacing.xs),
                  Text(t.common.buttons.refresh),
                ],
              ),
            ),
          ],
        ),

        // Global vs Projects scope switch; Projects mode reveals the project
        // picker (reused from the board/tasks/files/git pages).
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SegmentedButton<bool>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: false, label: Text('Global')),
                ButtonSegment(value: true, label: Text('Projects')),
              ],
              selected: {_projectsMode},
              onSelectionChanged: (selection) => setState(() => _projectsMode = selection.first),
            ),
            if (_projectsMode)
              if (projects.isEmpty)
                Text(
                  'No projects available',
                  style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                )
              else
                ProjectMenuButton(
                  projects: projects,
                  selected: selectedProject,
                  header: 'Project',
                  onSelected: (project) => unawaited(
                    ref
                        .read(providerSkillsProvider(widget.provider).notifier)
                        .selectProject(_projectPath(project)),
                  ),
                ),
          ],
        ),

        // `isLoadingProjectScopes` — "Scanning project skills...".
        SizedBox(
          height: AppSpacing.lg,
          child: state.isLoadingProjectScopes && _projectsMode
              ? Row(
                  children: [
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 1.5, color: c.mutedForeground),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'Scanning project skills...',
                      style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                    ),
                  ],
                )
              : null,
        ),

        // Load/delete error box (dialog carries its own submitError).
        if (error != null)
          Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: c.destructive.withValues(alpha: 0.08),
              border: Border.all(color: c.destructive.withValues(alpha: 0.4)),
              borderRadius: AppRadii.borderLg,
            ),
            child: Text(error, style: tt.bodySmall?.copyWith(color: c.destructive)),
          ),

        if (_justInstalled)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Icon(LucideIcons.circleCheck, size: 16, color: c.primary),
                const SizedBox(width: AppSpacing.xs),
                Text('Skills saved successfully.', style: tt.bodySmall?.copyWith(color: c.primary)),
              ],
            ),
          ),

        // Loading / empty / no-match states.
        if (state.isLoading && state.skills.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
            child: Center(
              child: Text(
                'Loading $_providerName skills…',
                style: tt.bodyMedium?.copyWith(color: c.mutedForeground),
              ),
            ),
          )
        else if (_projectsMode && selectedProject == null)
          const _EmptyState(
            icon: LucideIcons.folder,
            title: 'No projects available',
            description: 'Add a project or workspace to browse its skills.',
          )
        else if (modeSkills.isEmpty)
          _projectsMode
              ? const _EmptyState(
                  icon: LucideIcons.folder,
                  title: 'No skills in this project',
                  description:
                      'Create a .claude/skills, .cursor/skills or '
                      '.agents/skills folder in the selected project.',
                )
              : const _EmptyState(
                  icon: LucideIcons.fileText,
                  title: 'No global skills discovered yet',
                  description:
                      'Add a global skill above to make it available across '
                      'every project.',
                )
        else if (filtered.isEmpty)
          const _EmptyState(
            icon: LucideIcons.search,
            title: 'No matching skills',
            description:
                'Try a different command, name, scope, project, or source '
                'path.',
          ),

        // Scope groups (`groupSkillsByScope`).
        for (final group in grouped) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                _ScopeBadge(scope: group.scope),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  '${group.skills.length} '
                  'SKILL${group.skills.length == 1 ? '' : 'S'}',
                  style: tt.labelSmall?.copyWith(color: c.mutedForeground, letterSpacing: 1.8),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
            child: LayoutBuilder(
              builder: (context, constraints) {
                // `lg:grid-cols-2` — two columns once the pane is wide enough.
                final twoCol = constraints.maxWidth >= 720;
                final width = twoCol
                    ? (constraints.maxWidth - AppSpacing.md) / 2
                    : constraints.maxWidth;
                return Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.md,
                  children: [
                    for (final skill in group.skills)
                      SizedBox(
                        width: width,
                        child: _SkillCard(
                          skill: skill,
                          onDelete: switch (managedSkillDirectoryName(skill)) {
                            final dir? => () => unawaited(_confirmDelete(skill, dir)),
                            _ => null,
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

/// `SCOPE_BADGE_CLASSES` chip.
class _ScopeBadge extends StatelessWidget {
  const _ScopeBadge({required this.scope});

  final SkillScope scope;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = skillScopeBadgeColors(scope, isDark: isDark);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm + 2, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: colors.background,
        border: Border.all(color: colors.border),
        borderRadius: AppRadii.borderLg,
      ),
      child: Text(
        scope.label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: colors.foreground),
      ),
    );
  }
}

/// One skill card — command + name, description, plugin/project badges,
/// source path, delete when the skill is provider-managed.
class _SkillCard extends StatelessWidget {
  const _SkillCard({required this.skill, this.onDelete});

  final ProviderSkill skill;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: c.card.withValues(alpha: 0.5),
        border: Border.all(color: c.border),
        borderRadius: AppRadii.borderLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      skill.command,
                      style: tt.bodyMedium?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                        color: c.foreground,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(skill.name, style: tt.bodyMedium?.copyWith(color: c.mutedForeground)),
                  ],
                ),
              ),
              if (onDelete != null)
                IconButton(
                  tooltip: 'Delete ${skill.name}',
                  visualDensity: VisualDensity.compact,
                  onPressed: onDelete,
                  icon: Icon(LucideIcons.trash2, size: 16, color: c.mutedForeground),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            skill.description.isNotEmpty
                ? skill.description
                : 'No description provided in the skill front matter.',
            style: tt.bodyMedium?.copyWith(color: c.mutedForeground, height: 1.4),
          ),
          if (skill.pluginName != null || skill.projectDisplayName != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  if (skill.pluginName != null) _MetaBadge(label: 'Plugin: ${skill.pluginName}'),
                  if (skill.projectDisplayName != null)
                    _MetaBadge(label: 'Project: ${skill.projectDisplayName}'),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: c.muted.withValues(alpha: 0.2),
              border: Border.all(color: c.border.withValues(alpha: 0.6)),
              borderRadius: AppRadii.borderLg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SOURCE',
                  style: tt.labelSmall?.copyWith(
                    color: c.mutedForeground,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.8,
                  ),
                ),
                const SizedBox(height: 2),
                SelectableText(
                  skill.sourcePath,
                  style: tt.bodySmall?.copyWith(fontFamily: 'monospace', color: c.foreground),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Outline plugin/project badge — `Badge variant="outline"`.
class _MetaBadge extends StatelessWidget {
  const _MetaBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: c.background.withValues(alpha: 0.7),
        border: Border.all(color: c.border),
        borderRadius: AppRadii.borderLg,
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

/// `EmptyState` — centered icon + title + description.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title, required this.description});

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Column(
        children: [
          Icon(icon, size: 28, color: c.mutedForeground),
          const SizedBox(height: AppSpacing.sm),
          Text(title, style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            textAlign: TextAlign.center,
            style: tt.bodySmall?.copyWith(color: c.mutedForeground),
          ),
        ],
      ),
    );
  }
}
