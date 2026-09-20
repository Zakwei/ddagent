import { useCallback, useRef } from 'react';

import { api } from '../utils/api';
import type { Project } from '../types/app';

type FileNode = {
  type: 'file' | 'directory';
  name: string;
  path: string;
  children?: FileNode[];
};

type FlatFile = {
  name: string;
  path: string;
};

// `diffInfo` is intentionally `any` so this resolver can wrap editor handlers
// that expect a concrete diff payload type as well as generic callers. The
// optional `projectId` tells the editor which workspace the file belongs to.
type OnFileOpen = (filePath: string, diffInfo?: any, line?: number, projectId?: string | null) => void;

// Resolved opener: like OnFileOpen, but the optional `project` overrides which
// workspace's file tree the reference is matched against (per-pane opens).
type ResolvedFileOpen = (
  filePath: string,
  diffInfo?: any,
  line?: number,
  project?: Project | null,
) => void;

const normalize = (value: string): string => value.replace(/\\/g, '/');

const flatten = (nodes: FileNode[], out: FlatFile[]): void => {
  for (const node of nodes) {
    if (node.type === 'file') {
      out.push({ name: node.name, path: node.path });
    } else if (node.children && node.children.length > 0) {
      flatten(node.children, out);
    }
  }
};

// References inside chat messages are often bare basenames (`foo.ts`) or partial
// paths (`utils/foo.ts`) rather than full paths, so match by path suffix and
// fall back to filename equality.
const findBestMatch = (files: FlatFile[], ref: string): string | null => {
  const target = normalize(ref).replace(/^\.\//, '').replace(/^\/+/, '');
  if (!target) {
    return null;
  }

  const suffixMatch = files.find((file) => {
    const filePath = normalize(file.path);
    return filePath === target || filePath.endsWith(`/${target}`);
  });
  if (suffixMatch) {
    return suffixMatch.path;
  }

  const base = target.split('/').pop() || target;
  return files.find((file) => file.name === base)?.path ?? null;
};

/**
 * Wraps an `onFileOpen` handler so a possibly bare/partial file reference is
 * resolved against the project's file tree (cached per project) before the file
 * is opened in the in-app editor.
 */
export function useFileOpenResolver(
  selectedProject: Project | null | undefined,
  onFileOpen: OnFileOpen,
): ResolvedFileOpen {
  const projectId = selectedProject?.projectId;
  const cacheRef = useRef<{ projectId?: string; files: Promise<FlatFile[]> | null }>({
    projectId: undefined,
    files: null,
  });

  const loadFiles = useCallback(
    (forProjectId: string | null | undefined): Promise<FlatFile[]> => {
      if (!forProjectId) {
        return Promise.resolve([]);
      }
      if (cacheRef.current.projectId === forProjectId && cacheRef.current.files) {
        return cacheRef.current.files;
      }

      const filesPromise = (async () => {
        try {
          const response = await api.getFiles(forProjectId);
          if (!response.ok) {
            return [];
          }
          const data = await response.json();
          const tree: FileNode[] = Array.isArray(data) ? data : [];
          const flat: FlatFile[] = [];
          flatten(tree, flat);
          return flat;
        } catch {
          return [];
        }
      })();

      cacheRef.current = { projectId: forProjectId, files: filesPromise };
      return filesPromise;
    },
    [],
  );

  return useCallback(
    (filePath: string, diffInfo?: any, line?: number, project?: Project | null) => {
      const ref = normalize(filePath).trim();
      // A pane passes its own project so a file link resolves against the
      // workspace it was written in; otherwise the selected project applies.
      const targetProjectId = project?.projectId ?? projectId;
      void loadFiles(targetProjectId).then((files) => {
        const match = findBestMatch(files, ref);
        onFileOpen(match ?? filePath, diffInfo, line, targetProjectId);
      });
    },
    [loadFiles, onFileOpen, projectId],
  );
}
