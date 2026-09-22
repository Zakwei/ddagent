import { useTranslation } from 'react-i18next';
import {
  Activity,
  AudioLines,
  Camera,
  MessageSquare,
  Paperclip,
  RotateCcw,
  X,
} from 'lucide-react';

import { Dialog, DialogContent, DialogTitle } from '../../../../shared/view/ui';
import { cn } from '../../../../lib/utils';

import { formatTokenCount, getUsedTokens } from './TokenUsageSummary';

export interface MobileComposerActionSheetProps {
  isOpen: boolean;
  onOpenChange: (open: boolean) => void;
  onAttachFiles: () => void;
  onTakePhoto: () => void;
  hasAutoRead?: boolean;
  autoReadArmed?: boolean;
  onToggleAutoRead?: () => void;
  slashCommandsCount?: number;
  onToggleCommands: () => void;
  hasCheckpoint?: boolean;
  isCreatingCheckpoint?: boolean;
  onUndoCheckpoint?: () => void;
  tokenUsage?: Record<string, unknown> | null;
  onShowTokenUsage?: () => void;
  hasInput?: boolean;
  onClearInput?: () => void;
}

export default function MobileComposerActionSheet({
  isOpen,
  onOpenChange,
  onAttachFiles,
  onTakePhoto,
  hasAutoRead = false,
  autoReadArmed = false,
  onToggleAutoRead,
  slashCommandsCount = 0,
  onToggleCommands,
  hasCheckpoint = false,
  isCreatingCheckpoint = false,
  onUndoCheckpoint,
  tokenUsage,
  onShowTokenUsage,
  hasInput = false,
  onClearInput,
}: MobileComposerActionSheetProps) {
  const { t } = useTranslation(['chat', 'common']);

  const usedTokens = getUsedTokens(tokenUsage);
  const formattedTokens =
    tokenUsage?.unsupported === true ? 'N/A' : `${formatTokenCount(usedTokens)} tokens`;

  return (
    <Dialog open={isOpen} onOpenChange={onOpenChange}>
      <DialogContent
        aria-describedby="mobile-composer-tools-description"
        wrapperClassName="sm:hidden"
        animationClassName="animate-bottom-sheet-content-show motion-reduce:animate-none"
        className="bottom-0 left-0 top-auto max-h-[85dvh] max-w-none translate-x-0 translate-y-0 overflow-y-auto rounded-b-none rounded-t-2xl border-x-0 border-b-0 px-4 pb-safe-area-inset-bottom pt-3"
      >
        <div className="mx-auto mb-3 h-1 w-10 rounded-full bg-muted-foreground/30" aria-hidden="true" />

        <div className="mb-3 flex items-center justify-between border-b border-border/40 pb-2.5">
          <div>
            <DialogTitle className="not-sr-only text-base font-semibold text-foreground">
              {t('composer.toolsAndActions', { defaultValue: 'Tools & actions' })}
            </DialogTitle>
            <p id="mobile-composer-tools-description" className="text-xs text-muted-foreground">
              {t('composer.toolsAndActionsDesc', { defaultValue: 'Tools and controls for chat composer' })}
            </p>
          </div>
          <button
            type="button"
            onClick={() => onOpenChange(false)}
            className="flex h-11 w-11 items-center justify-center rounded-lg text-muted-foreground transition-colors hover:bg-muted hover:text-foreground touch-manipulation"
            aria-label={t('common.close', { defaultValue: 'Close' })}
          >
            <X className="h-4 w-4" />
          </button>
        </div>

        <div className="space-y-2 pb-2">
          {/* Attach Files */}
          <button
            type="button"
            onClick={() => {
              onOpenChange(false);
              onAttachFiles();
            }}
            className="flex min-h-[48px] w-full items-center gap-3 rounded-xl border border-border bg-muted/35 px-3.5 py-2.5 text-left text-foreground transition-colors active:bg-muted touch-manipulation"
          >
            <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg border border-border/40 bg-background/80 text-foreground">
              <Paperclip className="h-4 w-4" />
            </div>
            <div className="min-w-0 flex-1">
              <p className="truncate text-sm font-medium text-foreground">
                {t('input.attachFiles', { defaultValue: 'Attach files' })}
              </p>
              <p className="truncate text-xs text-muted-foreground">
                {t('input.attachFilesDesc', { defaultValue: 'Upload photos, files, or documents' })}
              </p>
            </div>
          </button>

          {/* Take Photo */}
          <button
            type="button"
            onClick={() => {
              onOpenChange(false);
              onTakePhoto();
            }}
            className="flex min-h-[48px] w-full items-center gap-3 rounded-xl border border-border bg-muted/35 px-3.5 py-2.5 text-left text-foreground transition-colors active:bg-muted touch-manipulation"
          >
            <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg border border-border/40 bg-background/80 text-foreground">
              <Camera className="h-4 w-4" />
            </div>
            <div className="min-w-0 flex-1">
              <p className="truncate text-sm font-medium text-foreground">
                {t('input.takePhoto', { defaultValue: 'Take photo' })}
              </p>
              <p className="truncate text-xs text-muted-foreground">
                {t('input.takePhotoDesc', { defaultValue: 'Use camera to capture photo' })}
              </p>
            </div>
          </button>

          {/* Auto Read-Aloud */}
          {hasAutoRead && onToggleAutoRead && (
            <button
              type="button"
              onClick={() => {
                onOpenChange(false);
                onToggleAutoRead();
              }}
              className={cn(
                'flex min-h-[48px] w-full items-center gap-3 rounded-xl border px-3.5 py-2.5 text-left transition-colors active:bg-muted touch-manipulation',
                autoReadArmed
                  ? 'border-primary/40 bg-primary/10 text-foreground'
                  : 'border-border bg-muted/35 text-foreground'
              )}
            >
              <div
                className={cn(
                  'flex h-9 w-9 shrink-0 items-center justify-center rounded-lg border border-border/40',
                  autoReadArmed ? 'bg-primary/20 text-primary' : 'bg-background/80 text-foreground'
                )}
              >
                <AudioLines className="h-4 w-4" />
              </div>
              <div className="min-w-0 flex-1">
                <p className="truncate text-sm font-medium">
                  {t('voice.autoRead', { defaultValue: 'Read replies aloud' })}
                </p>
                <p className="truncate text-xs text-muted-foreground">
                  {autoReadArmed
                    ? t('voice.autoReadOn', { defaultValue: 'Read replies aloud: on' })
                    : t('voice.autoReadOff', { defaultValue: 'Read replies aloud: off' })}
                </p>
              </div>
            </button>
          )}
          {/* Slash Commands */}
          <button
            type="button"
            onClick={() => {
              onOpenChange(false);
              onToggleCommands();
            }}
            className="flex min-h-[48px] w-full items-center gap-3 rounded-xl border border-border bg-muted/35 px-3.5 py-2.5 text-left text-foreground transition-colors active:bg-muted touch-manipulation"
          >
            <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg border border-border/40 bg-background/80 text-foreground">
              <MessageSquare className="h-4 w-4" />
            </div>
            <div className="min-w-0 flex-1">
              <div className="flex items-center gap-2">
                <p className="truncate text-sm font-medium text-foreground">
                  {t('input.showAllCommands', { defaultValue: 'Slash commands' })}
                </p>
                {slashCommandsCount > 0 && (
                  <span className="flex h-4 min-w-4 items-center justify-center rounded-full bg-primary px-1 text-[10px] font-bold text-primary-foreground">
                    {slashCommandsCount}
                  </span>
                )}
              </div>
              <p className="truncate text-xs text-muted-foreground">
                {t('input.commandsDesc', { defaultValue: 'Explore shortcuts and commands' })}
              </p>
            </div>
          </button>

          {/* Undo Checkpoint */}
          {hasCheckpoint && onUndoCheckpoint && (
            <button
              type="button"
              onClick={() => {
                onOpenChange(false);
                onUndoCheckpoint();
              }}
              disabled={isCreatingCheckpoint}
              className="flex min-h-[48px] w-full items-center gap-3 rounded-xl border border-border bg-muted/35 px-3.5 py-2.5 text-left text-foreground transition-colors active:bg-muted disabled:opacity-50 touch-manipulation"
            >
              <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg border border-border/40 bg-background/80 text-foreground">
                <RotateCcw className={cn('h-4 w-4', isCreatingCheckpoint && 'animate-spin')} />
              </div>
              <div className="min-w-0 flex-1">
                <p className="truncate text-sm font-medium text-foreground">
                  {t('checkpoint.undo', { defaultValue: 'Undo checkpoint' })}
                </p>
                <p className="truncate text-xs text-muted-foreground">
                  {isCreatingCheckpoint
                    ? t('checkpoint.creating', { defaultValue: 'Creating snapshot…' })
                    : t('checkpoint.revertChanges', { defaultValue: 'Revert files to last checkpoint' })}
                </p>
              </div>
            </button>
          )}

          {/* Token Usage */}
          {onShowTokenUsage && (
            <button
              type="button"
              onClick={() => {
                onOpenChange(false);
                onShowTokenUsage();
              }}
              className="flex min-h-[48px] w-full items-center gap-3 rounded-xl border border-border bg-muted/35 px-3.5 py-2.5 text-left text-foreground transition-colors active:bg-muted touch-manipulation"
            >
              <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg border border-border/40 bg-background/80 text-primary">
                <Activity className="h-4 w-4" />
              </div>
              <div className="min-w-0 flex-1">
                <div className="flex items-center gap-2">
                  <p className="truncate text-sm font-medium text-foreground">
                    {t('tokenUsage.title', { defaultValue: 'Token usage' })}
                  </p>
                  <span className="rounded bg-primary/10 px-1.5 py-0.5 text-[11px] font-medium text-primary">
                    {formattedTokens}
                  </span>
                </div>
                <p className="truncate text-xs text-muted-foreground">
                  {t('tokenUsage.desc', { defaultValue: 'View session token consumption' })}
                </p>
              </div>
            </button>
          )}

          {/* Clear input */}
          {hasInput && onClearInput && (
            <button
              type="button"
              onClick={() => {
                onOpenChange(false);
                onClearInput();
              }}
              className="flex min-h-[48px] w-full items-center gap-3 rounded-xl border border-border bg-muted/35 px-3.5 py-2.5 text-left text-foreground transition-colors active:bg-muted touch-manipulation"
            >
              <div className="flex h-9 w-9 shrink-0 items-center justify-center rounded-lg border border-border/40 bg-background/80 text-muted-foreground">
                <X className="h-4 w-4" />
              </div>
              <div className="min-w-0 flex-1">
                <p className="truncate text-sm font-medium text-foreground">
                  {t('input.clearInput', { defaultValue: 'Clear input' })}
                </p>
                <p className="truncate text-xs text-muted-foreground">
                  {t('input.clearInputDesc', { defaultValue: 'Discard current text' })}
                </p>
              </div>
            </button>
          )}
        </div>
      </DialogContent>
    </Dialog>
  );
}
