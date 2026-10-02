import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/theme/typography.dart';
import 'package:ddagent_app/core/widgets/app_badge.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_spinner.dart';
import 'package:ddagent_app/features/orchestrator/data/orchestrator_config.dart';
import 'package:ddagent_app/features/orchestrator/state/orchestrator_config_controller.dart';
import 'package:ddagent_app/features/provider_accounts/state/provider_accounts_controller.dart';
import 'package:ddagent_app/features/settings/view/sections/settings_section_layout.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Orchestration settings — port of `OrchestrationSettingsTab.tsx`: enable
/// toggle, candidate pool, per-task-type routing rules, planner behaviour and
/// execution limits behind one draft; a sticky save bar persists via
/// `PUT /api/orchestrator/config`.
class OrchestrationSection extends ConsumerWidget {
  const OrchestrationSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final state = ref.watch(orchestratorConfigProvider);
    final ctrl = ref.read(orchestratorConfigProvider.notifier);
    final orch = t.settings.orchestration;

    if (state.loading) {
      return Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppSpinner(size: 16),
            const SizedBox(width: AppSpacing.sm),
            Text(orch.loading, style: tt.bodySmall?.copyWith(color: c.mutedForeground)),
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
            Text(orch.loadError, style: tt.bodySmall?.copyWith(color: c.mutedForeground)),
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
                title: orch.title,
                description: orch.description,
                children: [
                  _DividedCard(
                    children: [
                      SettingsRow(
                        label: orch.enable.label,
                        description: orch.enable.description,
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
              const _CandidatePoolSection(),
              const SizedBox(height: AppSpacing.xl),
              const _RoutingRulesSection(),
              const SizedBox(height: AppSpacing.xl),
              const _PlannerSection(),
              const SizedBox(height: AppSpacing.xl),
              const _ExecutionSection(),
            ],
          ),
        ),

        // Sticky save bar — status on the left, discard/save on the right.
        Container(
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
                    // planner.candidateId must reference a pool member, so an
                    // empty pool can never validate — flag it here instead of
                    // on the server.
                    if (draft.pool.isEmpty) {
                      return Text(
                        orch.save.emptyPool,
                        style: tt.labelSmall?.copyWith(color: c.destructive),
                      );
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
                onPressed: state.dirty && !state.saving && draft.pool.isNotEmpty
                    ? () => unawaited(ctrl.save())
                    : null,
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
        ),
      ],
    );
  }
}

/// `SettingsCard divided` — rounded container with dividers between rows.
class _DividedCard extends StatelessWidget {
  const _DividedCard({required this.children});

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
            if (i > 0) Divider(height: 1, color: c.border),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: children[i],
            ),
          ],
        ],
      ),
    );
  }
}

/// `fieldSelectClass` — a `w-full rounded-lg border-input bg-card` select.
class _FieldSelect<T> extends StatelessWidget {
  const _FieldSelect({
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
    this.enabled = true,
  });

  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: enabled ? c.card : c.muted.withValues(alpha: 0.4),
        border: Border.all(color: c.input),
        borderRadius: AppRadii.borderLg,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          hint: hint != null
              ? Text(
                  hint!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.mutedForeground),
                )
              : null,
          isExpanded: true,
          isDense: true,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.foreground),
        ),
      ),
    );
  }
}

/// Labeled mini-field — `Field` from controls.tsx.
class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
          child: Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: c.mutedForeground, letterSpacing: 0.5),
          ),
        ),
        child,
      ],
    );
  }
}

/// Controlled text input for draft fields — keeps the caret stable across
/// rebuilds (an uncontrolled `initialValue` field jumps on every keystroke).
class _DraftInput extends StatefulWidget {
  const _DraftInput({required this.value, required this.onChanged, this.hint, this.mono = false});

  final String value;
  final ValueChanged<String> onChanged;
  final String? hint;
  final bool mono;

  @override
  State<_DraftInput> createState() => _DraftInputState();
}

class _DraftInputState extends State<_DraftInput> {
  late final TextEditingController _ctrl = TextEditingController(text: widget.value);

  @override
  void didUpdateWidget(_DraftInput old) {
    super.didUpdateWidget(old);
    if (widget.value != _ctrl.text) {
      _ctrl.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(
          offset: _ctrl.selection.start.clamp(0, widget.value.length),
        ),
      );
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: TextField(
        controller: _ctrl,
        onChanged: widget.onChanged,
        style: widget.mono
            ? monoStyle(context.appColors.foreground, size: 12)
            : Theme.of(context).textTheme.bodySmall,
        decoration: InputDecoration(
          hintText: widget.hint,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
        ),
      ),
    );
  }
}

/// Numeric field with clamp — used by the ms/int execution inputs.
class _IntField extends StatefulWidget {
  const _IntField({
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  State<_IntField> createState() => _IntFieldState();
}

class _IntFieldState extends State<_IntField> {
  late final TextEditingController _ctrl = TextEditingController(text: '${widget.value}');

  @override
  void didUpdateWidget(_IntField old) {
    super.didUpdateWidget(old);
    if ('${widget.value}' != _ctrl.text) {
      _ctrl.value = TextEditingValue(
        text: '${widget.value}',
        selection: TextSelection.collapsed(
          offset: _ctrl.selection.start.clamp(0, '${widget.value}'.length),
        ),
      );
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _commit(String text) {
    final parsed = int.tryParse(text);
    if (parsed == null || parsed == widget.value) return;
    widget.onChanged(parsed.clamp(widget.min, widget.max));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 36,
      child: TextField(
        controller: _ctrl,
        onChanged: _commit,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: Theme.of(context).textTheme.bodySmall,
        decoration: const InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
        ),
      ),
    );
  }
}

/// Chevron up/down pair — `MoveButtons` from controls.tsx.
class _MoveButtons extends StatelessWidget {
  const _MoveButtons({required this.index, required this.count, required this.onMove});

  final int index;
  final int count;
  final void Function(int index, int direction) onMove;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final fields = t.settings.orchestration.pool.fields;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(LucideIcons.chevronUp, size: 14),
          tooltip: fields.moveUp,
          onPressed: index == 0 ? null : () => onMove(index, -1),
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          icon: const Icon(LucideIcons.chevronDown, size: 14),
          tooltip: fields.moveDown,
          onPressed: index == count - 1 ? null : () => onMove(index, 1),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}

/// OrderedEntriesEditor — numbered rows with up/down/remove plus a trailing
/// "add" select; shared by routing rules and template steps.
class _OrderedEditor extends StatelessWidget {
  const _OrderedEditor({
    required this.entries,
    required this.onMove,
    required this.onRemove,
    required this.addOptions,
    required this.addPlaceholder,
    required this.onAdd,
    required this.emptyLabel,
    required this.removeTooltip,
  });

  final List<({String id, Widget content})> entries;
  final void Function(int index, int direction) onMove;
  final ValueChanged<String> onRemove;
  final List<({String value, String label})> addOptions;
  final String addPlaceholder;
  final ValueChanged<String> onAdd;
  final String emptyLabel;
  final String removeTooltip;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < entries.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
              decoration: BoxDecoration(
                color: c.muted.withValues(alpha: 0.3),
                border: Border.all(color: c.border.withValues(alpha: 0.5)),
                borderRadius: AppRadii.borderLg,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                    child: Text(
                      '${i + 1}.',
                      style: tt.labelSmall?.copyWith(
                        color: c.mutedForeground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: entries[i].content),
                  _MoveButtons(index: i, count: entries.length, onMove: onMove),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 14),
                    tooltip: removeTooltip,
                    onPressed: () => onRemove(entries[i].id),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ),
        if (entries.isEmpty)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs),
            child: Text(
              emptyLabel,
              style: tt.labelSmall?.copyWith(color: c.mutedForeground, fontStyle: FontStyle.italic),
            ),
          ),
        if (addOptions.isNotEmpty)
          _FieldSelect<String>(
            value: null,
            hint: addPlaceholder,
            items: [
              for (final option in addOptions)
                DropdownMenuItem(value: option.value, child: Text(option.label)),
            ],
            onChanged: (v) {
              if (v != null) onAdd(v);
            },
          ),
      ],
    );
  }
}

String _taskTypeLabel(Translations t, String type) {
  final types = t.settings.orchestration.rules.taskTypes;
  return switch (type) {
    'plan' => types.plan,
    'quick' => types.quick,
    'research' => types.research,
    'docs' => types.docs,
    'code' => types.code,
    'code-hard' => types.codeHard,
    'test' => types.test,
    'review' => types.review,
    // No i18n key for the report lane yet (added server-side with the
    // supervised loop) — English literal per project convention.
    'report' => 'Report',
    _ => type,
  };
}

String _tierLabel(Translations t, String tier) {
  final tiers = t.settings.orchestration.tiers;
  return switch (tier) {
    'free' => tiers.free,
    'cheap' => tiers.cheap,
    'mid' => tiers.mid,
    'premium' => tiers.premium,
    _ => tier,
  };
}

String _failureClassLabel(Translations$settings$orchestration$execution$en execT, String cls) =>
    switch (cls) {
      'rate_limit' => execT.retryClasses.rateLimit,
      'quota' => execT.retryClasses.quota,
      'auth' => execT.retryClasses.auth,
      'timeout' => execT.retryClasses.timeout,
      'transient' => execT.retryClasses.transient,
      _ => cls,
    };

/// CandidatePoolSection — the pool of model endpoints the router picks from.
class _CandidatePoolSection extends ConsumerWidget {
  const _CandidatePoolSection();

  static int _idCounter = 0;

  /// Pool edits cascade: a removed candidate must disappear from every rule
  /// and from planner.candidateId, or server-side validation rejects the save.
  void _onPoolChange(WidgetRef ref, List<OrchCandidate> nextPool) {
    ref.read(orchestratorConfigProvider.notifier).update((current) {
      final poolIds = nextPool.map((c) => c.id).toSet();
      final rules = {
        for (final e in current.rules.entries)
          e.key: [
            for (final id in e.value)
              if (poolIds.contains(id)) id,
          ],
      };
      final plannerCandidateId = poolIds.contains(current.planner.candidateId)
          ? current.planner.candidateId
          : (nextPool.isEmpty ? '' : nextPool.first.id);
      return current.copyWith(
        pool: nextPool,
        rules: rules,
        planner: current.planner.copyWith(candidateId: plannerCandidateId),
      );
    });
  }

  void _updateCandidate(
    WidgetRef ref,
    List<OrchCandidate> pool,
    String id,
    OrchCandidate Function(OrchCandidate) patch,
  ) {
    _onPoolChange(ref, [
      for (final c in pool)
        if (c.id == id) patch(c) else c,
    ]);
  }

  void _add(WidgetRef ref, List<OrchCandidate> pool) {
    _idCounter += 1;
    _onPoolChange(ref, [
      ...pool,
      OrchCandidate(
        id:
            'cand-${DateTime.now().millisecondsSinceEpoch.toRadixString(36)}-'
            '$_idCounter',
        provider: 'claude',
        model: '',
        tier: 'mid',
      ),
    ]);
  }

  void _move(WidgetRef ref, List<OrchCandidate> pool, int index, int dir) {
    final next = [...pool];
    final entry = next.removeAt(index);
    next.insert(index + dir, entry);
    _onPoolChange(ref, next);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final poolT = t.settings.orchestration.pool;
    final draft = ref.watch(orchestratorConfigProvider).draft!;
    final catalog = ref.watch(orchestratorConfigProvider).modelCatalog;
    final accounts = ref.watch(providerAccountsProvider('')).accounts;
    final pool = draft.pool;

    return SettingsSectionBlock(
      title: poolT.title,
      description: poolT.description,
      children: [
        if (pool.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
            decoration: BoxDecoration(
              border: Border.all(color: c.border),
              borderRadius: AppRadii.borderLg,
            ),
            child: Text(
              poolT.empty,
              textAlign: TextAlign.center,
              style: tt.bodySmall?.copyWith(color: c.mutedForeground),
            ),
          ),

        for (var i = 0; i < pool.length; i++)
          _CandidateCard(
            candidate: pool[i],
            index: i,
            count: pool.length,
            modelOptions: catalog[pool[i].provider] ?? const [],
            accounts: [
              for (final a in accounts)
                if (a.provider == pool[i].provider) a,
            ],
            onPatch: (patch) => _updateCandidate(ref, pool, pool[i].id, patch),
            onMove: (index, dir) => _move(ref, pool, index, dir),
            onRemove: () => _onPoolChange(ref, [
              for (final x in pool)
                if (x.id != pool[i].id) x,
            ]),
          ),

        AppButton(
          variant: AppButtonVariant.outline,
          size: AppButtonSize.sm,
          onPressed: () => _add(ref, pool),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.plus, size: 14),
              const SizedBox(width: AppSpacing.xs),
              Text(poolT.add),
            ],
          ),
        ),
      ],
    );
  }
}

/// One pool row — label input + move/remove + provider/model/effort/account/
/// tier grid.
class _CandidateCard extends StatelessWidget {
  const _CandidateCard({
    required this.candidate,
    required this.index,
    required this.count,
    required this.modelOptions,
    required this.accounts,
    required this.onPatch,
    required this.onMove,
    required this.onRemove,
  });

  final OrchCandidate candidate;
  final int index;
  final int count;
  final List<OrchModelOption> modelOptions;
  final List<ProviderAccountEntry> accounts;
  final void Function(OrchCandidate Function(OrchCandidate)) onPatch;
  final void Function(int index, int dir) onMove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final fields = t.settings.orchestration.pool.fields;
    final selectedOption = modelOptions.where((o) => o.value == candidate.model).firstOrNull;
    // A stored model missing from the catalog keeps a raw-value option
    // instead of silently snapping to the first entry.
    final modelInCatalog = selectedOption != null || candidate.model.isEmpty;
    final effortValues = selectedOption?.effortValues ?? const <String>[];

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: c.card.withValues(alpha: 0.5),
          border: Border.all(color: c.border),
          borderRadius: AppRadii.borderLg,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _DraftInput(
                    value: candidate.label,
                    hint: fields.labelPlaceholder,
                    onChanged: (v) => onPatch((cc) => cc.copyWith(label: v)),
                  ),
                ),
                _MoveButtons(index: index, count: count, onMove: onMove),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 14),
                  tooltip: fields.remove,
                  onPressed: onRemove,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final cols = width > 640 ? 3 : (width > 360 ? 2 : 1);
                final itemWidth = (width - (cols - 1) * AppSpacing.sm) / cols;
                return Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    SizedBox(
                      width: itemWidth,
                      child: _Field(
                        label: fields.provider,
                        child: _FieldSelect<String>(
                          value: candidate.provider,
                          items: [
                            for (final e in orchProviders.entries)
                              DropdownMenuItem(value: e.key, child: Text(e.value)),
                          ],
                          onChanged: (v) {
                            if (v == null) return;
                            // Model/effort/account ids are provider-scoped —
                            // a provider switch must not carry stale values.
                            onPatch(
                              (cc) => cc.copyWith(
                                provider: v,
                                model: '',
                                effort: () => null,
                                accountId: () => null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _Field(
                        label: fields.model,
                        child: _FieldSelect<String>(
                          value: modelInCatalog ? candidate.model : '',
                          hint: fields.modelPlaceholder,
                          items: [
                            DropdownMenuItem(value: '', child: Text(fields.modelPlaceholder)),
                            if (!modelInCatalog)
                              DropdownMenuItem(
                                value: candidate.model,
                                child: Text(candidate.model),
                              ),
                            for (final o in modelOptions)
                              DropdownMenuItem(
                                value: o.value,
                                child: Text(o.label, overflow: TextOverflow.ellipsis),
                              ),
                          ],
                          onChanged: (v) =>
                              onPatch((cc) => cc.copyWith(model: v ?? '', effort: () => null)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _Field(
                        label: fields.effort,
                        child: effortValues.isNotEmpty
                            ? _FieldSelect<String>(
                                value: candidate.effort ?? '',
                                items: [
                                  DropdownMenuItem(value: '', child: Text(fields.effortDefault)),
                                  for (final e in effortValues)
                                    DropdownMenuItem(value: e, child: Text(e)),
                                ],
                                onChanged: (v) => onPatch(
                                  (cc) => cc.copyWith(
                                    effort: () => (v == null || v.isEmpty) ? null : v,
                                  ),
                                ),
                              )
                            : _DraftInput(
                                value: candidate.effort ?? '',
                                hint: fields.effortPlaceholder,
                                onChanged: (v) => onPatch(
                                  (cc) =>
                                      cc.copyWith(effort: () => v.trim().isEmpty ? null : v.trim()),
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _Field(
                        label: fields.account,
                        child: _FieldSelect<String>(
                          value: candidate.accountId ?? '',
                          items: [
                            DropdownMenuItem(value: '', child: Text(fields.accountDefault)),
                            for (final a in accounts)
                              DropdownMenuItem(
                                value: a.id,
                                child: Text(
                                  a.isDefault ? '${a.label} (${fields.accountDefault})' : a.label,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                          onChanged: (v) => onPatch(
                            (cc) =>
                                cc.copyWith(accountId: () => (v == null || v.isEmpty) ? null : v),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: itemWidth,
                      child: _Field(
                        label: fields.tier,
                        child: _FieldSelect<String>(
                          value: candidate.tier,
                          items: [
                            for (final tier in orchCostTiers)
                              DropdownMenuItem(value: tier, child: Text(_tierLabel(t, tier))),
                          ],
                          onChanged: (v) {
                            if (v != null) {
                              onPatch((cc) => cc.copyWith(tier: v));
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Label + tier badge inside the routing-rule lists (`CandidateChipContent`).
class _CandidateChip extends StatelessWidget {
  const _CandidateChip({required this.candidate});

  final OrchCandidate candidate;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            candidate.label.isEmpty ? candidate.model : candidate.label,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        AppBadge(label: _tierLabel(t, candidate.tier)),
      ],
    );
  }
}

/// RoutingRulesSection — ordered candidate lists per task type.
class _RoutingRulesSection extends ConsumerWidget {
  const _RoutingRulesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final tt = Theme.of(context).textTheme;
    final c = context.appColors;
    final rulesT = t.settings.orchestration.rules;
    final draft = ref.watch(orchestratorConfigProvider).draft!;
    final ctrl = ref.read(orchestratorConfigProvider.notifier);
    final poolById = {for (final cc in draft.pool) cc.id: cc};

    void updateRule(String taskType, List<String> list) =>
        ctrl.update((d) => d.copyWith(rules: {...d.rules, taskType: list}));

    return SettingsSectionBlock(
      title: rulesT.title,
      description: rulesT.description,
      children: [
        _DividedCard(
          children: [
            for (final taskType in orchRuleLanes)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 128,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _taskTypeLabel(t, taskType),
                            style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          Text(taskType, style: monoStyle(c.mutedForeground, size: 10)),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          final list = draft.rules[taskType] ?? const [];
                          return _OrderedEditor(
                            entries: [
                              for (final id in list)
                                (
                                  id: id,
                                  content: poolById[id] != null
                                      ? _CandidateChip(candidate: poolById[id]!)
                                      : Text(
                                          '$id ${rulesT.missing}',
                                          overflow: TextOverflow.ellipsis,
                                          style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                                        ),
                                ),
                            ],
                            onMove: (index, dir) {
                              final next = [...list];
                              final entry = next.removeAt(index);
                              next.insert(index + dir, entry);
                              updateRule(taskType, next);
                            },
                            onRemove: (id) => updateRule(taskType, [
                              for (final x in list)
                                if (x != id) x,
                            ]),
                            addOptions: [
                              for (final cand in draft.pool)
                                if (!list.contains(cand.id))
                                  (
                                    value: cand.id,
                                    label:
                                        '${cand.label.isEmpty ? cand.model : cand.label}'
                                        ' · ${_tierLabel(t, cand.tier)}',
                                  ),
                            ],
                            addPlaceholder: rulesT.addCandidate,
                            onAdd: (id) => updateRule(taskType, [...list, id]),
                            emptyLabel: rulesT.empty,
                            removeTooltip: rulesT.remove,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// PlannerSection — planning mode, planner lane, confirm gate, checkpoints
/// and the pipeline-template editor.
class _PlannerSection extends ConsumerWidget {
  const _PlannerSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final plannerT = t.settings.orchestration.planner;
    final draft = ref.watch(orchestratorConfigProvider).draft!;
    final ctrl = ref.read(orchestratorConfigProvider.notifier);
    final planner = draft.planner;

    String modeLabel(String mode) => switch (mode) {
      'auto' => plannerT.modes.auto,
      'template' => plannerT.modes.template,
      _ => plannerT.modes.off,
    };

    String modeHint(String mode) => switch (mode) {
      'auto' => plannerT.modeHints.auto,
      'template' => plannerT.modeHints.template,
      _ => plannerT.modeHints.off,
    };

    return SettingsSectionBlock(
      title: plannerT.title,
      description: plannerT.description,
      children: [
        _DividedCard(
          children: [
            SettingsRow(
              label: plannerT.modeLabel,
              description: modeHint(planner.mode),
              child: SegmentedButton<String>(
                showSelectedIcon: false,
                segments: [
                  for (final mode in orchPlannerModes)
                    ButtonSegment(value: mode, label: Text(modeLabel(mode))),
                ],
                selected: {planner.mode},
                onSelectionChanged: (s) =>
                    ctrl.update((d) => d.copyWith(planner: planner.copyWith(mode: s.first))),
              ),
            ),
            SettingsRow(
              label: plannerT.candidateLabel,
              description: plannerT.candidateDescription,
              child: SizedBox(
                width: 224,
                child: _FieldSelect<String>(
                  value: planner.candidateId,
                  enabled: planner.mode != 'off',
                  hint: plannerT.candidatePlaceholder,
                  items: [
                    DropdownMenuItem(value: '', child: Text(plannerT.candidatePlaceholder)),
                    for (final cand in draft.pool)
                      DropdownMenuItem(
                        value: cand.id,
                        child: Text(
                          cand.label.isEmpty ? cand.model : cand.label,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (v) => ctrl.update(
                    (d) => d.copyWith(planner: planner.copyWith(candidateId: v ?? '')),
                  ),
                ),
              ),
            ),
            SettingsRow(
              label: plannerT.requireConfirm,
              description: plannerT.requireConfirmDescription,
              child: Switch(
                value: planner.requireConfirm,
                onChanged: planner.mode == 'off'
                    ? null
                    : (v) => ctrl.update(
                        (d) => d.copyWith(planner: planner.copyWith(requireConfirm: v)),
                      ),
              ),
            ),
            // Checkpoint policy — server `planner.checkpoint` (auto mode only).
            SettingsRow(
              label: plannerT.checkpointLabel,
              description: switch (planner.checkpoint.mode) {
                'per-step' => plannerT.checkpointHints.perStep,
                'every-n' => plannerT.checkpointHints.everyN,
                _ => plannerT.checkpointHints.off,
              },
              child: SegmentedButton<String>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: 'off', label: Text(plannerT.checkpointModes.off)),
                  ButtonSegment(value: 'per-step', label: Text(plannerT.checkpointModes.perStep)),
                  ButtonSegment(value: 'every-n', label: Text(plannerT.checkpointModes.everyN)),
                ],
                selected: {planner.checkpoint.mode},
                onSelectionChanged: planner.mode == 'off'
                    ? null
                    : (s) => ctrl.update(
                        (d) => d.copyWith(
                          planner: planner.copyWith(
                            checkpoint: planner.checkpoint.copyWith(mode: s.first),
                          ),
                        ),
                      ),
              ),
            ),
            if (planner.checkpoint.mode == 'every-n')
              SettingsRow(
                label: plannerT.checkpointIntervalLabel,
                description: plannerT.checkpointHints.everyN,
                child: _IntField(
                  value: planner.checkpoint.interval,
                  min: 1,
                  max: 50,
                  onChanged: (v) => ctrl.update(
                    (d) => d.copyWith(
                      planner: planner.copyWith(
                        checkpoint: planner.checkpoint.copyWith(interval: v),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: Text(
                plannerT.templates.title.toUpperCase(),
                style: tt.labelSmall?.copyWith(
                  color: c.mutedForeground,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            AppButton(
              variant: AppButtonVariant.outline,
              size: AppButtonSize.sm,
              onPressed: () => ctrl.update(
                (d) => d.copyWith(
                  planner: planner.copyWith(
                    templates: [
                      ...planner.templates,
                      const OrchTemplate(name: '', steps: ['code', 'test', 'review']),
                    ],
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.plus, size: 14),
                  const SizedBox(width: AppSpacing.xs),
                  Text(plannerT.templates.add),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        if (planner.templates.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              border: Border.all(color: c.border),
              borderRadius: AppRadii.borderLg,
            ),
            child: Text(
              plannerT.templates.empty,
              textAlign: TextAlign.center,
              style: tt.bodySmall?.copyWith(color: c.mutedForeground),
            ),
          ),

        for (var i = 0; i < planner.templates.length; i++)
          _TemplateCard(
            template: planner.templates[i],
            index: i,
            onChange: (next) => ctrl.update(
              (d) => d.copyWith(
                planner: planner.copyWith(
                  templates: [
                    for (var j = 0; j < planner.templates.length; j++)
                      if (j == i) next else planner.templates[j],
                  ],
                ),
              ),
            ),
            onRemove: () => ctrl.update(
              (d) => d.copyWith(
                planner: planner.copyWith(
                  templates: [
                    for (var j = 0; j < planner.templates.length; j++)
                      if (j != i) planner.templates[j],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// One pipeline template — name input, delete, and the step ordered editor.
class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.template,
    required this.index,
    required this.onChange,
    required this.onRemove,
  });

  final OrchTemplate template;
  final int index;
  final ValueChanged<OrchTemplate> onChange;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final templatesT = t.settings.orchestration.planner.templates;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: c.card.withValues(alpha: 0.5),
          border: Border.all(color: c.border),
          borderRadius: AppRadii.borderLg,
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _DraftInput(
                    value: template.name,
                    hint: templatesT.namePlaceholder,
                    mono: true,
                    onChanged: (v) => onChange(template.copyWith(name: v)),
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.trash2, size: 14),
                  tooltip: templatesT.remove,
                  onPressed: onRemove,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            _OrderedEditor(
              entries: [
                for (var i = 0; i < template.steps.length; i++)
                  (
                    // Steps may repeat a task type — the key needs the index.
                    id: '$index-$i-${template.steps[i]}',
                    content: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: _taskTypeLabel(t, template.steps[i]),
                            style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: ' ${template.steps[i]}',
                            style: monoStyle(c.mutedForeground, size: 10),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
              onMove: (i, dir) {
                final next = [...template.steps];
                final entry = next.removeAt(i);
                next.insert(i + dir, entry);
                onChange(template.copyWith(steps: next));
              },
              onRemove: (entryId) {
                // Entry ids are '<templateIndex>-<stepIndex>-<stepType>' —
                // parse the step index back out.
                final stepIndex = int.tryParse(entryId.split('-').elementAt(1)) ?? -1;
                if (stepIndex >= 0 && stepIndex < template.steps.length) {
                  onChange(
                    template.copyWith(
                      steps: [
                        for (var j = 0; j < template.steps.length; j++)
                          if (j != stepIndex) template.steps[j],
                      ],
                    ),
                  );
                }
              },
              addOptions: [
                for (final type in orchTemplateStepTypes)
                  (value: type, label: _taskTypeLabel(t, type)),
              ],
              addPlaceholder: templatesT.addStep,
              onAdd: (type) => onChange(template.copyWith(steps: [...template.steps, type])),
              emptyLabel: templatesT.emptySteps,
              removeTooltip: templatesT.removeStep,
            ),
          ],
        ),
      ),
    );
  }
}

/// ExecutionSection — parallelism cap, fix loops, empty-rule fallback, plus
/// the retry/timeout guardrails the supervised loop added server-side.
class _ExecutionSection extends ConsumerWidget {
  const _ExecutionSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final execT = t.settings.orchestration.execution;
    final draft = ref.watch(orchestratorConfigProvider).draft!;
    final ctrl = ref.read(orchestratorConfigProvider.notifier);
    final exec = draft.execution;

    void patch(OrchExecution Function(OrchExecution) change) =>
        ctrl.update((d) => d.copyWith(execution: change(exec)));

    Widget intSelect(int value, List<int> options, ValueChanged<int> onChanged) =>
        _FieldSelect<int>(
          value: value,
          items: [for (final v in options) DropdownMenuItem(value: v, child: Text('$v'))],
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        );

    return SettingsSectionBlock(
      title: execT.title,
      description: execT.description,
      children: [
        _DividedCard(
          children: [
            SettingsRow(
              label: execT.maxParallel,
              description: execT.maxParallelDescription,
              child: intSelect(exec.maxParallel, [
                1,
                2,
                3,
                4,
                5,
                6,
                7,
                8,
              ], (v) => patch((e) => e.copyWith(maxParallel: v))),
            ),
            SettingsRow(
              label: execT.maxFixLoops,
              description: execT.maxFixLoopsDescription,
              child: intSelect(exec.maxFixLoops, [
                0,
                1,
                2,
                3,
                4,
                5,
              ], (v) => patch((e) => e.copyWith(maxFixLoops: v))),
            ),
            SettingsRow(
              label: execT.onNoCandidate,
              description: execT.onNoCandidateDescription,
              child: _FieldSelect<String>(
                value: exec.onNoCandidate,
                items: [
                  DropdownMenuItem(value: 'ask', child: Text(execT.onNoCandidateOptions.ask)),
                  DropdownMenuItem(value: 'skip', child: Text(execT.onNoCandidateOptions.skip)),
                ],
                onChanged: (v) {
                  if (v != null) {
                    patch((e) => e.copyWith(onNoCandidate: v));
                  }
                },
              ),
            ),
            SettingsRow(
              label: execT.useWorktree,
              description: execT.useWorktreeDescription,
              child: Switch(
                value: exec.useWorktree,
                onChanged: (v) => patch((e) => e.copyWith(useWorktree: v)),
              ),
            ),
            SettingsRow(
              label: execT.maxAttempts,
              description: execT.maxAttemptsDescription,
              child: _IntField(
                value: exec.maxAttempts,
                min: 1,
                max: 50,
                onChanged: (v) => patch((e) => e.copyWith(maxAttempts: v)),
              ),
            ),
            SettingsRow(
              label: execT.stepTimeoutMs,
              description: execT.stepTimeoutMsDescription,
              child: _IntField(
                value: exec.stepTimeoutMs,
                min: 0,
                max: 86400000,
                onChanged: (v) => patch((e) => e.copyWith(stepTimeoutMs: v)),
              ),
            ),
            SettingsRow(
              label: execT.runTimeoutMs,
              description: execT.runTimeoutMsDescription,
              child: _IntField(
                value: exec.runTimeoutMs,
                min: 0,
                max: 86400000,
                onChanged: (v) => patch((e) => e.copyWith(runTimeoutMs: v)),
              ),
            ),
            SettingsRow(
              label: execT.maxSupervisorIterations,
              description: execT.maxSupervisorIterationsDescription,
              child: _IntField(
                value: exec.maxSupervisorIterations,
                min: 1,
                max: 100,
                onChanged: (v) => patch((e) => e.copyWith(maxSupervisorIterations: v)),
              ),
            ),
            SettingsRow(
              label: execT.retryBackoffBaseMs,
              description: execT.retryBackoffBaseMsDescription,
              child: _IntField(
                value: exec.retryBackoffBaseMs,
                min: 0,
                max: 600000,
                onChanged: (v) => patch((e) => e.copyWith(retryBackoffBaseMs: v)),
              ),
            ),
          ],
        ),

        // Same-lane retry budget per failure class — the circuit breaker
        // cools the lane once the budget is spent.
        const SizedBox(height: AppSpacing.md),
        _DividedCard(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  execT.retryBudgetTitle.toUpperCase(),
                  style: tt.labelSmall?.copyWith(
                    color: c.mutedForeground,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            for (final cls in orchFailureClasses)
              SettingsRow(
                label: _failureClassLabel(execT, cls),
                description: execT.retryBudgetDescription,
                child: intSelect(exec.retry[cls] ?? 0, [
                  0,
                  1,
                  2,
                  3,
                  4,
                  5,
                ], (v) => patch((e) => e.copyWith(retry: {...e.retry, cls: v}))),
              ),
          ],
        ),
      ],
    );
  }
}
