import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { formatTokenCount, getUsedTokens } from './TokenUsageSummary';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

test('MobileComposerActionSheet has correct bottom sheet structure, conventions, and touch optimization', () => {
  const filePath = path.resolve(__dirname, 'MobileComposerActionSheet.tsx');
  assert.ok(fs.existsSync(filePath), 'MobileComposerActionSheet.tsx must exist');

  const content = fs.readFileSync(filePath, 'utf-8');

  // Verify Dialog UI imports
  assert.ok(
    content.includes("from '../../../../shared/view/ui'") &&
      content.includes('Dialog') &&
      content.includes('DialogContent') &&
      content.includes('DialogTitle'),
    'Should import Dialog, DialogContent, DialogTitle from ui',
  );

  // Verify mobile bottom-sheet conventions
  assert.ok(
    content.includes('aria-describedby="mobile-composer-tools-description"'),
    'DialogContent must have aria-describedby for accessibility',
  );
  assert.ok(
    content.includes('wrapperClassName="sm:hidden"'),
    'DialogContent must be scoped to mobile viewports (sm:hidden)',
  );
  assert.ok(
    content.includes('animate-bottom-sheet-content-show'),
    'DialogContent must use bottom sheet animation',
  );
  assert.ok(
    content.includes('rounded-t-2xl') &&
      content.includes('border-x-0') &&
      content.includes('border-b-0') &&
      content.includes('pb-safe-area-inset-bottom'),
    'DialogContent must follow mobile bottom sheet layout classes',
  );

  // Verify drag handle pill
  assert.ok(
    content.includes('mx-auto mb-3 h-1 w-10 rounded-full bg-muted-foreground/30'),
    'Should render top drag handle pill',
  );

  // Verify accessible title and close button
  assert.ok(
    content.includes('<DialogTitle'),
    'Should render DialogTitle header',
  );
  assert.ok(
    content.includes('id="mobile-composer-tools-description"'),
    'Should render description element with matching id',
  );
  assert.ok(
    content.includes('<X className="h-4 w-4" />'),
    'Should render X close button in header',
  );

  // Verify touch target requirements
  assert.ok(
    content.includes('min-h-[48px]'),
    'Action buttons should have touch targets >= 44px (min-h-[48px])',
  );
  assert.ok(
    content.includes('touch-manipulation'),
    'Action buttons should include touch-manipulation',
  );
});

test('MobileComposerActionSheet defines all required action items and handles callbacks', () => {
  const filePath = path.resolve(__dirname, 'MobileComposerActionSheet.tsx');
  const content = fs.readFileSync(filePath, 'utf-8');

  // Attach Files action
  assert.ok(
    content.includes('onAttachFiles()') && content.includes('<Paperclip'),
    'Should include Attach Files action calling onAttachFiles() and closing sheet',
  );

  // Take Photo action
  assert.ok(
    content.includes('onTakePhoto()') && content.includes('<Camera'),
    'Should include Take Photo action calling onTakePhoto() and closing sheet',
  );

  // Slash Commands action with count badge
  assert.ok(
    content.includes('onToggleCommands()') &&
      content.includes('<MessageSquare') &&
      content.includes('slashCommandsCount > 0'),
    'Should include Slash Commands action with count badge when count > 0',
  );

  // Undo Checkpoint action (conditional on checkpoint)
  assert.ok(
    content.includes('hasCheckpoint && onUndoCheckpoint') &&
      content.includes('onUndoCheckpoint()') &&
      content.includes('isCreatingCheckpoint'),
    'Should include Undo Checkpoint action disabled while creating snapshot',
  );

  // Token Usage action
  assert.ok(
    content.includes('onShowTokenUsage') &&
      content.includes('onShowTokenUsage()') &&
      content.includes('<Activity'),
    'Should include Token Usage action calling onShowTokenUsage()',
  );

  // Clear Input action (conditional on input)
  assert.ok(
    content.includes('hasInput && onClearInput') &&
      content.includes('onClearInput()'),
    'Should include Clear Input action when input is non-empty',
  );
});

test('ChatComposer integrates Option C mobile tools button and hides desktop buttons on mobile', () => {
  const composerPath = path.resolve(__dirname, 'ChatComposer.tsx');
  const composerContent = fs.readFileSync(composerPath, 'utf-8');

  // Verify MobileComposerActionSheet import and state
  assert.ok(
    composerContent.includes("import MobileComposerActionSheet from './MobileComposerActionSheet';"),
    'ChatComposer must import MobileComposerActionSheet',
  );
  assert.ok(
    composerContent.includes('const [isMobileToolsOpen, setIsMobileToolsOpen] = useState(false);'),
    'ChatComposer must manage isMobileToolsOpen state',
  );

  // Verify Mobile '+' button in PromptInputTools
  assert.ok(
    composerContent.includes('onClick={() => setIsMobileToolsOpen(true)}') &&
      composerContent.includes('flex sm:hidden') &&
      composerContent.includes('<Plus'),
    'PromptInputTools must render mobile-only Plus button to open sheet',
  );

  // Verify desktop buttons hidden on mobile
  assert.ok(
    composerContent.includes('className="hidden sm:inline-flex"'),
    'PromptInputButton for attachments must be hidden on mobile (hidden sm:inline-flex)',
  );

  // MobileComposerActionSheet rendered
  assert.ok(
    composerContent.includes('<MobileComposerActionSheet') &&
      composerContent.includes('isOpen={isMobileToolsOpen}') &&
      composerContent.includes('onOpenChange={setIsMobileToolsOpen}') &&
      composerContent.includes('onAttachFiles={openAttachmentPicker}') &&
      composerContent.includes('onTakePhoto={() => cameraInputRef.current?.click()}'),
    'MobileComposerActionSheet must be rendered with handlers wired up',
  );
});

test('ComposerModelMenu trigger button width expanded on mobile for readability', () => {
  const modelMenuPath = path.resolve(__dirname, 'ComposerModelMenu.tsx');
  const modelMenuContent = fs.readFileSync(modelMenuPath, 'utf-8');

  // Trigger button width: max-w-36 instead of max-w-20
  assert.ok(
    modelMenuContent.includes('max-w-36') && modelMenuContent.includes('sm:max-w-56'),
    'ComposerModelMenu trigger button should use max-w-36 on mobile so model name is readable',
  );
  assert.ok(
    !modelMenuContent.includes('max-w-20'),
    'ComposerModelMenu should no longer squish model button to max-w-20',
  );
});

test('formatTokenCount correctly formats tokens for display', () => {
  assert.equal(formatTokenCount(0), '0');
  assert.equal(formatTokenCount(-5), '0');
  assert.equal(formatTokenCount(450), '450');
  assert.equal(formatTokenCount(1200), '1.2K');
  assert.equal(formatTokenCount(15000), '15K');
  assert.equal(formatTokenCount(1200000), '1.2M');
  assert.equal(formatTokenCount(15000000), '15M');
});

test('getUsedTokens correctly extracts token usage amounts', () => {
  assert.equal(getUsedTokens(null), 0);
  assert.equal(getUsedTokens(undefined), 0);
  assert.equal(getUsedTokens({ used: 5200 }), 5200);
  assert.equal(getUsedTokens({ inputTokens: 3000, outputTokens: 1200 }), 4200);
  assert.equal(
    getUsedTokens({
      inputTokens: 2000,
      breakdown: { output: 800 },
    }),
    2800,
  );
});
