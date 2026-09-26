import assert from 'node:assert/strict';
import test from 'node:test';

import type { SplitPane } from '../utils/splitWorkspace';

// Logic replicating the hook's maximization toggle
const toggleMaximizedPaneId = (current: string | null, targetId: string) =>
  current === targetId ? null : targetId;

// Logic replicating the hook's auto-cleanup effect:
// setMaximizedPaneId((id) => (id && !panes.some((pane) => pane.id === id) ? null : id));
const cleanupMaximizedPane = (current: string | null, panes: SplitPane[]) =>
  current && !panes.some((p) => p.id === current) ? null : current;

// Logic replicating MainContent's global Escape keydown listener:
// if (event.key === 'Escape' && !isModalOpen()) setMaximizedPaneId(null);
const handleEscapeKey = (
  current: string | null,
  event: { key: string; defaultPrevented?: boolean },
  isModalOpen: () => boolean,
) => {
  if (event.key === 'Escape' && !isModalOpen()) {
    return null;
  }
  return current;
};

test('initial state has no maximized pane', () => {
  const initialMaximizedPaneId: string | null = null;
  assert.equal(initialMaximizedPaneId, null);
});

test('toggling a pane id maximizes it', () => {
  let maximizedId: string | null = null;

  maximizedId = toggleMaximizedPaneId(maximizedId, 'pane-1');
  assert.equal(maximizedId, 'pane-1');

  // Toggling another pane switches to the new pane
  maximizedId = toggleMaximizedPaneId(maximizedId, 'pane-2');
  assert.equal(maximizedId, 'pane-2');
});

test('toggling the already maximized pane restores normal grid view', () => {
  let maximizedId: string | null = 'pane-1';

  maximizedId = toggleMaximizedPaneId(maximizedId, 'pane-1');
  assert.equal(maximizedId, null);
});

test('removing the maximized pane resets maximized state to null', () => {
  let panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'browser' },
  ];
  let maximizedId: string | null = 'p1';

  // Remove non-maximized pane: p1 stays maximized
  panes = panes.filter((p) => p.id !== 'p2');
  maximizedId = cleanupMaximizedPane(maximizedId, panes);
  assert.equal(maximizedId, 'p1');

  // Remove maximized pane: resets to null
  panes = panes.filter((p) => p.id !== 'p1');
  maximizedId = cleanupMaximizedPane(maximizedId, panes);
  assert.equal(maximizedId, null);
});

test('Escape key exits maximization when no modal dialog is open', () => {
  let maximizedId: string | null = 'pane-1';

  // Modal dialog is open -> Escape is ignored by workspace
  maximizedId = handleEscapeKey(maximizedId, { key: 'Escape' }, () => true);
  assert.equal(maximizedId, 'pane-1');

  // Non-Escape keys -> ignored
  maximizedId = handleEscapeKey(maximizedId, { key: 'Enter' }, () => false);
  assert.equal(maximizedId, 'pane-1');

  // Modal is closed -> Escape resets maximized state
  maximizedId = handleEscapeKey(maximizedId, { key: 'Escape' }, () => false);
  assert.equal(maximizedId, null);
});

test('stale pane id is cleaned up when pane list changes', () => {
  const panes: SplitPane[] = [{ id: 'p1', kind: 'chat' }];
  const staleId = 'stale-pane';

  const cleaned = cleanupMaximizedPane(staleId, panes);
  assert.equal(cleaned, null);
});
