import { useCallback } from 'react';
import { ActivityIndicator, StyleSheet, Text, TouchableOpacity, View } from 'react-native';
import { AlertTriangle, FileDiff, FileText, Pin, RefreshCw, X } from 'lucide-react-native';

import type { ThemeColors } from '../theme';
import type { ChangedFile } from '../lib/review-files';
import { splitReviewPath } from '../lib/review-files';

type ReviewFilesPanelProps = {
  files: ChangedFile[];
  loading: boolean;
  error: boolean;
  colors: ThemeColors;
  onRefresh: () => void;
  onOpenFile: (path: string) => void;
  onClose: () => void;
};

export function ReviewFilesPanel({ files, loading, error, colors, onRefresh, onOpenFile, onClose }: ReviewFilesPanelProps) {
  return (
    <View style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 10, backgroundColor: colors.card, overflow: 'hidden' }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', paddingHorizontal: 12, paddingVertical: 10, borderBottomWidth: 1, borderBottomColor: colors.border }}>
        <Text style={{ color: colors.foreground, fontSize: 12, fontWeight: '600' }}>
          Changed files{!loading && files.length > 0 ? ` (${files.length})` : ''}
        </Text>
        <View style={{ marginLeft: 'auto', flexDirection: 'row', alignItems: 'center', gap: 6 }}>
          <TouchableOpacity onPress={onRefresh} disabled={loading} hitSlop={6} style={{ padding: 4, opacity: loading ? 0.4 : 1 }}>
            <RefreshCw size={15} color={colors.mutedForeground} />
          </TouchableOpacity>
          <TouchableOpacity onPress={onClose} hitSlop={6} style={{ padding: 4 }}>
            <X size={15} color={colors.mutedForeground} />
          </TouchableOpacity>
        </View>
      </View>
      {loading && files.length === 0 ? (
        <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 8, paddingVertical: 24 }}>
          <ActivityIndicator size="small" color={colors.mutedForeground} />
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>Loading…</Text>
        </View>
      ) : error ? (
        <EmptyReview icon={<AlertTriangle size={20} color={colors.mutedForeground} />} label="Failed to load changes" colors={colors} />
      ) : files.length === 0 ? (
        <EmptyReview icon={<FileDiff size={20} color={colors.mutedForeground} />} label="No file changes" colors={colors} />
      ) : (
        <View style={{ opacity: loading ? 0.6 : 1 }}>
          {files.map((file) => {
            const { basename, dirname } = splitReviewPath(file.path);
            return (
              <TouchableOpacity
                key={file.path}
                onPress={() => { onOpenFile(file.path); onClose(); }}
                style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingHorizontal: 12, paddingVertical: 8 }}
              >
                <View style={{ flex: 1, minWidth: 0 }}>
                  <Text style={{ color: colors.foreground, fontSize: 12, fontWeight: '500' }} numberOfLines={1}>{basename}</Text>
                  {dirname ? <Text style={{ color: colors.mutedForeground, fontSize: 10 }} numberOfLines={1}>{dirname}</Text> : null}
                </View>
                <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
                  {file.subagent ? (
                    <Text style={{ color: colors.mutedForeground, fontSize: 9, backgroundColor: colors.muted, borderRadius: 3, paddingHorizontal: 4 }}>subagent</Text>
                  ) : null}
                  {file.edits > 1 ? <Text style={{ color: colors.mutedForeground, fontSize: 10 }}>x{file.edits}</Text> : null}
                </View>
              </TouchableOpacity>
            );
          })}
        </View>
      )}
    </View>
  );
}

function EmptyReview({ icon, label, colors }: { icon: React.ReactNode; label: string; colors: ThemeColors }) {
  return (
    <View style={{ alignItems: 'center', justifyContent: 'center', gap: 8, paddingVertical: 24 }}>
      {icon}
      <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{label}</Text>
    </View>
  );
}

type PinnedFilesBarProps = {
  files: string[];
  tokenEstimate?: number;
  colors: ThemeColors;
  onUnpin: (path: string) => void;
  onFileOpen?: (path: string) => void;
};

export function PinnedFilesBar({ files, tokenEstimate, colors, onUnpin, onFileOpen }: PinnedFilesBarProps) {
  if (files.length === 0) return null;
  const showEstimate = typeof tokenEstimate === 'number' && tokenEstimate > 0;
  return (
    <View style={{ borderTopWidth: StyleSheet.hairlineWidth, borderTopColor: colors.border, backgroundColor: colors.muted, paddingHorizontal: 10, paddingVertical: 6 }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
          <Pin size={11} color={colors.mutedForeground} />
          <Text style={{ color: colors.mutedForeground, fontSize: 11, fontWeight: '600' }}>Pinned</Text>
        </View>
        <View style={{ flex: 1, flexDirection: 'row', flexWrap: 'wrap', gap: 6, minWidth: 0 }}>
          {files.map((path) => (
            <View key={path} style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.card, borderRadius: 8, borderWidth: StyleSheet.hairlineWidth, borderColor: colors.border, paddingLeft: 6, paddingRight: 2, paddingVertical: 2, maxWidth: 240 }}>
              <TouchableOpacity onPress={() => onFileOpen?.(path)} disabled={!onFileOpen} style={{ flexDirection: 'row', alignItems: 'center', gap: 4, flexShrink: 1 }}>
                <FileText size={11} color={colors.mutedForeground} />
                <Text style={{ color: colors.cardForeground, fontSize: 11, flexShrink: 1 }} numberOfLines={1}>{path}</Text>
              </TouchableOpacity>
              <TouchableOpacity onPress={() => onUnpin(path)} hitSlop={6} style={{ padding: 3 }}>
                <X size={11} color={colors.mutedForeground} />
              </TouchableOpacity>
            </View>
          ))}
        </View>
        {showEstimate ? (
          <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{formatEstimate(tokenEstimate as number)}</Text>
        ) : null}
      </View>
    </View>
  );
}

function formatEstimate(value: number): string {
  if (value >= 1000) return `~${(value / 1000).toFixed(1)}K tokens`;
  return `~${Math.round(value)} tokens`;
}
