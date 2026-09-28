import { orchestratorMessagesDb } from '@/modules/database/index.js';
import type { OrchestratorDelegationService } from '@/modules/orchestrator/services/orchestrator-delegation.service.js';
import type { OrchestratorRouter } from '@/modules/orchestrator/services/orchestrator-router.service.js';
import type {
  AnyRecord,
  OrchestratorCandidate,
  OrchestratorConfig,
  OrchestratorPlanStep,
  OrchestratorTaskType,
  RealtimeClientConnection,
} from '@/shared/types.js';

export type OrchestrateInput = {
  sessionId: string;
  content: string;
  options: AnyRecord;
  connection: RealtimeClientConnection;
};

export type OrchestrateResult = { ok: true } | { ok: false; code: string; error: string };

/** Planner JSON contract: one entry per delegated subtask. */
type RawPlanStep = {
  type?: string;
  title?: string;
  prompt?: string;
  dependsOn?: unknown;
};

const TASK_TYPES: OrchestratorTaskType[] = [
  'plan',
  'quick',
  'research',
  'docs',
  'code',
  'code-hard',
  'test',
  'review',
];

const MAX_STEP_SUMMARY = 600;

/** UI language code → English name used inside prompts sent to child models. */
const LANGUAGE_NAMES: Record<string, string> = {
  en: 'English',
  pl: 'Polish',
  de: 'German',
  es: 'Spanish',
  fr: 'French',
  it: 'Italian',
  ja: 'Japanese',
  ko: 'Korean',
  ru: 'Russian',
  tr: 'Turkish',
  'zh-CN': 'Simplified Chinese',
  'zh-TW': 'Traditional Chinese',
};

/**
 * Maps the UI language carried in `chat.send`/`resume`/`confirm` options to a
 * prompt-facing language name. Consumed by the executor and tests; null means
 * no constraint (unknown or absent code).
 */
export function resolveLanguageName(options: AnyRecord): string | null {
  const raw = typeof options.language === 'string' ? options.language.trim() : '';
  if (!raw) return null;
  return LANGUAGE_NAMES[raw] ?? LANGUAGE_NAMES[raw.split('-')[0]] ?? null;
}

/**
 * Worktree surface the executor needs (wired to `worktreeServices` in the
 * module composition root). Kept structural so tests inject a stub.
 */
type WorktreeCreator = {
  create(input: { projectPath: string; branch: string }): Promise<{ worktreePath: string; branch: string }>;
};

/**
 * Minimal task shape the complete-all-tasks loop reads from
 * `.taskmaster/tasks/tasks.json` (satisfied by the taskmaster module's stored
 * task type — extra provider fields ride along untouched).
 */
type TaskmasterLoopTask = {
  id: number | string;
  title?: string;
  status?: string;
  description?: string;
  details?: string;
  testStrategy?: string;
  dependencies?: Array<number | string>;
  subtasks?: Array<Record<string, unknown>>;
};

/**
 * TaskMaster store surface the executor's complete-all-tasks loop needs
 * (wired to the taskmaster module's service in the composition root). Kept
 * structural so tests inject a stub. `listTasks` returns `null` when the
 * project has no tasks file.
 */
type TaskmasterStore = {
  listTasks(projectPath: string): Promise<TaskmasterLoopTask[] | null>;
  setTaskStatus(projectPath: string, taskId: string, status: string): Promise<unknown>;
};

/**
 * Task statuses the complete-all-tasks loop treats as finished — `deferred`
 * counts so "skip task and continue" never stalls the queue.
 */
const TASKMASTER_TERMINAL_STATUSES = new Set(['done', 'cancelled', 'deferred']);

/**
 * Hard cap on tasks processed by one complete-all-tasks run. Normal queues
 * never approach it; it exists so a pathological tasks.json (or a status
 * write that silently no-ops) cannot loop forever.
 */
const MAX_TASKMASTER_TASKS_PER_RUN = 200;

/**
 * Normalizes client-edited steps from `POST /plan/confirm`. Keeps the
 * submitted ids/`enabled` flags (the point of confirm is user edits) but
 * enforces the same invariants as planner output: known non-`plan` types,
 * string prompts, no dangling deps.
 */
export function normalizeEditableSteps(raw: unknown, fallbackPrompt: string, stepOffset = 0): OrchestratorPlanStep[] {
  const list = Array.isArray(raw) ? raw : [];
  const steps = list
    .map((entry, index): OrchestratorPlanStep | null => {
      if (!entry || typeof entry !== 'object' || Array.isArray(entry)) return null;
      const step = entry as Record<string, unknown>;
      const type = step.type as OrchestratorTaskType;
      if (!TASK_TYPES.includes(type) || type === 'plan') return null;
      return {
        id: typeof step.id === 'string' && step.id.trim() ? step.id.trim() : `step-${index + 1}`,
        type,
        title:
          typeof step.title === 'string' && step.title.trim()
            ? step.title.trim()
            : `Step ${index + 1}`,
        prompt:
          typeof step.prompt === 'string' && step.prompt.trim()
            ? step.prompt.trim()
            : fallbackPrompt,
        dependsOn: Array.isArray(step.dependsOn) ? step.dependsOn.map(String) : [],
        enabled: step.enabled !== false,
      };
    })
    .filter((step): step is OrchestratorPlanStep => step !== null);
  const ids = new Set(steps.map((s) => s.id));
  for (let i = 1; i <= stepOffset; i++) ids.add(`step-${i}`);
  for (const step of steps) {
    step.dependsOn = step.dependsOn.filter((dep) => ids.has(dep) && dep !== step.id);
  }
  return steps;
}

const strArr = (value: unknown): string[] =>
  Array.isArray(value) ? value.map(String).filter((v) => v.trim()) : [];

/**
 * Extracts the JSON array a planner model is told to emit verbatim. Tolerates
 * markdown fences and surrounding prose — the cheapest models do both.
 */
export function parsePlanJson(text: string): RawPlanStep[] | null {
  const fenced = text.match(/```(?:json)?\s*([\s\S]*?)```/);
  const candidate = fenced ? fenced[1] : text;
  const start = candidate.indexOf('[');
  const end = candidate.lastIndexOf(']');
  if (start === -1 || end === -1 || end <= start) return null;
  try {
    const parsed = JSON.parse(candidate.slice(start, end + 1));
    return Array.isArray(parsed) ? (parsed as RawPlanStep[]) : null;
  } catch {
    return null;
  }
}

/**
 * Extracted context from earlier child steps in an orchestrated session.
 * Consumed by the executor and planner to ensure cross-step coherence.
 */
export type PriorChildContext = {
  summaryText: string;
  stepOffset: number;
  completedSummaries: Map<string, string>;
  suggestions: string[];
};

/**
 * Extracts completed child agent outputs, recommendations, and step numbering
 * from session transcript rows. Consumed by orchestrator executor and tests.
 */
export function extractPriorSessionContext(
  rows: import('@/shared/types.js').OrchestratorMessage[],
): PriorChildContext {
  const completedSummaries = new Map<string, string>();
  const completedSteps: Array<{
    stepId: string;
    taskType: string;
    title: string;
    finalText: string;
    status: string;
  }> = [];

  let maxStepNum = 0;

  for (const row of rows) {
    if (row.kind === 'plan') {
      const steps = Array.isArray(row.payload?.steps) ? row.payload.steps : [];
      for (const step of steps) {
        if (step && typeof step === 'object') {
          const id = String((step as Record<string, unknown>).id ?? '');
          const match = id.match(/step-(\d+)/);
          if (match) {
            const num = parseInt(match[1], 10);
            if (!Number.isNaN(num) && num > maxStepNum) maxStepNum = num;
          }
        }
      }
    } else if (row.kind === 'delegation') {
      const stepId = typeof row.payload?.stepId === 'string' ? row.payload.stepId : null;
      const status = typeof row.payload?.status === 'string' ? row.payload.status : '';
      const finalText = typeof row.payload?.finalText === 'string' ? row.payload.finalText : '';
      const taskType = typeof row.payload?.taskType === 'string' ? row.payload.taskType : 'task';
      const title = typeof row.payload?.title === 'string' ? row.payload.title : stepId ?? 'Step';

      if (stepId) {
        const match = stepId.match(/step-(\d+)/);
        if (match) {
          const num = parseInt(match[1], 10);
          if (!Number.isNaN(num) && num > maxStepNum) maxStepNum = num;
        }
        if (status === 'done' && finalText) {
          completedSummaries.set(stepId, finalText.slice(-MAX_STEP_SUMMARY));
          completedSteps.push({
            stepId,
            taskType,
            title,
            finalText,
            status,
          });
        }
      }
    }
  }

  // Format context for child handoff and planner
  const summaryLines: string[] = [];
  for (const step of completedSteps) {
    const brief = step.finalText.slice(-400).trim();
    summaryLines.push(`- Step "${step.title}" (${step.taskType}, ${step.stepId}):\n  Result: ${brief}`);
  }
  const summaryText = summaryLines.join('\n');

  // Extract recommendations or next steps from child responses
  const suggestions: string[] = [];
  const bulletRe = /^[ \t]*[-*•]\s+(.+)$/gm;
  const headerRe = /(?:next steps|recommendations|kolejne kroki|dalsze kroki|suggestions|todo|follow-up|further improvements)[:\n]/i;

  for (let i = completedSteps.length - 1; i >= 0 && suggestions.length < 4; i--) {
    const text = completedSteps[i].finalText;
    const headerMatch = text.match(headerRe);
    if (headerMatch && headerMatch.index !== undefined) {
      const afterHeader = text.slice(headerMatch.index + headerMatch[0].length, headerMatch.index + 800);
      let m: RegExpExecArray | null;
      while ((m = bulletRe.exec(afterHeader)) !== null && suggestions.length < 4) {
        const item = m[1].replace(/[*#_`]/g, '').trim();
        if (item.length > 5 && item.length < 120 && !suggestions.includes(item)) {
          suggestions.push(item);
        }
      }
    }
  }

  // If no explicit bullet points extracted, infer contextual suggestions from the last tasks
  if (suggestions.length === 0 && completedSteps.length > 0) {
    const lastStep = completedSteps[completedSteps.length - 1];
    const touchedCode = completedSteps.some((s) => s.taskType === 'code' || s.taskType === 'code-hard');
    const hasTests = completedSteps.some((s) => s.taskType === 'test');
    const hasReview = completedSteps.some((s) => s.taskType === 'review');

    if (touchedCode && !hasTests) {
      suggestions.push('Napisz testy jednostkowe dla wprowadzonych zmian');
    }
    if (touchedCode && hasReview) {
      suggestions.push('Zaktualizuj dokumentację techniczną');
    }
    if (lastStep.taskType === 'research') {
      suggestions.push('Zaimplementuj rekomendowane rozwiązanie');
    }
    if (suggestions.length === 0) {
      suggestions.push('Zweryfikuj działanie i dodaj testy');
    }
  }

  return {
    summaryText,
    stepOffset: maxStepNum,
    completedSummaries,
    suggestions: suggestions.slice(0, 4),
  };
}

function toPlanSteps(
  raw: RawPlanStep[],
  fallbackPrompt: string,
  stepOffset = 0,
): OrchestratorPlanStep[] {
  const steps = raw
    .map((entry, index): OrchestratorPlanStep | null => {
      const type = entry.type as OrchestratorTaskType;
      if (!TASK_TYPES.includes(type) || type === 'plan') return null;
      const targetNum = stepOffset + index + 1;
      return {
        id: `step-${targetNum}`,
        type,
        title: typeof entry.title === 'string' && entry.title.trim() ? entry.title.trim() : `Step ${targetNum}`,
        prompt:
          typeof entry.prompt === 'string' && entry.prompt.trim()
            ? entry.prompt.trim()
            : fallbackPrompt,
        dependsOn: Array.isArray(entry.dependsOn) ? entry.dependsOn.map(String) : [],
        enabled: true,
      };
    })
    .filter((step): step is OrchestratorPlanStep => step !== null);

  // If offset > 0 and the first step has no dependsOn, link it to the last prior step
  if (stepOffset > 0 && steps.length > 0 && steps[0].dependsOn.length === 0) {
    steps[0].dependsOn = [`step-${stepOffset}`];
  }

  // Drop dangling deps so a hallucinated edge cannot deadlock the DAG.
  // Permitted deps include both current step ids and prior step ids up to stepOffset.
  const validIds = new Set(steps.map((s) => s.id));
  for (let i = 1; i <= stepOffset; i++) {
    validIds.add(`step-${i}`);
  }
  for (const step of steps) {
    step.dependsOn = step.dependsOn.filter((dep) => validIds.has(dep) && dep !== step.id);
  }
  return steps;
}

/**
 * Builds the prompt instructing the planner candidate. Consumed by
 * orchestrator executor and tests.
 */
export function buildPlannerPrompt(
  content: string,
  priorContextText?: string,
  stepOffset = 0,
  languageName?: string | null,
): string {
  const nextIdExample = stepOffset > 0 ? `step-${stepOffset + 1}, step-${stepOffset + 2}` : 'step-1, step-2';
  const startId = `step-${stepOffset + 1}`;
  const parts = [
    'You are a task planner. Split the user request into typed subtasks.',
    `Allowed types: ${TASK_TYPES.filter((t) => t !== 'plan').join(', ')}.`,
    'Rules: analysis/comparison of existing code is research, not code. Any plan that modifies code must end with a review step. Cheap work (code, test, docs, quick) goes on small models; review goes LAST.',
    'Use a single step ONLY for a trivial single-purpose request; requests mixing analysis and implementation need separate steps.',
    `Output ONLY a JSON array: [{"type":"...","title":"short","prompt":"full instruction for the sub-agent","dependsOn":["${stepOffset > 0 ? `step-${stepOffset}` : 'step-1'}"]}]. Step ids are ${nextIdExample}, ... in order starting at ${startId}.`,
  ];

  if (languageName) {
    parts.push(`Write every step's "title" and "prompt" in ${languageName}.`);
  }

  if (priorContextText) {
    parts.push(
      '',
      'CONTEXT FROM EARLIER COMPLETED STEPS AND CHILD AGENT RESPONSES IN THIS SESSION:',
      priorContextText,
      '',
      'CRITICAL: The new steps MUST be coherent with and build upon the child agents\' responses and findings above.',
      'Do not duplicate completed work. If the user asks to continue, proceed with the logical next steps recommended by the child agents or necessary to complete the overall goal.',
    );
  }

  const effectiveRequest = content.trim() || 'Continue the session with the next logical steps based on the child agent responses.';
  parts.push('', `Request: ${effectiveRequest}`);
  return parts.join('\n');
}

/**
 * Deterministic safety net on top of the planner: a plan that touches code
 * but never schedules a review gets one appended, depending on every prior
 * enabled step. Guarantees the "implement → review" pipeline even when the
 * planner LLM under-decomposes.
 */
function ensureReviewStep(steps: OrchestratorPlanStep[], stepOffset = 0): OrchestratorPlanStep[] {
  const enabled = steps.filter((s) => s.enabled);
  const touchesCode = enabled.some((s) => s.type === 'code' || s.type === 'code-hard');
  const hasReview = enabled.some((s) => s.type === 'review');
  if (!touchesCode || hasReview) return steps;
  const targetNum = stepOffset + steps.length + 1;
  return [
    ...steps,
    {
      id: `step-${targetNum}`,
      type: 'review',
      title: 'review: verify the changes',
      prompt:
        'Review the changes produced by the earlier steps: correctness, regressions, missing edge cases. Report concrete issues.',
      dependsOn: enabled.map((s) => s.id),
      enabled: true,
    },
  ];
}

/**
 * Detects if a review step output reported issues or failure.
 * Consumed by orchestrator tests and internal review-fix loop.
 */
export function hasIssuesVerdict(text: string): boolean {
  if (typeof text !== 'string' || !text) return false;
  const cleaned = text.replace(/[*#_`]/g, '');
  const matches = [...cleaned.matchAll(/VERDICT\s*:\s*([A-Za-z]+)/gi)];
  if (matches.length > 0) {
    const lastVerdict = matches[matches.length - 1][1].toUpperCase();
    return lastVerdict.startsWith('ISSUE') || lastVerdict.startsWith('FAIL');
  }
  return false;
}

/**
 * Turns one TaskMaster task into the delegation prompt for its plan/execute
 * cycle. Subtasks are listed with their statuses so the child finishes the
 * remaining ones; statuses themselves are written back by the orchestrator,
 * so the prompt forbids the child from touching `.taskmaster`.
 */
function buildTaskmasterPrompt(task: TaskmasterLoopTask): string {
  const title = typeof task.title === 'string' && task.title.trim() ? task.title.trim() : 'Untitled task';
  const parts = [`Implement TaskMaster task #${String(task.id)}: ${title}`];
  const description = typeof task.description === 'string' ? task.description.trim() : '';
  if (description && description !== title) parts.push('', `Description:\n${description}`);
  const details = typeof task.details === 'string' ? task.details.trim() : '';
  if (details) parts.push('', `Details:\n${details}`);
  const testStrategy = typeof task.testStrategy === 'string' ? task.testStrategy.trim() : '';
  if (testStrategy) parts.push('', `Test strategy:\n${testStrategy}`);
  const subtasks = Array.isArray(task.subtasks) ? task.subtasks : [];
  const pendingSubtasks = subtasks.filter((s) => !TASKMASTER_TERMINAL_STATUSES.has(String(s.status ?? 'pending')));
  if (pendingSubtasks.length > 0) {
    parts.push(
      '',
      'Subtasks to complete:',
      ...pendingSubtasks.map(
        (s) =>
          `- ${typeof s.title === 'string' && s.title.trim() ? s.title.trim() : `subtask ${String(s.id ?? '?')}`}`,
      ),
    );
  }
  parts.push(
    '',
    'The orchestrator manages TaskMaster statuses itself — do not edit .taskmaster files and do not mark tasks done.',
  );
  return parts.join('\n');
}

export type OrchestratorExecutor = {
  /**
   * Full pipeline for one user message on an orchestrated session: append the
   * user row, classify, plan (or single-step), then run steps through
   * delegated child runs while mirroring progress into the parent transcript.
   * With `planner.requireConfirm` the run stops after the plan row is emitted
   * and waits for `confirm`.
   */
  run(input: OrchestrateInput): Promise<OrchestrateResult>;
  /**
   * Executes a user-edited plan (`POST /plan/confirm`). Prefers the pending
   * plan stashed by `run`; falls back to rebuilding steps from the request so
   * confirm still works after a server restart.
   */
  confirm(sessionId: string, rawSteps: unknown, options: AnyRecord): Promise<OrchestrateResult>;
  /** True while a session has a plan awaiting confirmation. */
  hasPendingPlan(sessionId: string): boolean;
  /**
   * Re-runs the failed steps of the last finished plan (`POST
   * /sessions/:id/resume`). Dependency context is rebuilt from the earlier
   * run's completed delegation rows; finished steps are pre-settled so only
   * the failed set executes.
   */
  resume(sessionId: string, options: AnyRecord): Promise<OrchestrateResult>;
  /**
   * Continues the session with further steps, either automatic (inferred from
   * child responses), custom-prompted, or explicit user-defined steps.
   */
  continueSession(
    sessionId: string,
    prompt?: string,
    customSteps?: unknown,
    options?: AnyRecord,
  ): Promise<OrchestrateResult>;
  /**
   * Works through the session project's TaskMaster queue: each non-terminal
   * task whose dependencies are settled is marked `in-progress`, planned and
   * delegated, then marked `done` on success — until the queue drains, a task
   * fails, the run is aborted, or the per-run task cap hits. Invoked through
   * `resume` with `mode: 'complete-all-tasks'`; `options.maxTasks` bounds how
   * many tasks one call may process.
   */
  completeAllTasks(sessionId: string, options: AnyRecord): Promise<OrchestrateResult>;
  /** Aborts every live child run of the parent session. */
  abort(sessionId: string): Promise<boolean>;
};

export function createOrchestratorExecutor(deps: {
  getConfig(): OrchestratorConfig;
  router: OrchestratorRouter;
  delegation: OrchestratorDelegationService;
  /** Streams each appended parent-transcript row to live viewers. */
  publish?(entry: import('@/shared/types.js').OrchestratorMessage): void;
  /** Shared-worktree factory; absent (tests) disables the useWorktree flag. */
  worktrees?: WorktreeCreator;
  /** Reads the parent session's project path (confirm path after restart). */
  resolveSessionCwd?(sessionId: string): string | null;
  /** TaskMaster task store for the complete-all-tasks loop; absent = mode unavailable. */
  taskmaster?: TaskmasterStore;
  /** Injectable for tests — the wait before a rate-limit same-lane retry. */
  sleep?(ms: number): Promise<void>;
}): OrchestratorExecutor {
  const sleep = deps.sleep ?? ((ms: number) => new Promise<void>((resolve) => setTimeout(resolve, ms)));
  const append = (sessionId: string, kind: Parameters<typeof orchestratorMessagesDb.append>[1], payload: Record<string, unknown>) => {
    const entry = orchestratorMessagesDb.append(sessionId, kind, payload);
    deps.publish?.(entry);
    return entry;
  };
  /** Patches an existing transcript row and streams the update to viewers. */
  const patch = (rowId: number, payload: Record<string, unknown>) => {
    const entry = orchestratorMessagesDb.updatePayload(rowId, payload);
    if (entry) deps.publish?.(entry);
  };
  /** Active child aborts per parent session, so `chat.abort` reaches them. */
  const activeRuns = new Map<string, Set<() => Promise<void>>>();
  /**
   * Sessions whose parent run was aborted while no child was in flight
   * (e.g. during the rate-limit backoff) — checked before the next attempt
   * so an abort can never be missed.
   */
  const abortedParents = new Set<string>();

  /**
   * Throttle/quota errors — transient on free lanes like SWE-2, so the one
   * retry stays on the same model instead of burning a paid fallback.
   */
  const RATE_LIMIT_RE = /rate.?limit|429|too many|resource.?exhausted|quota.?exceeded/i;
  const RATE_LIMIT_RETRY_DELAY_MS = 20_000;

  const trackAbort = (sessionId: string, abort: () => Promise<void>) => {
    let set = activeRuns.get(sessionId);
    if (!set) {
      set = new Set();
      activeRuns.set(sessionId, set);
    }
    set.add(abort);
    return () => set?.delete(abort);
  };

  type PlanOutcome = { steps: OrchestratorPlanStep[]; source: string };

  const singleStep = (input: OrchestrateInput, stepOffset = 0): OrchestratorPlanStep[] => {
    const targetNum = stepOffset + 1;
    return [
      {
        id: `step-${targetNum}`,
        type: deps.router.classify(input.content),
        title: input.content.slice(0, 60) || `Step ${targetNum}`,
        prompt: input.content,
        dependsOn: stepOffset > 0 ? [`step-${stepOffset}`] : [],
        enabled: true,
      },
    ];
  };

  async function plan(
    input: OrchestrateInput,
    config: OrchestratorConfig,
    priorContext?: PriorChildContext,
  ): Promise<PlanOutcome> {
    const stepOffset = priorContext?.stepOffset ?? 0;
    // Template mode: the composer chip names a configured pipeline.
    const templateName = typeof input.options.template === 'string' ? input.options.template : null;
    const template = config.planner.templates.find((t) => t.name === templateName);
    if (config.planner.mode === 'template' || template) {
      const steps = (template?.steps ?? ['code' as OrchestratorTaskType]);
      return {
        source: template ? 'template' : 'template-default',
        steps: steps.map((type, index) => ({
          id: `step-${stepOffset + index + 1}`,
          type,
          title: `${template?.name ?? 'task'} · ${type}`,
          prompt: input.content,
          dependsOn: index === 0 ? (stepOffset > 0 ? [`step-${stepOffset}`] : []) : [`step-${stepOffset + index}`],
          enabled: true,
        })),
      };
    }

    if (config.planner.mode === 'off') {
      return { source: 'off', steps: singleStep(input, stepOffset) };
    }

    // 'auto': ask the planner candidate for a JSON decomposition.
    const plannerCandidate = config.pool.find((c) => c.id === config.planner.candidateId);
    if (!plannerCandidate) {
      return { source: 'planner-missing', steps: singleStep(input, stepOffset) };
    }

    try {
      const handle = await deps.delegation.run({
        parentSessionId: input.sessionId,
        delegationRowId: null,
        provider: plannerCandidate.provider,
        model: plannerCandidate.model,
        effort: plannerCandidate.effort,
        accountId: plannerCandidate.accountId,
        cwd: input.options.cwd ?? '',
        command: buildPlannerPrompt(
          input.content,
          priorContext?.summaryText,
          stepOffset,
          resolveLanguageName(input.options),
        ),
        permissionMode: 'bypassPermissions',
      });
      const result = await handle.completed;
      const parsed = result.finalText ? parsePlanJson(result.finalText) : null;
      const steps = parsed ? toPlanSteps(parsed, input.content, stepOffset) : [];
      if (steps.length > 0) return { source: 'planner', steps };
      console.warn('[Orchestrator] Planner returned no usable steps, single-step fallback.');
      return { source: 'planner-fallback', steps: singleStep(input, stepOffset) };
    } catch (error) {
      console.warn('[Orchestrator] Planner failed, single-step fallback:', error);
      return { source: 'planner-error', steps: singleStep(input, stepOffset) };
    }
  }

  /**
   * Plans (but does not run) one user message. Shared by `run` and the
   * confirm-after-restart rebuild path.
   */
  type PendingPlan = { input: OrchestrateInput; planRowId: number; steps: OrchestratorPlanStep[] };
  const pendingPlans = new Map<string, PendingPlan>();

  /**
   * Runs the step list through the DAG scheduler: independent steps run in
   * parallel up to `execution.maxParallel`; a failed dep marks dependents
   * skipped; review ISSUES verdicts push bounded fix steps into the queue.
   */
  async function executeSteps(
    input: OrchestrateInput,
    config: OrchestratorConfig,
    steps: OrchestratorPlanStep[],
    planRowId: number,
    /** Resume mode: ids of already-finished plan steps, their output
     *  summaries, and their existing delegation rows for in-place patches. */
    seed?: {
      settledIds?: string[];
      summaries?: Map<string, string>;
      delegationRowByStep?: Map<string, number>;
    },
  ): Promise<OrchestrateResult> {
    const sessionId = input.sessionId;
    abortedParents.delete(sessionId);
    const languageName = resolveLanguageName(input.options);
    const baseCwd =
      typeof input.options.cwd === 'string' && input.options.cwd
        ? input.options.cwd
        : deps.resolveSessionCwd?.(sessionId) ?? '';

    // One shared worktree per plan run when enabled: every child step works
    // in it (review sees the diff code left behind) and the path is recorded
    // on the plan row so session delete can clean it up.
    let cwd = baseCwd;
    if (config.execution.useWorktree && deps.worktrees && baseCwd) {
      try {
        const worktree = await deps.worktrees.create({
          projectPath: baseCwd,
          branch: `orchestrator/${sessionId.slice(0, 8)}-${Date.now().toString(36)}`,
        });
        cwd = worktree.worktreePath;
        orchestratorMessagesDb.updatePayload(planRowId, {
          worktreePath: worktree.worktreePath,
          branch: worktree.branch,
        });
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        append(sessionId, 'summary', {
          text: `Worktree creation failed: ${message}`,
          failed: steps.map((s) => s.id),
        });
        return { ok: false, code: 'WORKTREE_FAILED', error: message };
      }
    }

    const summaries = seed?.summaries ?? new Map<string, string>();
    const settled = new Set<string>([
      ...steps.filter((s) => !s.enabled).map((s) => s.id),
      ...(seed?.settledIds ?? []),
    ]);
    const failed = new Set<string>();
    /** Set by a user-cancelled child run or the parent session's abort. */
    let runAborted = false;

    const runStep = async (step: OrchestratorPlanStep): Promise<void> => {
      const routed = deps.router.route(step.type);
      if (!routed.ok) {
        append(sessionId, 'routing', {
          taskType: step.type,
          error: routed.reason,
          status: 'no_candidate',
        });
        failed.add(step.id);
        settled.add(step.id);
        return;
      }

      append(sessionId, 'routing', routed.decision as unknown as Record<string, unknown>);

      // Resume reuses the failed step's existing delegation row so the
      // transcript keeps one card per step instead of stacking retry rows.
      const resumeRowId = seed?.delegationRowByStep?.get(step.id);
      let delegationRow: { id: number };
      if (resumeRowId !== undefined) {
        delegationRow = { id: resumeRowId };
        patch(resumeRowId, { status: 'queued', attempt: 1, error: null });
      } else {
        delegationRow = append(sessionId, 'delegation', {
          stepId: step.id,
          taskType: step.type,
          title: step.title,
          provider: routed.candidate.provider,
          model: routed.candidate.model,
          effort: routed.decision.effort,
          tier: routed.candidate.tier,
          status: 'queued',
        });
      }

      // Handoff: the child sees summaries of completed dependencies — the
      // only cross-provider context channel (provider-native transcripts
      // cannot share history; kanban's prepended-contract precedent).
      const depSummary = step.dependsOn
        .map((dep) => summaries.get(dep))
        .filter(Boolean)
        .map((text, i) => `Result of earlier step ${i + 1}:\n${text}`)
        .join('\n\n');
      const command = depSummary ? `${step.prompt}\n\n${depSummary}` : step.prompt;
      // UI language constraint: every delegated step answers in the app's
      // language so the transcript reads consistently for the user.
      const langConstraint = languageName
        ? `\n\nIMPORTANT: Write your entire reply in ${languageName}.`
        : '';
      const reviewHint =
        step.type === 'review' || step.type === 'test'
          ? '\n\nEnd your reply with a line exactly: VERDICT: PASS or VERDICT: ISSUES'
          : '';

      // Route order = failover order: a failed attempt advances to the next
      // viable alternative so one dead lane never kills the step. The only
      // same-lane retry is for a rate limit — each candidate absorbs ONE
      // (free tiers like SWE-2 throttle transiently and are worth a short
      // wait before spending the next fallback's quota).
      const candidates = [
        routed.candidate,
        ...routed.decision.alternatives
          .map((id) => config.pool.find((c) => c.id === id))
          .filter((c): c is OrchestratorCandidate => Boolean(c)),
      ];

      let attempt = 0;
      let candidateIndex = 0;
      /** Lanes that already used their one rate-limit same-model retry. */
      const rateLimitRetried = new Set<number>();
      for (;;) {
        attempt += 1;
        const candidate = candidates[candidateIndex];
        if (attempt > 1) {
          patch(delegationRow.id, {
            status: 'queued',
            attempt,
            error: null,
            provider: candidate.provider,
            model: candidate.model,
            effort: candidate.effort ?? routed.decision.effort,
          });
        }
        const handle = await deps.delegation.run({
          parentSessionId: sessionId,
          delegationRowId: delegationRow.id,
          provider: candidate.provider,
          model: candidate.model,
          effort: candidate.effort ?? routed.decision.effort,
          accountId: candidate.accountId,
          cwd,
          command: command + langConstraint + reviewHint,
          // Delegated steps always bypass: nobody watches the child session to
          // approve prompts, so a strict mode stalls the pipeline waiting for
          // input that never comes.
          permissionMode: 'bypassPermissions',
        });
        const untrack = trackAbort(sessionId, handle.abort);
        const result = await handle.completed;
        untrack();

        if (result.ok) {
          summaries.set(step.id, result.finalText.slice(-MAX_STEP_SUMMARY) || `${step.title} completed.`);
          // Fix loop: when an evaluator step (review or test) reports issues, append a corrective 'code' step
          // and a follow-up verification step, iterating until PASS or maxFixLoops is reached.
          const isEvaluatorStep = step.type === 'review' || step.type === 'test';
          if (isEvaluatorStep && hasIssuesVerdict(result.finalText)) {
            const fixCount = steps.filter((s) => s.id.startsWith('fix-')).length;
            if (fixCount < config.execution.maxFixLoops) {
              const fixStepId = `fix-${fixCount + 1}`;
              const verifyType: OrchestratorTaskType = step.type === 'test' ? 'test' : 'review';
              const verifyStepId = `${verifyType}-fix-${fixCount + 1}`;
              const fixPrompt =
                step.type === 'test'
                  ? `Fix the test failures found in (${step.title}):\n\n${result.finalText.slice(-4000)}`
                  : `Fix the issues found in review (${step.title}):\n\n${result.finalText.slice(-4000)}`;
              const verifyPrompt =
                verifyType === 'test'
                  ? `Run tests to verify that the fixes made in ${fixStepId} resolved the issues in ${step.title}.`
                  : `Review the changes made in ${fixStepId} to verify that the issues found in ${step.title} were resolved and no regressions were introduced.`;

              // Update any downstream steps that were waiting for step.id so they wait for the verification step
              for (const s of steps) {
                if (s.id !== fixStepId && s.id !== verifyStepId && s.dependsOn.includes(step.id)) {
                  s.dependsOn = s.dependsOn.map((dep) => (dep === step.id ? verifyStepId : dep));
                }
              }

              steps.push(
                {
                  id: fixStepId,
                  type: 'code',
                  title: `fix ${fixCount + 1}: resolve issues from ${step.title}`,
                  prompt: fixPrompt,
                  dependsOn: [step.id],
                  enabled: true,
                },
                {
                  id: verifyStepId,
                  type: verifyType,
                  title: `${verifyType} fix ${fixCount + 1}: verify changes`,
                  prompt: verifyPrompt,
                  dependsOn: [step.id, fixStepId],
                  enabled: true,
                },
              );
              if (planRowId > 0) {
                const currentPlan = orchestratorMessagesDb.list(sessionId).find((r) => r.id === planRowId);
                const existingSteps = Array.isArray(currentPlan?.payload?.steps)
                  ? (currentPlan.payload.steps as OrchestratorPlanStep[])
                  : steps;
                const existingIds = new Set(existingSteps.map((s) => s.id));
                const newSteps = steps.filter((s) => !existingIds.has(s.id));
                patch(planRowId, {
                  steps: [...existingSteps, ...newSteps].map((s) => ({
                    id: s.id,
                    type: s.type,
                    title: s.title,
                    prompt: s.prompt,
                    dependsOn: s.dependsOn,
                    enabled: s.enabled,
                  })),
                });
              }
            } else {
              patch(delegationRow.id, {
                status: 'failed',
                error: `${step.title} found issues, but reached maximum fix loops (${config.execution.maxFixLoops})`,
              });
              failed.add(step.id);
            }
          }
          break;
        }

        // A user-aborted child (or an already-aborted run) never retries.
        if (result.aborted) runAborted = true;
        if (runAborted) {
          failed.add(step.id);
          break;
        }

        if (RATE_LIMIT_RE.test(result.error ?? '') && !rateLimitRetried.has(candidateIndex)) {
          rateLimitRetried.add(candidateIndex);
          patch(delegationRow.id, { status: 'queued', rateLimited: true });
          await sleep(RATE_LIMIT_RETRY_DELAY_MS);
          if (abortedParents.has(sessionId)) {
            runAborted = true;
            failed.add(step.id);
            break;
          }
          continue; // candidateIndex unchanged → the retry stays on this lane.
        }

        if (candidateIndex + 1 < candidates.length) {
          candidateIndex += 1;
          continue;
        }

        // Every routed alternative failed — the run ends here for this step;
        // the summary's Continue button reruns it via POST /sessions/:id/resume.
        patch(delegationRow.id, { status: 'failed' });
        failed.add(step.id);
        break;
      }
      settled.add(step.id);
    };

    // Wave scheduler: scan the (growable) step list each pass — fix steps
    // pushed mid-run join naturally. `settled` covers done/failed/skipped and
    // user-disabled steps (a disabled dep does not block its dependents).
    for (;;) {
      const waiting = steps.filter((s) => !settled.has(s.id));
      if (waiting.length === 0) break;

      // An abort decision drains the queue: every never-started step gets a
      // transcript row explaining why it never ran.
      if (runAborted) {
        for (const step of waiting) {
          append(sessionId, 'delegation', {
            stepId: step.id,
            title: step.title,
            status: 'aborted',
            error: 'aborted by user decision',
          });
          failed.add(step.id);
          settled.add(step.id);
        }
        break;
      }

      let progressed = false;
      for (const step of waiting) {
        if (step.dependsOn.some((dep) => failed.has(dep))) {
          append(sessionId, 'delegation', {
            stepId: step.id,
            title: step.title,
            status: 'skipped',
            error: 'blocked by failed step(s)',
          });
          failed.add(step.id);
          settled.add(step.id);
          progressed = true;
        }
      }

      const ready = waiting.filter(
        (s) => !settled.has(s.id) && s.dependsOn.every((dep) => settled.has(dep)),
      );
      if (ready.length === 0) {
        // Dependency cycle (should not occur after normalization) — bail.
        if (!progressed) break;
        continue;
      }
      await Promise.all(ready.slice(0, config.execution.maxParallel).map(runStep));
    }

    const total = steps.filter((s) => s.enabled).length;
    const okCount = total - failed.size;
    const failedList = [...failed];

    // Collect per-step findings for the summary card. Only completed steps
    // that produced a summary are included; failed/skipped steps are omitted
    // (the failed list already surfaces them).
    const stepResults = steps
      .filter((s) => s.enabled && !failed.has(s.id) && summaries.has(s.id))
      .map((s) => ({ title: s.title, summary: summaries.get(s.id) as string }));

    append(sessionId, 'summary', {
      text:
        `${okCount}/${total} steps completed` +
        (failedList.length ? `, failed: ${failedList.join(', ')}` : '') +
        (runAborted ? ' (aborted)' : ''),
      failed: failedList,
      aborted: runAborted,
      results: stepResults,
    });

    return failed.size === total && total > 0
      ? { ok: false, code: 'ALL_STEPS_FAILED', error: `All ${total} steps failed` }
      : { ok: true };
  }

  /**
   * The complete-all-tasks loop. Each iteration re-reads tasks.json (the file
   * stays the source of truth, so external edits and skip/deferred markers
   * are picked up live), picks the first non-terminal task whose dependencies
   * are all terminal, marks it `in-progress`, plans and delegates it, then
   * marks it `done` on success. The loop stops on task failure, user abort,
   * a dependency deadlock, or the per-run task cap.
   */
  async function completeAllTasks(sessionId: string, options: AnyRecord): Promise<OrchestrateResult> {
    const store = deps.taskmaster;
    const projectPath = deps.resolveSessionCwd?.(sessionId) ?? null;
    if (!store) {
      return { ok: false, code: 'TASKMASTER_UNAVAILABLE', error: 'TaskMaster integration is not configured.' };
    }
    if (!projectPath) {
      return { ok: false, code: 'PROJECT_PATH_UNKNOWN', error: 'Cannot resolve the session project path.' };
    }

    const config = deps.getConfig();
    // Sequential tasks must share the real project directory — a fresh
    // per-run worktree would strand each task's diff (and .taskmaster state)
    // from the next task's steps.
    const loopConfig = config.execution.useWorktree
      ? { ...config, execution: { ...config.execution, useWorktree: false } }
      : config;

    const requestedMax = Number(options.maxTasks);
    const maxTasks =
      Number.isFinite(requestedMax) && requestedMax > 0
        ? Math.min(Math.floor(requestedMax), MAX_TASKMASTER_TASKS_PER_RUN)
        : MAX_TASKMASTER_TASKS_PER_RUN;

    const makeInput = (content: string): OrchestrateInput => ({
      sessionId,
      content,
      options: { ...options, cwd: projectPath },
      connection: { readyState: 0, send: () => undefined } as unknown as OrchestrateInput['connection'],
    });

    /** Streams a queue-progress milestone row to the parent transcript. */
    const taskmasterEvent = (taskId: string | null, status: string, extra: Record<string, unknown> = {}) =>
      append(sessionId, 'taskmaster', { taskId, status, ...extra });

    // Ids already processed in this run — a status write that silently fails
    // must never reschedule the same task, so this doubles as the loop guard.
    const processed = new Set<string>();
    let completed = 0;

    // Clear a stale abort flag from a previous run; executeSteps does the
    // same at its start, but the loop's first check runs before that.
    abortedParents.delete(sessionId);

    for (;;) {
      if (abortedParents.has(sessionId)) {
        taskmasterEvent(null, 'aborted', { completed });
        return { ok: false, code: 'ABORTED', error: 'Aborted by user.' };
      }
      if (completed >= maxTasks) {
        taskmasterEvent(null, 'paused', {
          completed,
          text: `Stopped after ${completed} completed task(s).`,
        });
        return { ok: true };
      }

      let tasks: TaskmasterLoopTask[] | null;
      try {
        tasks = await store.listTasks(projectPath);
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        return { ok: false, code: 'TASKMASTER_READ_FAILED', error: `Cannot read tasks.json: ${message}` };
      }
      if (tasks === null) {
        return {
          ok: false,
          code: 'NO_TASKMASTER',
          error: `No .taskmaster/tasks/tasks.json found in ${projectPath}.`,
        };
      }

      const isTerminal = (status: unknown) => TASKMASTER_TERMINAL_STATUSES.has(String(status ?? 'pending'));
      const unfinished = tasks.filter((task) => !isTerminal(task.status));
      if (unfinished.length === 0) {
        taskmasterEvent(null, 'complete', {
          completed,
          remaining: 0,
          total: tasks.length,
          text: 'All TaskMaster tasks are complete.',
        });
        return { ok: true };
      }

      // Next runnable task = first unfinished task whose dependencies have all
      // reached a terminal status; `processed` keeps the run from re-picking
      // a task whose status write did not stick.
      const statusById = new Map(tasks.map((task) => [String(task.id), task.status]));
      const next = unfinished.find((task) => {
        if (processed.has(String(task.id))) return false;
        const taskDeps = Array.isArray(task.dependencies) ? task.dependencies : [];
        return taskDeps.every((dep) => {
          const depStatus = statusById.get(String(dep).split('.')[0]);
          return depStatus !== undefined && isTerminal(depStatus);
        });
      });

      if (!next) {
        taskmasterEvent(null, 'blocked', {
          completed,
          remaining: unfinished.length,
          total: tasks.length,
          text: `${unfinished.length} task(s) left but none has its dependencies satisfied.`,
        });
        return {
          ok: false,
          code: 'TASKS_BLOCKED',
          error: `${unfinished.length} TaskMaster task(s) remain but none is runnable — unresolved dependencies.`,
        };
      }

      const taskId = String(next.id);
      const title = typeof next.title === 'string' ? next.title : `Task ${taskId}`;
      processed.add(taskId);
      try {
        await store.setTaskStatus(projectPath, taskId, 'in-progress');
      } catch (error) {
        console.warn(`[Orchestrator] TaskMaster status update failed for #${taskId}:`, error);
      }
      taskmasterEvent(taskId, 'started', { title, remaining: unfinished.length, total: tasks.length });

      const input = makeInput(buildTaskmasterPrompt(next));
      const priorContext = extractPriorSessionContext(orchestratorMessagesDb.list(sessionId));
      const outcome = await plan(input, config, priorContext);
      const steps = ensureReviewStep(outcome.steps, priorContext.stepOffset);
      const planRow = append(sessionId, 'plan', {
        steps: steps.map((s) => ({ id: s.id, type: s.type, title: s.title, prompt: s.prompt, dependsOn: s.dependsOn, enabled: s.enabled })),
        awaitingConfirm: false,
        source: 'taskmaster',
        taskmaster: { taskId, title },
      });

      // An abort arriving while the planner delegation ran would otherwise be
      // cleared by executeSteps' start-of-run reset — check before launching.
      if (abortedParents.has(sessionId)) {
        taskmasterEvent(taskId, 'aborted', { title, completed });
        return { ok: false, code: 'ABORTED', error: 'Aborted by user.' };
      }
      // Prior steps are pre-settled (same convention as continueSession):
      // generated steps chain onto `step-<offset>` deps, so without the seed
      // they would never become ready and the task would pass vacuously.
      const execResult = await executeSteps(input, loopConfig, steps, planRow.id, {
        settledIds: Array.from({ length: priorContext.stepOffset }, (_, i) => `step-${i + 1}`),
        summaries: priorContext.completedSummaries,
      });

      // The per-task summary row just appended is the verdict source — its
      // `failed`/`aborted` lists decide whether the task counts as done.
      const lastSummary =
        [...orchestratorMessagesDb.list(sessionId)].reverse().find((row) => row.kind === 'summary') ?? null;
      const failedSteps = strArr(lastSummary?.payload.failed);
      const wasAborted = abortedParents.has(sessionId) || lastSummary?.payload.aborted === true;

      if (wasAborted) {
        taskmasterEvent(taskId, 'aborted', { title, completed });
        return { ok: false, code: 'ABORTED', error: 'Aborted by user.' };
      }
      if (!execResult.ok || failedSteps.length > 0) {
        // Partial success keeps the task `in-progress` so a retry resumes it.
        const detail =
          failedSteps.length > 0
            ? `failed steps: ${failedSteps.join(', ')}`
            : execResult.ok
              ? 'no steps completed'
              : execResult.error;
        taskmasterEvent(taskId, 'failed', { title, completed, remaining: unfinished.length, error: detail });
        return { ok: false, code: 'TASK_FAILED', error: `TaskMaster task #${taskId} failed (${detail}).` };
      }

      try {
        await store.setTaskStatus(projectPath, taskId, 'done');
      } catch (error) {
        console.warn(`[Orchestrator] TaskMaster status update failed for #${taskId}:`, error);
      }
      completed += 1;
      taskmasterEvent(taskId, 'done', {
        title,
        completed,
        remaining: unfinished.length - 1,
        total: tasks.length,
      });
    }
  }

  return {
    async run(input: OrchestrateInput): Promise<OrchestrateResult> {
      const config = deps.getConfig();
      const sessionId = input.sessionId;

      append(sessionId, 'user', { content: input.content });

      const outcome = await plan(input, config);
      const steps = ensureReviewStep(outcome.steps);
      const planRow = append(sessionId, 'plan', {
        steps: steps.map((s) => ({ id: s.id, type: s.type, title: s.title, prompt: s.prompt, dependsOn: s.dependsOn, enabled: s.enabled })),
        awaitingConfirm: config.planner.requireConfirm,
        source: outcome.source,
      });

      // Confirm mode parks here: the plan card stays editable until the
      // client POSTs /plan/confirm, which resumes via `confirm`.
      if (config.planner.requireConfirm) {
        pendingPlans.set(sessionId, { input, planRowId: planRow.id, steps });
        return { ok: true };
      }
      return executeSteps(input, config, steps, planRow.id);
    },

    hasPendingPlan(sessionId: string): boolean {
      return pendingPlans.has(sessionId);
    },

    async confirm(sessionId: string, rawSteps: unknown, options: AnyRecord): Promise<OrchestrateResult> {
      const pending = pendingPlans.get(sessionId);
      pendingPlans.delete(sessionId);
      const config = deps.getConfig();
      const input: OrchestrateInput = pending?.input ?? {
        sessionId,
        content: '',
        options,
        connection: { readyState: 0, send: () => undefined } as unknown as OrchestrateInput['connection'],
      };
      // The plan card's wire format omits prompts (they live in the pending
      // stash) — restore them by step id so a confirm round-trip does not
      // collapse every step onto step-1's prompt.
      const pendingById = new Map((pending?.steps ?? []).map((s) => [s.id, s]));
      const rawList = (Array.isArray(rawSteps) ? rawSteps : []).map((raw) => {
        if (!raw || typeof raw !== 'object') return raw;
        const step = raw as Record<string, unknown>;
        const hasPrompt = typeof step.prompt === 'string' && step.prompt.trim();
        const original = typeof step.id === 'string' ? pendingById.get(step.id) : undefined;
        return !hasPrompt && original ? { ...step, prompt: original.prompt } : raw;
      });
      const steps = normalizeEditableSteps(rawList, pending?.steps[0]?.prompt ?? '');
      if (steps.length === 0) {
        return { ok: false, code: 'EMPTY_PLAN', error: 'No executable steps in the confirmed plan.' };
      }

      // Patch the plan row so history shows the steps as actually approved.
      const planRow =
        orchestratorMessagesDb
          .list(sessionId)
          .filter((row) => row.kind === 'plan')
          .at(-1) ?? null;
      const planRowId = pending?.planRowId ?? planRow?.id ?? null;
      if (planRowId !== null) {
        orchestratorMessagesDb.updatePayload(planRowId, {
          steps: steps.map((s) => ({ id: s.id, type: s.type, title: s.title, prompt: s.prompt, dependsOn: s.dependsOn, enabled: s.enabled })),
          awaitingConfirm: false,
        });
      } else {
        append(sessionId, 'plan', {
          steps: steps.map((s) => ({ id: s.id, type: s.type, title: s.title, prompt: s.prompt, dependsOn: s.dependsOn, enabled: s.enabled })),
          awaitingConfirm: false,
        });
      }
      return executeSteps(input, config, steps, planRowId ?? -1);
    },

    async resume(sessionId: string, options: AnyRecord): Promise<OrchestrateResult> {
      // TaskMaster queue mode needs no prior plan — the loop emits its own
      // plan/delegation rows per task, so it dispatches before the last-plan
      // lookup below.
      if (options.mode === 'complete-all-tasks') {
        return completeAllTasks(sessionId, options);
      }
      const rows = orchestratorMessagesDb.list(sessionId);
      const lastPlan = [...rows].reverse().find((row) => row.kind === 'plan') ?? null;
      if (!lastPlan) {
        return { ok: false, code: 'NOTHING_TO_RESUME', error: 'No plan found to resume.' };
      }
      const lastSummary = [...rows].reverse().find((row) => row.kind === 'summary') ?? null;
      const failedIds = new Set(strArr(lastSummary?.payload.failed));
      // Steps the user already chose to continue past stay skipped.
      for (const id of strArr(lastSummary?.payload.continued)) failedIds.delete(id);

      const targetStepId =
        typeof options.stepId === 'string' && options.stepId.trim() ? options.stepId.trim() : null;
      const isExplicitContinue = options.mode === 'continue';

      if (!targetStepId && !isExplicitContinue && failedIds.size === 0) {
        return { ok: false, code: 'NOTHING_TO_RESUME', error: 'No failed steps left to resume.' };
      }

      const planSteps = (Array.isArray(lastPlan.payload.steps) ? lastPlan.payload.steps : []) as Record<
        string,
        unknown
      >[];

      // Rebuild the handoff channel from the earlier run: each finished
      // step's final answer feeds the rerun step's dependency summary.
      const summaries = new Map<string, string>();
      const delegationRowByStep = new Map<string, number>();
      for (const row of rows) {
        if (row.kind !== 'delegation') continue;
        const stepId = typeof row.payload.stepId === 'string' ? row.payload.stepId : null;
        if (!stepId) continue;
        delegationRowByStep.set(stepId, row.id);
        if (
          row.payload.status === 'done'
          && typeof row.payload.finalText === 'string'
          && row.payload.finalText
        ) {
          summaries.set(stepId, row.payload.finalText.slice(-MAX_STEP_SUMMARY));
        }
      }

      const allPlanIds = new Set(planSteps.map((s) => String(s.id)));
      let rerun: OrchestratorPlanStep[];
      let settledIds: string[];

      if (targetStepId) {
        const targetStep = planSteps.find((s) => String(s.id) === targetStepId);
        if (!targetStep) {
          return { ok: false, code: 'STEP_NOT_FOUND', error: `Step ${targetStepId} not found in plan` };
        }
        const contIndex =
          planSteps.filter(
            (s) =>
              String(s.id).startsWith(`fix-${targetStepId}`) ||
              String(s.id).startsWith(`cont-${targetStepId}`),
          ).length + 1;
        const fixStepId = `cont-${targetStepId}-${contIndex}`;
        const targetType = targetStep.type as OrchestratorTaskType;
        const verifyType: OrchestratorTaskType = targetType === 'test' ? 'test' : 'review';
        const verifyStepId = `${verifyType}-${targetStepId}-${contIndex}`;

        const lastOutput = summaries.get(targetStepId) || '';
        const customPrompt =
          typeof options.prompt === 'string' && options.prompt.trim() ? options.prompt.trim() : '';
        const fixPrompt = customPrompt
          ? `${customPrompt}\n\nContext from step ${String(targetStep.title || targetStep.id)}:\n${lastOutput}`
          : `Continue work and resolve issues for step "${String(targetStep.title || targetStep.id)}":\n\n${lastOutput}`;
        const verifyPrompt =
          verifyType === 'test'
            ? `Run tests to verify that the changes made in ${fixStepId} for step "${String(targetStep.title || targetStep.id)}" succeed.`
            : `Review the changes made in ${fixStepId} for step "${String(targetStep.title || targetStep.id)}".`;

        const newFixStep: OrchestratorPlanStep = {
          id: fixStepId,
          type: 'code',
          title: `continue / fix: ${String(targetStep.title || targetStep.id)}`,
          prompt: fixPrompt,
          dependsOn: [targetStepId],
          enabled: true,
        };
        const newVerifyStep: OrchestratorPlanStep = {
          id: verifyStepId,
          type: verifyType,
          title: `${verifyType}: verify ${String(targetStep.title || targetStep.id)}`,
          prompt: verifyPrompt,
          dependsOn: [targetStepId, fixStepId],
          enabled: true,
        };

        const updatedSteps = [...planSteps, newFixStep, newVerifyStep];
        patch(lastPlan.id, {
          steps: updatedSteps.map((s) => ({
            id: s.id,
            type: s.type,
            title: s.title,
            prompt: s.prompt,
            dependsOn: strArr(s.dependsOn),
            enabled: s.enabled !== false,
          })),
        });

        settledIds = [...allPlanIds];
        rerun = [newFixStep, newVerifyStep];
      } else if (isExplicitContinue && failedIds.size === 0) {
        return this.continueSession(
          sessionId,
          typeof options.prompt === 'string' && options.prompt.trim() ? options.prompt.trim() : undefined,
          options.customSteps ?? options.steps,
          options,
        );
      } else {
        rerun = planSteps
          .filter((s) => failedIds.has(String(s.id)) && s.enabled !== false)
          .map(
            (s): OrchestratorPlanStep => ({
              id: String(s.id),
              type: s.type as OrchestratorTaskType,
              title:
                typeof s.title === 'string' && s.title.trim() ? s.title : String(s.id),
              prompt:
                typeof s.prompt === 'string' && s.prompt.trim()
                  ? s.prompt
                  : `Continue the unfinished work for step "${s.title}".`,
              dependsOn: strArr(s.dependsOn),
              enabled: true,
            }),
          );
        if (rerun.length === 0) {
          return { ok: false, code: 'NOTHING_TO_RESUME', error: 'No failed steps left to resume.' };
        }
        settledIds = [...allPlanIds].filter((id) => !failedIds.has(id));
      }

      const config = deps.getConfig();
      const input: OrchestrateInput = {
        sessionId,
        content: '',
        options,
        connection: { readyState: 0, send: () => undefined } as unknown as OrchestrateInput['connection'],
      };
      return executeSteps(input, config, rerun, lastPlan.id, {
        settledIds,
        summaries,
        delegationRowByStep,
      });
    },

    async continueSession(
      sessionId: string,
      prompt?: string,
      customSteps?: unknown,
      options: AnyRecord = {},
    ): Promise<OrchestrateResult> {
      const rows = orchestratorMessagesDb.list(sessionId);
      const lastPlan = [...rows].reverse().find((row) => row.kind === 'plan') ?? null;
      if (!lastPlan) {
        return { ok: false, code: 'NOTHING_TO_RESUME', error: 'No plan found to continue.' };
      }
      const planSteps = (Array.isArray(lastPlan.payload.steps) ? lastPlan.payload.steps : []) as Record<
        string,
        unknown
      >[];
      const priorContext = extractPriorSessionContext(rows);
      const allPlanIds = planSteps.map((s) => String(s.id));

      const input: OrchestrateInput = {
        sessionId,
        content: prompt ?? '',
        options,
        connection: { readyState: 0, send: () => undefined } as unknown as OrchestrateInput['connection'],
      };

      const config = deps.getConfig();
      let newSteps: OrchestratorPlanStep[] = [];

      if (Array.isArray(customSteps) && customSteps.length > 0) {
        newSteps = normalizeEditableSteps(customSteps, prompt ?? '', priorContext.stepOffset);
      } else if (prompt && options.mode !== 'continue' && config.planner.mode !== 'off') {
        const planOutcome = await plan(input, config, priorContext);
        newSteps = ensureReviewStep(planOutcome.steps, priorContext.stepOffset);
      } else {
        const contIndex = planSteps.filter((s) => String(s.id).startsWith('continue-')).length + 1;
        const contStepId = `continue-${contIndex}`;
        const reviewStepId = `review-continue-${contIndex}`;
        const lastSummaryText = priorContext.summaryText || 'Previous session completed.';
        const newContStep: OrchestratorPlanStep = {
          id: contStepId,
          type: 'code',
          title: `continue ${contIndex}: follow-up work`,
          prompt: prompt ? `${prompt}\n\nPrevious summary:\n${lastSummaryText}` : `Continue work:\n${lastSummaryText}`,
          dependsOn: [...allPlanIds],
          enabled: true,
        };
        const newReviewStep: OrchestratorPlanStep = {
          id: reviewStepId,
          type: 'review',
          title: `review continue ${contIndex}: verify changes`,
          prompt: `Review the changes made in ${contStepId} to ensure quality and correctness.`,
          dependsOn: [contStepId],
          enabled: true,
        };
        newSteps = [newContStep, newReviewStep];
      }

      if (newSteps.length === 0) {
        return { ok: false, code: 'NOTHING_TO_RESUME', error: 'No new steps were generated to continue.' };
      }

      const updatedSteps = [...planSteps, ...newSteps];
      patch(lastPlan.id, {
        steps: updatedSteps.map((s) => ({
          id: s.id,
          type: s.type,
          title: s.title,
          prompt: s.prompt,
          dependsOn: strArr(s.dependsOn),
          enabled: s.enabled !== false,
        })),
      });

      const delegationRowByStep = new Map<string, number>();
      for (const row of rows) {
        if (row.kind !== 'delegation') continue;
        const stepId = typeof row.payload.stepId === 'string' ? row.payload.stepId : null;
        if (!stepId) continue;
        delegationRowByStep.set(stepId, row.id);
      }
      const summaries = new Map<string, string>(priorContext.completedSummaries);

      return executeSteps(input, config, newSteps, lastPlan.id, {
        settledIds: allPlanIds,
        summaries,
        delegationRowByStep,
      });
    },

    completeAllTasks,

    async abort(sessionId: string): Promise<boolean> {
      pendingPlans.delete(sessionId);
      // Covers the rate-limit backoff too — a run sleeping between attempts
      // has no child handle to cancel, so the flag drains it instead.
      abortedParents.add(sessionId);
      const set = activeRuns.get(sessionId);
      if (set && set.size > 0) {
        await Promise.all([...set].map((abort) => abort().catch(() => undefined)));
      }
      return true;
    },
  };
}
