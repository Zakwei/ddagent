import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';

import ts from 'typescript';

import {
  claudeStatusLine,
  describeClaudeResultFailure,
  scopeRememberedRule,
} from '@/modules/providers/list/claude/claude-runtime.provider.js';

/** Evaluates the runtime with a fake SDK so private maps and the run loop can be driven. */
async function loadClaudeRuntime(overrides: Record<string, unknown>) {
  const url = new URL('../list/claude/claude-runtime.provider.ts', import.meta.url);
  const source = await readFile(url, 'utf8');
  const ast = ts.createSourceFile(url.pathname, source, ts.ScriptTarget.Latest, true);
  const imports = new Map<string, unknown>();
  for (const node of ast.statements) {
    if (!ts.isImportDeclaration(node) || node.importClause?.isTypeOnly) continue;
    const spec = (node.moduleSpecifier as ts.StringLiteral).text;
    imports.set(spec, overrides[spec] ?? await import(spec));
  }
  const output = ts.transpileModule(`${source}\nexport const hooks = { matchesToolPermission };`, {
    compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022, esModuleInterop: true },
  }).outputText;
  const module = { exports: {} as Record<string, any> };
  new Function('require', 'module', 'exports', output)((spec: string) => imports.get(spec), module, module.exports);
  return module.exports;
}

function fakeSdk() {
  const processes: any[] = [];
  const query = ({ prompt, options }: { prompt: AsyncIterable<any>; options: any }) => {
    const outbox: any[] = [];
    let wake: (() => void) | null = null;
    let ended = false;
    const proc = {
      options,
      prompts: [] as any[],
      modes: [] as string[],
      emit(message: any) { outbox.push({ session_id: 'native', ...message }); wake?.(); },
      end() { ended = true; wake?.(); },
    };
    void (async () => { for await (const message of prompt) proc.prompts.push(message); })();
    processes.push(proc);
    const stream = (async function* () {
      while (true) {
        while (outbox.length) yield outbox.shift();
        if (ended) return;
        await new Promise<void>((resolve) => { wake = resolve; });
      }
    })();
    return Object.assign(stream, {
      interrupt: async () => proc.end(),
      setPermissionMode: async (mode: string) => { proc.modes.push(mode); },
    });
  };
  return { query, processes };
}

async function until(condition: () => boolean) {
  const deadline = Date.now() + 5000;
  while (!condition() && Date.now() < deadline) await new Promise((resolve) => setTimeout(resolve, 2));
  assert.ok(condition(), 'condition not reached');
}

function writer() {
  const events: any[] = [];
  return { events, userId: null, send(message: any) { events.push(message); } };
}

async function setup(resolveResumeModel: () => Promise<unknown> = async () => undefined) {
  const sdk = fakeSdk();
  const storedModes: Array<[string, string]> = [];
  const runtime = await loadClaudeRuntime({
    '@anthropic-ai/claude-agent-sdk': { query: sdk.query },
    '@/modules/database/index.js': {
      orchestratorMessagesDb: { findDelegationByChildSessionId: () => null },
      sessionsDb: {
        setSessionContextWindow: () => {},
        setSessionPermissionMode: (id: string, mode: string) => storedModes.push([id, mode]),
      },
    },
  });
  const context = {
    resolveProviderSessionId: () => 'native',
    resolveResumeModel,
    getProviderModels: async () => ({ OPTIONS: [], DEFAULT: 'default' }),
    isProviderInstalled: async () => true,
    normalizeMessage: () => [],
  };
  return { runtime, sdk, context, storedModes };
}

test('claude: a failed result sends error before complete with exitCode 1', async () => {
  const { runtime, sdk, context } = await setup();
  const out = writer();
  const run = runtime.queryClaudeSDK('hi', { sessionId: 'app-fail', cwd: '/tmp' }, out, context);
  await until(() => sdk.processes[0]?.prompts.length === 1);
  const proc = sdk.processes[0];
  proc.emit({ type: 'assistant', error: 'rate_limit', message: { content: [] } });
  proc.emit({ type: 'result', subtype: 'success', is_error: true, result: 'API Error: 429' });
  proc.end();
  await run;
  const kinds = out.events.map((event) => event.kind).filter((kind) => kind === 'error' || kind === 'complete');
  assert.deepEqual(kinds, ['error', 'complete']);
  assert.match(out.events.find((event) => event.kind === 'error').content, /usage limit.*API Error: 429/);
  assert.equal(out.events.find((event) => event.kind === 'complete').exitCode, 1);
});

test('claude: a stop that arrives before the query exists is honoured', async () => {
  let release!: () => void;
  const gate = new Promise<void>((resolve) => { release = resolve; });
  const { runtime, sdk, context } = await setup(async () => { await gate; return undefined; });
  const run = runtime.queryClaudeSDK('hi', { sessionId: 'app-early', cwd: '/tmp' }, writer(), context);
  assert.equal(await runtime.abortClaudeSDKSession('app-early'), true);
  release();
  await run;
  assert.equal(sdk.processes.length, 0, 'the CLI is never spawned');
  assert.equal(await runtime.abortClaudeSDKSession('app-early'), false, 'no stale pending abort');
});

test('claude: a stop during setup next to a held process spawns no new CLI', async () => {
  let release!: () => void;
  const gate = new Promise<void>((resolve) => { release = resolve; });
  let calls = 0;
  const { runtime, sdk, context } = await setup(async () => { calls += 1; if (calls > 1) await gate; return undefined; });
  const first = writer();
  const held = runtime.queryClaudeSDK('start', { sessionId: 'app-held', cwd: '/tmp' }, first, context);
  await until(() => sdk.processes[0]?.prompts.length === 1);
  sdk.processes[0].emit({ type: 'system', subtype: 'task_started', task_id: 't1' });
  sdk.processes[0].emit({ type: 'result', subtype: 'success', is_error: false });
  await until(() => first.events.some((event) => event.kind === 'complete'));

  const next = runtime.queryClaudeSDK('next', { sessionId: 'app-held', cwd: '/tmp' }, writer(), context);
  await until(() => calls === 2);
  assert.equal(await runtime.abortClaudeSDKSession('app-held'), true);
  release();
  await Promise.all([held, next]);
  assert.equal(sdk.processes.length, 1, 'the stopped turn never spawns a CLI');
});

test('claude: permission mode changes apply live and do not respawn a held process', async () => {
  const { runtime, sdk, context, storedModes } = await setup();
  const options = { sessionId: 'app-mode', cwd: '/tmp', permissionMode: 'plan' };
  const first = writer();
  void runtime.queryClaudeSDK('plan it', options, first, context);
  await until(() => sdk.processes[0]?.prompts.length === 1);
  const proc = sdk.processes[0];
  assert.equal(proc.options.permissionMode, 'plan');

  // The approved plan leaves plan mode and is persisted as `default`.
  const decision = proc.options.canUseTool('ExitPlanMode', { plan: 'x' }, {});
  const [pending] = runtime.getPendingApprovalsForSession('app-mode');
  runtime.resolveToolApproval(pending.requestId, { allow: true });
  assert.equal((await decision).behavior, 'allow');
  assert.deepEqual(storedModes, [['app-mode', 'default']]);

  runtime.claudeRuntime.setPermissionMode('app-mode', 'acceptEdits');
  assert.deepEqual(proc.modes, ['acceptEdits']);
  // Bypass is emulated: the CLI goes to default and canUseTool allows.
  runtime.claudeRuntime.setPermissionMode('app-mode', 'bypassPermissions');
  assert.deepEqual(proc.modes, ['acceptEdits', 'default']);
  assert.equal((await proc.options.canUseTool('Bash', { command: 'rm x' }, {})).behavior, 'allow');

  // Background work holds the process; a turn in another mode joins it.
  proc.emit({ type: 'system', subtype: 'task_started', task_id: 't1' });
  proc.emit({ type: 'result', subtype: 'success', is_error: false });
  await until(() => first.events.some((event) => event.kind === 'complete'));
  void runtime.queryClaudeSDK('next', { ...options, permissionMode: 'acceptEdits' }, writer(), context);
  await until(() => proc.prompts.length === 2);
  assert.equal(sdk.processes.length, 1);
  assert.deepEqual(proc.modes, ['acceptEdits', 'default', 'acceptEdits']);
  proc.end();
});

test('claude: Always rules are only the offered entry, edits scoped to the project', async () => {
  const { runtime } = await setup();
  const match = runtime.hooks.matchesToolPermission;
  assert.equal(scopeRememberedRule('Bash(git status:*)', 'Bash(rm:*)', 'Bash', '/p'), null);
  assert.equal(scopeRememberedRule('Bash(git status:*)', 'Bash(git status:*)', 'Bash', '/p'), 'Bash(git status:*)');
  const rule = scopeRememberedRule('Edit', 'Edit', 'Edit', '/work/proj');
  assert.equal(rule, 'Edit(//work/proj/**)');
  assert.equal(match(rule, 'Edit', { file_path: '/work/proj/src/a.ts' }), true);
  assert.equal(match(rule, 'Edit', { file_path: '/work/proj/../other/a.ts' }), false);
  assert.equal(match(rule, 'Edit', { file_path: '/work/project2/a.ts' }), false);
  assert.equal(match(rule, 'Write', { file_path: '/work/proj/a.ts' }), false);
});

test('claude: status lines and result failures read clearly', () => {
  assert.deepEqual(claudeStatusLine({ type: 'system', subtype: 'api_retry', attempt: 2, max_retries: 10, retry_delay_ms: 4000, error_status: 529, error: 'overloaded' }),
    { text: 'API error (overloaded 529), retrying in 4s — attempt 2/10.', notice: true });
  assert.equal(claudeStatusLine({ type: 'system', subtype: 'status', status: 'compacting' })?.notice, false);
  assert.match(claudeStatusLine({ type: 'system', subtype: 'status', status: null, compact_result: 'failed', compact_error: 'too long' })!.text, /Compaction failed: too long/);
  assert.match(claudeStatusLine({ type: 'system', subtype: 'permission_denied', tool_name: 'Bash', message: 'denied by rule' })!.text, /Bash denied: denied by rule/);
  assert.equal(claudeStatusLine({ type: 'rate_limit_event', rate_limit_info: { status: 'allowed' } }), null);
  assert.match(claudeStatusLine({ type: 'rate_limit_event', rate_limit_info: { status: 'rejected', rateLimitType: 'five_hour' } })!.text, /usage limit reached \(five hour\)/);
  // The failover reads the structured state, not the text.
  assert.deepEqual(
    claudeStatusLine({ type: 'rate_limit_event', rate_limit_info: { status: 'allowed_warning', resetsAt: 1791460800 } })!.usageLimit,
    { state: 'warning', resetAt: 1791460800000 },
  );
  assert.deepEqual(
    claudeStatusLine({ type: 'rate_limit_event', rate_limit_info: { status: 'rejected' } })!.usageLimit,
    { state: 'reached', resetAt: null },
  );
  assert.match(claudeStatusLine({ type: 'result', subtype: 'success', is_error: false, stop_reason: 'refusal' })!.text, /refusal/);

  assert.equal(describeClaudeResultFailure({ subtype: 'success', is_error: false }, null), null);
  assert.equal(describeClaudeResultFailure({ subtype: 'error_max_turns', is_error: true, errors: [] }, null), 'Stopped: reached the maximum number of turns.');
  assert.equal(
    describeClaudeResultFailure({ subtype: 'error_during_execution', is_error: true, errors: ['boom'], permission_denials: [{ tool_name: 'Bash' }] }, 'authentication_failed'),
    'Claude authentication failed — log in again. boom Denied tools: Bash.',
  );
});
