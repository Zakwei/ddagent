import React, { useState } from 'react';
import { ChevronRight } from 'lucide-react';

import { copyTextToClipboard } from '../../../../utils/clipboard';
import { Collapsible, CollapsibleTrigger, CollapsibleContent } from '../../../../shared/view/ui';
import { cn } from '../../../../lib/utils';

import { ToolStatusBadge } from './ToolStatusBadge';
import type { ToolStatus } from './ToolStatusBadge';

type ActionType = 'copy' | 'open-file' | 'jump-to-results' | 'none';

// opencode InlineTool glyphs (packages/tui/src/routes/session/index.tsx)
const OC_TOOL_ICONS: Record<string, string> = {
  Bash: '$',
  Glob: '✱',
  Grep: '✱',
  Read: '→',
  Write: '←',
  Edit: '←',
  ApplyPatch: '←',
  WebFetch: '%',
  WebSearch: '◈',
  AskUserQuestion: '→',
};
export const ocToolIcon = (toolName: string) => OC_TOOL_ICONS[toolName] || '⚙';

interface OneLineDisplayProps {
  toolName: string;
  icon?: string;
  label?: string;
  value: string;
  secondary?: string;
  action?: ActionType;
  onAction?: () => void;
  wrapText?: boolean;
  colorScheme?: {
    primary?: string;
    secondary?: string;
    background?: string;
    border?: string;
    icon?: string;
  };
  resultId?: string;
  toolResult?: any;
  toolId?: string;
  status?: ToolStatus;
  showRawParameters?: boolean;
  rawContent?: string;
  resultContent?: React.ReactNode;
  resultOpen?: boolean;
}

/**
 * Unified one-line display for simple tool inputs and results
 * Used by: Bash, Read, Grep/Glob (minimized), TodoRead, etc.
 */
export const OneLineDisplay: React.FC<OneLineDisplayProps> = ({
  toolName,
  label,
  value,
  secondary,
  action = 'none',
  onAction,
  wrapText = false,
  colorScheme = {
    primary: 'text-foreground',
    secondary: 'text-muted-foreground',
    background: '',
    border: 'border-border',
    icon: 'text-muted-foreground',
  },
  toolResult,
  toolId,
  status,
  showRawParameters = false,
  rawContent,
  resultContent,
  resultOpen = false,
}) => {
  const [copied, setCopied] = useState(false);
  const [isResultOpen, setIsResultOpen] = useState(resultOpen);

  const handleAction = async () => {
    if (action === 'copy' && value) {
      const didCopy = await copyTextToClipboard(value);
      if (!didCopy) return;
      setCopied(true);
      setTimeout(() => setCopied(false), 2000);
    } else if (onAction) {
      onAction();
    }
  };

  const renderCopyButton = () => (
    <button
      onClick={handleAction}
      className="ml-1 flex-shrink-0 text-muted-foreground/40 opacity-0 transition-all hover:text-muted-foreground group-hover:opacity-100"
      title="Copy to clipboard"
      aria-label="Copy to clipboard"
    >
      {copied ? (
        <svg className="h-3 w-3 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
        </svg>
      ) : (
        <svg className="h-3 w-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z" />
        </svg>
      )}
    </button>
  );

  const hasResult = resultContent != null;

  const rawParamsElement = showRawParameters && rawContent ? (
    <Collapsible className="mt-2">
      <CollapsibleTrigger className="flex items-center gap-1.5 py-0.5 text-[11px] text-muted-foreground hover:text-foreground">
        <svg
          className="h-2.5 w-2.5 flex-shrink-0 transition-transform duration-150 data-[state=open]:rotate-90"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
        </svg>
        raw params
      </CollapsibleTrigger>
      <CollapsibleContent>
        <pre className="mt-1 overflow-hidden whitespace-pre-wrap break-words rounded border border-border/40 bg-muted p-2 font-mono text-[11px] text-muted-foreground">
          {rawContent}
        </pre>
      </CollapsibleContent>
    </Collapsible>
  ) : null;

  const row = (
    <div className={`oc-tool-row ${colorScheme.background || ''} ${hasResult ? 'cursor-pointer select-none' : ''}`} onClick={hasResult ? () => setIsResultOpen((o) => !o) : undefined}>
      {hasResult && (
        <span className="flex-shrink-0 text-muted-foreground/70" aria-hidden>
          <ChevronRight className={cn('h-3.5 w-3.5 transition-transform duration-150', isResultOpen && 'rotate-90')} />
        </span>
      )}
      <span className="oc-tool-icon" aria-hidden>{ocToolIcon(toolName)}</span>
      {(label || toolName) && (
        <span className="oc-tool-label flex-shrink-0 text-xs">{label || toolName}</span>
      )}
      {value && (action === 'open-file' ? (
        <button
          onClick={(event) => {
            event.stopPropagation();
            handleAction();
          }}
          className="ml-1.5 min-w-0 truncate font-mono text-xs text-primary transition-colors hover:text-primary/80 hover:underline"
          title={typeof value === 'string' ? value : undefined}
        >
          {value}
        </button>
      ) : (
        <span
          className={cn('oc-tool-label ml-1.5 min-w-0 text-xs', isResultOpen || (!hasResult && wrapText) ? 'whitespace-pre-wrap break-all' : 'truncate')}
          title={typeof value === 'string' ? value : undefined}
        >
          {value}
        </span>
      ))}
      {secondary && (
        <span className={`text-[11px] ${colorScheme.secondary} ml-1.5 min-w-0 truncate italic`} title={secondary}>
          {secondary}
        </span>
      )}
      {status && <ToolStatusBadge status={status} className={hasResult ? 'ml-auto' : ''} />}
      {action === 'jump-to-results' && toolResult && (
        <a
          href={`#tool-result-${toolId}`}
          onClick={(event) => event.stopPropagation()}
          className="flex flex-shrink-0 items-center gap-0.5 text-[11px] text-primary transition-colors hover:text-primary/80"
          aria-label="Jump to results"
        >
          <svg className="h-3 w-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
          </svg>
        </a>
      )}
      {action === 'copy' && renderCopyButton()}
    </div>
  );

  if (!hasResult) {
    return rawParamsElement ? (
      <>
        {row}
        {rawParamsElement}
      </>
    ) : row;
  }

  return (
    <Collapsible open={isResultOpen} onOpenChange={setIsResultOpen} className="group my-1 overflow-hidden rounded-lg border border-border/60 bg-muted/40 transition-all duration-200">
      {row}
      <CollapsibleContent>
        <div className="border-t border-border/50 bg-background/50 px-3 py-2">
          {resultContent}
          {rawParamsElement}
        </div>
      </CollapsibleContent>
    </Collapsible>
  );
};
