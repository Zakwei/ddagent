import assert from 'node:assert/strict';
import test from 'node:test';

import { IN_APP_BROWSER_EVENT, openInAppBrowser } from './inAppBrowser';

type TestGlobals = {
  window?: unknown;
  CustomEvent?: unknown;
};

const globals = globalThis as unknown as TestGlobals;
const originalWindow = globals.window;
const originalCustomEvent = globals.CustomEvent;

type RecordedEvent = { type: string; detail?: { url?: string }; cancelable?: boolean };
let events: RecordedEvent[] = [];

class StubCustomEvent {
  type: string;
  detail?: { url?: string };
  cancelable: boolean;

  constructor(type: string, init?: { detail?: { url?: string }; cancelable?: boolean }) {
    this.type = type;
    this.detail = init?.detail;
    this.cancelable = Boolean(init?.cancelable);
  }
}

/**
 * `claim: true` simulates a mounted pane host (MainContent) that handles the
 * event with preventDefault(), which makes dispatchEvent return false.
 */
function installWindow(options?: { claim?: boolean }) {
  events = [];
  globals.CustomEvent = StubCustomEvent;
  globals.window = {
    dispatchEvent: (event: RecordedEvent) => {
      events.push(event);
      return !options?.claim;
    },
  };
}

function restoreGlobals() {
  globals.window = originalWindow;
  globals.CustomEvent = originalCustomEvent;
}

test.afterEach(() => {
  restoreGlobals();
});

test('openInAppBrowser refuses non-http(s) urls', () => {
  installWindow({ claim: true });
  assert.equal(openInAppBrowser('file:///etc/hosts'), false);
  assert.equal(openInAppBrowser('javascript:alert(1)'), false);
  assert.equal(openInAppBrowser('ftp://example.com'), false);
  assert.equal(openInAppBrowser(''), false);
  assert.equal(events.length, 0);
});

test('openInAppBrowser dispatches a cancelable browser event for http(s) urls', () => {
  installWindow({ claim: true });

  assert.equal(openInAppBrowser('https://example.com/path'), true);
  assert.equal(events.length, 1);
  assert.equal(events[0].type, IN_APP_BROWSER_EVENT);
  assert.equal(events[0].detail?.url, 'https://example.com/path');
  assert.equal(events[0].cancelable, true);

  assert.equal(openInAppBrowser('http://localhost:3000'), true);
  assert.equal(events.length, 2);
  assert.equal(events[1].detail?.url, 'http://localhost:3000');
});

test('openInAppBrowser reports false when no pane claims the event', () => {
  installWindow();
  assert.equal(openInAppBrowser('https://example.com'), false);
  assert.equal(events.length, 1);
});

test('openInAppBrowser accepts uppercase HTTP schemes', () => {
  installWindow({ claim: true });
  assert.equal(openInAppBrowser('HTTPS://EXAMPLE.COM'), true);
  assert.equal(events[0].detail?.url, 'HTTPS://EXAMPLE.COM');
});
