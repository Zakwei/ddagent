import assert from 'node:assert/strict';
import { mkdtemp, rm, writeFile } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { AppError, readJsonConfig } from '@/shared/utils.js';

async function withTempDir(run: (dir: string) => Promise<void>): Promise<void> {
  const dir = await mkdtemp(path.join(tmpdir(), 'read-json-config-'));
  try {
    await run(dir);
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
}

test('missing file returns an empty config', async () => {
  await withTempDir(async (dir) => {
    assert.deepEqual(await readJsonConfig(path.join(dir, 'absent.json')), {});
  });
});

test('empty or whitespace-only file returns an empty config', async () => {
  await withTempDir(async (dir) => {
    for (const content of ['', '   \n  ']) {
      const file = path.join(dir, 'empty.json');
      await writeFile(file, content, 'utf8');
      assert.deepEqual(await readJsonConfig(file), {}, `content=${JSON.stringify(content)}`);
    }
  });
});

test('valid JSON returns the parsed object', async () => {
  await withTempDir(async (dir) => {
    const file = path.join(dir, 'ok.json');
    await writeFile(file, '{"mcpServers": {"a": {}}}\n', 'utf8');
    assert.deepEqual(await readJsonConfig(file), { mcpServers: { a: {} } });
  });
});

test('malformed JSON throws an AppError naming the file', async () => {
  await withTempDir(async (dir) => {
    const file = path.join(dir, 'broken.json');
    await writeFile(file, '{"mcpServers": ', 'utf8');
    const error = await readJsonConfig(file).then(
      () => null,
      (err) => err,
    );
    assert.ok(error instanceof AppError);
    assert.equal((error as AppError).code, 'INVALID_JSON_CONFIG');
    assert.match((error as Error).message, new RegExp(file.replace(/[\\/]/g, '.')));
  });
});
