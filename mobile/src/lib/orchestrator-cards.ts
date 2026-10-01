/**
 * Pure readers for orchestrator transcript rows — no RN deps, runnable under
 * plain Node. Mirrors web `src/components/chat/hooks/useChatMessages.ts` +
 * `src/components/chat/view/subcomponents/OrchestratorCards.tsx`: orchestrated
 * ("Auto") sessions store routing/plan/delegation/summary rows as `status`
 * messages whose `context` carries `orchestratorKind` + the backend payload
 * verbatim, so every field is read defensively.
 */

export type OrchestratorCardData = { kind: string; [key: string]: unknown };

export type OrchestratorPlanStep = {
  id: string;
  type: string;
  title: string;
  dependsOn: string[];
  enabled: boolean;
  /** Deterministic gate steps carry a shell command — keep it on confirm round-trips. */
  command?: string;
};

/** Semantic tone per delegation status (web DELEGATION_STATUS_STYLES). */
export type DelegationTone = 'muted' | 'info' | 'success' | 'danger' | 'warning';

/** Web `FINAL_TEXT_PREVIEW_LIMIT`. */
export const FINAL_TEXT_PREVIEW_LIMIT = 800;

/** Trimmed non-empty string or null — web `str()`. */
export const readString = (value: unknown): string | null =>
  typeof value === 'string' && value.trim() ? value : null;

/** Stringified non-empty entries of an array — web `strList()`. */
export const readStringList = (value: unknown): string[] =>
  Array.isArray(value) ? value.map(String).filter((entry) => entry.trim()) : [];

/**
 * Reads the orchestrator card payload off a `status` row: `orchestratorKind`
 * becomes `kind`, every other key passes through. Non-object contexts and
 * missing/empty kinds are not cards.
 */
export function readOrchestratorPayload(context: unknown): OrchestratorCardData | null {
  if (!context || typeof context !== 'object' || Array.isArray(context)) {
    return null;
  }
  const { orchestratorKind, ...payload } = context as Record<string, unknown>;
  return typeof orchestratorKind === 'string' && orchestratorKind
    ? { kind: orchestratorKind, ...payload }
    : null;
}

/** Searchable text for a card row — titles/summaries users would grep for. */
export function orchestratorFallbackText(payload: OrchestratorCardData): string {
  for (const key of ['text', 'title', 'reason', 'error']) {
    const value = payload[key];
    if (typeof value === 'string' && value.trim()) {
      return value;
    }
  }
  return '';
}

/** Plan steps with web defaults for missing id/type/title. */
export function readPlanSteps(value: unknown): OrchestratorPlanStep[] {
  if (!Array.isArray(value)) return [];
  return value
    .map((entry, index): OrchestratorPlanStep | null => {
      if (!entry || typeof entry !== 'object') return null;
      const raw = entry as Record<string, unknown>;
      return {
        id: readString(raw.id) ?? `step-${index + 1}`,
        type: readString(raw.type) ?? 'task',
        title: readString(raw.title) ?? `Step ${index + 1}`,
        dependsOn: readStringList(raw.dependsOn),
        enabled: raw.enabled !== false,
        command: readString(raw.command) ?? undefined,
      };
    })
    .filter((step): step is OrchestratorPlanStep => step !== null);
}

/** i18n key (chat namespace) for the plan-source footnote — mirrors web. */
export function planSourceKey(source: unknown): string | null {
  const value = readString(source);
  if (value === 'planner-fallback' || value === 'planner-error') return 'orchestrator.plan.fallback';
  if (value === 'supervised' || value === 'supervisor-unavailable') {
    return 'orchestrator.plan.supervisedSource';
  }
  if (value === 'template' || value === 'template-default') return 'orchestrator.plan.templateSource';
  if (value === 'off') return 'orchestrator.plan.offSource';
  return null;
}

/** Delegated step's final answer, clipped to the preview limit (web 800). */
export function truncateFinalText(text: unknown, limit: number = FINAL_TEXT_PREVIEW_LIMIT): string {
  const value = readString(text);
  if (!value) return '';
  return value.length > limit ? `${value.slice(0, limit)}…` : value;
}

const DELEGATION_TONES: Record<string, DelegationTone> = {
  queued: 'muted',
  running: 'info',
  done: 'success',
  failed: 'danger',
  aborted: 'warning',
  skipped: 'muted',
  awaiting_decision: 'warning',
};

/** Status → tone; unknown statuses read as queued. */
export const delegationStatusTone = (status: unknown): DelegationTone =>
  DELEGATION_TONES[readString(status) ?? ''] ?? 'muted';
