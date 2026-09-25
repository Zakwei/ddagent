import React from 'react';
import { ActivityIndicator, Text, TouchableOpacity, View } from 'react-native';
import { ArrowDown, Check, ChevronUp, X } from 'lucide-react-native';

import type { ThemeColors } from '../theme';
import { formatNewMessageBadge } from '../lib/scroll';

const Spinner = ({ color }: { color: string }) => <ActivityIndicator size="small" color={color} />;

/** Floating pill above the composer: "All messages loaded" / "Load all (N)" / spinner. */
export function LoadAllOverlay({
  colors,
  allLoaded,
  loading,
  hasMore,
  total,
  onLoadAll,
}: {
  colors: ThemeColors;
  allLoaded: boolean;
  loading: boolean;
  hasMore: boolean;
  total: number;
  onLoadAll: () => void;
}) {
  if (allLoaded) {
    return (
      <View
        pointerEvents="none"
        style={{
          position: 'absolute',
          top: 8,
          alignSelf: 'center',
          zIndex: 20,
          flexDirection: 'row',
          alignItems: 'center',
          gap: 6,
          borderRadius: 999,
          borderWidth: 1,
          borderColor: 'rgba(16,185,129,0.4)',
          backgroundColor: 'rgba(16,185,129,0.12)',
          paddingHorizontal: 12,
          paddingVertical: 5,
        }}
      >
        <Check size={13} color="#10b981" />
        <Text style={{ color: '#059669', fontSize: 12, fontWeight: '500' }}>All messages loaded</Text>
      </View>
    );
  }
  if (loading) {
    return (
      <View
        pointerEvents="none"
        style={{
          position: 'absolute',
          top: 8,
          alignSelf: 'center',
          zIndex: 20,
          flexDirection: 'row',
          alignItems: 'center',
          gap: 6,
          borderRadius: 999,
          borderWidth: 1,
          borderColor: colors.border,
          backgroundColor: colors.card,
          paddingHorizontal: 12,
          paddingVertical: 5,
        }}
      >
        <Spinner color={colors.primary} />
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>Loading all messages…</Text>
      </View>
    );
  }
  if (!hasMore) return null;
  return (
    <View pointerEvents="box-none" style={{ position: 'absolute', top: 8, alignSelf: 'center', zIndex: 20 }}>
      <TouchableOpacity
        onPress={onLoadAll}
        style={{
          flexDirection: 'row',
          alignItems: 'center',
          gap: 6,
          borderRadius: 999,
          borderWidth: 1,
          borderColor: `${colors.primary}66`,
          backgroundColor: `${colors.primary}1a`,
          paddingHorizontal: 12,
          paddingVertical: 5,
        }}
      >
        <ChevronUp size={13} color={colors.primary} />
        <Text style={{ color: colors.primary, fontSize: 12, fontWeight: '500' }}>
          Load all{Number.isFinite(total) && total > 0 ? ` (${total})` : ''}
        </Text>
      </TouchableOpacity>
    </View>
  );
}

/** Scroll-to-bottom button with a new-message count badge. */
export function ScrollToBottomButton({
  colors,
  count,
  onPress,
}: {
  colors: ThemeColors;
  count: number;
  onPress: () => void;
}) {
  const badge = formatNewMessageBadge(count);
  const showBadge = count > 0;
  return (
    <TouchableOpacity
      onPress={onPress}
      accessibilityLabel={count === 1 ? 'New message' : 'New messages'}
      style={{
        position: 'absolute',
        bottom: 12,
        alignSelf: 'center',
        zIndex: 30,
        flexDirection: 'row',
        alignItems: 'center',
        gap: 6,
        borderRadius: 999,
        borderWidth: 1,
        borderColor: colors.border,
        backgroundColor: colors.card,
        paddingHorizontal: 12,
        paddingVertical: 7,
        shadowColor: '#000',
        shadowOpacity: 0.15,
        shadowRadius: 6,
        shadowOffset: { width: 0, height: 2 },
        elevation: 4,
      }}
    >
      <ArrowDown size={15} color={colors.foreground} />
      {showBadge && (
        <View
          style={{
            minWidth: 18,
            borderRadius: 999,
            backgroundColor: colors.primary,
            paddingHorizontal: 5,
            paddingVertical: 1,
            alignItems: 'center',
          }}
        >
          <Text style={{ color: colors.primaryForeground, fontSize: 11, fontWeight: '700' }}>{badge}</Text>
        </View>
      )}
    </TouchableOpacity>
  );
}

/** Header banner for the older-messages pagination state. */
export function OlderMessagesBanner({
  colors,
  loading,
  error,
  hasMore,
  allLoaded,
  shown,
  total,
  onRetry,
}: {
  colors: ThemeColors;
  loading: boolean;
  error: boolean;
  hasMore: boolean;
  allLoaded: boolean;
  shown: number;
  total: number;
  onRetry: () => void;
}) {
  if (allLoaded) return null;
  if (loading) {
    return (
      <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 8, paddingVertical: 10 }}>
        <Spinner color={colors.mutedForeground} />
        <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>Loading older messages…</Text>
      </View>
    );
  }
  if (error) {
    return (
      <TouchableOpacity
        onPress={onRetry}
        style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 4, paddingVertical: 10 }}
      >
        <X size={13} color="#ef4444" />
        <Text style={{ color: '#ef4444', fontSize: 12 }}>Failed to load older messages. </Text>
        <Text style={{ color: '#ef4444', fontSize: 12, textDecorationLine: 'underline' }}>Retry</Text>
      </TouchableOpacity>
    );
  }
  if (hasMore) {
    return (
      <View style={{ alignItems: 'center', paddingVertical: 10 }}>
        <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>
          Showing {shown} of {total} messages
        </Text>
        <Text style={{ color: `${colors.mutedForeground}99`, fontSize: 10, marginTop: 1 }}>Scroll up to load more</Text>
      </View>
    );
  }
  return null;
}

/** Legacy tail row when not paginated: "Showing last N (total)" + load earlier/all. */
export function ShowingLastRow({
  colors,
  shown,
  total,
  onLoadEarlier,
  onLoadAll,
  canLoadEarlier,
}: {
  colors: ThemeColors;
  shown: number;
  total: number;
  onLoadEarlier?: () => void;
  onLoadAll?: () => void;
  canLoadEarlier: boolean;
}) {
  if (shown >= total) return null;
  return (
    <View style={{ alignItems: 'center', gap: 4, paddingVertical: 10 }}>
      <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>
        Showing last {shown} messages ({total} total)
      </Text>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 12 }}>
        {canLoadEarlier && onLoadEarlier && (
          <TouchableOpacity onPress={onLoadEarlier}>
            <Text style={{ color: colors.primary, fontSize: 11, textDecorationLine: 'underline' }}>Load earlier messages</Text>
          </TouchableOpacity>
        )}
        {onLoadAll && (
          <TouchableOpacity onPress={onLoadAll}>
            <Text style={{ color: colors.primary, fontSize: 11, textDecorationLine: 'underline' }}>Load all messages</Text>
          </TouchableOpacity>
        )}
      </View>
    </View>
  );
}
