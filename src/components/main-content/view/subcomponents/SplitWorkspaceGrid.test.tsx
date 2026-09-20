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
