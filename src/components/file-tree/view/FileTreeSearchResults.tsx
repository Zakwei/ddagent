import { useTranslation } from 'react-i18next';
import { AlertTriangle, Loader2, Search } from 'lucide-react';

import { cn } from '../../../lib/utils';
import { getFileIconData } from '../constants/fileIcons';
import type { FileTreeContentSearchMatch } from '../types/types';

import FileTreeEmptyState from './FileTreeEmptyState';

type FileTreeSearchResultsProps = {
  results: FileTreeContentSearchMatch[];
  query: string;
  loading: boolean;
  error: string | null;
  onFileOpen: (path: string, line?: number) => void;
  truncated?: boolean;
  regex?: boolean;
};

function escapeHtml(value: string): string {
  return value
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function HighlightedText({
  text,
  query,
  regex,
}: {
  text: string;
  query: string;
  regex?: boolean;
}) {
  const trimmedQuery = query.trim();

  if (!trimmedQuery || trimmedQuery.length < 3 || regex) {
    return (
      <span
        className="block truncate text-[12px] text-muted-foreground"
        dangerouslySetInnerHTML={{ __html: escapeHtml(text) }}
      />
    );
  }

  const escapedQuery = trimmedQuery.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  let parts: string[];

  try {
    parts = text.split(new RegExp(`(${escapedQuery})`, 'gi'));
  } catch {
    return (
      <span
        className="block truncate text-[12px] text-muted-foreground"
        dangerouslySetInnerHTML={{ __html: escapeHtml(text) }}
      />
    );
  }

  return (
    <span className="block truncate text-[12px] text-muted-foreground">
      {parts.map((part, index) =>
        index % 2 === 1 ? (
          <mark
            key={index}
            className="bg-yellow-200 dark:bg-yellow-900"
          >
            {part}
          </mark>
        ) : (
          <span
            key={index}
            dangerouslySetInnerHTML={{ __html: escapeHtml(part) }}
          />
        ),
      )}
    </span>
  );
}

export default function FileTreeSearchResults({
  results,
  query,
  loading,
  error,
  onFileOpen,
  truncated = false,
  regex = false,
}: FileTreeSearchResultsProps) {
  const { t } = useTranslation();

  if (loading) {
    return (
      <div className="flex flex-col items-center justify-center py-8">
        <Loader2 className="h-5 w-5 animate-spin text-muted-foreground" />
        <span className="mt-2 text-sm text-muted-foreground">
          {t('fileTree.searching')}
        </span>
      </div>
    );
  }

  if (error) {
    return (
      <FileTreeEmptyState
        icon={AlertTriangle}
        title={t('fileTree.searchError')}
        description={error}
      />
    );
  }

  if (results.length === 0 && query) {
    return (
      <FileTreeEmptyState
        icon={Search}
        title={t('fileTree.noSearchResults')}
        description={t('fileTree.tryDifferentSearch')}
      />
    );
  }

  if (results.length === 0) {
    return null;
  }

  return (
    <div className="space-y-0.5 py-1">
      {results.map((result) => {
        const filename = result.path.split(/[\\/]/).pop() || result.path;
        const { icon: Icon, color } = getFileIconData(filename);

        return (
          <button
            key={`${result.path}:${result.line}:${result.column}`}
            type="button"
            onClick={() => onFileOpen(result.path, result.line)}
            className="group flex w-full items-start gap-2 rounded-sm px-2 py-[3px] text-left transition-colors hover:bg-accent/60"
            title={result.path}
          >
            <Icon
              className={cn(
                'mt-0.5 h-4 w-4 flex-shrink-0',
                color,
              )}
            />
            <div className="flex min-w-0 flex-1 flex-col gap-0.5">
              <div className="flex items-center gap-1.5">
                <span className="truncate text-[13px] text-foreground/90">
                  {result.path}
                </span>
                <span className="inline-flex h-5 flex-shrink-0 items-center justify-center rounded bg-muted px-1.5 text-[10px] font-medium text-muted-foreground">
                  {result.line}
                </span>
              </div>
              <HighlightedText text={result.text} query={query} regex={regex} />
            </div>
          </button>
        );
      })}

      {truncated && (
        <p className="px-2 pb-1 pt-3 text-center text-xs text-muted-foreground">
          {t('fileTree.resultsTruncated', { count: 100 })}
        </p>
      )}
    </div>
  );
}
