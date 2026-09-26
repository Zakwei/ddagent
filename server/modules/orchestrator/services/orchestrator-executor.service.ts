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

/**
 * Worktree surface the executor needs (wired to `worktreeServices` in the
 * module composition root). Kept structural so tests inject a stub.
 */
type WorktreeCreator = {
  create(input: { projectPath: string; branch: string }): Promise<{ worktreePath: string; branch: string }>;
};

/**
 * Normalizes client-edited steps from `POST /plan/confirm`. Keeps the
 * submitted ids/`enabled` flags (the point of confirm is user edits) but
 * enforces the same invariants as planner output: known non-`plan` types,
 * string prompts, no dangling deps.
 */
export function normalizeEditableSteps(raw: unknown, fallbackPrompt: string): OrchestratorPlanStep[] {
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
  for (const step of steps) {
    step.dependsOn = step.dependsOn.filter((dep) => ids.has(dep) && dep !== step.id);
  }
  return steps;
}

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

function toPlanSteps(raw: RawPlanStep[], fallbackPrompt: string): OrchestratorPlanStep[] {
  const steps = raw
    .map((entry, index): OrchestratorPlanStep | null => {
      const type = entry.type as OrchestratorTaskType;
      if (!TASK_TYPES.includes(type) || type === 'plan') return null;
      return {
        id: `step-${index + 1}`,
        type,
        title: typeof entry.title === 'string' && entry.title.trim() ? entry.title.trim() : `Step ${index + 1}`,
        prompt:
          typeof entry.prompt === 'string' && entry.prompt.trim()
            ? entry.prompt.trim()
            : fallbackPrompt,
        dependsOn: Array.isArray(entry.dependsOn) ? entry.dependsOn.map(String) : [],
        enabled: true,
      };
    })
    .filter((step): step is OrchestratorPlanStep => step !== null);
  // Drop dangling deps so a hallucinated edge cannot deadlock the DAG.
  const ids = new Set(steps.map((s) => s.id));
  for (const step of steps) {
    step.dependsOn = step.dependsOn.filter((dep) => ids.has(dep) && dep !== step.id);
  }
  return steps;
}

function buildPlannerPrompt(content: string): string {
  return [
    'You are a task planner. Split the user request into typed subtasks.',
    `Allowed types: ${TASK_TYPES.filter((t) => t !== 'plan').join(', ')}.`,
    'Rules: analysis/comparison of existing code is research, not code. Any plan that modifies code must end with a review step. Cheap work (code, test, docs, quick) goes on small models; review goes LAST.',
    'Use a single step ONLY for a trivial single-purpose request; requests mixing analysis and implementation need separate steps.',
    'Output ONLY a JSON array: [{"type":"...","title":"short","prompt":"full instruction for the sub-agent","dependsOn":["step-N"]}]. Step ids are step-1, step-2, ... in order.',
    '',
    `Request: ${content}`,
  ].join('\n');
}

/**
 * Deterministic safety net on top of the planner: a plan that touches code
 * but never schedules a review gets one appended, depending on every prior
 * enabled step. Guarantees the "implement → review" pipeline even when the
 * planner LLM under-decomposes.
 */
function ensureReviewStep(steps: OrchestratorPlanStep[]): OrchestratorPlanStep[] {
  const enabled = steps.filter((s) => s.enabled);
  const touchesCode = enabled.some((s) => s.type === 'code' || s.type === 'code-hard');
  const hasReview = enabled.some((s) => s.type === 'review');
  if (!touchesCode || hasReview) return steps;
  return [
    ...steps,
    {
      id: `step-${steps.length + 1}`,
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
 * Review verdict contract: the review prompt asks for a trailing
 * `VERDICT: PASS` / `VERDICT: ISSUES` line so the executor can loop a fix
 * without parsing prose.
 */
const VERDICT_ISSUES = /VERDICT:\s*ISSUES/i;

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

  const singleStep = (input: OrchestrateInput): OrchestratorPlanStep[] => [
    {
      id: 'step-1',
      type: deps.router.classify(input.content),
      title: input.content.slice(0, 60),
      prompt: input.content,
      dependsOn: [],
      enabled: true,
    },
  ];

  async function plan(input: OrchestrateInput, config: OrchestratorConfig): Promise<PlanOutcome> {
    // Template mode: the composer chip names a configured pipeline.
    const templateName = typeof input.options.template === 'string' ? input.options.template : null;
    const template = config.planner.templates.find((t) => t.name === templateName);
    if (config.planner.mode === 'template' || template) {
      const steps = (template?.steps ?? ['code' as OrchestratorTaskType]);
      return {
        source: template ? 'template' : 'template-default',
        steps: steps.map((type, index) => ({
          id: `step-${index + 1}`,
          type,
          title: `${template?.name ?? 'task'} · ${type}`,
          prompt: input.content,
          dependsOn: index === 0 ? [] : [`step-${index}`],
          enabled: true,
        })),
      };
    }

    if (config.planner.mode === 'off') {
      return { source: 'off', steps: singleStep(input) };
    }

    // 'auto': ask the planner candidate for a JSON decomposition.
    const plannerCandidate = config.pool.find((c) => c.id === config.planner.candidateId);
    if (!plannerCandidate) {
      return { source: 'planner-missing', steps: singleStep(input) };
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
        command: buildPlannerPrompt(input.content),
        permissionMode: 'bypassPermissions',
      });
      const result = await handle.completed;
      const parsed = result.finalText ? parsePlanJson(result.finalText) : null;
      const steps = parsed ? toPlanSteps(parsed, input.content) : [];
      if (steps.length > 0) return { source: 'planner', steps };
      console.warn('[Orchestrator] Planner returned no usable steps, single-step fallback.');
      return { source: 'planner-fallback', steps: singleStep(input) };
    } catch (error) {
      console.warn('[Orchestrator] Planner failed, single-step fallback:', error);
      return { source: 'planner-error', steps: singleStep(input) };
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
      const reviewHint =
        step.type === 'review'
          ? '\n\nEnd your reply with a line exactly: VERDICT: PASS or VERDICT: ISSUES'
          : '';

      // Route order = attempt order: the first viable alternative absorbs
      // the single automatic retry so a provider-local failure fails over
      // instead of repeating on the same dead lane. A rate-limit failure is
      // the exception — it stays on the same lane (free models like SWE-2
      // are worth a short wait rather than paid quota).
      const candidates = [
        routed.candidate,
        ...routed.decision.alternatives
          .map((id) => config.pool.find((c) => c.id === id))
          .filter((c): c is OrchestratorCandidate => Boolean(c)),
      ];

      let attempt = 0;
      let candidateIndex = 0;
      for (;;) {
        attempt += 1;
        const candidate = candidates[candidateIndex % candidates.length];
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
          command: command + reviewHint,
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
          // Fix loop: a review that reports issues appends a corrective step
          // routed through the cheap 'test'/'code' lane, bounded by config.
          if (step.type === 'review' && VERDICT_ISSUES.test(result.finalText)) {
            const fixCount = steps.filter((s) => s.type === 'test' && s.title.startsWith('fix')).length;
            if (fixCount < config.execution.maxFixLoops) {
              steps.push({
                id: `fix-${fixCount + 1}`,
                type: 'test',
                title: `fix ${fixCount + 1}: issues from ${step.title}`,
                prompt: `Fix the issues found in review:\n${result.finalText.slice(-1500)}`,
                dependsOn: [step.id],
                enabled: true,
              });
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

        if (attempt === 1) {
          if (RATE_LIMIT_RE.test(result.error ?? '')) {
            patch(delegationRow.id, { status: 'queued', rateLimited: true });
            await sleep(RATE_LIMIT_RETRY_DELAY_MS);
            if (abortedParents.has(sessionId)) {
              runAborted = true;
              failed.add(step.id);
              break;
            }
            // candidateIndex unchanged → retry stays on the same lane.
          } else {
            candidateIndex += 1;
          }
          continue;
        }

        // The automatic retry also failed — the run ends here for this step;
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
    append(sessionId, 'summary', {
      text:
        `${okCount}/${total} steps completed` +
        (failedList.length ? `, failed: ${failedList.join(', ')}` : '') +
        (runAborted ? ' (aborted)' : ''),
      failed: failedList,
      aborted: runAborted,
    });

    return failed.size === total && total > 0
      ? { ok: false, code: 'ALL_STEPS_FAILED', error: `All ${total} steps failed` }
      : { ok: true };
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
      const rows = orchestratorMessagesDb.list(sessionId);
      const lastPlan = [...rows].reverse().find((row) => row.kind === 'plan') ?? null;
      const lastSummary = [...rows].reverse().find((row) => row.kind === 'summary') ?? null;
      const strArr = (value: unknown): string[] =>
        Array.isArray(value) ? value.map(String).filter((v) => v.trim()) : [];

      const failedIds = new Set(strArr(lastSummary?.payload.failed));
      // Steps the user already chose to continue past stay skipped.
      for (const id of strArr(lastSummary?.payload.continued)) failedIds.delete(id);
      if (!lastPlan || failedIds.size === 0) {
        return { ok: false, code: 'NOTHING_TO_RESUME', error: 'No failed steps left to resume.' };
      }

      const planSteps = (Array.isArray(lastPlan.payload.steps) ? lastPlan.payload.steps : []) as Record<
        string,
        unknown
      >[];
      const rerun = planSteps
        .filter((s) => failedIds.has(String(s.id)) && s.enabled !== false)
        .map(
          (s): OrchestratorPlanStep => ({
            id: String(s.id),
            type: s.type as OrchestratorTaskType,
            title:
              typeof s.title === 'string' && s.title.trim() ? s.title : String(s.id),
            // Plan rows written before prompts were persisted fall back to a
            // generic continuation prompt.
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
      const settledIds = [...allPlanIds].filter((id) => !failedIds.has(id));

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
