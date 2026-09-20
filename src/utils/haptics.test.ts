import assert from 'node:assert/strict';
import test from 'node:test';

import {
  HAPTIC_PATTERNS,
  completion,
  error,
  permissionRequested,
  triggerHapticFeedback,
} from './haptics';

test('exports preset patterns with expected values', () => {
  assert.deepEqual(HAPTIC_PATTERNS.permissionRequested, [80, 40, 80]);
  assert.equal(HAPTIC_PATTERNS.completion, 50);
  assert.deepEqual(HAPTIC_PATTERNS.error, [100, 50, 100, 50, 100]);

  assert.deepEqual(permissionRequested, [80, 40, 80]);
  assert.equal(completion, 50);
  assert.deepEqual(error, [100, 50, 100, 50, 100]);
});

test('triggerHapticFeedback is a no-op when navigator is undefined', () => {
  const originalNavigator = globalThis.navigator;
  try {
    // @ts-expect-error - simulating environment without navigator
    delete globalThis.navigator;

    assert.doesNotThrow(() => {
      triggerHapticFeedback('permissionRequested');
    });
  } finally {
    globalThis.navigator = originalNavigator;
  }
});

test('triggerHapticFeedback is a no-op when navigator.vibrate is missing', () => {
  const originalNavigator = globalThis.navigator;
  try {
    // @ts-expect-error - simulating navigator without vibrate
    globalThis.navigator = {};

    assert.doesNotThrow(() => {
      triggerHapticFeedback('permissionRequested');
    });
  } finally {
    globalThis.navigator = originalNavigator;
  }
});

test('triggerHapticFeedback invokes navigator.vibrate with preset patterns', () => {
  const calls: unknown[] = [];
  const originalNavigator = globalThis.navigator;

  try {
    // @ts-expect-error - mock navigator
    globalThis.navigator = {
      vibrate(pattern: unknown) {
        calls.push(pattern);
        return true;
      },
    };

    triggerHapticFeedback('permissionRequested');
    assert.deepEqual(calls[0], [80, 40, 80]);

    triggerHapticFeedback('completion');
    assert.equal(calls[1], 50);

    triggerHapticFeedback('error');
    assert.deepEqual(calls[2], [100, 50, 100, 50, 100]);
  } finally {
    globalThis.navigator = originalNavigator;
  }
});

test('triggerHapticFeedback invokes navigator.vibrate with custom number or array pattern', () => {
  const calls: unknown[] = [];
  const originalNavigator = globalThis.navigator;

  try {
    // @ts-expect-error - mock navigator
    globalThis.navigator = {
      vibrate(pattern: unknown) {
        calls.push(pattern);
        return true;
      },
    };

    triggerHapticFeedback(120);
    assert.equal(calls[0], 120);

    triggerHapticFeedback([10, 20, 30]);
    assert.deepEqual(calls[1], [10, 20, 30]);

    // Default pattern
    triggerHapticFeedback();
    assert.deepEqual(calls[2], [50, 30, 50]);
  } finally {
    globalThis.navigator = originalNavigator;
  }
});

test('triggerHapticFeedback catches and suppresses vibrate exceptions', () => {
  const originalNavigator = globalThis.navigator;

  try {
    // @ts-expect-error - mock throwing navigator
    globalThis.navigator = {
      vibrate() {
        throw new Error('User activation required');
      },
    };

    assert.doesNotThrow(() => {
      triggerHapticFeedback('permissionRequested');
    });
  } finally {
    globalThis.navigator = originalNavigator;
  }
});
