import assert from 'node:assert/strict';
import test from 'node:test';

import { sanitizeWorkspaceState, type WorkspaceState } from './workspacePanes';
import { createWorkspaceSyncController } from './workspaceSync';

const LOCAL: WorkspaceState = {
  panes: [{ id: 'p1', kind: 'chat', sessionId: 's1', projectId: 'proj-1' }],
  activePaneId: 'p1',
  lastUsedProjectId: 'proj-1',
};

const REMOTE: WorkspaceState = {
  panes: [
    { id: 'p9', kind: 'chat', sessionId: 's9' },
    { id: 'p8', kind: 'terminal', projectId: 'proj-2' },
  ],
  activePaneId: 'p8',
  lastUsedProjectId: 'proj-2',
};

function harness(initial: WorkspaceState = LOCAL) {
  const sent: Array<Record<string, unknown>> = [];
  let applied: WorkspaceState | null = null;
  let current = initial;
  let sendOk = true;

  const controller = createWorkspaceSyncController({
    deviceId: 'dev-test',
    getState: () => current,
    applyRemote: (next) => {
      applied = next;
      current = next;
    },
    send: (message) => {
      if (sendOk) sent.push(message as Record<string, unknown>);
      return sendOk;
    },
  });

  return {
    controller,
    sent,
    get applied() {
      return applied;
    },
    setState(next: WorkspaceState) {
      current = next;
    },
    failSend() {
      sendOk = false;
    },
    restoreSend() {
      sendOk = true;
    },
  };
}

test('requestSnapshot sends workspace.get with the device id', () => {
  const h = harness();
  h.controller.requestSnapshot();
  assert.deepEqual(h.sent, [{ type: 'workspace.get', deviceId: 'dev-test' }]);
});

test('remote workspace_state applies the sanitized state and records it as synced', () => {
  const h = harness();
  h.controller.handleFrame({ kind: 'workspace_state', state: REMOTE, revision: 3 });

  // sanitizePane fills absent sessionId/projectId/url with null.
  assert.deepEqual(h.applied, sanitizeWorkspaceState(REMOTE));

  // Applying must not echo back — the local watcher now sees state equal to
  // lastSynced and stays silent.
  h.controller.pushLocal();
  assert.equal(h.sent.length, 0);
});

test('local change pushes one workspace.update; unchanged state stays silent', () => {
  const h = harness();

  h.controller.pushLocal(); // state == boot state → no-op
  assert.equal(h.sent.length, 0);

  h.setState(REMOTE);
  h.controller.pushLocal();
  assert.equal(h.sent.length, 1);
  assert.equal(h.sent[0].type, 'workspace.update');
  assert.deepEqual(h.sent[0].state, REMOTE);
});

test('empty server reply seeds it with the local workspace', () => {
  const h = harness();
  h.controller.handleFrame({ kind: 'workspace_state', state: null, revision: 0 });

  assert.equal(h.sent.length, 1);
  assert.equal(h.sent[0].type, 'workspace.update');
  assert.deepEqual(h.sent[0].state, LOCAL);
});

test('unsent local edits win over an incoming remote state (dirty LWW tie-break)', () => {
  const h = harness();
  h.setState(REMOTE);
  h.failSend();
  h.controller.pushLocal(); // socket down → dirty, nothing sent
  h.restoreSend();

  h.controller.handleFrame({ kind: 'workspace_state', state: LOCAL, revision: 5 });

  // Remote was NOT applied; our dirty local state was pushed instead.
  assert.equal(h.applied, null);
  assert.equal(h.sent.length, 1);
  assert.equal(h.sent[0].type, 'workspace.update');
  assert.deepEqual(h.sent[0].state, REMOTE);
  assert.equal(h.controller.dirty, false);
});

test('unrelated frames are ignored', () => {
  const h = harness();
  h.controller.handleFrame({ kind: 'stream_delta', sessionId: 'x' });
  h.controller.handleFrame({ type: 'presence-roster', users: [] });
  assert.equal(h.applied, null);
  assert.equal(h.sent.length, 0);
});
