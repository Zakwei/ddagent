import { memo } from 'react';
import { useTranslation } from 'react-i18next';
import {
  ArrowRight,
  CheckCircle2,
  ChevronRight,
  CircleSlash,
  ExternalLink,
  ListChecks,
  Loader2,
  Route,
  Sparkles,
  XCircle,
} from 'lucide-react';

import { Badge, Collapsible, CollapsibleContent, CollapsibleTrigger } from '../../../../shared/view/ui';
import type { LLMProvider } from '../../../../types/app';
import LLMProviderLogo from '../../../llm-provider-logo/LLMProviderLogo';
import type { OrchestratorCardData } from '../../types/types';

/**
 * Specialized cards for orchestrated ("Auto") sessions. Each row of the
 * parent transcript arrives as a `status` message whose `orchestrator`
 * payload carries `kind` + the backend payload verbatim, so the cards read
 * fields defensively and tolerate unknown keys.
 */

type NavigateToSession = (sessionId: string) => void;

const str = (value: unknown): string | null =>
  typeof value === 'string' && value.trim() ? value : null;

const strList = (value: unknown): string[] =>
  Array.isArray(value) ? value.map(String).filter((entry) => entry.trim()) : [];

type PlanStep = {
  id: string;
  type: string;
  title: string;
  dependsOn: string[];
  enabled: boolean;
};

function readSteps(value: unknown): PlanStep[] {
  if (!Array.isArray(value)) return [];
  return value
    .map((entry, index): PlanStep | null => {
      if (!entry || typeof entry !== 'object') return null;
      const raw = entry as Record<string, unknown>;
      return {
        id: str(raw.id) ?? `step-${index + 1}`,
        type: str(raw.type) ?? 'task',
        title: str(raw.title) ?? `Step ${index + 1}`,
        dependsOn: strList(raw.dependsOn),
        enabled: raw.enabled !== false,
      };
    })
    .filter((step): step is PlanStep => step !== null);
}

const CARD_CLASS =
  'rounded-lg border border-border/50 bg-muted/30 px-3 py-2 text-xs text-foreground';

const MUTED = 'text-muted-foreground';

const DELEGATION_STATUS_STYLES: Record<string, string> = {
  queued: 'border-border/60 bg-muted/60 text-muted-foreground',
  running: 'border-blue-500/40 bg-blue-500/10 text-blue-600 dark:text-blue-400',
  done: 'border-emerald-500/40 bg-emerald-500/10 text-emerald-600 dark:text-emerald-400',
  failed: 'border-red-500/40 bg-red-500/10 text-red-600 dark:text-red-400',
  aborted: 'border-amber-500/40 bg-amber-500/10 text-amber-600 dark:text-amber-400',
  skipped: 'border-border/60 bg-muted/60 text-muted-foreground line-through',
};

function DelegationStatusIcon({ status }: { status: string }) {
  switch (status) {
    case 'running':
      return <Loader2 className="h-3 w-3 animate-spin" />;
    case 'done':
      return <CheckCircle2 className="h-3 w-3" />;
    case 'failed':
      return <XCircle className="h-3 w-3" />;
    case 'skipped':
    case 'aborted':
      return <CircleSlash className="h-3 w-3" />;
    default:
      return null;
  }
}

function RoutingCard({ data }: { data: OrchestratorCardData }) {
  const { t } = useTranslation('chat');
  const taskType = str(data.taskType);
  const provider = str(data.provider);
  const model = str(data.model);
  const effort = str(data.effort);
  const tier = str(data.tier);
  const reason = str(data.reason);
  const error = str(data.error) ?? (data.status === 'no_candidate' ? str(data.status) : null);
  const alternatives = strList(data.alternatives);

  return (
    <div className={CARD_CLASS}>
      <div className="flex flex-wrap items-center gap-x-1.5 gap-y-1">
        <Route className={`h-3.5 w-3.5 ${MUTED}`} aria-hidden />
        {taskType && (
          <Badge variant="outline" className="px-1.5 py-0 text-[10px] font-normal">
            {taskType}
          </Badge>
        )}
        {provider && (
          <>
            <ArrowRight className={`h-3 w-3 ${MUTED}`} aria-hidden />
            <span className="inline-flex items-center gap-1">
              <LLMProviderLogo provider={provider as LLMProvider} className="h-3.5 w-3.5" />
              <span className="font-medium">{provider}</span>
              {model && <span className={MUTED}>· {model}</span>}
              {effort && <span className={MUTED}>· {effort}</span>}
              {tier && (
                <Badge variant="secondary" className="px-1 py-0 text-[10px] font-normal">
                  {tier}
                </Badge>
              )}
            </span>
          </>
        )}
        {!provider && (
          <span className={error ? 'text-red-600 dark:text-red-400' : MUTED}>
            {t('orchestrator.routing.title', { defaultValue: 'Routing' })}
          </span>
        )}
      </div>
      {reason && <p className={`mt-1 ${MUTED}`}>{reason}</p>}
      {error && (
        <p className="mt-1 text-red-600 dark:text-red-400">{error}</p>
      )}
      {alternatives.length > 0 && (
        <p className={`mt-0.5 text-[11px] ${MUTED}`}>
          {t('orchestrator.routing.alternatives', {
            defaultValue: 'Alternatives: {{list}}',
            list: alternatives.join(', '),
          })}
        </p>
      )}
    </div>
  );
}

function PlanCard({ data }: { data: OrchestratorCardData }) {
  const { t } = useTranslation('chat');
  const steps = readSteps(data.steps);
  const awaitingConfirm = data.awaitingConfirm === true;

  return (
    <div className={CARD_CLASS}>
      <div className="flex items-center gap-1.5">
        <ListChecks className={`h-3.5 w-3.5 ${MUTED}`} aria-hidden />
        <span className="font-medium">
          {t('orchestrator.plan.title', { defaultValue: 'Plan' })}
        </span>
        <Badge variant="secondary" className="px-1.5 py-0 text-[10px] font-normal">
          {t('orchestrator.plan.stepCount', { count: steps.length, defaultValue: '{{count}} steps' })}
        </Badge>
      </div>
      <ol className="mt-1.5 space-y-1">
        {steps.map((step, index) => (
          <li
            key={step.id}
            className={`flex min-w-0 items-center gap-2 ${step.enabled ? '' : 'opacity-50'}`}
          >
            <span className={`w-4 shrink-0 text-right tabular-nums ${MUTED}`}>{index + 1}.</span>
            <Badge variant="outline" className="shrink-0 px-1.5 py-0 text-[10px] font-normal">
              {step.type}
            </Badge>
            <span className="min-w-0 flex-1 truncate" title={step.title}>
              {step.title}
            </span>
            {!step.enabled && (
              <span className={`shrink-0 text-[10px] ${MUTED}`}>
                {t('orchestrator.plan.disabled', { defaultValue: 'disabled' })}
              </span>
            )}
          </li>
        ))}
      </ol>
      {awaitingConfirm && (
        <p className="mt-1.5 text-[11px] text-amber-600 dark:text-amber-400">
          {t('orchestrator.plan.awaitingConfirm', { defaultValue: 'Waiting for plan confirmation.' })}
        </p>
      )}
    </div>
  );
}

const FINAL_TEXT_PREVIEW_LIMIT = 800;

function DelegationCard({
  data,
  onNavigateToSession,
}: {
  data: OrchestratorCardData;
  onNavigateToSession?: NavigateToSession;
}) {
  const { t } = useTranslation('chat');
  const status = str(data.status) ?? 'queued';
  const title = str(data.title);
  const provider = str(data.provider);
  const model = str(data.model);
  const effort = str(data.effort);
  const tier = str(data.tier);
  const lastEvent = str(data.lastEvent);
  const error = str(data.error);
  const childSessionId = str(data.childSessionId);
  const finalText = str(data.finalText);
  const truncatedFinalText =
    finalText && finalText.length > FINAL_TEXT_PREVIEW_LIMIT
      ? `${finalText.slice(0, FINAL_TEXT_PREVIEW_LIMIT)}…`
      : finalText;

  return (
    <Collapsible defaultOpen={status === 'running'} className={CARD_CLASS}>
      <CollapsibleTrigger className="flex w-full min-w-0 items-center gap-2 text-left">
        <ChevronRight
          className={`h-3.5 w-3.5 shrink-0 ${MUTED} transition-transform [[data-state=open]>&]:rotate-90`}
          aria-hidden
        />
        <span className="min-w-0 flex-1 truncate font-medium" title={title ?? undefined}>
          {title ?? str(data.stepId) ?? t('orchestrator.delegation.title', { defaultValue: 'Delegated step' })}
        </span>
        {provider && (
          <span className={`hidden shrink-0 items-center gap-1 sm:inline-flex ${MUTED}`}>
            <LLMProviderLogo provider={provider as LLMProvider} className="h-3.5 w-3.5" />
            {provider}
            {model && ` · ${model}`}
            {effort && ` · ${effort}`}
          </span>
        )}
        {tier && (
          <Badge variant="secondary" className="shrink-0 px-1 py-0 text-[10px] font-normal">
            {tier}
          </Badge>
        )}
        <Badge
          variant="outline"
          className={`shrink-0 gap-1 px-1.5 py-0 text-[10px] font-normal ${DELEGATION_STATUS_STYLES[status] ?? DELEGATION_STATUS_STYLES.queued}`}
        >
          <DelegationStatusIcon status={status} />
          {t(`orchestrator.delegation.status.${status}`, { defaultValue: status })}
        </Badge>
      </CollapsibleTrigger>
      <CollapsibleContent>
        <div className="mt-1.5 border-t border-border/40 pt-1.5">
          {error && (
            <p className="whitespace-pre-wrap break-words text-red-600 dark:text-red-400">{error}</p>
          )}
          {lastEvent && status !== 'done' && (
            <p className={`whitespace-pre-wrap break-words ${MUTED}`}>{lastEvent}</p>
          )}
          {status === 'done' && truncatedFinalText && (
            <p className="whitespace-pre-wrap break-words text-foreground/80">{truncatedFinalText}</p>
          )}
          {childSessionId && onNavigateToSession && (
            <button
              type="button"
              onClick={(event) => {
                event.stopPropagation();
                onNavigateToSession(childSessionId);
              }}
              className="mt-1.5 inline-flex items-center gap-1 text-blue-600 underline-offset-2 hover:underline dark:text-blue-400"
            >
              <ExternalLink className="h-3 w-3" aria-hidden />
              {t('orchestrator.delegation.openSession', { defaultValue: 'Open full session' })}
            </button>
          )}
        </div>
      </CollapsibleContent>
    </Collapsible>
  );
}

function SummaryCard({ data }: { data: OrchestratorCardData }) {
  const { t } = useTranslation('chat');
  const text = str(data.text);
  const failed = strList(data.failed);

  return (
    <div className={`${CARD_CLASS} border-primary/30 bg-primary/5`}>
      <div className="flex items-center gap-1.5">
        <Sparkles className={`h-3.5 w-3.5 ${MUTED}`} aria-hidden />
        <span className="font-medium">
          {t('orchestrator.summary.title', { defaultValue: 'Summary' })}
        </span>
      </div>
      {text && <p className="mt-1 whitespace-pre-wrap break-words">{text}</p>}
      {failed.length > 0 && (
        <p className="mt-1 text-red-600 dark:text-red-400">
          {t('orchestrator.summary.failed', {
            defaultValue: 'Failed steps: {{list}}',
            list: failed.join(', '),
          })}
        </p>
      )}
    </div>
  );
}

/**
 * Renders one orchestrator transcript row. Unknown kinds degrade to a muted
 * generic card so a newer backend never renders an empty slot in the feed.
 */
export const OrchestratorCard = memo(function OrchestratorCard({
  data,
  onNavigateToSession,
}: {
  data: OrchestratorCardData;
  onNavigateToSession?: NavigateToSession;
}) {
  switch (data.kind) {
    case 'routing':
      return <RoutingCard data={data} />;
    case 'plan':
      return <PlanCard data={data} />;
    case 'delegation':
      return <DelegationCard data={data} onNavigateToSession={onNavigateToSession} />;
    case 'summary':
      return <SummaryCard data={data} />;
    default:
      return (
        <div className={`${CARD_CLASS} ${MUTED}`}>
          {data.kind}
        </div>
      );
  }
});

export default OrchestratorCard;
