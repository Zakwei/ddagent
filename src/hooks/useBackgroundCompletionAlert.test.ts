import assert from 'node:assert/strict';
import test from 'node:test';

import {
  DEFAULT_DONE_PREFIX,
  detectCompletedSessions,
  prefixTitle,
  resetTitle,
} from './useBackgroundCompletionAlert';

test('prefixTitle prefixes title when not already prefixed', () => {
  assert.equal(prefixTitle('Session 1'), `${DEFAULT_DONE_PREFIX}Session 1`);
  assert.equal(prefixTitle('ddagent UI'), '✓ Done! ddagent UI');
});

test('prefixTitle does not duplicate prefix if already present', () => {
  const alreadyPrefixed = `${DEFAULT_DONE_PREFIX}Session 1`;
  assert.equal(prefixTitle(alreadyPrefixed), alreadyPrefixed);
});

test('prefixTitle supports a custom prefix', () => {
  const custom = '✓ Gotowe! ';
  assert.equal(prefixTitle('Session 1', custom), '✓ Gotowe! Session 1');
  assert.equal(prefixTitle('✓ Gotowe! Session 1', custom), '✓ Gotowe! Session 1');
});

test('resetTitle removes prefix when present', () => {
  assert.equal(resetTitle(`${DEFAULT_DONE_PREFIX}Session 1`), 'Session 1');
  assert.equal(resetTitle('✓ Gotowe! Session 1', '✓ Gotowe! '), 'Session 1');
});

test('resetTitle leaves title unchanged when prefix is absent', () => {
  assert.equal(resetTitle('Session 1'), 'Session 1');
  assert.equal(resetTitle('ddagent UI'), 'ddagent UI');
});

test('detectCompletedSessions returns empty array when no sessions are removed', () => {
  const prev = new Set(['s1', 's2']);
  const curr = new Set(['s1', 's2']);
  assert.deepEqual(detectCompletedSessions(prev, curr), []);

  const currMore = new Set(['s1', 's2', 's3']);
  assert.deepEqual(detectCompletedSessions(prev, currMore), []);
});

test('detectCompletedSessions identifies sessions removed from previous set', () => {
  const prev = new Set(['s1', 's2', 's3']);
  const curr = new Set(['s2']);
  assert.deepEqual(detectCompletedSessions(prev, curr), ['s1', 's3']);
});

test('detectCompletedSessions handles empty previous or current sets', () => {
  assert.deepEqual(detectCompletedSessions(new Set(), new Set(['s1'])), []);
  assert.deepEqual(detectCompletedSessions(new Set(['s1']), new Set()), ['s1']);
});

test('simulates background completion workflow', () => {
  let soundPlayed = false;
  let hapticFired = false;
  let notificationTitle = '';
  let notificationBody = '';

  const mockDoc = {
    title: 'Code Review',
    hidden: true,
  };

  const playSound = () => {
    soundPlayed = true;
  };

  const triggerHaptic = () => {
    hapticFired = true;
  };

  const onNotification = (title: string, options?: NotificationOptions) => {
    notificationTitle = title;
    notificationBody = options?.body ?? '';
  };

  // 1. Initial state: session 's1' running
  const prevKeys = new Set(['s1']);
  const currentKeys = new Set<string>(); // s1 finished

  const completed = detectCompletedSessions(prevKeys, currentKeys);
  assert.deepEqual(completed, ['s1']);

  // If document is hidden:
  if (mockDoc.hidden && completed.length > 0) {
    playSound();
    triggerHaptic();
    mockDoc.title = prefixTitle(mockDoc.title);
    onNotification('Task completed', {
      body: completed.length === 1
        ? 'Session has finished processing.'
        : `${completed.length} sessions have finished processing.`,
    });
  }

  assert.equal(soundPlayed, true);
  assert.equal(hapticFired, true);
  assert.equal(mockDoc.title, '✓ Done! Code Review');
  assert.equal(notificationTitle, 'Task completed');
  assert.equal(notificationBody, 'Session has finished processing.');

  // 2. User returns to the tab:
  mockDoc.hidden = false;
  mockDoc.title = resetTitle(mockDoc.title);
  assert.equal(mockDoc.title, 'Code Review');
});

test('does not alert if document is visible when completion happens', () => {
  let soundPlayed = false;
  let hapticFired = false;

  const mockDoc = {
    title: 'Code Review',
    hidden: false,
  };

  const prevKeys = new Set(['s1']);
  const currentKeys = new Set<string>();
  const completed = detectCompletedSessions(prevKeys, currentKeys);

  if (mockDoc.hidden && completed.length > 0) {
    soundPlayed = true;
    hapticFired = true;
    mockDoc.title = prefixTitle(mockDoc.title);
  }

  assert.equal(soundPlayed, false);
  assert.equal(hapticFired, false);
  assert.equal(mockDoc.title, 'Code Review');
});
