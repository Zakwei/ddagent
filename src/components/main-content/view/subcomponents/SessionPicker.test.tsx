import assert from 'node:assert/strict';
import test from 'node:test';

import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';

import type { SplitSessionCandidate } from '../../utils/splitSessionUtils';

import SessionPicker from './SessionPicker';

const noop = () => {};

const sessions: SplitSessionCandidate[] = [
  {
    id: 's1',
    summary: 'Fix login bug',
    projectId: 'p1',
    projectName: 'Current project',
    isCurrentProject: true,
    lastActivity: '2026-09-17T11:18:00Z',
  },
  {
    id: 's2',
    title: 'Other work',
    projectId: 'p2',
    projectName: 'Another project',
    isCurrentProject: false,
    lastActivity: '2026-09-16T11:18:00Z',
  },
];

const baseProps = {
  sessions,
  onSelectSession: noop,
  onNewChat: noop,
};

test('renders the search box, new-chat row and grouped sessions', () => {
  const html = renderToStaticMarkup(React.createElement(SessionPicker, baseProps));

  assert.ok(html.includes('data-testid="session-picker"'));
  assert.ok(html.includes('aria-label="Search sessions..."'));
  assert.ok(html.includes('+ New chat'));
  // Current project group wins over the flat list: both groups render.
  assert.ok(html.includes('Fix login bug'));
  assert.ok(html.includes('Other work'));
  assert.equal((html.match(/role="group"/g) ?? []).length, 2);
  // No archive loader → no archive toggle, and nothing to cancel back to.
  assert.ok(!html.includes('aria-label="Archived"'));
  assert.ok(!html.includes('>Cancel<'));
});

test('marks running sessions and shows Cancel only for a session-bound pane', () => {
  const html = renderToStaticMarkup(
    React.createElement(SessionPicker, {
      ...baseProps,
      processingSessionIds: new Set(['s1']),
      canCancel: true,
      onCancel: noop,
      onLoadArchived: async () => {},
    }),
  );

  assert.ok(html.includes('aria-label="Session is running"'));
  assert.ok(html.includes('>Cancel<'));
  assert.ok(html.includes('aria-pressed="false"'));
});

test('filters sessions by the current search-independent state and shows an empty state', () => {
  const html = renderToStaticMarkup(
    React.createElement(SessionPicker, { ...baseProps, sessions: [] }),
  );

  assert.ok(html.includes('No other sessions available'));
  assert.ok(!html.includes('Fix login bug'));
});

test('labels a lone non-current group as recent sessions instead of other projects', () => {
  const html = renderToStaticMarkup(
    React.createElement(SessionPicker, {
      ...baseProps,
      sessions: [
        {
          id: 's9',
          title: 'Lone session',
          projectId: 'p9',
          projectName: 'Elsewhere',
          isCurrentProject: false,
        },
      ],
    }),
  );

  assert.ok(html.includes('Recent sessions'));
  assert.ok(!html.includes('Other projects'));
});

test('renders no row action buttons without archive/delete handlers', () => {
  const html = renderToStaticMarkup(React.createElement(SessionPicker, baseProps));

  assert.ok(!html.includes('Archive session:'));
  assert.ok(!html.includes('Delete permanently:'));
});

test('renders per-row archive and delete buttons when the handlers are provided', () => {
  const html = renderToStaticMarkup(
    React.createElement(SessionPicker, {
      ...baseProps,
      onArchiveSession: async () => true,
      onDeleteSession: async () => true,
    }),
  );

  // Both groups render the actions: current project (s1) and other projects (s2).
  assert.ok(html.includes('aria-label="Archive session: Fix login bug"'));
  assert.ok(html.includes('aria-label="Delete permanently: Fix login bug"'));
  assert.ok(html.includes('aria-label="Archive session: Other work"'));
  assert.ok(html.includes('aria-label="Delete permanently: Other work"'));
});
