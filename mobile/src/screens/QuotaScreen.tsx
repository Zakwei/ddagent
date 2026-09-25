import { useCallback, useEffect, useMemo, useState } from 'react';
import {
  ActivityIndicator,
  RefreshControl,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { useTranslation } from 'react-i18next';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import Svg, { Line, Path } from 'react-native-svg';
import {
  AlertTriangle,
  ArrowLeft,
  BarChart3,
  ChevronDown,
  Coins,
  Gauge,
  Hash,
  History,
  LayoutDashboard,
  RefreshCw,
  Users,
} from 'lucide-react-native';

import { useTheme } from '../theme';
import {
  type AgentFleetEntry,
  type AgentFleetStatus,
  type InsightPeriod,
  type QuotaAccount,
  type QuotaConfig,
  type QuotaDataQuality,
  type QuotaWindow,
  type UsageGroupBy,
  type UsageTrendPoint,
  TONE_FILL,
  formatCost,
  formatDuration,
  formatRelativeTo,
  formatTokens,
  toneForAgentStatus,
  toneForPercent,
  toneForQuality,
  toneTextColor,
  useAgentFleet,
  useQuotaConfig,
  useQuotaHistory,
  useQuotaSnapshot,
  useUsageSummary,
} from '../lib/quota';

type Section = 'overview' | 'quotas' | 'usage' | 'agents';

const SECTIONS: Array<{ id: Section; Icon: typeof Gauge; key: string; fallback: string }> = [
  { id: 'overview', Icon: LayoutDashboard, key: 'quota.section.overview', fallback: 'Overview' },
  { id: 'quotas', Icon: Gauge, key: 'quota.section.quotas', fallback: 'Quotas' },
  { id: 'usage', Icon: BarChart3, key: 'quota.section.usage', fallback: 'Usage' },
  { id: 'agents', Icon: Users, key: 'quota.section.agents', fallback: 'Agents' },
];

const RANGES: InsightPeriod[] = ['24h', '7d', '30d'];
const USAGE_PERIODS: InsightPeriod[] = ['24h', '7d', '30d', 'all'];
const GROUPS: UsageGroupBy[] = ['provider', 'model', 'agent', 'tool'];
const AGENT_STATUS_ORDER: AgentFleetStatus[] = ['running', 'waiting', 'finished', 'failed', 'queued'];

const QUALITY_KEY: Record<QuotaDataQuality, string> = {
  live: 'quota.quality.live',
  cached: 'quota.quality.cached',
  estimate: 'quota.quality.estimate',
  unknown: 'quota.quality.unknown',
  error: 'quota.quality.error',
};

type Ctx = {
  colors: ReturnType<typeof useTheme>['colors'];
  isDark: boolean;
  t: (key: string, fallback?: string, opts?: Record<string, unknown>) => string;
};

function worstWindow(account: QuotaAccount): QuotaWindow | null {
  if (account.windows.length === 0) return null;
  return account.windows.reduce((worst, window) => (window.percent > worst.percent ? window : worst));
}

function Card({ colors, children, style }: { colors: Ctx['colors']; children: React.ReactNode; style?: any }) {
  return (
    <View
      style={[
        { backgroundColor: colors.card, borderColor: colors.border, borderWidth: 1, borderRadius: 12, padding: 16 },
        style,
      ]}
    >
      {children}
    </View>
  );
}

function PillBar<T extends string>({
  items,
  value,
  onChange,
  colors,
}: {
  items: Array<{ id: T; label: string }>;
  value: T;
  onChange: (id: T) => void;
  colors: Ctx['colors'];
}) {
  return (
    <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 4 }}>
      {items.map((item) => {
        const active = item.id === value;
        return (
          <TouchableOpacity
            key={item.id}
            onPress={() => onChange(item.id)}
            style={{
              paddingHorizontal: 12,
              paddingVertical: 6,
              borderRadius: 8,
              backgroundColor: active ? colors.muted : 'transparent',
            }}
          >
            <Text
              style={{
                fontSize: 13,
                fontWeight: '600',
                color: active ? colors.foreground : colors.mutedForeground,
              }}
            >
              {item.label}
            </Text>
          </TouchableOpacity>
        );
      })}
    </View>
  );
}

function Sparkline({ points, tone, height = 24 }: { points: number[]; tone: keyof typeof TONE_FILL; height?: number }) {
  const color = TONE_FILL[tone];
  const width = 100;
  if (points.length < 2) {
    return (
      <Svg height={height} width="100%" viewBox={`0 0 ${width} ${height}`} preserveAspectRatio="none">
        <Line x1={0} y1={height / 2} x2={width} y2={height / 2} stroke="#8884" strokeWidth={1} />
      </Svg>
    );
  }
  const step = width / (points.length - 1);
  const path = points
    .map((value, index) => {
      const x = index * step;
      const y = height - (Math.min(100, Math.max(0, value)) / 100) * height;
      return `${index === 0 ? 'M' : 'L'}${x.toFixed(2)},${y.toFixed(2)}`;
    })
    .join(' ');
  return (
    <Svg height={height} width="100%" viewBox={`0 0 ${width} ${height}`} preserveAspectRatio="none">
      <Path d={`${path} L${width},${height} L0,${height} Z`} fill={color} opacity={0.15} />
      <Path d={path} fill="none" stroke={color} strokeWidth={1.5} />
    </Svg>
  );
}

function TrendChart({ trend, colors }: { trend: UsageTrendPoint[]; colors: Ctx['colors'] }) {
  const [series, setSeries] = useState<'tokens' | 'cost'>('tokens');
  const [hidden, setHidden] = useState(false);

  const width = 600;
  const height = 160;
  const padding = 8;

  const values = useMemo(
    () => trend.map((point) => (series === 'tokens' ? point.tokensTotal : point.costUsd)),
    [trend, series],
  );
  const formatValue = series === 'tokens' ? formatTokens : formatCost;
  const max = Math.max(1, ...values);

  return (
    <View style={{ gap: 8 }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
        <View style={{ flexDirection: 'row', gap: 4 }}>
          {(['tokens', 'cost'] as const).map((id) => (
            <TouchableOpacity
              key={id}
              onPress={() => setSeries(id)}
              style={{
                paddingHorizontal: 10,
                paddingVertical: 4,
                borderRadius: 8,
                backgroundColor: series === id ? colors.muted : 'transparent',
              }}
            >
              <Text
                style={{
                  fontSize: 12,
                  fontWeight: '600',
                  color: series === id ? colors.foreground : colors.mutedForeground,
                }}
              >
                {id === 'tokens' ? 'Tokens' : 'Cost'}
              </Text>
            </TouchableOpacity>
          ))}
        </View>
        <TouchableOpacity onPress={() => setHidden((value) => !value)}>
          <Text style={{ fontSize: 11, color: colors.mutedForeground }}>{hidden ? 'Show' : 'Hide'}</Text>
        </TouchableOpacity>
      </View>

      {hidden ? null : trend.length < 2 ? (
        <Text style={{ fontSize: 11, color: colors.mutedForeground }}>Not enough data for a trend.</Text>
      ) : (
        <View style={{ flexDirection: 'row', gap: 8 }}>
          <View style={{ width: 44, height: 120, justifyContent: 'space-between' }}>
            {[max, max / 2, 0].map((value) => (
              <Text key={value} style={{ fontSize: 10, color: colors.mutedForeground, textAlign: 'right' }}>
                {formatValue(value)}
              </Text>
            ))}
          </View>
          <View style={{ flex: 1 }}>
            <Svg height={120} width="100%" viewBox={`0 0 ${width} ${height}`} preserveAspectRatio="none">
              <Path
                d={`M${padding},${height - padding} L${width - padding},${height - padding}`}
                stroke={colors.border}
                strokeWidth={1}
              />
              <Path
                d={values
                  .map((value, index) => {
                    const step = values.length > 1 ? (width - padding * 2) / (values.length - 1) : 0;
                    const x = padding + index * step;
                    const y = height - padding - (value / max) * (height - padding * 2);
                    return `${index === 0 ? 'M' : 'L'}${x.toFixed(2)},${y.toFixed(2)}`;
                  })
                  .join(' ')}
                fill="none"
                stroke={TONE_FILL.info}
                strokeWidth={1.5}
              />
            </Svg>
            <View style={{ flexDirection: 'row', justifyContent: 'space-between' }}>
              <Text style={{ fontSize: 10, color: colors.mutedForeground }}>{trend[0]?.date}</Text>
              <Text style={{ fontSize: 10, color: colors.mutedForeground }}>{trend[trend.length - 1]?.date}</Text>
            </View>
          </View>
        </View>
      )}
    </View>
  );
}

function Kpi({
  label,
  value,
  hint,
  Icon,
  tone,
  onPress,
  ctx,
}: {
  label: string;
  value: string;
  hint?: string;
  Icon: typeof Gauge;
  tone: keyof typeof TONE_FILL;
  onPress?: () => void;
  ctx: Ctx;
}) {
  const toneColor = toneTextColor(tone, ctx.isDark);
  return (
    <TouchableOpacity
      activeOpacity={onPress ? 0.7 : 1}
      onPress={onPress}
      disabled={!onPress}
      style={{
        flexGrow: 1,
        flexBasis: 150,
        backgroundColor: ctx.colors.card,
        borderColor: ctx.colors.border,
        borderWidth: 1,
        borderRadius: 12,
        padding: 14,
        flexDirection: 'row',
        alignItems: 'center',
        gap: 12,
      }}
    >
      <View
        style={{
          width: 36,
          height: 36,
          borderRadius: 8,
          backgroundColor: ctx.colors.muted,
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        <Icon size={16} color={toneColor} />
      </View>
      <View style={{ flex: 1, minWidth: 0 }}>
        <Text style={{ fontSize: 11, color: ctx.colors.mutedForeground }}>{label}</Text>
        <Text style={{ fontSize: 18, fontWeight: '700', color: toneColor, fontVariant: ['tabular-nums'] }}>
          {value}
        </Text>
        {hint ? (
          <Text numberOfLines={1} style={{ fontSize: 11, color: ctx.colors.mutedForeground }}>
            {hint}
          </Text>
        ) : null}
      </View>
    </TouchableOpacity>
  );
}

function Metric({ label, value, ctx }: { label: string; value: string; ctx: Ctx }) {
  return (
    <View style={{ flexGrow: 1, flexBasis: 120, gap: 2 }}>
      <Text style={{ fontSize: 11, color: ctx.colors.mutedForeground }}>{label}</Text>
      <Text style={{ fontSize: 16, fontWeight: '700', color: ctx.colors.foreground, fontVariant: ['tabular-nums'] }}>
        {value}
      </Text>
    </View>
  );
}

function WindowRow({
  window,
  watch,
  danger,
  alertsEnabled,
  accountErrored,
  ctx,
}: {
  window: QuotaWindow;
  watch: number;
  danger: number;
  alertsEnabled: boolean;
  accountErrored: boolean;
  ctx: Ctx;
}) {
  const tone = accountErrored ? 'neutral' : toneForPercent(window.percent, watch, danger);
  const reset = formatRelativeTo(window.resetsAt);
  return (
    <View style={{ gap: 4 }}>
      <View style={{ flexDirection: 'row', alignItems: 'baseline', justifyContent: 'space-between', gap: 8 }}>
        <Text style={{ fontSize: 12, color: ctx.colors.mutedForeground }}>
          {window.label}{' '}
          <Text style={{ fontSize: 10, textTransform: 'uppercase' }}>{window.kind}</Text>
        </Text>
        <Text style={{ fontSize: 12, fontWeight: '600', color: toneTextColor(tone, ctx.isDark) }}>
          {window.percent}%
        </Text>
      </View>
      <View style={{ height: 8, borderRadius: 4, backgroundColor: ctx.colors.muted, overflow: 'hidden' }}>
        <View
          style={{
            height: '100%',
            width: `${Math.min(100, Math.max(0, window.percent))}%`,
            backgroundColor: TONE_FILL[tone],
          }}
        />
      </View>
      <View style={{ flexDirection: 'row', justifyContent: 'space-between', gap: 8 }}>
        <Text style={{ fontSize: 11, color: ctx.colors.mutedForeground }}>
          {ctx.t('quota.remaining', '{{value}}% left', { value: window.remainingPercent })}
        </Text>
        {reset !== '—' && (
          <Text style={{ fontSize: 11, color: ctx.colors.mutedForeground }}>
            {ctx.t('quota.resetsIn', 'reset in {{value}}', { value: reset })}
          </Text>
        )}
      </View>
      {alertsEnabled && window.etaSeconds !== null && !accountErrored && (
        <Text style={{ fontSize: 11, color: toneTextColor(tone, ctx.isDark) }}>
          {ctx.t('quota.projected', 'at the current pace this limit runs out in {{value}}', {
            value: formatDuration(window.etaSeconds),
          })}
        </Text>
      )}
    </View>
  );
}

function AccountQuotaCard({
  account,
  config,
  refreshing,
  onRefresh,
  ctx,
}: {
  account: QuotaAccount;
  config: QuotaConfig | null;
  refreshing: boolean;
  onRefresh: (accountId: string) => void;
  ctx: Ctx;
}) {
  const [historyOpen, setHistoryOpen] = useState(false);
  const history = useQuotaHistory(historyOpen ? account.id : null);
  const now = Date.now();

  const watch = config?.watchThreshold ?? 75;
  const danger = config?.dangerThreshold ?? 90;
  const alertsEnabled = config?.alertsEnabled ?? true;
  const worst = account.windows.reduce((max, window) => Math.max(max, window.percent), 0);
  const tone = account.status === 'error' ? 'neutral' : toneForPercent(worst, watch, danger);
  const qualityTone = toneForQuality(account.quality);
  const age = account.lastSyncedAt ? formatDuration(Math.max(0, (now - Date.parse(account.lastSyncedAt)) / 1000)) : null;
  const inactive = account.status === 'inactive';

  return (
    <Card colors={ctx.colors}>
      <View style={{ gap: 16 }}>
        <View style={{ flexDirection: 'row', alignItems: 'flex-start', justifyContent: 'space-between', gap: 8 }}>
          <View style={{ flexDirection: 'row', alignItems: 'flex-start', gap: 8, flex: 1, minWidth: 0 }}>
            <View style={{ width: 8, height: 8, borderRadius: 4, marginTop: 6, backgroundColor: TONE_FILL[tone] }} />
            <View style={{ flex: 1, minWidth: 0 }}>
              <Text numberOfLines={1} style={{ fontSize: 14, fontWeight: '700', color: ctx.colors.foreground }}>
                {account.providerLabel}
                {account.accountLabel ? (
                  <Text style={{ color: ctx.colors.mutedForeground }}> / {account.accountLabel}</Text>
                ) : null}
              </Text>
              <Text numberOfLines={1} style={{ fontSize: 12, color: ctx.colors.mutedForeground }}>
                {account.plan}
              </Text>
            </View>
          </View>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
            <View
              style={{
                borderWidth: 1,
                borderColor: toneTextColor(inactive ? 'neutral' : qualityTone, ctx.isDark),
                borderRadius: 6,
                paddingHorizontal: 6,
                paddingVertical: 2,
              }}
            >
              <Text
                style={{
                  fontSize: 10,
                  textTransform: 'uppercase',
                  color: toneTextColor(inactive ? 'neutral' : qualityTone, ctx.isDark),
                }}
              >
                {inactive ? ctx.t('quota.noSubscription', 'No subscription') : ctx.t(QUALITY_KEY[account.quality])}
              </Text>
            </View>
            <TouchableOpacity disabled={refreshing} onPress={() => onRefresh(account.id)} hitSlop={8} style={{ padding: 4 }}>
              <RefreshCw size={14} color={ctx.colors.mutedForeground} />
            </TouchableOpacity>
          </View>
        </View>

        {account.status === 'error' ? (
          <Text style={{ fontSize: 12, color: '#dc2626' }}>
            {account.syncError ?? ctx.t('quota.syncFailed', 'Synchronization failed')}
          </Text>
        ) : inactive ? (
          <Text style={{ fontSize: 12, color: ctx.colors.mutedForeground }}>
            {ctx.t('quota.noSubscriptionHint', 'The provider reports no active plan for this account.')}
          </Text>
        ) : (
          <View style={{ gap: 12 }}>
            {account.windows.map((window) => (
              <WindowRow
                key={window.label}
                window={window}
                watch={watch}
                danger={danger}
                alertsEnabled={alertsEnabled}
                accountErrored={account.status === 'error'}
                ctx={ctx}
              />
            ))}
          </View>
        )}

        <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 8 }}>
          {account.assignedAgents.length > 0 ? (
            account.assignedAgents.map((agent) => (
              <View
                key={agent.agentId}
                style={{
                  flexDirection: 'row',
                  alignItems: 'center',
                  gap: 4,
                  borderWidth: 1,
                  borderColor: ctx.colors.border,
                  borderRadius: 6,
                  paddingHorizontal: 6,
                  paddingVertical: 2,
                }}
              >
                <Users size={12} color={ctx.colors.mutedForeground} />
                <Text style={{ fontSize: 11, color: ctx.colors.mutedForeground }}>{agent.role}</Text>
                <Text style={{ fontSize: 11, color: ctx.colors.foreground }}>{agent.activeTasks}</Text>
              </View>
            ))
          ) : (
            <View
              style={{
                flexDirection: 'row',
                alignItems: 'center',
                gap: 4,
                borderWidth: 1,
                borderStyle: 'dashed',
                borderColor: ctx.colors.border,
                borderRadius: 6,
                paddingHorizontal: 6,
                paddingVertical: 2,
              }}
            >
              <Users size={12} color={ctx.colors.mutedForeground} />
              <Text style={{ fontSize: 11, color: ctx.colors.mutedForeground }}>
                {ctx.t('quota.noAgents', 'No agents assigned')}
              </Text>
            </View>
          )}
        </View>

        <TouchableOpacity
          onPress={() => setHistoryOpen((value) => !value)}
          style={{ flexDirection: 'row', alignItems: 'center', gap: 4, alignSelf: 'flex-start' }}
        >
          <History size={14} color={ctx.colors.mutedForeground} />
          <Text style={{ fontSize: 11, color: ctx.colors.mutedForeground }}>{ctx.t('quota.history', 'History')}</Text>
          <ChevronDown
            size={12}
            color={ctx.colors.mutedForeground}
            style={{ transform: [{ rotate: historyOpen ? '180deg' : '0deg' }] }}
          />
        </TouchableOpacity>
        {historyOpen && (
          <View style={{ gap: 4 }}>
            <Sparkline points={(history?.points ?? []).map((point) => point.percent)} tone={tone} />
            <Text style={{ fontSize: 10, color: ctx.colors.mutedForeground }}>
              {history && history.points.length > 0
                ? ctx.t('quota.historyPoints', '{{value}} readings recorded', { value: history.points.length })
                : ctx.t('quota.historyEmpty', 'No history recorded yet')}
            </Text>
          </View>
        )}

        <View style={{ flexDirection: 'row', justifyContent: 'space-between', gap: 8 }}>
          <Text style={{ fontSize: 11, textTransform: 'uppercase', color: toneTextColor(qualityTone, ctx.isDark) }}>
            {account.provider.charAt(0).toUpperCase() + account.provider.slice(1)}
          </Text>
          {age && (
            <Text style={{ fontSize: 11, color: ctx.colors.mutedForeground }}>
              {ctx.t('quota.syncedAgo', 'synced {{value}} ago', { value: age })}
            </Text>
          )}
        </View>
      </View>
    </Card>
  );
}

function OverviewPanel({
  snapshot,
  config,
  period,
  onOpenQuotas,
  onOpenAgents,
  ctx,
}: {
  snapshot: ReturnType<typeof useQuotaSnapshot>['snapshot'];
  config: QuotaConfig | null;
  period: InsightPeriod;
  onOpenQuotas: () => void;
  onOpenAgents: () => void;
  ctx: Ctx;
}) {
  const { summary } = useUsageSummary(period, 'provider');
  const { fleet } = useAgentFleet();

  const watch = config?.watchThreshold ?? 75;
  const danger = config?.dangerThreshold ?? 90;
  const overview = snapshot?.overview ?? null;
  const alertsEnabled = config?.alertsEnabled ?? true;
  const accounts = snapshot?.accounts ?? [];

  const paceAlerts = alertsEnabled
    ? accounts.flatMap((account) =>
        account.windows.filter((window) => window.etaSeconds !== null).map((window) => ({ account, window })),
      )
    : [];
  const riskyWindows = alertsEnabled
    ? accounts.flatMap((account) =>
        account.windows
          .filter((window) => window.etaSeconds === null && window.percent >= watch)
          .map((window) => ({ account, window })),
      )
    : [];

  const activeAgents = (fleet?.entries ?? []).filter(
    (entry) => entry.status === 'running' || entry.status === 'waiting' || entry.status === 'queued',
  );

  return (
    <View style={{ gap: 16 }}>
      <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 12 }}>
        <Kpi
          ctx={ctx}
          Icon={AlertTriangle}
          label={ctx.t('quota.kpi.atRisk', 'Limits at risk')}
          value={String(overview?.accountsAtRisk ?? 0)}
          hint={ctx.t('quota.kpi.atRiskHint', 'accounts over {{value}}%', { value: watch })}
          tone={(overview?.accountsAtRisk ?? 0) > 0 ? 'watch' : 'safe'}
          onPress={onOpenQuotas}
        />
        <Kpi
          ctx={ctx}
          Icon={Users}
          label={ctx.t('quota.kpi.activeAgents', 'Active agents')}
          value={String(fleet?.summary.running ?? 0)}
          hint={ctx.t('quota.kpi.agentsHint', '{{waiting}} waiting · {{queued}} queued', {
            waiting: fleet?.summary.waiting ?? 0,
            queued: fleet?.summary.queued ?? 0,
          })}
          tone="neutral"
          onPress={onOpenAgents}
        />
        <Kpi
          ctx={ctx}
          Icon={Hash}
          label={ctx.t('quota.kpi.tokens', 'Tokens')}
          value={formatTokens(summary?.totals.tokensTotal ?? 0)}
          hint={ctx.t('quota.kpi.sessionsHint', '{{value}} sessions', { value: summary?.totals.sessions ?? 0 })}
          tone="neutral"
        />
        <Kpi
          ctx={ctx}
          Icon={Coins}
          label={ctx.t('quota.kpi.cost', 'Estimated cost')}
          value={formatCost(summary?.totals.costUsd ?? 0)}
          hint={ctx.t('quota.kpi.costHint', '{{value}} covered by plans', {
            value: formatCost(summary?.effectiveCost.subscriptionValueUsd ?? 0),
          })}
          tone="neutral"
        />
      </View>

      <Card colors={ctx.colors}>
        <View style={{ gap: 12 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
            <Text style={{ fontSize: 14, fontWeight: '700', color: ctx.colors.foreground }}>
              {ctx.t('quota.overview.limitsTitle', 'Usage and limits')}
            </Text>
            <TouchableOpacity onPress={onOpenQuotas}>
              <Text style={{ fontSize: 12, color: ctx.colors.mutedForeground }}>
                {ctx.t('quota.overview.viewAccounts', 'All accounts')}
              </Text>
            </TouchableOpacity>
          </View>
          {accounts.length === 0 && (
            <Text style={{ fontSize: 12, color: ctx.colors.mutedForeground }}>
              {ctx.t('quota.empty.title', 'No accounts connected')}
            </Text>
          )}
          {accounts.map((account) => {
            const window = worstWindow(account);
            const tone =
              account.status === 'error' ? 'danger' : window ? toneForPercent(window.percent, watch, danger) : 'neutral';
            return (
              <View key={account.id} style={{ gap: 4 }}>
                <View style={{ flexDirection: 'row', alignItems: 'baseline', justifyContent: 'space-between', gap: 8 }}>
                  <Text numberOfLines={1} style={{ flex: 1, fontSize: 12, color: ctx.colors.foreground }}>
                    <Text style={{ fontWeight: '600' }}>{account.providerLabel}</Text>
                    {account.accountLabel ? (
                      <Text style={{ color: ctx.colors.mutedForeground }}> · {account.accountLabel}</Text>
                    ) : null}
                  </Text>
                  {account.status === 'error' ? (
                    <Text style={{ fontSize: 12, color: '#dc2626' }}>{ctx.t('quota.quality.error', 'Error')}</Text>
                  ) : account.status === 'inactive' ? (
                    <Text style={{ fontSize: 12, color: ctx.colors.mutedForeground }}>
                      {ctx.t('quota.noSubscription', 'No subscription')}
                    </Text>
                  ) : window ? (
                    <Text style={{ fontSize: 12, color: toneTextColor(tone, ctx.isDark) }}>
                      {window.percent}% · {formatRelativeTo(window.resetsAt)}
                    </Text>
                  ) : null}
                </View>
                <View style={{ height: 6, borderRadius: 3, backgroundColor: ctx.colors.muted, overflow: 'hidden' }}>
                  <View
                    style={{
                      height: '100%',
                      width: `${account.status === 'error' || !window ? 0 : window.percent}%`,
                      backgroundColor: TONE_FILL[tone],
                    }}
                  />
                </View>
              </View>
            );
          })}
        </View>
      </Card>

      <Card colors={ctx.colors}>
        <View style={{ gap: 8 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
            <Text style={{ fontSize: 14, fontWeight: '700', color: ctx.colors.foreground }}>
              {ctx.t('quota.overview.activeTasks', 'Active tasks')}
            </Text>
            <TouchableOpacity onPress={onOpenAgents}>
              <Text style={{ fontSize: 12, color: ctx.colors.mutedForeground }}>
                {ctx.t('quota.overview.viewAgents', 'All agents')}
              </Text>
            </TouchableOpacity>
          </View>
          {activeAgents.length === 0 && (
            <Text style={{ fontSize: 12, color: ctx.colors.mutedForeground }}>
              {ctx.t('quota.overview.noTasks', 'No agents are running right now.')}
            </Text>
          )}
          {activeAgents.slice(0, 6).map((entry) => (
            <View key={entry.agentId} style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
              <View
                style={{
                  width: 8,
                  height: 8,
                  borderRadius: 4,
                  backgroundColor: TONE_FILL[toneForAgentStatus(entry.status)],
                }}
              />
              <Text numberOfLines={1} style={{ flex: 1, fontSize: 12, color: ctx.colors.foreground }}>
                {entry.taskTitle ?? entry.role}
              </Text>
              <Text style={{ fontSize: 12, color: ctx.colors.mutedForeground }}>
                {formatDuration(entry.elapsedSeconds || null)}
              </Text>
            </View>
          ))}
        </View>
      </Card>

      <Card colors={ctx.colors}>
        <View style={{ gap: 8 }}>
          <Text style={{ fontSize: 14, fontWeight: '700', color: ctx.colors.foreground }}>
            {ctx.t('quota.overview.trendTitle', 'Tokens and cost — last 7 days')}
          </Text>
          {summary && (
            <Text style={{ fontSize: 12, color: ctx.colors.mutedForeground }}>
              {formatTokens(summary.totals.tokensTotal)} · {formatCost(summary.totals.costUsd)}
            </Text>
          )}
          <TrendChart trend={summary?.trend ?? []} colors={ctx.colors} />
        </View>
      </Card>

      <Card colors={ctx.colors}>
        <View style={{ gap: 8 }}>
          <Text style={{ fontSize: 14, fontWeight: '700', color: ctx.colors.foreground }}>
            {ctx.t('quota.overview.alertsTitle', 'Alerts')}
          </Text>
          {paceAlerts.length === 0 && riskyWindows.length === 0 && (
            <Text style={{ fontSize: 12, color: ctx.colors.mutedForeground }}>
              {ctx.t('quota.overview.noAlerts', 'Nothing needs attention right now.')}
            </Text>
          )}
          {paceAlerts.map(({ account, window }) => (
            <Text key={`${account.id}-${window.label}-pace`} style={{ fontSize: 12, color: '#d97706' }}>
              {ctx.t('quota.alert.pace', '{{account}} · {{window}}: at the current pace the limit runs out in {{value}}', {
                account: account.providerLabel,
                window: window.label,
                value: formatRelativeTo(window.projectedExhaustionAt),
              })}
            </Text>
          ))}
          {riskyWindows.map(({ account, window }) => (
            <Text
              key={`${account.id}-${window.label}-threshold`}
              style={{ fontSize: 12, color: window.percent >= danger ? '#dc2626' : '#d97706' }}
            >
              {ctx.t('quota.alert.threshold', '{{account}} · {{window}}: {{value}}% used (threshold {{watch}}%)', {
                account: account.providerLabel,
                window: window.label,
                value: window.percent,
                watch,
              })}
            </Text>
          ))}
        </View>
      </Card>
    </View>
  );
}

function QuotasPanel({
  snapshot,
  config,
  isRefreshing,
  refresh,
  ctx,
}: {
  snapshot: ReturnType<typeof useQuotaSnapshot>['snapshot'];
  config: QuotaConfig | null;
  isRefreshing: boolean;
  refresh: () => Promise<void>;
  ctx: Ctx;
}) {
  const [provider, setProvider] = useState<string>('__all__');
  const [refreshingAccount, setRefreshingAccount] = useState<string | null>(null);

  const providers = useMemo(() => {
    const ids = new Set<string>();
    for (const account of snapshot?.accounts ?? []) ids.add(account.provider);
    return Array.from(ids);
  }, [snapshot]);

  const accounts = useMemo(
    () => (snapshot?.accounts ?? []).filter((account) => provider === '__all__' || account.provider === provider),
    [snapshot, provider],
  );

  const handleRefreshAccount = useCallback(
    async (accountId: string) => {
      setRefreshingAccount(accountId);
      try {
        await refresh();
      } finally {
        setRefreshingAccount(null);
      }
    },
    [refresh],
  );

  if (!snapshot) return null;

  return (
    <View style={{ gap: 16 }}>
      {providers.length > 1 && (
        <PillBar
          colors={ctx.colors}
          value={provider}
          onChange={setProvider}
          items={[
            { id: '__all__', label: ctx.t('quota.filter.all', 'All') },
            ...providers.map((id) => ({ id, label: id.charAt(0).toUpperCase() + id.slice(1) })),
          ]}
        />
      )}

      {accounts.length === 0 ? (
        <Card colors={ctx.colors}>
          <View style={{ alignItems: 'center', gap: 6, paddingVertical: 24 }}>
            <Gauge size={28} color={ctx.colors.mutedForeground} />
            <Text style={{ fontSize: 14, fontWeight: '600', color: ctx.colors.foreground }}>
              {ctx.t('quota.empty.title', 'No accounts connected')}
            </Text>
            <Text style={{ fontSize: 12, color: ctx.colors.mutedForeground, textAlign: 'center' }}>
              {ctx.t(
                'quota.empty.description',
                'Sign in to Claude, Codex, Gemini or CommandCode so quota can be tracked here.',
              )}
            </Text>
          </View>
        </Card>
      ) : (
        accounts.map((account) => (
          <AccountQuotaCard
            key={account.id}
            account={account}
            config={config}
            refreshing={refreshingAccount === account.id || isRefreshing}
            onRefresh={handleRefreshAccount}
            ctx={ctx}
          />
        ))
      )}
    </View>
  );
}

function UsagePanel({ ctx }: { ctx: Ctx }) {
  const [period, setPeriod] = useState<InsightPeriod>('7d');
  const [groupBy, setGroupBy] = useState<UsageGroupBy>('provider');
  const { summary, isLoading, error } = useUsageSummary(period, groupBy);

  return (
    <View style={{ gap: 16 }}>
      <View style={{ gap: 8 }}>
        <PillBar
          colors={ctx.colors}
          value={period}
          onChange={setPeriod}
          items={USAGE_PERIODS.map((id) => ({ id, label: ctx.t(`quota.period.${id}`, id) }))}
        />
        <PillBar
          colors={ctx.colors}
          value={groupBy}
          onChange={setGroupBy}
          items={GROUPS.map((id) => ({ id, label: ctx.t(`quota.group.${id}`, id) }))}
        />
      </View>

      {error && <Text style={{ fontSize: 12, color: '#dc2626' }}>{error}</Text>}

      <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 12 }}>
        <Metric ctx={ctx} label={ctx.t('quota.metric.tokens', 'Tokens')} value={formatTokens(summary?.totals.tokensTotal ?? 0)} />
        <Metric ctx={ctx} label={ctx.t('quota.metric.cost', 'Cost')} value={formatCost(summary?.totals.costUsd ?? 0)} />
        <Metric ctx={ctx} label={ctx.t('quota.metric.calls', 'API calls')} value={String(summary?.totals.apiCalls ?? 0)} />
        <Metric ctx={ctx} label={ctx.t('quota.metric.sessions', 'Sessions')} value={String(summary?.totals.sessions ?? 0)} />
      </View>

      <Card colors={ctx.colors}>
        <View style={{ gap: 8 }}>
          <Text style={{ fontSize: 14, fontWeight: '700', color: ctx.colors.foreground }}>
            {ctx.t('quota.usage.trendTitle', 'Daily trend')}
          </Text>
          <TrendChart trend={summary?.trend ?? []} colors={ctx.colors} />
        </View>
      </Card>

      <Card colors={ctx.colors}>
        <View style={{ gap: 8 }}>
          <Text style={{ fontSize: 14, fontWeight: '700', color: ctx.colors.foreground }}>
            {ctx.t('quota.usage.breakdownTitle', 'Breakdown by {{group}}', {
              group: ctx.t(`quota.group.${groupBy}`, groupBy),
            })}
          </Text>
          {isLoading && !summary ? (
            <Text style={{ fontSize: 12, color: ctx.colors.mutedForeground }}>{ctx.t('quota.loading', 'Loading…')}</Text>
          ) : (
            <>
              <View style={{ flexDirection: 'row', gap: 8 }}>
                <Text style={{ flex: 2, fontSize: 11, color: ctx.colors.mutedForeground }}>
                  {ctx.t('quota.usage.colName', 'Name')}
                </Text>
                <Text style={{ flex: 1, fontSize: 11, textAlign: 'right', color: ctx.colors.mutedForeground }}>
                  {ctx.t('quota.metric.input', 'Input')}
                </Text>
                <Text style={{ flex: 1, fontSize: 11, textAlign: 'right', color: ctx.colors.mutedForeground }}>
                  {ctx.t('quota.metric.output', 'Output')}
                </Text>
                <Text style={{ flex: 1, fontSize: 11, textAlign: 'right', color: ctx.colors.mutedForeground }}>
                  {ctx.t('quota.metric.calls', 'Calls')}
                </Text>
                <Text style={{ flex: 1, fontSize: 11, textAlign: 'right', color: ctx.colors.mutedForeground }}>
                  {ctx.t('quota.metric.cost', 'Cost')}
                </Text>
              </View>
              {(summary?.buckets ?? []).map((bucket) => (
                <View
                  key={bucket.key}
                  style={{
                    flexDirection: 'row',
                    gap: 8,
                    paddingVertical: 6,
                    borderBottomWidth: StyleSheet.hairlineWidth,
                    borderBottomColor: ctx.colors.border,
                  }}
                >
                  <Text numberOfLines={1} style={{ flex: 2, fontSize: 12, color: ctx.colors.foreground }}>
                    {bucket.label}
                  </Text>
                  <Text style={{ flex: 1, fontSize: 12, textAlign: 'right', color: ctx.colors.mutedForeground }}>
                    {formatTokens(bucket.tokensInput)}
                  </Text>
                  <Text style={{ flex: 1, fontSize: 12, textAlign: 'right', color: ctx.colors.mutedForeground }}>
                    {formatTokens(bucket.tokensOutput)}
                  </Text>
                  <Text style={{ flex: 1, fontSize: 12, textAlign: 'right', color: ctx.colors.mutedForeground }}>
                    {bucket.apiCalls}
                  </Text>
                  <Text style={{ flex: 1, fontSize: 12, textAlign: 'right', color: ctx.colors.foreground }}>
                    {formatCost(bucket.costUsd)}
                  </Text>
                </View>
              ))}
            </>
          )}
        </View>
      </Card>

      <Card colors={ctx.colors}>
        <View style={{ gap: 8 }}>
          <Text style={{ fontSize: 14, fontWeight: '700', color: ctx.colors.foreground }}>
            {ctx.t('quota.overview.effectiveCost', 'Effective cost (7 days)')}
          </Text>
          <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 12 }}>
            <Metric
              ctx={ctx}
              label={ctx.t('quota.cost.billed', 'Billed (API + overage)')}
              value={formatCost(summary?.effectiveCost.billedUsd ?? 0)}
            />
            <Metric
              ctx={ctx}
              label={ctx.t('quota.cost.listPrice', 'List price of tokens used')}
              value={formatCost(summary?.effectiveCost.listPriceUsd ?? 0)}
            />
            <Metric
              ctx={ctx}
              label={ctx.t('quota.cost.subscriptionValue', 'Covered by subscriptions')}
              value={formatCost(summary?.effectiveCost.subscriptionValueUsd ?? 0)}
            />
            <Metric
              ctx={ctx}
              label={ctx.t('quota.cost.cacheSavings', 'Cache savings')}
              value={formatCost(summary?.cacheSavingsUsd ?? 0)}
            />
          </View>
        </View>
      </Card>
    </View>
  );
}

function AgentsPanel({ ctx }: { ctx: Ctx }) {
  const { fleet, isLoading, error, reload } = useAgentFleet();
  const [status, setStatus] = useState<AgentFleetStatus | '__all__'>('__all__');
  const [expanded, setExpanded] = useState<string | null>(null);

  const entries = (fleet?.entries ?? []).filter((entry) => status === '__all__' || entry.status === status);
  const summary = fleet?.summary;

  return (
    <View style={{ gap: 16 }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', flexWrap: 'wrap', gap: 8 }}>
        <View
          style={{
            flexDirection: 'row',
            alignItems: 'center',
            gap: 4,
            borderWidth: 1,
            borderColor: ctx.colors.border,
            borderRadius: 6,
            paddingHorizontal: 8,
            paddingVertical: 4,
          }}
        >
          <Users size={12} color="#0284c7" />
          <Text style={{ fontSize: 12, color: '#0284c7' }}>
            {ctx.t('quota.agents.runningCount', '{{value}} running', { value: summary?.running ?? 0 })}
          </Text>
        </View>
        <View
          style={{
            borderWidth: 1,
            borderColor: ctx.colors.border,
            borderRadius: 6,
            paddingHorizontal: 8,
            paddingVertical: 4,
          }}
        >
          <Text style={{ fontSize: 12, color: ctx.colors.mutedForeground }}>
            {formatTokens(summary?.totalTokens ?? 0)} · {formatCost(summary?.totalCostUsd ?? 0)}
          </Text>
        </View>
        <TouchableOpacity
          onPress={() => void reload()}
          style={{
            marginLeft: 'auto',
            borderWidth: 1,
            borderColor: ctx.colors.border,
            borderRadius: 6,
            paddingHorizontal: 8,
            paddingVertical: 4,
          }}
        >
          <Text style={{ fontSize: 12, color: ctx.colors.foreground }}>{ctx.t('quota.syncNow', 'Sync now')}</Text>
        </TouchableOpacity>
      </View>

      <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 4 }}>
        {(['__all__', ...AGENT_STATUS_ORDER] as const).map((id) => {
          const active = status === id;
          return (
            <TouchableOpacity
              key={id}
              onPress={() => setStatus(id)}
              style={{
                paddingHorizontal: 8,
                paddingVertical: 4,
                borderRadius: 6,
                backgroundColor: active ? ctx.colors.muted : 'transparent',
              }}
            >
              <Text style={{ fontSize: 12, color: active ? ctx.colors.foreground : ctx.colors.mutedForeground }}>
                {id === '__all__'
                  ? ctx.t('quota.filter.all', 'All')
                  : `${ctx.t(`quota.agentStatus.${id}`, id)} (${summary?.[id] ?? 0})`}
              </Text>
            </TouchableOpacity>
          );
        })}
      </View>

      {error && <Text style={{ fontSize: 12, color: '#dc2626' }}>{error}</Text>}

      {isLoading && !fleet ? (
        <ActivityIndicator color={ctx.colors.primary} />
      ) : entries.length === 0 ? (
        <Text style={{ fontSize: 12, color: ctx.colors.mutedForeground }}>
          {ctx.t('quota.agents.empty', 'No agents match this filter.')}
        </Text>
      ) : (
        <Card colors={ctx.colors} style={{ padding: 0 }}>
          <View>
            {entries.map((entry: AgentFleetEntry) => {
              const isOpen = expanded === entry.agentId;
              const tone = toneForAgentStatus(entry.status);
              return (
                <View key={entry.agentId}>
                  <TouchableOpacity
                    onPress={() => setExpanded(isOpen ? null : entry.agentId)}
                    style={{
                      flexDirection: 'row',
                      alignItems: 'center',
                      gap: 8,
                      padding: 12,
                      borderBottomWidth: StyleSheet.hairlineWidth,
                      borderBottomColor: ctx.colors.border,
                    }}
                  >
                    <View style={{ width: 8, height: 8, borderRadius: 4, backgroundColor: TONE_FILL[tone] }} />
                    <View style={{ flex: 1, minWidth: 0 }}>
                      <Text numberOfLines={1} style={{ fontSize: 12, fontWeight: '600', color: ctx.colors.foreground }}>
                        {entry.agentId}
                      </Text>
                      <Text numberOfLines={1} style={{ fontSize: 11, color: ctx.colors.mutedForeground }}>
                        {entry.taskTitle ?? entry.role}
                      </Text>
                    </View>
                    <Text style={{ fontSize: 11, color: toneTextColor(tone, ctx.isDark) }}>
                      {ctx.t(`quota.agentStatus.${entry.status}`, entry.status)}
                    </Text>
                    <Text style={{ fontSize: 11, color: ctx.colors.mutedForeground, width: 56, textAlign: 'right' }}>
                      {formatDuration(entry.elapsedSeconds || null)}
                    </Text>
                    <ChevronDown
                      size={14}
                      color={ctx.colors.mutedForeground}
                      style={{ transform: [{ rotate: isOpen ? '180deg' : '0deg' }] }}
                    />
                  </TouchableOpacity>
                  {isOpen && (
                    <View
                      style={{
                        padding: 12,
                        gap: 4,
                        backgroundColor: ctx.colors.muted,
                        borderBottomWidth: StyleSheet.hairlineWidth,
                        borderBottomColor: ctx.colors.border,
                      }}
                    >
                      <Text style={{ fontSize: 11, color: ctx.colors.mutedForeground }}>
                        {ctx.t('quota.agents.colModel', 'Account / model')}: {entry.provider ?? '—'}
                        {entry.model ? ` / ${entry.model}` : ''}
                      </Text>
                      <Text style={{ fontSize: 11, color: ctx.colors.mutedForeground }}>
                        {formatTokens(entry.tokensTotal)} · {formatCost(entry.costUsd)}
                        {entry.retryCount !== null
                          ? ` · ${ctx.t('quota.agents.detailRetries', 'Retries')}: ${entry.retryCount}`
                          : ''}
                      </Text>
                      {entry.result ? (
                        <Text style={{ fontSize: 11, color: ctx.colors.foreground }}>{entry.result}</Text>
                      ) : null}
                    </View>
                  )}
                </View>
              );
            })}
          </View>
        </Card>
      )}
    </View>
  );
}

export default function QuotaScreen() {
  const navigation = useNavigation<any>();
  const { colors, isDark } = useTheme();
  const { t } = useTranslation('common');
  const insets = useSafeAreaInsets();

  const { snapshot, isLoading, isRefreshing, error, refresh } = useQuotaSnapshot();
  const { config, reload: reloadConfig } = useQuotaConfig();
  const [section, setSection] = useState<Section>('overview');
  const [period, setPeriod] = useState<InsightPeriod>('7d');

  useEffect(() => {
    void reloadConfig();
  }, [reloadConfig]);

  const ctx: Ctx = useMemo(
    () => ({
      colors,
      isDark,
      t: (key: string, fallback?: string, opts?: Record<string, unknown>) =>
        (t as any)(key, { defaultValue: fallback, ...(opts ?? {}) }),
    }),
    [colors, isDark, t],
  );

  const retryAll = useCallback(() => {
    void refresh();
    void reloadConfig();
  }, [refresh, reloadConfig]);

  return (
    <View style={{ flex: 1, backgroundColor: colors.background }}>
      <View
        style={{
          flexDirection: 'row',
          alignItems: 'center',
          gap: 8,
          paddingHorizontal: 12,
          paddingVertical: 6,
          borderBottomWidth: StyleSheet.hairlineWidth,
          borderBottomColor: colors.border,
        }}
      >
        <TouchableOpacity
          onPress={() => navigation.navigate('Main', { screen: 'Projects' })}
          hitSlop={8}
          style={{ flexDirection: 'row', alignItems: 'center', gap: 4, padding: 4 }}
        >
          <ArrowLeft size={18} color={colors.foreground} />
        </TouchableOpacity>
        <Text style={{ flex: 1, fontSize: 15, fontWeight: '700', color: colors.foreground }}>
          {t('quota.controlCenter', 'AI Control Center')}
        </Text>
        <PillBar
          colors={colors}
          value={period}
          onChange={setPeriod}
          items={RANGES.map((id) => ({ id, label: t(`quota.range.${id}`, id) }))}
        />
        <TouchableOpacity disabled={isRefreshing} onPress={() => void refresh()} hitSlop={8} style={{ padding: 6 }}>
          <RefreshCw size={16} color={isRefreshing ? colors.primary : colors.mutedForeground} />
        </TouchableOpacity>
      </View>

      <View
        style={{
          flexDirection: 'row',
          gap: 4,
          paddingHorizontal: 12,
          paddingVertical: 6,
          borderBottomWidth: StyleSheet.hairlineWidth,
          borderBottomColor: colors.border,
        }}
      >
        {SECTIONS.map(({ id, Icon, key, fallback }) => {
          const active = section === id;
          return (
            <TouchableOpacity
              key={id}
              onPress={() => setSection(id)}
              style={{
                flexDirection: 'row',
                alignItems: 'center',
                gap: 6,
                paddingHorizontal: 12,
                paddingVertical: 6,
                borderRadius: 8,
                backgroundColor: active ? colors.muted : 'transparent',
              }}
            >
              <Icon size={14} color={active ? colors.foreground : colors.mutedForeground} />
              <Text
                style={{
                  fontSize: 13,
                  fontWeight: '600',
                  color: active ? colors.foreground : colors.mutedForeground,
                }}
              >
                {t(key, fallback)}
              </Text>
            </TouchableOpacity>
          );
        })}
      </View>

      <ScrollView
        contentContainerStyle={{ padding: 16, paddingBottom: 16 + insets.bottom, gap: 16 }}
        refreshControl={<RefreshControl refreshing={isRefreshing} onRefresh={retryAll} tintColor={colors.primary} />}
      >
        {isLoading && !snapshot ? (
          <ActivityIndicator color={colors.primary} style={{ marginTop: 32 }} />
        ) : (
          <>
            {error && (
              <Text style={{ fontSize: 12, color: '#dc2626' }}>
                {error} · {t('quota.syncNow', 'Sync now')}
              </Text>
            )}
            {section === 'overview' && (
              <OverviewPanel
                snapshot={snapshot}
                config={config}
                period={period}
                onOpenQuotas={() => setSection('quotas')}
                onOpenAgents={() => setSection('agents')}
                ctx={ctx}
              />
            )}
            {section === 'quotas' && (
              <QuotasPanel snapshot={snapshot} config={config} isRefreshing={isRefreshing} refresh={refresh} ctx={ctx} />
            )}
            {section === 'usage' && <UsagePanel ctx={ctx} />}
            {section === 'agents' && <AgentsPanel ctx={ctx} />}
          </>
        )}
      </ScrollView>
    </View>
  );
}
