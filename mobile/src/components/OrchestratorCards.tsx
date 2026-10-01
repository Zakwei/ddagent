import React, { useState } from 'react';
import { ActivityIndicator, Text, TouchableOpacity, View } from 'react-native';
import Markdown from 'react-native-markdown-display';
import {
  ArrowRight,
  CheckCircle2,
  ChevronRight,
  CircleSlash,
  Compass,
  ExternalLink,
  HelpCircle,
  ListChecks,
  Loader2,
  Route,
  Sparkles,
  Target,
  XCircle,
} from 'lucide-react-native';

import { authenticatedFetch } from '~shared/utils/api';
import { getLanguage } from '../i18n';
import { useTheme, type ThemeColors } from '../theme';
import { createMarkdownRules } from './MarkdownBlocks';
import {
  delegationStatusTone,
  planSourceNote,
  readPlanSteps,
  readString,
  readStringList,
  truncateFinalText,
  type DelegationTone,
  type OrchestratorCardData,
  type OrchestratorPlanStep,
} from '../lib/orchestrator-cards';

/**
 * Specialized cards for orchestrated ("Auto") sessions — the mobile twin of
 * web `src/components/chat/view/subcomponents/OrchestratorCards.tsx`. Each row
 * of the parent transcript arrives as a `status` message whose `context`
 * carries `orchestratorKind` + the backend payload verbatim, so the cards read
 * fields defensively and tolerate unknown keys.
 */

type NavigateToSession = (sessionId: string) => void;

type CardColors = ThemeColors & { isDark: boolean };

const TONE_COLORS: Record<DelegationTone, { light: string; dark: string }> = {
  muted: { light: '#6b7280', dark: '#a1a1aa' },
  info: { light: '#2563eb', dark: '#60a5fa' },
  success: { light: '#059669', dark: '#34d399' },
  danger: { light: '#dc2626', dark: '#f87171' },
  warning: { light: '#d97706', dark: '#fbbf24' },
};

const toneColor = (tone: DelegationTone, isDark: boolean) =>
  isDark ? TONE_COLORS[tone].dark : TONE_COLORS[tone].light;

const cardFrame = (colors: CardColors) => ({
  borderWidth: 1,
  borderColor: colors.border,
  borderRadius: 10,
  backgroundColor: colors.card,
  paddingHorizontal: 10,
  paddingVertical: 8,
  marginBottom: 8,
});

function Badge({ label, colors, tone }: { label: string; colors: CardColors; tone?: string }) {
  return (
    <View
      style={{
        borderWidth: 1,
        borderColor: tone ?? colors.border,
        borderRadius: 6,
        paddingHorizontal: 5,
        paddingVertical: 1,
      }}
    >
      <Text style={{ fontSize: 10, color: tone ?? colors.mutedForeground }}>{label}</Text>
    </View>
  );
}

function StatusIcon({ status, color }: { status: string; color: string }) {
  switch (status) {
    case 'running':
      return <Loader2 size={11} color={color} />;
    case 'done':
      return <CheckCircle2 size={11} color={color} />;
    case 'failed':
      return <XCircle size={11} color={color} />;
    case 'awaiting_decision':
      return <HelpCircle size={11} color={color} />;
    case 'skipped':
    case 'aborted':
      return <CircleSlash size={11} color={color} />;
    default:
      return null;
  }
}

function RoutingCard({ data, colors }: { data: OrchestratorCardData; colors: CardColors }) {
  const taskType = readString(data.taskType);
  const provider = readString(data.provider);
  const model = readString(data.model);
  const effort = readString(data.effort);
  const tier = readString(data.tier);
  const reason = readString(data.reason);
  const error =
    readString(data.error) ?? (data.status === 'no_candidate' ? readString(data.status) : null);
  const alternatives = readStringList(data.alternatives);

  return (
    <View style={cardFrame(colors)}>
      <View style={{ flexDirection: 'row', flexWrap: 'wrap', alignItems: 'center', gap: 5 }}>
        <Route size={13} color={colors.mutedForeground} />
        {taskType ? <Badge label={taskType} colors={colors} /> : null}
        {provider ? (
          <>
            <ArrowRight size={11} color={colors.mutedForeground} />
            <Text style={{ fontSize: 12, fontWeight: '500', color: colors.foreground }}>
              {provider}
            </Text>
            {model ? (
              <Text style={{ fontSize: 12, color: colors.mutedForeground }}>· {model}</Text>
            ) : null}
            {effort ? (
              <Text style={{ fontSize: 12, color: colors.mutedForeground }}>· {effort}</Text>
            ) : null}
            {tier ? <Badge label={tier} colors={colors} /> : null}
          </>
        ) : (
          <Text
            style={{
              fontSize: 12,
              color: error ? toneColor('danger', colors.isDark) : colors.mutedForeground,
            }}
          >
            Routing
          </Text>
        )}
      </View>
      {reason ? (
        <Text style={{ marginTop: 4, fontSize: 12, color: colors.mutedForeground }}>{reason}</Text>
      ) : null}
      {error ? (
        <Text style={{ marginTop: 4, fontSize: 12, color: toneColor('danger', colors.isDark) }}>
          {error}
        </Text>
      ) : null}
      {alternatives.length > 0 ? (
        <Text style={{ marginTop: 2, fontSize: 11, color: colors.mutedForeground }}>
          Alternatives: {alternatives.join(', ')}
        </Text>
      ) : null}
    </View>
  );
}

function PlanCard({
  data,
  sessionId,
  colors,
}: {
  data: OrchestratorCardData;
  sessionId?: string | null;
  colors: CardColors;
}) {
  const steps = readPlanSteps(data.steps);
  const awaitingConfirm = data.awaitingConfirm === true;
  const sourceNote = planSourceNote(data.source);
  const goals = readString(data.goals);
  const doneWhen = readStringList(data.doneWhen);
  const requiresTests = data.requiresTests === true;
  // A supervised run parks on the goal contract with an empty step list —
  // confirming goals posts an empty steps array, which the server ignores.
  const goalsParked = awaitingConfirm && steps.length === 0 && (goals !== null || doneWhen.length > 0);
  // Local copy lets the user disable steps before confirming; prompts are
  // server-side (pending plan stash), the wire sends the row fields only.
  const [edited, setEdited] = useState<OrchestratorPlanStep[] | null>(null);
  const [submitState, setSubmitState] = useState<'idle' | 'sending' | 'failed'>('idle');
  const shown = edited ?? steps;

  const toggleStep = (id: string) => {
    setEdited(shown.map((s) => (s.id === id ? { ...s, enabled: !s.enabled } : s)));
  };

  const confirmPlan = async () => {
    if (!sessionId || submitState === 'sending') return;
    setSubmitState('sending');
    try {
      const response = await authenticatedFetch('/api/orchestrator/plan/confirm', {
        method: 'POST',
        body: JSON.stringify({ sessionId, steps: goalsParked ? [] : shown, language: getLanguage() }),
      });
      setSubmitState(response.ok ? 'idle' : 'failed');
    } catch {
      setSubmitState('failed');
    }
  };

  const canConfirm = goalsParked || shown.some((s) => s.enabled);

  return (
    <View style={cardFrame(colors)}>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 5 }}>
        <ListChecks size={13} color={colors.mutedForeground} />
        <Text style={{ fontSize: 12, fontWeight: '500', color: colors.foreground }}>Plan</Text>
        <Badge label={`${shown.length} steps`} colors={colors} />
        {sourceNote ? (
          <Text style={{ flex: 1, fontSize: 10, textAlign: 'right', color: colors.mutedForeground }}>
            {sourceNote}
          </Text>
        ) : null}
      </View>
      {goals || doneWhen.length > 0 ? (
        <View
          style={{
            marginTop: 6,
            borderWidth: 1,
            borderColor: colors.border,
            borderRadius: 8,
            padding: 8,
            gap: 4,
          }}
        >
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 5 }}>
            <Target size={12} color={colors.mutedForeground} />
            <Text style={{ fontSize: 11, fontWeight: '600', color: colors.mutedForeground }}>
              Goals
            </Text>
            {requiresTests ? <Badge label="tests required" colors={colors} /> : null}
          </View>
          {goals ? <Text style={{ fontSize: 12, color: colors.foreground }}>{goals}</Text> : null}
          {doneWhen.map((criterion, index) => (
            <View key={index} style={{ flexDirection: 'row', alignItems: 'flex-start', gap: 6 }}>
              <CheckCircle2 size={11} color={colors.mutedForeground} style={{ marginTop: 2 }} />
              <Text style={{ flex: 1, fontSize: 11, color: colors.mutedForeground }}>{criterion}</Text>
            </View>
          ))}
        </View>
      ) : null}
      {shown.map((step, index) => (
        <View
          key={step.id}
          style={{
            flexDirection: 'row',
            alignItems: 'center',
            gap: 6,
            marginTop: 4,
            opacity: step.enabled ? 1 : 0.5,
          }}
        >
          {awaitingConfirm ? (
            <TouchableOpacity
              onPress={() => toggleStep(step.id)}
              hitSlop={8}
              accessibilityRole="checkbox"
              accessibilityState={{ checked: step.enabled }}
              accessibilityLabel="Enable step"
            >
              <View
                style={{
                  width: 14,
                  height: 14,
                  borderRadius: 3,
                  borderWidth: 1,
                  borderColor: step.enabled ? colors.primary : colors.border,
                  backgroundColor: step.enabled ? colors.primary : 'transparent',
                }}
              />
            </TouchableOpacity>
          ) : (
            <Text style={{ width: 16, fontSize: 12, textAlign: 'right', color: colors.mutedForeground }}>
              {index + 1}.
            </Text>
          )}
          <Badge label={step.type} colors={colors} />
          <Text
            numberOfLines={1}
            style={{ flex: 1, fontSize: 12, color: colors.foreground }}
          >
            {step.title}
          </Text>
          {!step.enabled ? (
            <Text style={{ fontSize: 10, color: colors.mutedForeground }}>disabled</Text>
          ) : null}
        </View>
      ))}
      {awaitingConfirm ? (
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, marginTop: 6 }}>
          <TouchableOpacity
            onPress={() => void confirmPlan()}
            disabled={!sessionId || submitState === 'sending' || !canConfirm}
            accessibilityRole="button"
            accessibilityLabel={goalsParked ? 'Confirm goals' : 'Run plan'}
            style={{
              flexDirection: 'row',
              alignItems: 'center',
              backgroundColor: colors.primary,
              borderRadius: 6,
              paddingHorizontal: 8,
              paddingVertical: 3,
              opacity: !sessionId || submitState === 'sending' || !canConfirm ? 0.5 : 1,
            }}
          >
            {submitState === 'sending' ? (
              <ActivityIndicator size="small" color={colors.primaryForeground} style={{ marginRight: 4 }} />
            ) : null}
            <Text style={{ fontSize: 11, fontWeight: '600', color: colors.primaryForeground }}>
              {goalsParked ? 'Confirm goals' : 'Run plan'}
            </Text>
          </TouchableOpacity>
          <Text
            style={{
              fontSize: 11,
              color: submitState === 'failed' ? toneColor('danger', colors.isDark) : toneColor('warning', colors.isDark),
            }}
          >
            {submitState === 'failed'
              ? 'Failed to start — try again.'
              : goalsParked
                ? 'Waiting for goals confirmation.'
                : 'Waiting for plan confirmation.'}
          </Text>
        </View>
      ) : null}
    </View>
  );
}

/**
 * One supervisor decision in a supervised run — the action badge plus the
 * reason are the point: the user should see why the loop keeps working.
 * While `awaitingConfirm` the proposed batch is toggleable like the plan card.
 */
function DecisionCard({
  data,
  sessionId,
  colors,
}: {
  data: OrchestratorCardData;
  sessionId?: string | null;
  colors: CardColors;
}) {
  const iteration = typeof data.iteration === 'number' ? data.iteration : null;
  const action = readString(data.action) ?? 'continue';
  const outcome = readString(data.outcome);
  const reason = readString(data.reason);
  const gateOverride = readString(data.gateOverride);
  const forcedStepId = readString(data.forcedStepId);
  const steps = readPlanSteps(data.steps);
  const awaitingConfirm = data.awaitingConfirm === true;
  const [edited, setEdited] = useState<OrchestratorPlanStep[] | null>(null);
  const [submitState, setSubmitState] = useState<'idle' | 'sending' | 'failed'>('idle');
  const shown = edited ?? steps;

  const actionTone =
    action === 'done' ? 'success' : action === 'invalid' ? 'danger' : 'info';

  const toggleStep = (id: string) => {
    setEdited(shown.map((s) => (s.id === id ? { ...s, enabled: !s.enabled } : s)));
  };

  const confirm = async () => {
    if (!sessionId || submitState === 'sending') return;
    setSubmitState('sending');
    try {
      const response = await authenticatedFetch('/api/orchestrator/plan/confirm', {
        method: 'POST',
        body: JSON.stringify({ sessionId, steps: shown, language: getLanguage() }),
      });
      setSubmitState(response.ok ? 'idle' : 'failed');
    } catch {
      setSubmitState('failed');
    }
  };

  return (
    <View style={cardFrame(colors)}>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 5 }}>
        <Compass size={13} color={colors.mutedForeground} />
        <Text style={{ fontSize: 12, fontWeight: '500', color: colors.foreground }}>
          Decision{iteration !== null ? ` #${iteration}` : ''}
        </Text>
        <Badge label={action} colors={colors} tone={toneColor(actionTone, colors.isDark)} />
        {outcome ? (
          <Badge label={outcome} colors={colors} tone={toneColor('muted', colors.isDark)} />
        ) : null}
      </View>
      {reason ? (
        <Text style={{ marginTop: 4, fontSize: 12, color: colors.foreground }}>{reason}</Text>
      ) : null}
      {shown.map((step, index) => (
        <View
          key={step.id}
          style={{
            flexDirection: 'row',
            alignItems: 'center',
            gap: 6,
            marginTop: 4,
            opacity: step.enabled ? 1 : 0.5,
          }}
        >
          {awaitingConfirm ? (
            <TouchableOpacity
              onPress={() => toggleStep(step.id)}
              hitSlop={8}
              accessibilityRole="checkbox"
              accessibilityState={{ checked: step.enabled }}
              accessibilityLabel="Enable step"
            >
              <View
                style={{
                  width: 14,
                  height: 14,
                  borderRadius: 3,
                  borderWidth: 1,
                  borderColor: step.enabled ? colors.primary : colors.border,
                  backgroundColor: step.enabled ? colors.primary : 'transparent',
                }}
              />
            </TouchableOpacity>
          ) : (
            <Text style={{ width: 16, fontSize: 12, textAlign: 'right', color: colors.mutedForeground }}>
              {index + 1}.
            </Text>
          )}
          <Badge label={step.type} colors={colors} />
          <Text numberOfLines={1} style={{ flex: 1, fontSize: 12, color: colors.foreground }}>
            {step.title}
          </Text>
        </View>
      ))}
      {gateOverride ? (
        <Text
          style={{ marginTop: 4, fontSize: 11, color: toneColor('warning', colors.isDark) }}
        >
          done rejected by the {gateOverride} gate — forced {forcedStepId ?? 'a step'} first
        </Text>
      ) : null}
      {awaitingConfirm ? (
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, marginTop: 6 }}>
          <TouchableOpacity
            onPress={() => void confirm()}
            disabled={!sessionId || submitState === 'sending'}
            accessibilityRole="button"
            accessibilityLabel="Approve steps"
            style={{
              flexDirection: 'row',
              alignItems: 'center',
              backgroundColor: colors.primary,
              borderRadius: 6,
              paddingHorizontal: 8,
              paddingVertical: 3,
              opacity: !sessionId || submitState === 'sending' ? 0.5 : 1,
            }}
          >
            {submitState === 'sending' ? (
              <ActivityIndicator size="small" color={colors.primaryForeground} style={{ marginRight: 4 }} />
            ) : null}
            <Text style={{ fontSize: 11, fontWeight: '600', color: colors.primaryForeground }}>
              Approve steps
            </Text>
          </TouchableOpacity>
          <Text
            style={{
              fontSize: 11,
              color: submitState === 'failed' ? toneColor('danger', colors.isDark) : toneColor('warning', colors.isDark),
            }}
          >
            {submitState === 'failed' ? 'Failed — try again.' : 'Waiting for approval.'}
          </Text>
        </View>
      ) : null}
    </View>
  );
}

function DelegationCard({
  data,
  colors,
  onNavigateToSession,
}: {
  data: OrchestratorCardData;
  colors: CardColors;
  onNavigateToSession?: NavigateToSession;
}) {
  const status = readString(data.status) ?? 'queued';
  const title = readString(data.title);
  const provider = readString(data.provider);
  const model = readString(data.model);
  const effort = readString(data.effort);
  const tier = readString(data.tier);
  const lastEvent = readString(data.lastEvent);
  const error = readString(data.error);
  const childSessionId = readString(data.childSessionId);
  const finalText = truncateFinalText(data.finalText);
  const attempt = typeof data.attempt === 'number' && data.attempt > 1 ? data.attempt : null;
  const tone = delegationStatusTone(status);
  const statusColor = toneColor(tone, colors.isDark);
  const [open, setOpen] = useState(status === 'running');

  return (
    <View style={cardFrame(colors)}>
      <TouchableOpacity
        onPress={() => setOpen((o) => !o)}
        accessibilityRole="button"
        accessibilityLabel={`${title ?? readString(data.stepId) ?? 'Delegated step'} — ${status}`}
        accessibilityState={{ expanded: open }}
        style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}
      >
        <View style={{ transform: [{ rotate: open ? '90deg' : '0deg' }] }}>
          <ChevronRight size={13} color={colors.mutedForeground} />
        </View>
        <Text numberOfLines={1} style={{ flex: 1, fontSize: 12, fontWeight: '500', color: colors.foreground }}>
          {title ?? readString(data.stepId) ?? 'Delegated step'}
        </Text>
        {attempt ? (
          <Text style={{ fontSize: 10, color: colors.mutedForeground }}>attempt {attempt}</Text>
        ) : null}
        <View
          style={{
            flexDirection: 'row',
            alignItems: 'center',
            gap: 3,
            borderWidth: 1,
            borderColor: statusColor,
            borderRadius: 6,
            paddingHorizontal: 5,
            paddingVertical: 1,
          }}
        >
          <StatusIcon status={status} color={statusColor} />
          <Text
            style={{
              fontSize: 10,
              color: statusColor,
              textDecorationLine: status === 'skipped' ? 'line-through' : 'none',
            }}
          >
            {status}
          </Text>
        </View>
      </TouchableOpacity>
      {provider ? (
        <View style={{ flexDirection: 'row', flexWrap: 'wrap', alignItems: 'center', gap: 4, marginTop: 2, paddingLeft: 19 }}>
          <Text style={{ fontSize: 11, color: colors.mutedForeground }}>
            {provider}
            {model ? ` · ${model}` : ''}
            {effort ? ` · ${effort}` : ''}
          </Text>
          {tier ? <Badge label={tier} colors={colors} /> : null}
        </View>
      ) : null}
      {open ? (
        <View style={{ marginTop: 6, borderTopWidth: 1, borderTopColor: colors.border, paddingTop: 6 }}>
          {error ? (
            <Text style={{ fontSize: 12, color: toneColor('danger', colors.isDark) }}>{error}</Text>
          ) : null}
          {lastEvent && status !== 'done' ? (
            <Text style={{ fontSize: 12, color: colors.mutedForeground }}>{lastEvent}</Text>
          ) : null}
          {status === 'done' && finalText ? (
            <Text style={{ fontSize: 12, color: colors.foreground }}>{finalText}</Text>
          ) : null}
          {childSessionId && onNavigateToSession ? (
            <TouchableOpacity
              onPress={() => onNavigateToSession(childSessionId)}
              accessibilityRole="link"
              accessibilityLabel="Open full session"
              hitSlop={6}
              style={{ flexDirection: 'row', alignItems: 'center', gap: 4, marginTop: 6 }}
            >
              <ExternalLink size={11} color={colors.primary} />
              <Text style={{ fontSize: 12, color: colors.primary }}>Open full session</Text>
            </TouchableOpacity>
          ) : null}
        </View>
      ) : null}
    </View>
  );
}

function SummaryCard({
  data,
  sessionId,
  colors,
}: {
  data: OrchestratorCardData;
  sessionId?: string | null;
  colors: CardColors;
}) {
  const text = readString(data.text);
  const failed = readStringList(data.failed);
  const report = readString(data.report);
  const outcome = readString(data.outcome);
  const supervisorError = readString(data.supervisorError);
  const iterations = typeof data.iterations === 'number' ? data.iterations : null;
  const capped = data.capped === true;
  const [submitState, setSubmitState] = useState<'idle' | 'sending' | 'failed'>('idle');

  const resume = async () => {
    if (!sessionId || submitState === 'sending') return;
    setSubmitState('sending');
    try {
      const response = await authenticatedFetch(
        `/api/orchestrator/sessions/${encodeURIComponent(sessionId)}/resume`,
        { method: 'POST', body: JSON.stringify({ language: getLanguage() }) },
      );
      setSubmitState(response.ok ? 'idle' : 'failed');
    } catch {
      setSubmitState('failed');
    }
  };

  return (
    <View style={[cardFrame(colors), { borderColor: colors.primary }]}>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 5 }}>
        <Sparkles size={13} color={colors.mutedForeground} />
        <Text style={{ fontSize: 12, fontWeight: '500', color: colors.foreground }}>Summary</Text>
        {outcome ? (
          <Badge
            label={outcome}
            colors={colors}
            tone={toneColor(
              outcome === 'ok' ? 'success' : outcome === 'failed' || outcome === 'aborted' ? 'danger' : 'warning',
              colors.isDark,
            )}
          />
        ) : null}
        {iterations !== null ? (
          <Text style={{ fontSize: 10, color: colors.mutedForeground }}>
            {iterations} iterations{capped ? ' · capped' : ''}
          </Text>
        ) : null}
      </View>
      {text ? (
        <Text style={{ marginTop: 4, fontSize: 12, color: colors.foreground }}>{text}</Text>
      ) : null}
      {supervisorError ? (
        <Text style={{ marginTop: 4, fontSize: 11, color: toneColor('danger', colors.isDark) }}>
          {supervisorError}
        </Text>
      ) : null}
      {report ? (
        <View style={{ marginTop: 6, borderTopWidth: 1, borderTopColor: colors.border, paddingTop: 6 }}>
          <Markdown rules={createMarkdownRules({ colors, isDark: colors.isDark })} style={{ body: { fontSize: 12, color: colors.foreground } }}>
            {report}
          </Markdown>
        </View>
      ) : null}
      {failed.length > 0 ? (
        <>
          <Text style={{ marginTop: 4, fontSize: 12, color: toneColor('danger', colors.isDark) }}>
            Failed steps: {failed.join(', ')}
          </Text>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, marginTop: 6 }}>
            <TouchableOpacity
              onPress={() => void resume()}
              disabled={!sessionId || submitState === 'sending'}
              accessibilityRole="button"
              accessibilityLabel="Continue"
              style={{
                backgroundColor: colors.primary,
                borderRadius: 6,
                paddingHorizontal: 8,
                paddingVertical: 3,
                opacity: !sessionId || submitState === 'sending' ? 0.5 : 1,
              }}
            >
              <Text style={{ fontSize: 11, fontWeight: '600', color: colors.primaryForeground }}>
                Continue
              </Text>
            </TouchableOpacity>
            {submitState === 'sending' ? (
              <ActivityIndicator size="small" color={colors.mutedForeground} />
            ) : null}
            {submitState === 'failed' ? (
              <Text style={{ fontSize: 11, color: toneColor('danger', colors.isDark) }}>
                Failed to resume — try again.
              </Text>
            ) : null}
          </View>
        </>
      ) : null}
    </View>
  );
}

/**
 * Renders one orchestrator transcript row. Unknown kinds degrade to a muted
 * generic card so a newer backend never renders an empty slot in the feed.
 */
export function OrchestratorCard({
  data,
  sessionId,
  onNavigateToSession,
}: {
  data: OrchestratorCardData;
  sessionId?: string | null;
  onNavigateToSession?: NavigateToSession;
}) {
  const theme = useTheme();
  const colors: CardColors = { ...theme.colors, isDark: theme.isDark };

  switch (data.kind) {
    case 'routing':
      return <RoutingCard data={data} colors={colors} />;
    case 'plan':
      return <PlanCard data={data} sessionId={sessionId} colors={colors} />;
    case 'decision':
      return <DecisionCard data={data} sessionId={sessionId} colors={colors} />;
    case 'delegation':
      return <DelegationCard data={data} colors={colors} onNavigateToSession={onNavigateToSession} />;
    case 'summary':
      return <SummaryCard data={data} sessionId={sessionId} colors={colors} />;
    default:
      return (
        <View style={cardFrame(colors)}>
          <Text style={{ fontSize: 12, color: colors.mutedForeground }}>{data.kind}</Text>
        </View>
      );
  }
}

export default OrchestratorCard;
