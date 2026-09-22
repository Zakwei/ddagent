import { useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, SquareKanban } from 'lucide-react';

import { Button, EmptyState } from '../../../shared/view/ui';
import MobileMenuButton from '../../main-content/view/subcomponents/MobileMenuButton';
import type { Project } from '../../../types/app';

import KanbanPanel from './KanbanPanel';

type BoardPageProps = {
  projects: Project[];
  selectedProject: Project | null;
  onOpenSession: (sessionId: string) => void;
  isMobile?: boolean;
  onMenuClick?: () => void;
};

/**
 * Full-page agent board. Unlike the per-project tabs this view owns the whole
 * workspace pane because moving a card starts agent sessions of its own, so the
 * project shown here is local state and never rewrites the global selection.
 */
export default function BoardPage({ projects, selectedProject, onOpenSession, isMobile, onMenuClick }: BoardPageProps) {
  const { t } = useTranslation('tasks');
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

  return (
    <div className="flex h-full flex-col overflow-hidden">
      {/* On wide-but-short screens (mobile landscape) the rail's Panel button
          already covers the trip back to chat, so this strip folds away and
          the panel header below becomes the single compact bar. On narrow
          screens it stays — it carries the hamburger. */}
      <div className="flex flex-shrink-0 items-center gap-2 border-b border-border/60 px-3 py-1.5 md:short:hidden">
        {isMobile && onMenuClick && <MobileMenuButton onMenuClick={onMenuClick} compact />}
        <Button variant="ghost" size="sm" onClick={() => navigate('/')}>
          <ArrowLeft />
          {t('board.backToChat', 'Back to chat')}
        </Button>
      </div>

      {!activeProject ? (
        <EmptyState
          icon={SquareKanban}
          title={t('board.empty.title')}
          description={t('board.noProject', 'Add a project first, then create cards for it.')}
          className="flex-1 p-8"
        />
      ) : (
        <KanbanPanel
          selectedProject={activeProject}
          projects={projects}
          isMobile={isMobile}
          onSelectProject={(project) => setProjectId(project.projectId)}
          onOpenSession={onOpenSession}
        />
      )}
    </div>
  );
}
