import { Plus, Trash2 } from 'lucide-react';
import { useMemo, useRef } from 'react';
import { useTranslation } from 'react-i18next';

import type { ProviderAccount } from '../../../../../../hooks/useProviderAccounts';
import { Badge, Button, Input } from '../../../../../../shared/view/ui';
import type { LLMProvider, ProviderModelOption } from '../../../../../../types/app';
import SettingsSection from '../../../SettingsSection';
import type { OrchestratorCandidate, OrchestratorCostTier } from '../types';
import { ORCHESTRATOR_COST_TIERS, ORCHESTRATOR_PROVIDERS } from '../types';

import { Field, fieldSelectClass, MoveButtons } from './controls';

type CandidatePoolSectionProps = {
  pool: OrchestratorCandidate[];
  modelCatalog: Partial<Record<LLMProvider, ProviderModelOption[]>>;
  accounts: ProviderAccount[];
  onChange: (pool: OrchestratorCandidate[]) => void;
};

/**
 * The pool of model endpoints the router can pick from. Each row pins one
 * provider/model/effort/account combination to a cost tier.
 */
export default function CandidatePoolSection({
  pool,
  modelCatalog,
  accounts,
  onChange,
}: CandidatePoolSectionProps) {
  const { t } = useTranslation('settings');
  const idCounter = useRef(0);

  const updateCandidate = (id: string, patch: Partial<OrchestratorCandidate>) => {
    onChange(pool.map((candidate) => (candidate.id === id ? { ...candidate, ...patch } : candidate)));
  };

  const moveCandidate = (index: number, direction: -1 | 1) => {
    const next = [...pool];
    const [entry] = next.splice(index, 1);
    next.splice(index + direction, 0, entry);
    onChange(next);
  };

  const removeCandidate = (id: string) => {
    onChange(pool.filter((candidate) => candidate.id !== id));
  };

  const addCandidate = () => {
    idCounter.current += 1;
    onChange([
      ...pool,
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
  };

  const accountsByProvider = useMemo(() => {
    const grouped = new Map<string, ProviderAccount[]>();
    for (const account of accounts) {
      const list = grouped.get(account.provider) ?? [];
      list.push(account);
      grouped.set(account.provider, list);
    }
    return grouped;
  }, [accounts]);

  return (
    <SettingsSection
      title={t('orchestration.pool.title')}
      description={t('orchestration.pool.description')}
    >
      <div className="space-y-3">
        {pool.length === 0 && (
          <p className="rounded-lg border border-dashed border-border px-4 py-6 text-center text-sm text-muted-foreground">
            {t('orchestration.pool.empty')}
          </p>
        )}

        {pool.map((candidate, index) => {
          const modelOptions = modelCatalog[candidate.provider] ?? [];
          const selectedOption = modelOptions.find((option) => option.value === candidate.model);
          const modelInCatalog = Boolean(selectedOption) || !candidate.model;
          const effortValues = selectedOption?.effort?.values ?? [];
          const providerAccounts = accountsByProvider.get(candidate.provider) ?? [];

          return (
            <div
              key={candidate.id}
              className="rounded-xl border border-border bg-card/50 p-3"
            >
              <div className="flex items-center gap-1">
                <Input
                  value={candidate.label}
                  onChange={(event) => updateCandidate(candidate.id, { label: event.target.value })}
                  placeholder={t('orchestration.pool.fields.labelPlaceholder')}
                  aria-label={t('orchestration.pool.fields.label')}
                  className="h-8 min-w-0 flex-1 text-sm font-medium"
                />
                <MoveButtons index={index} count={pool.length} onMove={moveCandidate} />
                <Button
                  type="button"
                  variant="ghost"
                  size="icon"
                  className="h-7 w-7 text-muted-foreground hover:bg-destructive/10 hover:text-destructive"
                  onClick={() => removeCandidate(candidate.id)}
                  aria-label={t('orchestration.pool.fields.remove')}
                  title={t('orchestration.pool.fields.remove')}
                >
                  <Trash2 className="h-3.5 w-3.5" />
                </Button>
              </div>

              <div className="mt-2 grid grid-cols-1 gap-2 sm:grid-cols-2 lg:grid-cols-3">
                <Field label={t('orchestration.pool.fields.provider')}>
                  <select
                    value={candidate.provider}
                    onChange={(event) =>
                      updateCandidate(candidate.id, {
                        provider: event.target.value as LLMProvider,
                        // Model/effort/account ids are provider-scoped — a
                        // provider switch must not carry stale values over.
                        model: '',
                        effort: null,
                        accountId: null,
                      })
                    }
                    className={fieldSelectClass}
                  >
                    {ORCHESTRATOR_PROVIDERS.map((provider) => (
                      <option key={provider.id} value={provider.id}>
                        {provider.label}
                      </option>
                    ))}
                  </select>
                </Field>

                <Field label={t('orchestration.pool.fields.model')}>
                  <select
                    value={candidate.model}
                    onChange={(event) =>
                      updateCandidate(candidate.id, { model: event.target.value, effort: null })
                    }
                    className={fieldSelectClass}
                  >
                    <option value="">{t('orchestration.pool.fields.modelPlaceholder')}</option>
                    {!modelInCatalog && (
                      <option value={candidate.model}>{candidate.model}</option>
                    )}
                    {modelOptions.map((option) => (
                      <option key={option.value} value={option.value}>
                        {option.label}
                      </option>
                    ))}
                  </select>
                </Field>

                <Field label={t('orchestration.pool.fields.effort')}>
                  {effortValues.length > 0 ? (
                    <select
                      value={candidate.effort ?? ''}
                      onChange={(event) =>
                        updateCandidate(candidate.id, { effort: event.target.value || null })
                      }
                      className={fieldSelectClass}
                    >
                      <option value="">{t('orchestration.pool.fields.effortDefault')}</option>
                      {effortValues.map((effort) => (
                        <option key={effort.value} value={effort.value}>
                          {effort.value}
                        </option>
                      ))}
                    </select>
                  ) : (
                    <Input
                      value={candidate.effort ?? ''}
                      onChange={(event) =>
                        updateCandidate(candidate.id, { effort: event.target.value.trim() || null })
                      }
                      placeholder={t('orchestration.pool.fields.effortPlaceholder')}
                      className="h-9 text-sm"
                    />
                  )}
                </Field>

                <Field label={t('orchestration.pool.fields.account')}>
                  <select
                    value={candidate.accountId ?? ''}
                    onChange={(event) =>
                      updateCandidate(candidate.id, { accountId: event.target.value || null })
                    }
                    className={fieldSelectClass}
                  >
                    <option value="">{t('orchestration.pool.fields.accountDefault')}</option>
                    {providerAccounts.map((account) => (
                      <option key={account.id} value={account.id}>
                        {account.label}
                        {account.isDefault ? ` (${t('orchestration.pool.fields.accountDefault')})` : ''}
                      </option>
                    ))}
                  </select>
                </Field>

                <Field label={t('orchestration.pool.fields.tier')}>
                  <select
                    value={candidate.tier}
                    onChange={(event) =>
                      updateCandidate(candidate.id, {
                        tier: event.target.value as OrchestratorCostTier,
                      })
                    }
                    className={fieldSelectClass}
                  >
                    {ORCHESTRATOR_COST_TIERS.map((tier) => (
                      <option key={tier} value={tier}>
                        {t(`orchestration.tiers.${tier}`)}
                      </option>
                    ))}
                  </select>
                </Field>
              </div>
            </div>
          );
        })}

        <Button type="button" variant="outline" size="sm" onClick={addCandidate}>
          <Plus className="mr-1 h-4 w-4" />
          {t('orchestration.pool.add')}
        </Button>
      </div>
    </SettingsSection>
  );
}

/** Label + tier badge used inside the routing-rule ordered lists. */
export function CandidateChipContent({ candidate }: { candidate: OrchestratorCandidate }) {
  const { t } = useTranslation('settings');
  return (
    <>
      <span className="truncate">{candidate.label || candidate.model}</span>
      <Badge variant="secondary" className="flex-shrink-0 rounded-full px-1.5 py-0 text-[9px]">
        {t(`orchestration.tiers.${candidate.tier}`)}
      </Badge>
    </>
  );
}
