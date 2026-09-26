import assert from 'node:assert/strict';
import test from 'node:test';

import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';

import type { SplitPane } from '../utils/splitWorkspace';
import {
  cleanupMaximizedPaneId,
  shouldRestoreMaximizedOnEscape,
  toggleMaximizedPaneId,
} from '../utils/splitWorkspace';

import { useSplitWorkspace } from './useSplitWorkspace';

test('useSplitWorkspace hook initializes with null maximizedPaneId and provides controls', () => {
  let hookValue: ReturnType<typeof useSplitWorkspace> | null = null;
  const initialPanes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'browser' },
  ];

  function TestHarness() {
    hookValue = useSplitWorkspace({ initialPanes });
    return null;
  }

  renderToStaticMarkup(React.createElement(TestHarness));

  assert.ok(hookValue !== null);
  const hook = hookValue as unknown as ReturnType<typeof useSplitWorkspace>;
  assert.equal(hook.maximizedPaneId, null);
  assert.equal(typeof hook.setMaximizedPaneId, 'function');
  assert.equal(hook.panes.length, 2);
  assert.deepEqual(hook.layout, { columns: 2, rows: 1 });
});

test('toggleMaximizedPaneId toggles maximization and restores normal grid view', () => {
  let maximizedId: string | null = null;

  // Maximize p1
  maximizedId = toggleMaximizedPaneId(maximizedId, 'p1');
  assert.equal(maximizedId, 'p1');

  // Switching to p2 maximizes p2
  maximizedId = toggleMaximizedPaneId(maximizedId, 'p2');
  assert.equal(maximizedId, 'p2');

  // Toggling the already maximized p2 restores normal grid view (null)
  maximizedId = toggleMaximizedPaneId(maximizedId, 'p2');
  assert.equal(maximizedId, null);
});

test('cleanupMaximizedPaneId resets maximized state to null when pane disappears', () => {
  const panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'browser' },
  ];

  // Active pane exists in panes list -> stays maximized
  assert.equal(cleanupMaximizedPaneId('p1', panes), 'p1');

  // Removing non-maximized p2 leaves p1 maximized
  const withoutP2 = panes.filter((p) => p.id !== 'p2');
  assert.equal(cleanupMaximizedPaneId('p1', withoutP2), 'p1');

  // Removing maximized p1 resets to null
  const withoutP1 = panes.filter((p) => p.id !== 'p1');
  assert.equal(cleanupMaximizedPaneId('p1', withoutP1), null);

  // Stale pane id not in list cleans up to null
  assert.equal(cleanupMaximizedPaneId('unknown-pane', panes), null);

  // null stays null
  assert.equal(cleanupMaximizedPaneId(null, panes), null);
});

test('shouldRestoreMaximizedOnEscape obeys defaultPrevented and modal dialog guards', () => {
  // Unhandled Escape when no modal is open -> restores layout
  assert.equal(
    shouldRestoreMaximizedOnEscape({ key: 'Escape' }, false),
    true,
  );

  // When a subcomponent (e.g. ActionMenu or ReviewFilesPanel) calls preventDefault(),
  // Escape does NOT trigger layout restore
  assert.equal(
    shouldRestoreMaximizedOnEscape({ key: 'Escape', defaultPrevented: true }, false),
    false,
  );

  // When a modal dialog is open, Escape does NOT trigger layout restore
  assert.equal(
    shouldRestoreMaximizedOnEscape({ key: 'Escape', defaultPrevented: false }, true),
    false,
  );

  // Non-Escape keys do NOT trigger layout restore
  assert.equal(
    shouldRestoreMaximizedOnEscape({ key: 'Enter' }, false),
    false,
  );
  assert.equal(
    shouldRestoreMaximizedOnEscape({ key: 'Tab' }, false),
    false,
  );
});
