export interface SearchableMessage {
  text?: string;
  tools?: Array<{ name?: string }>;
}

/** Concatenated text used for transcript search (content + tool names). */
export function getSearchableText(message: SearchableMessage): string {
  const parts: string[] = [];
  if (typeof message.text === 'string' && message.text.length > 0) parts.push(message.text);
  for (const tool of message.tools ?? []) {
    if (tool && typeof tool.name === 'string' && tool.name.length > 0) parts.push(tool.name);
  }
  return parts.join(' ');
}

export function messageMatches(message: SearchableMessage, query: string): boolean {
  if (!query) return true;
  return getSearchableText(message).toLowerCase().includes(query.toLowerCase());
}

export interface SearchIndex {
  /** Indices (into the source array) of matching messages, in order. */
  matchedIndices: number[];
  /** displayIndex -> 1-based match ordinal, for the "n of m" counter. */
  ordinalByIndex: Record<number, number>;
  count: number;
}

/** Case-insensitive index of matching messages; empty query yields an empty index. */
export function buildSearchIndex(messages: SearchableMessage[], query: string): SearchIndex {
  const q = query.trim();
  if (!q) return { matchedIndices: [], ordinalByIndex: {}, count: 0 };
  const matchedIndices: number[] = [];
  const ordinalByIndex: Record<number, number> = {};
  messages.forEach((message, index) => {
    if (messageMatches(message, q)) {
      matchedIndices.push(index);
      ordinalByIndex[index] = matchedIndices.length;
    }
  });
  return { matchedIndices, ordinalByIndex, count: matchedIndices.length };
}

/** Wraps the next active index around the match list (both directions). */
export function stepMatch(current: number, count: number, delta: number): number {
  if (count <= 0) return 0;
  return (current + delta + count) % count;
}

/** Splits text into alternating segments for highlighting (case-insensitive). */
export function splitHighlight(text: string, query: string): Array<{ text: string; isMatch: boolean }> {
  const q = query.trim();
  if (!q) return [{ text, isMatch: false }];
  const escaped = q.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const pattern = new RegExp(`(${escaped})`, 'gi');
  return text.split(pattern).map((part) => ({ text: part, isMatch: part.toLowerCase() === q.toLowerCase() }));
}

/** Finds the message index closest to (and >=) a view offset, for scroll-into-view. */
export function nearestMatchIndex(matchedIndices: number[], activeIndex: number): number | null {
  if (matchedIndices.length === 0) return null;
  const clamped = Math.max(0, Math.min(activeIndex, matchedIndices.length - 1));
  return matchedIndices[clamped];
}
