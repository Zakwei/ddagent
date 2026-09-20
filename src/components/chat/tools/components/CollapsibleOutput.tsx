import React, { useState, useMemo } from 'react';
import { ChevronDown } from 'lucide-react';

import { cn } from '../../../../lib/utils';
import { getToolExpansion, setToolExpansion } from '../../utils/toolExpansionState';

export interface CollapsibleOutputProps {
  content: string;
  maxCollapsedLines?: number;
  maxCollapsedChars?: number;
  className?: string;
  preClassName?: string;
  /**
   * Optional persistence key for the expanded state. When provided, the
   * user's expand/collapse choice survives unmount/remount (tile switches,
   * history pagination).
   */
  expandKey?: string | null;
}

export const CollapsibleOutput: React.FC<CollapsibleOutputProps> = ({
  content,
  maxCollapsedLines = 12,
  maxCollapsedChars = 400,
  className = '',
  preClassName = '',
  expandKey = null,
}) => {
  const [isExpanded, setIsExpanded] = useState(() => getToolExpansion(expandKey) ?? false);
  const lines = useMemo(() => content.split('\n'), [content]);
  const isLong = lines.length > maxCollapsedLines || content.length > maxCollapsedChars;

  if (!isLong) {
    return (
      <pre className={cn('whitespace-pre-wrap break-all font-mono text-xs leading-relaxed', preClassName)}>
        {content}
      </pre>
    );
  }

  const remainingLines = lines.length - maxCollapsedLines;
  const displayedContent = isExpanded
    ? content
    : lines.length > maxCollapsedLines
      ? lines.slice(0, maxCollapsedLines).join('\n')
      : content.slice(0, maxCollapsedChars) + '…';

  return (
    <div className={cn('flex flex-col', className)}>
      <pre className={cn('whitespace-pre-wrap break-all font-mono text-xs leading-relaxed', preClassName)}>
        {displayedContent}
      </pre>
      <button
        type="button"
        onClick={(e) => {
          e.stopPropagation();
          setIsExpanded((prev) => {
            const next = !prev;
            setToolExpansion(expandKey, next);
            return next;
          });
        }}
        className="flex w-full items-center justify-center gap-1.5 border-t border-border/40 bg-muted/30 py-1 text-xs font-medium text-muted-foreground transition-colors hover:bg-muted/50 hover:text-foreground"
      >
        <ChevronDown className={cn('h-3.5 w-3.5 transition-transform duration-150', isExpanded && 'rotate-180')} />
        {isExpanded
          ? 'Show less'
          : remainingLines > 0
            ? `Show ${remainingLines} more lines`
            : 'Show more'}
      </button>
    </div>
  );
};
