export function isOrchestratorSession(session: { provider?: string | null; __provider?: string | null }): boolean {
  return (session.provider ?? session.__provider) === 'orchestrator';
}

export function filterSelectableSessions<T extends { isArchived?: boolean }>(sessions: T[]): T[] {
  return sessions.filter((s) => !s.isArchived);
}

export function hasSelectableOrchestrators<
  T extends { isArchived?: boolean; provider?: string | null; __provider?: string | null },
>(sessions: T[]): boolean {
  return sessions.some((s) => !s.isArchived && isOrchestratorSession(s));
}

export function getSelectAllSessionIds<T extends { id: string; isArchived?: boolean }>(sessions: T[]): string[] {
  return filterSelectableSessions(sessions).map((s) => s.id);
}

export function getSelectOrchestratorSessionIds<
  T extends { id: string; isArchived?: boolean; provider?: string | null; __provider?: string | null },
>(sessions: T[]): string[] {
  return filterSelectableSessions(sessions)
    .filter(isOrchestratorSession)
    .map((s) => s.id);
}
