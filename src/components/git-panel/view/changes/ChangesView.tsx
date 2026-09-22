import { GitBranch, GitCommit, Inbox, RefreshCw } from 'lucide-react';
import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { EmptyState } from '../../../../shared/view/ui';
import type { ConfirmationRequest, FileStatusCode, GitCommitSummary, GitDiffMap, GitStatusResponse } from '../../types/types';
import { getAllChangedFiles, hasChangedFiles } from '../../utils/gitPanelUtils';

import CommitComposer from './CommitComposer';
import FileChangeList from './FileChangeList';
import FileStatusLegend from './FileStatusLegend';

type ChangesViewProps = {
  isMobile: boolean;
  projectPath: string;
  gitStatus: GitStatusResponse | null;
  gitDiff: GitDiffMap;
  isLoading: boolean;
  wrapText: boolean;
  recentCommits: GitCommitSummary[];
  onOpenHistory: () => void;
  isCreatingInitialCommit: boolean;
  onWrapTextChange: (wrapText: boolean) => void;
  onCreateInitialCommit: () => Promise<boolean>;
  onOpenFile: (filePath: string) => Promise<void>;
  onDiscardFile: (filePath: string) => Promise<void>;
  onDeleteFile: (filePath: string) => Promise<void>;
  onStageFiles: (files: string[]) => Promise<boolean>;
  onUnstageFiles: (files: string[]) => Promise<boolean>;
  onStageHunks: (filePath: string, hunkIndices: number[]) => Promise<boolean>;
  onUnstageHunks: (filePath: string, hunkIndices: number[]) => Promise<boolean>;
  onGenerateMessage: (files: string[]) => Promise<string | null>;
  onCommitChanges: (message: string, files: string[]) => Promise<boolean>;
  onRequestConfirmation: (request: ConfirmationRequest) => void;
  onExpandedFilesChange: (hasExpandedFiles: boolean) => void;
};

export default function ChangesView({
  isMobile,
  projectPath,
  gitStatus,
  gitDiff,
  isLoading,
  wrapText,
  recentCommits,
  onOpenHistory,
  isCreatingInitialCommit,
  onWrapTextChange,
  onCreateInitialCommit,
  onOpenFile,
  onDiscardFile,
  onDeleteFile,
  onStageFiles,
  onUnstageFiles,
  onStageHunks,
  onUnstageHunks,
  onGenerateMessage,
  onCommitChanges,
  onRequestConfirmation,
  onExpandedFilesChange,
}: ChangesViewProps) {
  const { t } = useTranslation('common');
  const [expandedFiles, setExpandedFiles] = useState<Set<string>>(new Set());
  const [selectedFiles, setSelectedFiles] = useState<Set<string>>(new Set());
  // Stage/unstage calls in flight or queued. While > 0, status refreshes must
  // not overwrite the optimistic selection with a snapshot that predates the
  // later clicks.
  const [pendingStageOps, setPendingStageOps] = useState(0);
  // Serializes stage/unstage requests so rapid toggles cannot interleave on
  // the server or resolve out of order.
  const stageOpQueueRef = useRef<Promise<unknown>>(Promise.resolve());

  const changedFiles = useMemo(() => getAllChangedFiles(gitStatus), [gitStatus]);
  const hasExpandedFiles = expandedFiles.size > 0;

  const enqueueStageOp = useCallback((operation: () => Promise<unknown>) => {
    setPendingStageOps((count) => count + 1);
    stageOpQueueRef.current = stageOpQueueRef.current
      .catch(() => {}) // a failed op must not block the queue
      .then(operation)
      .finally(() => setPendingStageOps((count) => count - 1));
  }, []);

  useEffect(() => {
    if (!gitStatus || gitStatus.error) {
      setSelectedFiles(new Set());
      return;
    }

    if (pendingStageOps > 0) {
      return; // keep the optimistic state until the queued ops settle
    }

    // The Staged section mirrors the real git index reported by /status, so
    // files staged outside the app (VSCode, terminal) show up here too. Also
    // re-runs when the queue drains, syncing to the final refreshed status.
    setSelectedFiles(new Set(gitStatus.staged ?? []));
  }, [gitStatus, pendingStageOps]);

  useEffect(() => {
    onExpandedFilesChange(hasExpandedFiles);
  }, [hasExpandedFiles, onExpandedFilesChange]);

  useEffect(() => {
    return () => {
      onExpandedFilesChange(false);
    };
  }, [onExpandedFilesChange]);

  const toggleFileExpanded = useCallback((filePath: string) => {
    setExpandedFiles((previous) => {
      const next = new Set(previous);
      if (next.has(filePath)) {
        next.delete(filePath);
      } else {
        next.add(filePath);
      }
      return next;
    });
  }, []);

  // Staging is real: every toggle runs git add / git reset through the API.
  // The set is flipped optimistically; the queued API call keeps the git
  // index in sync and the final status refresh re-syncs once the queue drains.
  const toggleFileSelected = useCallback(
    (filePath: string) => {
      const isStaged = selectedFiles.has(filePath);
      setSelectedFiles((previous) => {
        const next = new Set(previous);
        if (isStaged) {
          next.delete(filePath);
        } else {
          next.add(filePath);
        }
        return next;
      });
      enqueueStageOp(() => (isStaged ? onUnstageFiles([filePath]) : onStageFiles([filePath])));
    },
    [enqueueStageOp, onStageFiles, onUnstageFiles, selectedFiles],
  );

  const requestFileAction = useCallback(
    (filePath: string, status: FileStatusCode) => {
      if (status === 'U') {
        onRequestConfirmation({
          type: 'delete',
          message: t('gitPanel.confirmDeleteFile', { file: filePath, defaultValue: 'Delete untracked file "{{file}}"? This action cannot be undone.' }),
          onConfirm: async () => {
            await onDeleteFile(filePath);
          },
        });
        return;
      }

      onRequestConfirmation({
        type: 'discard',
        message: t('gitPanel.confirmDiscardFile', { file: filePath, defaultValue: 'Discard all changes to "{{file}}"? This action cannot be undone.' }),
        onConfirm: async () => {
          await onDiscardFile(filePath);
        },
      });
    },
    [onDeleteFile, onDiscardFile, onRequestConfirmation, t],
  );

  const commitSelectedFiles = useCallback(
    (message: string) => {
      return onCommitChanges(message, Array.from(selectedFiles));
    },
    [onCommitChanges, selectedFiles],
  );

  // Accepting a hunk is an index-only operation, so it bypasses the file-level
  // selection state and just re-syncs status afterwards.
  const acceptHunk = useCallback(
    (filePath: string, hunkIndex: number) => {
      enqueueStageOp(() => onStageHunks(filePath, [hunkIndex]));
    },
    [enqueueStageOp, onStageHunks],
  );

  const revertHunk = useCallback(
    (filePath: string, hunkIndex: number) => {
      enqueueStageOp(() => onUnstageHunks(filePath, [hunkIndex]));
    },
    [enqueueStageOp, onUnstageHunks],
  );

  const generateMessageForSelection = useCallback(
    () => onGenerateMessage(Array.from(selectedFiles)),
    [onGenerateMessage, selectedFiles],
  );

  const unstagedFiles = useMemo(
    () => new Set(changedFiles.filter((f) => !selectedFiles.has(f))),
    [changedFiles, selectedFiles],
  );

  return (
    <>
      <CommitComposer
        isMobile={isMobile}
        projectPath={projectPath}
        selectedFileCount={selectedFiles.size}
        isHidden={hasExpandedFiles}
        hasChanges={hasChangedFiles(gitStatus)}
        onCommit={commitSelectedFiles}
        onGenerateMessage={generateMessageForSelection}
        onRequestConfirmation={onRequestConfirmation}
      />

      {!gitStatus?.error && <FileStatusLegend isMobile={isMobile} />}

      <div className="flex-1 overflow-y-auto">
        {isLoading ? (
          <div className="flex h-32 items-center justify-center">
            <RefreshCw className="h-5 w-5 animate-spin text-muted-foreground" />
          </div>
        ) : gitStatus?.hasCommits === false && hasChangedFiles(gitStatus) ? (
          <EmptyState
            icon={GitBranch}
            title={t('gitPanel.noCommits.title', 'No commits yet')}
            description={t('gitPanel.noCommits.description', "This repository doesn't have any commits yet. Create your first commit to start tracking changes.")}
            action={{
              label: isCreatingInitialCommit ? t('gitPanel.noCommits.creating', 'Creating Initial Commit...') : t('gitPanel.noCommits.create', 'Create Initial Commit'),
              onClick: () => void onCreateInitialCommit(),
              icon: GitCommit,
              loading: isCreatingInitialCommit,
            }}
          />
        ) : !gitStatus || !hasChangedFiles(gitStatus) ? (
          <div className="px-3 py-4">
            <EmptyState size="sm" icon={GitCommit} title={t('gitPanel.noChanges', 'No changes detected')} className="mb-3" />
            {recentCommits.length > 0 && (
              <>
                <div className="mb-1 flex items-center justify-between border-b border-border/60 pb-1.5">
                  <span className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
                    {t('gitPanel.recentCommits', 'Recent commits')}
                  </span>
                  <button
                    onClick={onOpenHistory}
                    className="text-xs text-primary transition-colors hover:text-primary/80"
                  >
                    {t('gitPanel.viewAll', 'View all')}
                  </button>
                </div>
                {recentCommits.slice(0, 5).map((commit) => (
                  <div key={commit.hash} className="flex items-baseline gap-2 py-1 text-sm">
                    <span className="shrink-0 font-mono text-xs text-muted-foreground">
                      {commit.hash.slice(0, 7)}
                    </span>
                    <span className="min-w-0 flex-1 truncate text-foreground" title={commit.message}>
                      {commit.message}
                    </span>
                  </div>
                ))}
              </>
            )}
          </div>
        ) : (
          <div className={isMobile ? 'pb-4' : ''}>
            {/* STAGED section */}
            <div className="flex items-center justify-between border-b border-border/60 bg-muted/30 px-3 py-1.5">
              <span className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
                {t('gitPanel.staged', { count: selectedFiles.size, defaultValue: 'Staged ({{count}})' })}
              </span>
              {selectedFiles.size > 0 && (
                <button
                  onClick={() => {
                    const filesToUnstage = Array.from(selectedFiles);
                    setSelectedFiles(new Set());
                    enqueueStageOp(() => onUnstageFiles(filesToUnstage));
                  }}
                  className="text-xs text-primary transition-colors hover:text-primary/80"
                >
                  {t('gitPanel.unstageAll', 'Unstage All')}
                </button>
              )}
            </div>
            {selectedFiles.size === 0 ? (
              <EmptyState size="sm" icon={Inbox} title={t('gitPanel.noStagedFiles', 'No staged files')} />
            ) : (
              <FileChangeList
                gitStatus={gitStatus}
                gitDiff={gitDiff}
                expandedFiles={expandedFiles}
                selectedFiles={selectedFiles}
                isMobile={isMobile}
                wrapText={wrapText}
                filePaths={selectedFiles}
                onToggleSelected={toggleFileSelected}
                onToggleExpanded={toggleFileExpanded}
                onOpenFile={(filePath) => { void onOpenFile(filePath); }}
                onToggleWrapText={() => onWrapTextChange(!wrapText)}
                onRequestFileAction={requestFileAction}
                hunkAction={{
                  variant: 'remove',
                  title: t('gitPanel.unstageHunk', 'Unstage this hunk'),
                  onAction: revertHunk,
                }}
              />
            )}

            {/* CHANGES section */}
            <div className="flex items-center justify-between border-b border-border/60 bg-muted/30 px-3 py-1.5">
              <span className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
                {t('gitPanel.changesCount', { count: unstagedFiles.size, defaultValue: 'Changes ({{count}})' })}
              </span>
              {unstagedFiles.size > 0 && (
                <button
                  onClick={() => {
                    const filesToStage = Array.from(unstagedFiles);
                    setSelectedFiles(new Set(changedFiles));
                    enqueueStageOp(() => onStageFiles(filesToStage));
                  }}
                  className="text-xs text-primary transition-colors hover:text-primary/80"
                >
                  {t('gitPanel.stageAll', 'Stage All')}
                </button>
              )}
            </div>
            {unstagedFiles.size === 0 ? (
              <div className="px-3 py-2 text-xs italic text-muted-foreground">{t('gitPanel.allStaged', 'All changes staged')}</div>
            ) : (
              <FileChangeList
                gitStatus={gitStatus}
                gitDiff={gitDiff}
                expandedFiles={expandedFiles}
                selectedFiles={selectedFiles}
                isMobile={isMobile}
                wrapText={wrapText}
                filePaths={unstagedFiles}
                onToggleSelected={toggleFileSelected}
                onToggleExpanded={toggleFileExpanded}
                onOpenFile={(filePath) => { void onOpenFile(filePath); }}
                onToggleWrapText={() => onWrapTextChange(!wrapText)}
                onRequestFileAction={requestFileAction}
                hunkAction={{
                  variant: 'add',
                  title: t('gitPanel.stageHunk', 'Stage this hunk'),
                  onAction: acceptHunk,
                }}
              />
            )}
          </div>
        )}
      </div>
    </>
  );
}
