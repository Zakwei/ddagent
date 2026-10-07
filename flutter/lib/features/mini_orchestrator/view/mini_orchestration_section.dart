import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_spinner.dart';
import 'package:ddagent_app/features/mini_orchestrator/data/mini_orchestrator_config.dart';
import 'package:ddagent_app/features/mini_orchestrator/state/mini_orchestrator_config_controller.dart';
import 'package:ddagent_app/features/orchestrator/data/orchestrator_config.dart';
import 'package:ddagent_app/features/settings/view/sections/settings_section_layout.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Human label for a mini task type (the `OrchestratorTaskType` set).
String _taskTypeLabel(String type) => switch (type) {
  'plan' => 'Plan',
  'quick' => 'Quick',
  'research' => 'Research',
  'docs' => 'Docs',
  'code' => 'Code',
  'code-hard' => 'Code (hard)',
  'test' => 'Test',
  'review' => 'Review',
  'gate' => 'Gate',
  'report' => 'Report',
  _ => type,
};

String _roleLabel(String role) => role == 'thinker' ? 'Thinker' : 'Worker';

/// Settings → Mini orchestration: the two-role engine's config — a non-flash
/// thinker, a flash worker, and the per-task-type role map — behind one draft
/// persisted via `PUT /api/mini-orchestrator/config`.
class MiniOrchestrationSection extends ConsumerWidget {
  const MiniOrchestrationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final state = ref.watch(miniOrchestratorConfigProvider);
    final ctrl = ref.read(miniOrchestratorConfigProvider.notifier);
    final mi = t.settings.miniOrchestration;
    final orch = t.settings.orchestration;

    if (state.loading) {
      return Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppSpinner(size: 16),
            const SizedBox(width: AppSpacing.sm),
            Text(mi.loading, style: tt.bodySmall?.copyWith(color: c.mutedForeground)),
          ],
        ),
      );
    }

    final draft = state.draft;
    if (state.loadFailed || draft == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mi.loadError, style: tt.bodySmall?.copyWith(color: c.mutedForeground)),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              variant: AppButtonVariant.outline,
              size: AppButtonSize.sm,
              onPressed: () => unawaited(ctrl.load()),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.rotateCcw, size: 14),
                  const SizedBox(width: AppSpacing.xs),
                  Text(orch.retry),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              SettingsSectionBlock(
                title: mi.title,
                description: mi.description,
                children: [
                  _Card(
                    children: [
                      SettingsRow(
                        label: mi.enable.label,
                        description: mi.enable.description,
                        child: Switch(
                          value: draft.enabled,
                          onChanged: (enabled) => ctrl.update((d) => d.copyWith(enabled: enabled)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              _RoleEditor(
                title: mi.thinker.title,
                description: mi.thinker.description,
                candidate: draft.thinker.isNotEmpty
                    ? draft.thinker.first
                    : const OrchCandidate(id: 'thinker', provider: 'devin', model: ''),
                onChanged: (cand) => ctrl.update((d) => d.copyWith(thinker: [cand])),
              ),
              const SizedBox(height: AppSpacing.lg),
              _RoleEditor(
                title: mi.worker.title,
                description: mi.worker.description,
                candidate: draft.worker.isNotEmpty
                    ? draft.worker.first
                    : const OrchCandidate(id: 'worker', provider: 'devin', model: ''),
                onChanged: (cand) => ctrl.update((d) => d.copyWith(worker: [cand])),
              ),
              const SizedBox(height: AppSpacing.xl),
              _RolesEditor(draft: draft, ctrl: ctrl),
              const SizedBox(height: AppSpacing.xl),
              _PlannerEditor(draft: draft, ctrl: ctrl),
            ],
          ),
        ),
        _SaveBar(
          state: state,
          ctrl: ctrl,
          valid: draft.thinker.isNotEmpty && draft.worker.isNotEmpty,
        ),
      ],
    );
  }
}

/// One role's provider + model + tier editor.
class _RoleEditor extends StatefulWidget {
  const _RoleEditor({
    required this.title,
    required this.description,
    required this.candidate,
    required this.onChanged,
  });

  final String title;
  final String description;
  final OrchCandidate candidate;
  final ValueChanged<OrchCandidate> onChanged;

  @override
  State<_RoleEditor> createState() => _RoleEditorState();
}

class _RoleEditorState extends State<_RoleEditor> {
  late final TextEditingController _model = TextEditingController(text: widget.candidate.model);

  @override
  void didUpdateWidget(covariant _RoleEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.candidate.model != _model.text) {
      _model.text = widget.candidate.model;
    }
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final mi = t.settings.miniOrchestration;
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final cand = widget.candidate;
    return SettingsSectionBlock(
      title: widget.title,
      description: widget.description,
      children: [
        _Card(
          children: [
            SettingsRow(
              label: mi.fields.provider,
              child: DropdownButton<String>(
                value: orchProviders.containsKey(cand.provider) ? cand.provider : 'devin',
                isExpanded: true,
                underline: const SizedBox.shrink(),
                items: [
                  for (final e in orchProviders.entries)
                    DropdownMenuItem(value: e.key, child: Text(e.value)),
                ],
                onChanged: (provider) {
                  if (provider == null) return;
                  widget.onChanged(cand.copyWith(provider: provider));
                },
              ),
            ),
            SettingsRow(
              label: mi.fields.model,
              child: TextField(
                controller: _model,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: mi.fields.modelPlaceholder,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) => widget.onChanged(cand.copyWith(model: value.trim())),
              ),
            ),
            SettingsRow(
              label: mi.fields.tier,
              child: DropdownButton<String>(
                value: orchCostTiers.contains(cand.tier) ? cand.tier : 'mid',
                isExpanded: true,
                underline: const SizedBox.shrink(),
                items: [
                  for (final tier in orchCostTiers)
                    DropdownMenuItem(value: tier, child: Text(tier)),
                ],
                onChanged: (tier) {
                  if (tier == null) return;
                  widget.onChanged(cand.copyWith(tier: tier));
                },
              ),
            ),
            if (cand.model.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text(
                  mi.fields.modelPlaceholder,
                  style: tt.labelSmall?.copyWith(color: c.destructive),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Per-task-type role map — the "which model takes part" knob.
class _RolesEditor extends StatelessWidget {
  const _RolesEditor({required this.draft, required this.ctrl});

  final MiniOrchestratorConfigData draft;
  final MiniOrchestratorConfigController ctrl;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final mi = t.settings.miniOrchestration;
    return SettingsSectionBlock(
      title: mi.roles.title,
      description: mi.roles.description,
      children: [
        _Card(
          children: [
            for (final type in miniRoleTaskTypes)
              SettingsRow(
                label: _taskTypeLabel(type),
                child: DropdownButton<String>(
                  value: draft.roles[type] ?? 'worker',
                  underline: const SizedBox.shrink(),
                  items: [
                    for (final role in miniRoleValues)
                      DropdownMenuItem(value: role, child: Text(_roleLabel(role))),
                  ],
                  onChanged: (role) {
                    if (role == null) return;
                    ctrl.update((d) => d.copyWith(roles: {...d.roles, type: role}));
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Planner mode + confirm gate.
class _PlannerEditor extends StatelessWidget {
  const _PlannerEditor({required this.draft, required this.ctrl});

  final MiniOrchestratorConfigData draft;
  final MiniOrchestratorConfigController ctrl;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final mi = t.settings.miniOrchestration;
    return SettingsSectionBlock(
      title: mi.planner.title,
      children: [
        _Card(
          children: [
            SettingsRow(
              label: mi.planner.mode,
              child: DropdownButton<String>(
                value: draft.plannerMode,
                underline: const SizedBox.shrink(),
                items: [
                  DropdownMenuItem(value: 'auto', child: Text(mi.planner.modes.auto)),
                  DropdownMenuItem(value: 'off', child: Text(mi.planner.modes.off)),
                ],
                onChanged: (mode) {
                  if (mode == null) return;
                  ctrl.update((d) => d.copyWith(plannerMode: mode));
                },
              ),
            ),
            SettingsRow(
              label: mi.planner.requireConfirmLabel,
              child: Switch(
                value: draft.requireConfirm,
                onChanged: (value) => ctrl.update((d) => d.copyWith(requireConfirm: value)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SaveBar extends StatelessWidget {
  const _SaveBar({required this.state, required this.ctrl, required this.valid});

  final MiniOrchestratorConfigState state;
  final MiniOrchestratorConfigController ctrl;
  final bool valid;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final mi = t.settings.miniOrchestration;
    final orch = t.settings.orchestration;
    return Container(
      decoration: BoxDecoration(
        color: c.background.withValues(alpha: 0.95),
        border: Border(top: BorderSide(color: c.border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                if (state.error != null) {
                  return Text(
                    '${orch.save.error}: ${state.error}',
                    style: tt.labelSmall?.copyWith(color: c.destructive),
                  );
                }
                if (!valid) {
                  return Text(mi.roles.title, style: tt.labelSmall?.copyWith(color: c.destructive));
                }
                if (state.savedNotice) {
                  return Row(
                    children: [
                      const Icon(LucideIcons.check, size: 14, color: Color(0xFF059669)),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        orch.save.saved,
                        style: tt.labelSmall?.copyWith(color: const Color(0xFF059669)),
                      ),
                    ],
                  );
                }
                if (state.dirty) {
                  return Text(
                    orch.save.unsaved,
                    style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          AppButton(
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.sm,
            onPressed: state.dirty && !state.saving ? ctrl.discard : null,
            child: Text(orch.save.discard),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppButton(
            size: AppButtonSize.sm,
            loading: state.saving,
            onPressed: state.dirty && !state.saving && valid ? () => unawaited(ctrl.save()) : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(LucideIcons.save, size: 14),
                const SizedBox(width: AppSpacing.xs),
                Text(state.saving ? orch.save.saving : orch.save.save),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded container with dividers between rows (`SettingsCard divided`).
class _Card extends StatelessWidget {
  const _Card({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      decoration: BoxDecoration(
        color: c.card.withValues(alpha: 0.5),
        border: Border.all(color: c.border),
        borderRadius: AppRadii.borderLg,
      ),
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(height: 1, color: c.border.withValues(alpha: 0.5)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: children[i],
            ),
          ],
        ],
      ),
    );
  }
}
