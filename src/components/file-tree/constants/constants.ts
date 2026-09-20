import type { FileTreeViewMode } from '../types/types';

export const FILE_TREE_VIEW_MODE_STORAGE_KEY = 'file-tree-view-mode';

export const FILE_TREE_DEFAULT_VIEW_MODE: FileTreeViewMode = 'detailed';

export const FILE_TREE_VIEW_MODES: FileTreeViewMode[] = ['simple', 'compact', 'detailed'];

export const FILE_TREE_RECENT_ONLY_STORAGE_KEY = 'file-tree-recent-only';

/**
 * Window event asking mounted file trees to refetch. `detail.projectId` scopes
 * the refresh to one project; omitting it refreshes every mounted tree.
 */
export const FILE_TREE_REFRESH_EVENT = 'filetree:refresh';

export type FileTreeRefreshEventDetail = {
  projectId?: string;
  path?: string;
};

/**
 * Window event emitted after a tree delete so an open code editor can drop
 * the affected file instead of keeping a stale (now missing) buffer.
 */
export const EDITOR_FILE_DELETED_EVENT = 'editor:file-deleted';

export type EditorFileDeletedEventDetail = {
  projectId?: string;
  path: string;
  type?: 'file' | 'directory';
};

/**
 * Window event emitted after a tree rename so an open code editor can point
 * its buffer at the new path instead of saving under the old name.
 */
export const EDITOR_FILE_RENAMED_EVENT = 'editor:file-renamed';

export type EditorFileRenamedEventDetail = {
  projectId?: string;
  oldPath: string;
  newPath: string;
};

export const FILE_TREE_RECENT_WINDOW_DAYS = 7;

export const MAX_FILE_UPLOAD_SIZE_MB = 200;

export const MAX_FILE_UPLOAD_SIZE_BYTES = MAX_FILE_UPLOAD_SIZE_MB * 1024 * 1024;

export const MAX_FILE_UPLOAD_SIZE_LABEL = `${MAX_FILE_UPLOAD_SIZE_MB}MB`;

export const MAX_FILE_UPLOAD_COUNT = 20;

export const IMAGE_FILE_EXTENSIONS = new Set([
  'png',
  'jpg',
  'jpeg',
  'gif',
  'svg',
  'webp',
  'ico',
  'bmp',
]);
