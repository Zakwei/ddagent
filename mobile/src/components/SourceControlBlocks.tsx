import React, { useEffect, useState } from 'react';
import { ActivityIndicator, Modal, ScrollView, Text, TextInput, TouchableOpacity, View } from 'react-native';
import Svg, { Circle, Path } from 'react-native-svg';
import { AlertTriangle, Check, ChevronDown, FileText, Play, Square } from 'lucide-react-native';
import type { ThemeColors } from '../theme';
import { buildDiffLines, GitChangedFile, type WorktreeScriptsConfig } from '../lib/git';
import {
  buildSplitDiffRows,
  CommitGraphRow,
  CommitFileEntry,
  laneColor,
  mergeMessage,
  validateWorktreeConfig,
  worktreeFolderPreview,
} from '../lib/git-extras';

type T = (key: string, opts?: Record<string, unknown>) => string;

const STATUS_BADGE: Record<GitChangedFile['status'], { bg: string; text: string }> = {
  M: { bg: '#fef3c7', text: '#b45309' },
  A: { bg: '#dcfce7', text: '#15803d' },
  D: { bg: '#fee2e2', text: '#b91c1c' },
  U: { bg: '#e5e7eb', text: '#4b5563' },
};

/* ------------------------------------------------------------- diff viewer */

function LineText({ line, colors }: { line: { kind: string; text: string }; colors: ThemeColors }) {
  const bg = line.kind === 'add' ? '#dcfce7' : line.kind === 'del' ? '#fee2e2' : line.kind === 'hunk' ? colors.muted : 'transparent';
  const fg = line.kind === 'add' ? '#15803d' : line.kind === 'del' ? '#b91c1c' : line.kind === 'hunk' ? colors.primary : colors.foreground;
  return (
    <Text style={{ fontFamily: 'monospace', fontSize: 11, paddingVertical: 1, paddingHorizontal: 8, backgroundColor: bg, color: fg }}>
      {line.text || ' '}
    </Text>
  );
}

export function DiffViewer({
  diff,
  colors,
  viewMode = 'unified',
  wrapText = false,
  hunkAction,
}: {
  diff: string | undefined;
  colors: ThemeColors;
  viewMode?: 'unified' | 'split';
  wrapText?: boolean;
  hunkAction?: { variant: 'add' | 'remove'; onAction: (hunkIndex: number) => void };
}) {
  const lines = buildDiffLines(diff);
  const hunkIndices = new Map<number, number>();
  if (viewMode === 'unified') {
    let hunkIndex = 0;
    lines.forEach((line, index) => {
      if (line.kind === 'hunk') hunkIndices.set(index, hunkIndex++);
    });
  }
  if (lines.length === 0) {
    return <Text style={{ color: colors.mutedForeground, fontSize: 12, padding: 8 }}>No diff available</Text>;
  }
  const hunkButton = (index: number) =>
    hunkAction && hunkIndices.has(index) ? (
      <TouchableOpacity
        onPress={() => hunkAction.onAction(hunkIndices.get(index) as number)}
        style={{
          marginLeft: 8,
          borderRadius: 4,
          paddingHorizontal: 6,
          paddingVertical: 1,
          backgroundColor: hunkAction.variant === 'add' ? '#dcfce7' : '#fee2e2',
        }}
      >
        <Text style={{ color: hunkAction.variant === 'add' ? '#15803d' : '#b91c1c', fontSize: 10, fontWeight: '700' }}>
          {hunkAction.variant === 'add' ? '+ Hunk' : '− Hunk'}
        </Text>
      </TouchableOpacity>
    ) : null;
  if (viewMode === 'split') {
    const rows = buildSplitDiffRows(lines.map((line) => line.text));
    let hunkIndex = 0;
    return (
      <View style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 8, overflow: 'hidden', marginTop: 8 }}>
        <ScrollView horizontal showsHorizontalScrollIndicator={false}>
          <View style={{ minWidth: 520 }}>
            {rows.map((row, index) => {
              if (row.kind === 'header') {
                const isHunk = row.text.startsWith('@@');
                const currentHunk = isHunk ? hunkIndex++ : -1;
                return (
                  <View key={index} style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: isHunk ? colors.muted : 'transparent', paddingVertical: 1 }}>
                    <Text style={{ fontFamily: 'monospace', fontSize: 11, paddingHorizontal: 8, color: isHunk ? colors.primary : colors.mutedForeground, flex: 1 }}>
                      {row.text || ' '}
                    </Text>
                    {isHunk && hunkAction ? (
                      <TouchableOpacity
                        onPress={() => hunkAction.onAction(currentHunk)}
                        style={{ marginRight: 8, borderRadius: 4, paddingHorizontal: 6, paddingVertical: 1, backgroundColor: hunkAction.variant === 'add' ? '#dcfce7' : '#fee2e2' }}
                      >
                        <Text style={{ color: hunkAction.variant === 'add' ? '#15803d' : '#b91c1c', fontSize: 10, fontWeight: '700' }}>
                          {hunkAction.variant === 'add' ? '+ Hunk' : '− Hunk'}
                        </Text>
                      </TouchableOpacity>
                    ) : null}
                  </View>
                );
              }
              return (
                <View key={index} style={{ flexDirection: 'row' }}>
                  {(['left', 'right'] as const).map((side) => {
                    const cell = row[side];
                    const bg = cell?.type === 'removed' ? '#fee2e2' : cell?.type === 'added' ? '#dcfce7' : 'transparent';
                    const fg = cell?.type === 'removed' ? '#b91c1c' : cell?.type === 'added' ? '#15803d' : colors.foreground;
                    return (
                      <View key={side} style={{ flex: 1, borderRightWidth: side === 'left' ? 1 : 0, borderRightColor: colors.border }}>
                        <Text
                          style={{ fontFamily: 'monospace', fontSize: 11, paddingVertical: 1, paddingHorizontal: 8, backgroundColor: bg, color: cell ? fg : colors.mutedForeground }}
                        >
                          {cell?.content || ' '}
                        </Text>
                      </View>
                    );
                  })}
                </View>
              );
            })}
          </View>
        </ScrollView>
      </View>
    );
  }
  return (
    <View style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 8, overflow: 'hidden', marginTop: 8 }}>
      <ScrollView horizontal={!wrapText} showsHorizontalScrollIndicator={false}>
        <View style={{ flex: wrapText ? 1 : undefined }}>
          {lines.map((line, index) =>
            line.kind === 'hunk' ? (
              <View key={index} style={{ flexDirection: 'row', alignItems: 'center', backgroundColor: colors.muted }}>
                <Text style={{ fontFamily: 'monospace', fontSize: 11, paddingVertical: 1, paddingHorizontal: 8, color: colors.primary, flex: 1 }}>{line.text}</Text>
                {hunkButton(index)}
              </View>
            ) : (
              <LineText key={index} line={line} colors={colors} />
            ),
          )}
        </View>
      </ScrollView>
    </View>
  );
}

/* ------------------------------------------------------------- commit graph strip */

export function CommitGraphStrip({ row }: { row: CommitGraphRow }) {
  const laneWidth = 12;
  const height = 56;
  const nodeY = 28;
  const laneX = (lane: number) => lane * laneWidth + 6;
  return (
    <Svg width={Math.max(12, row.laneCount * laneWidth)} height={height}>
      {row.passThrough.map((lane) => (
        <Path key={`p-${lane}`} d={`M${laneX(lane)},0 L${laneX(lane)},${height}`} stroke={laneColor(lane)} strokeWidth={2} fill="none" />
      ))}
      {row.hasTopContinuation ? (
        <Path d={`M${laneX(row.nodeLane)},0 L${laneX(row.nodeLane)},${nodeY}`} stroke={laneColor(row.nodeLane)} strokeWidth={2} fill="none" />
      ) : null}
      {row.hasParentContinuation ? (
        <Path d={`M${laneX(row.nodeLane)},${nodeY} L${laneX(row.nodeLane)},${height}`} stroke={laneColor(row.nodeLane)} strokeWidth={2} fill="none" />
      ) : null}
      {row.inbound.map((lane) => (
        <Path key={`i-${lane}`} d={`M${laneX(lane)},0 Q${laneX(lane)},${nodeY} ${laneX(row.nodeLane)},${nodeY}`} stroke={laneColor(lane)} strokeWidth={2} fill="none" />
      ))}
      {row.outbound.map((lane) => (
        <Path key={`o-${lane}`} d={`M${laneX(row.nodeLane)},${nodeY} Q${laneX(lane)},${nodeY} ${laneX(lane)},${height}`} stroke={laneColor(lane)} strokeWidth={2} fill="none" />
      ))}
      <Circle cx={laneX(row.nodeLane)} cy={nodeY} r={(row.inbound.length || row.outbound.length) ? 4 : 3.5} fill={laneColor(row.nodeLane)} />
    </Svg>
  );
}

/* ------------------------------------------------------------- commit detail */

export function CommitFileList({ files, colors }: { files: CommitFileEntry[]; colors: ThemeColors }) {
  if (files.length === 0) return null;
  return (
    <View style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 8, marginBottom: 8 }}>
      {files.map((file) => {
        const badge = STATUS_BADGE[file.status];
        return (
          <View key={file.path} style={{ flexDirection: 'row', alignItems: 'center', gap: 6, paddingHorizontal: 8, paddingVertical: 5 }}>
            <View style={{ backgroundColor: badge.bg, borderRadius: 3, paddingHorizontal: 4 }}>
              <Text style={{ color: badge.text, fontSize: 10, fontWeight: '700' }}>{file.status}</Text>
            </View>
            <Text style={{ color: colors.mutedForeground, fontSize: 11 }} numberOfLines={1}>
              {file.directory ? `${file.directory}/` : ''}
              <Text style={{ color: colors.foreground }}>{file.filename}</Text>
            </Text>
            <View style={{ flex: 1 }} />
            <Text style={{ color: '#15803d', fontSize: 11 }}>+{file.insertions}</Text>
            <Text style={{ color: '#b91c1c', fontSize: 11 }}>−{file.deletions}</Text>
          </View>
        );
      })}
    </View>
  );
}

/* ------------------------------------------------------------- confirm modal */

export type ConfirmRequest = {
  title: string;
  message: string;
  actionLabel: string;
  onConfirm: () => void;
  alternate?: { label: string; description: string; actionLabel: string; onConfirm: () => void };
};

export function ConfirmModal({ request, colors, t, onClose }: { request: ConfirmRequest | null; colors: ThemeColors; t: T; onClose: () => void }) {
  const [alternate, setAlternate] = useState(false);
  useEffect(() => { setAlternate(false); }, [request]);
  if (!request) return null;
  return (
    <Modal visible transparent animationType="fade" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.6)', alignItems: 'center', justifyContent: 'center', padding: 24 }}>
        <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 20, gap: 12, width: '100%', maxWidth: 380 }}>
          <Text style={{ color: colors.foreground, fontSize: 16, fontWeight: '700' }}>{request.title}</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 13 }}>{request.message}</Text>
          {request.alternate ? (
            <TouchableOpacity onPress={() => setAlternate((value) => !value)} style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
              <View style={{ height: 18, width: 18, borderRadius: 4, borderWidth: 1, borderColor: alternate ? colors.primary : colors.input, backgroundColor: alternate ? colors.primary : 'transparent', alignItems: 'center', justifyContent: 'center' }}>
                {alternate ? <Check size={12} color={colors.primaryForeground} /> : null}
              </View>
              <View style={{ flex: 1 }}>
                <Text style={{ color: colors.foreground, fontSize: 13 }}>{request.alternate.label}</Text>
                <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{request.alternate.description}</Text>
              </View>
            </TouchableOpacity>
          ) : null}
          <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 10 }}>
            <TouchableOpacity onPress={onClose} style={{ paddingVertical: 10, paddingHorizontal: 8 }}>
              <Text style={{ color: colors.mutedForeground }}>{t('gitPanel.cancel')}</Text>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => {
                if (alternate && request.alternate) request.alternate.onConfirm();
                else request.onConfirm();
                onClose();
              }}
              style={{ backgroundColor: colors.destructive, borderRadius: 8, paddingVertical: 10, paddingHorizontal: 16 }}
            >
              <Text style={{ color: '#fff', fontWeight: '600' }}>
                {alternate && request.alternate ? request.alternate.actionLabel : request.actionLabel}
              </Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
}

/* ------------------------------------------------------------- worktree modals */

export function NewWorktreeModal({
  visible,
  colors,
  t,
  baseBranch,
  localBranches,
  repositoryRoot,
  isCreating,
  onClose,
  onCreate,
}: {
  visible: boolean;
  colors: ThemeColors;
  t: T;
  baseBranch: string | null;
  localBranches: string[];
  repositoryRoot: string;
  isCreating: boolean;
  onClose: () => void;
  onCreate: (branch: string, baseBranch: string | null, openAfterCreate: boolean) => void;
}) {
  const [branch, setBranch] = useState('');
  const [base, setBase] = useState<string | null>(baseBranch);
  const [openAfter, setOpenAfter] = useState(true);
  const [baseSheet, setBaseSheet] = useState(false);
  useEffect(() => {
    if (!visible) return;
    setBranch('');
    setBase(baseBranch && localBranches.includes(baseBranch) ? baseBranch : localBranches[0] ?? null);
    setOpenAfter(true);
  }, [visible, baseBranch, localBranches]);
  const trimmed = branch.trim();
  const branchExists = localBranches.includes(trimmed);
  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, padding: 16, gap: 12 }}>
          <Text style={{ color: colors.foreground, fontSize: 16, fontWeight: '700' }}>{t('newWorktree.title')}</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('newWorktree.description')}</Text>
          <TextInput
            value={branch}
            onChangeText={setBranch}
            autoCapitalize="none"
            placeholder={t('newWorktree.branchLabel')}
            placeholderTextColor={colors.mutedForeground}
            style={{ borderWidth: 1, borderColor: colors.input, borderRadius: 8, padding: 10, color: colors.foreground }}
          />
          {trimmed ? (
            <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('newWorktree.willCreateIn', { folder: worktreeFolderPreview(repositoryRoot, trimmed) })}</Text>
          ) : null}
          {!branchExists ? (
            <TouchableOpacity onPress={() => setBaseSheet(true)} style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'space-between', borderWidth: 1, borderColor: colors.input, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10 }}>
              <Text style={{ color: base ? colors.foreground : colors.mutedForeground, fontSize: 13 }}>{base ?? t('newWorktree.createFrom')}</Text>
              <ChevronDown size={14} color={colors.mutedForeground} />
            </TouchableOpacity>
          ) : (
            <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('newWorktree.existingBranch')}</Text>
          )}
          <TouchableOpacity onPress={() => setOpenAfter((value) => !value)} style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
            <View style={{ height: 18, width: 18, borderRadius: 4, borderWidth: 1, borderColor: openAfter ? colors.primary : colors.input, backgroundColor: openAfter ? colors.primary : 'transparent', alignItems: 'center', justifyContent: 'center' }}>
              {openAfter ? <Check size={12} color={colors.primaryForeground} /> : null}
            </View>
            <Text style={{ color: colors.foreground, fontSize: 13 }}>{t('newWorktree.switchAfter')}</Text>
          </TouchableOpacity>
          <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 10 }}>
            <TouchableOpacity onPress={onClose} style={{ paddingVertical: 10, paddingHorizontal: 8 }}>
              <Text style={{ color: colors.mutedForeground }}>{t('gitPanel.cancel')}</Text>
            </TouchableOpacity>
            <TouchableOpacity
              disabled={!trimmed || isCreating}
              onPress={() => onCreate(trimmed, branchExists ? null : base, openAfter)}
              style={{ backgroundColor: colors.primary, borderRadius: 8, paddingVertical: 10, paddingHorizontal: 16, opacity: !trimmed || isCreating ? 0.6 : 1 }}
            >
              <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>{isCreating ? t('gitPanel.creating') : t('newWorktree.submit')}</Text>
            </TouchableOpacity>
          </View>
          <Modal visible={baseSheet} transparent animationType="fade" onRequestClose={() => setBaseSheet(false)}>
            <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'center', padding: 24 }}>
              <View style={{ backgroundColor: colors.card, borderRadius: 12, padding: 12, maxHeight: '70%' }}>
                <ScrollView>
                  {localBranches.map((name) => (
                    <TouchableOpacity key={name} onPress={() => { setBase(name); setBaseSheet(false); }} style={{ paddingVertical: 12, paddingHorizontal: 8 }}>
                      <Text style={{ color: name === base ? colors.primary : colors.foreground }}>{name}</Text>
                    </TouchableOpacity>
                  ))}
                </ScrollView>
              </View>
            </View>
          </Modal>
        </View>
      </View>
    </Modal>
  );
}

export function MergeWorktreeModal({
  visible,
  colors,
  t,
  worktreeBranch,
  isMerging,
  onClose,
  onMerge,
}: {
  visible: boolean;
  colors: ThemeColors;
  t: T;
  worktreeBranch: string | null;
  isMerging: boolean;
  onClose: () => void;
  onMerge: (options: { squash: boolean; message: string; removeAfterMerge: boolean }) => void;
}) {
  const [squash, setSquash] = useState(true);
  const [removeAfter, setRemoveAfter] = useState(true);
  const [message, setMessage] = useState('');
  const [edited, setEdited] = useState(false);
  useEffect(() => {
    if (!visible) return;
    const branch = worktreeBranch ?? '';
    setSquash(true);
    setRemoveAfter(true);
    setMessage(mergeMessage(branch, true));
    setEdited(false);
  }, [visible, worktreeBranch]);
  const toggleSquash = () => {
    const next = !squash;
    setSquash(next);
    if (!edited) setMessage(mergeMessage(worktreeBranch ?? '', next));
  };
  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, padding: 16, gap: 12 }}>
          <Text style={{ color: colors.foreground, fontSize: 16, fontWeight: '700' }}>{t('mergeWorktree.title')}</Text>
          <TouchableOpacity onPress={toggleSquash} style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
            <View style={{ height: 18, width: 18, borderRadius: 4, borderWidth: 1, borderColor: squash ? colors.primary : colors.input, backgroundColor: squash ? colors.primary : 'transparent', alignItems: 'center', justifyContent: 'center' }}>
              {squash ? <Check size={12} color={colors.primaryForeground} /> : null}
            </View>
            <View style={{ flex: 1 }}>
              <Text style={{ color: colors.foreground, fontSize: 13 }}>{t('mergeWorktree.squashLabel')}</Text>
              <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('mergeWorktree.squashDesc')}</Text>
            </View>
          </TouchableOpacity>
          <TextInput
            value={message}
            onChangeText={(value) => { setMessage(value); setEdited(true); }}
            placeholder={t('mergeWorktree.messageLabel')}
            placeholderTextColor={colors.mutedForeground}
            multiline
            style={{ borderWidth: 1, borderColor: colors.input, borderRadius: 8, padding: 10, color: colors.foreground, minHeight: 56, textAlignVertical: 'top' }}
          />
          <TouchableOpacity onPress={() => setRemoveAfter((value) => !value)} style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
            <View style={{ height: 18, width: 18, borderRadius: 4, borderWidth: 1, borderColor: removeAfter ? colors.primary : colors.input, backgroundColor: removeAfter ? colors.primary : 'transparent', alignItems: 'center', justifyContent: 'center' }}>
              {removeAfter ? <Check size={12} color={colors.primaryForeground} /> : null}
            </View>
            <View style={{ flex: 1 }}>
              <Text style={{ color: colors.foreground, fontSize: 13 }}>{t('mergeWorktree.cleanupLabel')}</Text>
              <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('mergeWorktree.cleanupDesc')}</Text>
            </View>
          </TouchableOpacity>
          <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 10 }}>
            <TouchableOpacity onPress={onClose} style={{ paddingVertical: 10, paddingHorizontal: 8 }}>
              <Text style={{ color: colors.mutedForeground }}>{t('gitPanel.cancel')}</Text>
            </TouchableOpacity>
            <TouchableOpacity
              disabled={isMerging || !message.trim()}
              onPress={() => onMerge({ squash, message: message.trim(), removeAfterMerge: removeAfter })}
              style={{ backgroundColor: colors.primary, borderRadius: 8, paddingVertical: 10, paddingHorizontal: 16, opacity: isMerging || !message.trim() ? 0.6 : 1 }}
            >
              <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>{isMerging ? t('gitPanel.merging') : t('mergeWorktree.merge')}</Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
}

export function RemoveWorktreeModal({
  visible,
  colors,
  t,
  isDirty,
  hasBranch,
  isRemoving,
  onClose,
  onRemove,
}: {
  visible: boolean;
  colors: ThemeColors;
  t: T;
  isDirty: boolean;
  hasBranch: boolean;
  isRemoving: boolean;
  onClose: () => void;
  onRemove: (options: { force: boolean; deleteBranch: boolean }) => void;
}) {
  const [force, setForce] = useState(false);
  const [deleteBranch, setDeleteBranch] = useState(true);
  useEffect(() => {
    if (!visible) return;
    setForce(false);
    setDeleteBranch(true);
  }, [visible]);
  const disabled = isRemoving || (isDirty && !force);
  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, padding: 16, gap: 12 }}>
          <Text style={{ color: colors.foreground, fontSize: 16, fontWeight: '700' }}>{t('removeWorktree.title')}</Text>
          <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{t('removeWorktree.description')}</Text>
          {isDirty ? (
            <View style={{ flexDirection: 'row', gap: 8, backgroundColor: '#fef3c7', borderRadius: 8, padding: 10 }}>
              <AlertTriangle size={16} color="#b45309" />
              <Text style={{ color: '#b45309', fontSize: 12, flex: 1 }}>{t('removeWorktree.dirtyWarning')}</Text>
            </View>
          ) : null}
          {isDirty ? (
            <TouchableOpacity onPress={() => setForce((value) => !value)} style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
              <View style={{ height: 18, width: 18, borderRadius: 4, borderWidth: 1, borderColor: force ? colors.destructive : colors.input, backgroundColor: force ? colors.destructive : 'transparent', alignItems: 'center', justifyContent: 'center' }}>
                {force ? <Check size={12} color="#fff" /> : null}
              </View>
              <Text style={{ color: colors.foreground, fontSize: 13 }}>{t('removeWorktree.discardChanges')}</Text>
            </TouchableOpacity>
          ) : null}
          {hasBranch ? (
            <TouchableOpacity onPress={() => setDeleteBranch((value) => !value)} style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
              <View style={{ height: 18, width: 18, borderRadius: 4, borderWidth: 1, borderColor: deleteBranch ? colors.primary : colors.input, backgroundColor: deleteBranch ? colors.primary : 'transparent', alignItems: 'center', justifyContent: 'center' }}>
                {deleteBranch ? <Check size={12} color={colors.primaryForeground} /> : null}
              </View>
              <Text style={{ color: colors.foreground, fontSize: 13 }}>{t('removeWorktree.alsoDelete')}</Text>
            </TouchableOpacity>
          ) : null}
          <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 10 }}>
            <TouchableOpacity onPress={onClose} style={{ paddingVertical: 10, paddingHorizontal: 8 }}>
              <Text style={{ color: colors.mutedForeground }}>{t('gitPanel.cancel')}</Text>
            </TouchableOpacity>
            <TouchableOpacity
              disabled={disabled}
              onPress={() => onRemove({ force, deleteBranch })}
              style={{ backgroundColor: colors.destructive, borderRadius: 8, paddingVertical: 10, paddingHorizontal: 16, opacity: disabled ? 0.6 : 1 }}
            >
              <Text style={{ color: '#fff', fontWeight: '600' }}>{isRemoving ? t('gitPanel.removing') : t('gitPanel.remove')}</Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
}

export function WorktreeScriptsModal({
  visible,
  colors,
  t,
  config,
  isSaving,
  onClose,
  onSave,
}: {
  visible: boolean;
  colors: ThemeColors;
  t: T;
  config: WorktreeScriptsConfig | null;
  isSaving: boolean;
  onClose: () => void;
  onSave: (next: { setup: string | null; run: string | null; runPort: number | null }) => void;
}) {
  const [setup, setSetup] = useState('');
  const [run, setRun] = useState('');
  const [port, setPort] = useState('');
  const [error, setError] = useState<string | null>(null);
  useEffect(() => {
    if (!visible) return;
    setSetup(config?.setup ?? '');
    setRun(config?.run ?? '');
    setPort(config?.runPort != null ? String(config.runPort) : '');
    setError(null);
  }, [visible, config]);
  const save = () => {
    const validation = validateWorktreeConfig(setup, run, port);
    if (!validation.ok) {
      setError(t('worktreeScripts.invalidPort'));
      return;
    }
    onSave({ setup: setup.trim() || null, run: run.trim() || null, runPort: validation.runPort });
  };
  const field = (label: string, value: string, onChange: (text: string) => void, mono = false) => (
    <View style={{ gap: 4 }}>
      <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{label}</Text>
      <TextInput
        value={value}
        onChangeText={onChange}
        autoCapitalize="none"
        placeholderTextColor={colors.mutedForeground}
        style={{ borderWidth: 1, borderColor: colors.input, borderRadius: 8, padding: 10, color: colors.foreground, fontFamily: mono ? 'monospace' : undefined, fontSize: mono ? 12 : 14 }}
      />
    </View>
  );
  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, padding: 16, gap: 12, maxHeight: '85%' }}>
          <Text style={{ color: colors.foreground, fontSize: 16, fontWeight: '700' }}>{t('worktreeScripts.title')}</Text>
          <ScrollView contentContainerStyle={{ gap: 12 }}>
            {field(t('worktreeScripts.setup'), setup, setSetup, true)}
            {field(t('worktreeScripts.run'), run, setRun, true)}
            {field(t('worktreeScripts.runPort'), port, setPort)}
            {error ? <Text style={{ color: colors.destructive, fontSize: 12 }}>{error}</Text> : null}
          </ScrollView>
          <View style={{ flexDirection: 'row', justifyContent: 'flex-end', gap: 10 }}>
            <TouchableOpacity onPress={onClose} style={{ paddingVertical: 10, paddingHorizontal: 8 }}>
              <Text style={{ color: colors.mutedForeground }}>{t('gitPanel.cancel')}</Text>
            </TouchableOpacity>
            <TouchableOpacity disabled={isSaving} onPress={save} style={{ backgroundColor: colors.primary, borderRadius: 8, paddingVertical: 10, paddingHorizontal: 16, opacity: isSaving ? 0.6 : 1 }}>
              <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>{isSaving ? t('worktreeScripts.saving') : t('gitPanel.save')}</Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
}

/* ------------------------------------------------------------- status legend */

export function FileStatusLegend({ colors, t }: { colors: ThemeColors; t: T }) {
  const [open, setOpen] = useState(false);
  const items: { status: GitChangedFile['status']; key: string; fallback: string }[] = [
    { status: 'M', key: 'modified', fallback: 'Modified' },
    { status: 'A', key: 'added', fallback: 'Added' },
    { status: 'D', key: 'deleted', fallback: 'Deleted' },
    { status: 'U', key: 'untracked', fallback: 'Untracked' },
  ];
  return (
    <View>
      <TouchableOpacity onPress={() => setOpen((value) => !value)} style={{ flexDirection: 'row', alignItems: 'center', gap: 4, paddingHorizontal: 12, paddingVertical: 6 }}>
        <FileText size={12} color={colors.mutedForeground} />
        <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t('gitPanel.statusGuide')}</Text>
        <ChevronDown size={12} color={colors.mutedForeground} style={{ transform: [{ rotate: open ? '180deg' : '0deg' }] }} />
      </TouchableOpacity>
      {open ? (
        <View style={{ flexDirection: 'row', flexWrap: 'wrap', gap: 10, paddingHorizontal: 12, paddingBottom: 8 }}>
          {items.map((item) => (
            <View key={item.status} style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
              <View style={{ backgroundColor: STATUS_BADGE[item.status].bg, borderRadius: 3, paddingHorizontal: 4 }}>
                <Text style={{ color: STATUS_BADGE[item.status].text, fontSize: 10, fontWeight: '700' }}>{item.status}</Text>
              </View>
              <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{t(`gitPanel.status.${item.key}`, { defaultValue: item.fallback })}</Text>
            </View>
          ))}
        </View>
      ) : null}
    </View>
  );
}

export function WorktreeRunButton({
  colors,
  t,
  running,
  port,
  onPress,
  disabled,
}: {
  colors: ThemeColors;
  t: T;
  running: boolean;
  port?: number | null;
  onPress: () => void;
  disabled?: boolean;
}) {
  return (
    <TouchableOpacity disabled={disabled} onPress={onPress} style={{ flexDirection: 'row', alignItems: 'center', gap: 4, borderWidth: 1, borderColor: colors.border, borderRadius: 6, paddingHorizontal: 8, paddingVertical: 4 }}>
      {running ? <Square size={12} color="#b45309" /> : <Play size={12} color={colors.foreground} />}
      <Text style={{ color: running ? '#b45309' : colors.foreground, fontSize: 11, fontWeight: '600' }}>
        {running ? t('worktreeScripts.stop') : t('worktreeScripts.run')}
        {running && port ? ` :${port}` : ''}
      </Text>
    </TouchableOpacity>
  );
}
