import assert from 'node:assert/strict';
import test from 'node:test';

import type { ProjectSession } from '../types/app';

import { getSessionTitle } from './pageTitle';

test('uses the session summary as the session title', () => {
  const session: ProjectSession = {
    id: 'session-1',
    summary: 'Fix browser tab title',
    __provider: 'claude',
  };

  assert.equal(getSessionTitle(session), 'Fix browser tab title');
});

test('uses the session name for Cursor sessions', () => {
  const session: ProjectSession = {
    id: 'session-1',
    name: 'Cursor session name',
    __provider: 'cursor',
  };

  assert.equal(getSessionTitle(session), 'Cursor session name');
});

test('falls back to a placeholder when the session has no title', () => {
  const session: ProjectSession = {
    id: 'session-1',
    __provider: 'claude',
  };

  assert.equal(getSessionTitle(session), 'New Session');
});
