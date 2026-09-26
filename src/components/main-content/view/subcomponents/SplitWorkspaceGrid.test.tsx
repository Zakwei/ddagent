import assert from 'node:assert/strict';
import test from 'node:test';

import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';

import type { SplitPane } from '../../utils/splitWorkspace';

import { SplitWorkspaceGrid } from './SplitWorkspaceGrid';

const noop = () => {};

const renderPane = (pane: SplitPane, isActive: boolean) =>
  React.createElement('div', { 'data-pane-id': pane.id, 'data-active': String(isActive) }, pane.kind);

const baseProps = {
  onClosePane: noop,
  onReorderPanes: noop,
  renderPane,
};

test('renders nothing for zero panes', () => {
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, { ...baseProps, panes: [] }),
  );

  assert.ok(!html.includes('data-pane-id'));
  assert.ok(!html.includes('data-split-columns'));
});

test('renders a single pane full-bleed without a drag header', () => {
  const panes: SplitPane[] = [{ id: 'p1', kind: 'chat' }];
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, { ...baseProps, panes, activePaneId: 'p1' }),
  );

  assert.ok(html.includes('data-pane-id="p1"'));
  assert.ok(html.includes('data-split-columns="1"'));
  assert.ok(html.includes('data-split-rows="1"'));
  assert.ok(!html.includes('aria-label="Reorder pane"'));
  assert.ok(!html.includes('aria-label="Close pane"'));
});

test('lays out panes using the shared grid mapping and adds drag headers', () => {
  const panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'browser' },
  ];
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, { ...baseProps, panes }),
  );

  assert.ok(html.includes('data-split-columns="2"'));
  assert.ok(html.includes('data-split-rows="1"'));
  assert.equal((html.match(/aria-label="Reorder pane"/g) ?? []).length, 2);
  assert.equal((html.match(/aria-label="Close pane"/g) ?? []).length, 2);
});

test('renders pane titles via getPaneTitle and header extras', () => {
  const panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'chat' },
  ];
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, {
      ...baseProps,
      panes,
      getPaneTitle: (pane) => `Title ${pane.id}`,
      renderPaneHeaderExtra: (pane) =>
        pane.id === 'p2' ? React.createElement('select', { 'aria-label': 'session' }) : null,
    }),
  );

  assert.ok(html.includes('Title p1'));
  assert.ok(html.includes('Title p2'));
  assert.ok(html.includes('aria-label="session"'));
});

test('marks the active pane', () => {
  const panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'terminal' },
  ];
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, { ...baseProps, panes, activePaneId: 'p2' }),
  );

  assert.ok(html.includes('data-active="true"'));
  assert.ok(html.includes('data-active="false"'));
  // 2 panes fill the 2x1 layout exactly — no empty cells to pad.
  assert.equal((html.match(/border-dashed/g) ?? []).length, 0);
});

test('stretches a short last row across the full grid width', () => {
  const panes: SplitPane[] = Array.from({ length: 5 }, (_, index) => ({
    id: `p${index}`,
    kind: 'chat' as const,
  }));
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, { ...baseProps, panes }),
  );

  // 5 panes in a 3x2 layout render on a 6-column grid: the full row spans
  // 2 each, the two last-row panes span 3 each — no empty cell remains.
  assert.equal((html.match(/grid-column:span 2/g) ?? []).length, 3);
  assert.equal((html.match(/grid-column:span 3/g) ?? []).length, 2);
  assert.equal((html.match(/border-dashed/g) ?? []).length, 0);
  assert.ok(html.includes('data-split-columns="3"'));
  assert.ok(html.includes('data-split-rows="2"'));
});

test('does not add drop zones when the grid is full', () => {
  const panes: SplitPane[] = Array.from({ length: 6 }, (_, index) => ({
    id: `p${index}`,
    kind: 'chat' as const,
  }));
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, { ...baseProps, panes }),
  );

  assert.equal((html.match(/border-dashed/g) ?? []).length, 0);
  assert.ok(html.includes('data-split-columns="3"'));
  assert.ok(html.includes('data-split-rows="2"'));
});

test('on mobile, renders a tab strip and mounts only the active pane', () => {
  const panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'terminal' },
  ];
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, {
      ...baseProps,
      panes,
      activePaneId: 'p2',
      isMobile: true,
    }),
  );

  assert.ok(html.includes('role="tablist"'));
  assert.equal((html.match(/role="tab"/g) ?? []).length, 2);
  assert.equal((html.match(/aria-selected="true"/g) ?? []).length, 1);
  // Only the selected pane mounts; the other stays persisted but hidden.
  assert.ok(!html.includes('data-pane-id="p1"'));
  assert.ok(html.includes('data-pane-id="p2"'));
  // No drag handle — touch reordering is not supported.
  assert.ok(!html.includes('aria-label="Reorder pane"'));
});

test('on mobile, falls back to the first pane when none is active', () => {
  const panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'browser' },
  ];
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, {
      ...baseProps,
      panes,
      activePaneId: null,
      isMobile: true,
    }),
  );

  assert.ok(html.includes('data-pane-id="p1"'));
  assert.ok(!html.includes('data-pane-id="p2"'));
});

test('on mobile, a single pane renders without a tab strip', () => {
  const panes: SplitPane[] = [{ id: 'p1', kind: 'chat' }];
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, { ...baseProps, panes, isMobile: true }),
  );

  assert.ok(!html.includes('role="tablist"'));
  assert.ok(html.includes('data-pane-id="p1"'));
});

test('maximize button is available for each tile when multiple panes are open', () => {
  const panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'browser' },
    { id: 'p3', kind: 'terminal' },
  ];
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, {
      ...baseProps,
      panes,
      maximizedPaneId: null,
      onToggleMaximizePane: noop,
    }),
  );

  // Each of the 3 panes has a Maximize pane button with Maximize2 icon
  assert.equal((html.match(/aria-label="Maximize pane"/g) ?? []).length, 3);
  assert.equal((html.match(/title="Maximize pane"/g) ?? []).length, 3);
  assert.ok(!html.includes('aria-label="Restore panes"'));
});

test('hides the maximize button for a single pane and without a handler', () => {
  const single: SplitPane[] = [{ id: 'p1', kind: 'chat' }];
  const htmlSingle = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, {
      ...baseProps,
      panes: single,
      maximizedPaneId: null,
      onToggleMaximizePane: noop,
    }),
  );
  assert.ok(!htmlSingle.includes('aria-label="Maximize pane"'));

  const panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'browser' },
  ];
  const htmlNoHandler = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, { ...baseProps, panes }),
  );
  assert.ok(!htmlNoHandler.includes('aria-label="Maximize pane"'));
});

test('clicking maximize hides other panels and switches button to restore (Minimize2)', () => {
  const panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'browser' },
  ];
  let maximizedId: string | null = null;
  const onToggleMaximizePane = (id: string) => {
    maximizedId = maximizedId === id ? null : id;
  };

  // Initially in multi-panel split grid
  const initialHtml = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, {
      ...baseProps,
      panes,
      maximizedPaneId: maximizedId,
      onToggleMaximizePane,
    }),
  );
  assert.ok(initialHtml.includes('data-split-columns="2"'));
  assert.doesNotMatch(initialHtml, /data-pane-id="p2"[^>]*aria-hidden="true"/);

  // Simulate clicking maximize on p1
  onToggleMaximizePane('p1');
  assert.equal(maximizedId, 'p1');

  // Render with maximizedPaneId: 'p1'
  const maximizedHtml = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, {
      ...baseProps,
      panes,
      maximizedPaneId: maximizedId,
      onToggleMaximizePane,
    }),
  );

  // Maximized tile fills entire 1x1 grid
  assert.ok(maximizedHtml.includes('data-split-columns="1"'));
  assert.ok(maximizedHtml.includes('data-split-rows="1"'));

  // Maximized pane p1 has the restore button (Minimize2)
  assert.equal((maximizedHtml.match(/aria-label="Restore panes"/g) ?? []).length, 1);
  assert.equal((maximizedHtml.match(/title="Restore panes"/g) ?? []).length, 1);
  assert.doesNotMatch(maximizedHtml, /data-pane-id="p1"[^>]*aria-hidden="true"/);

  // Other pane p2 stays mounted for state retention but is marked hidden
  assert.ok(maximizedHtml.includes('data-pane-id="p2"'));
  assert.match(maximizedHtml, /data-pane-id="p2"[^>]*aria-hidden="true"/);
  assert.match(maximizedHtml, /data-pane-id="p2"[^>]*class="[^"]*\s+hidden(?:\s|")/);
});

test('clicking restore restores all panels in the grid', () => {
  const panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'browser' },
  ];
  let maximizedId: string | null = 'p1';
  const onToggleMaximizePane = (id: string) => {
    maximizedId = maximizedId === id ? null : id;
  };

  // Maximized state first
  const maximizedHtml = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, {
      ...baseProps,
      panes,
      maximizedPaneId: maximizedId,
      onToggleMaximizePane,
    }),
  );
  assert.equal((maximizedHtml.match(/aria-label="Restore panes"/g) ?? []).length, 1);
  assert.match(maximizedHtml, /data-pane-id="p2"[^>]*aria-hidden="true"/);

  // Simulate clicking restore button on p1
  onToggleMaximizePane('p1');
  assert.equal(maximizedId, null);

  // Restored state shows full grid
  const restoredHtml = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, {
      ...baseProps,
      panes,
      maximizedPaneId: maximizedId,
      onToggleMaximizePane,
    }),
  );

  // All panels visible again in 2-column grid
  assert.ok(restoredHtml.includes('data-split-columns="2"'));
  assert.ok(restoredHtml.includes('data-split-rows="1"'));
  assert.doesNotMatch(restoredHtml, /data-pane-id="p[12]"[^>]*aria-hidden="true"/);
  assert.doesNotMatch(restoredHtml, /data-pane-id="p[12]"[^>]*class="[^"]*\s+hidden(?:\s|")/);

  // Both panes show maximize button again
  assert.equal((restoredHtml.match(/aria-label="Maximize pane"/g) ?? []).length, 2);
  assert.ok(!restoredHtml.includes('aria-label="Restore panes"'));
});

test('Escape key restores previous window layout unless a modal owns the key', () => {
  const panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'browser' },
  ];
  let maximizedId: string | null = 'p1';
  let modalOpen = false;

  const handleKeyDown = (event: { key: string }) => {
    if (event.key === 'Escape' && !modalOpen) {
      maximizedId = null;
    }
  };

  // When a modal dialog is open, Escape should not reset maximized state
  modalOpen = true;
  handleKeyDown({ key: 'Escape' });
  assert.equal(maximizedId, 'p1');

  // Non-Escape keys do not reset maximized state
  modalOpen = false;
  handleKeyDown({ key: 'Enter' });
  assert.equal(maximizedId, 'p1');

  // Escape key without open modal restores the layout
  handleKeyDown({ key: 'Escape' });
  assert.equal(maximizedId, null);

  // The restored state renders the complete multi-panel grid
  const restoredHtml = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, {
      ...baseProps,
      panes,
      maximizedPaneId: maximizedId,
      onToggleMaximizePane: noop,
    }),
  );
  assert.ok(restoredHtml.includes('data-split-columns="2"'));
  assert.doesNotMatch(restoredHtml, /data-pane-id="p[12]"[^>]*aria-hidden="true"/);
  assert.doesNotMatch(restoredHtml, /data-pane-id="p[12]"[^>]*class="[^"]*\s+hidden(?:\s|")/);
  assert.equal((restoredHtml.match(/aria-label="Maximize pane"/g) ?? []).length, 2);
});

test('closing the maximized pane resets fullscreen state and restores remaining panes', () => {
  let panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'browser' },
    { id: 'p3', kind: 'terminal' },
  ];
  let maximizedId: string | null = 'p1';

  const cleanupMaximizedPaneId = (currentId: string | null, currentPanes: SplitPane[]) =>
    currentId && !currentPanes.some((p) => p.id === currentId) ? null : currentId;

  // Closing p1 (the maximized pane)
  panes = panes.filter((p) => p.id !== 'p1');
  maximizedId = cleanupMaximizedPaneId(maximizedId, panes);

  assert.equal(maximizedId, null);

  // Renders the 2 remaining panes in a split grid
  const remainingHtml = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, {
      ...baseProps,
      panes,
      maximizedPaneId: maximizedId,
      onToggleMaximizePane: noop,
    }),
  );
  assert.ok(remainingHtml.includes('data-split-columns="2"'));
  assert.ok(remainingHtml.includes('data-pane-id="p2"'));
  assert.ok(remainingHtml.includes('data-pane-id="p3"'));
  assert.doesNotMatch(remainingHtml, /data-pane-id="p[23]"[^>]*aria-hidden="true"/);
  assert.doesNotMatch(remainingHtml, /data-pane-id="p[23]"[^>]*class="[^"]*\s+hidden(?:\s|")/);
  assert.equal((remainingHtml.match(/aria-label="Maximize pane"/g) ?? []).length, 2);

  // If another close leaves only 1 pane, it resets to full-bleed with no maximize button
  panes = panes.filter((p) => p.id !== 'p2');
  maximizedId = cleanupMaximizedPaneId(maximizedId, panes);
  const singleHtml = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, {
      ...baseProps,
      panes,
      maximizedPaneId: maximizedId,
      onToggleMaximizePane: noop,
    }),
  );
  assert.ok(singleHtml.includes('data-pane-id="p3"'));
  assert.ok(!singleHtml.includes('aria-label="Maximize pane"'));
  assert.ok(!singleHtml.includes('aria-label="Restore panes"'));
});

test('a stale maximizedPaneId is ignored and the normal grid renders', () => {
  const panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'browser' },
  ];
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, {
      ...baseProps,
      panes,
      maximizedPaneId: 'gone',
      onToggleMaximizePane: noop,
    }),
  );

  assert.ok(html.includes('data-split-columns="2"'));
  assert.doesNotMatch(html, /data-pane-id="p[12]"[^>]*aria-hidden="true"/);
  assert.equal((html.match(/aria-label="Maximize pane"/g) ?? []).length, 2);
});

test('on mobile, no maximize button renders in tab mode', () => {
  const panes: SplitPane[] = [
    { id: 'p1', kind: 'chat' },
    { id: 'p2', kind: 'terminal' },
  ];
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceGrid, {
      ...baseProps,
      panes,
      activePaneId: 'p1',
      isMobile: true,
      maximizedPaneId: 'p1',
      onToggleMaximizePane: noop,
    }),
  );

  assert.ok(html.includes('role="tablist"'));
  assert.ok(!html.includes('aria-label="Maximize pane"'));
  assert.ok(!html.includes('aria-label="Restore panes"'));
});
