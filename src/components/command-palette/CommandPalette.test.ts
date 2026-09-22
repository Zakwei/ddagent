import assert from 'node:assert/strict';
import test from 'node:test';

import { NAV_ITEMS, navShortcut } from './navItems';

// Mirrors the standalone routes mounted in App.tsx — a route added there
// without a palette entry fails here.
const APP_ROUTES = ['/board', '/tasks', '/usage', '/source-control', '/files'];

test('every standalone app route is reachable from the palette', () => {
  const covered = new Set(NAV_ITEMS.map((item) => item.to).filter(Boolean));
  for (const route of APP_ROUTES) {
    assert.ok(covered.has(route), `missing palette entry for route ${route}`);
  }
});

test('nav items target exactly one destination kind', () => {
  for (const item of NAV_ITEMS) {
    assert.notEqual(
      Boolean(item.tab),
      Boolean(item.to),
      `${item.id} must set either tab or to, not both/neither`,
    );
  }
});

test('workspace tabs chat and git are present', () => {
  const tabs = new Set(NAV_ITEMS.map((item) => item.tab).filter(Boolean));
  assert.ok(tabs.has('chat'));
  assert.ok(tabs.has('git'));
});

test('shortcut badges mirror the Alt+1..3 quick-switch mapping', () => {
  assert.equal(navShortcut('chat', true), 'Alt+1');
  assert.equal(navShortcut('tasks', true), 'Alt+2');
  assert.equal(navShortcut('git', true), 'Alt+3');
  // Without the tasks tab the git shortcut shifts down a slot.
  assert.equal(navShortcut('tasks', false), null);
  assert.equal(navShortcut('git', false), 'Alt+2');
  // Route pages have no quick-switch shortcut.
  assert.equal(navShortcut('board', true), null);
});
