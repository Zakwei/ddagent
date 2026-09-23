import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  buildSharedContextPrefix,
  readSharedContext,
  sharedContextPath,
  writeSharedContext,
} from '@/modules/shared-context/shared-context.service.js';

async function withTempDir(run: (dir: string) => Promise<void>): Promise<void> {
  const dir = await mkdtemp(path.join(tmpdir(), 'shared-context-'));
  try {
    await run(dir);
  } finally {
    await rm(dir, { recursive: true, force: true });
  }
}

test('readSharedContext returns null when the file does not exist', async () => {
  await withTempDir(async (dir) => {
    assert.equal(await readSharedContext(dir), null);
    assert.equal(await buildSharedContextPrefix(dir), null);
  });
});

test('writeSharedContext then readSharedContext round-trips content', async () => {
  await withTempDir(async (dir) => {
    const written = await writeSharedContext(dir, '# Conventions\nUse pnpm.');
    assert.equal(written.content, '# Conventions\nUse pnpm.');
    assert.ok(written.updatedAt);

    const read = await readSharedContext(dir);
    assert.equal(read?.content, '# Conventions\nUse pnpm.');
    assert.equal(sharedContextPath(dir), path.join(dir, '.ddagent', 'shared-context.md'));
  });
});

test('writeSharedContext rejects documents over 50KB', async () => {
  await withTempDir(async (dir) => {
    await assert.rejects(
      writeSharedContext(dir, 'x'.repeat(51 * 1024)),
      (error: unknown) =>
        error instanceof Error && 'statusCode' in error && error.statusCode === 413,
    );
  });
});

test('buildSharedContextPrefix wraps the file content and ends before the message', async () => {
  await withTempDir(async (dir) => {
    await writeSharedContext(dir, 'Agents share this.');
    const prefix = await buildSharedContextPrefix(dir);
    assert.ok(prefix?.includes('Agents share this.'));
    assert.ok(prefix?.endsWith('---\n\n'));
  });
});
