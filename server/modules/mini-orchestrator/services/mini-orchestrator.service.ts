import { orchestratorMessagesDb, sessionsDb } from '@/modules/database/index.js';
import type { OrchestratorDelegationService } from '@/modules/orchestrator/index.js';
import { classifyTaskType } from '@/shared/utils.js';
import type {
  AnyRecord,
  MiniOrchestratorConfig,
  MiniOrchestratorRole,
  OrchestratorCandidate,
  OrchestratorMessage,
  OrchestratorMessageKind,
  OrchestratorPlanStep,
  OrchestratorTaskType,
} from '@/shared/types.js';

/** Task types the mini planner may emit for a delegated step. */
const STEP_TYPES: OrchestratorTaskType[] = [
  'quick',
  'research',
  'docs',
  'code',
  'code-hard',
  'test',
  'review',
];

type MiniStep = OrchestratorPlanStep;

export type MiniOrchestrateInput = {
  sessionId: string;
  content: string;
  options: AnyRecord;
};

export type MiniOrchestrateResult = { ok: true } | { ok: false; code: string; error: string };

type LaneOutcome = { ok: boolean; error: string | null; finalText: string; aborted: boolean };

/**
 * One step's settled outcome, kept for the final summary row and as context
 * chained into dependent steps.
 */
type StepResult = {
  stepId: string;
  title: string;
  status: 'done' | 'failed' | 'skipped' | 'aborted';
  error: string | null;
  finalText: string;
};

export type MiniOrchestratorExecutor = {
  run(input: MiniOrchestrateInput): Promise<MiniOrchestrateResult>;
  confirm(sessionId: string, rawSteps: unknown, options: AnyRecord): Promise<MiniOrchestrateResult>;
  resume(sessionId: string, options: AnyRecord): Promise<MiniOrchestrateResult>;
  abort(sessionId: string): Promise<boolean>;
};

/** Tolerant parse of a planner reply: `[ … ]` slice, JSON, then per-step clamp. */
function parsePlanJson(text: string, maxSteps: number, fallbackType: OrchestratorTaskType): MiniStep[] {
  const start = text.indexOf('[');
  const end = text.lastIndexOf(']');
  if (start === -1 || end <= start) return [];
  let raw: unknown;
  try {
    raw = JSON.parse(text.slice(start, end + 1));
  } catch {
    return [];
  }
  if (!Array.isArray(raw)) return [];
  const steps: MiniStep[] = [];
  const seen = new Set<string>();
  raw.slice(0, maxSteps).forEach((entry, index) => {
    if (!entry || typeof entry !== 'object' || Array.isArray(entry)) return;
    const record = entry as Record<string, unknown>;
    const type = STEP_TYPES.includes(record.type as OrchestratorTaskType)
      ? (record.type as OrchestratorTaskType)
      : fallbackType;
    const id = `step-${index + 1}`;
    const prompt = typeof record.prompt === 'string' && record.prompt.trim() ? record.prompt.trim() : '';
    if (!prompt) return;
    // dependsOn may only reference already-emitted step ids — drop the rest so a
    // hallucinated forward reference can never deadlock the scheduler.
    const dependsOn = Array.isArray(record.dependsOn)
      ? record.dependsOn.map(String).filter((dep) => seen.has(dep))
      : [];
    const command = typeof record.command === 'string' && record.command.trim() ? record.command.trim() : undefined;
    steps.push({
      id,
      type,
      title: typeof record.title === 'string' && record.title.trim() ? record.title.trim() : prompt.slice(0, 60),
      prompt,
      dependsOn,
      enabled: true,
      ...(command ? { command } : {}),
    });
    seen.add(id);
  });
  return steps;
}

/** Normalizes a client-edited step list back onto the plan step contract. */
function normalizeEditableSteps(raw: unknown, fallbackPrompt: string, fallbackType: OrchestratorTaskType): MiniStep[] {
  if (!Array.isArray(raw)) return [];
  const steps: MiniStep[] = [];
  const seen = new Set<string>();
  raw.forEach((entry, index) => {
    if (!entry || typeof entry !== 'object' || Array.isArray(entry)) return;
    const record = entry as Record<string, unknown>;
    const type = STEP_TYPES.includes(record.type as OrchestratorTaskType)
      ? (record.type as OrchestratorTaskType)
      : fallbackType;
    const id = `step-${index + 1}`;
    const prompt =
      typeof record.prompt === 'string' && record.prompt.trim() ? record.prompt.trim() : fallbackPrompt;
    const dependsOn = Array.isArray(record.dependsOn)
      ? record.dependsOn.map(String).filter((dep) => seen.has(dep))
      : [];
    steps.push({
      id,
      type,
      title: typeof record.title === 'string' && record.title.trim() ? record.title.trim() : prompt.slice(0, 60),
      prompt,
      dependsOn,
      enabled: record.enabled !== false,
    });
    seen.add(id);
  });
  return steps;
}

const serializeStep = (step: MiniStep): Record<string, unknown> => ({
  id: step.id,
  type: step.type,
  title: step.title,
  prompt: step.prompt,
  dependsOn: step.dependsOn,
  enabled: step.enabled !== false,
});

/** Planner prompt asking the thinker lane for a JSON step list. */
function buildPlannerPrompt(content: string, maxSteps: number): string {
  return [
    'You are the planner for a two-model pipeline. The worker model will execute',
    'each step you emit, so write concrete, self-contained instructions that name',
    'real files/paths where possible.',
    '',
    'Return ONLY a JSON array (no prose, no code fences). Each element:',
    '{"type": "quick"|"research"|"docs"|"code"|"code-hard"|"test"|"review",',
    ' "title": "<short label>", "prompt": "<instructions for the worker>",',
    ' "dependsOn": ["step-1", ...]}',
    '',
    `Rules: at most ${maxSteps} steps; keep it minimal (1-4 for most requests);`,
    '`dependsOn` may only reference earlier step ids.',
    '',
    'User request:',
    content,
  ].join('\n');
}

/**
 * Mini orchestrator engine: a lightweight sibling of the full orchestrator.
 *
 * Two roles only — `thinker` (non-flash) plans and reviews, `worker` (flash)
 * executes — with a per-task-type role map (`MiniOrchestratorConfig.roles`).
 * The pipeline is classify → plan → execute steps → summary, streaming the very
 * same `status` frames as the full orchestrator through the shared transcript
 * repository and delegation mirror, so the client renders both identically.
 */
export function createMiniOrchestratorExecutor(deps: {
  getConfig(): MiniOrchestratorConfig;
  delegation: OrchestratorDelegationService;
  /** Streams each appended parent-transcript row to live viewers. */
  publish?(entry: OrchestratorMessage): void;
  /** Reads the parent session's project path. */
  resolveSessionCwd?(sessionId: string): string | null;
  /** Injectable for tests — the wait used by timeouts. */
  sleep?(ms: number): Promise<void>;
}): MiniOrchestratorExecutor {
  const append = (
    sessionId: string,
    kind: OrchestratorMessageKind,
    payload: Record<string, unknown>,
  ): OrchestratorMessage => {
    const entry = orchestratorMessagesDb.append(sessionId, kind, payload);
    deps.publish?.(entry);
    return entry;
  };

  const patch = (rowId: number, payload: Record<string, unknown>): void => {
    const entry = orchestratorMessagesDb.updatePayload(rowId, payload);
    if (entry) deps.publish?.(entry);
  };

  /** Active child aborts per parent session, so `chat.abort` reaches them. */
  const activeRuns = new Map<string, Set<() => Promise<void>>>();
  const abortedParents = new Set<string>();
  /** Plans parked by `planner.requireConfirm`, waiting for `confirm`. */
  const pendingPlans = new Map<string, { planRowId: number; steps: MiniStep[] }>();

  const trackAbort = (sessionId: string, abort: () => Promise<void>): (() => void) => {
    let set = activeRuns.get(sessionId);
    if (!set) {
      set = new Set();
      activeRuns.set(sessionId, set);
    }
    set.add(abort);
    return () => set?.delete(abort);
  };

  const candidatesFor = (config: MiniOrchestratorConfig, role: MiniOrchestratorRole): OrchestratorCandidate[] =>
    role === 'thinker' ? config.thinker : config.worker;

  const resolveCwd = (sessionId: string, options: AnyRecord): string => {
    if (typeof options.cwd === 'string' && options.cwd) return options.cwd;
    return deps.resolveSessionCwd?.(sessionId) ?? sessionsDb.getSessionById(sessionId)?.project_path ?? '';
  };

  /** Runs one child lane with a timeout; aborts the child on expiry. */
  async function callLane(input: {
    parentSessionId: string;
    candidate: OrchestratorCandidate;
    cwd: string;
    command: string;
    permissionMode: string;
    timeoutMs: number;
    hidden: boolean;
    delegationRowId: number | null;
  }): Promise<LaneOutcome> {
    const handle = await deps.delegation.run({
      parentSessionId: input.parentSessionId,
      delegationRowId: input.delegationRowId,
      provider: input.candidate.provider,
      model: input.candidate.model,
      effort: input.candidate.effort,
      accountId: input.candidate.accountId,
      cwd: input.cwd,
      command: input.command,
      permissionMode: input.permissionMode,
      hidden: input.hidden,
    });
    const untrack = trackAbort(input.parentSessionId, handle.abort);
    try {
      if (input.timeoutMs > 0) {
        let timer: NodeJS.Timeout | undefined;
        const timeout = new Promise<LaneOutcome>((resolve) => {
          timer = setTimeout(() => {
            void handle.abort();
            resolve({ ok: false, error: 'step timed out', finalText: '', aborted: false });
          }, input.timeoutMs);
        });
        return await Promise.race([handle.completed, timeout]).finally(() => clearTimeout(timer));
      }
      return await handle.completed;
    } finally {
      untrack();
    }
  }

  /** Decomposes the request into steps; falls back to a single step. */
  async function buildPlan(
    input: MiniOrchestrateInput,
    config: MiniOrchestratorConfig,
    taskType: OrchestratorTaskType,
    cwd: string,
    permissionMode: string,
  ): Promise<{ steps: MiniStep[]; source: string }> {
    const single = (): MiniStep[] => [
      {
        id: 'step-1',
        type: taskType,
        title: input.content.slice(0, 60) || 'Step 1',
        prompt: input.content,
        dependsOn: [],
        enabled: true,
      },
    ];
    if (config.planner.mode === 'off') return { steps: single(), source: 'off' };

    const prompt = buildPlannerPrompt(input.content, config.execution.maxSteps);
    for (let index = 0; index < config.thinker.length; index += 1) {
      const candidate = config.thinker[index];
      append(input.sessionId, 'routing', {
        taskType: 'plan',
        candidateId: candidate.id,
        provider: candidate.provider,
        model: candidate.model,
        effort: candidate.effort,
        reason: index === 0 ? `${candidate.label} — planner` : `${candidate.label} — planner fallback ${index}`,
        label: candidate.label,
        rejected: config.thinker.slice(0, index).map((c) => c.id),
        alternatives: config.thinker.slice(index + 1).map((c) => c.id),
      });
      const outcome = await callLane({
        parentSessionId: input.sessionId,
        candidate,
        cwd,
        command: prompt,
        permissionMode,
        timeoutMs: config.execution.stepTimeoutMs,
        hidden: true,
        delegationRowId: null,
      });
      if (!outcome.ok) continue;
      const steps = parsePlanJson(outcome.finalText, config.execution.maxSteps, taskType);
      if (steps.length) return { steps, source: 'thinker' };
    }
    return { steps: single(), source: 'fallback' };
  }

  /** Emits the routing + delegation rows and runs one step with candidate failover. */
  async function runStep(
    input: MiniOrchestrateInput,
    config: MiniOrchestratorConfig,
    step: MiniStep,
    cwd: string,
    permissionMode: string,
    priorResults: StepResult[],
  ): Promise<StepResult> {
    const sessionId = input.sessionId;
    const role = config.roles[step.type] ?? 'worker';
    const candidates = candidatesFor(config, role);
    if (candidates.length === 0) {
      append(sessionId, 'routing', { taskType: step.type, error: `no ${role} candidate configured`, status: 'no_candidate' });
      return { stepId: step.id, title: step.title, status: 'failed', error: `no ${role} candidate configured`, finalText: '' };
    }

    const context = priorResults
      .filter((result) => result.status === 'done' && result.finalText)
      .map((result) => `### ${result.title}\n${result.finalText.slice(-1500)}`)
      .join('\n\n');
    const command = context ? `Context from earlier steps:\n${context}\n\n${step.prompt}` : step.prompt;

    let lastError: string | null = null;
    for (let index = 0; index < candidates.length; index += 1) {
      const candidate = candidates[index];
      append(sessionId, 'routing', {
        taskType: step.type,
        candidateId: candidate.id,
        provider: candidate.provider,
        model: candidate.model,
        effort: candidate.effort,
        reason:
          index === 0
            ? `${candidate.label} — ${role} for ${step.type}`
            : `${candidate.label} — ${role} fallback ${index}`,
        label: candidate.label,
        rejected: candidates.slice(0, index).map((c) => c.id),
        alternatives: candidates.slice(index + 1).map((c) => c.id),
      });
      const row = append(sessionId, 'delegation', {
        stepId: step.id,
        taskType: step.type,
        role,
        title: step.title,
        candidateId: candidate.id,
        provider: candidate.provider,
        model: candidate.model,
        effort: candidate.effort,
        accountId: candidate.accountId,
        tier: candidate.tier,
        status: 'queued',
      });

      const outcome = await callLane({
        parentSessionId: sessionId,
        candidate,
        cwd,
        command,
        permissionMode,
        timeoutMs: config.execution.stepTimeoutMs,
        hidden: false,
        delegationRowId: row.id,
      });

      if (outcome.ok) {
        return { stepId: step.id, title: step.title, status: 'done', error: null, finalText: outcome.finalText };
      }
      if (outcome.aborted || abortedParents.has(sessionId)) {
        return { stepId: step.id, title: step.title, status: 'aborted', error: outcome.error, finalText: '' };
      }
      lastError = outcome.error;
      patch(row.id, { status: 'failed', error: outcome.error, candidateId: candidate.id });
    }
    return { stepId: step.id, title: step.title, status: 'failed', error: lastError, finalText: '' };
  }

  /** Dependency-aware wave scheduler honouring `maxParallel` and the run timeout. */
  async function executeSteps(
    input: MiniOrchestrateInput,
    config: MiniOrchestratorConfig,
    steps: MiniStep[],
    cwd: string,
    permissionMode: string,
  ): Promise<MiniOrchestrateResult> {
    const sessionId = input.sessionId;
    abortedParents.delete(sessionId);
    const settled = new Set<string>();
    const failed = new Set<string>();
    const results: StepResult[] = [];
    const startedAt = Date.now();
    const deadline = config.execution.runTimeoutMs > 0 ? startedAt + config.execution.runTimeoutMs : 0;
    let timedOut = false;

    const record = (result: StepResult): void => {
      results.push(result);
      settled.add(result.stepId);
      if (result.status === 'failed' || result.status === 'skipped') failed.add(result.stepId);
    };

    while (settled.size < steps.length) {
      if (abortedParents.has(sessionId)) break;
      if (deadline > 0 && Date.now() > deadline) {
        timedOut = true;
        break;
      }

      const remaining = steps.filter((step) => !settled.has(step.id) && step.enabled !== false);
      // Disabled steps settle as done without running.
      for (const step of steps) {
        if (step.enabled === false && !settled.has(step.id)) settled.add(step.id);
      }
      // Steps whose dependencies failed are skipped.
      const blocked = remaining.filter((step) => step.dependsOn.some((dep) => failed.has(dep)));
      for (const step of blocked) {
        append(sessionId, 'delegation', {
          stepId: step.id,
          taskType: step.type,
          title: step.title,
          status: 'skipped',
          error: 'blocked by failed step(s)',
        });
        record({ stepId: step.id, title: step.title, status: 'skipped', error: 'blocked by failed step(s)', finalText: '' });
      }

      const ready = steps.filter(
        (step) =>
          !settled.has(step.id) &&
          step.enabled !== false &&
          step.dependsOn.every((dep) => settled.has(dep)) &&
          !step.dependsOn.some((dep) => failed.has(dep)),
      );
      if (ready.length === 0) break;

      const batch = ready.slice(0, config.execution.maxParallel);
      const batchResults = await Promise.all(
        batch.map((step) => runStep(input, config, step, cwd, permissionMode, results)),
      );
      for (const result of batchResults) record(result);
      if (batchResults.some((result) => result.status === 'aborted')) break;
    }

    const aborted = abortedParents.has(sessionId);
    for (const step of steps) {
      if (settled.has(step.id)) continue;
      const status: StepResult['status'] = aborted ? 'aborted' : timedOut ? 'failed' : 'skipped';
      const error = aborted ? 'aborted by user' : timedOut ? 'run timed out' : 'not reached';
      append(sessionId, 'delegation', { stepId: step.id, taskType: step.type, title: step.title, status, error });
      record({ stepId: step.id, title: step.title, status, error, finalText: '' });
    }

    const okCount = results.filter((result) => result.status === 'done').length;
    const failedList = results.filter((result) => result.status === 'failed' || result.status === 'skipped').map((result) => result.stepId);
    append(sessionId, 'summary', {
      text:
        `${okCount}/${steps.length} steps completed` +
        (failedList.length ? `, failed: ${failedList.join(', ')}` : '') +
        (aborted ? ' (aborted)' : '') +
        (timedOut ? ' (timed out)' : ''),
      completed: okCount,
      total: steps.length,
      failed: failedList,
      aborted,
      timedOut,
      results,
    });

    return { ok: true };
  }

  const permissionOf = (options: AnyRecord): string =>
    typeof options.permissionMode === 'string' && options.permissionMode ? options.permissionMode : 'default';

  return {
    async run(input: MiniOrchestrateInput): Promise<MiniOrchestrateResult> {
      const config = deps.getConfig();
      if (!config.enabled) {
        return { ok: false, code: 'MINI_ORCHESTRATOR_DISABLED', error: 'Mini orchestrator is disabled in Settings → Mini orchestration.' };
      }
      const sessionId = input.sessionId;
      abortedParents.delete(sessionId);
      const cwd = resolveCwd(sessionId, input.options);
      const permissionMode = permissionOf(input.options);

      append(sessionId, 'user', { content: input.content });

      const hint = typeof input.options.taskType === 'string' ? input.options.taskType : null;
      const taskType = classifyTaskType(input.content, hint);
      const { steps, source } = await buildPlan(input, config, taskType, cwd, permissionMode);

      const planRow = append(sessionId, 'plan', {
        steps: steps.map(serializeStep),
        awaitingConfirm: config.planner.requireConfirm,
        source,
      });

      if (abortedParents.has(sessionId)) {
        return { ok: false, code: 'ABORTED', error: 'Aborted by user.' };
      }
      if (config.planner.requireConfirm) {
        pendingPlans.set(sessionId, { planRowId: planRow.id, steps });
        return { ok: true };
      }
      return executeSteps(input, config, steps, cwd, permissionMode);
    },

    async confirm(sessionId: string, rawSteps: unknown, options: AnyRecord): Promise<MiniOrchestrateResult> {
      const config = deps.getConfig();
      const cwd = resolveCwd(sessionId, options);
      const permissionMode = permissionOf(options);
      const pending = pendingPlans.get(sessionId);
      pendingPlans.delete(sessionId);
      const fallbackType = classifyTaskType(
        typeof options.prompt === 'string' ? options.prompt : '',
      );
      const edited = normalizeEditableSteps(rawSteps, '', fallbackType);
      const steps = edited.length ? edited : pending?.steps ?? [];
      if (steps.length === 0) {
        return { ok: false, code: 'NOTHING_TO_CONFIRM', error: 'No plan is waiting for confirmation.' };
      }
      if (pending) patch(pending.planRowId, { awaitingConfirm: false, steps: steps.map(serializeStep) });
      return executeSteps(
        { sessionId, content: '', options },
        config,
        steps,
        cwd,
        permissionMode,
      );
    },

    async resume(sessionId: string, options: AnyRecord): Promise<MiniOrchestrateResult> {
      const config = deps.getConfig();
      const rows = orchestratorMessagesDb.list(sessionId);
      const planRow = [...rows].reverse().find((row) => row.kind === 'plan' && Array.isArray(row.payload.steps));
      const rawSteps = (planRow?.payload.steps as unknown[]) ?? [];
      const fallbackType = classifyTaskType(typeof options.prompt === 'string' ? options.prompt : '');
      const steps = normalizeEditableSteps(rawSteps, '', fallbackType);
      if (steps.length === 0) {
        return { ok: false, code: 'NOTHING_TO_RESUME', error: 'No prior plan to resume.' };
      }
      patch(planRow!.id, { awaitingConfirm: false });
      const cwd = resolveCwd(sessionId, options);
      return executeSteps({ sessionId, content: '', options }, config, steps, cwd, permissionOf(options));
    },

    async abort(sessionId: string): Promise<boolean> {
      abortedParents.add(sessionId);
      pendingPlans.delete(sessionId);
      const set = activeRuns.get(sessionId);
      if (!set || set.size === 0) return false;
      await Promise.all([...set].map((abort) => abort().catch(() => undefined)));
      activeRuns.delete(sessionId);
      return true;
    },
  };
}
