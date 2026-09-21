import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// subcomponents → view → shell → components → src → repo root.
const repoRoot = path.resolve(__dirname, '../../../../..');
const readSrc = (rel: string) => fs.readFileSync(path.join(repoRoot, rel), 'utf-8');

// Task 276: at 844x390 (mobile landscape) the stacked workspace toolbar, pane
// header, and shell header consumed ~35% of the terminal before content, and
// the accessory key bar vanished because `md:hidden` keys off width. A `short`
// screen (max-height: 450px) now collapses the chrome into a single compact
// icon-only bar and restores the key bar.
test('Task 276: compact headers and restored key bar in mobile landscape', () => {
  const tailwindConfig = readSrc('tailwind.config.js');
  assert.ok(
    tailwindConfig.includes("'max-height: 450px'") ||
      tailwindConfig.includes('"(max-height: 450px)"') ||
      tailwindConfig.includes('(max-height: 450px)'),
    'tailwind.config.js should register a `short` screen for max-height 450px',
  );

  // Key bar: hidden on md+ widths, restored for short viewports, offset past
  // the 48px desktop rail.
  const shortcuts = readSrc(
    'src/components/shell/view/subcomponents/TerminalShortcutsPanel.tsx',
  );
  assert.ok(
    shortcuts.includes('md:hidden') && shortcuts.includes('short:!block'),
    'Shortcuts bar should keep md:hidden but restore with short:!block',
  );
  assert.ok(
    shortcuts.includes('md:left-12'),
    'Shortcuts bar should clear the 48px nav rail on wide screens (md:left-12)',
  );

  // CLI prompt option chips are mobile chrome too — same restore treatment.
  const shell = readSrc('src/components/shell/view/Shell.tsx');
  assert.ok(
    /md:hidden[^}]*short:!block|short:!block/.test(shell),
    'Shell prompt-option overlay should restore in short viewports',
  );

  // ShellHeader becomes the terminal's single ~36px bar: icon-only buttons.
  const shellHeader = readSrc(
    'src/components/shell/view/subcomponents/ShellHeader.tsx',
  );
  assert.ok(
    shellHeader.includes('short:[&_button_span]:hidden'),
    'ShellHeader labels should hide in short viewports (icon-only buttons)',
  );
  assert.ok(
    shellHeader.includes('short:py-1') && shellHeader.includes('short:[&_button]:h-7'),
    'ShellHeader should compact to ~36px (py-1 + h-7 buttons) in short viewports',
  );

  // The workspace toolbar collapses only where the nav rail already exists.
  const controls = readSrc(
    'src/components/main-content/view/subcomponents/SplitWorkspaceControls.tsx',
  );
  assert.ok(
    controls.includes('md:short:hidden'),
    'Workspace toolbar should collapse on wide-but-short viewports (md:short:hidden)',
  );

  // Terminal panes drop the generic title strip; their own header is the bar.
  const grid = readSrc(
    'src/components/main-content/view/subcomponents/SplitWorkspaceGrid.tsx',
  );
  assert.ok(
    grid.includes("pane.kind === 'terminal'") && grid.includes('short:hidden'),
    'Terminal pane header strip should hide in short viewports',
  );
});
