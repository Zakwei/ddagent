import { useEffect, useRef, useState } from 'react';

import type { Project } from '../../../types/app';
import type { FileTreeContentSearchMatch } from '../types/types';

const SEARCH_LIMIT = 100;
const SEARCH_DEBOUNCE_MS = 300;

type UseFileTreeContentSearchArgs = {
  selectedProject: Project | null;
  query: string;
  enabled: boolean;
  respectGitignore?: boolean;
  regex?: boolean;
};

type UseFileTreeContentSearchResult = {
  results: FileTreeContentSearchMatch[];
  loading: boolean;
  error: string | null;
  truncated: boolean;
};

export function useFileTreeContentSearch({
  selectedProject,
  query,
  enabled,
  respectGitignore = true,
  regex = false,
}: UseFileTreeContentSearchArgs): UseFileTreeContentSearchResult {
  const [results, setResults] = useState<FileTreeContentSearchMatch[]>([]);
  const [truncated, setTruncated] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [debouncedQuery, setDebouncedQuery] = useState(query);

  const abortRef = useRef<AbortController | null>(null);
  const debounceRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  // Debounce the query by 300 ms.
  useEffect(() => {
    if (debounceRef.current) {
      clearTimeout(debounceRef.current);
    }
    debounceRef.current = setTimeout(() => {
      setDebouncedQuery(query);
      debounceRef.current = null;
    }, SEARCH_DEBOUNCE_MS);

    return () => {
      if (debounceRef.current) {
        clearTimeout(debounceRef.current);
        debounceRef.current = null;
      }
    };
  }, [query]);

  // Run the search request when the debounced query or settings change.
  useEffect(() => {
    if (!enabled || !selectedProject || debouncedQuery.trim().length === 0) {
      setResults([]);
      setError(null);
      setTruncated(false);
      setLoading(false);

      if (abortRef.current) {
        abortRef.current.abort();
        abortRef.current = null;
      }
      return;
    }

    setLoading(true);
    setError(null);

    const controller = new AbortController();
    abortRef.current = controller;

    const searchParams = new URLSearchParams({
      q: debouncedQuery.trim(),
      respectGitignore: String(respectGitignore),
      limit: String(SEARCH_LIMIT),
      regex: String(regex),
    });

    const url = `/api/file-tree/projects/${encodeURIComponent(
      selectedProject.projectId,
    )}/search?${searchParams.toString()}`;

    fetch(url, { credentials: 'include', signal: controller.signal })
      .then(async (response) => {
        if (!response.ok) {
          let message = `HTTP ${response.status}`;
          try {
            const body = await response.text();
            if (body) message += `: ${body}`;
          } catch {
            // Ignore parse failure; the status code is enough.
          }
          throw new Error(message);
        }

        const data = (await response.json()) as {
          results: FileTreeContentSearchMatch[];
          truncated?: boolean;
        };

        if (!Array.isArray(data.results)) {
          throw new Error('Invalid response format');
        }

        setResults(data.results);
        setTruncated(Boolean(data.truncated));
        setError(null);
      })
      .catch((err) => {
        if (err instanceof Error && err.name === 'AbortError') {
          return;
        }
        setResults([]);
        setTruncated(false);
        setError(err instanceof Error ? err.message : String(err));
      })
      .finally(() => {
        if (!controller.signal.aborted) {
          setLoading(false);
        }
        if (abortRef.current === controller) {
          abortRef.current = null;
        }
      });

    return () => {
      controller.abort();
      if (abortRef.current === controller) {
        abortRef.current = null;
      }
    };
  }, [enabled, selectedProject, debouncedQuery, respectGitignore, regex]);

  return { results, loading, error, truncated };
}
