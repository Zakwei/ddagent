import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

test('ChatComposer mentions dropdown has mobile touch optimization', () => {
  const filePath = path.resolve(__dirname, 'ChatComposer.tsx');
  const content = fs.readFileSync(filePath, 'utf-8');

  // Check touch-manipulation and min-h-[44px]
  assert.ok(
    content.includes('min-h-[44px]'),
    'ChatComposer mentions dropdown items should include min-h-[44px]',
  );
  assert.ok(
    content.includes('touch-manipulation'),
    'ChatComposer mentions dropdown items should include touch-manipulation',
  );

  // Check smooth mobile scrolling
  assert.ok(
    content.includes('[-webkit-overflow-scrolling:touch]') || content.includes("WebkitOverflowScrolling: 'touch'"),
    'ChatComposer mentions dropdown should support -webkit-overflow-scrolling: touch',
  );

  // Check icons centered and styled
  assert.ok(
    content.includes('FileText') &&
      content.includes('MessageSquare') &&
      content.includes('ListTodo'),
    'ChatComposer mentions dropdown should include FileText, MessageSquare, and ListTodo icons',
  );
});

test('CommandMenu slash command items have mobile touch optimization and alignment', () => {
  const filePath = path.resolve(__dirname, 'CommandMenu.tsx');
  const content = fs.readFileSync(filePath, 'utf-8');

  // Check touch-manipulation and min-h-[44px]
  assert.ok(
    content.includes('min-h-[44px]'),
    'CommandMenu items should include min-h-[44px]',
  );
  assert.ok(
    content.includes('touch-manipulation'),
    'CommandMenu items should include touch-manipulation',
  );

  // Check smooth mobile scrolling
  assert.ok(
    content.includes('[-webkit-overflow-scrolling:touch]') || content.includes("WebkitOverflowScrolling: 'touch'"),
    'CommandMenu should support -webkit-overflow-scrolling: touch',
  );

  // Check metadata badge and alignment
  assert.ok(
    content.includes('command-metadata-badge'),
    'CommandMenu should include command-metadata-badge',
  );
  assert.ok(
    content.includes('items-center'),
    'CommandMenu items should use items-center for vertical alignment',
  );
});

test('PermissionRequestsBanner has sticky bottom bar, touch targets >= 44px, icons, and multi-permission support', () => {
  const filePath = path.resolve(__dirname, 'PermissionRequestsBanner.tsx');
  const content = fs.readFileSync(filePath, 'utf-8');

  // Sticky bottom positioning
  assert.ok(
    content.includes('sticky bottom-0 z-30'),
    'PermissionRequestsBanner should include sticky bottom-0 z-30 for mobile dock',
  );

  // 44px touch targets & touch-manipulation
  assert.ok(
    content.includes('min-h-[44px]'),
    'PermissionRequestsBanner action buttons should include min-h-[44px]',
  );
  assert.ok(
    content.includes('touch-manipulation'),
    'PermissionRequestsBanner action buttons should include touch-manipulation',
  );

  // Clear icons for actions
  assert.ok(
    content.includes('Check') && content.includes('CheckCheck') && content.includes('X'),
    'PermissionRequestsBanner should include Check, CheckCheck, and X icons',
  );

  // Distinct color contrast (green/emerald for Allow, destructive for Deny/Reject)
  assert.ok(
    content.includes('bg-emerald-600'),
    'PermissionRequestsBanner should include green/emerald styling for Allow actions',
  );
  assert.ok(
    content.includes('border-destructive') || content.includes('text-destructive'),
    'PermissionRequestsBanner should include destructive styling for Reject actions',
  );

  // Allow all and count pill for multiple queued requests
  assert.ok(
    content.includes('Allow all'),
    'PermissionRequestsBanner should include Allow all button for queued permissions',
  );
  assert.ok(
    content.includes('queued'),
    'PermissionRequestsBanner should include count pill for queued permissions',
  );
});

test('ToolGroupContainer stays compacted by default with touch optimization', () => {
  const filePath = path.resolve(__dirname, 'ToolGroupContainer.tsx');
  const content = fs.readFileSync(filePath, 'utf-8');

  // Default collapsed state (persisted expansion map falls back to false)
  assert.ok(
    content.includes('?? false'),
    'ToolGroupContainer should default to collapsed (isExpanded = false)',
  );

  // Touch manipulation on button
  assert.ok(
    content.includes('touch-manipulation'),
    'ToolGroupContainer button should include touch-manipulation',
  );
});

test('Tool outputs and diffs auto-collapse long outputs with toggle', () => {
  const collapsiblePath = path.resolve(__dirname, '../../tools/components/CollapsibleOutput.tsx');
  const collapsibleContent = fs.readFileSync(collapsiblePath, 'utf-8');

  // Check 12 lines / 400 chars threshold
  assert.ok(
    collapsibleContent.includes('maxCollapsedLines = 12'),
    'CollapsibleOutput should default to 12 max collapsed lines',
  );
  assert.ok(
    collapsibleContent.includes('maxCollapsedChars = 400'),
    'CollapsibleOutput should default to 400 max collapsed chars',
  );
  assert.ok(
    collapsibleContent.includes('more lines'),
    'CollapsibleOutput should provide "more lines" toggle',
  );

  const diffViewerPath = path.resolve(__dirname, '../../tools/components/ToolDiffViewer.tsx');
  const diffViewerContent = fs.readFileSync(diffViewerPath, 'utf-8');
  assert.ok(
    diffViewerContent.includes('renderedDiffLines.length > 12'),
    'ToolDiffViewer should check for diffs longer than 12 lines',
  );
  assert.ok(
    diffViewerContent.includes('more lines'),
    'ToolDiffViewer should include "more lines" toggle',
  );
});
