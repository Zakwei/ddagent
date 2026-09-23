import { Check, FileText } from 'lucide-react';
import { useCallback, useEffect, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { cn } from '../../../lib/utils';
import { authenticatedFetch } from '../../../utils/api';

type SharedNotesPaneProps = {
  /** Project id the shared-context document belongs to. */
  projectId?: string | null;
  isActive?: boolean;
  className?: string;
};

type SharedContextDoc = { content: string; updatedAt: string | null };

/**
 * Editor for the project's `.ddagent/shared-context.md` — the shared memory
 * every session in the project receives prepended to its first message.
 */
const SharedNotesPane = ({ projectId, isActive = false, className }: SharedNotesPaneProps) => {
  const { t } = useTranslation('common');
  const [content, setContent] = useState('');
  const [updatedAt, setUpdatedAt] = useState<string | null>(null);
  const [dirty, setDirty] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const loadedRef = useRef(false);

  const load = useCallback(async () => {
    if (!projectId) return;
    try {
      const response = await authenticatedFetch(`/api/shared-context?project=${encodeURIComponent(projectId)}`);
      const body = await response.json().catch(() => ({}));
      if (!response.ok) throw new Error(body?.error?.message || `status ${response.status}`);
      const doc = body?.data as SharedContextDoc;
      setContent(doc?.content ?? '');
      setUpdatedAt(doc?.updatedAt ?? null);
      setDirty(false);
      setError(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'load failed');
    }
  }, [projectId]);

  useEffect(() => {
    if (loadedRef.current) return;
    loadedRef.current = true;
    void load();
  }, [load]);

  const save = async () => {
    if (!projectId) return;
    setSaving(true);
    setError(null);
    try {
      const response = await authenticatedFetch('/api/shared-context', {
        method: 'PUT',
        body: JSON.stringify({ project: projectId, content }),
      });
      const body = await response.json().catch(() => ({}));
      if (!response.ok) throw new Error(body?.error?.message || `status ${response.status}`);
      setUpdatedAt((body?.data as SharedContextDoc)?.updatedAt ?? null);
      setDirty(false);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'save failed');
    } finally {
      setSaving(false);
    }
  };

  return (
    <div className={cn('flex h-full min-h-0 flex-col overflow-hidden', className)} data-active={isActive}>
      <div className="flex h-9 shrink-0 items-center gap-2 border-b border-border/50 bg-muted/30 px-2">
        <FileText className="h-3.5 w-3.5 shrink-0 text-muted-foreground" />
        <span className="min-w-0 flex-1 truncate text-xs text-muted-foreground">
          {t('sharedNotes.subtitle', {
            defaultValue: 'Shared memory — injected into every session of this project',
          })}
        </span>
        {updatedAt && (
          <span className="shrink-0 text-[10px] text-muted-foreground/70">
            {new Date(updatedAt).toLocaleString()}
          </span>
        )}
        <button
          type="button"
          onClick={() => void save()}
          disabled={!projectId || saving || !dirty}
          className="flex h-6 shrink-0 items-center gap-1 rounded px-2 text-xs text-muted-foreground transition-colors hover:bg-muted hover:text-foreground disabled:opacity-40"
        >
          <Check className="h-3.5 w-3.5" />
          {saving
            ? t('sharedNotes.saving', { defaultValue: 'Saving…' })
            : t('sharedNotes.save', { defaultValue: 'Save' })}
        </button>
      </div>

      {error && (
        <div className="border-b border-destructive/30 bg-destructive/10 px-3 py-1.5 text-xs text-destructive">
          {error}
        </div>
      )}

      {!projectId ? (
        <div className="flex flex-1 items-center justify-center px-4 text-center text-xs text-muted-foreground">
          {t('sharedNotes.noProject', { defaultValue: 'Select a workspace to edit its shared context' })}
        </div>
      ) : (
        <textarea
          value={content}
          onChange={(event) => {
            setContent(event.target.value);
            setDirty(true);
          }}
          placeholder={t('sharedNotes.placeholder', {
            defaultValue: '# Shared context\nConventions, decisions and pointers every agent should know…',
          })}
          className="min-h-0 flex-1 resize-none bg-background px-3 py-2 font-mono text-xs leading-relaxed outline-none"
          spellCheck={false}
        />
      )}
    </div>
  );
};

export default SharedNotesPane;
export { SharedNotesPane };
