import { useEffect, useState } from 'react';

import { api } from '../../../utils/api';
import type { CollabUser, KanbanApiResponse } from '../types';

/**
 * Loads the collaborator list once (assignee pickers, avatar tooltips). The
 * list is small and changes rarely, so a single fetch per mount is enough.
 */
export function useCollabUsers(): CollabUser[] {
  const [users, setUsers] = useState<CollabUser[]>([]);

  useEffect(() => {
    let cancelled = false;
    api.collab
      .users()
      .then(async (response) => {
        const payload = (await response.json()) as KanbanApiResponse<{ users: CollabUser[] }>;
        if (!cancelled && response.ok && payload.success !== false) {
          setUsers(Array.isArray(payload.data?.users) ? payload.data.users : []);
        }
      })
      .catch(() => {
        // The picker degrades to "Unassigned"-only when the list fails to load.
      });
    return () => {
      cancelled = true;
    };
  }, []);

  return users;
}
