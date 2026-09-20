import assert from 'node:assert/strict';
import test from 'node:test';

import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';

import SplitOverviewDialog, { type SplitOverviewPaneInfo } from './SplitOverviewDialog';

const noop = () => {};

const panes: SplitOverviewPaneInfo[] = [
  { id: 'c1', kind: 'chat', title: 'FIX LOGIN', action: 'question', subtitle: 'Project One' },
  { id: 'b1', kind: 'browser', title: 'Browser', action: 'idle', subtitle: 'example.com' },
  { id: 't1', kind: 'terminal', title: 'Terminal', action: 'processing' },
];

test('renders nothing when closed', () => {
  const html = renderToStaticMarkup(
    React.createElement(SplitOverviewDialog, {
      open: false,
      onClose: noop,
      panes,
      onSelectPane: noop,
    }),
  );
  assert.equal(html, '');
});

test('renders a modal dialog with every pane title', () => {
  const html = renderToStaticMarkup(
    React.createElement(SplitOverviewDialog, {
      open: true,
      onClose: noop,
      panes,
      onSelectPane: noop,
    }),
  );

  assert.ok(html.includes('role="dialog"'));
  assert.ok(html.includes('aria-modal="true"'));
  assert.ok(html.includes('FIX LOGIN'));
  assert.ok(html.includes('Browser'));
  assert.ok(html.includes('Terminal'));
  assert.ok(html.includes('example.com'));
  assert.ok(html.includes('Project One'));
});

test('flags a pane waiting for input as a question', () => {
  const html = renderToStaticMarkup(
    React.createElement(SplitOverviewDialog, {
      open: true,
      onClose: noop,
      panes: [panes[0]],
      onSelectPane: noop,
    }),
  );

  assert.ok(html.includes('QUESTION — input required'));
  assert.ok(!html.includes('PROCESSING'));
});

test('flags a running pane as processing and leaves idle panes unbadged', () => {
  const processing = renderToStaticMarkup(
    React.createElement(SplitOverviewDialog, {
      open: true,
      onClose: noop,
      panes: [panes[2]],
      onSelectPane: noop,
    }),
  );
  assert.ok(processing.includes('PROCESSING'));
  assert.ok(!processing.includes('QUESTION — input required'));

  const idle = renderToStaticMarkup(
    React.createElement(SplitOverviewDialog, {
      open: true,
      onClose: noop,
      panes: [panes[1]],
      onSelectPane: noop,
    }),
  );
  assert.ok(!idle.includes('PROCESSING'));
  assert.ok(!idle.includes('QUESTION — input required'));
});

test('renders one selectable button per pane', () => {
  const html = renderToStaticMarkup(
    React.createElement(SplitOverviewDialog, {
      open: true,
      onClose: noop,
      panes,
      onSelectPane: noop,
    }),
  );

  assert.equal((html.match(/<button/g) ?? []).length, 4);
});

test('handles an empty pane list', () => {
  assert.doesNotThrow(() => {
    renderToStaticMarkup(
      React.createElement(SplitOverviewDialog, {
        open: true,
        onClose: noop,
        panes: [],
        onSelectPane: noop,
      }),
    );
  });
});
