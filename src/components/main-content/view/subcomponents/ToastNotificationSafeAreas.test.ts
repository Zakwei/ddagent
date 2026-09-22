import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

test('PaneSessionHeader renders Check for success toast and uses safe-area margins', () => {
  const filePath = path.resolve(__dirname, 'PaneSessionHeader.tsx');
  const content = fs.readFileSync(filePath, 'utf-8');

  // Verify Check and X are imported
  assert.ok(
    content.includes('Check') && content.includes('X') && content.includes("'lucide-react'"),
    'PaneSessionHeader must import Check and X from lucide-react',
  );

  // Verify toast conditional icon rendering (Check on success, X on error)
  assert.ok(
    content.includes("toast.type === 'success' ? (") &&
      content.includes('<Check className="h-4 w-4" />') &&
      content.includes('<X className="h-4 w-4" />'),
    'PaneSessionHeader must render Check icon on success and X icon on error',
  );

  // Verify safe area insets on toast container
  assert.ok(
    content.includes('bottom-[calc(1rem_+_env(safe-area-inset-bottom))]') &&
      content.includes('right-[calc(1rem_+_env(safe-area-inset-right))]'),
    'PaneSessionHeader toast container must use safe-area-inset in bottom and right positioning',
  );

  // Verify role="status"
  assert.ok(
    content.includes('role="status"'),
    'PaneSessionHeader toast container must have role="status" for accessibility',
  );
});

test('FileTree toast uses safe-area margins and role="status"', () => {
  const filePath = path.resolve(__dirname, '../../../file-tree/view/FileTree.tsx');
  const content = fs.readFileSync(filePath, 'utf-8');

  // Verify safe area insets
  assert.ok(
    content.includes('bottom-[calc(1rem_+_env(safe-area-inset-bottom))]') &&
      content.includes('right-[calc(1rem_+_env(safe-area-inset-right))]'),
    'FileTree toast container must use safe-area-inset in bottom and right positioning',
  );

  // Verify role="status"
  assert.ok(
    content.includes('role="status"'),
    'FileTree toast container must have role="status" for accessibility',
  );

  // Verify icon condition
  assert.ok(
    content.includes("toast.type === 'success' ? (") &&
      content.includes('<Check className="h-4 w-4" />') &&
      content.includes('<X className="h-4 w-4" />'),
    'FileTree toast must render Check icon on success and X icon on error',
  );
});

test('TaskMasterPanel notification uses safe-area margins and role="status"', () => {
  const filePath = path.resolve(__dirname, '../../../task-master/view/TaskMasterPanel.tsx');
  const content = fs.readFileSync(filePath, 'utf-8');

  // Verify safe area insets
  assert.ok(
    content.includes('bottom-[calc(1rem_+_env(safe-area-inset-bottom))]') &&
      content.includes('right-[calc(1rem_+_env(safe-area-inset-right))]'),
    'TaskMasterPanel prdNotification container must use safe-area-inset in bottom and right positioning',
  );

  // Verify role="status"
  assert.ok(
    content.includes('role="status"'),
    'TaskMasterPanel prdNotification container must have role="status" for accessibility',
  );
});
