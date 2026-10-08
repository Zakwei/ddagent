import assert from 'node:assert/strict';
import test from 'node:test';

import { generateDisplayName } from '@/modules/projects/services/projects-with-sessions-fetch.service.js';

test('generateDisplayName shortens POSIX and Windows paths to the folder name', async () => {
  // Non-existent dirs, so no package.json is read and the path fallback is used.
  assert.equal(await generateDisplayName('x', '/nonexistent-ddagent/home/u/proj'), 'proj');
  assert.equal(await generateDisplayName('x', 'C:\\nonexistent-ddagent\\Users\\u\\proj'), 'proj');
  assert.equal(await generateDisplayName('x', 'C:/nonexistent-ddagent/Users/u/proj/'), 'proj');
  assert.equal(await generateDisplayName('x', 'C:\\'), 'C:\\');
});
