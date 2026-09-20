import { useEffect, useMemo, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, GitBranch } from 'lucide-react';

import { ActionMenu, Button, type ActionMenuItem } from '../../../shared/view/ui';
import MobileMenuButton from '../../main-content/view/subcomponents/MobileMenuButton';
import { useEditorSidebar } from '../../code-editor/hooks/useEditorSidebar';
import EditorSidebar from '../../code-editor/view/EditorSidebar';
import type { Project } from '../../../types/app';

import GitPanel from './GitPanel';

type SourceControlPageProps = {
  projects: Project[];
  selectedProject: Project | null;
  isMobile?: boolean;
  onMenuClick?: () => void;
  onProjectsRefresh?: () => void;
};

/**
 * Full-page source control. Like the agent board this view owns the whole
 * workspace pane and keeps its own workspace selection, so switching the
 * repository here never rewrites the global project selection.
 */
export default function SourceControlPage({
  projects,
  selectedProject,
  isMobile,
  onMenuClick,
  onProjectsRefresh,
}: SourceControlPageProps) {
  const { t } = useTranslation('common');
  const navigate = useNavigate();
  const [projectId, setProjectId] = useState<string | null>(selectedProject?.projectId ?? null);

  useEffect(() => {
    setProjectId((current) => {
      if (current && projects.some((project) => project.projectId === current)) {
        return current;
      }
      return selectedProject?.projectId ?? projects[0]?.projectId ?? null;
    });
  }, [projects, selectedProject?.projectId]);

  const activeProject = projects.find((project) => project.projectId === projectId) ?? null;

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
    selectedProject: activeProject,
    isMobile: Boolean(isMobile),
  });

  const projectMenuItems = useMemo<ActionMenuItem[]>(
    () =>
      projects.map((project) => ({
        key: project.projectId,
        label: project.displayName || project.projectId,
        description: project.fullPath,
        onSelect: () => setProjectId(project.projectId),
      })),
    [projects],
  );

  return (
    <div className="flex h-full flex-col overflow-hidden">
      <div className="flex flex-shrink-0 items-center gap-2 border-b border-border/60 px-3 py-1.5">
        {isMobile && onMenuClick && <MobileMenuButton onMenuClick={onMenuClick} compact />}
        <Button variant="ghost" size="sm" onClick={() => navigate('/')}>
          <ArrowLeft />
          <span className="hidden sm:inline">{t('quota.backToChat', 'Back to chat')}</span>
        </Button>

        {activeProject && projectMenuItems.length > 0 && (
          <ActionMenu
            label={activeProject.displayName || activeProject.projectId}
            icon={GitBranch}
            items={projectMenuItems}
            variant="ghost"
            size="sm"
            portal
            header={<span className="text-xs text-muted-foreground">{t('tabs.git', 'Source Control')}</span>}
            triggerClassName="h-7 max-w-full gap-1 px-2 font-semibold text-foreground"
          />
        )}
      </div>

      <div className="flex min-h-0 flex-1">
        <div className="min-w-0 flex-1 overflow-hidden">
          <GitPanel
            selectedProject={activeProject}
            isMobile={isMobile}
            onFileOpen={handleFileOpen}
            onProjectSelect={(project) => setProjectId(project.projectId)}
            onProjectsRefresh={onProjectsRefresh}
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
          projectPath={activeProject?.path}
        />
      </div>
    </div>
  );
}
