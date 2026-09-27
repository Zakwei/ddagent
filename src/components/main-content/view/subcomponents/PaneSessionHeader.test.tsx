import assert from 'node:assert/strict';
import test from 'node:test';

import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';

import type { ProjectSession } from '../../../../types/app';

import PaneSessionHeader from './PaneSessionHeader';

const mockSession: ProjectSession = {
  id: 'sess-1',
  summary: 'Fix login bug',
  createdAt: '2026-09-27T10:00:00Z',
  updatedAt: '2026-09-27T10:00:00Z',
  __provider: 'claude',
};

const baseProps = {
  session: mockSession,
  projectName: 'Core App',
};

test('renders active processing badge when session is busy (requiredAction="processing")', () => {
  const html = renderToStaticMarkup(
    React.createElement(PaneSessionHeader, {
      ...baseProps,
      requiredAction: 'processing',
    }),
  );

  // Active work indicator: role="status", aria-label="Processing…", and animated spinner
  assert.ok(html.includes('role="status"'), 'must include role="status"');
  assert.ok(html.includes('aria-label="Processing…"'), 'must include processing aria-label');
  assert.ok(html.includes('animate-spin'), 'must include spinner animation');
  assert.ok(html.includes('border-emerald-500'), 'spinner must use emerald border');

  // Should NOT render a question indicator
  assert.ok(!html.includes('aria-label="Awaiting input"'));
});

test('renders question indicator when input is required (requiredAction="question")', () => {
  const html = renderToStaticMarkup(
    React.createElement(PaneSessionHeader, {
      ...baseProps,
      requiredAction: 'question',
    }),
  );

  assert.ok(html.includes('aria-label="Awaiting input"'));
  assert.ok(html.includes('text-amber-500'));
  assert.ok(!html.includes('animate-spin'));
});

test('renders no status indicators when session is idle (requiredAction="idle")', () => {
  const html = renderToStaticMarkup(
    React.createElement(PaneSessionHeader, {
      ...baseProps,
      requiredAction: 'idle',
    }),
  );

  assert.ok(!html.includes('aria-label="Processing…"'));
  assert.ok(!html.includes('animate-spin'));
  assert.ok(!html.includes('aria-label="Awaiting input"'));
  assert.ok(html.includes('Fix login bug'));
  assert.ok(html.includes('Core App'));
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

test('renders switch session button with correct accessibility label and title when onChangeSession is provided', () => {
  const html = renderToStaticMarkup(
    React.createElement(PaneSessionHeader, {
      ...baseProps,
      onChangeSession: () => {},
    }),
  );

  assert.ok(html.includes('aria-label="Switch session"'));
  assert.ok(html.includes('title="Switch session"'));
});

test('omits switch session button when onChangeSession is absent', () => {
  const html = renderToStaticMarkup(
    React.createElement(PaneSessionHeader, {
      ...baseProps,
      onChangeSession: undefined,
    }),
  );

  assert.ok(!html.includes('aria-label="Switch session"'));
  assert.ok(!html.includes('title="Switch session"'));
});

test('triggers onChangeSession handler when switch session button is clicked', () => {
  let clicked = false;
  let captured: React.ReactElement | null = null;

  function Harness() {
    captured = PaneSessionHeader({
      ...baseProps,
      onChangeSession: () => {
        clicked = true;
      },
    });
    return null;
  }

  renderToStaticMarkup(React.createElement(Harness));

  const button = findElement(captured, (el) => el.props?.['aria-label'] === 'Switch session');
  assert.ok(button, 'Switch session button must be found in rendered tree');
  assert.equal(typeof button.props?.onClick, 'function');

  (button.props.onClick as () => void)();
  assert.equal(clicked, true, 'onChangeSession should be triggered on click');
});
