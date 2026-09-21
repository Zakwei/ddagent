import assert from 'node:assert/strict';
import test from 'node:test';

import type { ProjectSession } from '../types/app';

import { getSessionTitle, getTabTitle } from './pageTitle';

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

test('shows the running session count in the tab title', () => {
  assert.equal(getTabTitle(3, 'ddagent'), '● 3 · ddagent');
});

test('keeps the bare tab title when nothing is running', () => {
  assert.equal(getTabTitle(0, 'ddagent'), 'ddagent');
});

test('preserves alert prefixes while updating the count', () => {
  assert.equal(getTabTitle(1, '✓ Done! ddagent'), '✓ Done! ● 1 · ddagent');
  assert.equal(getTabTitle(0, '[Done] ● 2 · ddagent'), '[Done] ddagent');
});
