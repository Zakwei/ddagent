import assert from 'node:assert/strict';
import test from 'node:test';

import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';
import { MemoryRouter } from 'react-router-dom';

import { TasksSettingsProvider } from '../../../../contexts/TasksSettingsContext';

import SidebarRail from './SidebarRail';

// Mock localStorage for the Node test environment where browser storage is absent.
if (typeof globalThis.localStorage === 'undefined') {
  globalThis.localStorage = {
    getItem: () => null,
    setItem: () => {},
    removeItem: () => {},
    clear: () => {},
    length: 0,
    key: () => null,
  } as unknown as Storage;
}

const noop = () => {};

const baseProps = {
  runningCount: 0,
  onOpenPanel: noop,
  onOpenSessions: noop,
  onShowSettings: noop,
  restartRequired: false,
};

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

test('renders the browse sessions button with correct accessibility label and title', () => {
  const html = renderToStaticMarkup(
    React.createElement(
      MemoryRouter,
      null,
      React.createElement(
        TasksSettingsProvider,
        null,
        React.createElement(SidebarRail, baseProps),
      ),
    ),
  );

  assert.ok(html.includes('aria-label="Browse sessions"'));
  assert.ok(html.includes('title="Browse sessions"'));
});

test('triggers onOpenSessions handler when browse sessions button is clicked', () => {
  let sessionsClicked = false;
  let panelClicked = false;
  let captured: React.ReactElement | null = null;

  function Harness() {
    captured = SidebarRail({
      ...baseProps,
      onOpenSessions: () => {
        sessionsClicked = true;
      },
      onOpenPanel: () => {
        panelClicked = true;
      },
    });
    return null;
  }

  renderToStaticMarkup(
    React.createElement(
      MemoryRouter,
      null,
      React.createElement(TasksSettingsProvider, null, React.createElement(Harness)),
    ),
  );

  const sessionsButton = findElement(
    captured,
    (el) => el.props?.['aria-label'] === 'Browse sessions',
  );
  assert.ok(sessionsButton, 'Browse sessions button must be found in rendered tree');
  assert.equal(typeof sessionsButton.props?.onClick, 'function');

  (sessionsButton.props.onClick as () => void)();
  assert.equal(sessionsClicked, true, 'onOpenSessions should be triggered on click');
  assert.equal(panelClicked, false, 'onOpenPanel should not be triggered by sessions button');
});
