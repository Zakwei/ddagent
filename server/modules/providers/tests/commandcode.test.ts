import assert from 'node:assert/strict';
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { CommandCodeMcpProvider } from '@/modules/providers/list/commandcode/commandcode-mcp.provider.js';
import { parseCommandCodeModelList } from '@/modules/providers/list/commandcode/commandcode-models.provider.js';
import { readCommandCodeTranscript } from '@/modules/providers/list/commandcode/commandcode-sessions.provider.js';
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
