import { useEffect, useState } from 'react';

import { collectExpandedDirectoryPaths, filterFileTree, filterFileTreeByModified } from '../utils/fileTreeUtils';
import type { FileTreeNode } from '../types/types';

type UseFileTreeSearchArgs = {
  files: FileTreeNode[];
  expandDirectories: (paths: string[]) => void;
  recentOnly?: boolean;
};

type UseFileTreeSearchResult = {
  searchQuery: string;
  setSearchQuery: (query: string) => void;
  filteredFiles: FileTreeNode[];
};

export function useFileTreeSearch({
  files,
  expandDirectories,
  recentOnly = false,
}: UseFileTreeSearchArgs): UseFileTreeSearchResult {
  const [searchQuery, setSearchQuery] = useState('');
  const [filteredFiles, setFilteredFiles] = useState<FileTreeNode[]>(files);

  useEffect(() => {
    const query = searchQuery.trim().toLowerCase();
    const base = recentOnly
      ? filterFileTreeByModified(files, Date.now() - 7 * 24 * 60 * 60 * 1000)
      : files;

    if (!query) {
      setFilteredFiles(base);
      return;
    }

    const filtered = filterFileTree(base, query);
    setFilteredFiles(filtered);
    // Keep search results visible by opening every matching ancestor directory once per query update.
    expandDirectories(collectExpandedDirectoryPaths(filtered));
  }, [files, searchQuery, expandDirectories, recentOnly]);

  return {
    searchQuery,
    setSearchQuery,
    filteredFiles,
  };
}
