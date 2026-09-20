export interface ScrollRestoreState {
  height: number;
  top: number;
  anchor: HTMLElement | null;
  anchorKey: string | null;
  anchorOffset: number | null;
}

/**
 * Capture scroll restore state before prepending older messages.
 * Uses both DOM reference and stable message keys to survive tool grouping re-renders.
 */
export function captureScrollRestoreState(container: HTMLElement): ScrollRestoreState {
  const containerBounds = container.getBoundingClientRect();
  const elements = Array.from(container.querySelectorAll<HTMLElement>('.chat-message'));

  // Prefer an anchor element that won't be swallowed or destroyed by tool-group boundary merging:
  // e.g. a user or assistant message, or an existing tool group container.
  const visibleElements = elements.filter((element) => {
    const b = element.getBoundingClientRect();
    return b.bottom >= containerBounds.top + 5 && b.top <= containerBounds.bottom;
  });

  const anchor = visibleElements.find((el) => {
    return !el.classList.contains('tool') || el.hasAttribute('data-last-message-key');
  }) ?? visibleElements[0] ?? elements[0] ?? null;

  const anchorKey = anchor?.getAttribute('data-message-key')
    || anchor?.getAttribute('data-last-message-key')
    || anchor?.getAttribute('data-first-message-key')
    || null;

  return {
    height: container.scrollHeight,
    top: container.scrollTop,
    anchor,
    anchorKey,
    anchorOffset: anchor
      ? anchor.getBoundingClientRect().top - containerBounds.top
      : null,
  };
}

/**
 * Restore scroll position after older messages are prepended.
 * Returns true if scroll was adjusted or validated, or false if DOM has not updated yet.
 */
export function restoreScrollPosition(container: HTMLElement, state: ScrollRestoreState): boolean {
  let targetElement = state.anchor?.isConnected ? state.anchor : null;

  if (!targetElement && state.anchorKey) {
    try {
      const escapedKey = (typeof CSS !== 'undefined' && typeof CSS.escape === 'function')
        ? CSS.escape(state.anchorKey)
        : state.anchorKey.replace(/["\\]/g, '\\$&');
      targetElement = container.querySelector<HTMLElement>(
        `[data-message-key="${escapedKey}"], [data-last-message-key="${escapedKey}"], [data-first-message-key="${escapedKey}"]`
      );
    } catch {
      // Fall back if querySelector throws on exotic key format
    }
  }

  const containerBounds = container.getBoundingClientRect();

  if (targetElement?.isConnected && state.anchorOffset !== null) {
    const nextAnchorOffset = targetElement.getBoundingClientRect().top - containerBounds.top;
    const delta = nextAnchorOffset - state.anchorOffset;
    if (Math.abs(delta) > 0.5) {
      container.scrollTop += delta;
      return true;
    }
    // If the element didn't move AND height didn't grow, the new messages haven't rendered yet
    if (container.scrollHeight > state.height) {
      return true;
    }
    return false;
  }

  if (container.scrollHeight > state.height) {
    const heightDelta = container.scrollHeight - state.height;
    container.scrollTop = state.top + heightDelta;
    return true;
  }

  return false;
}

/**
 * Determine whether the user is following the conversation near the bottom.
 * Guarantees that when the user scrolls near the top (e.g. scrollTop < 100),
 * isNearBottom returns false even if total scrollable height is small (e.g. due to collapsed tools).
 */
export function isNearBottom(container: HTMLElement): boolean {
  const { scrollTop, scrollHeight, clientHeight } = container;
  const maxScroll = scrollHeight - clientHeight;
  if (maxScroll <= 0) return true;
  if (scrollTop < 100 && maxScroll > 80) return false;
  const distanceFromBottom = maxScroll - scrollTop;
  return distanceFromBottom < 80;
}

/**
 * Decide whether content growth should pull the viewport back to the bottom.
 * Growth re-pins only while the user is following the conversation — scrolled
 * away or mid-gesture means their position wins until they return to the bottom.
 */
export function shouldPinOnContentGrowth(args: {
  previousHeight: number;
  nextHeight: number;
  isUserScrolledUp: boolean;
  isUserInteracting: boolean;
}): boolean {
  if (args.nextHeight <= args.previousHeight) return false;
  return !args.isUserScrolledUp && !args.isUserInteracting;
}
