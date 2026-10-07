import { exec } from 'node:child_process';
import { appendFile, mkdir, readdir, readFile } from 'node:fs/promises';
import { join } from 'node:path';
import { promisify } from 'node:util';

import { orchestratorMessagesDb } from '@/modules/database/index.js';
import type { OrchestratorDelegationService } from '@/modules/orchestrator/services/orchestrator-delegation.service.js';
import type { OrchestratorRouter } from '@/modules/orchestrator/services/orchestrator-router.service.js';
import {
  buildGoalsPrompt,
  buildReportPrompt,
  buildSupervisorLedger,
  buildSupervisorPrompt,
  doneGateOverride,
  normalizeProposedSteps,
  parseDecisionJson,
  parseGoalsJson,
} from '@/modules/orchestrator/services/orchestrator-supervisor.service.js';
import type {
  AnyRecord,
  OrchestratorCandidate,
  OrchestratorConfig,
  OrchestratorFailureClass,
  OrchestratorGoals,
  OrchestratorPlanStep,
  OrchestratorStepArtifact,
  OrchestratorSupervisorDecision,
  OrchestratorTaskType,
  RealtimeClientConnection,
} from '@/shared/types.js';
import { classifyStepError, execCliFile } from '@/shared/utils.js';

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
  /** Gate steps carry the shell command instead of delegating a prompt. */
  command?: unknown;
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
  'gate',
  'report',
];

/**
 * Types that route a lane but can never be delegated as plan steps: `plan`
 * is the supervisor lane itself, `report` is the final-report lane.
 */
const NON_STEP_TYPES = new Set<OrchestratorTaskType>(['plan', 'report']);

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
 * Result of one gate command run: exit code, combined stdout/stderr tail,
 * and whether the run was killed on its timeout budget.
 */
export type GateRunResult = { code: number; output: string; timedOut: boolean };

const execAsync = promisify(exec);
const execFileAsync = execCliFile;

/**
 * Default gate runner: executes the gate command in the step's working
 * directory through a shell. Consumed by executor default + tests.
 */
export async function runGateCommand(command: string, cwd: string, timeoutMs: number): Promise<GateRunResult> {
  const options = {
    cwd,
    timeout: timeoutMs > 0 ? timeoutMs : undefined,
    maxBuffer: 4 << 20,
    env: process.env,
    windowsHide: true,
  };
  try {
    const { stdout, stderr } = await execAsync(command, options);
    return { code: 0, output: `${stdout}${stderr}`.slice(-4000), timedOut: false };
  } catch (error) {
    const err = error as {
      code?: unknown;
      stdout?: string;
      stderr?: string;
      message?: string;
      killed?: boolean;
      signal?: string;
    };
    return {
      code: typeof err.code === 'number' ? err.code : 1,
      output: `${err.stdout ?? ''}${err.stderr ?? ''}${err.message ?? ''}`.slice(-4000),
      timedOut: err.killed === true || err.signal === 'SIGTERM',
    };
  }
}

/**
 * Default changed-files probe: paths from `git status --porcelain` in the
 * step's working directory (chars 3+ skip the XY status columns). Consumed
 * by executor default + tests; returns an empty set when cwd is not a repo
 * or git fails — artifact probing is best-effort, never fatal.
 */
export async function gitStatusFiles(cwd: string): Promise<Set<string>> {
  try {
    const { stdout } = await execFileAsync('git', ['status', '--porcelain'], { cwd, timeout: 10_000 });
    const files = new Set<string>();
    for (const line of stdout.split('\n')) {
      if (line.length < 4) continue;
      files.add(line.slice(3).trim());
    }
    return files;
  } catch {
    return new Set();
  }
}

/**
 * Default repo-map builder for planner context: top-level entries (dirs
 * first, dotfiles and node_modules skipped, ~60 names cap), detected
 * manifests, and a codegraph file tree when the project carries a
 * `.codegraph/` index. Consumed by executor default + tests; returns null
 * on failure or empty output — planner context is best-effort.
 */
export async function buildRepoMap(cwd: string): Promise<string | null> {
  try {
    const entries = await readdir(cwd, { withFileTypes: true });
    const visible = entries.filter((e) => !e.name.startsWith('.') && e.name !== 'node_modules');
    const dirs = visible.filter((e) => e.isDirectory()).map((e) => `${e.name}/`);
    const files = visible.filter((e) => !e.isDirectory()).map((e) => e.name);
    const lines = [...dirs, ...files].slice(0, 60);

    const fileSet = new Set(files);
    const manifests: string[] = [];
    if (fileSet.has('package.json')) {
      try {
        const pkg = JSON.parse(await readFile(join(cwd, 'package.json'), 'utf8')) as {
          name?: unknown;
          scripts?: unknown;
        };
        const scriptKeys =
          pkg.scripts && typeof pkg.scripts === 'object' ? Object.keys(pkg.scripts).join(', ') : '';
        manifests.push(
          `package.json${typeof pkg.name === 'string' ? ` (name: ${pkg.name})` : ''}${scriptKeys ? ` — scripts: ${scriptKeys}` : ''}`,
        );
      } catch {
        manifests.push('package.json');
      }
    }
    for (const manifest of ['Cargo.toml', 'go.mod', 'pyproject.toml', 'pubspec.yaml', 'requirements.txt']) {
      if (fileSet.has(manifest)) manifests.push(manifest);
    }

    let map = lines.join('\n');
    if (manifests.length > 0) map += `\n\nManifests: ${manifests.join('; ')}`;

    // An indexed project gets its real file tree appended — the planner
    // references these paths in step prompts instead of guessing.
    if (entries.some((e) => e.isDirectory() && e.name === '.codegraph')) {
      try {
        const { stdout } = await execFileAsync(
          'codegraph',
          ['files', '-p', cwd, '--format', 'tree', '--max-depth', '3', '--no-metadata'],
          { timeout: 15_000 },
        );
        const tree = stdout.slice(0, 6000).trim();
        if (tree) map += `\n\nCodeGraph file tree:\n${tree}`;
      } catch {
        // codegraph binary missing or timed out — the top-level map stands.
      }
    }
    return map.trim() ? map : null;
  } catch {
    return null;
  }
}

/**
 * Plan-row wire shape for one step. `command` rides along so gate steps
 * survive plan-row round-trips (confirm edits, fix-loop appends, resume).
 * Tolerant of the untyped records read back from stored plan payloads.
 */
const serializeStep = (s: {
  id?: unknown;
  type?: unknown;
  title?: unknown;
  prompt?: unknown;
  dependsOn?: unknown;
  enabled?: unknown;
  command?: unknown;
}) => ({
  id: s.id,
  type: s.type,
  title: s.title,
  prompt: s.prompt,
  dependsOn: Array.isArray(s.dependsOn) ? s.dependsOn.map(String).filter((v) => v.trim()) : [],
  enabled: s.enabled !== false,
  command: typeof s.command === 'string' && s.command.trim() ? s.command.trim() : undefined,
});

/**
 * Reads a stored step artifact off a delegation payload — prefers the
 * structured `artifact` written by a successful step, else derives one
 * from the row's finalText (rows written before artifacts existed).
 */
const artifactFromPayload = (payload: Record<string, unknown>): OrchestratorStepArtifact | null => {
  const stored = payload.artifact;
  if (stored && typeof stored === 'object' && typeof (stored as { summary?: unknown }).summary === 'string') {
    return stored as OrchestratorStepArtifact;
  }
  if (payload.status === 'done' && typeof payload.finalText === 'string' && payload.finalText) {
    return { summary: payload.finalText.slice(-MAX_STEP_SUMMARY), changedFiles: [], keyPaths: [] };
  }
  return null;
};

/** Default scratchpad writer — appends a section to `<cwd>/.orchestrator/scratchpad.md`. */
async function appendScratchpadSection(cwd: string, section: string): Promise<void> {
  await mkdir(join(cwd, '.orchestrator'), { recursive: true });
  await appendFile(join(cwd, '.orchestrator', 'scratchpad.md'), section, 'utf8');
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
      if (!TASK_TYPES.includes(type) || NON_STEP_TYPES.has(type)) return null;
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
        command:
          typeof step.command === 'string' && step.command.trim() ? step.command.trim() : undefined,
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
  /** Structured per-step artifacts (summary + changed/key files) for seeding reruns. */
  artifacts: Map<string, OrchestratorStepArtifact>;
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
  const artifacts = new Map<string, OrchestratorStepArtifact>();
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
        const artifact = artifactFromPayload(row.payload);
        if (artifact) artifacts.set(stepId, artifact);
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
    artifacts,
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
      if (!TASK_TYPES.includes(type) || NON_STEP_TYPES.has(type)) return null;
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
        command:
          typeof entry.command === 'string' && entry.command.trim() ? entry.command.trim() : undefined,
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
  repoMap?: string | null,
): string {
  const nextIdExample = stepOffset > 0 ? `step-${stepOffset + 1}, step-${stepOffset + 2}` : 'step-1, step-2';
  const startId = `step-${stepOffset + 1}`;
  const parts = [
    'You are a task planner. Split the user request into typed subtasks.',
    `Allowed types: ${TASK_TYPES.filter((t) => !NON_STEP_TYPES.has(t)).join(', ')}.`,
    'Rules: analysis/comparison of existing code is research, not code. Any plan that modifies code must end with a review step. Cheap work (code, test, docs, quick) goes on small models; review goes LAST. Deterministic verification (tests, builds) belongs on a gate step — {"type":"gate","title":"...","command":"npm test"} runs the command itself instead of delegating to an agent.',
    'Use a single step ONLY for a trivial single-purpose request; requests mixing analysis and implementation need separate steps.',
    '- "title": an imperative phrase naming the concrete deliverable, sentence case, at most 6 words, no step numbers, no trailing punctuation, no provider/model names.',
    `Output ONLY a JSON array: [{"type":"...","title":"Add OAuth callback handler","prompt":"full instruction for the sub-agent","dependsOn":["${stepOffset > 0 ? `step-${stepOffset}` : 'step-1'}"]}]. Step ids are ${nextIdExample}, ... in order starting at ${startId}. The "plan"/"report" types are internal lanes — never emit them.`,
  ];

  if (languageName) {
    parts.push(`Write every step's "title" and "prompt" in ${languageName}.`);
  }

  if (repoMap) {
    parts.push(
      '',
      'REPOSITORY MAP (real paths — reference these in step prompts):',
      repoMap,
    );
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
  /** Fires after a successful tasks.json status write so the tasks panel can refetch. */
  onTasksChanged?(projectPath: string): void;
  /** Injectable for tests — the wait before a same-lane retry backoff. */
  sleep?(ms: number): Promise<void>;
  /** Injectable for tests — jitter source for the retry backoff (default Math.random). */
  random?(): number;
  /** Injectable for tests — runs a gate step's shell command in the step cwd. */
  runGate?(command: string, cwd: string, timeoutMs: number): Promise<GateRunResult>;
  /** Injectable for tests — lists changed/untracked files in the step cwd for artifacts. */
  probeChangedFiles?(cwd: string): Promise<Set<string>>;
  /** Injectable for tests — appends a step-result section to the run's scratchpad file. */
  appendScratchpad?(cwd: string, section: string): Promise<void>;
  /** Injectable for tests — builds the repo-map section handed to the planner. */
  repoMap?(cwd: string): Promise<string | null>;
}): OrchestratorExecutor {
  const sleep = deps.sleep ?? ((ms: number) => new Promise<void>((resolve) => setTimeout(resolve, ms)));
  const random = deps.random ?? Math.random;
  const runGate = deps.runGate ?? runGateCommand;
  const probeChangedFiles = deps.probeChangedFiles ?? gitStatusFiles;
  const appendScratchpad = deps.appendScratchpad ?? appendScratchpadSection;
  const repoMapFn = deps.repoMap ?? buildRepoMap;
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

    // Ground the plan in the real tree: the planner sees top-level entries,
    // manifests, and the codegraph file map so step prompts name real paths.
    const planCwd =
      typeof input.options.cwd === 'string' && input.options.cwd
        ? input.options.cwd
        : deps.resolveSessionCwd?.(input.sessionId) ?? '';
    const repoMapText = planCwd ? await repoMapFn(planCwd).catch(() => null) : null;

    const callPlanner = async (command: string) => {
      const handle = await deps.delegation.run({
        parentSessionId: input.sessionId,
        delegationRowId: null,
        provider: plannerCandidate.provider,
        model: plannerCandidate.model,
        effort: plannerCandidate.effort,
        accountId: plannerCandidate.accountId,
        cwd: planCwd,
        command,
        permissionMode: 'bypassPermissions',
        // Internal lane call with no delegation card: its child must not appear
        // as a standalone session in the sidebar.
        hidden: true,
      });
      const untrack = trackAbort(input.sessionId, handle.abort);
      const result = await handle.completed;
      untrack();
      return result;
    };

    try {
      const first = await callPlanner(
        buildPlannerPrompt(
          input.content,
          priorContext?.summaryText,
          stepOffset,
          resolveLanguageName(input.options),
          repoMapText,
        ),
      );
      let parsed = first.finalText ? parsePlanJson(first.finalText) : null;
      let steps = parsed ? toPlanSteps(parsed, input.content, stepOffset) : [];
      if (steps.length === 0) {
        // One repair shot: feed the bad reply back and demand the bare JSON
        // array before giving up on the planner entirely.
        const repair = await callPlanner(
          `Your previous reply was not a valid JSON array of steps. Output ONLY the corrected JSON array.\n\nPrevious reply:\n${(first.finalText ?? '').slice(-1500)}`,
        );
        parsed = repair.finalText ? parsePlanJson(repair.finalText) : null;
        steps = parsed ? toPlanSteps(parsed, input.content, stepOffset) : [];
      }
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
  type PendingPlan = {
    input: OrchestrateInput;
    planRowId: number;
    steps: OrchestratorPlanStep[];
    /** Supervised runs park on the goals card, not on a step list. */
    supervised?: boolean;
  };
  const pendingPlans = new Map<string, PendingPlan>();

  /**
   * Runs the step list through the DAG scheduler: independent steps run in
   * parallel up to `execution.maxParallel`; a failed dep marks dependents
   * skipped; review ISSUES verdicts push bounded fix steps into the queue.
   */
  /**
   * Richer internal result of executeSteps — the supervised loop needs the
   * per-batch failed-id list and abort/timeout flags, while external callers
   * still see an OrchestrateResult-compatible shape.
   */
  type StepBatchResult =
    | { ok: true; failed: string[]; aborted: boolean; timedOut: boolean }
    | {
        ok: false;
        code: string;
        error: string;
        failed: string[];
        aborted: boolean;
        timedOut: boolean;
      };

  async function executeSteps(
    input: OrchestrateInput,
    config: OrchestratorConfig,
    steps: OrchestratorPlanStep[],
    planRowId: number,
    /** Resume mode: ids of already-finished plan steps, their output
     *  artifacts, and their existing delegation rows for in-place patches. */
    seed?: {
      settledIds?: string[];
      artifacts?: Map<string, OrchestratorStepArtifact>;
      delegationRowByStep?: Map<string, number>;
      /**
       * Pre-resolved working directory — the supervised loop creates the
       * shared worktree once, then passes it here so every iteration's batch
       * runs in the same place.
       */
      overrideCwd?: string;
      /** Absolute ms deadline — the supervised loop keeps one across batches. */
      runDeadline?: number;
      /** Run-scoped lane breakers shared across supervised batches. */
      cooldown?: Set<string>;
      failStreak?: Map<string, number>;
    },
    opts?: {
      /** Supervised batches emit no summary — the loop writes one final row. */
      suppressSummary?: boolean;
    },
  ): Promise<StepBatchResult> {
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
    let cwd = seed?.overrideCwd ?? baseCwd;
    if (!seed?.overrideCwd && config.execution.useWorktree && deps.worktrees && baseCwd) {
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
        return {
          ok: false,
          code: 'WORKTREE_FAILED',
          error: message,
          failed: steps.map((s) => s.id),
          aborted: false,
          timedOut: false,
        };
      }
    }

    const artifacts = seed?.artifacts ?? new Map<string, OrchestratorStepArtifact>();
    const settled = new Set<string>([
      ...steps.filter((s) => !s.enabled).map((s) => s.id),
      ...(seed?.settledIds ?? []),
    ]);
    const failed = new Set<string>();
    /** Set by a user-cancelled child run or the parent session's abort. */
    let runAborted = false;
    /** Global run deadline — a bounded plan cannot burn lanes forever. */
    const runDeadline =
      seed?.runDeadline ??
      (config.execution.runTimeoutMs > 0 ? Date.now() + config.execution.runTimeoutMs : 0);
    let runTimedOut = false;
    /**
     * Run-scoped circuit breaker: candidates cooled by quota/auth failures,
     * an exhausted rate-limit budget, or a 2-streak of transient/timeout
     * errors are skipped by every remaining step of this run. The supervised
     * loop passes its own set in so a cooled lane stays cooled across batches.
     */
    const cooldown = seed?.cooldown ?? new Set<string>();
    /** Consecutive transient/timeout failures per candidate — 2 cools it. */
    const failStreak = seed?.failStreak ?? new Map<string, number>();
    /**
     * Scratchpad sections serialize through this chain so parallel steps
     * never interleave writes. Only active when this run created a worktree.
     */
    const scratchpadCwd = cwd !== baseCwd ? cwd : null;
    let scratchpadTail: Promise<void> = Promise.resolve();
    const enqueueScratchpad = (step: OrchestratorPlanStep, artifact: OrchestratorStepArtifact) => {
      if (!scratchpadCwd) return;
      const dir = scratchpadCwd;
      const section = `## ${step.id} — ${step.title}\n${artifact.summary}\nFiles: ${artifact.keyPaths.join(', ')}\n\n`;
      scratchpadTail = scratchpadTail.then(() =>
        appendScratchpad(dir, section).catch((error) =>
          console.warn('[Orchestrator] scratchpad append failed:', error),
        ),
      );
    };

    /** Pushes fix/gate steps appended mid-run onto the plan row (UI card). */
    const syncPlanRow = () => {
      if (planRowId <= 0) return;
      const currentPlan = orchestratorMessagesDb.list(sessionId).find((r) => r.id === planRowId);
      const existingSteps = Array.isArray(currentPlan?.payload?.steps)
        ? (currentPlan.payload.steps as OrchestratorPlanStep[])
        : steps;
      const existingIds = new Set(existingSteps.map((s) => s.id));
      const newSteps = steps.filter((s) => !existingIds.has(s.id));
      patch(planRowId, { steps: [...existingSteps, ...newSteps].map(serializeStep) });
    };

    /**
     * A gate step runs its `command` deterministically in the plan cwd —
     * no delegation, no candidate. A non-zero exit mirrors the review/test
     * fix loop: a bounded fix + re-gate pair is appended and downstream
     * deps are repointed at it.
     */
    const runGateStep = async (step: OrchestratorPlanStep): Promise<void> => {
      const row = append(sessionId, 'gate', {
        stepId: step.id,
        title: step.title,
        command: step.command ?? null,
        cwd,
        status: 'running',
      });
      const command = step.command;
      if (!command) {
        patch(row.id, { status: 'failed', error: 'gate step requires a command' });
        failed.add(step.id);
        return;
      }
      const baseline = cwd ? await probeChangedFiles(cwd) : new Set<string>();
      const startedAt = Date.now();
      const result = await runGate(command, cwd, config.execution.stepTimeoutMs);
      const durationMs = Date.now() - startedAt;
      const ok = result.code === 0 && !result.timedOut;
      patch(row.id, {
        status: ok ? 'done' : 'failed',
        exitCode: result.code,
        output: result.output.slice(-4000),
        durationMs,
        timedOut: result.timedOut,
      });
      // A parent abort landing mid-command still drains the run — the gate
      // process may have finished, but the queue must not continue.
      if (abortedParents.has(sessionId)) {
        runAborted = true;
        failed.add(step.id);
        return;
      }
      if (ok) {
        const after = cwd ? await probeChangedFiles(cwd) : new Set<string>();
        const changedFiles = [...after].filter((f) => !baseline.has(f)).slice(0, 50);
        const artifact: OrchestratorStepArtifact = {
          summary: `gate passed: \`${command}\``,
          changedFiles,
          keyPaths: changedFiles.slice(0, 10),
        };
        artifacts.set(step.id, artifact);
        enqueueScratchpad(step, artifact);
        return;
      }
      enqueueScratchpad(step, {
        summary: `gate failed: \`${command}\` (exit code ${result.code}${result.timedOut ? ', timed out' : ''})`,
        changedFiles: [],
        keyPaths: [],
      });
      const fixCount = steps.filter((s) => s.id.startsWith('fix-')).length;
      if (fixCount < config.execution.maxFixLoops) {
        const fixStepId = `fix-${fixCount + 1}`;
        const gateStepId = `gate-fix-${fixCount + 1}`;
        // Downstream steps wait on the re-gate, not on the failed original.
        for (const s of steps) {
          if (s.id !== fixStepId && s.id !== gateStepId && s.dependsOn.includes(step.id)) {
            s.dependsOn = s.dependsOn.map((dep) => (dep === step.id ? gateStepId : dep));
          }
        }
        steps.push(
          {
            id: fixStepId,
            type: 'code',
            title: `fix ${fixCount + 1}: make gate ${step.id} pass`,
            prompt: `The gate command \`${command}\` failed with exit code ${result.code}. Output:\n${result.output.slice(-4000)}\n\nFix the underlying cause so the gate passes.`,
            dependsOn: [step.id],
            enabled: true,
          },
          {
            id: gateStepId,
            type: 'gate',
            title: `gate fix ${fixCount + 1}: re-run ${step.title}`,
            prompt: `Re-run the gate command for ${step.title}.`,
            command,
            dependsOn: [step.id, fixStepId],
            enabled: true,
          },
        );
        syncPlanRow();
      } else {
        failed.add(step.id);
      }
    };

    const runStep = async (step: OrchestratorPlanStep): Promise<void> => {
      if (step.type === 'gate') {
        await runGateStep(step);
        settled.add(step.id);
        return;
      }
      const routed = deps.router.route(step.type, cooldown);
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
        patch(resumeRowId, {
          status: 'queued',
          attempt: 1,
          error: null,
          candidateId: routed.candidate.id,
          accountId: routed.candidate.accountId,
        });
      } else {
        delegationRow = append(sessionId, 'delegation', {
          stepId: step.id,
          taskType: step.type,
          title: step.title,
          candidateId: routed.candidate.id,
          provider: routed.candidate.provider,
          model: routed.candidate.model,
          effort: routed.decision.effort,
          accountId: routed.candidate.accountId,
          tier: routed.candidate.tier,
          status: 'queued',
        });
      }

      // Handoff: the child sees artifacts of completed dependencies — the
      // only cross-provider context channel (provider-native transcripts
      // cannot share history; kanban's prepended-contract precedent).
      const depSummary = step.dependsOn
        .map((dep) => {
          const artifact = artifacts.get(dep);
          if (!artifact) return null;
          const files =
            artifact.keyPaths.length > 0 ? `\nChanged files: ${artifact.keyPaths.join(', ')}` : '';
          return `Result of earlier step "${dep}":\n${artifact.summary}${files}`;
        })
        .filter((text): text is string => text !== null)
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

      // Route order = failover order: a failed attempt advances to the
      // next viable alternative so one dead lane never kills the step.
      // Same-lane retries are bounded per failure class (execution.retry);
      // cooled lanes are skipped in place — a sibling step may have
      // tripped the breaker after this step resolved its candidate list.
      const candidates = [
        routed.candidate,
        ...routed.decision.alternatives
          .map((id) => config.pool.find((c) => c.id === id))
          .filter((c): c is OrchestratorCandidate => Boolean(c)),
      ].filter((c) => !cooldown.has(c.id));

      // Redundant operation: a candidate may pin several provider accounts
      // (primary first, then ordered fallbacks). `accountIndex` walks that
      // list before the candidate itself is abandoned; it resets to 0
      // whenever `candidateIndex` advances to another lane.
      const accountsFor = (c: OrchestratorCandidate): Array<string | null> => [
        c.accountId,
        ...c.fallbackAccountIds,
      ];

      // Changed-file baseline probed once before the first attempt; the
      // step artifact's diff is measured against it on success.
      const baseline = cwd ? await probeChangedFiles(cwd) : new Set<string>();
      /** Same-lane retries consumed per failure class on this step. */
      const classRetries: Partial<Record<OrchestratorFailureClass, number>> = {};

      let attempt = 0;
      let candidateIndex = 0;
      let accountIndex = 0;
      for (;;) {
        while (candidateIndex < candidates.length && cooldown.has(candidates[candidateIndex].id)) {
          candidateIndex += 1;
          accountIndex = 0;
        }
        if (runDeadline > 0 && Date.now() > runDeadline) {
          runTimedOut = true;
          patch(delegationRow.id, { status: 'failed', error: 'run timed out' });
          failed.add(step.id);
          break;
        }
        const candidate = candidates[candidateIndex];
        if (!candidate || attempt >= config.execution.maxAttempts) {
          // Every routed alternative failed (or the attempt ceiling hit) —
          // the run ends here for this step; the summary's Continue button
          // reruns it via POST /sessions/:id/resume.
          patch(delegationRow.id, { status: 'failed' });
          failed.add(step.id);
          break;
        }
        attempt += 1;
        const accountId = accountsFor(candidate)[accountIndex] ?? null;
        if (attempt > 1) {
          patch(delegationRow.id, {
            status: 'queued',
            attempt,
            error: null,
            candidateId: candidate.id,
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
          accountId,
          cwd,
          command: command + langConstraint + reviewHint,
          // Delegated steps always bypass: nobody watches the child session to
          // approve prompts, so a strict mode stalls the pipeline waiting for
          // input that never comes.
          permissionMode: 'bypassPermissions',
        });
        const untrack = trackAbort(sessionId, handle.abort);
        // The step timeout races the child on a REAL timer — the injected
        // sleep is stubbed in tests and must not gate this. Expiry aborts
        // the child and counts as a 'timeout'-class failure so the normal
        // budget/failover path handles it. The timer stays referenced: an
        // unref'd timer is dropped once the event loop drains, which cancels
        // the race before the timeout can fire.
        let stepTimer: ReturnType<typeof setTimeout> | undefined;
        let result: { ok: boolean; error: string | null; finalText: string; aborted: boolean };
        try {
          const timeout = config.execution.stepTimeoutMs;
          const raced =
            timeout > 0
              ? await Promise.race([
                  handle.completed,
                  new Promise<'timed-out'>((resolve) => {
                    stepTimer = setTimeout(() => resolve('timed-out'), timeout);
                  }),
                ])
              : await handle.completed;
          if (raced === 'timed-out') {
            await handle.abort().catch(() => undefined);
            result = {
              ok: false,
              error: `step timed out after ${timeout}ms`,
              finalText: '',
              aborted: false,
            };
          } else {
            result = raced;
          }
        } finally {
          if (stepTimer) clearTimeout(stepTimer);
        }
        untrack();

        if (result.ok) {
          failStreak.delete(candidate.id);
          const after = cwd ? await probeChangedFiles(cwd) : new Set<string>();
          const changedFiles = [...after].filter((f) => !baseline.has(f)).slice(0, 50);
          const artifact: OrchestratorStepArtifact = {
            summary: (result.finalText || `${step.title} completed.`).slice(-1500),
            changedFiles,
            keyPaths: changedFiles.slice(0, 10),
          };
          artifacts.set(step.id, artifact);
          patch(delegationRow.id, { artifact });
          enqueueScratchpad(step, artifact);
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
              syncPlanRow();
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

        const cls = classifyStepError(result.error);
        patch(delegationRow.id, { errorClass: cls });
        // A user-aborted child (or an already-aborted run) never retries.
        if (result.aborted) runAborted = true;
        if (runAborted) {
          failed.add(step.id);
          break;
        }

        // Same-lane retry: bounded per failure class, exponential backoff
        // with full jitter so parallel steps don't re-hit the lane in
        // lockstep.
        if (
          (classRetries[cls] ?? 0) < config.execution.retry[cls]
          && attempt < config.execution.maxAttempts
        ) {
          classRetries[cls] = (classRetries[cls] ?? 0) + 1;
          patch(delegationRow.id, {
            status: 'queued',
            rateLimited: cls === 'rate_limit',
            errorClass: cls,
          });
          const backoff =
            config.execution.retryBackoffBaseMs * 2 ** ((classRetries[cls] ?? 1) - 1)
            + random() * config.execution.retryBackoffBaseMs;
          await sleep(backoff);
          if (abortedParents.has(sessionId)) {
            runAborted = true;
            failed.add(step.id);
            break;
          }
          continue; // candidateIndex unchanged → the retry stays on this lane.
        }

        // Redundant operation: a spent quota, lost auth, or exhausted
        // rate-limit budget is account-specific, so the candidate's next
        // account gets the attempt on the same lane before the candidate
        // itself is cooled and abandoned.
        if (
          (cls === 'quota' || cls === 'auth' || cls === 'rate_limit')
          && accountIndex + 1 < accountsFor(candidate).length
        ) {
          accountIndex += 1;
          patch(delegationRow.id, {
            status: 'queued',
            rateLimited: cls === 'rate_limit',
            errorClass: cls,
            attempt,
          });
          continue;
        }

        // Budget spent — the breaker decides whether this lane may serve
        // later steps: quota/auth are sticky, an exhausted rate-limit
        // budget cools the lane too, and transient/timeout failures only
        // cool after a 2-streak.
        if (cls === 'quota' || cls === 'auth' || cls === 'rate_limit') {
          cooldown.add(candidate.id);
        } else {
          const streak = (failStreak.get(candidate.id) ?? 0) + 1;
          failStreak.set(candidate.id, streak);
          if (streak >= 2) cooldown.add(candidate.id);
        }
        // Advance — the loop top skips cooled lanes and fails the step
        // when no candidate or attempt budget is left.
        candidateIndex += 1;
        accountIndex = 0;
        continue;
      }
      settled.add(step.id);
    };

    // Wave scheduler: scan the (growable) step list each pass — fix steps
    // pushed mid-run join naturally. `settled` covers done/failed/skipped and
    // user-disabled steps (a disabled dep does not block its dependents).
    for (;;) {
      const waiting = steps.filter((s) => !settled.has(s.id));
      if (waiting.length === 0) break;

      // An abort or the run deadline drains the queue: every never-started
      // step gets a transcript row explaining why it never ran.
      if (runAborted || runTimedOut || (runDeadline > 0 && Date.now() > runDeadline)) {
        if (!runAborted) runTimedOut = true;
        for (const step of waiting) {
          append(sessionId, 'delegation', {
            stepId: step.id,
            title: step.title,
            status: runAborted ? 'aborted' : 'failed',
            error: runAborted ? 'aborted by user decision' : 'run timed out',
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
    // that produced an artifact are included; failed/skipped steps are
    // omitted (the failed list already surfaces them).
    const stepResults = steps
      .filter((s) => s.enabled && !failed.has(s.id) && artifacts.has(s.id))
      .map((s) => ({ title: s.title, summary: (artifacts.get(s.id) as OrchestratorStepArtifact).summary }));

    if (!opts?.suppressSummary) {
      append(sessionId, 'summary', {
        text:
          `${okCount}/${total} steps completed` +
          (failedList.length ? `, failed: ${failedList.join(', ')}` : '') +
          (runAborted ? ' (aborted)' : '') +
          (runTimedOut ? ' (timed out)' : ''),
        completed: okCount,
        total,
        failed: failedList,
        aborted: runAborted,
        timedOut: runTimedOut,
        results: stepResults,
      });
    }

    return failed.size === total && total > 0
      ? {
          ok: false,
          code: 'ALL_STEPS_FAILED',
          error: `All ${total} steps failed`,
          failed: failedList,
          aborted: runAborted,
          timedOut: runTimedOut,
        }
      : { ok: true, failed: failedList, aborted: runAborted, timedOut: runTimedOut };
  }

  // --- supervised loop (planner.mode 'auto') --------------------------------

  /**
   * Mutable state carried across the supervised loop's iterations — the same
   * shape the transcript rebuild produces for confirm/resume after a restart.
   */
  type SupervisedState = {
    goals: OrchestratorGoals;
    planRowId: number;
    /** Growable step list of the current plan run (includes fix steps). */
    steps: OrchestratorPlanStep[];
    artifacts: Map<string, OrchestratorStepArtifact>;
    failedIds: Set<string>;
    iteration: number;
    /** Shared worktree path once created (or plan-row restored). */
    overrideCwd?: string;
    runDeadline: number;
    /** Run-scoped lane breakers shared with every step batch. */
    cooldown: Set<string>;
    failStreak: Map<string, number>;
    /** Done-count watermark the `every-n` checkpoint measures against. */
    doneCountAtCheckpoint: number;
    /** step-1..stepOffset belong to earlier runs/tasks — reserved numbering. */
    stepOffset: number;
    /** One-shot user directive injected into the next decision prompt. */
    directive?: string | null;
    /** One-shot executor note (done-gate rejection, invalid decision). */
    feedback?: string | null;
  };

  /** A checkpoint-paused decision parked until the user confirms its batch. */
  type PendingDecision = {
    input: OrchestrateInput;
    state: SupervisedState;
    decisionRowId: number;
    proposed: OrchestratorPlanStep[];
  };
  const pendingDecisions = new Map<string, PendingDecision>();

  /** Highest `step-N` number in a step list — supervised ids continue it. */
  const maxStepNumber = (list: ReadonlyArray<{ id?: unknown }>): number =>
    list.reduce((max, s) => {
      const m = typeof s.id === 'string' ? /^step-(\d+)$/.exec(s.id) : null;
      return m ? Math.max(max, Number(m[1])) : max;
    }, 0);

  /** Rewrites the plan row's step list so the card tracks the live queue. */
  const patchPlanSteps = (sessionId: string, planRowId: number, steps: OrchestratorPlanStep[]) => {
    if (planRowId <= 0) return;
    patch(planRowId, { steps: steps.map(serializeStep) });
  };

  type LaneCallResult = {
    ok: boolean;
    finalText: string;
    aborted: boolean;
    candidateId: string | null;
    error: string | null;
  };

  /**
   * One routed internal call: supervisor goals/decisions on the `plan` lane,
   * the final report on `report`. Walks the routed alternatives like a step
   * does, cooling each failed lane for the rest of the run, and races the
   * shared step timeout so a hung supervisor cannot stall the loop forever.
   * Internal calls write no delegation row — the decision/summary rows carry
   * the candidate id instead.
   */
  async function callLane(
    sessionId: string,
    taskType: 'plan' | 'report',
    command: string,
    cwd: string,
    cooldown: Set<string>,
    config: OrchestratorConfig,
  ): Promise<LaneCallResult> {
    const routed = deps.router.route(taskType, cooldown);
    if (!routed.ok) {
      return { ok: false, finalText: '', aborted: false, candidateId: null, error: routed.reason };
    }
    const candidates = [
      routed.candidate,
      ...routed.decision.alternatives
        .map((id) => config.pool.find((c) => c.id === id))
        .filter((c): c is OrchestratorCandidate => Boolean(c)),
    ];
    let lastError: string | null = null;
    for (const candidate of candidates) {
      if (cooldown.has(candidate.id) || abortedParents.has(sessionId)) break;
      const handle = await deps.delegation.run({
        parentSessionId: sessionId,
        delegationRowId: null,
        provider: candidate.provider,
        model: candidate.model,
        effort: candidate.effort,
        accountId: candidate.accountId,
        cwd,
        command,
        permissionMode: 'bypassPermissions',
        // Supervisor goals/decisions and the final report are internal lane
        // calls with no delegation card — hide their child from session lists.
        hidden: true,
      });
      const untrack = trackAbort(sessionId, handle.abort);
      const timeout = config.execution.stepTimeoutMs;
      let result: Awaited<typeof handle.completed> | 'timed-out';
      let timer: ReturnType<typeof setTimeout> | undefined;
      try {
        result =
          timeout > 0
            ? await Promise.race([
                handle.completed,
                new Promise<'timed-out'>((resolve) => {
                  // Referenced on purpose — see the step-timer note above.
                  timer = setTimeout(() => resolve('timed-out'), timeout);
                }),
              ])
            : await handle.completed;
      } finally {
        if (timer) clearTimeout(timer);
      }
      untrack();
      if (result === 'timed-out') {
        await handle.abort().catch(() => undefined);
        lastError = `internal call timed out after ${timeout}ms`;
        cooldown.add(candidate.id);
        continue;
      }
      if (result.ok) {
        return {
          ok: true,
          finalText: result.finalText,
          aborted: false,
          candidateId: candidate.id,
          error: null,
        };
      }
      if (result.aborted || abortedParents.has(sessionId)) {
        return { ok: false, finalText: '', aborted: true, candidateId: candidate.id, error: result.error };
      }
      lastError = result.error;
      cooldown.add(candidate.id);
    }
    return {
      ok: false,
      finalText: '',
      aborted: false,
      candidateId: null,
      error: lastError ?? 'no viable candidate',
    };
  }

  /** Shared seed wiring for one supervised batch through executeSteps. */
  const batchSeed = (st: SupervisedState) => ({
    settledIds: [
      ...st.steps.map((s) => s.id),
      ...Array.from({ length: st.stepOffset }, (_, i) => `step-${i + 1}`),
    ],
    artifacts: st.artifacts,
    cooldown: st.cooldown,
    failStreak: st.failStreak,
    overrideCwd: st.overrideCwd,
    runDeadline: st.runDeadline,
  });

  /**
   * The supervised decision loop: supervisor (plan lane) → optional
   * checkpoint → batch through the DAG scheduler → repeat until done, a
   * cap, a timeout or an abort. Emits the final report + summary row.
   * Returns {ok:true} early when a checkpoint parks the run for confirm.
   */
  async function supervisedLoop(
    input: OrchestrateInput,
    config: OrchestratorConfig,
    st: SupervisedState,
  ): Promise<OrchestrateResult> {
    const sessionId = input.sessionId;
    const languageName = resolveLanguageName(input.options);
    const baseCwd =
      typeof input.options.cwd === 'string' && input.options.cwd
        ? input.options.cwd
        : deps.resolveSessionCwd?.(sessionId) ?? '';
    const maxIter = config.execution.maxSupervisorIterations;
    const nextOffset = () => st.stepOffset + maxStepNumber(st.steps);

    // One shared worktree for the whole supervised run — created lazily
    // before the first batch, recorded on the plan row for cleanup/rebuild.
    if (!st.overrideCwd && config.execution.useWorktree && deps.worktrees && baseCwd) {
      try {
        const worktree = await deps.worktrees.create({
          projectPath: baseCwd,
          branch: `orchestrator/${sessionId.slice(0, 8)}-${Date.now().toString(36)}`,
        });
        st.overrideCwd = worktree.worktreePath;
        orchestratorMessagesDb.updatePayload(st.planRowId, {
          worktreePath: worktree.worktreePath,
          branch: worktree.branch,
        });
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        append(sessionId, 'summary', { text: `Worktree creation failed: ${message}`, failed: [] });
        return { ok: false, code: 'WORKTREE_FAILED', error: message };
      }
    }

    let aborted = false;
    let timedOut = false;
    let capped = false;
    let supervisorDead: string | null = null;
    let outcome: 'success' | 'partial' | 'failed' = 'success';
    /** Consecutive decisions that produced no executable steps — 2 ends it. */
    let unproductive = 0;

    for (;;) {
      if (abortedParents.has(sessionId)) {
        aborted = true;
        break;
      }
      if (st.runDeadline > 0 && Date.now() > st.runDeadline) {
        timedOut = true;
        break;
      }
      if (st.iteration >= maxIter) {
        capped = true;
        break;
      }
      st.iteration += 1;

      const ledger = buildSupervisorLedger({
        steps: st.steps,
        artifacts: st.artifacts,
        failed: st.failedIds,
      });
      const callCwd = st.overrideCwd ?? baseCwd;
      const res = await callLane(
        sessionId,
        'plan',
        buildSupervisorPrompt({
          content: input.content,
          goals: st.goals,
          ledger,
          iteration: st.iteration,
          maxIterations: maxIter,
          maxParallel: config.execution.maxParallel,
          languageName,
          directive: st.directive,
          feedback: st.feedback,
        }),
        callCwd,
        st.cooldown,
        config,
      );
      st.directive = null;
      st.feedback = null;
      if (res.aborted) {
        aborted = true;
        break;
      }
      if (!res.ok) {
        supervisorDead = res.error;
        break;
      }

      let decision: OrchestratorSupervisorDecision | null = res.finalText
        ? parseDecisionJson(res.finalText)
        : null;
      if (!decision) {
        // Same single repair shot the static planner gets.
        const repair = await callLane(
          sessionId,
          'plan',
          `Your previous reply was not a valid JSON decision. Output ONLY the corrected JSON object.\n\nPrevious reply:\n${res.finalText.slice(-1500)}`,
          callCwd,
          st.cooldown,
          config,
        );
        if (repair.aborted) {
          aborted = true;
          break;
        }
        decision = repair.ok && repair.finalText ? parseDecisionJson(repair.finalText) : null;
      }

      const proposed =
        decision?.action === 'continue'
          ? normalizeProposedSteps(
              decision.steps,
              input.content || 'Continue the work.',
              nextOffset(),
              new Set(st.steps.map((s) => s.id)),
              config.execution.maxParallel,
            )
          : [];
      const decisionRow = append(sessionId, 'decision', {
        iteration: st.iteration,
        action: decision?.action ?? 'invalid',
        reason: decision?.reason || 'unparseable supervisor reply',
        outcome: decision?.outcome,
        candidateId: res.candidateId,
        steps: proposed.map(serializeStep),
        awaitingConfirm: false,
      });

      if (!decision || (decision.action === 'continue' && proposed.length === 0)) {
        unproductive += 1;
        if (unproductive >= 2) {
          outcome = 'partial';
          break;
        }
        st.feedback =
          'Your previous decision was invalid or proposed no valid steps. Answer with the JSON contract only.';
        continue;
      }
      unproductive = 0;

      if (decision.action === 'done') {
        const override = doneGateOverride(st.steps, st.artifacts, st.goals.requiresTests);
        if (!override) {
          outcome = decision.outcome ?? (st.failedIds.size > 0 ? 'partial' : 'success');
          break;
        }
        // Deterministic done-gate: code changes are never finished without a
        // later review (and a test/gate pass when the contract requires one).
        const gateStep: OrchestratorPlanStep = {
          id: `step-${nextOffset() + 1}`,
          type: override,
          title: `gate: ${override} before finish`,
          prompt:
            override === 'test'
              ? 'Run the project tests/build to verify the changes made by earlier steps. Report concrete failures; end your reply with a line exactly: VERDICT: PASS or VERDICT: ISSUES'
              : 'Review the changes produced by the earlier steps before finishing: correctness, regressions, missing edge cases. Report concrete issues; end your reply with a line exactly: VERDICT: PASS or VERDICT: ISSUES',
          dependsOn: st.steps
            .filter((s) => (s.type === 'code' || s.type === 'code-hard') && st.artifacts.has(s.id))
            .map((s) => s.id)
            .slice(-5),
          enabled: true,
        };
        patch(decisionRow.id, { gateOverride: override, forcedStepId: gateStep.id });
        const gateBatch = [gateStep];
        const batchRes = await executeSteps(input, config, gateBatch, st.planRowId, batchSeed(st), {
          suppressSummary: true,
        });
        // gateBatch grew by any appended fix steps mid-run — absorb all of it.
        st.steps.push(...gateBatch);
        patchPlanSteps(sessionId, st.planRowId, st.steps);
        for (const id of batchRes.failed) st.failedIds.add(id);
        if (batchRes.aborted) {
          aborted = true;
          break;
        }
        if (batchRes.timedOut) {
          timedOut = true;
          break;
        }
        st.feedback = `Your done was rejected by the ${override} gate — ${gateStep.id} ran first. Re-evaluate against the goal contract.`;
        continue;
      }

      // continue → checkpoint gate before the batch executes.
      const doneCount = st.steps.filter((s) => st.artifacts.has(s.id)).length;
      const cp = config.planner.checkpoint;
      const checkpointDue =
        cp.mode === 'per-step' ||
        (cp.mode === 'every-n' &&
          cp.interval > 0 &&
          doneCount - st.doneCountAtCheckpoint >= cp.interval);
      if (checkpointDue) {
        patch(decisionRow.id, { awaitingConfirm: true });
        pendingDecisions.set(sessionId, {
          input,
          state: st,
          decisionRowId: decisionRow.id,
          proposed,
        });
        return { ok: true };
      }

      const batchRes = await executeSteps(input, config, proposed, st.planRowId, batchSeed(st), {
        suppressSummary: true,
      });
      // `proposed` grew by any appended fix steps mid-batch — absorb all of it
      // so the ledger, numbering and plan row stay coherent.
      st.steps.push(...proposed);
      patchPlanSteps(sessionId, st.planRowId, st.steps);
      for (const id of batchRes.failed) st.failedIds.add(id);
      if (batchRes.aborted) {
        aborted = true;
        break;
      }
      if (batchRes.timedOut) {
        timedOut = true;
        break;
      }
    }

    const runStatus: 'ok' | 'partial' | 'failed' | 'aborted' | 'timed-out' = aborted
      ? 'aborted'
      : timedOut
        ? 'timed-out'
        : outcome === 'failed'
          ? 'failed'
          : capped || supervisorDead || st.failedIds.size > 0 || outcome === 'partial'
            ? 'partial'
            : 'ok';

    // Final report on the cheap lane; when it is dead the supervisor lane
    // writes the report instead — either way the summary row carries it.
    const reportInput = {
      content: input.content,
      goals: st.goals,
      ledger: buildSupervisorLedger({ steps: st.steps, artifacts: st.artifacts, failed: st.failedIds }),
      status: runStatus,
      languageName,
    };
    let report: string | null = null;
    const reportCall = await callLane(
      sessionId,
      'report',
      buildReportPrompt(reportInput),
      st.overrideCwd ?? baseCwd,
      st.cooldown,
      config,
    );
    if (reportCall.ok && reportCall.finalText.trim()) {
      report = reportCall.finalText.trim().slice(-4000);
    } else {
      const fallback = await callLane(
        sessionId,
        'plan',
        buildReportPrompt(reportInput),
        st.overrideCwd ?? baseCwd,
        st.cooldown,
        config,
      );
      if (fallback.ok && fallback.finalText.trim()) {
        report = fallback.finalText.trim().slice(-4000);
      }
    }

    const enabledSteps = st.steps.filter((s) => s.enabled);
    const total = enabledSteps.length;
    const failedList = [...st.failedIds];
    const okCount = total - failedList.length;
    const stepResults = enabledSteps
      .filter((s) => !st.failedIds.has(s.id) && st.artifacts.has(s.id))
      .map((s) => ({ title: s.title, summary: (st.artifacts.get(s.id) as OrchestratorStepArtifact).summary }));

    append(sessionId, 'summary', {
      text:
        `${okCount}/${total} steps completed` +
        (failedList.length ? `, failed: ${failedList.join(', ')}` : '') +
        (aborted ? ' (aborted)' : '') +
        (timedOut ? ' (timed out)' : '') +
        (capped ? ' (iteration cap)' : ''),
      completed: okCount,
      total,
      failed: failedList,
      aborted,
      timedOut,
      capped,
      iterations: st.iteration,
      results: stepResults,
      report,
      outcome: runStatus,
      supervisorError: supervisorDead ?? undefined,
    });

    return failedList.length === total && total > 0
      ? { ok: false, code: 'ALL_STEPS_FAILED', error: `All ${total} steps failed` }
      : { ok: true };
  }

  /**
   * Supervised entry point for `planner.mode === 'auto'`: the plan lane writes
   * the goal contract, the plan row carries it (parked for confirm when
   * `planner.requireConfirm`), then the decision loop runs. Degrades to the
   * old single-step path only when the supervisor lane itself is unreachable.
   */
  async function executeSupervised(
    input: OrchestrateInput,
    config: OrchestratorConfig,
    options: {
      /** Extra fields merged onto the plan row (taskmaster meta etc.). */
      planExtra?: Record<string, unknown>;
      /** completeAllTasks runs unattended — never park for goal confirm. */
      skipConfirm?: boolean;
      /** step-1..stepOffset reserved by earlier runs/tasks. */
      stepOffset?: number;
      /** Prior artifacts so step handoffs can reference earlier work. */
      artifacts?: Map<string, OrchestratorStepArtifact>;
      directive?: string;
    } = {},
  ): Promise<OrchestrateResult> {
    const sessionId = input.sessionId;
    abortedParents.delete(sessionId);
    const languageName = resolveLanguageName(input.options);
    const planCwd =
      typeof input.options.cwd === 'string' && input.options.cwd
        ? input.options.cwd
        : deps.resolveSessionCwd?.(sessionId) ?? '';
    const cooldown = new Set<string>();

    const repoMapText = planCwd ? await repoMapFn(planCwd).catch(() => null) : null;
    let goals: OrchestratorGoals | null = null;
    const first = await callLane(
      sessionId,
      'plan',
      buildGoalsPrompt(input.content, languageName, repoMapText),
      planCwd,
      cooldown,
      config,
    );
    if (first.aborted) return { ok: false, code: 'ABORTED', error: 'Aborted by user.' };
    if (first.ok && first.finalText) goals = parseGoalsJson(first.finalText);
    if (!goals && first.ok) {
      const repair = await callLane(
        sessionId,
        'plan',
        `Your previous reply was not a valid JSON goal contract. Output ONLY the corrected JSON object.\n\nPrevious reply:\n${first.finalText.slice(-1500)}`,
        planCwd,
        cooldown,
        config,
      );
      if (repair.aborted) return { ok: false, code: 'ABORTED', error: 'Aborted by user.' };
      if (repair.ok && repair.finalText) goals = parseGoalsJson(repair.finalText);
    }
    if (!goals && !first.ok) {
      // The supervisor lane itself is unreachable — degrade to the old
      // single-step path so the request still executes end to end.
      console.warn('[Orchestrator] Supervisor lane unavailable, single-step fallback:', first.error);
      const steps = singleStep(input, options.stepOffset ?? 0);
      const planRow = append(sessionId, 'plan', {
        steps: steps.map(serializeStep),
        awaitingConfirm: false,
        source: 'supervisor-unavailable',
        ...options.planExtra,
      });
      return executeSteps(input, config, steps, planRow.id, {
        artifacts: options.artifacts,
        settledIds: Array.from({ length: options.stepOffset ?? 0 }, (_, i) => `step-${i + 1}`),
      });
    }
    if (!goals) {
      // Parse-resistant reply — the echo contract keeps the loop moving;
      // requiresTests is guessed from the request's own wording.
      goals = {
        goals: input.content.trim() || 'Complete the user request.',
        doneWhen: [],
        requiresTests: /\b(test|tests|build|verify)\b/i.test(input.content),
      };
    }

    const planRow = append(sessionId, 'plan', {
      steps: [],
      goals: goals.goals,
      doneWhen: goals.doneWhen,
      requiresTests: goals.requiresTests,
      awaitingConfirm: config.planner.requireConfirm && !options.skipConfirm,
      source: 'supervised',
      ...options.planExtra,
    });
    if (abortedParents.has(sessionId)) {
      return { ok: false, code: 'ABORTED', error: 'Aborted by user.' };
    }
    if (config.planner.requireConfirm && !options.skipConfirm) {
      pendingPlans.set(sessionId, { input, planRowId: planRow.id, steps: [], supervised: true });
      return { ok: true };
    }
    return supervisedLoop(input, config, {
      goals,
      planRowId: planRow.id,
      steps: [],
      artifacts: options.artifacts ?? new Map(),
      failedIds: new Set(),
      iteration: 0,
      cooldown,
      failStreak: new Map(),
      runDeadline:
        config.execution.runTimeoutMs > 0 ? Date.now() + config.execution.runTimeoutMs : 0,
      doneCountAtCheckpoint: 0,
      stepOffset: options.stepOffset ?? 0,
      directive: options.directive ?? null,
    });
  }

  /**
   * Rebuilds a supervised run's loop state from the transcript — used by
   * confirm after a restart and by resume/continueSession on
   * `source:'supervised'` plan rows. Returns null for legacy plans.
   */
  function rebuildSupervisedState(sessionId: string): {
    state: SupervisedState;
    parkedDecision: { rowId: number; steps: unknown } | null;
    planAwaitingConfirm: boolean;
  } | null {
    const rows = orchestratorMessagesDb.list(sessionId);
    const lastPlan = [...rows].reverse().find((row) => row.kind === 'plan') ?? null;
    if (!lastPlan || lastPlan.payload.source !== 'supervised') return null;

    const steps = normalizeEditableSteps(lastPlan.payload.steps, '', 0);
    const artifacts = new Map<string, OrchestratorStepArtifact>();
    const failedIds = new Set<string>();
    const seen = new Set<string>();
    for (const row of [...rows].reverse()) {
      if (row.kind !== 'delegation' && row.kind !== 'gate') continue;
      const stepId = typeof row.payload?.stepId === 'string' ? row.payload.stepId : null;
      if (!stepId || seen.has(stepId)) continue;
      seen.add(stepId);
      const artifact = artifactFromPayload(row.payload);
      if (artifact) artifacts.set(stepId, artifact);
      const status = String(row.payload.status ?? '');
      if (status === 'failed' || status === 'skipped' || status === 'aborted') {
        failedIds.add(stepId);
      }
    }

    const decisions = rows.filter((row) => row.kind === 'decision');
    const parked = [...decisions].reverse().find((row) => row.payload.awaitingConfirm === true);
    return {
      state: {
        goals: {
          goals: typeof lastPlan.payload.goals === 'string' ? lastPlan.payload.goals : '',
          doneWhen: strArr(lastPlan.payload.doneWhen),
          requiresTests: lastPlan.payload.requiresTests === true,
        },
        planRowId: lastPlan.id,
        steps,
        artifacts,
        failedIds,
        iteration: decisions.length,
        overrideCwd:
          typeof lastPlan.payload.worktreePath === 'string' ? lastPlan.payload.worktreePath : undefined,
        runDeadline: 0,
        cooldown: new Set(),
        failStreak: new Map(),
        doneCountAtCheckpoint: artifacts.size,
        stepOffset: 0,
      },
      parkedDecision: parked ? { rowId: parked.id, steps: parked.payload.steps } : null,
      planAwaitingConfirm: lastPlan.payload.awaitingConfirm === true,
    };
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
        ? Math.min(Math.max(1, Math.floor(requestedMax)), MAX_TASKMASTER_TASKS_PER_RUN)
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
        deps.onTasksChanged?.(projectPath);
      } catch (error) {
        console.warn(`[Orchestrator] TaskMaster status update failed for #${taskId}:`, error);
      }
      taskmasterEvent(taskId, 'started', { title, remaining: unfinished.length, total: tasks.length });

      const input = makeInput(buildTaskmasterPrompt(next));
      const priorContext = extractPriorSessionContext(orchestratorMessagesDb.list(sessionId));
      let execResult: StepBatchResult | OrchestrateResult;

      if (config.planner.mode === 'auto') {
        // Supervised per task: goals from the task body, decision loop, report.
        // Runs unattended — the queue must never park on a goals confirm.
        execResult = await executeSupervised(input, loopConfig, {
          planExtra: { taskmaster: { taskId, title } },
          skipConfirm: true,
          stepOffset: priorContext.stepOffset,
          artifacts: priorContext.artifacts,
        });
      } else {
        const outcome = await plan(input, config, priorContext);
        const steps = ensureReviewStep(outcome.steps, priorContext.stepOffset);
        const planRow = append(sessionId, 'plan', {
          steps: steps.map(serializeStep),
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
        execResult = await executeSteps(input, loopConfig, steps, planRow.id, {
          settledIds: Array.from({ length: priorContext.stepOffset }, (_, i) => `step-${i + 1}`),
          artifacts: priorContext.artifacts,
        });
      }

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
        // Counting the task done while tasks.json still says in-progress would
        // re-run it next time — stop the run instead and say why.
        const message = error instanceof Error ? error.message : String(error);
        taskmasterEvent(taskId, 'failed', {
          title,
          completed,
          remaining: unfinished.length,
          error: `status write failed: ${message}`,
        });
        return {
          ok: false,
          code: 'TASK_STATUS_WRITE_FAILED',
          error: `TaskMaster task #${taskId} finished but could not be marked done: ${message}`,
        };
      }
      deps.onTasksChanged?.(projectPath);
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

      // Clear a stale flag from a previous aborted run; an abort landing
      // during plan() below still sets it and trips the post-plan check.
      abortedParents.delete(sessionId);

      append(sessionId, 'user', { content: input.content });

      // Auto mode = supervised loop: the plan lane writes the goal contract,
      // then steers per-batch decisions until done. An explicit template chip
      // keeps the static pipeline even in auto mode.
      const templateRequested = typeof input.options.template === 'string' && input.options.template;
      if (config.planner.mode === 'auto' && !templateRequested) {
        return executeSupervised(input, config);
      }

      const outcome = await plan(input, config);
      const steps = ensureReviewStep(outcome.steps);
      const planRow = append(sessionId, 'plan', {
        steps: steps.map(serializeStep),
        awaitingConfirm: config.planner.requireConfirm,
        source: outcome.source,
      });

      // An abort that landed while the planner delegation ran would be
      // cleared by executeSteps' start-of-run reset — check before launching.
      if (abortedParents.has(sessionId)) {
        return { ok: false, code: 'ABORTED', error: 'Aborted by user.' };
      }
      // Confirm mode parks here: the plan card stays editable until the
      // client POSTs /plan/confirm, which resumes via `confirm`.
      if (config.planner.requireConfirm) {
        pendingPlans.set(sessionId, { input, planRowId: planRow.id, steps });
        return { ok: true };
      }
      return executeSteps(input, config, steps, planRow.id);
    },

    hasPendingPlan(sessionId: string): boolean {
      if (pendingPlans.has(sessionId) || pendingDecisions.has(sessionId)) return true;
      // Restart-safe: parked plan/decision rows outlive the in-memory stash.
      const rows = orchestratorMessagesDb.list(sessionId);
      const lastPlan = [...rows].reverse().find((row) => row.kind === 'plan');
      if (lastPlan?.payload.awaitingConfirm === true) return true;
      const lastDecision = [...rows].reverse().find((row) => row.kind === 'decision');
      return lastDecision?.payload.awaitingConfirm === true;
    },

    async confirm(sessionId: string, rawSteps: unknown, options: AnyRecord): Promise<OrchestrateResult> {
      const pending = pendingPlans.get(sessionId);
      pendingPlans.delete(sessionId);
      const parkedDecision = pendingDecisions.get(sessionId);
      pendingDecisions.delete(sessionId);
      // Same stale-flag reset as run() — the check before executeSteps below
      // only cares about aborts that land from here on.
      abortedParents.delete(sessionId);
      const config = deps.getConfig();
      const freshDeadline = () =>
        config.execution.runTimeoutMs > 0 ? Date.now() + config.execution.runTimeoutMs : 0;
      // Restart path: with no in-memory stash the pending plan is rebuilt
      // from the transcript — the parked plan row's stored steps restore
      // the prompts, the newest user row restores the original request.
      const rows = orchestratorMessagesDb.list(sessionId);
      const lastPlan = [...rows].reverse().find((row) => row.kind === 'plan') ?? null;
      const lastUser = [...rows].reverse().find((row) => row.kind === 'user') ?? null;
      const input: OrchestrateInput = pending?.input ?? parkedDecision?.input ?? {
        sessionId,
        content: typeof lastUser?.payload.content === 'string' ? lastUser.payload.content : '',
        options,
        connection: { readyState: 0, send: () => undefined } as unknown as OrchestrateInput['connection'],
      };
      // The plan/decision card's wire format omits prompts (they live in the
      // pending stash or the stored row) — restore them by step id so a
      // confirm round-trip does not collapse every step onto one prompt.
      const restorePrompts = (rawList: unknown[], source: OrchestratorPlanStep[]) => {
        const byId = new Map(source.map((s) => [s.id, s]));
        return rawList.map((raw) => {
          if (!raw || typeof raw !== 'object') return raw;
          const step = raw as Record<string, unknown>;
          const hasPrompt = typeof step.prompt === 'string' && step.prompt.trim();
          const original = typeof step.id === 'string' ? byId.get(step.id) : undefined;
          return !hasPrompt && original ? { ...step, prompt: original.prompt } : raw;
        });
      };

      /**
       * Runs one user-confirmed batch through the shared scheduler, then
       * re-enters the loop. Abort/timeout flags translate back into the loop's
       * own exit checks so the summary/report tail still runs.
       */
      const runConfirmedThenLoop = async (
        st: SupervisedState,
        proposedSource: OrchestratorPlanStep[],
      ): Promise<OrchestrateResult> => {
        const nextOffset = st.stepOffset + maxStepNumber(st.steps);
        const accepted = normalizeEditableSteps(
          restorePrompts(Array.isArray(rawSteps) ? rawSteps : [], proposedSource),
          input.content || 'Continue the work.',
          nextOffset,
        ).filter((s) => !st.steps.some((e) => e.id === s.id));
        if (accepted.length === 0) {
          st.feedback =
            'The user rejected the proposed batch at the checkpoint. Propose different steps or finish.';
        } else {
          const batchRes = await executeSteps(input, config, accepted, st.planRowId, batchSeed(st), {
            suppressSummary: true,
          });
          st.steps.push(...accepted);
          patchPlanSteps(sessionId, st.planRowId, st.steps);
          for (const id of batchRes.failed) st.failedIds.add(id);
          if (batchRes.aborted) abortedParents.add(sessionId);
          if (batchRes.timedOut) st.runDeadline = Date.now() - 1;
        }
        return supervisedLoop(input, config, st);
      };

      // Supervised: the user confirmed the goals card — start the loop.
      if (pending?.supervised) {
        const rebuilt = rebuildSupervisedState(sessionId);
        if (!rebuilt) {
          return { ok: false, code: 'NOTHING_TO_CONFIRM', error: 'Supervised plan not found.' };
        }
        orchestratorMessagesDb.updatePayload(rebuilt.state.planRowId, { awaitingConfirm: false });
        rebuilt.state.runDeadline = freshDeadline();
        return supervisedLoop(input, config, rebuilt.state);
      }

      // Supervised: a checkpoint decision parked in memory — confirm/edit its
      // proposed batch, run it, then continue the loop.
      if (parkedDecision) {
        patch(parkedDecision.decisionRowId, { awaitingConfirm: false });
        parkedDecision.state.runDeadline = parkedDecision.state.runDeadline || freshDeadline();
        return runConfirmedThenLoop(parkedDecision.state, parkedDecision.proposed);
      }

      // Supervised restart paths — nothing in memory, rebuild from rows.
      const rebuilt = rebuildSupervisedState(sessionId);
      if (rebuilt) {
        if (rebuilt.planAwaitingConfirm) {
          orchestratorMessagesDb.updatePayload(rebuilt.state.planRowId, { awaitingConfirm: false });
          rebuilt.state.runDeadline = freshDeadline();
          return supervisedLoop(input, config, rebuilt.state);
        }
        if (rebuilt.parkedDecision) {
          patch(rebuilt.parkedDecision.rowId, { awaitingConfirm: false });
          rebuilt.state.runDeadline = freshDeadline();
          const proposedSource = normalizeEditableSteps(rebuilt.parkedDecision.steps, '', 0);
          return runConfirmedThenLoop(rebuilt.state, proposedSource);
        }
        return {
          ok: false,
          code: 'NOTHING_TO_CONFIRM',
          error: 'No pending goals or decision to confirm.',
        };
      }

      const storedSteps = (
        Array.isArray(lastPlan?.payload.steps) ? lastPlan.payload.steps : []
      ) as OrchestratorPlanStep[];
      const promptSource = pending?.steps ?? storedSteps;
      const rawList = restorePrompts(Array.isArray(rawSteps) ? rawSteps : [], promptSource);
      const steps = normalizeEditableSteps(rawList, promptSource[0]?.prompt ?? '');
      if (steps.length === 0) {
        return { ok: false, code: 'EMPTY_PLAN', error: 'No executable steps in the confirmed plan.' };
      }

      // Patch the plan row so history shows the steps as actually approved.
      const planRowId = pending?.planRowId ?? lastPlan?.id ?? null;
      if (planRowId !== null) {
        orchestratorMessagesDb.updatePayload(planRowId, {
          steps: steps.map(serializeStep),
          awaitingConfirm: false,
        });
      } else {
        append(sessionId, 'plan', {
          steps: steps.map(serializeStep),
          awaitingConfirm: false,
        });
      }
      if (abortedParents.has(sessionId)) {
        return { ok: false, code: 'ABORTED', error: 'Aborted by user.' };
      }
      return executeSteps(input, config, steps, planRowId ?? -1);
    },

    async resume(sessionId: string, options: AnyRecord): Promise<OrchestrateResult> {
      // Clear a stale flag from a previous aborted run — same reset as run().
      abortedParents.delete(sessionId);
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

      // Supervised runs resume by re-entering the loop — the supervisor sees
      // the failed/aborted steps in the rebuilt ledger and decides whether to
      // retry, skip or finish. A parked decision gets resolved so it cannot
      // dead-lock the run; the user's prompt becomes a one-shot directive.
      if (lastPlan.payload.source === 'supervised') {
        const rebuilt = rebuildSupervisedState(sessionId);
        if (!rebuilt) {
          return { ok: false, code: 'NOTHING_TO_RESUME', error: 'No plan found to resume.' };
        }
        const config = deps.getConfig();
        if (rebuilt.planAwaitingConfirm) {
          orchestratorMessagesDb.updatePayload(rebuilt.state.planRowId, { awaitingConfirm: false });
        }
        if (rebuilt.parkedDecision) {
          patch(rebuilt.parkedDecision.rowId, { awaitingConfirm: false });
        }
        rebuilt.state.runDeadline =
          config.execution.runTimeoutMs > 0 ? Date.now() + config.execution.runTimeoutMs : 0;
        rebuilt.state.directive =
          typeof options.prompt === 'string' && options.prompt.trim()
            ? options.prompt.trim()
            : null;
        const input: OrchestrateInput = {
          sessionId,
          content: '',
          options,
          connection: { readyState: 0, send: () => undefined } as unknown as OrchestrateInput['connection'],
        };
        return supervisedLoop(input, config, rebuilt.state);
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
      // step's stored artifact (or final text) feeds the rerun step's
      // dependency summary.
      const artifacts = new Map<string, OrchestratorStepArtifact>();
      const delegationRowByStep = new Map<string, number>();
      for (const row of rows) {
        if (row.kind !== 'delegation') continue;
        const stepId = typeof row.payload.stepId === 'string' ? row.payload.stepId : null;
        if (!stepId) continue;
        delegationRowByStep.set(stepId, row.id);
        const artifact = artifactFromPayload(row.payload);
        if (artifact) artifacts.set(stepId, artifact);
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

        const lastOutput = artifacts.get(targetStepId)?.summary ?? '';
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
        patch(lastPlan.id, { steps: updatedSteps.map(serializeStep) });

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
              command:
                typeof s.command === 'string' && s.command.trim() ? s.command.trim() : undefined,
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
        artifacts,
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

      // Supervised continue: optional custom steps run as one batch, then the
      // loop resumes with the user's prompt as a one-shot directive.
      if (lastPlan.payload.source === 'supervised') {
        const rebuilt = rebuildSupervisedState(sessionId);
        if (!rebuilt) {
          return { ok: false, code: 'NOTHING_TO_RESUME', error: 'No plan found to continue.' };
        }
        const st = rebuilt.state;
        st.runDeadline =
          config.execution.runTimeoutMs > 0 ? Date.now() + config.execution.runTimeoutMs : 0;
        st.directive = prompt?.trim() || null;
        if (rebuilt.parkedDecision) {
          patch(rebuilt.parkedDecision.rowId, { awaitingConfirm: false });
        }
        if (Array.isArray(customSteps) && customSteps.length > 0) {
          const accepted = normalizeEditableSteps(
            customSteps,
            prompt ?? '',
            st.stepOffset + maxStepNumber(st.steps),
          ).filter((s) => !st.steps.some((e) => e.id === s.id));
          if (accepted.length > 0) {
            const batchRes = await executeSteps(input, config, accepted, st.planRowId, batchSeed(st), {
              suppressSummary: true,
            });
            st.steps.push(...accepted);
            patchPlanSteps(sessionId, st.planRowId, st.steps);
            for (const id of batchRes.failed) st.failedIds.add(id);
            if (batchRes.aborted) abortedParents.add(sessionId);
            if (batchRes.timedOut) st.runDeadline = Date.now() - 1;
          }
        }
        return supervisedLoop(input, config, st);
      }

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
      patch(lastPlan.id, { steps: updatedSteps.map(serializeStep) });

      const delegationRowByStep = new Map<string, number>();
      for (const row of rows) {
        if (row.kind !== 'delegation') continue;
        const stepId = typeof row.payload.stepId === 'string' ? row.payload.stepId : null;
        if (!stepId) continue;
        delegationRowByStep.set(stepId, row.id);
      }
      const artifacts = new Map(priorContext.artifacts);

      if (abortedParents.has(sessionId)) {
        return { ok: false, code: 'ABORTED', error: 'Aborted by user.' };
      }
      return executeSteps(input, config, newSteps, lastPlan.id, {
        settledIds: allPlanIds,
        artifacts,
        delegationRowByStep,
      });
    },

    completeAllTasks,

    async abort(sessionId: string): Promise<boolean> {
      pendingPlans.delete(sessionId);
      pendingDecisions.delete(sessionId);
      // Parked plan/decision rows survive restarts — clear their
      // awaitingConfirm flags so an aborted session does not stay resumable.
      const parkedRows = orchestratorMessagesDb
        .list(sessionId)
        .filter(
          (row) =>
            (row.kind === 'plan' || row.kind === 'decision') &&
            row.payload.awaitingConfirm === true,
        );
      for (const row of parkedRows) {
        orchestratorMessagesDb.updatePayload(row.id, { awaitingConfirm: false });
      }
      // Covers the retry backoff too — a run sleeping between attempts
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
