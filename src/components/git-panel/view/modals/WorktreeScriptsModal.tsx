import { X } from 'lucide-react';
import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';

import type { WorktreeScriptsConfig } from '../../hooks/useWorktreeScripts';

type WorktreeScriptsModalProps = {
  isOpen: boolean;
  config: WorktreeScriptsConfig | null;
  isSaving: boolean;
  onClose: () => void;
  onSave: (config: { setup: string | null; run: string | null; runPort: number | null }) => Promise<void>;
};

/**
 * Editor for the repo's worktree scripts (`.ddagent/worktree.json` semantics,
 * stored as a project override): setup runs after every worktree create/open,
 * run is the on-demand dev server.
 */
export default function WorktreeScriptsModal({
  isOpen,
  config,
  isSaving,
  onClose,
  onSave,
}: WorktreeScriptsModalProps) {
  const { t } = useTranslation('common');
  const [setup, setSetup] = useState('');
  const [run, setRun] = useState('');
  const [runPort, setRunPort] = useState('');
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (isOpen) {
      setSetup(config?.setup ?? '');
      setRun(config?.run ?? '');
      setRunPort(config?.runPort != null ? String(config.runPort) : '');
      setError(null);
    }
  }, [isOpen, config]);

  if (!isOpen) return null;

  const handleSave = async () => {
    setError(null);
    const port = runPort.trim() === '' ? null : Number(runPort);
    if (port !== null && (!Number.isInteger(port) || port < 1 || port > 65535)) {
      setError(t('gitPanel.worktreeScripts.invalidPort', 'Port must be between 1 and 65535'));
      return;
    }
    try {
      await onSave({
        setup: setup.trim() || null,
        run: run.trim() || null,
        runPort: port,
      });
      onClose();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'save failed');
    }
  };

  const sourceHint = config?.hasProjectOverride
    ? t('gitPanel.worktreeScripts.sourceProject', 'Saved as a project override')
    : config?.hasRepoFile
      ? t('gitPanel.worktreeScripts.sourceFile', 'From .ddagent/worktree.json — saving creates a project override')
      : t('gitPanel.worktreeScripts.sourceNone', 'Nothing configured yet');

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 p-4" onClick={onClose}>
      <div
        className="w-full max-w-lg rounded-xl border border-border bg-card shadow-xl"
        onClick={(event) => event.stopPropagation()}
      >
        <div className="flex items-center justify-between border-b border-border/60 px-4 py-3">
          <h3 className="text-sm font-semibold">
            {t('gitPanel.worktreeScripts.title', 'Worktree scripts')}
          </h3>
          <button onClick={onClose} className="rounded p-1 text-muted-foreground hover:bg-accent hover:text-foreground">
            <X className="h-4 w-4" />
          </button>
        </div>

        <div className="space-y-3 px-4 py-3">
          <p className="text-xs text-muted-foreground">{sourceHint}</p>

          <label className="block">
            <span className="mb-1 block text-xs font-medium text-muted-foreground">
              {t('gitPanel.worktreeScripts.setup', 'Setup script (runs after create/open)')}
            </span>
            <textarea
              value={setup}
              onChange={(event) => setSetup(event.target.value)}
              rows={2}
              placeholder="npm install"
              className="w-full resize-y rounded-md border border-border/60 bg-background px-2.5 py-1.5 font-mono text-xs outline-none focus:ring-1 focus:ring-primary/40"
            />
          </label>

          <label className="block">
            <span className="mb-1 block text-xs font-medium text-muted-foreground">
              {t('gitPanel.worktreeScripts.runScript', 'Run script (dev server, on demand)')}
            </span>
            <textarea
              value={run}
              onChange={(event) => setRun(event.target.value)}
              rows={2}
              placeholder="npm run dev"
              className="w-full resize-y rounded-md border border-border/60 bg-background px-2.5 py-1.5 font-mono text-xs outline-none focus:ring-1 focus:ring-primary/40"
            />
          </label>

          <label className="block">
            <span className="mb-1 block text-xs font-medium text-muted-foreground">
              {t('gitPanel.worktreeScripts.runPort', 'Preview port (optional — auto-detected when empty)')}
            </span>
            <input
              value={runPort}
              onChange={(event) => setRunPort(event.target.value)}
              inputMode="numeric"
              placeholder="5173"
              className="w-32 rounded-md border border-border/60 bg-background px-2.5 py-1.5 font-mono text-xs outline-none focus:ring-1 focus:ring-primary/40"
            />
          </label>

          {error && <p className="text-xs text-destructive">{error}</p>}
        </div>

        <div className="flex justify-end gap-2 border-t border-border/60 px-4 py-3">
          <button
            onClick={onClose}
            className="rounded-md px-3 py-1.5 text-sm text-muted-foreground transition-colors hover:bg-accent hover:text-foreground"
          >
            {t('gitPanel.cancel', 'Cancel')}
          </button>
          <button
            onClick={() => void handleSave()}
            disabled={isSaving}
            className="rounded-md bg-primary/10 px-3 py-1.5 text-sm font-medium text-primary transition-colors hover:bg-primary/20 disabled:opacity-50"
          >
            {isSaving ? t('gitPanel.worktreeScripts.saving', 'Saving…') : t('gitPanel.save', 'Save')}
          </button>
        </div>
      </div>
    </div>
  );
}
