import { useState } from 'react';
import { useTranslation } from 'react-i18next';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, BarChart3, Gauge, LayoutDashboard, MonitorCog, RefreshCw, Settings, Users } from 'lucide-react';

import { Button, Pill, PillBar } from '../../../shared/view/ui';
import { cn } from '../../../lib/utils';
import { usePaletteOps } from '../../../contexts/PaletteOpsContext';
import MobileMenuButton from '../../main-content/view/subcomponents/MobileMenuButton';
import { useQuotaConfig, useQuotaSnapshot } from '../hooks/useQuotaSnapshot';
import type { InsightPeriod } from '../types';

import AgentsPanel from './AgentsPanel';
import OverviewPanel from './OverviewPanel';
import QuotasPanel from './QuotasPanel';
import UsagePanel from './UsagePanel';

type ControlCenterPageProps = {
  isMobile?: boolean;
  onMenuClick?: () => void;
};

/** Sections of the Control Center; the spec's five MVP screens minus Settings. */
type Section = 'overview' | 'quotas' | 'usage' | 'agents';

const SECTIONS: Array<{ id: Section; icon: typeof Gauge; labelKey: string; fallback: string }> = [
  { id: 'overview', icon: LayoutDashboard, labelKey: 'quota.section.overview', fallback: 'Overview' },
  { id: 'quotas', icon: Gauge, labelKey: 'quota.section.quotas', fallback: 'Quotas' },
  { id: 'usage', icon: BarChart3, labelKey: 'quota.section.usage', fallback: 'Usage' },
  { id: 'agents', icon: Users, labelKey: 'quota.section.agents', fallback: 'Agents' },
];

const RANGES: InsightPeriod[] = ['24h', '7d', '30d'];

/**
 * Full-page Control Center shell.
 *
 * Owns the workspace pane, the shared period switch and the four read-only
 * sections. Quota state lives here so switching sections — or changing only the
 * period — does not re-trigger a provider sweep.
 */
export default function ControlCenterPage({ isMobile, onMenuClick }: ControlCenterPageProps) {
  const { t } = useTranslation('common');
  const navigate = useNavigate();
  const paletteOps = usePaletteOps();
  const { snapshot, isLoading, isRefreshing, error, refresh } = useQuotaSnapshot();
  const { config } = useQuotaConfig();
  const [section, setSection] = useState<Section>('overview');
  const [period, setPeriod] = useState<InsightPeriod>('7d');

  return (
    <div className="flex h-full flex-col overflow-hidden">
      <div className="flex flex-shrink-0 items-center gap-2 border-b border-border/60 px-3 py-1.5">
        {isMobile && onMenuClick && <MobileMenuButton onMenuClick={onMenuClick} compact />}
        <Button variant="ghost" size="sm" onClick={() => navigate('/')}>
          <ArrowLeft />
          <span className="hidden sm:inline">{t('quota.backToChat', 'Back to chat')}</span>
        </Button>
        <span className="ml-1 hidden items-center gap-1.5 text-sm font-medium md:flex">
          <MonitorCog className="h-4 w-4 text-muted-foreground" />
          {t('quota.controlCenter', 'AI Control Center')}
        </span>
        <div className="ml-auto flex items-center gap-2">
          <PillBar className="shrink-0">
            {RANGES.map((range) => (
              <Pill key={range} isActive={period === range} onClick={() => setPeriod(range)}>
                {t(`quota.range.${range}`, range)}
              </Pill>
            ))}
          </PillBar>
          {snapshot && (
            <span className="hidden text-[11px] tabular-nums text-muted-foreground lg:inline">
              {t('quota.generatedAt', 'Updated {{value}}', {
                value: new Date(snapshot.generatedAt).toLocaleTimeString(),
              })}
            </span>
          )}
          <Button variant="outline" size="sm" disabled={isRefreshing} onClick={() => void refresh()}>
            <RefreshCw className={cn('h-3.5 w-3.5', isRefreshing && 'animate-spin')} />
            <span className="hidden sm:inline">{t('quota.syncNow', 'Sync now')}</span>
          </Button>
          <Button
            variant="ghost"
            size="icon"
            aria-label={t('quota.settings.tab', 'Control Center settings')}
            title={t('quota.settings.tab', 'Control Center settings')}
            onClick={() => paletteOps.openSettings('quota')}
          >
            <Settings className="h-4 w-4" />
          </Button>
        </div>
      </div>

      {/* Mobile horizontal nav */}
      <div className="flex flex-shrink-0 items-center gap-1 overflow-x-auto border-b border-border/60 px-3 py-1.5 md:hidden">
        {SECTIONS.map((item) => {
          const Icon = item.icon;
          const isActive = section === item.id;
          return (
            <button
              key={item.id}
              type="button"
              onClick={() => setSection(item.id)}
              aria-current={isActive ? 'page' : undefined}
              className={cn(
                'flex shrink-0 items-center gap-1.5 rounded-md px-3 py-1.5 text-sm font-medium transition-colors',
                isActive ? 'bg-muted text-foreground' : 'text-muted-foreground hover:text-foreground',
              )}
            >
              <Icon className="h-4 w-4" />
              {t(item.labelKey, item.fallback)}
            </button>
          );
        })}
      </div>

      {/* Main body: sidebar on desktop, content pane */}
      <div className="flex flex-1 overflow-hidden">
        {/* Desktop left sidebar */}
        <aside className="hidden w-56 flex-shrink-0 border-r border-border/60 bg-muted/30 md:flex md:flex-col">
          <nav className="flex flex-col gap-1 p-3">
            {SECTIONS.map((item) => {
              const Icon = item.icon;
              const isActive = section === item.id;
              return (
                <button
                  key={item.id}
                  type="button"
                  onClick={() => setSection(item.id)}
                  aria-current={isActive ? 'page' : undefined}
                  className={cn(
                    'flex items-center gap-3 rounded-lg px-3 py-2.5 text-left text-sm font-medium transition-colors duration-150',
                    isActive
                      ? 'bg-accent text-accent-foreground shadow-sm'
                      : 'text-muted-foreground hover:bg-accent/50 hover:text-foreground active:bg-accent/50',
                  )}
                >
                  <Icon className="h-4 w-4 flex-shrink-0" />
                  {t(item.labelKey, item.fallback)}
                </button>
              );
            })}
          </nav>
        </aside>

        {/* Scrollable content pane */}
        <div className="flex-1 overflow-y-auto p-4">
          {isLoading && !snapshot ? (
            <p className="text-sm text-muted-foreground">{t('quota.loading', 'Loading account limits…')}</p>
          ) : error && !snapshot ? (
            <p className="text-sm text-red-600 dark:text-red-400">{error}</p>
          ) : (
            <div className="space-y-3">
              {error && <p className="text-xs text-amber-600 dark:text-amber-400">{error}</p>}
              {section === 'overview' && (
                <OverviewPanel
                  snapshot={snapshot}
                  config={config}
                  period={period}
                  onOpenQuotas={() => setSection('quotas')}
                  onOpenAgents={() => setSection('agents')}
                />
              )}
              {section === 'quotas' && (
                <QuotasPanel
                  snapshot={snapshot}
                  config={config}
                  isRefreshing={isRefreshing}
                  refresh={refresh}
                />
              )}
              {section === 'usage' && <UsagePanel />}
              {section === 'agents' && <AgentsPanel />}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
