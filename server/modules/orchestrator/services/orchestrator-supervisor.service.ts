import type {
  OrchestratorGoals,
  OrchestratorPlanStep,
  OrchestratorProposedStep,
  OrchestratorStepArtifact,
  OrchestratorSupervisorDecision,
  OrchestratorTaskType,
} from '@/shared/types.js';

/**
 * Supervised-loop helpers for the orchestrator executor
 * (`planner.mode === 'auto'`).
 *
 * Everything here is a pure function: prompt builders and tolerant parsers
 * shared between the executor and its tests. The supervisor itself is just a
 * delegated child run on the `plan` routing lane; these helpers define the
 * JSON contracts it reads and writes.
 */

/** Step types a supervisor may delegate — 'plan'/'report' are internal lanes, never steps. */
const DELEGATABLE_TYPES: OrchestratorTaskType[] = [
  'quick',
  'research',
  'docs',
  'code',
  'code-hard',
  'test',
  'review',
  'gate',
];

/** Per-line artifact tail and total cap keep the ledger inside a small context. */
const LEDGER_SUMMARY_CHARS = 300;
const LEDGER_MAX_CHARS = 6000;

/**
 * Extracts the first JSON object from a model reply — tolerates markdown
 * fences and surrounding prose like parsePlanJson does for arrays.
 */
function parseJsonObject(text: string): Record<string, unknown> | null {
  const fenced = text.match(/```(?:json)?\s*([\s\S]*?)```/);
  const candidate = fenced ? fenced[1] : text;
  const start = candidate.indexOf('{');
  const end = candidate.lastIndexOf('}');
  if (start === -1 || end === -1 || end <= start) return null;
  try {
    const parsed = JSON.parse(candidate.slice(start, end + 1));
    return parsed && typeof parsed === 'object' && !Array.isArray(parsed)
      ? (parsed as Record<string, unknown>)
      : null;
  } catch {
    return null;
  }
}

/**
 * Parses the supervisor's goal-contract reply. `doneWhen` items are trimmed
 * to non-empty strings; `requiresTests` defaults to false when absent so a
 * sloppy contract never forces a spurious test gate.
 */
export function parseGoalsJson(text: string): OrchestratorGoals | null {
  const raw = parseJsonObject(text);
  if (!raw) return null;
  const goals = typeof raw.goals === 'string' ? raw.goals.trim() : '';
  if (!goals) return null;
  return {
    goals,
    doneWhen: Array.isArray(raw.doneWhen)
      ? raw.doneWhen.map(String).map((s) => s.trim()).filter(Boolean)
      : [],
    requiresTests: raw.requiresTests === true,
  };
}

/**
 * Parses one supervisor decision. A `continue` with no usable steps still
 * parses — the executor counts those and breaks after two in a row so a
 * confused supervisor cannot spin forever.
 */
export function parseDecisionJson(text: string): OrchestratorSupervisorDecision | null {
  const raw = parseJsonObject(text);
  if (!raw) return null;
  const action = raw.action === 'done' ? 'done' : raw.action === 'continue' ? 'continue' : null;
  if (!action) return null;
  const outcome =
    raw.outcome === 'partial' || raw.outcome === 'failed' || raw.outcome === 'success'
      ? raw.outcome
      : undefined;
  return {
    action,
    reason: typeof raw.reason === 'string' ? raw.reason.trim() : '',
    outcome,
    steps: (Array.isArray(raw.steps) ? raw.steps : []) as OrchestratorProposedStep[],
  };
}

/**
 * Prompt for the goals call — the planner lane's first supervised job.
 * Consumed by the executor's `executeSupervised` and by tests.
 */
export function buildGoalsPrompt(
  content: string,
  languageName?: string | null,
  repoMap?: string | null,
): string {
  const parts = [
    'You are the supervisor of an autonomous agent run. Read the request and write its goal contract — you will re-check it after every batch of work before deciding the run is finished.',
    'Output ONLY a JSON object:',
    '{"goals": "one paragraph describing the end state", "doneWhen": ["observable criterion", "..."], "requiresTests": true}',
    'Rules: each doneWhen item must be checkable from step results (files written, tests green, docs updated). Keep doneWhen to 2-5 concrete items. Set requiresTests=true when the request changes behavior or explicitly asks for verification.',
  ];
  if (languageName) {
    parts.push(`Write "goals" and "doneWhen" in ${languageName}.`);
  }
  if (repoMap) {
    parts.push('', 'REPOSITORY MAP (real paths — reference these in later step prompts):', repoMap);
  }
  parts.push('', `Request: ${content.trim() || 'Continue the session.'}`);
  return parts.join('\n');
}

/**
 * Prompt for one supervisor decision. The ledger summarizes every step so
 * far so the supervisor decides with full state in a small context.
 * Consumed by the executor's supervised loop and by tests.
 */
export function buildSupervisorPrompt(input: {
  content: string;
  goals: OrchestratorGoals;
  ledger: string;
  iteration: number;
  maxIterations: number;
  maxParallel: number;
  languageName?: string | null;
  /** Extra user directive (continueSession prompt) injected for this decision. */
  directive?: string | null;
  /** Set after a done-gate rejection or an empty/invalid previous decision. */
  feedback?: string | null;
}): string {
  const doneWhen =
    input.goals.doneWhen.length > 0
      ? input.goals.doneWhen.map((item) => `- ${item}`).join('\n')
      : '- the request is fully implemented';
  const parts = [
    'You are the supervisor of an autonomous agent run. After each batch of steps you decide what happens next, until the goal contract is satisfied.',
    '',
    'GOAL CONTRACT:',
    `Goals: ${input.goals.goals}`,
    'Done requires ALL of:',
    doneWhen,
    `Tests required: ${input.goals.requiresTests ? 'yes' : 'no'}`,
    '',
    `Iteration ${input.iteration} of ${input.maxIterations}.`,
    '',
    'LEDGER — every step so far:',
    input.ledger || '(no steps yet)',
    '',
    'RULES:',
    `- Emit 1..${input.maxParallel} NEW steps per decision. A step's dependsOn may only list step ids that already exist in the ledger; steps in one batch run in parallel.`,
    '- Keep every step small and self-contained — the executing agent is a fresh context that sees only its "prompt" plus the results of the steps it dependsOn.',
    `- Allowed types: ${DELEGATABLE_TYPES.join(', ')}. A "gate" step runs {"type":"gate","command":"npm test"} deterministically instead of delegating — prefer it for build/test verification.`,
    '- Do NOT emit done while ledger shows code changed without a later successful review (and test/gate pass when tests are required) — the gate rejects it and wastes an iteration.',
    '- When the contract is satisfied or further progress is impossible, emit done with outcome success|partial|failed.',
  ];
  if (input.languageName) {
    parts.push(`Write "title", "prompt" and "reason" in ${input.languageName}.`);
  }
  if (input.directive) {
    parts.push('', `USER DIRECTIVE (takes priority this iteration): ${input.directive}`);
  }
  if (input.feedback) {
    parts.push('', `NOTE: ${input.feedback}`);
  }
  parts.push(
    '',
    'Output ONLY a JSON object:',
    '{"action":"continue","reason":"why these steps","steps":[{"type":"code","title":"short","prompt":"full instruction","dependsOn":["step-1"],"command":"optional for gate"}]}',
    'or {"action":"done","reason":"why finished","outcome":"success|partial|failed","steps":[]}',
  );
  return parts.join('\n');
}

/**
 * Prompt for the final report call (the `report` lane — cheapest models).
 * The reporter summarizes what the run did and what is left, in the UI
 * language. Consumed by the executor's supervised loop and by tests.
 */
export function buildReportPrompt(input: {
  content: string;
  goals: OrchestratorGoals;
  ledger: string;
  status: 'ok' | 'partial' | 'failed' | 'aborted' | 'timed-out';
  languageName?: string | null;
}): string {
  return [
    'You write the final report of an autonomous agent run for the user. Be concise and factual — max ~200 words, markdown allowed.',
    'Cover: what was accomplished (short bullets), the final outcome, anything unfinished or risky, suggested follow-ups if any.',
    input.languageName ? `Write the entire report in ${input.languageName}.` : '',
    '',
    `GOAL CONTRACT:\nGoals: ${input.goals.goals}\nDone criteria: ${input.goals.doneWhen.join('; ') || 'n/a'}`,
    `RUN STATUS: ${input.status}`,
    '',
    'LEDGER — every step that ran:',
    input.ledger || '(none)',
    '',
    'Output ONLY the report text.',
  ]
    .filter((line) => line !== '')
    .join('\n');
}

/**
 * Serializes the step ledger handed to supervisor and reporter prompts: one
 * line per step — id, type, title, status and a bounded artifact summary.
 * Consumed by the executor's supervised loop and by tests.
 */
export function buildSupervisorLedger(input: {
  steps: OrchestratorPlanStep[];
  artifacts: Map<string, OrchestratorStepArtifact>;
  failed: ReadonlySet<string>;
}): string {
  const lines: string[] = [];
  for (const step of input.steps) {
    const artifact = input.artifacts.get(step.id);
    const status = input.failed.has(step.id) ? 'failed' : artifact ? 'done' : 'pending';
    const tail = artifact ? ` — ${artifact.summary.slice(-LEDGER_SUMMARY_CHARS)}` : '';
    lines.push(`- ${step.id} [${step.type}] "${step.title}": ${status}${tail}`);
  }
  const text = lines.join('\n');
  return text.length > LEDGER_MAX_CHARS ? `…${text.slice(-LEDGER_MAX_CHARS)}` : text;
}

/**
 * Normalizes a decision's proposed steps into plan steps: ids continue the
 * plan's `step-N` numbering, only delegatable types survive, and dependsOn
 * is restricted to ids that already exist (in-ledger or the offset range)
 * plus earlier siblings from the same decision — a review can chain onto
 * the code step proposed alongside it, while forward/self deps stay
 * impossible by construction.
 * Consumed by the executor's supervised loop and by tests.
 */
export function normalizeProposedSteps(
  raw: OrchestratorProposedStep[],
  fallbackPrompt: string,
  stepOffset: number,
  existingIds: ReadonlySet<string>,
  maxNew: number,
): OrchestratorPlanStep[] {
  const validDepIds = new Set(existingIds);
  for (let i = 1; i <= stepOffset; i++) validDepIds.add(`step-${i}`);
  const steps: OrchestratorPlanStep[] = [];
  for (const [index, entry] of raw.slice(0, Math.max(0, maxNew)).entries()) {
    const type = entry.type as OrchestratorTaskType;
    if (!DELEGATABLE_TYPES.includes(type)) continue;
    const targetNum = stepOffset + index + 1;
    const id = `step-${targetNum}`;
    steps.push({
      id,
      type,
      title:
        typeof entry.title === 'string' && entry.title.trim()
          ? entry.title.trim()
          : `Step ${targetNum}`,
      prompt:
        typeof entry.prompt === 'string' && entry.prompt.trim()
          ? entry.prompt.trim()
          : fallbackPrompt,
      dependsOn: Array.isArray(entry.dependsOn)
        ? entry.dependsOn.map(String).filter((dep) => validDepIds.has(dep))
        : [],
      enabled: true,
      command:
        type === 'gate' && typeof entry.command === 'string' && entry.command.trim()
          ? entry.command.trim()
          : undefined,
    });
    validDepIds.add(id);
  }
  return steps;
}

/**
 * The deterministic done-gate. Returns 'review' when code-typed artifacts
 * exist with no successful review after the latest one, 'test' when the
 * goal contract requires tests and no test/gate succeeded after the latest
 * code step, or null when finishing is allowed. Consumed by the executor's
 * supervised loop and by tests.
 */
export function doneGateOverride(
  steps: OrchestratorPlanStep[],
  artifacts: Map<string, OrchestratorStepArtifact>,
  requiresTests: boolean,
): 'review' | 'test' | null {
  const enabled = steps.filter((s) => s.enabled !== false);
  const indexOf = new Map(enabled.map((s, i) => [s.id, i]));
  let lastCodeIdx = -1;
  for (const s of enabled) {
    if ((s.type === 'code' || s.type === 'code-hard') && artifacts.has(s.id)) {
      lastCodeIdx = Math.max(lastCodeIdx, indexOf.get(s.id) ?? -1);
    }
  }
  if (lastCodeIdx === -1) return null;
  const succeededAfter = (type: OrchestratorTaskType | 'gate-or-test') =>
    enabled.some((s) => {
      const idx = indexOf.get(s.id) ?? -1;
      if (idx <= lastCodeIdx || !artifacts.has(s.id)) return false;
      return type === 'gate-or-test' ? s.type === 'test' || s.type === 'gate' : s.type === type;
    });
  if (!succeededAfter('review')) return 'review';
  if (requiresTests && !succeededAfter('gate-or-test')) return 'test';
  return null;
}
