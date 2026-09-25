import React from 'react';
import { Text, TouchableOpacity, View } from 'react-native';
import { Clock, Pencil, Send, WifiOff, X } from 'lucide-react-native';

import type { ThemeColors } from '../theme';

export interface QueuedMessageListItem {
  id: number | string;
  content: string;
  attachmentCount?: number;
  status?: 'queued' | 'sending' | 'failed';
}

/** Amber dashed "N messages queued offline" banner with a Clear action. */
export function OfflineQueueCard({
  count,
  colors,
  onClear,
}: {
  count: number;
  colors: ThemeColors;
  onClear?: () => void;
}) {
  if (count <= 0) return null;
  const text =
    count === 1
      ? '1 message queued offline — will send automatically when reconnected'
      : `${count} messages queued offline — will send automatically when reconnected`;
  return (
    <View
      style={{
        borderWidth: 1,
        borderStyle: 'dashed',
        borderColor: 'rgba(245,158,11,0.4)',
        backgroundColor: 'rgba(245,158,11,0.08)',
        borderRadius: 12,
        paddingHorizontal: 12,
        paddingVertical: 8,
        marginBottom: 8,
        flexDirection: 'row',
        alignItems: 'center',
        gap: 8,
      }}
    >
      <WifiOff size={14} color="#d97706" />
      <Clock size={12} color="rgba(217,119,6,0.8)" />
      <Text style={{ flex: 1, color: '#b45309', fontSize: 12, fontWeight: '500' }} numberOfLines={2}>
        {text}
      </Text>
      {onClear && (
        <TouchableOpacity onPress={onClear} hitSlop={8} style={{ flexDirection: 'row', alignItems: 'center', gap: 3 }}>
          <X size={13} color="#b45309" />
          <Text style={{ color: '#b45309', fontSize: 11 }}>Cancel</Text>
        </TouchableOpacity>
      )}
    </View>
  );
}

/** One server-queued message row: content, status, attachment count, actions. */
export function QueuedMessageCard({
  message,
  colors,
  onSendNow,
  onEdit,
  onDelete,
  isSending,
}: {
  message: QueuedMessageListItem;
  colors: ThemeColors;
  onSendNow?: () => void;
  onEdit?: () => void;
  onDelete?: () => void;
  isSending?: boolean;
}) {
  const attachmentCount = message.attachmentCount ?? 0;
  const isFailed = message.status === 'failed';
  return (
    <View
      style={{
        borderWidth: 1,
        borderStyle: 'dashed',
        borderColor: `${colors.primary}40`,
        backgroundColor: `${colors.primary}0a`,
        borderRadius: 12,
        paddingHorizontal: 12,
        paddingVertical: 8,
        marginBottom: 8,
      }}
    >
      <View style={{ flexDirection: 'row', alignItems: 'flex-start', gap: 8 }}>
        <View style={{ width: 6, height: 6, borderRadius: 3, backgroundColor: `${colors.primary}99`, marginTop: 6 }} />
        <View style={{ flex: 1, minWidth: 0 }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
            <Text style={{ fontSize: 10, fontWeight: '600', letterSpacing: 0.5, color: `${colors.primary}b3` }}>QUEUED</Text>
            <Text style={{ fontSize: 10, color: colors.mutedForeground }}>
              · {isFailed ? 'Failed to send' : 'Will send when this finishes'}
            </Text>
          </View>
          <Text style={{ fontSize: 13, color: colors.foreground, marginTop: 2 }} numberOfLines={2}>
            {message.content}
          </Text>
          {attachmentCount > 0 && (
            <Text style={{ fontSize: 11, color: colors.mutedForeground, marginTop: 2 }}>
              {attachmentCount} {attachmentCount === 1 ? 'file' : 'files'} attached
            </Text>
          )}
        </View>
        <View style={{ flexDirection: 'row', alignItems: 'center' }}>
          {onSendNow && (
            <TouchableOpacity onPress={onSendNow} disabled={isSending} hitSlop={6} style={{ padding: 6 }}>
              <Send size={14} color={colors.primary} />
            </TouchableOpacity>
          )}
          {onEdit && (
            <TouchableOpacity onPress={onEdit} hitSlop={6} style={{ padding: 6 }}>
              <Pencil size={14} color={colors.mutedForeground} />
            </TouchableOpacity>
          )}
          {onDelete && (
            <TouchableOpacity onPress={onDelete} hitSlop={6} style={{ padding: 6 }}>
              <X size={14} color={colors.destructive} />
            </TouchableOpacity>
          )}
        </View>
      </View>
    </View>
  );
}
