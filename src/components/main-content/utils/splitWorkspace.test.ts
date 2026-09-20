import assert from 'node:assert/strict';
import test from 'node:test';

import {
  MAX_SPLIT_PANES,
  addSplitPane,
  canAddSplitPane,
  createSplitPaneId,
  getSplitLayout,
  getSplitPaneDisplay,
  getSplitPaneRequiredAction,
  removeSplitPane,
  reorderSplitPanes,
  updateSplitPane,
  type SplitPane,
} from './splitWorkspace';

function pane(id: string, kind: SplitPane['kind'] = 'chat'): SplitPane {
  return { id, kind };
}

test('getSplitLayout maps pane counts to grid dimensions', () => {
  assert.deepEqual(getSplitLayout(0), { columns: 1, rows: 1 });
  assert.deepEqual(getSplitLayout(1), { columns: 1, rows: 1 });
  assert.deepEqual(getSplitLayout(2), { columns: 2, rows: 1 });
  assert.deepEqual(getSplitLayout(3), { columns: 3, rows: 1 });
  assert.deepEqual(getSplitLayout(4), { columns: 2, rows: 2 });
  assert.deepEqual(getSplitLayout(5), { columns: 3, rows: 2 });
  assert.deepEqual(getSplitLayout(6), { columns: 3, rows: 2 });
  assert.deepEqual(getSplitLayout(7), { columns: 3, rows: 2 });
});

test('canAddSplitPane reflects the six pane cap', () => {
  assert.equal(canAddSplitPane([]), true);
  assert.equal(canAddSplitPane(Array.from({ length: 5 }, (_, i) => pane(`p${i}`))), true);
  assert.equal(canAddSplitPane(Array.from({ length: 6 }, (_, i) => pane(`p${i}`))), false);
});

test('createSplitPaneId returns unique ids', () => {
  const ids = new Set(Array.from({ length: 50 }, () => createSplitPaneId()));
  assert.equal(ids.size, 50);
});

test('addSplitPane appends immutably and generates an id', () => {
  const original: SplitPane[] = [pane('a')];
  const next = addSplitPane(original, { kind: 'browser', url: 'https://example.com' });

  assert.notEqual(next, original);
  assert.equal(original.length, 1);
  assert.equal(next.length, 2);
  assert.equal(next[1].kind, 'browser');
  assert.ok(next[1].id);
});

test('addSplitPane preserves an explicitly provided id', () => {
  const next = addSplitPane([], { id: 'fixed', kind: 'terminal' });
  assert.equal(next[0].id, 'fixed');
});

test('addSplitPane returns the same reference at the cap', () => {
  const full = Array.from({ length: MAX_SPLIT_PANES }, (_, i) => pane(`p${i}`));
  const next = addSplitPane(full, { kind: 'chat' });
  assert.equal(next, full);
});

test('removeSplitPane returns a new array without the target', () => {
  const original = [pane('a'), pane('b'), pane('c')];
  const next = removeSplitPane(original, 'b');

  assert.notEqual(next, original);
  assert.deepEqual(next.map((p) => p.id), ['a', 'c']);
  assert.equal(original.length, 3);
});

test('updateSplitPane patches the matching pane immutably', () => {
  const original = [pane('a'), pane('b')];
  const next = updateSplitPane(original, 'b', { sessionId: 's2', projectId: 'proj-1' });

  assert.notEqual(next, original);
  assert.equal(next[1].sessionId, 's2');
  assert.equal(next[1].projectId, 'proj-1');
  assert.equal(original[1].sessionId, undefined);
  assert.equal(next[0], original[0]);
});

test('reorderSplitPanes moves a pane forward', () => {
  const original = [pane('a'), pane('b'), pane('c')];
  const next = reorderSplitPanes(original, 'a', 2);
  assert.deepEqual(next.map((p) => p.id), ['b', 'c', 'a']);
});

test('reorderSplitPanes moves a pane backward', () => {
  const original = [pane('a'), pane('b'), pane('c')];
  const next = reorderSplitPanes(original, 'c', 0);
  assert.deepEqual(next.map((p) => p.id), ['c', 'a', 'b']);
});

test('reorderSplitPanes clamps the target index', () => {
  const original = [pane('a'), pane('b'), pane('c')];
  assert.deepEqual(reorderSplitPanes(original, 'a', 99).map((p) => p.id), ['b', 'c', 'a']);
  assert.deepEqual(reorderSplitPanes(original, 'c', -5).map((p) => p.id), ['c', 'a', 'b']);
});

test('reorderSplitPanes is a no-op returning the same reference', () => {
  const original = [pane('a'), pane('b'), pane('c')];
  assert.equal(reorderSplitPanes(original, 'b', 1), original);
  assert.equal(reorderSplitPanes(original, 'missing', 0), original);
});

test('getSplitPaneRequiredAction prioritizes question over processing', () => {
  const signals = {
    processingSessionIds: new Set(['s1', 's2']),
    pendingActionSessionIds: new Set(['s2']),
  };

  assert.equal(
    getSplitPaneRequiredAction({ id: 'p', kind: 'chat', sessionId: 's1' }, signals),
    'processing',
  );
  assert.equal(
    getSplitPaneRequiredAction({ id: 'p', kind: 'chat', sessionId: 's2' }, signals),
    'question',
  );
  assert.equal(
    getSplitPaneRequiredAction({ id: 'p', kind: 'chat', sessionId: 's3' }, signals),
    'idle',
  );
  assert.equal(
    getSplitPaneRequiredAction({ id: 'p', kind: 'chat', sessionId: null }, signals),
    'idle',
  );
  assert.equal(
    getSplitPaneRequiredAction({ id: 'p', kind: 'browser', sessionId: 's2' }, signals),
    'idle',
  );
  assert.equal(
    getSplitPaneRequiredAction({ id: 'p', kind: 'terminal', sessionId: 's1' }, signals),
    'idle',
  );
});

test('getSplitPaneDisplay resolves chat session title and project subtitle', () => {
  const sessions = new Map([
    ['s1', { summary: 'Summary title', title: 'Title', name: 'Name' }],
    ['s2', { title: 'Only title' }],
    ['s3', { name: 'Only name' }],
  ]);
  const projects = new Map([['proj-1', 'Project One']]);

  const withSummary = getSplitPaneDisplay(
    { id: 'p', kind: 'chat', sessionId: 's1', projectId: 'proj-1' },
    { sessionsById: sessions, projectNamesById: projects },
  );
  assert.equal(withSummary.title, 'Summary title');
  assert.equal(withSummary.subtitle, 'Project One');
  assert.equal(withSummary.action, 'idle');

  assert.equal(
    getSplitPaneDisplay({ id: 'p', kind: 'chat', sessionId: 's2' }, { sessionsById: sessions }).title,
    'Only title',
  );
  assert.equal(
    getSplitPaneDisplay({ id: 'p', kind: 'chat', sessionId: 's3' }, { sessionsById: sessions }).title,
    'Only name',
  );
});

test('getSplitPaneDisplay falls back to a session id stub without a session map', () => {
  const display = getSplitPaneDisplay({ id: 'p', kind: 'chat', sessionId: 'abcdef123456' }, {});
  assert.equal(display.title, 'abcdef12');
  assert.equal(display.action, 'idle');
  assert.equal(
    getSplitPaneDisplay({ id: 'p', kind: 'chat' }, {}).title,
    'Chat',
  );
});

test('getSplitPaneDisplay maps chat actions question > processing > idle', () => {
  const context = {
    processingSessionIds: new Set(['s1', 's2']),
    pendingActionSessionIds: new Set(['s2']),
  };

  assert.equal(
    getSplitPaneDisplay({ id: 'p', kind: 'chat', sessionId: 's1' }, context).action,
    'processing',
  );
  assert.equal(
    getSplitPaneDisplay({ id: 'p', kind: 'chat', sessionId: 's2' }, context).action,
    'question',
  );
  assert.equal(
    getSplitPaneDisplay({ id: 'p', kind: 'chat', sessionId: 's3' }, context).action,
    'idle',
  );
});

test('getSplitPaneDisplay derives browser hostname and never throws on bad urls', () => {
  const valid = getSplitPaneDisplay(
    { id: 'p', kind: 'browser', url: 'https://example.com/path?q=1' },
    {},
  );
  assert.equal(valid.title, 'Browser');
  assert.equal(valid.subtitle, 'example.com');
  assert.equal(valid.action, 'idle');

  const invalid = getSplitPaneDisplay({ id: 'p', kind: 'browser', url: 'not a url' }, {});
  assert.equal(invalid.subtitle, 'not a url');

  assert.equal(getSplitPaneDisplay({ id: 'p', kind: 'browser' }, {}).subtitle, undefined);
});

test('getSplitPaneDisplay labels terminal panes with the project name', () => {
  const display = getSplitPaneDisplay(
    { id: 'p', kind: 'terminal', projectId: 'proj-1' },
    { projectNamesById: new Map([['proj-1', 'Project One']]) },
  );
  assert.equal(display.title, 'Terminal');
  assert.equal(display.subtitle, 'Project One');
  assert.equal(display.action, 'idle');
});

test('getSplitPaneDisplay treats empty-string chrome values as absent', () => {
  const browser = getSplitPaneDisplay({ id: 'p', kind: 'browser', url: '' }, {});
  assert.equal(browser.subtitle, undefined);

  const chat = getSplitPaneDisplay({ id: 'p', kind: 'chat', sessionId: '' }, {});
  assert.equal(chat.title, 'Chat');
  assert.equal(chat.action, 'idle');
});

test('getSplitPaneDisplay accepts unicode titles unchanged', () => {
  const display = getSplitPaneDisplay(
    { id: 'p', kind: 'chat', sessionId: 's1' },
    { sessionsById: new Map([['s1', { summary: 'Zbadaj błąd logowania żółć' }]]) },
  );

  assert.equal(display.title, 'Zbadaj błąd logowania żółć');
});

test('getSplitPaneDisplay passes through very long titles without truncating', () => {
  const long = 'A'.repeat(300);
  const display = getSplitPaneDisplay(
    { id: 'p', kind: 'chat', sessionId: 's1' },
    { sessionsById: new Map([['s1', { title: long }]]) },
  );

  assert.equal(display.title, long);
});

test('getSplitPaneDisplay prefers summary over title over name', () => {
  const display = getSplitPaneDisplay(
    { id: 'p', kind: 'chat', sessionId: 's1' },
    { sessionsById: new Map([['s1', { summary: 'S', title: 'T', name: 'N' }]]) },
  );
  assert.equal(display.title, 'S');
});

test('getSplitPaneDisplay omits a project subtitle when the project is unknown', () => {
  const display = getSplitPaneDisplay(
    { id: 'p', kind: 'terminal', projectId: 'missing-project' },
    { projectNamesById: new Map([['proj-1', 'Project One']]) },
  );
  assert.equal(display.subtitle, undefined);
});

test('getSplitPaneRequiredAction ignores session signals for non-chat panes', () => {
  const signals = {
    processingSessionIds: new Set(['s1']),
    pendingActionSessionIds: new Set(['s1']),
  };

  assert.equal(
    getSplitPaneRequiredAction({ id: 'p', kind: 'terminal', sessionId: 's1' }, signals),
    'idle',
  );
  assert.equal(
    getSplitPaneRequiredAction({ id: 'p', kind: 'browser', sessionId: 's1' }, signals),
    'idle',
  );
});

test('getSplitPaneDisplay does not throw when context sets are missing', () => {
  assert.doesNotThrow(() => {
    const display = getSplitPaneDisplay({ id: 'p', kind: 'chat', sessionId: 's1' }, {});
    assert.equal(display.action, 'idle');
  });
});

