import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Folder } from 'lucide-react';

import { ActionMenu, Button, type ActionMenuItem } from '../../../shared/view/ui';
import MobileMenuButton from '../../main-content/view/subcomponents/MobileMenuButton';
import { useEditorSidebar } from '../../code-editor/hooks/useEditorSidebar';
import EditorSidebar from '../../code-editor/view/EditorSidebar';
import { CollapsibleSection } from '../../chat/tools/components/CollapsibleSection';
import { cn } from '../../../lib/utils';
import type { Project } from '../../../types/app';

import FileTree from './FileTree';

const ALL_WORKSPACES_ID = '__all__';

type FilesPageProps = {
  projects: Project[];
  selectedProject: Project | null;
  isMobile?: boolean;
  onMenuClick?: () => void;
};

/**
 * Full-page files view. Like the agent board and source control it owns the
 * whole workspace pane and keeps its own workspace selection, so browsing files
 * here never rewrites the global project selection. It can also show every
 * workspace at once through the `__all__` sentinel.
 */
export default function FilesPage({ projects, selectedProject, isMobile, onMenuClick }: FilesPageProps) {
  const { t } = useTranslation('common');
  const navigate = useNavigate();
  const [projectId, setProjectId] = useState<string>(selectedProject?.projectId ?? ALL_WORKSPACES_ID);

  useEffect(() => {
    setProjectId((current) => {
      if (current === ALL_WORKSPACES_ID) {
        return current;
      }
      if (current && projects.some((project) => project.projectId === current)) {
        return current;
      }
      return selectedProject?.projectId ?? ALL_WORKSPACES_ID;
    });
  }, [projects, selectedProject?.projectId]);

  const isAllWorkspaces = projectId === ALL_WORKSPACES_ID;
  const activeProject = projects.find((project) => project.projectId === projectId) ?? null;

  // The editor hook binds the projectId at open time, so track which project
  // owns the open file and defer the open until that project is selected.
  const [editorProjectId, setEditorProjectId] = useState<string | null>(null);
  const pendingOpenRef = useRef<{ path: string; line?: number } | null>(null);
  const editorProject = projects.find((project) => project.projectId === editorProjectId) ?? null;

  useEffect(() => {
    if (!isAllWorkspaces) {
      setEditorProjectId(activeProject?.projectId ?? null);
    }
  }, [isAllWorkspaces, activeProject?.projectId]);

  const {
    editingFile,
    editorWidth,
    editorExpanded,
    hasManualWidth,
    resizeHandleRef,
    handleFileOpen,
    handleCloseEditor,
    handleToggleEditorExpand,
    handleResizeStart,
  } = useEditorSidebar({
    selectedProject: editorProject,
    isMobile: Boolean(isMobile),
  });

  const handleOpenFileForProject = useCallback(
    (project: Project | null, path: string, line?: number) => {
      const targetId = project?.projectId ?? null;
      if (editorProjectId === targetId) {
        handleFileOpen(path, undefined, line);
        return;
      }
      pendingOpenRef.current = { path, line };
      setEditorProjectId(targetId);
    },
    [editorProjectId, handleFileOpen],
  );

  useEffect(() => {
    const pending = pendingOpenRef.current;
    if (!pending) {
      return;
    }
    pendingOpenRef.current = null;
    handleFileOpen(pending.path, undefined, pending.line);
  }, [editorProjectId, handleFileOpen]);

  const projectMenuItems = useMemo<ActionMenuItem[]>(
    () => [
      {
        key: ALL_WORKSPACES_ID,
        label: t('fileTree.allWorkspaces', 'All workspaces'),
        onSelect: () => setProjectId(ALL_WORKSPACES_ID),
      },
      ...projects.map((project) => ({
        key: project.projectId,
        label: project.displayName || project.projectId,
        description: project.fullPath,
        onSelect: () => setProjectId(project.projectId),
      })),
    ],
    [projects, t],
  );

  const menuLabel = isAllWorkspaces
    ? t('fileTree.allWorkspaces', 'All workspaces')
    : activeProject?.displayName || activeProject?.projectId || t('tabs.files', 'Files');

  const emptyState = (
    <div className="flex flex-1 flex-col items-center justify-center gap-2 p-8 text-center">
      <Folder className="h-8 w-8 text-muted-foreground" />
      <p className="text-sm font-medium text-foreground">{t('fileTree.noProject', 'Add a project first')}</p>
    </div>
  );

  return (
    <div className="flex h-full flex-col overflow-hidden">
      <div className="flex flex-shrink-0 items-center gap-2 border-b border-border/60 px-3 py-1.5">
        {isMobile && onMenuClick && <MobileMenuButton onMenuClick={onMenuClick} compact />}
        <Button variant="ghost" size="sm" onClick={() => navigate('/')}>
          <ArrowLeft />
          <span className="hidden sm:inline">{t('quota.backToChat', 'Back to chat')}</span>
        </Button>

        <div className="flex items-center gap-1.5">
          <Folder className="h-4 w-4 text-muted-foreground" />
          <span className="text-sm font-semibold text-foreground">{t('tabs.files', 'Files')}</span>
        </div>

        <ActionMenu
          label={menuLabel}
          icon={Folder}
          items={projectMenuItems}
          variant="ghost"
          size="sm"
          portal
          header={<span className="text-xs text-muted-foreground">{t('tabs.files', 'Files')}</span>}
          triggerClassName="h-7 max-w-full gap-1 px-2 font-semibold text-foreground"
        />
      </div>

      {isAllWorkspaces ? (
        projects.length === 0 ? (
          emptyState
        ) : (
          <div className="flex min-h-0 flex-1">
            <div className="min-w-0 flex-1 overflow-y-auto px-2 py-2">
              <div className={cn('space-y-2', isMobile && 'space-y-3')}>
                {projects.map((project, index) => (
                  <CollapsibleSection
                    key={project.projectId}
                    title={project.displayName || project.projectId}
                    open={index === 0}
                  >
                    <div className="h-[60vh] min-h-[320px]">
                      <FileTree
                        selectedProject={project}
                        onFileOpen={(path, line) => handleOpenFileForProject(project, path, line)}
                      />
                    </div>
                  </CollapsibleSection>
                ))}
              </div>
            </div>

            <EditorSidebar
              editingFile={editingFile}
              isMobile={Boolean(isMobile)}
              editorExpanded={editorExpanded}
              editorWidth={editorWidth}
              hasManualWidth={hasManualWidth}
              resizeHandleRef={resizeHandleRef}
              onResizeStart={handleResizeStart}
              onCloseEditor={handleCloseEditor}
              onToggleEditorExpand={handleToggleEditorExpand}
              projectPath={editorProject?.path}
              fillSpace
            />
          </div>
        )
      ) : activeProject ? (
        <div className="flex min-h-0 flex-1">
          <div className="min-w-0 flex-1 overflow-hidden">
            <FileTree
              key={activeProject.projectId}
              selectedProject={activeProject}
              onFileOpen={(path, line) => handleOpenFileForProject(activeProject, path, line)}
            />
          </div>

          <EditorSidebar
            editingFile={editingFile}
            isMobile={Boolean(isMobile)}
            editorExpanded={editorExpanded}
            editorWidth={editorWidth}
            hasManualWidth={hasManualWidth}
            resizeHandleRef={resizeHandleRef}
            onResizeStart={handleResizeStart}
            onCloseEditor={handleCloseEditor}
            onToggleEditorExpand={handleToggleEditorExpand}
            projectPath={activeProject.path}
            fillSpace
          />
        </div>
      ) : (
        emptyState
      )}
    </div>
  );
}
