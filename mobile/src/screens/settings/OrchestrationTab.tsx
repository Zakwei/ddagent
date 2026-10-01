import React from 'react';
import { ActivityIndicator, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { Check, ChevronDown, ChevronUp, Plus, RotateCcw, Save, Trash2, X } from 'lucide-react-native';

import { ActionSheet, type ActionSheetItem } from '../../components/ActionSheet';
import type { ThemeColors } from '../../theme';
import {
  loadModelCatalogs,
  loadOrchestratorConfig,
  loadProviderAccounts,
  saveOrchestratorConfig,
  ORCHESTRATOR_CHECKPOINT_MODES,
  ORCHESTRATOR_COST_TIERS,
  ORCHESTRATOR_PLANNER_MODES,
  ORCHESTRATOR_PROVIDERS,
  ORCHESTRATOR_TASK_TYPES,
  type OrchestratorCandidate,
  type OrchestratorCheckpointMode,
  type OrchestratorConfig,
  type OrchestratorCostTier,
  type OrchestratorTaskType,
} from '../../lib/orchestrator';
import type { ProviderModelOption } from '../../lib/model-menu';
import type { AgentProvider, ProviderAccountItem } from '../../lib/settings-api';
import { Btn, Field, Section, Toggle } from './kit';
import type { TabCtx } from '../SettingsTabs';

type SheetState = { title: string; items: ActionSheetItem[] } | null;

const candidateLabel = (c: OrchestratorCandidate) => c.label || c.model || c.id;

function PickerButton({
  label,
  value,
  onPress,
  colors,
  disabled,
}: {
  label: string;
  value: string;
  onPress: () => void;
  colors: ThemeColors;
  disabled?: boolean;
}) {
  return (
    <View style={{ gap: 4 }}>
      <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{label}</Text>
      <TouchableOpacity
        onPress={onPress}
        disabled={disabled}
        style={{
          flexDirection: 'row',
          alignItems: 'center',
          justifyContent: 'space-between',
          backgroundColor: colors.background,
          borderColor: colors.border,
          borderWidth: 1,
          borderRadius: 8,
          paddingHorizontal: 12,
          paddingVertical: 10,
          opacity: disabled ? 0.5 : 1,
        }}
      >
        <Text style={{ color: colors.foreground, fontSize: 14, flex: 1 }} numberOfLines={1}>
          {value}
        </Text>
        <ChevronDown size={14} color={colors.mutedForeground} />
      </TouchableOpacity>
    </View>
  );
}

/** Ordered list of entries with move/remove + an add picker. */
function OrderedEntries({
  entries,
  onMove,
  onRemove,
  onAdd,
  addOptions,
  addPlaceholder,
  emptyLabel,
  colors,
}: {
  entries: { id: string; label: string }[];
  onMove: (index: number, direction: -1 | 1) => void;
  onRemove: (id: string) => void;
  onAdd: (value: string) => void;
  addOptions: { value: string; label: string }[];
  addPlaceholder: string;
  emptyLabel: string;
  colors: ThemeColors;
}) {
  const [adding, setAdding] = React.useState(false);
  return (
    <View style={{ gap: 6 }}>
      {entries.length === 0 ? (
        <Text style={{ color: colors.mutedForeground, fontSize: 12, fontStyle: 'italic' }}>{emptyLabel}</Text>
      ) : (
        entries.map((entry, index) => (
          <View
            key={entry.id}
            style={{
              flexDirection: 'row',
              alignItems: 'center',
              gap: 6,
              backgroundColor: colors.background,
              borderColor: colors.border,
              borderWidth: 1,
              borderRadius: 8,
              paddingHorizontal: 10,
              paddingVertical: 8,
            }}
          >
            <Text style={{ flex: 1, color: colors.foreground, fontSize: 13 }} numberOfLines={1}>
              {entry.label}
            </Text>
            <TouchableOpacity accessibilityRole="button" accessibilityLabel="Move up" disabled={index === 0} onPress={() => onMove(index, -1)} hitSlop={6} style={{ opacity: index === 0 ? 0.3 : 1 }}>
              <ChevronUp size={15} color={colors.mutedForeground} />
            </TouchableOpacity>
            <TouchableOpacity
              accessibilityRole="button"
              accessibilityLabel="Move down"
              disabled={index === entries.length - 1}
              onPress={() => onMove(index, 1)}
              hitSlop={6}
              style={{ opacity: index === entries.length - 1 ? 0.3 : 1 }}
            >
              <ChevronDown size={15} color={colors.mutedForeground} />
            </TouchableOpacity>
            <TouchableOpacity accessibilityRole="button" accessibilityLabel="Remove" onPress={() => onRemove(entry.id)} hitSlop={6}>
              <X size={15} color={colors.destructive} />
            </TouchableOpacity>
          </View>
        ))
      )}
      {addOptions.length > 0 ? (
        <TouchableOpacity
          onPress={() => setAdding(true)}
          style={{ flexDirection: 'row', alignItems: 'center', gap: 4, alignSelf: 'flex-start', paddingVertical: 4 }}
        >
          <Plus size={14} color={colors.primary} />
          <Text style={{ color: colors.primary, fontSize: 13, fontWeight: '600' }}>{addPlaceholder}</Text>
        </TouchableOpacity>
      ) : null}
      <ActionSheet
        visible={adding}
        title={addPlaceholder}
        items={addOptions.map((option) => ({
          label: option.label,
          onPress: () => onAdd(option.value),
        }))}
        onClose={() => setAdding(false)}
      />
    </View>
  );
}

/**
 * Native port of the web OrchestrationSettingsTab: candidate pool, per-task-type
 * routing rules, planner behaviour and execution guardrails behind one enable
 * flag. Everything is a local draft until Save pushes PUT /orchestrator/config.
 */
export function OrchestrationTab({ ctx }: { ctx: TabCtx }) {
  const { colors, t } = ctx;
  const [config, setConfig] = React.useState<OrchestratorConfig | null>(null);
  const [savedConfig, setSavedConfig] = React.useState<OrchestratorConfig | null>(null);
  const [loading, setLoading] = React.useState(true);
  const [loadFailed, setLoadFailed] = React.useState(false);
  const [saving, setSaving] = React.useState(false);
  const [error, setError] = React.useState<string | null>(null);
  const [notice, setNotice] = React.useState(false);
  const [modelCatalog, setModelCatalog] = React.useState<Partial<Record<AgentProvider, ProviderModelOption[]>>>({});
  const [accounts, setAccounts] = React.useState<ProviderAccountItem[]>([]);
  const [sheet, setSheet] = React.useState<SheetState>(null);
  const idCounter = React.useRef(0);

  const load = React.useCallback(async () => {
    setLoading(true);
    setLoadFailed(false);
    try {
      const next = await loadOrchestratorConfig();
      setConfig(next);
      setSavedConfig(next);
    } catch {
      setLoadFailed(true);
    } finally {
      setLoading(false);
    }
  }, []);

  React.useEffect(() => {
    void load();
    void loadModelCatalogs().then(setModelCatalog);
    void loadProviderAccounts().then(setAccounts);
  }, [load]);

  const dirty = Boolean(config && savedConfig && JSON.stringify(config) !== JSON.stringify(savedConfig));

  const update = (recipe: (draft: OrchestratorConfig) => OrchestratorConfig) => {
    setConfig((current) => (current ? recipe(current) : current));
    setNotice(false);
  };

  const save = async () => {
    if (!config || saving) return;
    setSaving(true);
    setError(null);
    try {
      const saved = await saveOrchestratorConfig(config);
      setConfig(saved);
      setSavedConfig(saved);
      setNotice(true);
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : 'Failed to save orchestration settings');
    } finally {
      setSaving(false);
    }
  };

  if (loading) {
    return (
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingVertical: 32 }}>
        <ActivityIndicator color={colors.primary} />
        <Text style={{ color: colors.mutedForeground }}>{t('orchestration.loading', 'Loading orchestration settings…')}</Text>
      </View>
    );
  }

  if (loadFailed || !config) {
    return (
      <View style={{ alignItems: 'center', gap: 12, paddingVertical: 32 }}>
        <Text style={{ color: colors.mutedForeground }}>{t('orchestration.loadError', 'Could not load orchestration settings.')}</Text>
        <Btn
          label={t('orchestration.retry', 'Retry')}
          onPress={() => void load()}
          colors={colors}
          variant="outline"
          icon={<RotateCcw size={14} color={colors.foreground} />}
        />
      </View>
    );
  }

  /* Pool edits cascade into rules + planner, or the server rejects the save. */
  const setPool = (nextPool: OrchestratorCandidate[]) => {
    update((current) => {
      const poolIds = new Set(nextPool.map((c) => c.id));
      const rules = { ...current.rules };
      for (const taskType of ORCHESTRATOR_TASK_TYPES) {
        rules[taskType] = (rules[taskType] ?? []).filter((id) => poolIds.has(id));
      }
      return {
        ...current,
        pool: nextPool,
        rules,
        planner: {
          ...current.planner,
          candidateId: poolIds.has(current.planner.candidateId) ? current.planner.candidateId : (nextPool[0]?.id ?? ''),
        },
      };
    });
  };

  const updateCandidate = (id: string, patch: Partial<OrchestratorCandidate>) => {
    setPool(config.pool.map((c) => (c.id === id ? { ...c, ...patch } : c)));
  };

  const accountsFor = (provider: AgentProvider) => accounts.filter((a) => a.provider === provider);

  const pick = (title: string, options: { label: string; value: string }[], onPick: (value: string) => void) => {
    setSheet({ title, items: options.map((o) => ({ label: o.label, onPress: () => onPick(o.value) })) });
  };

  const providerLabel = (id: AgentProvider) => ORCHESTRATOR_PROVIDERS.find((p) => p.id === id)?.label ?? id;

  return (
    <View style={{ gap: 0 }}>
      <Section title={t('orchestration.title', 'Orchestration')} colors={colors}>
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>
          {t('orchestration.description', 'Delegate work across multiple model endpoints with a planner, routing rules and a candidate pool.')}
        </Text>
        <Toggle
          label={t('orchestration.enable.label', 'Enable orchestration')}
          description={t('orchestration.enable.description', 'Route matching requests through the planner and candidate pool.')}
          value={config.enabled}
          onValueChange={(enabled) => update((c) => ({ ...c, enabled }))}
          colors={colors}
        />
      </Section>

      {/* ------------------------------------------------------------- pool */}
      <Section title={t('orchestration.pool.title', 'Candidate pool')} colors={colors}>
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>
          {t('orchestration.pool.description', 'Model endpoints the router can pick from. Each row pins provider/model/effort/account to a cost tier.')}
        </Text>
        {config.pool.length === 0 ? (
          <Text style={{ color: colors.mutedForeground, fontSize: 13, textAlign: 'center', paddingVertical: 12 }}>
            {t('orchestration.pool.empty', 'No candidates yet. Add one to start routing.')}
          </Text>
        ) : null}
        {config.pool.map((candidate, index) => {
          const modelOptions = modelCatalog[candidate.provider] ?? [];
          const selectedOption = modelOptions.find((o) => o.value === candidate.model);
          const effortValues = selectedOption?.effort?.values ?? [];
          const providerAccounts = accountsFor(candidate.provider);
          return (
            <View
              key={candidate.id}
              style={{ borderColor: colors.border, borderWidth: 1, borderRadius: 10, padding: 10, gap: 8 }}
            >
              <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
                <TextInput
                  value={candidate.label}
                  onChangeText={(label) => updateCandidate(candidate.id, { label })}
                  placeholder={t('orchestration.pool.fields.labelPlaceholder', 'Label (optional)')}
                  placeholderTextColor={colors.mutedForeground}
                  style={{ flex: 1, color: colors.foreground, fontSize: 14, fontWeight: '600', paddingVertical: 4 }}
                />
                <TouchableOpacity
                  accessibilityRole="button"
                  accessibilityLabel="Move up"
                  disabled={index === 0}
                  onPress={() => {
                    const next = [...config.pool];
                    const [entry] = next.splice(index, 1);
                    next.splice(index - 1, 0, entry);
                    setPool(next);
                  }}
                  hitSlop={6}
                  style={{ opacity: index === 0 ? 0.3 : 1 }}
                >
                  <ChevronUp size={16} color={colors.mutedForeground} />
                </TouchableOpacity>
                <TouchableOpacity
                  accessibilityRole="button"
                  accessibilityLabel="Move down"
                  disabled={index === config.pool.length - 1}
                  onPress={() => {
                    const next = [...config.pool];
                    const [entry] = next.splice(index, 1);
                    next.splice(index + 1, 0, entry);
                    setPool(next);
                  }}
                  hitSlop={6}
                  style={{ opacity: index === config.pool.length - 1 ? 0.3 : 1 }}
                >
                  <ChevronDown size={16} color={colors.mutedForeground} />
                </TouchableOpacity>
                <TouchableOpacity accessibilityRole="button" accessibilityLabel="Remove" onPress={() => setPool(config.pool.filter((c) => c.id !== candidate.id))} hitSlop={6}>
                  <Trash2 size={15} color={colors.destructive} />
                </TouchableOpacity>
              </View>

              <PickerButton
                label={t('orchestration.pool.fields.provider', 'Provider')}
                value={providerLabel(candidate.provider)}
                colors={colors}
                onPress={() =>
                  pick(
                    t('orchestration.pool.fields.provider', 'Provider'),
                    ORCHESTRATOR_PROVIDERS.map((p) => ({ label: p.label, value: p.id })),
                    (value) =>
                      updateCandidate(candidate.id, {
                        provider: value as AgentProvider,
                        model: '',
                        effort: null,
                        accountId: null,
                      }),
                  )
                }
              />
              <PickerButton
                label={t('orchestration.pool.fields.model', 'Model')}
                value={selectedOption?.label || candidate.model || t('orchestration.pool.fields.modelPlaceholder', 'Select a model')}
                colors={colors}
                onPress={() => {
                  const options = modelOptions.map((o) => ({ label: o.label, value: o.value }));
                  if (candidate.model && !selectedOption) options.unshift({ label: candidate.model, value: candidate.model });
                  pick(t('orchestration.pool.fields.model', 'Model'), options, (value) =>
                    updateCandidate(candidate.id, { model: value, effort: null }),
                  );
                }}
              />
              {effortValues.length > 0 ? (
                <PickerButton
                  label={t('orchestration.pool.fields.effort', 'Effort')}
                  value={candidate.effort || t('orchestration.pool.fields.effortDefault', 'Default')}
                  colors={colors}
                  onPress={() =>
                    pick(
                      t('orchestration.pool.fields.effort', 'Effort'),
                      [
                        { label: t('orchestration.pool.fields.effortDefault', 'Default'), value: '' },
                        ...effortValues.map((e) => ({ label: e.value, value: e.value })),
                      ],
                      (value) => updateCandidate(candidate.id, { effort: value || null }),
                    )
                  }
                />
              ) : (
                <Field
                  label={t('orchestration.pool.fields.effort', 'Effort')}
                  value={candidate.effort ?? ''}
                  onChangeText={(v) => updateCandidate(candidate.id, { effort: v.trim() || null })}
                  placeholder={t('orchestration.pool.fields.effortPlaceholder', 'e.g. high')}
                  colors={colors}
                />
              )}
              <PickerButton
                label={t('orchestration.pool.fields.account', 'Account')}
                value={
                  providerAccounts.find((a) => a.id === candidate.accountId)?.label ??
                  t('orchestration.pool.fields.accountDefault', 'Provider default')
                }
                colors={colors}
                onPress={() =>
                  pick(
                    t('orchestration.pool.fields.account', 'Account'),
                    [
                      { label: t('orchestration.pool.fields.accountDefault', 'Provider default'), value: '' },
                      ...providerAccounts.map((a) => ({
                        label: a.isDefault ? `${a.label} (${t('orchestration.pool.fields.accountDefault', 'Provider default')})` : a.label,
                        value: a.id,
                      })),
                    ],
                    (value) => updateCandidate(candidate.id, { accountId: value || null }),
                  )
                }
              />
              <PickerButton
                label={t('orchestration.pool.fields.tier', 'Cost tier')}
                value={t(`orchestration.tiers.${candidate.tier}`, candidate.tier)}
                colors={colors}
                onPress={() =>
                  pick(
                    t('orchestration.pool.fields.tier', 'Cost tier'),
                    ORCHESTRATOR_COST_TIERS.map((tier) => ({ label: t(`orchestration.tiers.${tier}`, tier), value: tier })),
                    (value) => updateCandidate(candidate.id, { tier: value as OrchestratorCostTier }),
                  )
                }
              />
            </View>
          );
        })}
        <Btn
          label={t('orchestration.pool.add', 'Add candidate')}
          onPress={() => {
            idCounter.current += 1;
            setPool([
              ...config.pool,
              {
                id: `cand-${Date.now().toString(36)}-${idCounter.current}`,
                provider: 'claude',
                model: '',
                effort: null,
                accountId: null,
                tier: 'mid',
                label: '',
              },
            ]);
          }}
          colors={colors}
          variant="outline"
          icon={<Plus size={14} color={colors.foreground} />}
        />
      </Section>

      {/* --------------------------------------------------------- routing */}
      <Section title={t('orchestration.rules.title', 'Routing rules')} colors={colors}>
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>
          {t('orchestration.rules.description', 'Ordered candidates per task type — the first reachable candidate wins.')}
        </Text>
        {ORCHESTRATOR_TASK_TYPES.map((taskType) => {
          const list = config.rules[taskType] ?? [];
          const available = config.pool.filter((c) => !list.includes(c.id));
          return (
            <View key={taskType} style={{ gap: 6, paddingVertical: 8, borderTopWidth: taskType === 'plan' ? 0 : 1, borderTopColor: colors.border }}>
              <Text style={{ color: colors.foreground, fontSize: 13, fontWeight: '600' }}>
                {t(`orchestration.rules.taskTypes.${taskType}`, taskType)}{' '}
                <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace' }}>{taskType}</Text>
              </Text>
              <OrderedEntries
                colors={colors}
                entries={list.map((id) => {
                  const candidate = config.pool.find((c) => c.id === id);
                  return {
                    id,
                    label: candidate
                      ? `${candidateLabel(candidate)} · ${t(`orchestration.tiers.${candidate.tier}`, candidate.tier)}`
                      : `${id} ${t('orchestration.rules.missing', '(removed)')}`,
                  };
                })}
                onMove={(index, direction) => {
                  const next = [...list];
                  const [entry] = next.splice(index, 1);
                  next.splice(index + direction, 0, entry);
                  update((c) => ({ ...c, rules: { ...c.rules, [taskType]: next } }));
                }}
                onRemove={(id) => update((c) => ({ ...c, rules: { ...c.rules, [taskType]: list.filter((v) => v !== id) } }))}
                addOptions={available.map((c) => ({ value: c.id, label: `${candidateLabel(c)} · ${t(`orchestration.tiers.${c.tier}`, c.tier)}` }))}
                addPlaceholder={t('orchestration.rules.addCandidate', 'Add candidate')}
                onAdd={(id) => update((c) => ({ ...c, rules: { ...c.rules, [taskType]: [...list, id] } }))}
                emptyLabel={t('orchestration.rules.empty', 'No candidates — falls back to the default provider.')}
              />
            </View>
          );
        })}
      </Section>

      {/* ---------------------------------------------------------- planner */}
      <Section title={t('orchestration.planner.title', 'Planner')} colors={colors}>
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>
          {t(`orchestration.planner.modeHints.${config.planner.mode}`, config.planner.mode)}
        </Text>
        <View style={{ flexDirection: 'row', gap: 8 }}>
          {ORCHESTRATOR_PLANNER_MODES.map((mode) => (
            <TouchableOpacity
              key={mode}
              onPress={() => update((c) => ({ ...c, planner: { ...c.planner, mode } }))}
              style={{
                backgroundColor: config.planner.mode === mode ? colors.primary : colors.secondary,
                borderRadius: 8,
                paddingHorizontal: 14,
                paddingVertical: 8,
              }}
            >
              <Text
                style={{
                  color: config.planner.mode === mode ? colors.primaryForeground : colors.secondaryForeground,
                  fontSize: 13,
                }}
              >
                {t(`orchestration.planner.modes.${mode}`, mode)}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
        <PickerButton
          label={t('orchestration.planner.candidateLabel', 'Legacy planner model')}
          value={
            config.pool.find((c) => c.id === config.planner.candidateId)
              ? candidateLabel(config.pool.find((c) => c.id === config.planner.candidateId)!)
              : t('orchestration.planner.candidatePlaceholder', 'Select a candidate')
          }
          colors={colors}
          disabled={config.planner.mode === 'off'}
          onPress={() =>
            pick(
              t('orchestration.planner.candidateLabel', 'Planning candidate'),
              config.pool.map((c) => ({ label: candidateLabel(c), value: c.id })),
              (value) => update((c) => ({ ...c, planner: { ...c.planner, candidateId: value } })),
            )
          }
        />
        <Toggle
          label={t('orchestration.planner.requireConfirm', 'Confirm goals before the run starts')}
          description={t('orchestration.planner.requireConfirmDescription', 'Pause after planning so you can approve the goal contract or edit/disable steps on the plan card.')}
          value={config.planner.requireConfirm}
          onValueChange={(requireConfirm) => update((c) => ({ ...c, planner: { ...c.planner, requireConfirm } }))}
          colors={colors}
        />
        <PickerButton
          label={t('orchestration.planner.checkpointLabel', 'Autonomy')}
          value={t(`orchestration.planner.checkpointModes.${config.planner.checkpoint?.mode ?? 'off'}`, 'Autonomous')}
          colors={colors}
          disabled={config.planner.mode !== 'auto'}
          onPress={() =>
            pick(
              t('orchestration.planner.checkpointLabel', 'Autonomy'),
              ORCHESTRATOR_CHECKPOINT_MODES.map((mode) => ({
                label: t(`orchestration.planner.checkpointModes.${mode}`, mode),
                value: mode,
              })),
              (value) =>
                update((c) => ({
                  ...c,
                  planner: {
                    ...c.planner,
                    checkpoint: {
                      ...(c.planner.checkpoint ?? { mode: 'off', interval: 5 }),
                      mode: value as OrchestratorCheckpointMode,
                    },
                  },
                })),
            )
          }
        />
        {config.planner.mode === 'auto' ? (
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>
            {t(
              `orchestration.planner.checkpointHints.${config.planner.checkpoint?.mode ?? 'off'}`,
              'Supervisor decisions run without asking (auto mode).',
            )}
          </Text>
        ) : null}
        {(config.planner.checkpoint?.mode ?? 'off') === 'every-n' ? (
          <PickerButton
            label={t('orchestration.planner.checkpointIntervalLabel', 'Steps between checkpoints (1–50)')}
            value={String(config.planner.checkpoint?.interval ?? 5)}
            colors={colors}
            onPress={() =>
              pick(
                t('orchestration.planner.checkpointIntervalLabel', 'Steps between checkpoints (1–50)'),
                [1, 2, 3, 5, 10, 15, 25, 50].map((v) => ({ label: String(v), value: String(v) })),
                (value) =>
                  update((c) => ({
                    ...c,
                    planner: {
                      ...c.planner,
                      checkpoint: {
                        ...(c.planner.checkpoint ?? { mode: 'every-n', interval: 5 }),
                        interval: Number(value),
                      },
                    },
                  })),
              )
            }
          />
        ) : null}

        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', marginTop: 4 }}>
          <Text style={{ color: colors.mutedForeground, fontSize: 12, fontWeight: '600', textTransform: 'uppercase' }}>
            {t('orchestration.planner.templates.title', 'Pipeline templates')}
          </Text>
          <TouchableOpacity
            onPress={() =>
              update((c) => ({
                ...c,
                planner: { ...c.planner, templates: [...c.planner.templates, { name: '', steps: ['code', 'test', 'review'] }] },
              }))
            }
            style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}
          >
            <Plus size={14} color={colors.primary} />
            <Text style={{ color: colors.primary, fontSize: 13, fontWeight: '600' }}>
              {t('orchestration.planner.templates.add', 'Add template')}
            </Text>
          </TouchableOpacity>
        </View>
        {config.planner.templates.length === 0 ? (
          <Text style={{ color: colors.mutedForeground, fontSize: 12, fontStyle: 'italic' }}>
            {t('orchestration.planner.templates.empty', 'No templates.')}
          </Text>
        ) : null}
        {config.planner.templates.map((template, index) => (
          <View key={index} style={{ borderColor: colors.border, borderWidth: 1, borderRadius: 10, padding: 10, gap: 8 }}>
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
              <TextInput
                value={template.name}
                onChangeText={(name) =>
                  update((c) => ({
                    ...c,
                    planner: {
                      ...c.planner,
                      templates: c.planner.templates.map((tpl, i) => (i === index ? { ...tpl, name } : tpl)),
                    },
                  }))
                }
                placeholder={t('orchestration.planner.templates.namePlaceholder', 'Template name')}
                placeholderTextColor={colors.mutedForeground}
                style={{ flex: 1, color: colors.foreground, fontFamily: 'monospace', fontSize: 13, paddingVertical: 4 }}
              />
              <TouchableOpacity
                accessibilityRole="button"
                accessibilityLabel="Remove template"
                onPress={() =>
                  update((c) => ({
                    ...c,
                    planner: { ...c.planner, templates: c.planner.templates.filter((_, i) => i !== index) },
                  }))
                }
                hitSlop={6}
              >
                <Trash2 size={15} color={colors.destructive} />
              </TouchableOpacity>
            </View>
            <OrderedEntries
              colors={colors}
              entries={template.steps.map((step, stepIndex) => ({
                id: `${index}-${stepIndex}-${step}`,
                label: `${t(`orchestration.rules.taskTypes.${step}`, step)} · ${step}`,
              }))}
              onMove={(stepIndex, direction) => {
                const next = [...template.steps];
                const [entry] = next.splice(stepIndex, 1);
                next.splice(stepIndex + direction, 0, entry);
                update((c) => ({
                  ...c,
                  planner: { ...c.planner, templates: c.planner.templates.map((tpl, i) => (i === index ? { ...tpl, steps: next } : tpl)) },
                }));
              }}
              onRemove={(entryId) => {
                const stepIndex = template.steps.findIndex((_, i) => `${index}-${i}-${template.steps[i]}` === entryId);
                if (stepIndex < 0) return;
                update((c) => ({
                  ...c,
                  planner: {
                    ...c.planner,
                    templates: c.planner.templates.map((tpl, i) =>
                      i === index ? { ...tpl, steps: tpl.steps.filter((_, si) => si !== stepIndex) } : tpl,
                    ),
                  },
                }));
              }}
              addOptions={ORCHESTRATOR_TASK_TYPES.map((taskType) => ({
                value: taskType,
                label: t(`orchestration.rules.taskTypes.${taskType}`, taskType),
              }))}
              addPlaceholder={t('orchestration.planner.templates.addStep', 'Add step')}
              onAdd={(value) =>
                update((c) => ({
                  ...c,
                  planner: {
                    ...c.planner,
                    templates: c.planner.templates.map((tpl, i) =>
                      i === index ? { ...tpl, steps: [...tpl.steps, value as OrchestratorTaskType] } : tpl,
                    ),
                  },
                }))
              }
              emptyLabel={t('orchestration.planner.templates.emptySteps', 'No steps.')}
            />
          </View>
        ))}
      </Section>

      {/* -------------------------------------------------------- execution */}
      <Section title={t('orchestration.execution.title', 'Execution')} colors={colors}>
        <PickerButton
          label={t('orchestration.execution.maxParallel', 'Max parallel steps')}
          value={String(config.execution.maxParallel)}
          colors={colors}
          onPress={() =>
            pick(
              t('orchestration.execution.maxParallel', 'Max parallel steps'),
              [1, 2, 3, 4, 5, 6, 7, 8].map((v) => ({ label: String(v), value: String(v) })),
              (value) => update((c) => ({ ...c, execution: { ...c.execution, maxParallel: Number(value) } })),
            )
          }
        />
        <PickerButton
          label={t('orchestration.execution.maxFixLoops', 'Max fix loops')}
          value={String(config.execution.maxFixLoops)}
          colors={colors}
          onPress={() =>
            pick(
              t('orchestration.execution.maxFixLoops', 'Max fix loops'),
              [0, 1, 2, 3, 4, 5].map((v) => ({ label: String(v), value: String(v) })),
              (value) => update((c) => ({ ...c, execution: { ...c.execution, maxFixLoops: Number(value) } })),
            )
          }
        />
        <PickerButton
          label={t('orchestration.execution.maxSupervisorIterations', 'Max supervisor iterations')}
          value={String(config.execution.maxSupervisorIterations ?? 25)}
          colors={colors}
          onPress={() =>
            pick(
              t('orchestration.execution.maxSupervisorIterations', 'Max supervisor iterations'),
              [5, 10, 25, 50, 75, 100].map((v) => ({ label: String(v), value: String(v) })),
              (value) =>
                update((c) => ({ ...c, execution: { ...c.execution, maxSupervisorIterations: Number(value) } })),
            )
          }
        />
        <PickerButton
          label={t('orchestration.execution.onNoCandidate', 'When no candidate is available')}
          value={t(`orchestration.execution.onNoCandidateOptions.${config.execution.onNoCandidate}`, config.execution.onNoCandidate)}
          colors={colors}
          onPress={() =>
            pick(
              t('orchestration.execution.onNoCandidate', 'When no candidate is available'),
              (['ask', 'skip'] as const).map((v) => ({
                label: t(`orchestration.execution.onNoCandidateOptions.${v}`, v),
                value: v,
              })),
              (value) =>
                update((c) => ({ ...c, execution: { ...c.execution, onNoCandidate: value as 'ask' | 'skip' } })),
            )
          }
        />
        <Toggle
          label={t('orchestration.execution.useWorktree', 'Shared git worktree')}
          description={t('orchestration.execution.useWorktreeDescription', 'Run delegated steps in one shared worktree per plan run.')}
          value={config.execution.useWorktree}
          onValueChange={(useWorktree) => update((c) => ({ ...c, execution: { ...c.execution, useWorktree } }))}
          colors={colors}
        />
      </Section>

      {/* ---------------------------------------------------------- save bar */}
      <View
        style={{
          flexDirection: 'row',
          alignItems: 'center',
          justifyContent: 'space-between',
          gap: 10,
          borderTopWidth: 1,
          borderTopColor: colors.border,
          paddingVertical: 12,
        }}
      >
        <View style={{ flex: 1 }}>
          {error ? (
            <Text style={{ color: colors.destructive, fontSize: 12 }}>
              {t('orchestration.save.error', 'Save failed')}: {error}
            </Text>
          ) : config.pool.length === 0 ? (
            <Text style={{ color: colors.destructive, fontSize: 12 }}>
              {t('orchestration.save.emptyPool', 'Add at least one candidate before saving.')}
            </Text>
          ) : notice ? (
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
              <Check size={13} color="#10b981" />
              <Text style={{ color: '#10b981', fontSize: 12 }}>{t('orchestration.save.saved', 'Saved')}</Text>
            </View>
          ) : dirty ? (
            <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('orchestration.save.unsaved', 'Unsaved changes')}</Text>
          ) : null}
        </View>
        <View style={{ flexDirection: 'row', gap: 8 }}>
          <Btn
            label={t('orchestration.save.discard', 'Discard')}
            onPress={() => {
              setConfig(savedConfig);
              setError(null);
              setNotice(false);
            }}
            colors={colors}
            variant="outline"
            disabled={!dirty || saving}
          />
          <Btn
            label={saving ? t('orchestration.save.saving', 'Saving…') : t('orchestration.save.save', 'Save')}
            onPress={() => void save()}
            colors={colors}
            disabled={!dirty || saving || config.pool.length === 0}
            icon={saving ? <ActivityIndicator size="small" color={colors.primaryForeground} /> : <Save size={14} color={colors.primaryForeground} />}
          />
        </View>
      </View>

      <ActionSheet visible={sheet !== null} title={sheet?.title} items={sheet?.items ?? []} onClose={() => setSheet(null)} />
    </View>
  );
}
