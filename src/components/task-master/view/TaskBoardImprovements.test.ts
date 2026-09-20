import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

test('Task 51: Kanban Mobile Swipe Carousel in TaskBoardContent', () => {
  const filePath = path.resolve(__dirname, 'TaskBoardContent.tsx');
  const content = fs.readFileSync(filePath, 'utf-8');

  // Check horizontal snap carousel classes
  assert.ok(
    content.includes('snap-x') && content.includes('snap-mandatory') && content.includes('overflow-x-auto') && content.includes('flex-nowrap'),
    'KanbanColumns container should have snap-x, snap-mandatory, overflow-x-auto, and flex-nowrap on mobile',
  );

  // Check scroll-snap-align and responsive column width
  assert.ok(
    content.includes('snap-center') && content.includes('w-[85vw]'),
    'Kanban column cards should include snap-center and w-[85vw] for mobile carousel',
  );

  // Check column indicator segments/dots on mobile
  assert.ok(
    content.includes('scrollToColumn') && content.includes('activeColumnIndex'),
    'KanbanColumns should have scrollToColumn and activeColumnIndex state for mobile indicator segments',
  );
});

test('Task 52: 1-Click Run Task on TaskCard and TaskMasterPanel', () => {
  const cardPath = path.resolve(__dirname, 'TaskCard.tsx');
  const cardContent = fs.readFileSync(cardPath, 'utf-8');

  // Check Play button and onRunTask prop in TaskCard
  assert.ok(
    cardContent.includes('onRunTask'),
    'TaskCard should accept onRunTask prop',
  );
  assert.ok(
    cardContent.includes('Play') && cardContent.includes('onRunTask(task)'),
    'TaskCard should render Play button invoking onRunTask(task)',
  );

  // Check TaskMasterPanel handles task execution and event dispatch
  const panelPath = path.resolve(__dirname, 'TaskMasterPanel.tsx');
  const panelContent = fs.readFileSync(panelPath, 'utf-8');
  assert.ok(
    panelContent.includes('handleRunTask') && panelContent.includes('taskmaster:run-task'),
    'TaskMasterPanel should implement handleRunTask and dispatch taskmaster:run-task event',
  );
  assert.ok(
    panelContent.includes("status: 'in-progress'"),
    'TaskMasterPanel should update task status to in-progress',
  );
});

test('Task 53: Compact To-Do View in TaskBoardToolbar and TaskBoardContent', () => {
  const toolbarPath = path.resolve(__dirname, 'TaskBoardToolbar.tsx');
  const toolbarContent = fs.readFileSync(toolbarPath, 'utf-8');

  // Check LayoutGrid vs List view toggle icons in toolbar
  assert.ok(
    toolbarContent.includes('LayoutGrid') && toolbarContent.includes('List'),
    'TaskBoardToolbar should have LayoutGrid and List view toggle icons',
  );

  const contentPath = path.resolve(__dirname, 'TaskBoardContent.tsx');
  const content = fs.readFileSync(contentPath, 'utf-8');

  // Check compact list view rendering
  assert.ok(
    content.includes('CompactTaskRow') && content.includes("viewMode === 'list'"),
    'TaskBoardContent should render CompactTaskRow when viewMode is list',
  );

  // Check dense row elements: status indicator, task id, title, priority badge, quick action
  assert.ok(
    content.includes('handleToggleStatus') && content.includes('task.priority') && content.includes('onRunTask'),
    'CompactTaskRow should include status toggle, priority badge, and quick action',
  );
});
