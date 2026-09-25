import { orchestratorMessagesDb } from '@/modules/database/index.js';
import type { OrchestratorDelegationService } from '@/modules/orchestrator/services/orchestrator-delegation.service.js';
import type { OrchestratorRouter } from '@/modules/orchestrator/services/orchestrator-router.service.js';
import type {
  AnyRecord,
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
    'Rules: cheap work (code, test, docs, quick) on small models; review goes LAST on a stronger model; use multiple steps ONLY when the request genuinely mixes types.',
    'Output ONLY a JSON array: [{"type":"...","title":"short","prompt":"full instruction for the sub-agent","dependsOn":["step-N"]}]. Step ids are step-1, step-2, ... in order.',
    '',
    `Request: ${content}`,
  ].join('\n');
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
}): OrchestratorExecutor {
  const append = (sessionId: string, kind: Parameters<typeof orchestratorMessagesDb.append>[1], payload: Record<string, unknown>) => {
    const entry = orchestratorMessagesDb.append(sessionId, kind, payload);
    deps.publish?.(entry);
    return entry;
  };
  /** Active child aborts per parent session, so `chat.abort` reaches them. */
  const activeRuns = new Map<string, Set<() => Promise<void>>>();

  const trackAbort = (sessionId: string, abort: () => Promise<void>) => {
    let set = activeRuns.get(sessionId);
    if (!set) {
      set = new Set();
      activeRuns.set(sessionId, set);
    }
    set.add(abort);
    return () => set?.delete(abort);
  };

  async function plan(input: OrchestrateInput, config: OrchestratorConfig): Promise<OrchestratorPlanStep[]> {
    // Template mode: the composer chip names a configured pipeline.
    const templateName = typeof input.options.template === 'string' ? input.options.template : null;
    const template = config.planner.templates.find((t) => t.name === templateName);
    if (config.planner.mode === 'template' || template) {
      const steps = (template?.steps ?? ['code' as OrchestratorTaskType]);
      return steps.map((type, index) => ({
        id: `step-${index + 1}`,
        type,
        title: `${template?.name ?? 'task'} · ${type}`,
        prompt: input.content,
        dependsOn: index === 0 ? [] : [`step-${index}`],
        enabled: true,
      }));
    }

    if (config.planner.mode === 'off') {
      const type = deps.router.classify(
        input.content,
        typeof input.options.taskType === 'string' ? input.options.taskType : null,
      );
      return [
        { id: 'step-1', type, title: input.content.slice(0, 60), prompt: input.content, dependsOn: [], enabled: true },
      ];
    }

    // 'auto': ask the planner candidate for a JSON decomposition.
    const plannerCandidate = config.pool.find((c) => c.id === config.planner.candidateId);
    if (!plannerCandidate) {
      return [
        { id: 'step-1', type: deps.router.classify(input.content), title: input.content.slice(0, 60), prompt: input.content, dependsOn: [], enabled: true },
      ];
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
      if (steps.length > 0) return steps;
    } catch (error) {
      console.warn('[Orchestrator] Planner failed, single-step fallback:', error);
    }
    return [
      { id: 'step-1', type: deps.router.classify(input.content), title: input.content.slice(0, 60), prompt: input.content, dependsOn: [], enabled: true },
    ];
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
  ): Promise<OrchestrateResult> {
    const sessionId = input.sessionId;
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

    const summaries = new Map<string, string>();
    const settled = new Set<string>(steps.filter((s) => !s.enabled).map((s) => s.id));
    const failed = new Set<string>();

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

      const delegationRow = append(sessionId, 'delegation', {
        stepId: step.id,
        taskType: step.type,
        title: step.title,
        provider: routed.candidate.provider,
        model: routed.candidate.model,
        effort: routed.decision.effort,
        tier: routed.candidate.tier,
        status: 'queued',
      });

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

      const handle = await deps.delegation.run({
        parentSessionId: sessionId,
        delegationRowId: delegationRow.id,
        provider: routed.candidate.provider,
        model: routed.candidate.model,
        effort: routed.decision.effort,
        accountId: routed.candidate.accountId,
        cwd,
        command: command + reviewHint,
        permissionMode:
          typeof input.options.permissionMode === 'string'
            ? input.options.permissionMode
            : 'bypassPermissions',
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
      } else {
        failed.add(step.id);
      }
      settled.add(step.id);
    };

    // Wave scheduler: scan the (growable) step list each pass — fix steps
    // pushed mid-run join naturally. `settled` covers done/failed/skipped and
    // user-disabled steps (a disabled dep does not block its dependents).
    for (;;) {
      const waiting = steps.filter((s) => !settled.has(s.id));
      if (waiting.length === 0) break;

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
      text: `${okCount}/${total} steps completed${failedList.length ? `, failed: ${failedList.join(', ')}` : ''}`,
      failed: failedList,
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

      const steps = await plan(input, config);
      const planRow = append(sessionId, 'plan', {
        steps: steps.map((s) => ({ id: s.id, type: s.type, title: s.title, dependsOn: s.dependsOn, enabled: s.enabled })),
        awaitingConfirm: config.planner.requireConfirm,
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
      const steps = normalizeEditableSteps(rawSteps, pending?.steps[0]?.prompt ?? '');
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
          steps: steps.map((s) => ({ id: s.id, type: s.type, title: s.title, dependsOn: s.dependsOn, enabled: s.enabled })),
          awaitingConfirm: false,
        });
      } else {
        append(sessionId, 'plan', {
          steps: steps.map((s) => ({ id: s.id, type: s.type, title: s.title, dependsOn: s.dependsOn, enabled: s.enabled })),
          awaitingConfirm: false,
        });
      }
      return executeSteps(input, config, steps, planRowId ?? -1);
    },

    async abort(sessionId: string): Promise<boolean> {
      pendingPlans.delete(sessionId);
      const set = activeRuns.get(sessionId);
      if (!set || set.size === 0) return false;
      await Promise.all([...set].map((abort) => abort().catch(() => undefined)));
      return true;
    },
  };
}
