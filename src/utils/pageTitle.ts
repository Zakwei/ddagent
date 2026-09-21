import type { ProjectSession } from '../types/app';

const TAB_BASE_TITLE = 'ddagent';

// Preserves alert prefixes owned by other title writers: '[Done] '
// (pageTitleNotification.ts) and '✓ Done! ' (useBackgroundCompletionAlert.ts).
const TAB_ALERT_PREFIX_RE = /^(?:\[Done\] |✓ Done! )*/;

export const getTabTitle = (runningCount: number, currentTitle: string): string => {
  const alertPrefix = currentTitle.match(TAB_ALERT_PREFIX_RE)?.[0] ?? '';
  const base = runningCount > 0 ? `● ${runningCount} · ${TAB_BASE_TITLE}` : TAB_BASE_TITLE;
  return `${alertPrefix}${base}`;
};

export const getSessionTitle = (session: ProjectSession): string => {
  if (session.__provider === 'cursor') {
    return (session.name as string) || 'Untitled Session';
  }

  return (session.summary as string) || 'New Session';
};
