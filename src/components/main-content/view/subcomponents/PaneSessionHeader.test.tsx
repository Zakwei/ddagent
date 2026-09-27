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

  // Should NOT render completed or question indicators
  assert.ok(!html.includes('aria-label="Task completed"'));
  assert.ok(!html.includes('aria-label="Awaiting input"'));
});

test('renders completion indicator when session is done (requiredAction="completed")', () => {
  const html = renderToStaticMarkup(
    React.createElement(PaneSessionHeader, {
      ...baseProps,
      requiredAction: 'completed',
    }),
  );

  // Completed task indicator: role="status", aria-label="Task completed", emerald check
  assert.ok(html.includes('role="status"'), 'must include role="status"');
  assert.ok(html.includes('aria-label="Task completed"'), 'must include completed aria-label');
  assert.ok(html.includes('text-emerald-500'), 'completion icon must use emerald text color');

  // Should NOT render processing spinner or question alert
  assert.ok(!html.includes('animate-spin'));
  assert.ok(!html.includes('aria-label="Processing…"'));
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
  assert.ok(!html.includes('aria-label="Task completed"'));
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
  assert.ok(!html.includes('aria-label="Task completed"'));
  assert.ok(!html.includes('aria-label="Awaiting input"'));
  assert.ok(html.includes('Fix login bug'));
  assert.ok(html.includes('Core App'));
});
