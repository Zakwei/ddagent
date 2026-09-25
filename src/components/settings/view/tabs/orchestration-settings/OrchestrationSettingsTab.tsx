import { Check, Loader2, RotateCcw, Save } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import { Button } from '../../../../../shared/view/ui';
import SettingsCard from '../../SettingsCard';
import SettingsRow from '../../SettingsRow';
import SettingsSection from '../../SettingsSection';
import SettingsToggle from '../../SettingsToggle';

import CandidatePoolSection from './sections/CandidatePoolSection';
import ExecutionSection from './sections/ExecutionSection';
import PlannerSection from './sections/PlannerSection';
import RoutingRulesSection from './sections/RoutingRulesSection';
import type { OrchestratorCandidate } from './types';
import { ORCHESTRATOR_TASK_TYPES } from './types';
import { useOrchestratorConfig } from './useOrchestratorConfig';

/**
 * Orchestration settings: the candidate pool, per-task-type routing rules,
 * planner behaviour and execution limits behind a single enabled flag.
 * Everything is a local draft until the sticky Save bar persists it via
 * PUT /api/orchestrator/config.
 */
export default function OrchestrationSettingsTab() {
  const { t } = useTranslation('settings');
  const {
    config,
    update,
    loading,
    loadFailed,
    reload,
    saving,
    dirty,
    error,
    notice,
    save,
    discard,
    modelCatalog,
    accounts,
  } = useOrchestratorConfig();

  if (loading) {
    return (
      <div className="flex items-center gap-2 py-10 text-sm text-muted-foreground">
        <Loader2 className="h-4 w-4 animate-spin" />
        {t('orchestration.loading')}
      </div>
    );
  }

  if (loadFailed || !config) {
    return (
      <div className="space-y-3 py-10 text-center">
        <p className="text-sm text-muted-foreground">{t('orchestration.loadError')}</p>
        <Button type="button" variant="outline" size="sm" onClick={() => void reload()}>
          <RotateCcw className="mr-1 h-4 w-4" />
          {t('orchestration.retry')}
        </Button>
      </div>
    );
  }

  /**
   * Pool edits cascade: a removed candidate must disappear from every rule and
   * from planner.candidateId, or the server-side validation rejects the save.
   */
  const handlePoolChange = (nextPool: OrchestratorCandidate[]) => {
    update((current) => {
      const poolIds = new Set(nextPool.map((candidate) => candidate.id));
      const rules = { ...current.rules };
      for (const taskType of ORCHESTRATOR_TASK_TYPES) {
        rules[taskType] = (rules[taskType] ?? []).filter((id) => poolIds.has(id));
      }
      const plannerCandidateId = poolIds.has(current.planner.candidateId)
        ? current.planner.candidateId
        : (nextPool[0]?.id ?? '');
      return {
        ...current,
        pool: nextPool,
        rules,
        planner: { ...current.planner, candidateId: plannerCandidateId },
      };
    });
  };

  return (
    <div className="space-y-8">
      <SettingsSection
        title={t('orchestration.title')}
        description={t('orchestration.description')}
      >
        <SettingsCard>
          <SettingsRow
            label={t('orchestration.enable.label')}
            description={t('orchestration.enable.description')}
          >
            <SettingsToggle
              checked={config.enabled}
              onChange={(enabled) => update((current) => ({ ...current, enabled }))}
              ariaLabel={t('orchestration.enable.label')}
            />
          </SettingsRow>
        </SettingsCard>
      </SettingsSection>

      <CandidatePoolSection
        pool={config.pool}
        modelCatalog={modelCatalog}
        accounts={accounts}
        onChange={handlePoolChange}
      />

      <RoutingRulesSection
        rules={config.rules}
        pool={config.pool}
        onChange={(rules) => update((current) => ({ ...current, rules }))}
      />

      <PlannerSection
        planner={config.planner}
        pool={config.pool}
        onChange={(planner) => update((current) => ({ ...current, planner }))}
      />

      <ExecutionSection
        execution={config.execution}
        onChange={(execution) => update((current) => ({ ...current, execution }))}
      />

      {/* Sticky save bar — spans the padded content column edge to edge. */}
      <div className="sticky bottom-0 -mx-4 -mb-4 flex items-center justify-between gap-3 border-t border-border bg-background/95 px-4 py-3 backdrop-blur md:-mx-6 md:-mb-6 md:px-6">
        <div className="min-w-0 flex-1 text-xs">
          {error ? (
            <span className="text-destructive">
              {t('orchestration.save.error')}: {error}
            </span>
          ) : config.pool.length === 0 ? (
            // planner.candidateId must reference a pool member, so an empty
            // pool can never validate — flag it here instead of on the server.
            <span className="text-destructive">{t('orchestration.save.emptyPool')}</span>
          ) : notice ? (
            <span className="flex items-center gap-1 text-emerald-600 dark:text-emerald-400">
              <Check className="h-3.5 w-3.5" />
              {t('orchestration.save.saved')}
            </span>
          ) : dirty ? (
            <span className="text-muted-foreground">{t('orchestration.save.unsaved')}</span>
          ) : (
            <span />
          )}
        </div>
        <div className="flex flex-shrink-0 items-center gap-2">
          <Button
            type="button"
            variant="ghost"
            size="sm"
            onClick={discard}
            disabled={!dirty || saving}
          >
            {t('orchestration.save.discard')}
          </Button>
          <Button
            type="button"
            size="sm"
            onClick={() => void save()}
            disabled={!dirty || saving || config.pool.length === 0}
          >
            {saving ? (
              <Loader2 className="mr-1 h-4 w-4 animate-spin" />
            ) : (
              <Save className="mr-1 h-4 w-4" />
            )}
            {saving ? t('orchestration.save.saving') : t('orchestration.save.save')}
          </Button>
        </div>
      </div>
    </div>
  );
}
