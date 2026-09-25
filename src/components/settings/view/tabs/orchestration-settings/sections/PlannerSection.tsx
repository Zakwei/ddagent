import { Plus, Trash2 } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import { cn } from '../../../../../../lib/utils';
import { Button, Input } from '../../../../../../shared/view/ui';
import SettingsCard from '../../../SettingsCard';
import SettingsRow from '../../../SettingsRow';
import SettingsSection from '../../../SettingsSection';
import type {
  OrchestratorCandidate,
  OrchestratorConfig,
  OrchestratorTaskType,
} from '../types';
import { ORCHESTRATOR_PLANNER_MODES, ORCHESTRATOR_TASK_TYPES } from '../types';

import { fieldSelectClass, OrderedEntriesEditor, SegmentedControl } from './controls';

type Planner = OrchestratorConfig['planner'];

type PlannerSectionProps = {
  planner: Planner;
  pool: OrchestratorCandidate[];
  onChange: (planner: Planner) => void;
};

/**
 * Planner settings: whether an LLM decomposes requests (auto), a fixed pipeline
 * runs (template), or every request routes as a single step (off) — plus which
 * pool candidate answers the planning calls.
 */
export default function PlannerSection({ planner, pool, onChange }: PlannerSectionProps) {
  const { t } = useTranslation('settings');

  const updateTemplate = (index: number, patch: Partial<Planner['templates'][number]>) => {
    onChange({
      ...planner,
      templates: planner.templates.map((template, i) => (i === index ? { ...template, ...patch } : template)),
    });
  };

  const removeTemplate = (index: number) => {
    onChange({ ...planner, templates: planner.templates.filter((_, i) => i !== index) });
  };

  const addTemplate = () => {
    onChange({
      ...planner,
      templates: [...planner.templates, { name: '', steps: ['code', 'test', 'review'] }],
    });
  };

  return (
    <SettingsSection
      title={t('orchestration.planner.title')}
      description={t('orchestration.planner.description')}
    >
      <SettingsCard divided>
        <SettingsRow
          label={t('orchestration.planner.modeLabel')}
          description={t(`orchestration.planner.modeHints.${planner.mode}`)}
        >
          <SegmentedControl
            value={planner.mode}
            ariaLabel={t('orchestration.planner.modeLabel')}
            options={ORCHESTRATOR_PLANNER_MODES.map((mode) => ({
              value: mode,
              label: t(`orchestration.planner.modes.${mode}`),
            }))}
            onChange={(mode) => onChange({ ...planner, mode })}
          />
        </SettingsRow>

        <SettingsRow
          label={t('orchestration.planner.candidateLabel')}
          description={t('orchestration.planner.candidateDescription')}
        >
          <select
            value={planner.candidateId}
            onChange={(event) => onChange({ ...planner, candidateId: event.target.value })}
            className={cn(fieldSelectClass, 'sm:w-56')}
            disabled={planner.mode === 'off'}
          >
            <option value="">{t('orchestration.planner.candidatePlaceholder')}</option>
            {pool.map((candidate) => (
              <option key={candidate.id} value={candidate.id}>
                {candidate.label || candidate.model}
              </option>
            ))}
          </select>
        </SettingsRow>
      </SettingsCard>

      <div className="mt-3 space-y-3">
        <div className="flex items-center justify-between">
          <h4 className="text-xs font-semibold uppercase tracking-wider text-muted-foreground">
            {t('orchestration.planner.templates.title')}
          </h4>
          <Button type="button" variant="outline" size="sm" onClick={addTemplate}>
            <Plus className="mr-1 h-3.5 w-3.5" />
            {t('orchestration.planner.templates.add')}
          </Button>
        </div>

        {planner.templates.length === 0 && (
          <p className="rounded-lg border border-dashed border-border px-4 py-4 text-center text-sm text-muted-foreground">
            {t('orchestration.planner.templates.empty')}
          </p>
        )}

        {planner.templates.map((template, index) => (
          <div key={index} className="rounded-xl border border-border bg-card/50 p-3">
            <div className="flex items-center gap-2">
              <Input
                value={template.name}
                onChange={(event) => updateTemplate(index, { name: event.target.value })}
                placeholder={t('orchestration.planner.templates.namePlaceholder')}
                aria-label={t('orchestration.planner.templates.namePlaceholder')}
                className="h-8 min-w-0 flex-1 font-mono text-sm"
              />
              <Button
                type="button"
                variant="ghost"
                size="icon"
                className="h-7 w-7 text-muted-foreground hover:bg-destructive/10 hover:text-destructive"
                onClick={() => removeTemplate(index)}
                aria-label={t('orchestration.planner.templates.remove')}
                title={t('orchestration.planner.templates.remove')}
              >
                <Trash2 className="h-3.5 w-3.5" />
              </Button>
            </div>
            <div className="mt-2">
              <OrderedEntriesEditor
                entries={template.steps.map((step, stepIndex) => ({
                  // Steps may repeat a task type, so the key needs the index.
                  id: `${index}-${stepIndex}-${step}`,
                  content: (
                    <span className="font-medium">
                      {t(`orchestration.rules.taskTypes.${step}`)}
                      <span className="ml-1 font-mono text-[10px] text-muted-foreground">{step}</span>
                    </span>
                  ),
                }))}
                onMove={(stepIndex, direction) => {
                  const next = [...template.steps];
                  const [entry] = next.splice(stepIndex, 1);
                  next.splice(stepIndex + direction, 0, entry);
                  updateTemplate(index, { steps: next });
                }}
                onRemove={(entryId) => {
                  const stepIndex = template.steps.findIndex(
                    (_, i) => `${index}-${i}-${template.steps[i]}` === entryId,
                  );
                  if (stepIndex >= 0) {
                    updateTemplate(index, {
                      steps: template.steps.filter((_, i) => i !== stepIndex),
                    });
                  }
                }}
                addOptions={ORCHESTRATOR_TASK_TYPES.map((taskType) => ({
                  value: taskType,
                  label: t(`orchestration.rules.taskTypes.${taskType}`),
                }))}
                addPlaceholder={t('orchestration.planner.templates.addStep')}
                onAdd={(value) =>
                  updateTemplate(index, {
                    steps: [...template.steps, value as OrchestratorTaskType],
                  })
                }
                emptyLabel={t('orchestration.planner.templates.emptySteps')}
                removeLabel={t('orchestration.planner.templates.removeStep')}
              />
            </div>
          </div>
        ))}
      </div>
    </SettingsSection>
  );
}
