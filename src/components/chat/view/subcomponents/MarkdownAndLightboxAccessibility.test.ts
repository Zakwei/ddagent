import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

test('Markdown code block has accessible copy button with Lucide icons and mobile visibility', () => {
  const filePath = path.resolve(__dirname, 'Markdown.tsx');
  const content = fs.readFileSync(filePath, 'utf-8');

  // Check Lucide icon imports
  assert.ok(
    content.includes('Check') && content.includes('Copy') && content.includes("'lucide-react'"),
    'Markdown.tsx must import Check and Copy from lucide-react',
  );

  // Check copy button rendering Lucide icons
  assert.ok(
    content.includes('<Check className="h-4 w-4" />') &&
      content.includes('<Copy className="h-4 w-4" />'),
    'Markdown.tsx must use Lucide Check and Copy icons in the copy button',
  );

  // Check mobile visibility (visible on mobile, hover on desktop)
  assert.ok(
    content.includes('sm:opacity-0') && content.includes('sm:group-hover:opacity-100'),
    'Copy button must use sm:opacity-0 sm:group-hover:opacity-100 to stay visible on mobile',
  );
});

test('ChatMessageImages ImageLightbox implements body scroll-lock and safe-area-inset-top', () => {
  const filePath = path.resolve(__dirname, 'ChatMessageImages.tsx');
  const content = fs.readFileSync(filePath, 'utf-8');

  // Check body scroll lock logic
  assert.ok(
    content.includes("document.body.style.overflow = 'hidden'"),
    'ImageLightbox must lock body scroll when open',
  );
  assert.ok(
    content.includes('document.body.style.overflow = prevOverflow'),
    'ImageLightbox must restore previous body overflow on cleanup',
  );

  // Check safe-area-inset-top on close button
  assert.ok(
    content.includes('safe-area-inset-top'),
    'ImageLightbox close button must handle safe-area-inset-top',
  );
  assert.ok(
    content.includes('top-[calc(1rem_+_env(safe-area-inset-top))]'),
    'ImageLightbox close button must position using top-[calc(1rem_+_env(safe-area-inset-top))]',
  );
});
