import assert from 'node:assert/strict';
import test from 'node:test';

import { createWorkspaceSyncService } from '@/modules/websocket/services/workspace-sync.service.js';

class FakeConnection {
  readyState = 1; // WS_OPEN_STATE
  frames: Array<Record<string, unknown>> = [];

  send(data: string): void {
    this.frames.push(JSON.parse(data) as Record<string, unknown>);
  }
}

/** In-memory stand-in for workspaceStateDb so the service test needs no DB. */
function createFakeStore() {
  const rows = new Map<number, { state: unknown; revision: number }>();
  return {
    get(userId: number) {
      return rows.get(userId) ?? null;
    },
    put(userId: number, stateJson: string) {
      const next = (rows.get(userId)?.revision ?? 0) + 1;
      rows.set(userId, { state: JSON.parse(stateJson), revision: next });
      return next;
    },
  };
}

const STATE = { panes: [{ id: 'p1', kind: 'chat', sessionId: 's1' }], activePaneId: 'p1' };

test('workspace.get on empty store replies with null state and revision 0', () => {
  const sync = createWorkspaceSyncService(createFakeStore());
  const ws = new FakeConnection();
  sync.register(ws, 7);

  sync.sendCurrent(ws, 7);

  assert.equal(ws.frames.length, 1);
  assert.deepEqual(ws.frames[0].state, null);
  assert.equal(ws.frames[0].kind, 'workspace_state');
  assert.equal(ws.frames[0].revision, 0);
});

test('workspace.update persists state, bumps revision, and replies nothing to sender', () => {
  const sync = createWorkspaceSyncService(createFakeStore());
  const ws = new FakeConnection();
  sync.register(ws, 7);

  assert.deepEqual(sync.applyUpdate(ws, 7, STATE, 'dev-a'), { ok: true });
  assert.equal(ws.frames.length, 0);

  sync.sendCurrent(ws, 7);
  assert.deepEqual(ws.frames[0].state, STATE);
  assert.equal(ws.frames[0].revision, 1);
});

test('workspace.update broadcasts to other same-user sockets only', () => {
  const sync = createWorkspaceSyncService(createFakeStore());
  const sender = new FakeConnection();
  const sibling = new FakeConnection();
  const otherUser = new FakeConnection();
  const closed = new FakeConnection();
  closed.readyState = 0;

  sync.register(sender, 7);
  sync.register(sibling, 7);
  sync.register(otherUser, 8);
  sync.register(closed, 7);

  sync.applyUpdate(sender, 7, STATE, 'dev-a');

  assert.equal(sender.frames.length, 0);
  assert.equal(sibling.frames.length, 1);
  assert.equal(sibling.frames[0].kind, 'workspace_state');
  assert.equal(sibling.frames[0].originDeviceId, 'dev-a');
  assert.equal(otherUser.frames.length, 0);
  assert.equal(closed.frames.length, 0);
});

test('workspace.update rejects non-object and oversized states without persisting', () => {
  const store = createFakeStore();
  const sync = createWorkspaceSyncService(store);
  const ws = new FakeConnection();
  sync.register(ws, 7);

  assert.equal(sync.applyUpdate(ws, 7, 'nope', null).ok, false);
  assert.equal(sync.applyUpdate(ws, 7, [1, 2], null).ok, false);
  assert.equal(sync.applyUpdate(ws, 7, { blob: 'x'.repeat(70 * 1024) }, null).ok, false);
  assert.equal(store.get(7), null);
});

test('unregister drops the socket from broadcasts', () => {
  const sync = createWorkspaceSyncService(createFakeStore());
  const sender = new FakeConnection();
  const sibling = new FakeConnection();
  sync.register(sender, 7);
  sync.register(sibling, 7);

  sync.unregister(sibling);
  sync.applyUpdate(sender, 7, STATE, null);

  assert.equal(sibling.frames.length, 0);
});
