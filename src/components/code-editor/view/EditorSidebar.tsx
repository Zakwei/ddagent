import { useState, useEffect, useRef } from 'react';
import type { MouseEvent, MutableRefObject } from 'react';

import type { CodeEditorFile } from '../types/types';

import CodeEditor from './CodeEditor';

type EditorSidebarProps = {
  editingFile: CodeEditorFile | null;
  isMobile: boolean;
  editorExpanded: boolean;
  editorWidth: number;
  hasManualWidth: boolean;
  resizeHandleRef: MutableRefObject<HTMLDivElement | null>;
  onResizeStart: (event: MouseEvent<HTMLDivElement>) => void;
  onCloseEditor: () => void;
  onToggleEditorExpand: () => void;
  projectPath?: string;
  fillSpace?: boolean;
};

// Minimum width for the left content (file tree, chat, etc.)
const MIN_LEFT_CONTENT_WIDTH = 400;
// Minimum width for the editor sidebar
const MIN_EDITOR_WIDTH = 450;

export default function EditorSidebar({
  editingFile,
  isMobile,
  editorExpanded,
  editorWidth,
  hasManualWidth,
  resizeHandleRef,
  onResizeStart,
  onCloseEditor,
  onToggleEditorExpand,
  projectPath,
  fillSpace,
}: EditorSidebarProps) {
  const [poppedOut, setPoppedOut] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);
  const [effectiveWidth, setEffectiveWidth] = useState(editorWidth);

  // Adjust editor width when container size changes to ensure buttons are always
  // visible. Keeps observing while popped out so the editor can pop back in once
  // the container regains enough room.
  useEffect(() => {
    if (!editingFile || isMobile) return;

    const updateWidth = () => {
      if (!containerRef.current) return;
      const parentElement = containerRef.current.parentElement;
      if (!parentElement) return;

      const containerWidth = parentElement.clientWidth;

      // Calculate maximum allowed editor width
      const minLeftWidth = fillSpace ? 200 : MIN_LEFT_CONTENT_WIDTH;
      const maxEditorWidth = containerWidth - minLeftWidth;

      if (maxEditorWidth < MIN_EDITOR_WIDTH) {
        // Not enough space - pop out the editor so user can still see everything
        setPoppedOut(true);
        return;
      }
      // Enough room again — return to the sidebar layout when popped out.
      if (poppedOut) {
        setPoppedOut(false);
      }
      if (editorWidth > maxEditorWidth) {
        // Editor is too wide - constrain it to ensure left content has space
        setEffectiveWidth(maxEditorWidth);
      } else {
        setEffectiveWidth(Math.max(MIN_EDITOR_WIDTH, editorWidth));
      }
    };

    updateWidth();
    window.addEventListener('resize', updateWidth);

    // Also use ResizeObserver for more accurate detection
    const resizeObserver = new ResizeObserver(updateWidth);
    const parentEl = containerRef.current?.parentElement;
    if (parentEl) {
      resizeObserver.observe(parentEl);
    }

    return () => {
      window.removeEventListener('resize', updateWidth);
      resizeObserver.disconnect();
    };
  }, [editingFile, isMobile, poppedOut, editorWidth, fillSpace]);

  if (!editingFile) {
    return null;
  }

  if (isMobile || poppedOut) {
    return (
      <div ref={containerRef} className="h-full min-w-0 flex-1">
        <CodeEditor
          file={editingFile}
          onClose={() => {
            setPoppedOut(false);
            onCloseEditor();
          }}
          projectPath={projectPath}
          isSidebar={false}
        />
      </div>
    );
  }

  // In files tab, fill the remaining width unless user has dragged manually.
  const useFlexLayout = editorExpanded || (fillSpace && !hasManualWidth);

  return (
    <div ref={containerRef} className={`flex h-full min-w-0 ${editorExpanded ? 'flex-1' : ''}`}>
      {!editorExpanded && (
        <div
          ref={resizeHandleRef}
          onMouseDown={onResizeStart}
          className="group relative w-1 flex-shrink-0 cursor-col-resize bg-gray-200 transition-colors hover:bg-blue-500 dark:bg-gray-700 dark:hover:bg-blue-600"
          title="Drag to resize"
        >
          <div className="absolute inset-y-0 left-1/2 w-1 -translate-x-1/2 bg-blue-500 opacity-0 transition-opacity group-hover:opacity-100 dark:bg-blue-600" />
        </div>
      )}

      <div
        className={`h-full overflow-hidden border-l border-gray-200 dark:border-gray-700 ${useFlexLayout ? 'min-w-0 flex-1' : 'min-w-[450px] flex-shrink-0'}`}
        style={useFlexLayout ? undefined : { width: `${effectiveWidth}px`, minWidth: `${MIN_EDITOR_WIDTH}px` }}
      >
        <CodeEditor
          file={editingFile}
          onClose={onCloseEditor}
          projectPath={projectPath}
          isSidebar
          isExpanded={editorExpanded}
          onToggleExpand={onToggleEditorExpand}
          onPopOut={() => setPoppedOut(true)}
        />
      </div>
    </div>
  );
}
