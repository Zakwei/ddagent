import { useMemo } from 'react';

import { escapeRegExp } from '../../utils/chatFormatting';

interface HighlightTextProps {
  text: string;
  query: string;
  className?: string;
}

export function HighlightText({ text, query, className }: HighlightTextProps) {
  const parts = useMemo(() => {
    if (!query) return [{ text, isMatch: false }];
    const pattern = new RegExp(`(${escapeRegExp(query)})`, 'gi');
    return text.split(pattern).map((part) => ({
      text: part,
      isMatch: part.toLowerCase() === query.toLowerCase(),
    }));
  }, [text, query]);

  return (
    <span className={className}>
      {parts.map((part, i) =>
        part.isMatch ? (
          <mark
            key={i}
            className="rounded bg-amber-200 px-0.5 text-amber-900 dark:bg-amber-500/30 dark:text-amber-100"
          >
            {part.text}
          </mark>
        ) : (
          <span key={i}>{part.text}</span>
        ),
      )}
    </span>
  );
}
