import type {
  InsightPeriod,
  UsageBucket,
  UsageGroupBy,
  UsageSummary,
  UsageTotals,
  UsageTrendPoint,
} from '@/shared/types.js';
import type { InsightSession, InsightSource } from '@/modules/quota/services/insights-source.service.js';
import { addSessionTotals } from '@/modules/quota/services/insights-source.service.js';

/** Milliseconds per hour, used to turn a period into a cutoff. */
const HOUR_MS = 3_600_000;

const PERIOD_HOURS: Record<Exclude<InsightPeriod, 'all'>, number> = {
  '24h': 24,
  '7d': 24 * 7,
  '30d': 24 * 30,
};

const PERIODS: InsightPeriod[] = ['24h', '7d', '30d', 'all'];
const GROUP_BYS: UsageGroupBy[] = ['provider', 'model', 'agent', 'tool'];

export type UsageServiceDependencies = {
  source: InsightSource;
  now: () => number;
};

/** Empty accumulator with every counter at zero. */
function emptyTotals(): UsageTotals {
  return {
    tokensInput: 0,
    tokensOutput: 0,
    tokensReasoning: 0,
    tokensCacheRead: 0,
    tokensCacheWrite: 0,
    tokensTotal: 0,
    apiCalls: 0,
    costUsd: 0,
    sessions: 0,
  };
}

export function isInsightPeriod(value: unknown): value is InsightPeriod {
  return typeof value === 'string' && PERIODS.includes(value as InsightPeriod);
}

export function isUsageGroupBy(value: unknown): value is UsageGroupBy {
  return typeof value === 'string' && GROUP_BYS.includes(value as UsageGroupBy);
}

/** Derives the bucket key and display label for one session on one dimension. */
function bucketOf(session: InsightSession, groupBy: UsageGroupBy): { key: string; label: string } {
  switch (groupBy) {
    case 'provider': {
      const key = session.provider || session.subscription || 'unknown';
      return { key, label: key };
    }
    case 'tool':
      return { key: session.source || 'unknown', label: session.source || 'unknown' };
    case 'model':
      return { key: session.model || 'unknown', label: session.model || 'unknown' };
    case 'agent':
      return { key: session.agent || 'unassigned', label: session.agent || 'unassigned' };
  }
}

/** UTC date (YYYY-MM-DD) of a Unix epoch in seconds. */
function utcDate(epochSeconds: number): string {
  return new Date(epochSeconds * 1000).toISOString().slice(0, 10);
}

/**
 * Aggregates the external analytics store into the Usage and Overview payloads.
 *
 * All filtering and grouping happens in memory because the source is a single
 * read-only query: the analytics store is owned by another process and is small
 * enough (thousands of rows) that one sweep per request stays cheap. The
 * service never mutates the store.
 */
export function createUsageService(dependencies: UsageServiceDependencies) {
  /** Reads and filters sessions for a period, newest first. */
  function selectSessions(period: InsightPeriod, now: number): InsightSession[] {
    const sessions = dependencies.source.loadSessions();
    if (period === 'all') {
      return sessions;
    }

    const cutoff = now - PERIOD_HOURS[period] * HOUR_MS;
    return sessions.filter((session) => {
      const stamp = session.endedAt ?? session.startedAt;
      return stamp !== null && stamp * 1000 >= cutoff;
    });
  }

  return {
    /**
     * Builds one usage summary.
     *
     * `cacheSavingsUsd` and `effectiveCost` use the analytics price table keyed
     * by model: cache reads are billed at the cache rate, so the saving is the
     * difference against the full input rate. Models missing from the table
     * simply contribute nothing rather than guessing a price.
     */
    getSummary(input: { period: InsightPeriod; groupBy: UsageGroupBy }): UsageSummary {
      const now = dependencies.now();
      const sessions = selectSessions(input.period, now);

      const totals = emptyTotals();
      const bucketMap = new Map<string, UsageBucket>();
      const trendMap = new Map<string, UsageTrendPoint>();
      let cacheSavingsUsd = 0;
      let listPriceUsd = 0;

      for (const session of sessions) {
        addSessionTotals(totals, session);

        const { key, label } = bucketOf(session, input.groupBy);
        const bucket = bucketMap.get(key) ?? { ...emptyTotals(), key, label };
        addSessionTotals(bucket, session);
        bucketMap.set(key, bucket);

        const stamp = session.endedAt ?? session.startedAt;
        if (stamp !== null) {
          const date = utcDate(stamp);
          const point = trendMap.get(date) ?? { date, tokensTotal: 0, costUsd: 0 };
          point.tokensTotal +=
            session.tokensInput +
            session.tokensOutput +
            session.tokensReasoning +
            session.tokensCacheRead +
            session.tokensCacheWrite;
          point.costUsd += session.costUsd;
          trendMap.set(date, point);
        }

        const price = dependencies.source.priceFor(session.model);
        if (price) {
          // Cache reads cost `cacheRead`, not the full input rate; the gap is
          // the saving. Reasoning and output are priced at the output rate.
          cacheSavingsUsd +=
            (session.tokensCacheRead * (price.input - price.cacheRead)) / 1_000_000;
          listPriceUsd +=
            (session.tokensInput * price.input +
              session.tokensOutput * price.output +
              session.tokensReasoning * price.output +
              session.tokensCacheRead * price.cacheRead +
              session.tokensCacheWrite * price.input) /
            1_000_000;
        }
      }

      const buckets = Array.from(bucketMap.values()).sort((a, b) => b.tokensTotal - a.tokensTotal);
      const trend = Array.from(trendMap.values()).sort((a, b) => a.date.localeCompare(b.date));

      return {
        period: input.period,
        groupBy: input.groupBy,
        totals,
        buckets,
        trend,
        cacheSavingsUsd,
        effectiveCost: {
          billedUsd: totals.costUsd,
          listPriceUsd,
          // Subscription-backed work bills 0 for tokens already covered by the
          // plan; the list-price value is what that quota actually delivered.
          subscriptionValueUsd: Math.max(0, listPriceUsd - totals.costUsd),
        },
        source: dependencies.source.available
          ? `insights:${dependencies.source.path ?? 'unknown'}`
          : 'unavailable',
        generatedAt: new Date(now).toISOString(),
      };
    },
  };
}

export type UsageService = ReturnType<typeof createUsageService>;
