import React, { useState } from 'react';
import {
  FlatList,
  Image,
  Modal,
  ScrollView,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import {
  Activity,
  BadgeCheck,
  Check,
  CornerDownLeft,
  Cpu,
  Coins,
  FileText,
  Folder,
  Gauge,
  ListTodo,
  MessageSquare,
  Package,
  Server,
  Sparkles,
  Star,
  Terminal,
  Timer,
  User,
  X,
} from 'lucide-react-native';

import type { ThemeColors } from '../theme';
import { HighlightText } from './HighlightText';
import {
  type CommandGroup,
  type CommandModalPayload,
  type MentionableItem,
  attachmentKind,
  attachmentKindLabel,
} from '../lib/composer';

const MONO = 'Menlo';

const NAMESPACE_ICON: Record<string, React.ComponentType<{ size?: number; color?: string }>> = {
  frequent: Star,
  builtin: Terminal,
  skill: Sparkles,
  project: Folder,
  user: User,
  other: MessageSquare,
};

const MENTION_ICON: Record<string, React.ComponentType<{ size?: number; color?: string }>> = {
  file: FileText,
  session: MessageSquare,
  task: ListTodo,
};

const MENTION_TINT: Record<string, string> = {
  file: '#94a3b8',
  session: '#3b82f6',
  task: '#f59e0b',
};

export function MentionDropdown({
  items,
  selectedIndex,
  colors,
  onPick,
}: {
  items: MentionableItem[];
  selectedIndex: number;
  colors: ThemeColors;
  onPick: (item: MentionableItem) => void;
}) {
  if (items.length === 0) return null;
  return (
    <View style={{ backgroundColor: colors.card, borderTopWidth: 1, borderTopColor: colors.border, maxHeight: 240 }}>
      <FlatList
        keyboardShouldPersistTaps="handled"
        data={items}
        keyExtractor={(m) => `${m.type}-${m.id}`}
        renderItem={({ item, index }) => {
          const Icon = MENTION_ICON[item.type] ?? FileText;
          const on = index === selectedIndex;
          return (
            <TouchableOpacity
              onPress={() => onPick(item)}
              style={{ flexDirection: 'row', alignItems: 'center', minHeight: 44, paddingHorizontal: 14, paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: colors.border, backgroundColor: on ? colors.accent : 'transparent' }}
            >
              <View style={{ width: 28, height: 28, borderRadius: 6, borderWidth: 1, borderColor: colors.border, alignItems: 'center', justifyContent: 'center', marginRight: 10 }}>
                <Icon size={15} color={MENTION_TINT[item.type] ?? colors.mutedForeground} />
              </View>
              <View style={{ flex: 1, minWidth: 0 }}>
                <Text style={{ color: on ? colors.accentForeground : colors.foreground, fontSize: 14, fontWeight: '500' }} numberOfLines={1}>
                  {item.title}
                </Text>
                {!!item.subtitle && item.subtitle !== item.title && (
                  <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: MONO, marginTop: 1 }} numberOfLines={1}>
                    {item.subtitle}
                  </Text>
                )}
              </View>
              <Text style={{ color: colors.mutedForeground, fontSize: 9, fontWeight: '700', letterSpacing: 0.6, textTransform: 'uppercase', marginLeft: 8, borderWidth: 1, borderColor: colors.border, borderRadius: 4, paddingHorizontal: 5, paddingVertical: 2 }}>
                {item.type}
              </Text>
            </TouchableOpacity>
          );
        }}
      />
    </View>
  );
}

export function CommandMenuList({
  groups,
  flatRows,
  selectedIndex,
  colors,
  onPick,
}: {
  groups: CommandGroup[];
  flatRows: { commandIndex: number }[];
  selectedIndex: number;
  colors: ThemeColors;
  onPick: (commandIndex: number) => void;
}) {
  if (groups.length === 0) {
    return (
      <View style={{ backgroundColor: colors.card, borderTopWidth: 1, borderTopColor: colors.border, padding: 20 }}>
        <Text style={{ color: colors.mutedForeground, textAlign: 'center', fontSize: 13 }}>No commands available</Text>
      </View>
    );
  }
  const flatIndexByCommandIndex = new Map(flatRows.map((row, i) => [row.commandIndex, i]));
  return (
    <View style={{ backgroundColor: colors.card, borderTopWidth: 1, borderTopColor: colors.border, maxHeight: 300 }}>
      <ScrollView keyboardShouldPersistTaps="handled">
        {groups.map((group) => {
          const Icon = NAMESPACE_ICON[group.namespace] ?? MessageSquare;
          return (
            <View key={group.namespace}>
              {groups.length > 1 && (
                <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', paddingHorizontal: 12, paddingTop: 8, paddingBottom: 4 }}>
                  <Text style={{ color: colors.mutedForeground, fontSize: 10, fontWeight: '700', letterSpacing: 0.8, textTransform: 'uppercase' }}>
                    {group.label}
                  </Text>
                  <Text style={{ color: colors.mutedForeground, fontSize: 10 }}>{group.rows.length}</Text>
                </View>
              )}
              {group.rows.map(({ command, commandIndex }) => {
                const flat = flatIndexByCommandIndex.get(commandIndex) ?? -1;
                const on = flat === selectedIndex;
                return (
                  <TouchableOpacity
                    key={`${group.namespace}-${command.name}`}
                    onPress={() => onPick(commandIndex)}
                    style={{ flexDirection: 'row', alignItems: 'center', minHeight: 44, paddingHorizontal: 12, paddingVertical: 8, marginHorizontal: 6, marginBottom: 2, borderRadius: 8, borderWidth: 1, borderColor: on ? colors.primary : 'transparent', backgroundColor: on ? colors.accent : 'transparent' }}
                  >
                    <View style={{ width: 26, height: 26, borderRadius: 6, borderWidth: 1, borderColor: colors.border, alignItems: 'center', justifyContent: 'center', marginRight: 10 }}>
                      <Icon size={14} color={colors.primary} />
                    </View>
                    <View style={{ flex: 1, minWidth: 0 }}>
                      <Text style={{ color: colors.foreground, fontSize: 13, fontWeight: '600', fontFamily: MONO }} numberOfLines={1}>
                        {command.name}
                      </Text>
                      {!!command.description && (
                        <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 1 }} numberOfLines={1}>
                          {command.description}
                        </Text>
                      )}
                    </View>
                    {on && <CornerDownLeft size={14} color={colors.primary} />}
                  </TouchableOpacity>
                );
              })}
            </View>
          );
        })}
      </ScrollView>
    </View>
  );
}

/** Image thumbnail / file kind chip for a pending composer attachment. */
export function ComposerAttachmentChip({
  uri,
  name,
  mimeType,
  size,
  colors,
  onRemove,
  onExpand,
}: {
  uri: string;
  name: string;
  mimeType: string;
  size?: number;
  colors: ThemeColors;
  onRemove: () => void;
  onExpand?: (uri: string) => void;
}) {
  const isImage = attachmentKind(mimeType, name) === 'image';
  const [failed, setFailed] = useState(false);
  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.secondary, borderRadius: 8, paddingHorizontal: 8, paddingVertical: 4, maxWidth: 240 }}>
      {isImage && !failed ? (
        <TouchableOpacity onPress={() => onExpand?.(uri)} disabled={!onExpand}>
          <Image source={{ uri }} style={{ width: 22, height: 22, borderRadius: 4, marginRight: 6 }} onError={() => setFailed(true)} />
        </TouchableOpacity>
      ) : (
        <Text style={{ color: colors.mutedForeground, fontSize: 9, fontWeight: '700', marginRight: 6 }}>
          {attachmentKindLabel(mimeType, name)}
        </Text>
      )}
      <Text style={{ color: colors.secondaryForeground, fontSize: 11, maxWidth: 120 }} numberOfLines={1}>
        {name}
      </Text>
      {typeof size === 'number' && size > 0 && (
        <Text style={{ color: colors.mutedForeground, fontSize: 10, marginLeft: 6 }}>
          {size < 1024 ? `${size} B` : size < 1048576 ? `${Math.round(size / 1024)} KB` : `${(size / 1048576).toFixed(1)} MB`}
        </Text>
      )}
      <TouchableOpacity onPress={onRemove} hitSlop={6} style={{ marginLeft: 6 }}>
        <X size={12} color={colors.secondaryForeground} />
      </TouchableOpacity>
    </View>
  );
}

function MetricRow({ label, value, Icon, colors }: { label: string; value: string; Icon: React.ComponentType<{ size?: number; color?: string }>; colors: ThemeColors }) {
  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', paddingVertical: 10, borderBottomWidth: 1, borderBottomColor: colors.border }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', flex: 1, minWidth: 0 }}>
        <View style={{ width: 30, height: 30, borderRadius: 8, backgroundColor: colors.muted, alignItems: 'center', justifyContent: 'center', marginRight: 10 }}>
          <Icon size={15} color={colors.primary} />
        </View>
        <Text style={{ color: colors.foreground, fontSize: 13 }} numberOfLines={1}>{label}</Text>
      </View>
      <Text style={{ color: colors.foreground, fontSize: 13, fontWeight: '600', fontFamily: MONO }} numberOfLines={1}>{value}</Text>
    </View>
  );
}

const fmtNum = (v: unknown) => {
  const n = Number(v ?? 0);
  return Number.isFinite(n) ? n.toLocaleString() : '0';
};

const fmtCost = (v: unknown) => {
  const n = Number(v ?? 0);
  if (!Number.isFinite(n) || n <= 0) return null;
  return n < 0.01 ? `$${n.toFixed(4)}` : `$${n.toFixed(2)}`;
};

function HelpContent({ data, colors }: { data: Record<string, unknown>; colors: ThemeColors }) {
  const [query, setQuery] = useState('');
  const commands = Array.isArray(data.commands) && data.commands.length > 0
    ? (data.commands as { name: string; description?: string; namespace?: string }[])
    : [{ name: '/help', description: 'Show command documentation and syntax.', namespace: 'builtin' }];
  const q = query.trim().toLowerCase();
  const filtered = q
    ? commands.filter((c) => `${c.name} ${c.description ?? ''} ${c.namespace ?? ''}`.toLowerCase().includes(q))
    : commands;
  return (
    <View style={{ flex: 1 }}>
      <TextInput
        value={query}
        onChangeText={setQuery}
        placeholder="Filter commands…"
        placeholderTextColor={colors.mutedForeground}
        autoCapitalize="none"
        autoCorrect={false}
        style={{ backgroundColor: colors.background, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 10, paddingVertical: 8, marginBottom: 12 }}
      />
      <FlatList
        data={filtered}
        keyExtractor={(c) => `${c.namespace ?? 'builtin'}-${c.name}`}
        keyboardShouldPersistTaps="handled"
        renderItem={({ item: c }) => (
          <View style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 12, padding: 10, marginBottom: 8, backgroundColor: colors.background }}>
            <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between' }}>
              <Text style={{ color: colors.primary, fontFamily: MONO, fontSize: 12, fontWeight: '600' }}>{c.name}</Text>
              <Text style={{ color: colors.mutedForeground, fontSize: 10, textTransform: 'uppercase' }}>{c.namespace ?? 'builtin'}</Text>
            </View>
            <Text style={{ color: colors.mutedForeground, fontSize: 13, marginTop: 6 }}>{c.description ?? 'No description available.'}</Text>
          </View>
        )}
      />
    </View>
  );
}

function ModelsContent({ data, colors, onSelect }: { data: Record<string, unknown>; colors: ThemeColors; onSelect: (model: string) => void }) {
  const current = (data.current as { provider?: string; providerLabel?: string; model?: string } | undefined) ?? {};
  const options = (() => {
    if (Array.isArray(data.availableOptions) && data.availableOptions.length > 0) {
      return (data.availableOptions as { value: string; label?: string; description?: string; tier?: string }[]);
    }
    if (Array.isArray(data.availableModels)) {
      return (data.availableModels as string[]).map((value) => ({ value, label: value }));
    }
    const available = data.available as Record<string, string[]> | undefined;
    if (available) return Object.values(available).flat().map((value) => ({ value, label: value }));
    return [] as { value: string; label?: string; description?: string; tier?: string }[];
  })();
  return (
    <View style={{ flex: 1 }}>
      <Text style={{ color: colors.mutedForeground, fontSize: 11, textTransform: 'uppercase', letterSpacing: 1, marginBottom: 8 }}>
        Active model · {current.providerLabel ?? current.provider ?? 'Unknown'}
      </Text>
      <FlatList
        data={options}
        keyExtractor={(o) => o.value}
        keyboardShouldPersistTaps="handled"
        ListEmptyComponent={<Text style={{ color: colors.mutedForeground, textAlign: 'center', padding: 20 }}>No models available.</Text>}
        renderItem={({ item: o }) => {
          const isCurrent = o.value === current.model;
          return (
            <TouchableOpacity
              onPress={() => onSelect(o.value)}
              style={{ flexDirection: 'row', alignItems: 'center', borderWidth: 1, borderColor: isCurrent ? colors.primary : colors.border, backgroundColor: isCurrent ? colors.accent : colors.background, borderRadius: 12, padding: 12, marginBottom: 8 }}
            >
              <View style={{ flex: 1, minWidth: 0 }}>
                <Text style={{ color: colors.foreground, fontSize: 14, fontWeight: '600' }} numberOfLines={1}>{o.label ?? o.value}</Text>
                {o.label !== o.value && (
                  <Text style={{ color: colors.mutedForeground, fontFamily: MONO, fontSize: 11, marginTop: 2 }} numberOfLines={1}>{o.value}</Text>
                )}
                {!!o.description && <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 4 }} numberOfLines={2}>{o.description}</Text>}
              </View>
              {isCurrent && <BadgeCheck size={16} color={colors.primary} />}
            </TouchableOpacity>
          );
        }}
      />
    </View>
  );
}

function CostContent({ data, colors }: { data: Record<string, unknown>; colors: ThemeColors }) {
  const tokenUsage = (data.tokenUsage as { used?: number; total?: number } | undefined) ?? {};
  const breakdown = (data.tokenBreakdown as { input?: number; output?: number; cacheRead?: number; cacheCreation?: number } | undefined) ?? {};
  const used = Number(tokenUsage.used ?? 0);
  const total = Number(tokenUsage.total ?? 0);
  const cost = fmtCost(data.costUsd);
  const rows: { label: string; value: string; Icon: any }[] = [
    { label: 'Total tokens used', value: fmtNum(used), Icon: Activity },
  ];
  if (typeof breakdown.input === 'number' || typeof breakdown.output === 'number') {
    rows.push({ label: 'Input tokens', value: fmtNum(breakdown.input), Icon: Terminal });
    if (Number(breakdown.cacheRead) > 0) rows.push({ label: 'Cache read tokens', value: fmtNum(breakdown.cacheRead), Icon: Terminal });
    if (Number(breakdown.cacheCreation) > 0) rows.push({ label: 'Cache write tokens', value: fmtNum(breakdown.cacheCreation), Icon: Terminal });
    rows.push({ label: 'Output tokens', value: fmtNum(breakdown.output), Icon: Coins });
  } else {
    rows.push({ label: 'Breakdown', value: 'Unavailable', Icon: Terminal });
  }
  if (total > 0) rows.push({ label: 'Context window', value: fmtNum(total), Icon: Gauge });
  if (cost) rows.push({ label: 'Cost', value: cost, Icon: Coins });
  return (
    <ScrollView>
      {Boolean(data.unsupported) && !!data.message && (
        <View style={{ borderWidth: 1, borderColor: '#f59e0b', borderRadius: 12, padding: 12, marginBottom: 12 }}>
          <Text style={{ color: '#f59e0b', fontSize: 13 }}>{String(data.message)}</Text>
        </View>
      )}
      {!data.unsupported && (
        <View style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 12, paddingHorizontal: 12 }}>
          {rows.map((row) => <MetricRow key={row.label} {...row} colors={colors} />)}
        </View>
      )}
      <View style={{ flexDirection: 'row', marginTop: 12 }}>
        <View style={{ flex: 1 }}>
          <Text style={{ color: colors.mutedForeground, fontSize: 10, textTransform: 'uppercase', letterSpacing: 1 }}>Provider</Text>
          <Text style={{ color: colors.foreground, fontSize: 13, marginTop: 2 }}>{String(data.provider ?? 'Unknown')}</Text>
        </View>
        <View style={{ flex: 1 }}>
          <Text style={{ color: colors.mutedForeground, fontSize: 10, textTransform: 'uppercase', letterSpacing: 1 }}>Model</Text>
          <Text style={{ color: colors.foreground, fontSize: 13, fontFamily: MONO, marginTop: 2 }} numberOfLines={1}>{String(data.model ?? 'Unknown')}</Text>
        </View>
      </View>
    </ScrollView>
  );
}

function StatusContent({ data, colors }: { data: Record<string, unknown>; colors: ThemeColors }) {
  const mem = (data.memoryUsage as { rssMb?: number } | undefined) ?? {};
  const rows: { label: string; value: string; Icon: any }[] = [
    { label: 'Package', value: String(data.packageName ?? 'ddagent'), Icon: Package },
    { label: 'Version', value: String(data.version ?? 'Unknown'), Icon: BadgeCheck },
    { label: 'Uptime', value: String(data.uptime ?? 'Unknown'), Icon: Timer },
    { label: 'Provider', value: String(data.provider ?? 'Unknown'), Icon: Server },
    { label: 'Model', value: String(data.model ?? 'Unknown'), Icon: Cpu },
    { label: 'Node.js', value: String(data.nodeVersion ?? 'Unknown'), Icon: Terminal },
    { label: 'Platform', value: String(data.platform ?? 'Unknown'), Icon: Activity },
    { label: 'Memory', value: typeof mem.rssMb === 'number' ? `${mem.rssMb} MB RSS` : 'Unknown', Icon: Gauge },
  ];
  return (
    <View style={{ flex: 1 }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', borderWidth: 1, borderColor: '#10b981', backgroundColor: 'rgba(16,185,129,0.1)', borderRadius: 16, padding: 14, marginBottom: 12 }}>
        <View style={{ width: 10, height: 10, borderRadius: 5, backgroundColor: '#10b981', marginRight: 10 }} />
        <View style={{ flex: 1 }}>
          <Text style={{ color: colors.foreground, fontSize: 14, fontWeight: '600' }}>Runtime online</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>Process {data.pid ? `#${data.pid}` : 'status'} is responding.</Text>
        </View>
      </View>
      <FlatList
        data={rows}
        keyExtractor={(r) => r.label}
        numColumns={2}
        columnWrapperStyle={{ gap: 8 }}
        renderItem={({ item }) => (
          <View style={{ flex: 1, borderWidth: 1, borderColor: colors.border, borderRadius: 12, padding: 10, marginBottom: 8 }}>
            <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
              <item.Icon size={13} color={colors.primary} />
              <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{item.label}</Text>
            </View>
            <Text style={{ color: colors.foreground, fontSize: 13, fontWeight: '600', marginTop: 4 }} numberOfLines={1}>{item.value}</Text>
          </View>
        )}
      />
    </View>
  );
}

const MODAL_TITLES: Record<string, string> = {
  help: 'Help & Shortcuts',
  models: 'Choose a Model',
  cost: 'Token Usage',
  status: 'System Status',
};

/** Bottom-sheet modal for /help /models /cost /status command results. */
export function CommandResultModal({
  payload,
  colors,
  onClose,
  onSelectModel,
}: {
  payload: CommandModalPayload | null;
  colors: ThemeColors;
  onClose: () => void;
  onSelectModel?: (model: string) => void;
}) {
  const kind = payload?.kind;
  return (
    <Modal visible={!!payload} transparent animationType="fade" onRequestClose={onClose}>
      <TouchableOpacity style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }} activeOpacity={1} onPress={onClose}>
        <TouchableOpacity activeOpacity={1} style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, maxHeight: '88%', paddingBottom: 16 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', paddingHorizontal: 16, paddingVertical: 14, borderBottomWidth: 1, borderBottomColor: colors.border }}>
            <Text style={{ color: colors.foreground, fontSize: 17, fontWeight: '600' }}>{MODAL_TITLES[kind ?? 'help'] ?? 'Command Result'}</Text>
            <TouchableOpacity onPress={onClose} hitSlop={8}>
              <X size={18} color={colors.mutedForeground} />
            </TouchableOpacity>
          </View>
          <View style={{ padding: 16, minHeight: 200 }}>
            {kind === 'help' && <HelpContent data={payload!.data} colors={colors} />}
            {kind === 'models' && <ModelsContent data={payload!.data} colors={colors} onSelect={(m) => { onSelectModel?.(m); onClose(); }} />}
            {kind === 'cost' && <CostContent data={payload!.data} colors={colors} />}
            {kind === 'status' && <StatusContent data={payload!.data} colors={colors} />}
          </View>
        </TouchableOpacity>
      </TouchableOpacity>
    </Modal>
  );
}

/**
 * Transparent overlay rendered behind the composer TextInput so @mention tokens
 * get a chip background (web `renderInputWithMentions`). Non-mention text is
 * drawn transparent — the real TextInput above supplies the visible text.
 */
export function MentionHighlightOverlay({
  parts,
  style,
}: {
  parts: { text: string; mention: boolean }[];
  style: React.ComponentProps<typeof Text>['style'];
}) {
  return (
    <Text pointerEvents="none" style={[style, { position: 'absolute', left: 0, right: 0, top: 0 }]} numberOfLines={undefined}>
      {parts.map((part, i) =>
        part.mention ? (
          <Text key={i} style={[styles.mentionChip, { color: 'transparent' }]}>{part.text}</Text>
        ) : (
          <Text key={i} style={{ color: 'transparent' }}>{part.text}</Text>
        ),
      )}
    </Text>
  );
}

const styles = StyleSheet.create({
  mentionChip: {
    backgroundColor: 'rgba(147,197,253,0.55)',
    borderRadius: 4,
  },
});

export { HighlightText };
