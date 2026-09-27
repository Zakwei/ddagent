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

function findElement(
  node: unknown,
  predicate: (el: React.ReactElement<Record<string, unknown>>) => boolean,
): React.ReactElement<Record<string, unknown>> | null {
  if (!React.isValidElement(node)) return null;
  const element = node as React.ReactElement<Record<string, unknown>>;
  if (predicate(element)) return element;
  const children = element.props?.children;
  if (Array.isArray(children)) {
    for (const child of children) {
      const found = findElement(child, predicate);
      if (found) return found;
    }
  } else if (React.isValidElement(children)) {
    return findElement(children, predicate);
  }
  return null;
}

test('renders the browse sessions button with correct accessibility label when onBrowseSessions is provided', () => {
  const html = renderToStaticMarkup(
    React.createElement(SplitWorkspaceControls, { ...baseProps, onBrowseSessions: noop }),
  );

  assert.ok(html.includes('aria-label="Open session list"'));
});

test('omits the browse sessions button when onBrowseSessions is absent', () => {
  const html = renderToStaticMarkup(React.createElement(SplitWorkspaceControls, baseProps));

  assert.ok(!html.includes('aria-label="Open session list"'));
});

test('triggers onBrowseSessions handler when session list button is clicked', () => {
  let clicked = false;
  let captured: React.ReactElement | null = null;

  function Harness() {
    captured = SplitWorkspaceControls({
      ...baseProps,
      onBrowseSessions: () => {
        clicked = true;
      },
    });
    return null;
  }

  renderToStaticMarkup(React.createElement(Harness));

  const button = findElement(captured, (el) => el.props?.['aria-label'] === 'Open session list');
  assert.ok(button, 'Open session list button must be found in rendered tree');
  assert.equal(typeof button.props?.onClick, 'function');

  (button.props.onClick as () => void)();
  assert.equal(clicked, true, 'onBrowseSessions should be triggered on click');
});
