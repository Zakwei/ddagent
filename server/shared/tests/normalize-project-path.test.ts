import assert from 'node:assert/strict';
import test from 'node:test';

import { normalizeProjectPath } from '@/shared/utils.js';

test('normalizeProjectPath uppercases Windows drive letters', () => {
  assert.equal(normalizeProjectPath('c:\\proj'), 'C:\\proj');
  assert.equal(normalizeProjectPath('c:/proj/'), normalizeProjectPath('C:\\proj'));
  assert.equal(normalizeProjectPath('\\\\?\\c:\\proj'), 'C:\\proj');
  assert.equal(normalizeProjectPath('/c:/proj'), '/c:/proj');
});
