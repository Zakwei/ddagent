import { useCallback, useEffect, useRef, useState } from 'react';
import type { MouseEvent as ReactMouseEvent } from 'react';

import type { Project } from '../../../types/app';
import {
  EDITOR_FILE_DELETED_EVENT,
  EDITOR_FILE_RENAMED_EVENT,
  type EditorFileDeletedEventDetail,
  type EditorFileRenamedEventDetail,
} from '../../file-tree/constants/constants';
import type { CodeEditorDiffInfo, CodeEditorFile } from '../types/types';

type UseEditorSidebarOptions = {
  selectedProject: Project | null;
  isMobile: boolean;
  initialWidth?: number;
};

const MIN_EDITOR_WIDTH = 450;
const MIN_LEFT_CONTENT_WIDTH = 400;

export const useEditorSidebar = ({
  selectedProject,
  isMobile,
  initialWidth = 600,
}: UseEditorSidebarOptions) => {
  const [editingFile, setEditingFile] = useState<CodeEditorFile | null>(null);
  const [editorWidth, setEditorWidth] = useState(initialWidth);
  const [editorExpanded, setEditorExpanded] = useState(false);
  const [isResizing, setIsResizing] = useState(false);
  const [hasManualWidth, setHasManualWidth] = useState(false);
  const resizeHandleRef = useRef<HTMLDivElement | null>(null);

  const handleFileOpen = useCallback(
    (
      filePath: string,
      diffInfo: CodeEditorDiffInfo | null = null,
      line?: number,
      // Pane-scoped opens (split chat/terminal panes) pass their own projectId
      // so the file resolves against the pane's workspace, not whichever
      // project happens to be selected globally.
      projectId?: string | null,
    ) => {
      const normalizedPath = filePath.replace(/\\/g, '/');
      const fileName = normalizedPath.split('/').pop() || filePath;

      setEditingFile({
        name: fileName,
        path: filePath,
        // DB projectId is forwarded to the editor so it can read/save files
        // via `/api/file-tree/projects/:projectId/file` endpoints.
        projectId: projectId ?? selectedProject?.projectId,
        diffInfo,
        line,
      });
      // Keep editor in split review mode on desktop when opening a review or file
      setEditorExpanded(false);
    },
    [selectedProject?.projectId],
  );

  const handleCloseEditor = useCallback(() => {
    setEditingFile(null);
    setEditorExpanded(false);
  }, []);

  // The file tree broadcasts delete/rename events after filesystem writes so
  // an open editor doesn't keep a stale buffer: drop a deleted file, or repoint
  // the buffer at the new path after a rename (including directory prefixes).
  useEffect(() => {
    const normalize = (path: string) => path.replace(/\\/g, '/').replace(/\/+$/, '');

    const handleFileDeleted = (event: Event) => {
      const detail = (event as CustomEvent<EditorFileDeletedEventDetail>).detail;
      if (!detail?.path) return;
      setEditingFile((current) => {
        if (!current) return current;
        if (detail.projectId && current.projectId && detail.projectId !== current.projectId) {
          return current;
        }
        const deletedPath = normalize(detail.path);
        const openPath = normalize(current.path);
        const removed = detail.type === 'directory'
          ? openPath === deletedPath || openPath.startsWith(`${deletedPath}/`)
          : openPath === deletedPath;
        return removed ? null : current;
      });
    };

    const handleFileRenamed = (event: Event) => {
      const detail = (event as CustomEvent<EditorFileRenamedEventDetail>).detail;
      if (!detail?.oldPath || !detail.newPath) return;
      setEditingFile((current) => {
        if (!current) return current;
        if (detail.projectId && current.projectId && detail.projectId !== current.projectId) {
          return current;
        }
        const oldPath = normalize(detail.oldPath);
        const newPath = normalize(detail.newPath);
        const openPath = normalize(current.path);
        const movedPath = openPath === oldPath
          ? newPath
          : openPath.startsWith(`${oldPath}/`)
            ? `${newPath}${openPath.slice(oldPath.length)}`
            : null;
        if (!movedPath) return current;
        return { ...current, path: movedPath, name: movedPath.split('/').pop() || current.name };
      });
    };

    window.addEventListener(EDITOR_FILE_DELETED_EVENT, handleFileDeleted);
    window.addEventListener(EDITOR_FILE_RENAMED_EVENT, handleFileRenamed);
    return () => {
      window.removeEventListener(EDITOR_FILE_DELETED_EVENT, handleFileDeleted);
      window.removeEventListener(EDITOR_FILE_RENAMED_EVENT, handleFileRenamed);
    };
  }, []);

  const handleToggleEditorExpand = useCallback(() => {
    setEditorExpanded((previous) => !previous);
  }, []);

  const handleResizeStart = useCallback(
    (event: ReactMouseEvent<HTMLDivElement>) => {
      if (isMobile) {
        return;
      }

      // After first drag interaction, the editor width is user-controlled.
      setHasManualWidth(true);
      setIsResizing(true);
      event.preventDefault();
    },
    [isMobile],
  );

  useEffect(() => {
    const handleMouseMove = (event: globalThis.MouseEvent) => {
      if (!isResizing) {
        return;
      }

      // Get the main container (parent of EditorSidebar's parent) that contains both left content and editor
      const editorContainer = resizeHandleRef.current?.parentElement;
      const mainContainer = editorContainer?.parentElement;
      if (!mainContainer) {
        return;
      }

      const containerRect = mainContainer.getBoundingClientRect();
      // Calculate new editor width: distance from mouse to right edge of main container
      const newWidth = containerRect.right - event.clientX;

      const minWidth = MIN_EDITOR_WIDTH;
      const maxWidth = Math.max(minWidth, containerRect.width - MIN_LEFT_CONTENT_WIDTH);

      if (newWidth >= minWidth && newWidth <= maxWidth) {
        setEditorWidth(newWidth);
      }
    };

    const handleMouseUp = () => {
      setIsResizing(false);
    };

    if (isResizing) {
      document.addEventListener('mousemove', handleMouseMove);
      document.addEventListener('mouseup', handleMouseUp);
      document.body.style.cursor = 'col-resize';
      document.body.style.userSelect = 'none';
    }

    return () => {
      document.removeEventListener('mousemove', handleMouseMove);
      document.removeEventListener('mouseup', handleMouseUp);
      document.body.style.cursor = '';
      document.body.style.userSelect = '';
    };
  }, [isResizing]);

  return {
    editingFile,
    editorWidth,
    editorExpanded,
    hasManualWidth,
    resizeHandleRef,
    handleFileOpen,
    handleCloseEditor,
    handleToggleEditorExpand,
    handleResizeStart,
  };
};
