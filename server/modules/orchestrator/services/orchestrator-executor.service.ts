import { exec, execFile } from 'node:child_process';
import { appendFile, mkdir, readdir, readFile } from 'node:fs/promises';
import { join } from 'node:path';
import { promisify } from 'node:util';

import { orchestratorMessagesDb } from '@/modules/database/index.js';
import type { OrchestratorDelegationService } from '@/modules/orchestrator/services/orchestrator-delegation.service.js';
import type { OrchestratorRouter } from '@/modules/orchestrator/services/orchestrator-router.service.js';
import type {
  AnyRecord,
  OrchestratorCandidate,
  OrchestratorConfig,
  OrchestratorFailureClass,
  OrchestratorPlanStep,
  OrchestratorStepArtifact,
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
 * Maps a child-run error string onto its failure class — drives the
 * per-class same-lane retry budget and the lane cooldown breaker.
 * Consumed by executor + tests. Order matters: a "rate-limited, quota
 * resets in 144h" message is rate_limit even though it says quota, and a
 * 403 about billing is auth, not quota.
 */
export function classifyStepError(error: string | null | undefined): OrchestratorFailureClass {
  const text = error ?? '';
  if (/rate.?limit|429|too many|throttl|resource.?exhausted/i.test(text)) return 'rate_limit';
  if (/401|403|unauthori[sz]ed|forbidden|invalid (api.?key|token|credentials?)|token (invalid|expired)|missing access token|permission denied|not logged in/i.test(text)) return 'auth';
  if (/quota|insufficient (balance|credits?)|billing|payment required|plan (exhausted|limit)|exceeded (the |your )?(quota|usage|monthly limit)/i.test(text)) return 'quota';
  if (/timed? ?out|deadline exceeded|etimedout/i.test(text)) return 'timeout';
  return 'transient';
}

/**
 * Result of one gate command run: exit code, combined stdout/stderr tail,
 * and whether the run was killed on its timeout budget.
 */
export type GateRunResult = { code: number; output: string; timedOut: boolean };

const execAsync = promisify(exec);
const execFileAsync = promisify(execFile);

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
    `Allowed types: ${TASK_TYPES.filter((t) => t !== 'plan').join(', ')}.`,
    'Rules: analysis/comparison of existing code is research, not code. Any plan that modifies code must end with a review step. Cheap work (code, test, docs, quick) goes on small models; review goes LAST. Deterministic verification (tests, builds) belongs on a gate step — {"type":"gate","title":"...","command":"npm test"} runs the command itself instead of delegating to an agent.',
    'Use a single step ONLY for a trivial single-purpose request; requests mixing analysis and implementation need separate steps.',
    `Output ONLY a JSON array: [{"type":"...","title":"short","prompt":"full instruction for the sub-agent","dependsOn":["${stepOffset > 0 ? `step-${stepOffset}` : 'step-1'}"]}]. Step ids are ${nextIdExample}, ... in order starting at ${startId}.`,
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
     *  artifacts, and their existing delegation rows for in-place patches. */
    seed?: {
      settledIds?: string[];
      artifacts?: Map<string, OrchestratorStepArtifact>;
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

    const artifacts = seed?.artifacts ?? new Map<string, OrchestratorStepArtifact>();
    const settled = new Set<string>([
      ...steps.filter((s) => !s.enabled).map((s) => s.id),
      ...(seed?.settledIds ?? []),
    ]);
    const failed = new Set<string>();
    /** Set by a user-cancelled child run or the parent session's abort. */
    let runAborted = false;
    /** Global run deadline — a bounded plan cannot burn lanes forever. */
    const runDeadline = config.execution.runTimeoutMs > 0 ? Date.now() + config.execution.runTimeoutMs : 0;
    let runTimedOut = false;
    /**
     * Run-scoped circuit breaker: candidates cooled by quota/auth failures,
     * an exhausted rate-limit budget, or a 2-streak of transient/timeout
     * errors are skipped by every remaining step of this run.
     */
    const cooldown = new Set<string>();
    /** Consecutive transient/timeout failures per candidate — 2 cools it. */
    const failStreak = new Map<string, number>();
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
        patch(resumeRowId, { status: 'queued', attempt: 1, error: null, candidateId: routed.candidate.id });
      } else {
        delegationRow = append(sessionId, 'delegation', {
          stepId: step.id,
          taskType: step.type,
          title: step.title,
          candidateId: routed.candidate.id,
          provider: routed.candidate.provider,
          model: routed.candidate.model,
          effort: routed.decision.effort,
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

      // Changed-file baseline probed once before the first attempt; the
      // step artifact's diff is measured against it on success.
      const baseline = cwd ? await probeChangedFiles(cwd) : new Set<string>();
      /** Same-lane retries consumed per failure class on this step. */
      const classRetries: Partial<Record<OrchestratorFailureClass, number>> = {};

      let attempt = 0;
      let candidateIndex = 0;
      for (;;) {
        while (candidateIndex < candidates.length && cooldown.has(candidates[candidateIndex].id)) {
          candidateIndex += 1;
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
          accountId: candidate.accountId,
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
        // budget/failover path handles it.
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
                    stepTimer.unref?.();
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

    append(sessionId, 'summary', {
      text:
        `${okCount}/${total} steps completed` +
        (failedList.length ? `, failed: ${failedList.join(', ')}` : '') +
        (runAborted ? ' (aborted)' : '') +
        (runTimedOut ? ' (timed out)' : ''),
      failed: failedList,
      aborted: runAborted,
      timedOut: runTimedOut,
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
      const execResult = await executeSteps(input, loopConfig, steps, planRow.id, {
        settledIds: Array.from({ length: priorContext.stepOffset }, (_, i) => `step-${i + 1}`),
        artifacts: priorContext.artifacts,
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
      if (pendingPlans.has(sessionId)) return true;
      // Restart-safe: a parked plan row outlives the in-memory stash.
      const lastPlan = [...orchestratorMessagesDb.list(sessionId)]
        .reverse()
        .find((row) => row.kind === 'plan');
      return lastPlan?.payload.awaitingConfirm === true;
    },

    async confirm(sessionId: string, rawSteps: unknown, options: AnyRecord): Promise<OrchestrateResult> {
      const pending = pendingPlans.get(sessionId);
      pendingPlans.delete(sessionId);
      // Same stale-flag reset as run() — the check before executeSteps below
      // only cares about aborts that land from here on.
      abortedParents.delete(sessionId);
      const config = deps.getConfig();
      // Restart path: with no in-memory stash the pending plan is rebuilt
      // from the transcript — the parked plan row's stored steps restore
      // the prompts, the newest user row restores the original request.
      const rows = orchestratorMessagesDb.list(sessionId);
      const lastPlan = [...rows].reverse().find((row) => row.kind === 'plan') ?? null;
      const storedSteps = (
        Array.isArray(lastPlan?.payload.steps) ? lastPlan.payload.steps : []
      ) as OrchestratorPlanStep[];
      const lastUser = [...rows].reverse().find((row) => row.kind === 'user') ?? null;
      const input: OrchestrateInput = pending?.input ?? {
        sessionId,
        content: typeof lastUser?.payload.content === 'string' ? lastUser.payload.content : '',
        options,
        connection: { readyState: 0, send: () => undefined } as unknown as OrchestrateInput['connection'],
      };
      // The plan card's wire format omits prompts (they live in the pending
      // stash or the stored plan row) — restore them by step id so a
      // confirm round-trip does not collapse every step onto step-1's.
      const promptSource = pending?.steps ?? storedSteps;
      const pendingById = new Map(promptSource.map((s) => [s.id, s]));
      const rawList = (Array.isArray(rawSteps) ? rawSteps : []).map((raw) => {
        if (!raw || typeof raw !== 'object') return raw;
        const step = raw as Record<string, unknown>;
        const hasPrompt = typeof step.prompt === 'string' && step.prompt.trim();
        const original = typeof step.id === 'string' ? pendingById.get(step.id) : undefined;
        return !hasPrompt && original ? { ...step, prompt: original.prompt } : raw;
      });
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
      // A parked plan row survives restarts — clear its awaitingConfirm
      // flag so an aborted confirm-pending session does not stay resumable.
      const parkedPlan = [...orchestratorMessagesDb.list(sessionId)]
        .reverse()
        .find((row) => row.kind === 'plan' && row.payload.awaitingConfirm === true);
      if (parkedPlan) {
        orchestratorMessagesDb.updatePayload(parkedPlan.id, { awaitingConfirm: false });
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
