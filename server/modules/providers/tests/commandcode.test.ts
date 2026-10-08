import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { CommandCodeMcpProvider } from '@/modules/providers/list/commandcode/commandcode-mcp.provider.js';
import { parseCommandCodeModelList } from '@/modules/providers/list/commandcode/commandcode-models.provider.js';
import { commandCodeToolNameFromAcp, isEditPermissionRequest, questionAnswerOptionId, resolveCommandCodePlanReviewContent } from '@/modules/providers/list/commandcode/commandcode-runtime.provider.js';
import { COMMAND_CODE_CONTINUATION_PROMPT, CommandCodeSessionsProvider, readCommandCodeTranscript } from '@/modules/providers/list/commandcode/commandcode-sessions.provider.js';
import {
  commandCodeProjectSlug,
  isCommandCodeTranscriptFileName,
  resolveCommandCodeExecutable,
} from '@/shared/utils.js';

const patchHomeDir = (nextHomeDir: string) => {
  const original = os.homedir;
  (os as any).homedir = () => nextHomeDir;
  return () => {
    (os as any).homedir = original;
  };
};

const readJson = async (filePath: string): Promise<Record<string, unknown>> => {
  const content = await fs.readFile(filePath, 'utf8');
  return JSON.parse(content) as Record<string, unknown>;
};

test('commandCodeProjectSlug matches the CLI\'s project directory naming', () => {
  assert.equal(commandCodeProjectSlug('/tmp/CC-Test Dir'), 'tmp-cc-test-dir');
  assert.equal(commandCodeProjectSlug('/home/user/my_project.v2'), 'home-user-my-project-v2');
  assert.equal(commandCodeProjectSlug('C:\\Work\\Repo'), 'c-work-repo');
  assert.equal(commandCodeProjectSlug(''), 'root');
  assert.equal(commandCodeProjectSlug('///'), 'root');
});

test('isCommandCodeTranscriptFileName keeps primary transcripts and drops sidecars', () => {
  assert.equal(isCommandCodeTranscriptFileName('sess-1.jsonl'), true);
  assert.equal(isCommandCodeTranscriptFileName('sess-1.meta.json'), false);
  assert.equal(isCommandCodeTranscriptFileName('sess-1.checkpoints.jsonl'), false);
  assert.equal(isCommandCodeTranscriptFileName('sess-1.prompts.jsonl'), false);
  assert.equal(isCommandCodeTranscriptFileName('sess-1.v2.bak'), false);
  assert.equal(isCommandCodeTranscriptFileName('share.json'), false);
});

test('resolveCommandCodeExecutable picks the first working documented alias', () => {
  const seen: string[] = [];
  const spawnSync = (command: string) => {
    seen.push(command);
    return command === 'cmd' ? { status: 0 } : { status: 1 };
  };
  assert.equal(resolveCommandCodeExecutable(spawnSync), 'cmd');
  assert.equal(seen.length, 2); // command-code failed, cmd answered

  const none = resolveCommandCodeExecutable(() => ({ status: 1 }));
  assert.equal(none, null);
});

test('resolveCommandCodeExecutable honors COMMAND_CODE_CLI_PATH before probing', () => {
  const previous = process.env.COMMAND_CODE_CLI_PATH;
  process.env.COMMAND_CODE_CLI_PATH = '  /opt/cc/bin/command-code  ';
  try {
    let probed = 0;
    const resolved = resolveCommandCodeExecutable(() => {
      probed += 1;
      return { status: 0 };
    });
    assert.equal(resolved, '/opt/cc/bin/command-code');
    assert.equal(probed, 0);
  } finally {
    if (previous === undefined) {
      delete process.env.COMMAND_CODE_CLI_PATH;
    } else {
      process.env.COMMAND_CODE_CLI_PATH = previous;
    }
  }
});

test('parseCommandCodeModelList parses the --list-models table', () => {
  const stdout = [
    'Available models  ·  3 models',
    '',
    'Open Source',
    '',
    'deepseek/deepseek-v4-flash      fast hybrid-attention reasoning (default)',
    'moonshotai/kimi-k2.5          FREE multimodal frontend coding',
    'google/gemini-3.8-flash       fast multimodal model',
    '',
    'Pass the full id, or just the short name after the last "/":',
    'cmd --model moonshotai/kimi-k2.5',
    '',
    'Docs:  https://commandcode.ai/docs/reference/cli/models',
  ].join('\n');

  const catalog = parseCommandCodeModelList(stdout);
  assert.ok(catalog);
  assert.equal(catalog.DEFAULT, 'deepseek/deepseek-v4-flash');
  assert.deepEqual(
    catalog.OPTIONS.map((option) => option.value),
    ['deepseek/deepseek-v4-flash', 'moonshotai/kimi-k2.5', 'google/gemini-3.8-flash'],
  );
  assert.equal(catalog.OPTIONS[1].tier, 'free');
  assert.equal(catalog.OPTIONS[0].tier, 'paid');
  assert.equal(catalog.OPTIONS[0].description, 'fast hybrid-attention reasoning');
});

test('parseCommandCodeModelList returns null on empty output', () => {
  assert.equal(parseCommandCodeModelList(''), null);
  assert.equal(parseCommandCodeModelList('Docs: https://x'), null);
});

test('readCommandCodeTranscript parses v3 rows and skips torn lines', async () => {
  const tempRoot = await fs.mkdtemp(path.join(os.tmpdir(), 'cc-transcript-'));
  try {
    const filePath = path.join(tempRoot, 'sess-9.jsonl');
    await fs.writeFile(filePath, [
      JSON.stringify({ type: 'session', id: 'sess-9', cwd: '/tmp/ws' }),
      JSON.stringify({ type: 'message', id: 'm1', message: { role: 'user', content: 'hi' } }),
      '{"type":"message","id":"m2","broken":',
      JSON.stringify({ type: 'model_change', id: 'm3', model: 'deepseek/deepseek-v4-flash' }),
    ].join('\n'));

    const entries = await readCommandCodeTranscript(filePath);
    assert.equal(entries.length, 3);
    assert.equal(entries[0].type, 'session');
    assert.equal(entries[1].id, 'm1');
    assert.equal(entries[2].type, 'model_change');
  } finally {
    await fs.rm(tempRoot, { recursive: true, force: true });
  }
});

test('questionAnswerOptionId keeps a label that itself contains ", " intact', () => {
  const question = 'Co dokładnie ma obejmować "przeczyść wszystko do zera"?';
  const params = {
    toolCall: {
      title: `Zakres resetu: ${question}`,
      rawInput: {
        question,
        options: ['Nic nie zmieniam, tylko przegląd', 'Reset konfiguracji'],
      },
    },
    options: [
      { optionId: 'option_0', name: 'Nic nie zmieniam, tylko przegląd: bez zmian' },
      { optionId: 'option_1', name: 'Reset konfiguracji: świeży config' },
    ],
  };

  // The picked label contains ", " — splitting it would drop the selection.
  assert.equal(
    questionAnswerOptionId(params, { answers: { [question]: 'Nic nie zmieniam, tylko przegląd' } }),
    'option_0',
  );
  assert.equal(
    questionAnswerOptionId(params, { answers: { [question]: 'Reset konfiguracji' } }),
    'option_1',
  );
  // Arrays and comma-free labels keep working.
  assert.equal(
    questionAnswerOptionId(params, { answers: { [question]: ['Reset konfiguracji'] } }),
    'option_1',
  );
});

test('questionAnswerOptionId refuses free text, skip and malformed input', () => {
  const question = 'Pick one';
  const params = {
    toolCall: { rawInput: { question, options: ['Yes, auto-accept edits', 'No, keep planning'] } },
    options: [
      { optionId: 'option_0', name: 'Yes, auto-accept edits: go' },
      { optionId: 'option_1', name: 'No, keep planning: stop' },
    ],
  };

  // Free text that is not one of the labels must not fabricate a selection.
  assert.equal(questionAnswerOptionId(params, { answers: { [question]: 'something else' } }), null);
  assert.equal(questionAnswerOptionId(params, { answers: { [question]: '' } }), null);
  assert.equal(questionAnswerOptionId(params, { answers: {} }), null);
  assert.equal(questionAnswerOptionId(params, {}), null);
});

test('commandcode MCP provider round-trips stdio/http servers across scopes', { concurrency: false }, async () => {
  const tempRoot = await fs.mkdtemp(path.join(os.tmpdir(), 'llm-mcp-commandcode-'));
  const workspacePath = path.join(tempRoot, 'workspace');
  await fs.mkdir(workspacePath, { recursive: true });
  const restoreHomeDir = patchHomeDir(tempRoot);
  try {
    const provider = new CommandCodeMcpProvider();

    await provider.upsertServer({
      name: 'echo',
      scope: 'project',
      transport: 'stdio',
      command: 'npx',
      args: ['echo-server'],
      workspacePath,
    });
    await provider.upsertServer({
      name: 'remote',
      scope: 'user',
      transport: 'http',
      url: 'https://example.com/mcp',
      workspacePath,
    });

    // project scope lands in the shared <workspace>/.mcp.json convention.
    const projectConfig = await readJson(path.join(workspacePath, '.mcp.json'));
    const echo = (projectConfig.mcpServers as Record<string, any>).echo;
    assert.equal(echo.transport, 'stdio');
    assert.equal(echo.command, 'npx');

    // user scope lands in ~/.commandcode/mcp.json.
    const userConfig = await readJson(path.join(tempRoot, '.commandcode', 'mcp.json'));
    const remote = (userConfig.mcpServers as Record<string, any>).remote;
    assert.equal(remote.transport, 'http');
    assert.equal(remote.url, 'https://example.com/mcp');

    // local scope lands in the per-project folder under ~/.commandcode/projects.
    await provider.upsertServer({
      name: 'local-one',
      scope: 'local',
      transport: 'stdio',
      command: 'local-bin',
      workspacePath,
    });
    const localConfig = await readJson(
      path.join(tempRoot, '.commandcode', 'projects', commandCodeProjectSlug(workspacePath), 'mcp.json'),
    );
    assert.ok((localConfig.mcpServers as Record<string, any>)['local-one']);

    const scoped = await provider.listServers({ workspacePath });
    assert.ok(scoped.project.some((s) => s.name === 'echo'));
    assert.ok(scoped.user.some((s) => s.name === 'remote'));
    assert.ok(scoped.local.some((s) => s.name === 'local-one'));

    // sse is not a transport this CLI accepts (ACP reports http only).
    await assert.rejects(
      provider.upsertServer({
        name: 'bad',
        scope: 'project',
        transport: 'sse',
        url: 'https://example.com/sse',
        workspacePath,
      }),
    );
  } finally {
    restoreHomeDir();
    await fs.rm(tempRoot, { recursive: true, force: true });
  }
});

test('resolveCommandCodePlanReviewContent returns the newest plan written since process start', async () => {
  const tempRoot = await fs.mkdtemp(path.join(os.tmpdir(), 'cc-plans-'));
  const plansDir = path.join(tempRoot, '.commandcode', 'plans');
  await fs.mkdir(plansDir, { recursive: true });
  try {
    const processStartedAt = Date.now() - 60_000;
    const stale = path.join(plansDir, 'stale.md');
    const older = path.join(plansDir, 'older.md');
    const newest = path.join(plansDir, 'newest.md');
    const notMd = path.join(plansDir, 'notes.txt');
    await fs.writeFile(stale, '# stale plan');
    await fs.writeFile(older, '# older plan');
    await fs.writeFile(newest, '  # newest plan\n\n- step 1\n');
    await fs.writeFile(notMd, '# not a plan');
    const at = new Date();
    await fs.utimes(stale, at, new Date(processStartedAt - 1000)); // before start → ignored
    await fs.utimes(older, at, new Date(processStartedAt + 1000));
    await fs.utimes(newest, at, new Date(processStartedAt + 2000));
    await fs.utimes(notMd, at, new Date(processStartedAt + 3000)); // newest but not .md

    const resolved = resolveCommandCodePlanReviewContent({ plansDir, processStartedAt });
    assert.equal(resolved?.planFilePath, newest);
    assert.equal(resolved?.planContent, '# newest plan\n\n- step 1');
  } finally {
    await fs.rm(tempRoot, { recursive: true, force: true });
  }
});

test('resolveCommandCodePlanReviewContent returns null without a qualifying plan', async () => {
  const tempRoot = await fs.mkdtemp(path.join(os.tmpdir(), 'cc-plans-'));
  try {
    // Missing directory and missing state fields both resolve to null.
    assert.equal(
      resolveCommandCodePlanReviewContent({ plansDir: path.join(tempRoot, 'nope'), processStartedAt: 0 }),
      null,
    );
    assert.equal(resolveCommandCodePlanReviewContent({}), null);

    // A plan older than the session is not this session's plan to review.
    const plansDir = path.join(tempRoot, 'plans');
    await fs.mkdir(plansDir, { recursive: true });
    const stale = path.join(plansDir, 'stale.md');
    await fs.writeFile(stale, '# old');
    const oldTime = new Date(Date.now() - 120_000);
    await fs.utimes(stale, oldTime, oldTime);
    assert.equal(
      resolveCommandCodePlanReviewContent({ plansDir, processStartedAt: Date.now() - 60_000 }),
      null,
    );
  } finally {
    await fs.rm(tempRoot, { recursive: true, force: true });
  }
});

test('questionAnswerOptionId cancels a multi-select pick instead of keeping only the first label', () => {
  const question = 'Which areas?';
  const params = {
    toolCall: { title: question, rawInput: { question, options: ['API', 'UI', 'Docs'], multiple: true } },
    options: [
      { optionId: 'option_0', name: 'API' },
      { optionId: 'option_1', name: 'UI' },
      { optionId: 'option_2', name: 'Docs' },
    ],
  };

  assert.equal(questionAnswerOptionId(params, { answers: { [question]: 'API, Docs' } }), null);
  assert.equal(questionAnswerOptionId(params, { answers: { [question]: ['API', 'UI'] } }), null);
  assert.equal(questionAnswerOptionId(params, { answers: { [question]: 'UI' } }), 'option_1');
});

test('Command Code history flags a tool result that reports a non-zero exit code', () => {
  const provider = new CommandCodeSessionsProvider();
  const resultFor = (text: string) => provider.normalizeMessage({
    type: 'message', id: 'm1', timestamp: '2026-10-07T10:00:00Z',
    message: { role: 'user', content: [{ type: 'tool_result', tool_use_id: 't1', content: [{ type: 'text', text }] }] },
  }, 'app').find((message) => message.kind === 'tool_result');

  assert.equal(resultFor('Exit code: 2\n\nnpm ERR!')?.isError, true);
  assert.equal(resultFor('Exit code: 0\n\nok')?.isError, false);
  assert.equal(resultFor('total 12\n-rw-r--r-- a.ts')?.isError, false);
});

test('acceptEdits auto-approves only ACP edit kinds, never shell titles that mention files', () => {
  assert.equal(isEditPermissionRequest({ toolCall: { kind: 'edit', title: 'Edit: a.ts' } }), true);
  assert.equal(isEditPermissionRequest({ toolCall: { kind: 'execute', title: 'Shell: rm -rf ./profile' } }), false);
  assert.equal(isEditPermissionRequest({ toolCall: { kind: 'execute', title: 'kubectl apply -f file.yaml' } }), false);
  assert.equal(isEditPermissionRequest({ toolCall: { title: 'Write file' } }), false);
});

test('live ACP tool titles map onto the raw tool names history uses', () => {
  assert.equal(commandCodeToolNameFromAcp('Edit: src/a.ts', { file_path: 'src/a.ts' }), 'edit_file');
  assert.equal(commandCodeToolNameFromAcp('Shell: npm test', { command: 'npm test' }), 'shell_command');
  assert.equal(commandCodeToolNameFromAcp('Read: *.ts', { include: '*.ts' }), 'read_multiple_files');
  assert.equal(commandCodeToolNameFromAcp('Search: acp', { query: 'acp' }), 'web_search');
  assert.equal(commandCodeToolNameFromAcp('Search: acp', { pattern: 'acp' }), 'grep');
  assert.equal(commandCodeToolNameFromAcp('Updating todos', {}), 'todo_write');
  assert.equal(commandCodeToolNameFromAcp('enter_plan_mode', {}), 'enter_plan_mode');
  assert.equal(commandCodeToolNameFromAcp(undefined, {}), 'Tool');
});

test('Command Code history hides injected continuation prompts and marks notices', () => {
  const provider = new CommandCodeSessionsProvider();
  const userRow = (text: string) => provider.normalizeMessage({
    type: 'message', id: 'u1', timestamp: '2026-10-07T10:00:00Z',
    message: { role: 'user', content: [{ type: 'text', text }] },
  }, 'app');

  assert.deepEqual(userRow(COMMAND_CODE_CONTINUATION_PROMPT), []);
  assert.deepEqual(userRow('There are 3 unfinished Task Master task(s). Use mcp_call_tool ...'), []);
  assert.equal(userRow('real question').length, 1);

  const [notice] = provider.normalizeMessage({ type: 'custom_message', id: 'c1', content: 'hook output' }, 'app');
  assert.equal(notice?.kind, 'status');
  assert.equal(notice?.notice, true);
});
