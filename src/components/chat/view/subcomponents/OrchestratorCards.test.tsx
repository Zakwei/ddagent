import assert from 'node:assert/strict';
import test from 'node:test';

import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

import { WebSocketContext } from '../../../../contexts/WebSocketContext';
import type { OrchestratorCardData } from '../../types/types';

import { OrchestratorCard, SummaryCard } from './OrchestratorCards';

if (!i18n.isInitialized) {
  i18n.use(initReactI18next).init({
    lng: 'en',
    fallbackLng: 'en',
    resources: {
      en: {
        translation: {
          'chat.orchestrator.tasksLeft': '{{count}} tasks left',
          'chat.orchestrator.failedSteps': 'Failed steps: {{list}}',
          'chat.orchestrator.taskmasterLeft': '{{count}} left',
          'chat.orchestrator.endAllTasks': 'End all tasks',
          'chat.orchestrator.workingOnTasks': 'Working on tasks…',
          'chat.orchestrator.continueWork': 'Continue work',
          'chat.orchestrator.continue': 'Continue',
          'chat.orchestrator.results': 'Results',
          'chat.orchestrator.running': 'Running',
          'chat.orchestrator.done': 'Done',
          'chat.orchestrator.failed': 'Failed',
          'chat.orchestrator.aborted': 'Aborted',
          'chat.orchestrator.paused': 'Paused',
          'chat.orchestrator.complete': 'Complete',
          'chat.orchestrator.blocked': 'Blocked',
          'chat.orchestrator.cancel': 'Cancel',
        },
      },
    },
    interpolation: {
      escapeValue: false,
    },
  });
}

if (typeof (globalThis as Record<string, unknown>).localStorage === 'undefined') {
  const store = new Map<string, string>();
  (globalThis as Record<string, unknown>).localStorage = {
    getItem: (key: string) => store.get(key) ?? null,
    setItem: (key: string, value: string) => {
      store.set(key, String(value));
    },
    removeItem: (key: string) => {
      store.delete(key);
    },
    clear: () => {
      store.clear();
    },
    key: (index: number) => Array.from(store.keys())[index] ?? null,
    get length() {
      return store.size;
    },
  };
}

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

function makeFakeWebSocket(options?: {
  onSendMessage?: (msg: unknown) => boolean;
}) {
  const listeners = new Set<(event: unknown) => void>();
  const sent: unknown[] = [];
  return {
    value: {
      ws: null,
      sendMessage: (msg: unknown) => {
        sent.push(msg);
        return options?.onSendMessage ? options.onSendMessage(msg) : true;
      },
      subscribe: (listener: (event: unknown) => void) => {
        listeners.add(listener);
        return () => listeners.delete(listener);
      },
      latestMessage: null,
      isConnected: true,
    },
    sent,
    listeners,
  };
}

test('SummaryCard: renders summary content, results, and action buttons when idle', () => {
  const ws = makeFakeWebSocket();
  const summaryData: OrchestratorCardData = {
    kind: 'summary',
    text: 'Execution succeeded smoothly.',
    results: [
      { title: 'Step 1: Scaffolding', summary: 'Scaffolded components successfully.' },
    ],
  };

  const html = renderToStaticMarkup(
    React.createElement(
      WebSocketContext.Provider,
      { value: ws.value as never },
      React.createElement(SummaryCard, {
        data: summaryData,
        sessionId: 'sess-orchestrator-1',
      }),
    ),
  );

  assert.ok(html.includes('Summary'));
  assert.ok(html.includes('Execution succeeded smoothly.'));
  assert.ok(html.includes('Step 1: Scaffolding'));
  assert.ok(html.includes('Scaffolded components successfully.'));
  assert.ok(html.includes('Continue work'));
  assert.ok(html.includes('End all tasks'));
  assert.ok(!html.includes('disabled=""'));
});

test('SummaryCard: disables buttons when sessionId is missing', () => {
  const ws = makeFakeWebSocket();
  const summaryData: OrchestratorCardData = {
    kind: 'summary',
    text: 'Initial summary.',
  };

  const html = renderToStaticMarkup(
    React.createElement(
      WebSocketContext.Provider,
      { value: ws.value as never },
      React.createElement(SummaryCard, {
        data: summaryData,
        sessionId: null,
      }),
    ),
  );

  assert.ok(html.includes('Continue work'));
  assert.ok(html.includes('End all tasks'));
  // All three action buttons should have disabled attribute
  const disabledMatches = html.match(/disabled=""/g) ?? [];
  assert.equal(disabledMatches.length, 3);
});

test('SummaryCard: renders "Continue" with failed steps when failures exist', () => {
  const ws = makeFakeWebSocket();
  const summaryData: OrchestratorCardData = {
    kind: 'summary',
    text: 'Completed with some errors.',
    failed: ['step-2-test', 'step-3-lint'],
  };

  const html = renderToStaticMarkup(
    React.createElement(
      WebSocketContext.Provider,
      { value: ws.value as never },
      React.createElement(SummaryCard, {
        data: summaryData,
        sessionId: 'sess-failed-1',
      }),
    ),
  );

  assert.ok(html.includes('Failed steps: step-2-test, step-3-lint'));
  assert.ok(html.includes('Continue'));
  assert.ok(!html.includes('Continue work'));
  assert.ok(html.includes('End all tasks'));
});

test('SummaryCard: clicking "End all tasks" calls authenticatedFetch with complete-all-tasks mode', async () => {
  const ws = makeFakeWebSocket();
  const summaryData: OrchestratorCardData = {
    kind: 'summary',
    text: 'Ready for batch tasks.',
  };

  const fetchCalls: Array<{ url: string; options: RequestInit }> = [];
  const originalFetch = globalThis.fetch;
  globalThis.fetch = (async (url: string | URL | Request, init?: RequestInit) => {
    fetchCalls.push({ url: String(url), options: init ?? {} });
    return new Response(JSON.stringify({ ok: true }), { status: 200 });
  }) as typeof fetch;

  try {
    let captured: React.ReactElement | null = null;
    function Harness() {
      captured = SummaryCard({
        data: summaryData,
        sessionId: 'sess-batch-test',
      });
      return null;
    }

    renderToStaticMarkup(
      React.createElement(
        WebSocketContext.Provider,
        { value: ws.value as never },
        React.createElement(Harness),
      ),
    );

    assert.ok(captured);
    const endAllBtn = findElement(
      captured,
      (el) => el.props?.children === 'End all tasks',
    );
    assert.ok(endAllBtn, 'End all tasks button must be found in tree');
    assert.equal(typeof endAllBtn.props?.onClick, 'function');

    await (endAllBtn.props.onClick as () => Promise<void>)();

    assert.equal(fetchCalls.length, 1);
    assert.equal(fetchCalls[0].url, '/api/orchestrator/sessions/sess-batch-test/resume');
    assert.equal(fetchCalls[0].options.method, 'POST');
    const parsedBody = JSON.parse(String(fetchCalls[0].options.body));
    assert.equal(parsedBody.mode, 'complete-all-tasks');
  } finally {
    globalThis.fetch = originalFetch;
  }
});

test('SummaryCard: clicking "Continue work" calls authenticatedFetch with continue mode', async () => {
  const ws = makeFakeWebSocket();
  const summaryData: OrchestratorCardData = {
    kind: 'summary',
    text: 'Prior phase done.',
  };

  const fetchCalls: Array<{ url: string; options: RequestInit }> = [];
  const originalFetch = globalThis.fetch;
  globalThis.fetch = (async (url: string | URL | Request, init?: RequestInit) => {
    fetchCalls.push({ url: String(url), options: init ?? {} });
    return new Response(JSON.stringify({ ok: true }), { status: 200 });
  }) as typeof fetch;

  try {
    let captured: React.ReactElement | null = null;
    function Harness() {
      captured = SummaryCard({
        data: summaryData,
        sessionId: 'sess-continue-test',
      });
      return null;
    }

    renderToStaticMarkup(
      React.createElement(
        WebSocketContext.Provider,
        { value: ws.value as never },
        React.createElement(Harness),
      ),
    );

    assert.ok(captured);
    const continueBtn = findElement(
      captured,
      (el) => el.props?.children === 'Continue work',
    );
    assert.ok(continueBtn, 'Continue work button must be found');
    await (continueBtn.props?.onClick as () => Promise<void>)();

    assert.equal(fetchCalls.length, 1);
    assert.equal(fetchCalls[0].url, '/api/orchestrator/sessions/sess-continue-test/resume');
    const parsedBody = JSON.parse(String(fetchCalls[0].options.body));
    assert.equal(parsedBody.mode, 'continue');
  } finally {
    globalThis.fetch = originalFetch;
  }
});

test('SummaryCard: clicking "Continue" (with failures) re-runs failed steps without mode: continue', async () => {
  const ws = makeFakeWebSocket();
  const summaryData: OrchestratorCardData = {
    kind: 'summary',
    text: 'Failed step present.',
    failed: ['step-fail'],
  };

  const fetchCalls: Array<{ url: string; options: RequestInit }> = [];
  const originalFetch = globalThis.fetch;
  globalThis.fetch = (async (url: string | URL | Request, init?: RequestInit) => {
    fetchCalls.push({ url: String(url), options: init ?? {} });
    return new Response(JSON.stringify({ ok: true }), { status: 200 });
  }) as typeof fetch;

  try {
    let captured: React.ReactElement | null = null;
    function Harness() {
      captured = SummaryCard({
        data: summaryData,
        sessionId: 'sess-fail-retry',
      });
      return null;
    }

    renderToStaticMarkup(
      React.createElement(
        WebSocketContext.Provider,
        { value: ws.value as never },
        React.createElement(Harness),
      ),
    );

    assert.ok(captured);
    const continueBtn = findElement(
      captured,
      (el) => el.props?.children === 'Continue',
    );
    assert.ok(continueBtn, 'Continue button must be found');
    await (continueBtn.props?.onClick as () => Promise<void>)();

    assert.equal(fetchCalls.length, 1);
    assert.equal(fetchCalls[0].url, '/api/orchestrator/sessions/sess-fail-retry/resume');
    const parsedBody = JSON.parse(String(fetchCalls[0].options.body));
    assert.equal(parsedBody.mode, undefined);
  } finally {
    globalThis.fetch = originalFetch;
  }
});

test('SummaryCard: renders running state with spinner, progress count, cancel button, and disabled Continue', () => {
  const ws = makeFakeWebSocket();
  const summaryData: OrchestratorCardData = {
    kind: 'summary',
    text: 'Running queue.',
  };

  const html = renderToStaticMarkup(
    React.createElement(
      WebSocketContext.Provider,
      { value: ws.value as never },
      React.createElement(SummaryCard, {
        data: summaryData,
        sessionId: 'sess-running-1',
        initialTasksState: 'running',
        initialTasksProgress: { remaining: 4, total: 7 },
      }),
    ),
  );

  assert.ok(html.includes('4 tasks left'));
  assert.ok(html.includes('Cancel'));
  assert.ok(html.includes('animate-spin'));
  assert.ok(!html.includes('End all tasks'));
  // Continue button must be disabled while running
  assert.ok(html.includes('disabled=""'));
});

test('SummaryCard: clicking Cancel in running state dispatches chat.abort websocket message', () => {
  const ws = makeFakeWebSocket();
  const summaryData: OrchestratorCardData = {
    kind: 'summary',
    text: 'Tasks in flight.',
  };

  let captured: React.ReactElement | null = null;
  function Harness() {
    captured = SummaryCard({
      data: summaryData,
      sessionId: 'sess-abort-target',
      initialTasksState: 'running',
      initialTasksProgress: { remaining: 2, total: 3 },
    });
    return null;
  }

  renderToStaticMarkup(
    React.createElement(
      WebSocketContext.Provider,
      { value: ws.value as never },
      React.createElement(Harness),
    ),
  );

  assert.ok(captured);
  const cancelBtn = findElement(
    captured,
    (el) => el.props?.children === 'Cancel',
  );
  assert.ok(cancelBtn, 'Cancel button must be found in running state');
  assert.equal(typeof cancelBtn.props?.onClick, 'function');

  (cancelBtn.props.onClick as () => void)();

  assert.equal(ws.sent.length, 1);
  assert.deepEqual(ws.sent[0], {
    type: 'chat.abort',
    sessionId: 'sess-abort-target',
  });
});

test('SummaryCard: renders error message when tasksState is failed', () => {
  const ws = makeFakeWebSocket();
  const summaryData: OrchestratorCardData = {
    kind: 'summary',
    text: 'Execution summary.',
  };

  const html = renderToStaticMarkup(
    React.createElement(
      WebSocketContext.Provider,
      { value: ws.value as never },
      React.createElement(SummaryCard, {
        data: summaryData,
        sessionId: 'sess-failed-run',
        initialTasksState: 'failed',
      }),
    ),
  );

  assert.ok(html.includes('Failed to resume — try again.'));
});

test('OrchestratorCard: renders TaskmasterCard with status badge and remaining task counter', () => {
  const taskmasterData: OrchestratorCardData = {
    kind: 'taskmaster',
    status: 'started',
    taskId: '12',
    title: 'Migrate legacy schema',
    remaining: 3,
    total: 8,
  };

  const html = renderToStaticMarkup(
    React.createElement(OrchestratorCard, {
      data: taskmasterData,
      sessionId: 'sess-taskmaster-view',
    }),
  );

  assert.ok(html.includes('Task queue'));
  assert.ok(html.includes('#12'));
  assert.ok(html.includes('Migrate legacy schema'));
  assert.ok(html.includes('3 left'));
  assert.ok(html.includes('/ 8'));
});
