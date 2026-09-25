// Pure scroll/pagination helpers mirroring the web chat scroll behavior.
export const SESSION_MESSAGES_PAGE_SIZE = 40;
export const MIN_VISIBLE_TEXT_MESSAGES = 2;
export const AUTO_LOAD_ALL_THRESHOLD = 1000;
export const NEAR_BOTTOM_PX = 80;
export const NEW_MESSAGE_BADGE_CAP = 99;

export interface ScrollMetrics {
  scrollTop: number;
  contentHeight: number;
  layoutHeight: number;
}

export interface SliceableMessage {
  id?: string;
  role?: string;
  text?: string;
  tools?: { id?: string; name?: string }[];
  isStreaming?: boolean;
}

const isBareToolOrThinking = (message: SliceableMessage): boolean => {
  if (message.role === 'thinking') return true;
  const hasText = Boolean(message.text && message.text.trim());
  const hasTools = Array.isArray(message.tools) && message.tools.length > 0;
  return hasTools && !hasText;
};

export function isNearBottom(metrics: ScrollMetrics, threshold = NEAR_BOTTOM_PX): boolean {
  const { scrollTop, contentHeight, layoutHeight } = metrics;
  const maxScroll = contentHeight - layoutHeight;
  if (maxScroll <= 0) return true;
  if (scrollTop < 100 && maxScroll > threshold) return false;
  return maxScroll - scrollTop < threshold;
}

export function shouldPinOnContentGrowth(args: {
  previousHeight: number;
  nextHeight: number;
  isUserScrolledUp: boolean;
  isUserInteracting?: boolean;
}): boolean {
  const { previousHeight, nextHeight, isUserScrolledUp, isUserInteracting } = args;
  if (nextHeight <= previousHeight) return false;
  return !isUserScrolledUp && !isUserInteracting;
}

export function computeAnchorOffset(args: {
  prevOffset: number;
  prevContentHeight: number;
  nextContentHeight: number;
}): number {
  const growth = Math.max(0, args.nextContentHeight - args.prevContentHeight);
  return args.prevOffset + growth;
}

export function nextVisibleCount(current: number, pageSize = SESSION_MESSAGES_PAGE_SIZE): number {
  if (!Number.isFinite(current)) return pageSize;
  return current + pageSize;
}

export function formatNewMessageBadge(count: number): string {
  if (!Number.isFinite(count) || count <= 0) return '0';
  return count > NEW_MESSAGE_BADGE_CAP ? `${NEW_MESSAGE_BADGE_CAP}+` : String(count);
}

// Mirrors web sliceVisibleMessages: keep the newest `visibleCount` rows, but if
// the window boundary lands on a bare tool/thinking row, walk back to the
// nearest text message so the window does not open mid-tool-run.
export function sliceVisibleMessages<T extends SliceableMessage>(
  messages: T[],
  visibleCount: number,
  minTextMessages = MIN_VISIBLE_TEXT_MESSAGES,
): T[] {
  if (!Number.isFinite(visibleCount) || visibleCount >= messages.length) return messages;
  if (visibleCount <= 0) return [];
  const windowStart = Math.max(0, messages.length - visibleCount);
  let anchorStart = windowStart;
  if (isBareToolOrThinking(messages[windowStart])) {
    let textSeen = 0;
    for (let i = windowStart - 1; i >= 0; i -= 1) {
      if (!isBareToolOrThinking(messages[i])) {
        textSeen += 1;
        anchorStart = i;
        if (textSeen >= minTextMessages) break;
      }
    }
  }
  return messages.slice(Math.min(windowStart, anchorStart));
}

export function shouldAutoLoadAll(args: {
  items: { _isGroup?: boolean }[];
  hasMore: boolean;
  allLoaded: boolean;
  loading: boolean;
  loadingOlder: boolean;
  total: number;
  isUserScrolledUp: boolean;
  threshold?: number;
}): boolean {
  const {
    items,
    hasMore,
    allLoaded,
    loading,
    loadingOlder,
    total,
    isUserScrolledUp,
    threshold = AUTO_LOAD_ALL_THRESHOLD,
  } = args;
  if (!items.length || !hasMore || allLoaded || loading || loadingOlder) return false;
  if (isUserScrolledUp) return false;
  if (Number.isFinite(total) && total > threshold) return false;
  return items.every((item) => Boolean(item._isGroup));
}
