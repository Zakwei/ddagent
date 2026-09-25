import React, { useEffect, useMemo, useState } from 'react';
import { ActivityIndicator, Modal, ScrollView, Text, TextInput, TouchableOpacity, View } from 'react-native';
import {
  AlertTriangle,
  BadgeCheck,
  Bot,
  Check,
  ChevronDown,
  ChevronRight,
  ClipboardList,
  Hand,
  ListChecks,
  RefreshCw,
  ShieldQuestion,
  Smile,
  Star,
  UserCircle2,
} from 'lucide-react-native';

import type { ThemeColors } from '../theme';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { api } from '~shared/utils/api';
import {
  type EffortOption,
  type FavoriteModel,
  type ProviderAccount,
  type ProviderModelOption,
  type TierFilter,
  type UsageResponse,
  DEFAULT_EFFORT_VALUE,
  FAVORITES_STORAGE_KEY,
  favoriteStorageKey,
  filterModelsByTier,
  getPermissionAppearance,
  isFreeModel,
  isModelAvailableIn,
  loadFavoritesFrom,
  mergeFavorites,
  modelSubtitle,
  resolveEffortOptions,
  toggleFavoriteIn,
  usageFromQuotaSnapshot,
} from '../lib/model-menu';
import { matchesModelSearch } from '../lib/chat-extras';

const MONO = 'Menlo';

const MODE_ICONS: Record<string, React.ComponentType<{ size?: number; color?: string }>> = {
  hand: Hand,
  bot: Bot,
  smile: Smile,
  alert: AlertTriangle,
  clipboard: ClipboardList,
  shield: ShieldQuestion,
};

function SectionHeading({ children, colors }: { children: React.ReactNode; colors: ThemeColors }) {
  return (
    <Text style={{ color: colors.mutedForeground, fontSize: 11, fontWeight: '700', letterSpacing: 1, textTransform: 'uppercase', paddingHorizontal: 4, paddingTop: 12, paddingBottom: 6 }}>
      {children}
    </Text>
  );
}

export function ModelMenuModal({
  visible,
  onClose,
  colors,
  isDark,
  provider,
  models,
  model,
  effort,
  effortOptions,
  onSelectModel,
  onSelectEffort,
  onRefreshModels,
  modelsLoading,
}: {
  visible: boolean;
  onClose: () => void;
  colors: ThemeColors;
  isDark: boolean;
  provider?: string;
  models: ProviderModelOption[];
  model: string | null;
  effort: string | null;
  effortOptions: EffortOption[];
  onSelectModel: (value: string) => void;
  onSelectEffort: (value: string | null) => void;
  onRefreshModels?: () => void;
  modelsLoading: boolean;
}) {
  const [favorites, setFavorites] = useState<Record<string, FavoriteModel>>({});
  const [tierFilter, setTierFilter] = useState<TierFilter>('all');
  const [search, setSearch] = useState('');
  const [sectionOpen, setSectionOpen] = useState(false);
  const [usage, setUsage] = useState<UsageResponse | null>(null);

  // Reload favorites + quota availability each time the menu opens (web
  // refresh on open + useSubscriptionUsage poll).
  useEffect(() => {
    if (!visible) {
      setSectionOpen(false);
      setSearch('');
      return;
    }
    AsyncStorage.getItem(FAVORITES_STORAGE_KEY)
      .then((raw) => setFavorites(loadFavoritesFrom(raw)))
      .catch(() => {});
    api
      .get('/quota')
      .then((r) => (r.ok ? r.json() : null))
      .then((d) => {
        const snap = d?.data?.snapshot ?? d?.snapshot ?? d?.data ?? d;
        if (snap?.accounts) setUsage(usageFromQuotaSnapshot(snap));
      })
      .catch(() => {});
    void onRefreshModels?.();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visible]);

  const resolvedEffort = useMemo(() => resolveEffortOptions({ values: effortOptions }), [effortOptions]);
  const hasEffortSection = resolvedEffort.length > 0;
  const hasModelSection = models.length > 0;

  const persistFavorites = (next: Record<string, FavoriteModel>) => {
    setFavorites(next);
    void AsyncStorage.setItem(FAVORITES_STORAGE_KEY, JSON.stringify(next)).catch(() => {});
  };

  const toggleFavorite = (option: ProviderModelOption) => {
    persistFavorites(toggleFavoriteIn(favorites, provider ?? 'claude', option));
  };

  const available = models.filter((m) => isModelAvailableIn(usage, provider ?? 'claude', m.value, m.tier ?? undefined));
  const { favoritesList, others } = mergeFavorites(available, favorites, provider ?? 'claude');
  const tieredOthers = filterModelsByTier(others, tierFilter);
  const shown = search.trim()
    ? tieredOthers.filter((m) => matchesModelSearch(`${m.label} ${m.value} ${m.description ?? ''}`, search))
    : tieredOthers;

  const selectedModel = models.find((m) => m.value === model);

  const ModelRow = ({ option, isFavorite }: { option: ProviderModelOption; isFavorite: boolean }) => {
    const subtitle = modelSubtitle(option);
    const free = isFreeModel(option);
    return (
      <TouchableOpacity
        onPress={() => {
          onSelectModel(option.value);
          onClose();
        }}
        style={{ flexDirection: 'row', alignItems: 'center', minHeight: 52, paddingHorizontal: 8, paddingVertical: 8, borderRadius: 8, backgroundColor: option.value === model ? colors.accent : 'transparent' }}
      >
        <ScrollView horizontal showsHorizontalScrollIndicator={false} scrollEnabled={false} style={{ flexGrow: 0 }} contentContainerStyle={{ paddingRight: 8 }}>
          <TouchableOpacity onPress={() => toggleFavorite(option)} hitSlop={8} style={{ paddingVertical: 12, paddingRight: 8 }}>
            <Star size={16} color={isFavorite ? '#f59e0b' : colors.mutedForeground} fill={isFavorite ? '#f59e0b' : 'transparent'} />
          </TouchableOpacity>
        </ScrollView>
        <View style={{ flex: 1, minWidth: 0 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
            <Text style={{ color: colors.foreground, fontSize: 14, fontWeight: '500' }} numberOfLines={1}>{option.label}</Text>
            {free && (
              <Text style={{ color: '#059669', fontSize: 9, fontWeight: '700', borderWidth: 1, borderColor: '#059669', borderRadius: 4, paddingHorizontal: 4, paddingVertical: 1 }}>
                Free
              </Text>
            )}
          </View>
          {!!subtitle && (
            <Text style={{ color: colors.mutedForeground, fontSize: 11, marginTop: 2 }} numberOfLines={2}>{subtitle}</Text>
          )}
        </View>
        {option.value === model && <BadgeCheck size={16} color={colors.primary} />}
      </TouchableOpacity>
    );
  };

  if (!visible) return null;

  return (
    <Modal visible transparent animationType="fade" onRequestClose={onClose}>
      <TouchableOpacity style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }} activeOpacity={1} onPress={onClose}>
        <TouchableOpacity activeOpacity={1} style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, maxHeight: '85%', paddingBottom: 12 }}>
          <Text style={{ color: colors.foreground, fontWeight: '600', fontSize: 16, padding: 16, paddingBottom: 4 }}>
            {selectedModel?.label ?? model ?? 'Model'}
            {effort && effort !== DEFAULT_EFFORT_VALUE ? <Text style={{ color: colors.mutedForeground }}>{` · ${effort}`}</Text> : null}
          </Text>
          <ScrollView keyboardShouldPersistTaps="handled" style={{ paddingHorizontal: 12 }}>
            {hasEffortSection && (
              <>
                <SectionHeading colors={colors}>Reasoning</SectionHeading>
                {resolvedEffort.map((e) => {
                  const on = (effort ?? DEFAULT_EFFORT_VALUE) === e.value;
                  const label = e.value === DEFAULT_EFFORT_VALUE ? 'Default' : e.label ?? e.value;
                  return (
                    <TouchableOpacity
                      key={e.value}
                      onPress={() => {
                        onSelectEffort(e.value === DEFAULT_EFFORT_VALUE ? null : e.value);
                        onClose();
                      }}
                      style={{ flexDirection: 'row', alignItems: 'center', minHeight: 44, paddingHorizontal: 8, borderRadius: 8, backgroundColor: on ? colors.accent : 'transparent' }}
                    >
                      <Text style={{ flex: 1, color: colors.foreground, fontSize: 14, textTransform: 'capitalize' }}>{label}</Text>
                      {on && <Check size={16} color={colors.primary} />}
                    </TouchableOpacity>
                  );
                })}
              </>
            )}

            {hasModelSection && (
              <>
                {favoritesList.length > 0 && (
                  <>
                    <SectionHeading colors={colors}>Favorites</SectionHeading>
                    {favoritesList.map((option) => (
                      <ModelRow key={`fav-${option.value}`} option={option} isFavorite />
                    ))}
                  </>
                )}
                <TouchableOpacity
                  onPress={() => setSectionOpen((v) => !v)}
                  style={{ flexDirection: 'row', alignItems: 'center', minHeight: 48, paddingHorizontal: 8, marginTop: 4 }}
                >
                  <Text style={{ flex: 1, color: colors.foreground, fontSize: 15, fontWeight: '600' }}>Model</Text>
                  {sectionOpen ? <ChevronDown size={16} color={colors.mutedForeground} /> : <ChevronRight size={16} color={colors.mutedForeground} />}
                </TouchableOpacity>
                {sectionOpen && (
                  <View>
                    <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6, paddingHorizontal: 4, paddingBottom: 8 }}>
                      {(['all', 'free', 'paid'] as TierFilter[]).map((tier) => {
                        const on = tierFilter === tier;
                        return (
                          <TouchableOpacity
                            key={tier}
                            onPress={() => setTierFilter(tier)}
                            style={{ borderRadius: 999, paddingHorizontal: 12, paddingVertical: 5, backgroundColor: on ? colors.primary : colors.secondary }}
                          >
                            <Text style={{ color: on ? colors.primaryForeground : colors.secondaryForeground, fontSize: 12, textTransform: 'capitalize' }}>{tier}</Text>
                          </TouchableOpacity>
                        );
                      })}
                      <View style={{ flex: 1 }} />
                      <TouchableOpacity onPress={() => onRefreshModels?.()} hitSlop={8} style={{ padding: 6 }}>
                        {modelsLoading ? <ActivityIndicator size="small" color={colors.primary} /> : <RefreshCw size={15} color={colors.mutedForeground} />}
                      </TouchableOpacity>
                    </View>
                    <TextInput
                      value={search}
                      onChangeText={setSearch}
                      placeholder="Search models…"
                      placeholderTextColor={colors.mutedForeground}
                      autoCapitalize="none"
                      autoCorrect={false}
                      style={{ marginHorizontal: 4, marginBottom: 8, backgroundColor: colors.background, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 10, paddingVertical: 8 }}
                    />
                    {modelsLoading && shown.length === 0 ? (
                      <Text style={{ color: colors.mutedForeground, fontSize: 13, padding: 12 }}>Loading models…</Text>
                    ) : shown.length === 0 ? (
                      <Text style={{ color: colors.mutedForeground, fontSize: 13, padding: 12 }}>No models found.</Text>
                    ) : (
                      shown.map((option) => (
                        <ModelRow
                          key={option.value}
                          option={option}
                          isFavorite={Boolean(favorites[favoriteStorageKey(provider ?? 'claude', option.value)])}
                        />
                      ))
                    )}
                  </View>
                )}
              </>
            )}
          </ScrollView>
        </TouchableOpacity>
      </TouchableOpacity>
    </Modal>
  );
}

export function PermissionMenuModal({
  visible,
  onClose,
  colors,
  isDark,
  permissionMode,
  permissionModes,
  onSelect,
  providerLabel,
  autoContinue,
  onToggleAutoContinue,
}: {
  visible: boolean;
  onClose: () => void;
  colors: ThemeColors;
  isDark: boolean;
  permissionMode: string;
  permissionModes: string[];
  onSelect: (mode: string) => void;
  providerLabel: string;
  autoContinue: boolean;
  onToggleAutoContinue: () => void;
}) {
  if (!visible) return null;
  const modeLabel = (mode: string) =>
    ({ default: 'Default Mode', auto: 'Auto Mode', acceptEdits: 'Accept Edits', bypassPermissions: 'Bypass Permissions', plan: 'Plan Mode' }[mode] ?? mode);
  const modeDescription = (mode: string) =>
    ({
      default: 'Standard permission checks for every action.',
      auto: 'Automatically approve safe actions and ask only when needed.',
      acceptEdits: 'Automatically approve file edits.',
      bypassPermissions: 'Skip all permission prompts.',
      plan: 'Read-only mode — plan before making changes.',
    }[mode] ?? '');
  return (
    <Modal visible transparent animationType="fade" onRequestClose={onClose}>
      <TouchableOpacity style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }} activeOpacity={1} onPress={onClose}>
        <TouchableOpacity activeOpacity={1} style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, maxHeight: '80%', paddingBottom: 12 }}>
          <Text style={{ color: colors.foreground, fontWeight: '600', fontSize: 16, padding: 16, paddingBottom: 4 }}>
            {`How should ${providerLabel} actions be approved?`}
          </Text>
          <ScrollView>
            {permissionModes.map((mode) => {
              const appearance = getPermissionAppearance(mode);
              const Icon = MODE_ICONS[appearance.iconKey] ?? ShieldQuestion;
              const tint = isDark ? appearance.tintDark : appearance.tintLight;
              const bg = isDark ? appearance.bgDark : appearance.bgLight;
              const on = mode === permissionMode;
              return (
                <TouchableOpacity
                  key={mode}
                  onPress={() => {
                    onSelect(mode);
                    onClose();
                  }}
                  style={{ flexDirection: 'row', alignItems: 'center', gap: 12, minHeight: 56, marginHorizontal: 10, marginBottom: 6, paddingHorizontal: 12, paddingVertical: 8, borderRadius: 10, borderWidth: 1, borderColor: on ? colors.primary : 'transparent', backgroundColor: on ? colors.accent : 'transparent' }}
                >
                  <View style={{ width: 34, height: 34, borderRadius: 8, backgroundColor: bg, alignItems: 'center', justifyContent: 'center' }}>
                    <Icon size={18} color={tint} />
                  </View>
                  <View style={{ flex: 1, minWidth: 0 }}>
                    <Text style={{ color: tint, fontSize: 14, fontWeight: '600' }}>{modeLabel(mode)}</Text>
                    <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 1 }}>{modeDescription(mode)}</Text>
                  </View>
                  {on && <Check size={16} color={colors.primary} />}
                </TouchableOpacity>
              );
            })}
            <TouchableOpacity
              onPress={onToggleAutoContinue}
              style={{ flexDirection: 'row', alignItems: 'center', gap: 12, minHeight: 56, marginHorizontal: 10, marginTop: 6, paddingHorizontal: 12, borderTopWidth: 1, borderTopColor: colors.border }}
            >
              <View style={{ width: 34, height: 34, borderRadius: 8, backgroundColor: colors.muted, alignItems: 'center', justifyContent: 'center' }}>
                <ListChecks size={18} color={colors.primary} />
              </View>
              <View style={{ flex: 1 }}>
                <Text style={{ color: colors.foreground, fontSize: 14, fontWeight: '500' }}>Auto-continue</Text>
                <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>Continue to the next Task Master task automatically</Text>
              </View>
              <View style={{ width: 36, height: 20, borderRadius: 10, backgroundColor: autoContinue ? colors.primary : colors.muted, justifyContent: 'center', paddingHorizontal: 2 }}>
                <View style={{ width: 16, height: 16, borderRadius: 8, backgroundColor: '#fff', alignSelf: autoContinue ? 'flex-end' : 'flex-start' }} />
              </View>
            </TouchableOpacity>
          </ScrollView>
        </TouchableOpacity>
      </TouchableOpacity>
    </Modal>
  );
}

export function AccountMenuModal({
  visible,
  onClose,
  colors,
  accounts,
  accountId,
  onSelect,
}: {
  visible: boolean;
  onClose: () => void;
  colors: ThemeColors;
  accounts: ProviderAccount[];
  accountId: string | null;
  onSelect: (accountId: string | null) => void;
}) {
  if (!visible) return null;
  const defaultAccount = accounts.find((a) => a.isDefault) ?? null;
  return (
    <Modal visible transparent animationType="fade" onRequestClose={onClose}>
      <TouchableOpacity style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }} activeOpacity={1} onPress={onClose}>
        <TouchableOpacity activeOpacity={1} style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, paddingBottom: 12 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, padding: 16, paddingBottom: 4 }}>
            <UserCircle2 size={18} color={colors.primary} />
            <Text style={{ color: colors.foreground, fontWeight: '600', fontSize: 16 }}>Account</Text>
          </View>
          <TouchableOpacity
            onPress={() => { onSelect(null); onClose(); }}
            style={{ paddingHorizontal: 16, paddingVertical: 12, minHeight: 52 }}
          >
            <Text style={{ color: colors.foreground, fontSize: 14, fontWeight: '500' }}>Auto (default)</Text>
            {!!defaultAccount && <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 2 }}>{defaultAccount.label}</Text>}
          </TouchableOpacity>
          <View style={{ height: 1, backgroundColor: colors.border, marginVertical: 4 }} />
          {accounts.map((account) => (
            <TouchableOpacity
              key={account.id}
              onPress={() => { onSelect(account.id); onClose(); }}
              style={{ flexDirection: 'row', alignItems: 'center', paddingHorizontal: 16, paddingVertical: 12, minHeight: 52 }}
            >
              <View style={{ flex: 1 }}>
                <Text style={{ color: colors.foreground, fontSize: 14 }}>{account.label}</Text>
                {account.isDefault && <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 2 }}>Default</Text>}
              </View>
              {account.id === accountId && <Check size={16} color={colors.primary} />}
            </TouchableOpacity>
          ))}
        </TouchableOpacity>
      </TouchableOpacity>
    </Modal>
  );
}
