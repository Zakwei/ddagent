import assert from 'node:assert/strict';
import test from 'node:test';

import {
  isNearBottom,
  restoreScrollByAnchor,
  restoreScrollPosition,
  shouldPinOnContentGrowth,
  type ScrollRestoreState,
} from './chatScrollAnchoring';

test('isNearBottom returns true when content does not overflow', () => {
  const container = {
    scrollTop: 0,
    scrollHeight: 500,
    clientHeight: 500,
  } as HTMLElement;

  assert.equal(isNearBottom(container), true);
});

test('isNearBottom returns false when user is scrolled near the top even if transcript is short due to collapsed tools', () => {
  // Typical scenario: tools collapsed to 36px each, total scrollable range is only 150px
  const container = {
    scrollTop: 20, // Scrolled near top
    scrollHeight: 750,
    clientHeight: 600, // maxScroll = 150px, distanceFromBottom = 130px (< 200px in old logic!)
  } as HTMLElement;

  // In old logic, 150 - 20 = 130 < 200 returned true!
  // In new logic, scrollTop < 100 and maxScroll > 80 returns false.
  assert.equal(isNearBottom(container), false);
});

test('isNearBottom returns true when user is within 80px of the bottom', () => {
  const container = {
    scrollTop: 550,
    scrollHeight: 1200,
    clientHeight: 600, // maxScroll = 600px, distanceFromBottom = 50px (< 80px)
  } as HTMLElement;

  assert.equal(isNearBottom(container), true);
});

test('isNearBottom returns false when user is scrolled up in a long conversation', () => {
  const container = {
    scrollTop: 200,
    scrollHeight: 1200,
    clientHeight: 600, // maxScroll = 600px, distanceFromBottom = 400px
  } as HTMLElement;

  assert.equal(isNearBottom(container), false);
});

test('restoreScrollPosition restores using connected anchor element offset', () => {
  const container = {
    scrollTop: 50,
    scrollHeight: 2000,
    getBoundingClientRect: () => ({ top: 100, bottom: 600 }),
    querySelector: () => null,
  } as unknown as HTMLElement;

  const mockAnchor = {
    isConnected: true,
    getBoundingClientRect: () => ({ top: 350, bottom: 400 }),
  } as unknown as HTMLElement;

  const state: ScrollRestoreState = {
    height: 1500,
    top: 50,
    anchor: mockAnchor,
    anchorKey: 'msg-1',
    anchorOffset: 50, // previously was at container top + 50 (i.e. 150 on screen)
  };

  // Now anchor is at 350 on screen (container is at 100, so relative is 250).
  // diff = 250 - 50 = +200px.
  const result = restoreScrollPosition(container, state);
  assert.equal(result, true);
  assert.equal(container.scrollTop, 250); // 50 + 200
});

test('restoreScrollPosition finds element by stable anchorKey when original DOM node disconnected due to tool grouping', () => {
  const mockNewToolGroup = {
    isConnected: true,
    getBoundingClientRect: () => ({ top: 400, bottom: 440 }),
  } as unknown as HTMLElement;

  const container = {
    scrollTop: 30,
    scrollHeight: 2200,
    getBoundingClientRect: () => ({ top: 100, bottom: 600 }),
    querySelector: (selector: string) => {
      if (selector.includes('tool-group-end-msg')) {
        return mockNewToolGroup;
      }
      return null;
    },
  } as unknown as HTMLElement;

  const disconnectedAnchor = {
    isConnected: false, // unmounted because React re-keyed the tool group
  } as unknown as HTMLElement;

  const state: ScrollRestoreState = {
    height: 1600,
    top: 30,
    anchor: disconnectedAnchor,
    anchorKey: 'tool-group-end-msg',
    anchorOffset: 40,
  };

  // New element is at 400 on screen (relative offset = 300).
  // diff = 300 - 40 = +260px.
  const result = restoreScrollPosition(container, state);
  assert.equal(result, true);
  assert.equal(container.scrollTop, 290); // 30 + 260
});

test('restoreScrollPosition falls back to height delta if anchor element cannot be found', () => {
  const container = {
    scrollTop: 40,
    scrollHeight: 2500,
    getBoundingClientRect: () => ({ top: 100, bottom: 600 }),
    querySelector: () => null,
  } as unknown as HTMLElement;

  const state: ScrollRestoreState = {
    height: 1800,
    top: 40,
    anchor: null,
    anchorKey: null,
    anchorOffset: null,
  };

  // heightDelta = 2500 - 1800 = +700px.
  const result = restoreScrollPosition(container, state);
  assert.equal(result, true);
  assert.equal(container.scrollTop, 740); // 40 + 700
});

test('restoreScrollByAnchor shifts scrollTop to keep the anchored message in place', () => {
  const container = {
    scrollTop: 50,
    scrollHeight: 2200,
    getBoundingClientRect: () => ({ top: 100, bottom: 600 }),
    querySelector: () => null,
  } as unknown as HTMLElement;

  const anchor = {
    isConnected: true,
    getBoundingClientRect: () => ({ top: 445, bottom: 500 }), // was at 350 → moved +95
  } as unknown as HTMLElement;

  const state: ScrollRestoreState = {
    height: 2000,
    top: 50,
    anchor,
    anchorKey: 'msg-9',
    anchorOffset: 250, // 350 - 100
  };

  assert.equal(restoreScrollByAnchor(container, state), true);
  assert.equal(container.scrollTop, 145); // 50 + 95
});

test('restoreScrollByAnchor leaves scrollTop alone when the anchor did not move (growth below the viewport)', () => {
  const container = {
    scrollTop: 50,
    scrollHeight: 2500, // grew +500 — all below the anchor
    getBoundingClientRect: () => ({ top: 100, bottom: 600 }),
    querySelector: () => null,
  } as unknown as HTMLElement;

  const anchor = {
    isConnected: true,
    getBoundingClientRect: () => ({ top: 350, bottom: 400 }), // same offset as before
  } as unknown as HTMLElement;

  const state: ScrollRestoreState = {
    height: 2000,
    top: 50,
    anchor,
    anchorKey: 'msg-9',
    anchorOffset: 250,
  };

  // restoreScrollPosition's height-delta fallback would wrongly add +500 here;
  // anchor-only restore must no-op.
  assert.equal(restoreScrollByAnchor(container, state), false);
  assert.equal(container.scrollTop, 50);
});

test('restoreScrollByAnchor resolves a re-keyed anchor via data-message-key', () => {
  const regrouped = {
    isConnected: true,
    getBoundingClientRect: () => ({ top: 390, bottom: 430 }),
  } as unknown as HTMLElement;

  const container = {
    scrollTop: 40,
    scrollHeight: 2300,
    getBoundingClientRect: () => ({ top: 100, bottom: 600 }),
    querySelector: (selector: string) =>
      selector.includes('tool-group-end-msg') ? regrouped : null,
  } as unknown as HTMLElement;

  const state: ScrollRestoreState = {
    height: 2100,
    top: 40,
    anchor: { isConnected: false } as HTMLElement,
    anchorKey: 'tool-group-end-msg',
    anchorOffset: 300, // 400 - 100 previously; now 390 - 100 = 290 → delta -10
  };

  assert.equal(restoreScrollByAnchor(container, state), true);
  assert.equal(container.scrollTop, 30); // 40 - 10
});

test('shouldPinOnContentGrowth re-pins when content grows and the user follows the bottom', () => {
  assert.equal(
    shouldPinOnContentGrowth({
      previousHeight: 1000,
      nextHeight: 1400,
      isUserScrolledUp: false,
      isUserInteracting: false,
    }),
    true,
  );
});

test('shouldPinOnContentGrowth keeps the user position when scrolled up or mid-gesture', () => {
  const base = { previousHeight: 1000, nextHeight: 1400 };
  assert.equal(
    shouldPinOnContentGrowth({ ...base, isUserScrolledUp: true, isUserInteracting: false }),
    false,
  );
  assert.equal(
    shouldPinOnContentGrowth({ ...base, isUserScrolledUp: false, isUserInteracting: true }),
    false,
  );
});

test('shouldPinOnContentGrowth ignores shrink (content collapsing above the viewport)', () => {
  assert.equal(
    shouldPinOnContentGrowth({
      previousHeight: 1400,
      nextHeight: 1000,
      isUserScrolledUp: false,
      isUserInteracting: false,
    }),
    false,
  );
});
