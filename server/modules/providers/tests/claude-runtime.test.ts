import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import path from 'node:path';
import test from 'node:test';
import { fileURLToPath } from 'node:url';

import { mapCliOptionsToSDK } from '@/modules/providers/list/claude/claude-runtime.provider.js';

test('claude: SDK options enable partial messages so deltas can stream live', () => {
  // The mapper lives in a JavaScript file, so its option bag is typed loosely.
  const sdkOptions = mapCliOptionsToSDK({
    providerSessionId: 'provider-session-1',
    cwd: '/tmp/project',
    model: 'claude-sonnet-4-5',
  }) as Record<string, unknown>;

  // Without this option the SDK never emits `stream_event` wrappers, which is
  // what the live text/thinking frames are built from.
  assert.equal(sdkOptions.includePartialMessages, true);
  // The streaming switch must not disturb the options a run already relies on.
  assert.equal(sdkOptions.resume, 'provider-session-1');
  assert.equal(sdkOptions.cwd, '/tmp/project');
  assert.equal(sdkOptions.model, 'claude-sonnet-4-5');
});

test('claude: includePartialMessages is an option the installed SDK declares', async () => {
  // The SDK maps this option onto the CLI's partial-message flag; a rename in a
  // future SDK version would silently kill live streaming, so the exact option
  // name is pinned against the installed type declarations.
  const sdkEntryUrl = import.meta.resolve('@anthropic-ai/claude-agent-sdk');
  const sdkEntryPath = fileURLToPath(sdkEntryUrl);
  const sdkTypesPath = sdkEntryPath.endsWith('.d.ts')
    ? sdkEntryPath
    : path.join(path.dirname(sdkEntryPath), 'sdk.d.ts');
  const types = await readFile(sdkTypesPath, 'utf8');

  assert.match(types, /includePartialMessages\?: boolean/);
});
