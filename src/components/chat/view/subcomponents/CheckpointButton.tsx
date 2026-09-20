import { RotateCcwIcon, CheckIcon } from 'lucide-react';

import { PromptInputButton } from '../../../../shared/view/ui';
import { cn } from '../../../../lib/utils';
import type { UndoState } from '../../hooks/useGitCheckpoints';

interface CheckpointButtonProps {
  /** A snapshot exists and can be restored. */
  hasCheckpoint: boolean;
  isCreatingCheckpoint: boolean;
  undoState: UndoState;
  onUndo: () => void;
  error: string | null;
  className?: string;
}

/**
 * Chat composer control for undoing the last AI run. A working-tree snapshot is
 * taken before each turn (see `useGitCheckpoints`); this button restores it in
 * one click so an unwanted AI change never needs manual git gymnastics.
 */
export default function CheckpointButton({
  hasCheckpoint,
  isCreatingCheckpoint,
  undoState,
  onUndo,
  error,
  className,
}: CheckpointButtonProps) {
  if (!hasCheckpoint && !isCreatingCheckpoint) {
    return null;
  }

  if (undoState === 'restored') {
    return (
      <span
        className={cn(
          'flex h-8 items-center gap-1 rounded-md px-2 text-xs font-medium text-emerald-600 dark:text-emerald-400',
          className
        )}
        title="Last AI run was undone"
      >
        <CheckIcon className="h-3.5 w-3.5" />
        Undone
      </span>
    );
  }

  return (
    <PromptInputButton
      onClick={onUndo}
      disabled={isCreatingCheckpoint || undoState === 'restoring'}
      tooltip={{ content: error ? `Undo failed: ${error}` : 'Undo last AI run' }}
      aria-label="Undo last AI run"
      className={cn('w-auto gap-1 px-2 text-xs text-muted-foreground hover:text-foreground', className)}
    >
      <RotateCcwIcon className={undoState === 'restoring' ? 'animate-spin' : undefined} />
      <span className="hidden sm:inline">
        {undoState === 'restoring' ? 'Undoing…' : 'Undo AI run'}
      </span>
    </PromptInputButton>
  );
}
