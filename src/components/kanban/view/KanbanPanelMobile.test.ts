import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Task 271: the agent board stacked all columns vertically on mobile, so users
// scrolled past every stage. Below md the columns now render as a snap
// carousel with a segmented tab bar; the desktop grid is untouched.
test('Task 271: KanbanPanel mobile column tabs + snap carousel', () => {
  const filePath = path.resolve(__dirname, 'KanbanPanel.tsx');
  const content = fs.readFileSync(filePath, 'utf-8');

  // Horizontal snap carousel classes on the column container
  assert.ok(
    content.includes('snap-x') && content.includes('snap-mandatory') && content.includes('overflow-x-auto') && content.includes('flex-nowrap'),
    'Column container should have snap-x, snap-mandatory, overflow-x-auto, and flex-nowrap on mobile',
  );

  // Columns take ~85% of the viewport and snap to center on mobile
  assert.ok(
    content.includes('snap-center') && content.includes('w-[85vw]'),
    'Column wrappers should include snap-center and w-[85vw] for the mobile carousel',
  );

  // Segmented tab bar + scroll tracking state
  assert.ok(
    content.includes('scrollToColumn') && content.includes('activeColumnIndex'),
    'KanbanPanel should have scrollToColumn and activeColumnIndex for the mobile column tabs',
  );

  // Tabs/dots are mobile-only and the desktop grid breakpoints are preserved
  assert.ok(
    content.includes('md:hidden') && content.includes('md:grid-cols-2') && content.includes('xl:grid-cols-6'),
    'Tab bar should be md:hidden and the desktop grid (md/lg/xl) should remain unchanged',
  );
});
