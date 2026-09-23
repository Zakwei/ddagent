import assert from 'node:assert/strict';
import test from 'node:test';

import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';

import SplitWorkspaceControls from './SplitWorkspaceControls';

const noop = () => {};

const baseProps = {
  open: false,
  onOpenChange: noop,
  canAddPane: true,
  onAddChatPane: noop,
  onAddBrowserPane: noop,
  onAddTerminalPane: noop,
  onAddPreviewPane: noop,
  panes: [],
  onSelectPane: noop,
};

test('renders the add buttons and the overview toggle', () => {
  const html = renderToStaticMarkup(React.createElement(SplitWorkspaceControls, baseProps));

  assert.ok(html.includes('aria-label="Add chat pane"'));
  assert.ok(html.includes('aria-label="Add browser pane"'));
  assert.ok(html.includes('aria-label="Add terminal pane"'));
  assert.ok(html.includes('aria-label="Add preview pane"'));
  assert.ok(html.includes('aria-label="Show all panes"'));
});

test('disables the add buttons when the pane cap is reached', () => {
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceControls, { ...baseProps, canAddPane: false }),
  );

  assert.ok(html.includes('disabled=""'));
  assert.equal((html.match(/disabled=""/g) ?? []).length, 4);
});

test('reflects open state with aria-pressed on the overview toggle', () => {
  const closed = renderToStaticMarkup(React.createElement(SplitWorkspaceControls, baseProps));
  assert.ok(closed.includes('aria-pressed="false"'));

  const open = renderToStaticMarkup(
    React.createElement(SplitWorkspaceControls, { ...baseProps, open: true }),
  );
  assert.ok(open.includes('aria-pressed="true"'));
});

test('mounts the overview dialog only when open', () => {
  const closed = renderToStaticMarkup(React.createElement(SplitWorkspaceControls, baseProps));
  assert.ok(!closed.includes('role="dialog"'));

  const open = renderToStaticMarkup(
    React.createElement(SplitWorkspaceControls, { ...baseProps, open: true }),
  );
  assert.ok(open.includes('role="dialog"'));
});
