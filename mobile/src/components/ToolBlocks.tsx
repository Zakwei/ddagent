/** Native tool-call renderers — 1:1 port of web `src/components/chat/tools/*`.
 *
 * Web tool chrome (oc-tool-row, status badges, diff colors) is reproduced with
 * inline RN styles; provider-agnostic labels are the same hardcoded English the
 * web toolConfigs use.
 */

import React, { useState } from 'react';
import { Platform, Text, TouchableOpacity, View } from 'react-native';
import { Check, ChevronRight, Circle, Clock, Copy } from 'lucide-react-native';
import * as Clipboard from 'expo-clipboard';

import { HighlightText } from './HighlightText';
import type { ToolCall } from '../lib/chat-messages';
import {
  calculateDiff,
  collapsibleTitle,
  diffContentFor,
  extractFilePaths,
  flattenToolValue,
  getToolDisplay,
  ocToolIcon,
  oneLineValues,
  parseTaskListContent,
  resolveToolName,
  shouldHideToolResult,
  TOOL_STATUS_LABEL,
  type ToolGroupItem,
  type ToolStatus,
} from '../lib/tool-render';

const MONO = Platform.OS === 'ios' ? 'Menlo' : 'monospace';

interface Colors {
  foreground: string;
  mutedForeground: string;
  card: string;
  border: string;
  muted: string;
  primary: string;
  primaryForeground: string;
  destructive: string;
}

const STATUS_STYLE: Record<ToolStatus, { bg: string; fg: string; darkBg: string; darkFg: string }> = {
  running: { bg: '#dbeafe', fg: '#1d4ed8', darkBg: 'rgba(30,64,175,0.3)', darkFg: '#93c5fd' },
  completed: { bg: '#dcfce7', fg: '#15803d', darkBg: 'rgba(22,101,52,0.3)', darkFg: '#86efac' },
  error: { bg: '#fee2e2', fg: '#b91c1c', darkBg: 'rgba(127,29,29,0.3)', darkFg: '#fca5a5' },
  denied: { bg: '#ffedd5', fg: '#c2410c', darkBg: 'rgba(124,45,18,0.3)', darkFg: '#fdba74' },
};

export function ToolStatusBadge({ status, isDark, style }: { status: ToolStatus; isDark: boolean; style?: any }) {
  const s = STATUS_STYLE[status];
  return (
    <View style={[{ borderRadius: 4, paddingHorizontal: 5, paddingVertical: 1, alignSelf: 'flex-start' }, { backgroundColor: isDark ? s.darkBg : s.bg }, style]}>
      <Text style={{ fontSize: 10, fontWeight: '600', color: isDark ? s.darkFg : s.fg }}>
        {TOOL_STATUS_LABEL[status]}
      </Text>
    </View>
  );
}

function Chevron({ open, colors, size = 13 }: { open: boolean; colors: Colors; size?: number }) {
  return (
    <View style={{ transform: [{ rotate: open ? '90deg' : '0deg' }] }}>
      <ChevronRight size={size} color={colors.mutedForeground} />
    </View>
  );
}

function ToolIcon({ name }: { name: string }) {
  return <Text style={{ fontFamily: MONO, fontSize: 12, width: 14, textAlign: 'center' }}>{ocToolIcon(name)}</Text>;
}

function DiffBlock({ oldText, newText, badge, colors, isDark }: { oldText: string; newText: string; badge: string; colors: Colors; isDark: boolean }) {
  const lines = calculateDiff(oldText, newText);
  if (lines.length === 0) {
    return <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>No changes</Text>;
  }
  return (
    <View style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 6, overflow: 'hidden' }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', paddingHorizontal: 8, paddingVertical: 4, backgroundColor: colors.muted }}>
        <Text style={{ fontSize: 10, fontWeight: '600', color: colors.mutedForeground }}>{badge}</Text>
      </View>
      {lines.map((line, i) => {
        const added = line.type === 'added';
        return (
          <View
            key={i}
            style={{ flexDirection: 'row', backgroundColor: added ? (isDark ? 'rgba(20,83,45,0.35)' : '#f0fdf4') : (isDark ? 'rgba(127,29,29,0.3)' : '#fef2f2') }}
          >
            <Text style={{ width: 34, textAlign: 'right', paddingRight: 6, fontSize: 11, color: colors.mutedForeground, fontFamily: MONO }}>{line.lineNum}</Text>
            <Text style={{ width: 12, fontSize: 11, color: added ? '#16a34a' : '#dc2626', fontFamily: MONO }}>{added ? '+' : '-'}</Text>
            <Text style={{ flex: 1, fontSize: 11, fontFamily: MONO, color: added ? (isDark ? '#bbf7d0' : '#166534') : (isDark ? '#fecaca' : '#991b1b'), paddingRight: 6 }}>{line.content}</Text>
          </View>
        );
      })}
    </View>
  );
}

function CollapsibleTool({
  toolName, title, status, defaultOpen, colors, isDark, children, onTitlePress, query,
}: {
  toolName: string; title: string; status?: ToolStatus; defaultOpen?: boolean;
  colors: Colors; isDark: boolean; children: React.ReactNode; onTitlePress?: () => void; query?: string;
}) {
  const [open, setOpen] = useState(Boolean(defaultOpen));
  return (
    <View style={{ marginBottom: 4 }}>
      <View style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 2 }}>
        <TouchableOpacity onPress={() => setOpen((o) => !o)} style={{ flexDirection: 'row', alignItems: 'center' }} hitSlop={6}>
          <Chevron open={open} colors={colors} size={12} />
          <Text style={{ fontSize: 12, fontWeight: '500', color: colors.mutedForeground, marginLeft: 4 }}>{toolName}</Text>
          <Text style={{ fontSize: 10, color: colors.mutedForeground, marginHorizontal: 3 }}>/</Text>
        </TouchableOpacity>
        <TouchableOpacity onPress={onTitlePress} disabled={!onTitlePress} style={{ flex: 1 }} hitSlop={4}>
          <HighlightText text={title} query={query ?? ''} style={{ fontSize: 12, color: colors.primary, fontFamily: MONO }} numberOfLines={1} />
        </TouchableOpacity>
        {status ? <ToolStatusBadge status={status} isDark={isDark} /> : null}
      </View>
      {open && <View style={{ paddingLeft: 18, marginTop: 4 }}>{children}</View>}
    </View>
  );
}

function OneLineTool({
  name, tool, colors, isDark, query, onOpenFile,
}: {
  name: string; tool: ToolCall; colors: Colors; isDark: boolean; query?: string; onOpenFile?: (path: string) => void;
}) {
  const { value, secondary } = oneLineValues(name, tool.input);
  const hasResult = Boolean(tool.result && tool.result.trim());
  const [open, setOpen] = useState(false);
  const [copied, setCopied] = useState(false);
  const status: ToolStatus = tool.status === 'running' ? 'running' : tool.isError ? 'error' : 'completed';
  const isError = status === 'error';
  const openFile = name === 'Read' && value && onOpenFile ? () => onOpenFile(value) : undefined;

  return (
    <View style={{ borderWidth: 1, borderColor: isError ? 'rgba(239,68,68,0.45)' : colors.border, borderRadius: 8, backgroundColor: colors.card, marginBottom: 4, overflow: 'hidden' }}>
      <TouchableOpacity activeOpacity={0.8} onPress={() => hasResult && setOpen((o) => !o)} style={{ flexDirection: 'row', alignItems: 'center', paddingHorizontal: 8, paddingVertical: 5 }}>
        {hasResult ? <Chevron open={open} colors={colors} /> : null}
        <View style={{ marginHorizontal: 4 }}><ToolIcon name={name} /></View>
        <Text style={{ fontSize: 12, color: colors.mutedForeground, marginRight: 6 }}>{name}</Text>
        {value ? (
          openFile ? (
            <TouchableOpacity onPress={openFile} style={{ flex: 1 }} hitSlop={4}>
              <Text style={{ fontSize: 12, fontFamily: MONO, color: colors.primary }} numberOfLines={1}>{value}</Text>
            </TouchableOpacity>
          ) : (
            <HighlightText text={value} query={query ?? ''} style={{ flex: 1, fontSize: 12, color: colors.foreground, fontFamily: MONO }} numberOfLines={open ? 0 : 1} />
          )
        ) : (
          <View style={{ flex: 1 }} />
        )}
        {secondary ? (
          <Text style={{ fontSize: 11, fontStyle: 'italic', color: colors.mutedForeground, marginLeft: 6 }} numberOfLines={1}>{secondary}</Text>
        ) : null}
        {status !== 'completed' ? <ToolStatusBadge status={status} isDark={isDark} style={{ marginLeft: 6 }} /> : null}
        {value ? (
          <TouchableOpacity
            onPress={() => {
              setCopied(true);
              void Clipboard.setStringAsync(value).catch(() => {});
              setTimeout(() => setCopied(false), 1500);
            }}
            hitSlop={6}
            style={{ padding: 4 }}
          >
            {copied ? <Check size={12} color="#16a34a" /> : <Copy size={12} color={colors.mutedForeground} />}
          </TouchableOpacity>
        ) : null}
      </TouchableOpacity>
      {open && hasResult && (
        <View style={{ borderTopWidth: 1, borderTopColor: colors.border, paddingHorizontal: 10, paddingVertical: 8 }}>
          <Text style={{ fontSize: 11, fontFamily: MONO, color: isError ? colors.destructive : colors.mutedForeground }}>{tool.result}</Text>
        </View>
      )}
    </View>
  );
}

function BashTool({ tool, colors, isDark }: { tool: ToolCall; colors: Colors; isDark: boolean }) {
  const command = String((tool.input as any)?.command ?? '');
  const description = (tool.input as any)?.description;
  const output = (tool.result ?? '').replace(/\s+$/, '');
  const hasOutput = output.length > 0;
  const [open, setOpen] = useState(false);
  const [copied, setCopied] = useState(false);
  const isRunning = tool.status === 'running';
  const isError = Boolean(tool.isError);
  const lines = hasOutput ? output.split('\n').length : 0;

  return (
    <View style={{ borderWidth: 1, borderColor: isError ? 'rgba(239,68,68,0.45)' : colors.border, borderRadius: 8, backgroundColor: colors.card, marginBottom: 4, overflow: 'hidden' }}>
      <TouchableOpacity activeOpacity={0.8} onPress={() => hasOutput && setOpen((o) => !o)} style={{ flexDirection: 'row', alignItems: 'center', paddingHorizontal: 8, paddingVertical: 5 }}>
        <Chevron open={open} colors={colors} />
        <Text style={{ fontFamily: MONO, fontSize: 12, fontWeight: '700', color: '#10b981', marginHorizontal: 4 }}>$</Text>
        <Text style={{ flex: 1, fontFamily: MONO, fontSize: 12, color: colors.foreground }} numberOfLines={open ? 0 : 1}>{command}</Text>
        {isRunning ? <Text style={{ fontSize: 10, color: colors.mutedForeground }}>running…</Text> : null}
        {!isRunning ? <ToolStatusBadge status={isError ? 'error' : 'completed'} isDark={isDark} style={{ marginLeft: 6 }} /> : null}
        {!open && hasOutput && !isRunning ? (
          <Text style={{ fontSize: 10, color: colors.mutedForeground, marginLeft: 6 }}>{lines} {lines === 1 ? 'line' : 'lines'}</Text>
        ) : null}
        <TouchableOpacity
          onPress={() => {
            setCopied(true);
            void Clipboard.setStringAsync(command).catch(() => {});
            setTimeout(() => setCopied(false), 1500);
          }}
          hitSlop={6}
          style={{ padding: 4 }}
        >
          {copied ? <Check size={13} color="#10b981" /> : <Copy size={13} color={colors.mutedForeground} />}
        </TouchableOpacity>
      </TouchableOpacity>
      {description && !open ? (
        <Text style={{ fontSize: 11, fontStyle: 'italic', color: colors.mutedForeground, paddingHorizontal: 10, paddingBottom: 6 }}>{description}</Text>
      ) : null}
      {open && hasOutput && (
        <View style={{ borderTopWidth: 1, borderTopColor: colors.border, maxHeight: 360 }}>
          {description ? (
            <Text style={{ fontSize: 11, fontStyle: 'italic', color: colors.mutedForeground, paddingHorizontal: 10, paddingTop: 6 }}>{description}</Text>
          ) : null}
          <Text style={{ fontFamily: MONO, fontSize: 11, padding: 10, color: isError ? colors.destructive : colors.mutedForeground }}>{output}</Text>
        </View>
      )}
    </View>
  );
}

function TodoTool({ todos, isResult, colors }: { todos: any[]; isResult?: boolean; colors: Colors }) {
  if (!Array.isArray(todos) || todos.length === 0) return null;
  const iconFor = (status: string) =>
    status === 'completed' ? <Check size={13} color="#16a34a" /> : status === 'in_progress' ? <Clock size={13} color="#2563eb" /> : <Circle size={13} color={colors.mutedForeground} />;
  return (
    <View>
      {isResult ? (
        <Text style={{ fontSize: 12, fontWeight: '500', color: colors.mutedForeground, marginBottom: 4 }}>
          Todo List ({todos.length} {todos.length === 1 ? 'item' : 'items'})
        </Text>
      ) : null}
      {todos.map((todo, i) => (
        <View key={todo?.id ?? i} style={{ flexDirection: 'row', alignItems: 'flex-start', paddingVertical: 2 }}>
          <View style={{ marginTop: 1 }}>{iconFor(String(todo?.status ?? 'pending'))}</View>
          <Text
            style={{
              flex: 1, marginLeft: 6, fontSize: 12, color: colors.foreground,
              textDecorationLine: todo?.status === 'completed' ? 'line-through' : 'none',
              opacity: todo?.status === 'completed' ? 0.6 : 1,
            }}
          >
            {String(todo?.content ?? todo?.activeForm ?? '')}
          </Text>
        </View>
      ))}
    </View>
  );
}

function TaskListTool({ content, colors }: { content: string; colors: Colors }) {
  const tasks = parseTaskListContent(content);
  if (tasks.length === 0) {
    return <Text style={{ fontFamily: MONO, fontSize: 11, color: colors.mutedForeground }}>{content}</Text>;
  }
  const completed = tasks.filter((t) => t.status === 'completed').length;
  return (
    <View>
      <View style={{ flexDirection: 'row', alignItems: 'center', marginBottom: 6 }}>
        <Text style={{ fontSize: 11, color: colors.mutedForeground, marginRight: 8 }}>{completed}/{tasks.length} completed</Text>
        <View style={{ flex: 1, height: 4, borderRadius: 2, backgroundColor: colors.muted, overflow: 'hidden' }}>
          <View style={{ width: `${(completed / tasks.length) * 100}%`, height: 4, backgroundColor: '#22c55e' }} />
        </View>
      </View>
      {tasks.map((task) => {
        const icon = task.status === 'completed' ? <Check size={13} color="#16a34a" /> : task.status === 'in_progress' ? <Clock size={13} color="#2563eb" /> : <Circle size={13} color={colors.mutedForeground} />;
        return (
          <View key={task.id} style={{ flexDirection: 'row', alignItems: 'center', paddingVertical: 2 }}>
            {icon}
            <Text style={{ fontFamily: MONO, fontSize: 11, color: colors.mutedForeground, marginHorizontal: 5 }}>#{task.id}</Text>
            <Text style={{ flex: 1, fontSize: 12, color: colors.foreground, textDecorationLine: task.status === 'completed' ? 'line-through' : 'none' }} numberOfLines={1}>{task.subject}</Text>
            <Text style={{ fontSize: 10, color: colors.mutedForeground }}>{task.status.replace('_', ' ')}</Text>
          </View>
        );
      })}
    </View>
  );
}

function QATool({ questions, answers, colors }: { questions: any[]; answers: Record<string, string>; colors: Colors }) {
  const [expanded, setExpanded] = useState<number | null>(null);
  if (!Array.isArray(questions) || questions.length === 0) return null;
  const hasAnyAnswer = Object.keys(answers || {}).length > 0;
  return (
    <View>
      {questions.map((q, idx) => {
        if (!q || typeof q.question !== 'string') return null;
        const answer = answers?.[q.question];
        const labels = typeof answer === 'string' ? answer.split(', ') : [];
        const isOpen = expanded === idx;
        return (
          <View key={idx} style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 8, marginBottom: 8, overflow: 'hidden' }}>
            <TouchableOpacity onPress={() => setExpanded(isOpen ? null : idx)} style={{ flexDirection: 'row', alignItems: 'flex-start', paddingHorizontal: 10, paddingVertical: 8 }}>
              <View style={{ marginTop: 2, marginRight: 8 }}>
                {labels.length > 0 ? <Check size={14} color={colors.primary} /> : <Circle size={14} color={colors.mutedForeground} />}
              </View>
              <View style={{ flex: 1 }}>
                <View style={{ flexDirection: 'row', flexWrap: 'wrap', alignItems: 'center' }}>
                  {q.header ? <Text style={{ fontSize: 9, fontWeight: '700', letterSpacing: 0.5, color: colors.primary, marginRight: 6 }}>{String(q.header).toUpperCase()}</Text> : null}
                  {questions.length > 1 ? <Text style={{ fontSize: 10, color: colors.mutedForeground }}>{idx + 1}/{questions.length}</Text> : null}
                </View>
                <Text style={{ fontSize: 12, color: colors.mutedForeground, marginTop: 2 }}>{q.question}</Text>
                {labels.length > 0 ? (
                  <View style={{ flexDirection: 'row', flexWrap: 'wrap', marginTop: 4 }}>
                    {labels.map((lbl: string) => <Text key={lbl} style={{ fontSize: 11, color: colors.primary, marginRight: 6 }}>{lbl}</Text>)}
                  </View>
                ) : hasAnyAnswer ? (
                  <Text style={{ fontSize: 10, fontStyle: 'italic', color: colors.mutedForeground, marginTop: 3 }}>Skipped</Text>
                ) : null}
              </View>
            </TouchableOpacity>
            {isOpen && Array.isArray(q.options) ? (
              <View style={{ borderTopWidth: 1, borderTopColor: colors.border, paddingHorizontal: 10, paddingVertical: 8 }}>
                {q.options.filter((o: any) => o && typeof o.label === 'string').map((opt: any) => {
                  const selected = labels.includes(opt.label);
                  return (
                    <View key={opt.label} style={{ flexDirection: 'row', alignItems: 'flex-start', paddingVertical: 3 }}>
                      <View style={{ marginTop: 2, marginRight: 8 }}>
                        {selected ? <Check size={13} color={colors.primary} /> : <Circle size={13} color={colors.mutedForeground} />}
                      </View>
                      <View style={{ flex: 1 }}>
                        <Text style={{ fontSize: 12, color: selected ? colors.foreground : colors.mutedForeground, fontWeight: selected ? '600' : '400' }}>{opt.label}</Text>
                        {opt.description ? <Text style={{ fontSize: 11, color: colors.mutedForeground }}>{opt.description}</Text> : null}
                      </View>
                    </View>
                  );
                })}
              </View>
            ) : null}
          </View>
        );
      })}
      {!hasAnyAnswer && questions.length === 1 ? (
        <Text style={{ fontSize: 11, fontStyle: 'italic', color: colors.mutedForeground }}>Skipped</Text>
      ) : null}
    </View>
  );
}

function FileListTool({ files, colors, onOpenFile }: { files: string[]; colors: Colors; onOpenFile?: (p: string) => void }) {
  if (!Array.isArray(files) || files.length === 0) {
    return <Text style={{ fontSize: 12, color: colors.mutedForeground }}>No files</Text>;
  }
  return (
    <View style={{ flexDirection: 'row', flexWrap: 'wrap', maxHeight: 220 }}>
      {files.map((file, i) => (
        <TouchableOpacity key={`${file}-${i}`} onPress={() => onOpenFile?.(file)} hitSlop={4}>
          <Text style={{ fontFamily: MONO, fontSize: 11, color: colors.primary, marginRight: 6 }}>{file.split('/').pop() || file}</Text>
        </TouchableOpacity>
      ))}
    </View>
  );
}

function PlanTool({ title, content, colors, defaultOpen }: { title: string; content: string; colors: Colors; isDark: boolean; defaultOpen?: boolean }) {
  const [open, setOpen] = useState(Boolean(defaultOpen));
  return (
    <View style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 8, backgroundColor: colors.card, marginBottom: 4, overflow: 'hidden' }}>
      <TouchableOpacity onPress={() => setOpen((o) => !o)} style={{ flexDirection: 'row', alignItems: 'center', paddingHorizontal: 10, paddingVertical: 8 }}>
        <Chevron open={open} colors={colors} />
        <Text style={{ flex: 1, fontSize: 12, fontWeight: '600', color: colors.foreground, marginLeft: 6 }}>{title}</Text>
      </TouchableOpacity>
      {open ? (
        <View style={{ borderTopWidth: 1, borderTopColor: colors.border, paddingHorizontal: 12, paddingVertical: 10 }}>
          <Text style={{ fontSize: 13, color: colors.foreground }}>{content}</Text>
        </View>
      ) : null}
    </View>
  );
}

const safeJson = (raw: string): any => {
  try {
    return JSON.parse(raw);
  } catch {
    return raw;
  }
};

export function ToolItem({
  tool, colors, isDark, query, onOpenFile,
}: {
  tool: ToolCall; colors: Colors; isDark: boolean; query?: string; onOpenFile?: (path: string) => void;
}) {
  const name = resolveToolName(tool.name, tool.toolId);
  const display = getToolDisplay(tool.name, tool.toolId);

  const hideResult = shouldHideToolResult(tool.name, Boolean(tool.isError), tool.toolId);
  const resultText = hideResult ? '' : tool.result ?? '';
  const effective: ToolCall = { ...tool, result: resultText };
  const status: ToolStatus = tool.status === 'running' ? 'running' : tool.isError ? 'error' : 'completed';

  if (name === 'Bash') return <BashTool tool={effective} colors={colors} isDark={isDark} />;

  if (display.kind === 'plan') {
    const content = String((tool.input as any)?.plan ?? '').replace(/\\n/g, '\n');
    return <PlanTool title={display.label || 'Implementation plan'} content={content} colors={colors} isDark={isDark} defaultOpen={display.defaultOpen} />;
  }

  if (display.kind === 'collapsible') {
    const input = tool.input;
    let body: React.ReactNode = null;
    if (display.contentType === 'diff') {
      const { old: oldText, new: newText, badge } = diffContentFor(name, input);
      body = <DiffBlock oldText={oldText} newText={newText} badge={badge} colors={colors} isDark={isDark} />;
    } else if (display.contentType === 'todo-list') {
      body = <TodoTool todos={(input as any)?.todos} colors={colors} />;
    } else if (display.contentType === 'task') {
      body = <TaskListTool content={String(resultText || flattenToolValue(input))} colors={colors} />;
    } else if (display.contentType === 'question-answer') {
      body = <QATool questions={(input as any)?.questions} answers={(input as any)?.answers ?? {}} colors={colors} />;
    } else if (display.contentType === 'file-list') {
      body = <FileListTool files={extractFilePaths(resultText ? safeJson(resultText) : input)} colors={colors} onOpenFile={onOpenFile} />;
    } else if (display.contentType === 'markdown') {
      body = <Text style={{ fontSize: 13, color: colors.foreground }}>{String((input as any)?.prompt ?? (input as any)?.content ?? '')}</Text>;
    } else {
      body = <Text style={{ fontSize: 12, color: colors.mutedForeground }}>{flattenToolValue(input)}</Text>;
    }

    const filePath = (input as any)?.file_path || (input as any)?.filePath;
    const onTitlePress = (name === 'Edit' || name === 'Write' || name === 'ApplyPatch') && filePath && onOpenFile
      ? () => onOpenFile(String(filePath))
      : undefined;

    return (
      <CollapsibleTool
        toolName={name}
        title={collapsibleTitle(name, input)}
        status={status !== 'completed' ? status : undefined}
        defaultOpen={display.defaultOpen}
        colors={colors}
        isDark={isDark}
        onTitlePress={onTitlePress}
        query={query}
      >
        {body}
      </CollapsibleTool>
    );
  }

  if (display.kind === 'hidden') return null;

  return <OneLineTool name={name} tool={effective} colors={colors} isDark={isDark} query={query} onOpenFile={onOpenFile} />;
}

/** Collapsed run of >=3 consecutive same-tool calls (web ToolGroupContainer). */
export function ToolGroupBlock({
  group, colors, isDark, query, onOpenFile,
}: {
  group: ToolGroupItem; colors: Colors; isDark: boolean; query?: string; onOpenFile?: (path: string) => void;
}) {
  const [open, setOpen] = useState(false);
  return (
    <View style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 8, backgroundColor: colors.card, marginBottom: 4, overflow: 'hidden' }}>
      <TouchableOpacity onPress={() => setOpen((o) => !o)} style={{ flexDirection: 'row', alignItems: 'center', paddingHorizontal: 10, paddingVertical: 7 }}>
        <Chevron open={open} colors={colors} />
        <View style={{ marginHorizontal: 5 }}><ToolIcon name={group.toolName} /></View>
        <Text style={{ flex: 1, fontSize: 12, color: colors.mutedForeground }} numberOfLines={1}>
          {group.toolName} · {group.messages.length} calls
        </Text>
      </TouchableOpacity>
      {open ? (
        <View style={{ borderTopWidth: 1, borderTopColor: colors.border, padding: 8 }}>
          {group.messages.map((m) => m.tools.map((t) => (
            <ToolItem key={t.id} tool={t} colors={colors} isDark={isDark} query={query} onOpenFile={onOpenFile} />
          )))}
        </View>
      ) : null}
    </View>
  );
}
