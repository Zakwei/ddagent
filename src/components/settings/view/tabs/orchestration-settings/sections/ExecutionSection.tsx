import { useTranslation } from 'react-i18next';

import { cn } from '../../../../../../lib/utils';
import SettingsCard from '../../../SettingsCard';
import SettingsRow from '../../../SettingsRow';
import SettingsSection from '../../../SettingsSection';
import type { OrchestratorConfig } from '../types';

import { fieldSelectClass } from './controls';

type Execution = OrchestratorConfig['execution'];

type ExecutionSectionProps = {
  execution: Execution;
  onChange: (execution: Execution) => void;
};

/** Guardrails: parallelism cap, fix-loop retries, and the empty-rule fallback. */
export default function ExecutionSection({ execution, onChange }: ExecutionSectionProps) {
  const { t } = useTranslation('settings');

  return (
    <SettingsSection
      title={t('orchestration.execution.title')}
      description={t('orchestration.execution.description')}
    >
      <SettingsCard divided>
        <SettingsRow
          label={t('orchestration.execution.maxParallel')}
          description={t('orchestration.execution.maxParallelDescription')}
        >
          <select
            value={execution.maxParallel}
            onChange={(event) =>
              onChange({ ...execution, maxParallel: Number(event.target.value) })
            }
            className={cn(fieldSelectClass, 'sm:w-28')}
          >
            {[1, 2, 3, 4, 5, 6, 7, 8].map((value) => (
              <option key={value} value={value}>
                {value}
              </option>
            ))}
          </select>
        </SettingsRow>

        <SettingsRow
          label={t('orchestration.execution.maxFixLoops')}
          description={t('orchestration.execution.maxFixLoopsDescription')}
        >
          <select
            value={execution.maxFixLoops}
            onChange={(event) =>
              onChange({ ...execution, maxFixLoops: Number(event.target.value) })
            }
            className={cn(fieldSelectClass, 'sm:w-28')}
          >
            {[0, 1, 2, 3, 4, 5].map((value) => (
              <option key={value} value={value}>
                {value}
              </option>
            ))}
          </select>
        </SettingsRow>

        <SettingsRow
          label={t('orchestration.execution.onNoCandidate')}
          description={t('orchestration.execution.onNoCandidateDescription')}
        >
          <select
            value={execution.onNoCandidate}
            onChange={(event) =>
              onChange({
                ...execution,
                onNoCandidate: event.target.value as Execution['onNoCandidate'],
              })
            }
            className={cn(fieldSelectClass, 'sm:w-40')}
          >
            <option value="ask">{t('orchestration.execution.onNoCandidateOptions.ask')}</option>
            <option value="skip">{t('orchestration.execution.onNoCandidateOptions.skip')}</option>
          </select>
        </SettingsRow>
      </SettingsCard>
    </SettingsSection>
  );
}
