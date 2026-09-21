import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Task 275: nine keys were crammed into ~390px at ~34px each, so the right
// arrow clipped off the screen edge and every key missed the 44px minimum
// touch target (Apple HIG / WCAG 2.5.5). The strip now scrolls horizontally
// with edge-fade cues and >= 44px keys.
test('Task 275: TerminalShortcutsPanel scrollable bar with 44px touch targets', () => {
  const filePath = path.resolve(__dirname, 'TerminalShortcutsPanel.tsx');
  const content = fs.readFileSync(filePath, 'utf-8');

  // Horizontally scrollable strip, same scrollbar-hide pattern as KanbanPanel.
  assert.ok(
    content.includes('overflow-x-auto') && content.includes('scrollbar-hide'),
    'Key strip should scroll horizontally with scrollbar-hide',
  );
  assert.ok(
    content.includes('overscroll-x-contain') &&
      content.includes('[-webkit-overflow-scrolling:touch]'),
    'Key strip should keep momentum touch scrolling and contain overscroll',
  );

  // Every key button meets the 44px minimum touch target.
  assert.ok(
    content.includes('min-w-[44px]') && content.includes('min-h-[44px]'),
    'Key buttons should enforce min-w/min-h of 44px',
  );
  assert.ok(
    content.includes('touch-manipulation'),
    'Key buttons should include touch-manipulation',
  );

  // Scroll cues: edge fades driven by real scroll position, not static chrome.
  assert.ok(
    content.includes('canScrollLeft') && content.includes('canScrollRight') && content.includes('onScroll'),
    'Key strip should track scroll position to drive scroll cues',
  );
  assert.ok(
    content.includes('bg-gradient-to-r') && content.includes('bg-gradient-to-l'),
    'Key strip should render edge-fade gradients as scroll cues',
  );
});
