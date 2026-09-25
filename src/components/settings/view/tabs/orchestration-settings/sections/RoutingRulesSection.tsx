import { useMemo } from 'react';
import { useTranslation } from 'react-i18next';

import SettingsCard from '../../../SettingsCard';
import SettingsSection from '../../../SettingsSection';
import type { OrchestratorCandidate, OrchestratorTaskType } from '../types';
import { ORCHESTRATOR_TASK_TYPES } from '../types';

import { CandidateChipContent } from './CandidatePoolSection';
import { OrderedEntriesEditor } from './controls';

type RoutingRulesSectionProps = {
  rules: Record<OrchestratorTaskType, string[]>;
  pool: OrchestratorCandidate[];
  onChange: (rules: Record<OrchestratorTaskType, string[]>) => void;
};

/**
 * Per-task-type ordered candidate lists. The router walks a rule top-down and
 * dispatches on the first candidate that is reachable right now.
 */
export default function RoutingRulesSection({ rules, pool, onChange }: RoutingRulesSectionProps) {
  const { t } = useTranslation('settings');
  const poolById = useMemo(() => new Map(pool.map((candidate) => [candidate.id, candidate])), [pool]);

  const updateRule = (taskType: OrchestratorTaskType, list: string[]) => {
    onChange({ ...rules, [taskType]: list });
  };

  return (
    <SettingsSection
      title={t('orchestration.rules.title')}
      description={t('orchestration.rules.description')}
    >
      <SettingsCard divided>
        {ORCHESTRATOR_TASK_TYPES.map((taskType) => {
          const list = rules[taskType] ?? [];
          const availableOptions = pool
            .filter((candidate) => !list.includes(candidate.id))
            .map((candidate) => ({
              value: candidate.id,
              label: `${candidate.label || candidate.model} · ${t(`orchestration.tiers.${candidate.tier}`)}`,
            }));

          return (
            <div key={taskType} className="flex flex-col gap-2 px-4 py-3 sm:flex-row sm:gap-4">
              <div className="w-full flex-shrink-0 pt-0.5 sm:w-32">
                <div className="text-sm font-medium text-foreground">
                  {t(`orchestration.rules.taskTypes.${taskType}`)}
                </div>
                <div className="font-mono text-[10px] text-muted-foreground">{taskType}</div>
              </div>
              <div className="min-w-0 flex-1">
                <OrderedEntriesEditor
                  entries={list.map((candidateId) => {
                    const candidate = poolById.get(candidateId);
                    return {
                      id: candidateId,
                      content: candidate ? (
                        <CandidateChipContent candidate={candidate} />
                      ) : (
                        <span className="truncate text-muted-foreground">
                          {candidateId} {t('orchestration.rules.missing')}
                        </span>
                      ),
                    };
                  })}
                  onMove={(index, direction) => {
                    const next = [...list];
                    const [entry] = next.splice(index, 1);
                    next.splice(index + direction, 0, entry);
                    updateRule(taskType, next);
                  }}
                  onRemove={(candidateId) => updateRule(taskType, list.filter((id) => id !== candidateId))}
                  addOptions={availableOptions}
                  addPlaceholder={t('orchestration.rules.addCandidate')}
                  onAdd={(candidateId) => updateRule(taskType, [...list, candidateId])}
                  emptyLabel={t('orchestration.rules.empty')}
                  removeLabel={t('orchestration.rules.remove')}
                />
              </div>
            </div>
          );
        })}
      </SettingsCard>
    </SettingsSection>
  );
}
