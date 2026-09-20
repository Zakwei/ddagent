import { Bot, Gauge, Cpu } from 'lucide-react';
import { useMemo } from 'react';
import { useTranslation } from 'react-i18next';

import { ActionMenu, type ActionMenuItem } from '../../../shared/view/ui';
import { useKanbanBoardConfig } from '../hooks/useKanbanBoardConfig';

type BoardAgentSettingsProps = {
  projectId: string;
  isMobile?: boolean;
};

/**
 * Compact agent picker for a project's board: provider, model and reasoning
 * effort. Values here seed every card started from the board; a card can still
 * override them. Rendered as three small menus so it stays out of the way.
 *
 * On phones the labels do not fit next to the project name, so the triggers
 * collapse to icons (the menu headers keep them self-explanatory).
 */
export default function BoardAgentSettings({ projectId, isMobile = false }: BoardAgentSettingsProps) {
  const { t } = useTranslation('tasks');
  const { config, providers, modelOptions, effortOptions, isLoadingModels, save } =
    useKanbanBoardConfig(projectId);

  const triggerClassName = isMobile
    ? 'h-7 w-7 gap-0 px-0'
    : 'h-7 max-w-[10rem] gap-1 px-2 text-xs font-medium';

  const providerItems = useMemo<ActionMenuItem[]>(
    () =>
      providers.map((provider) => ({
        key: provider,
        label: provider,
        onSelect: () => void save({ provider, model: null, effort: null }),
      })),
    [providers, save],
  );

  const modelItems = useMemo<ActionMenuItem[]>(
    () =>
      modelOptions.map((option) => ({
        key: option.value,
        label: option.label,
        description: option.description,
        onSelect: () => void save({ model: option.value, effort: null }),
      })),
    [modelOptions, save],
  );

  const effortItems = useMemo<ActionMenuItem[]>(
    () =>
      effortOptions.map((option) => ({
        key: option.value,
        label: option.value,
        description: option.description,
        onSelect: () => void save({ effort: option.value }),
      })),
    [effortOptions, save],
  );

  return (
    <div className="flex flex-shrink-0 items-center gap-1">
      <ActionMenu
        label={config.provider ?? t('board.agent.anyProvider', 'Any agent')}
        icon={Bot}
        items={providerItems}
        variant="ghost"
        size="sm"
        portal
        iconOnly={isMobile}
        header={<span className="text-xs text-muted-foreground">{t('board.agent.provider', 'Agent')}</span>}
        triggerClassName={triggerClassName}
      />
      {config.provider && (
        <ActionMenu
          label={config.model ?? t('board.agent.defaultModel', 'Default model')}
          icon={Cpu}
          items={modelItems}
          variant="ghost"
          size="sm"
          portal
          iconOnly={isMobile}
          disabled={isLoadingModels}
          header={<span className="text-xs text-muted-foreground">{t('board.agent.model', 'Model')}</span>}
          searchPlaceholder={t('board.agent.searchModel', 'Search models…')}
          emptyText={t('board.agent.noModels', 'No matching models')}
          triggerClassName={isMobile ? triggerClassName : 'h-7 max-w-[12rem] gap-1 px-2 text-xs font-medium'}
        />
      )}
      {effortItems.length > 0 && (
        <ActionMenu
          label={config.effort ?? t('board.agent.defaultEffort', 'Default')}
          icon={Gauge}
          items={effortItems}
          variant="ghost"
          size="sm"
          portal
          iconOnly={isMobile}
          header={<span className="text-xs text-muted-foreground">{t('board.agent.effort', 'Reasoning')}</span>}
          triggerClassName={isMobile ? triggerClassName : 'h-7 max-w-[9rem] gap-1 px-2 text-xs font-medium'}
        />
      )}
    </div>
  );
}
