import { useEffect, useMemo, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, ClipboardCheck, Folder } from 'lucide-react';

import { ActionMenu, Button, EmptyState, type ActionMenuItem } from '../../../shared/view/ui';
import MobileMenuButton from '../../main-content/view/subcomponents/MobileMenuButton';
import type { Project } from '../../../types/app';
import { useTaskMaster } from '../context/TaskMasterContext';

import TaskMasterPanel from './TaskMasterPanel';

type TasksPageProps = {
  projects: Project[];
  selectedProject: Project | null;
  isMobile?: boolean;
  onMenuClick?: () => void;
};

/**
 * Full-page TaskMaster view, sitting next to Agent Board in the footer
 * navigation. It owns its workspace selection locally (never rewrites the
 * global project) and pushes that selection into the TaskMaster context, which
 * keys every task request by `projectId`.
 */
export default function TasksPage({ projects, selectedProject, isMobile, onMenuClick }: TasksPageProps) {
  const { t } = useTranslation('tasks');
  const navigate = useNavigate();
  const { setCurrentProject } = useTaskMaster();
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

  useEffect(() => {
    if (activeProject) {
      setCurrentProject?.(activeProject);
    }
  }, [activeProject, setCurrentProject]);

  const projectItems = useMemo<ActionMenuItem[]>(
    () => projects.map((project) => ({
      key: project.projectId,
      label: project.displayName,
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
          {t('board.backToChat', 'Back to chat')}
        </Button>
        {activeProject && projectItems.length > 0 && (
          <ActionMenu
            label={activeProject.displayName}
            items={projectItems}
            icon={Folder}
            variant="ghost"
            portal
            header={<span>{t('board.project', 'Project')}</span>}
            // -ml-2 lives on the wrapper: on the trigger it made max-w-full
            // resolve against the margin-box and clipped ~8px of the label.
            className="-ml-2"
            triggerClassName="h-7 max-w-full gap-1 px-2 font-semibold text-foreground"
          />
        )}
      </div>

      {!activeProject ? (
        <EmptyState
          icon={ClipboardCheck}
          title={t('board.empty.title')}
          description={t('board.noProject', 'Add a project first, then create tasks for it.')}
          className="flex-1 p-8"
        />
      ) : (
        <TaskMasterPanel isVisible onSwitchToChat={() => navigate('/')} />
      )}
    </div>
  );
}
