import assert from 'node:assert/strict';
import test from 'node:test';

import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';

import { WebBrowserPane } from './WebBrowserPane';

const globals = globalThis as unknown as { window?: unknown };
const originalWindow = globals.window;

test.afterEach(() => {
  globals.window = originalWindow;
});

test('falls back to the remote browser view when the bridge is missing', () => {
  globals.window = {};
  const html = renderToStaticMarkup(React.createElement(WebBrowserPane, {}));

  assert.ok(html.includes('data-testid="remote-browser-canvas"'));
  assert.ok(html.includes('Connecting to browser'));
  assert.ok(!html.includes('<webview'));
});

test('renders the toolbar and a webview when the desktop bridge is present', () => {
  globals.window = { ddagentBrowser: { isDesktop: true } };
  const html = renderToStaticMarkup(
    React.createElement(WebBrowserPane, { url: 'https://example.com/path' }),
  );

  assert.ok(html.includes('<webview'));
  assert.ok(html.includes('src="https://example.com/path"'));
  assert.ok(html.includes('aria-label="Back"'));
  assert.ok(html.includes('aria-label="Forward"'));
  assert.ok(html.includes('aria-label="Reload"'));
  assert.ok(html.includes('aria-label="Address"'));
  assert.ok(html.includes('aria-label="Open in system browser"'));
});

test('does not set a webview src for a non-http url', () => {
  globals.window = { ddagentBrowser: { isDesktop: true } };
  const html = renderToStaticMarkup(
    React.createElement(WebBrowserPane, { url: 'javascript:alert(1)' }),
  );

  assert.ok(html.includes('<webview'));
  assert.ok(!html.includes('<webview src='));
  assert.ok(html.includes('value="javascript:alert(1)"'));
});

test('reflects the isActive flag on the root element', () => {
  globals.window = { ddagentBrowser: { isDesktop: true } };
  const html = renderToStaticMarkup(
    React.createElement(WebBrowserPane, { url: 'https://example.com', isActive: true }),
  );

  assert.ok(html.includes('data-active="true"'));
  assert.ok(!html.includes('data-active="false"'));
});
