import React, { useMemo, useState } from 'react';
import {
  Image,
  Linking,
  Modal,
  Platform,
  Pressable,
  ScrollView,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import * as Clipboard from 'expo-clipboard';
import Markdown from 'react-native-markdown-display';
import {
  Archive,
  Check,
  ChevronDown,
  ChevronRight,
  Copy,
  File as FileIcon,
  FileCode,
  FileText,
  X,
} from 'lucide-react-native';
import { tokenizeCode, syntaxStyleFor, languageLabel } from '../lib/highlight';
import {
  fileRefFromLink,
  formatFileSize,
  formatMessageTime,
  formatTurnLatency,
  type ParsedInteractivePrompt,
  type ParsedTaskNotification,
} from '../lib/chat-format';
import { HighlightText } from './HighlightText';

const MONO = Platform.OS === 'ios' ? 'Menlo' : 'monospace';

/** Prism-highlighted fenced code block with a language label + copy button. */
export function CodeBlock({
  code,
  language,
  colors,
  isDark,
}: {
  code: string;
  language?: string;
  colors: any;
  isDark: boolean;
}) {
  const [copied, setCopied] = useState(false);
  const tokens = useMemo(() => tokenizeCode(code, language), [code, language]);

  const copy = () => {
    void Clipboard.setStringAsync(code);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  return (
    <View
      style={{
        backgroundColor: isDark ? '#18181b' : colors.muted,
        borderRadius: 12,
        borderWidth: 1,
        borderColor: colors.border,
        marginVertical: 6,
        overflow: 'hidden',
      }}
    >
      <View
        style={{
          flexDirection: 'row',
          alignItems: 'center',
          justifyContent: 'space-between',
          paddingHorizontal: 12,
          paddingVertical: 6,
          borderBottomWidth: 1,
          borderBottomColor: colors.border,
        }}
      >
        <Text style={{ color: colors.mutedForeground, fontSize: 11, textTransform: 'capitalize' }}>
          {languageLabel(language)}
        </Text>
        <TouchableOpacity onPress={copy} hitSlop={8} style={{ flexDirection: 'row', alignItems: 'center', gap: 4 }}>
          {copied ? <Check size={13} color="#10b981" /> : <Copy size={13} color={colors.mutedForeground} />}
          <Text style={{ color: copied ? '#10b981' : colors.mutedForeground, fontSize: 11 }}>
            {copied ? 'Copied' : 'Copy'}
          </Text>
        </TouchableOpacity>
      </View>
      <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={{ paddingHorizontal: 12, paddingVertical: 10 }}>
        <Text style={{ fontFamily: MONO, fontSize: 13, lineHeight: 21 }}>
          {tokens.map((tok, i) => {
            const style = syntaxStyleFor(tok.types, isDark);
            return (
              <Text
                key={i}
                style={{ color: style.color, fontStyle: style.italic ? 'italic' : 'normal' }}
              >
                {tok.text}
              </Text>
            );
          })}
        </Text>
      </ScrollView>
    </View>
  );
}

/** Builds the react-native-markdown-display rule set used by the chat body. */
export function createMarkdownRules({
  colors,
  isDark,
  onOpenFile,
  renderText,
  renderFenceOverride,
}: {
  colors: any;
  isDark: boolean;
  onOpenFile?: (path: string) => void;
  renderText?: (node: any, children: any, parent: any, styles: any, inherited: any) => any;
  /** Mermaid etc. — return a node to take over, or null/undefined to fall back. */
  renderFenceOverride?: (node: any) => any;
}) {
  const renderFence = (node: any) => {
    const override = renderFenceOverride?.(node);
    if (override) return override;
    const lang = (node.sourceInfo ?? '').trim().split(/\s+/)[0];
    return <CodeBlock key={node.key} code={node.content ?? ''} language={lang} colors={colors} isDark={isDark} />;
  };

  return {
    fence: (node: any) => renderFence(node),
    code_block: (node: any) => renderFence(node),
    hr: (node: any) => (
      <View key={node.key} style={{ height: StyleSheet.hairlineWidth, backgroundColor: colors.border, marginVertical: 10 }} />
    ),
    blockquote: (node: any, children: any) => (
      <View
        key={node.key}
        style={{
          borderLeftWidth: 3,
          borderLeftColor: colors.primary,
          paddingLeft: 10,
          marginVertical: 4,
          opacity: 0.9,
        }}
      >
        {children}
      </View>
    ),
    link: (node: any, children: any, _parent: any, styles: any) => {
      const href = String(node.attributes?.href ?? '');
      const linkText = collectText(children);
      const fileRef = onOpenFile ? fileRefFromLink(href, linkText) : null;
      const onPress = () => {
        if (fileRef) onOpenFile?.(fileRef);
        else if (/^(https?:|mailto:|tel:|data:)/i.test(href)) Linking.openURL(href).catch(() => {});
      };
      return (
        <Text key={node.key} style={[styles?.link ?? {}, { color: colors.primary }]} onPress={onPress}>
          {children}
        </Text>
      );
    },
    table: (node: any, children: any) => (
      <ScrollView
        key={node.key}
        horizontal
        showsHorizontalScrollIndicator={false}
        style={{ marginVertical: 6, borderWidth: 1, borderColor: colors.border, borderRadius: 8 }}
      >
        <View>{children}</View>
      </ScrollView>
    ),
    thead: (node: any, children: any) => (
      <View key={node.key} style={{ backgroundColor: colors.muted }}>
        {children}
      </View>
    ),
    th: (node: any, children: any) => (
      <View key={node.key} style={{ paddingHorizontal: 12, paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: colors.border, minWidth: 90 }}>
        <Text style={{ color: colors.foreground, fontSize: 13, fontWeight: '600' }}>{children}</Text>
      </View>
    ),
    td: (node: any, children: any) => (
      <View key={node.key} style={{ paddingHorizontal: 12, paddingVertical: 8, borderBottomWidth: 1, borderBottomColor: colors.border, minWidth: 90 }}>
        <Text style={{ color: colors.foreground, fontSize: 13 }}>{children}</Text>
      </View>
    ),
    ...(renderText ? { text: renderText } : {}),
  };
}

const collectText = (children: any): string => {
  if (children == null) return '';
  if (typeof children === 'string') return children;
  if (Array.isArray(children)) return children.map(collectText).join('');
  if (typeof children === 'object' && children.props) return collectText(children.props.children);
  return '';
};

/** Collapsible "Reasoning" block (web Reasoning accordion). */
export function ReasoningBlock({
  text,
  colors,
  title = 'Thinking',
  defaultOpen = false,
  query = '',
}: {
  text: string;
  colors: any;
  title?: string;
  defaultOpen?: boolean;
  query?: string;
}) {
  const [open, setOpen] = useState(defaultOpen);
  return (
    <View style={{ marginBottom: 8, borderWidth: 1, borderColor: colors.border, borderRadius: 8, overflow: 'hidden', backgroundColor: colors.card }}>
      <TouchableOpacity onPress={() => setOpen((v) => !v)} style={{ flexDirection: 'row', alignItems: 'center', gap: 6, paddingHorizontal: 10, paddingVertical: 8 }}>
        {open ? <ChevronDown size={14} color={colors.mutedForeground} /> : <ChevronRight size={14} color={colors.mutedForeground} />}
        <Text style={{ color: colors.mutedForeground, fontSize: 12, fontWeight: '600' }}>{title}</Text>
      </TouchableOpacity>
      {open && (
        <View style={{ paddingHorizontal: 12, paddingBottom: 10 }}>
          <HighlightText
            text={text}
            query={query}
            style={{ color: colors.mutedForeground, fontSize: 13, fontStyle: 'italic', lineHeight: 19 }}
          />
        </View>
      )}
    </View>
  );
}

/** Pretty-printed JSON response card. */
export function JsonCard({ formatted, colors, label = 'JSON' }: { formatted: string; colors: any; label?: string }) {
  return (
    <View style={{ borderWidth: 1, borderColor: colors.border, borderRadius: 8, backgroundColor: colors.card, marginVertical: 4, overflow: 'hidden' }}>
      <Text style={{ color: colors.mutedForeground, fontSize: 10, textTransform: 'uppercase', letterSpacing: 0.5, paddingHorizontal: 10, paddingTop: 8 }}>
        {label}
      </Text>
      <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={{ padding: 10 }}>
        <Text style={{ fontFamily: MONO, fontSize: 12, color: colors.foreground }}>{formatted}</Text>
      </ScrollView>
    </View>
  );
}

/** CLI-style interactive prompt (`❯ 1. Yes`). */
export function InteractivePromptCard({ prompt, colors }: { prompt: ParsedInteractivePrompt; colors: any }) {
  return (
    <View style={{ borderWidth: 1, borderColor: colors.primary, borderRadius: 8, backgroundColor: colors.card, padding: 10, marginBottom: 8 }}>
      <Text style={{ color: colors.primary, fontSize: 10, fontWeight: '700', textTransform: 'uppercase', marginBottom: 4 }}>
        Waiting for input
      </Text>
      {!!prompt.questionLine && (
        <Text style={{ color: colors.foreground, fontSize: 14, marginBottom: 6 }}>{prompt.questionLine}</Text>
      )}
      {prompt.options.map((opt) => (
        <View key={opt.number} style={{ flexDirection: 'row', gap: 6, paddingVertical: 2 }}>
          <Text style={{ color: opt.isSelected ? colors.primary : colors.mutedForeground, fontSize: 13, fontFamily: MONO }}>
            {opt.isSelected ? '❯' : ' '} {opt.number}.
          </Text>
          <Text style={{ color: colors.foreground, fontSize: 13, flex: 1 }}>{opt.text}</Text>
        </View>
      ))}
    </View>
  );
}

/** Compact background-task notification row. */
export function TaskNotificationRow({
  notification,
  timestamp,
  colors,
}: {
  notification: ParsedTaskNotification;
  timestamp?: number;
  colors: any;
}) {
  const failed = /fail|error/i.test(notification.status);
  const time = formatMessageTime(timestamp);
  return (
    <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8, paddingVertical: 4, marginBottom: 6 }}>
      <View style={{ width: 8, height: 8, borderRadius: 4, backgroundColor: failed ? '#f59e0b' : '#10b981' }} />
      <Text style={{ color: colors.mutedForeground, fontSize: 12, flex: 1 }} numberOfLines={1}>
        {notification.summary}
      </Text>
      {time ? <Text style={{ color: colors.mutedForeground, fontSize: 11 }}>{time}</Text> : null}
    </View>
  );
}

const fileIcon = (name: string) => {
  const ext = (name.split('.').pop() ?? '').toLowerCase();
  if (['zip', 'tar', 'gz', 'rar', '7z'].includes(ext)) return Archive;
  if (['js', 'ts', 'tsx', 'jsx', 'py', 'go', 'rs', 'java', 'c', 'cpp', 'json', 'yml', 'yaml', 'sh', 'html', 'css'].includes(ext)) return FileCode;
  if (['txt', 'md', 'log', 'csv'].includes(ext)) return FileText;
  return FileIcon;
};

/** Image thumbnail that opens a full-screen lightbox on tap. */
export function MessageImage({
  uri,
  name,
  headers,
  colors,
}: {
  uri: string;
  name?: string;
  headers?: Record<string, string>;
  colors: any;
}) {
  const [open, setOpen] = useState(false);
  const [failed, setFailed] = useState(false);
  return (
    <>
      <TouchableOpacity activeOpacity={0.85} onPress={() => setOpen(true)}>
        <View style={{ width: 220, height: 160, borderRadius: 10, marginBottom: 6, backgroundColor: colors.muted, overflow: 'hidden', alignItems: 'center', justifyContent: 'center' }}>
          {failed ? (
            <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>{name ?? 'image'}</Text>
          ) : (
            <Image
              source={{ uri, headers }}
              style={{ width: '100%', height: '100%' }}
              resizeMode="cover"
              onError={() => setFailed(true)}
            />
          )}
        </View>
      </TouchableOpacity>
      <Modal visible={open} transparent animationType="fade" onRequestClose={() => setOpen(false)}>
        <Pressable style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.92)', alignItems: 'center', justifyContent: 'center' }} onPress={() => setOpen(false)}>
          <Image source={{ uri, headers }} style={{ width: '100%', height: '80%' }} resizeMode="contain" />
          <TouchableOpacity onPress={() => setOpen(false)} style={{ position: 'absolute', top: 48, right: 16, padding: 10 }}>
            <X size={24} color="#fff" />
          </TouchableOpacity>
        </Pressable>
      </Modal>
    </>
  );
}

/** File attachment card; tap opens the asset in the system browser. */
export function MessageFileCard({
  name,
  size,
  url,
  colors,
  light = false,
}: {
  name: string;
  size?: number;
  url?: string;
  colors: any;
  light?: boolean;
}) {
  const Icon = fileIcon(name);
  const tint = light ? colors.primaryForeground : colors.foreground;
  const sub = light ? colors.primaryForeground : colors.mutedForeground;
  return (
    <TouchableOpacity
      disabled={!url}
      activeOpacity={0.8}
      // ponytail: open in the system browser instead of pulling in expo-file-system/sharing
      onPress={() => url && Linking.openURL(url).catch(() => {})}
      style={{
        flexDirection: 'row',
        alignItems: 'center',
        gap: 8,
        borderWidth: 1,
        borderColor: light ? 'transparent' : colors.border,
        backgroundColor: light ? 'rgba(255,255,255,0.15)' : colors.card,
        borderRadius: 8,
        paddingHorizontal: 10,
        paddingVertical: 8,
        marginBottom: 4,
      }}
    >
      <Icon size={16} color={tint} />
      <Text style={{ color: tint, fontSize: 12, flex: 1 }} numberOfLines={1}>
        {name}
      </Text>
      {typeof size === 'number' && size > 0 ? (
        <Text style={{ color: sub, fontSize: 11 }}>{formatFileSize(size)}</Text>
      ) : null}
    </TouchableOpacity>
  );
}

/** Small role avatar shown above ungrouped messages. */
export function MessageAvatar({ role, label, colors }: { role: string; label: string; colors: any }) {
  const isUser = role === 'user';
  const initial = isUser ? 'U' : (label.trim().charAt(0) || 'A').toUpperCase();
  return (
    <View
      style={{
        width: 22,
        height: 22,
        borderRadius: 11,
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: isUser ? colors.primary : colors.muted,
      }}
    >
      <Text style={{ color: isUser ? colors.primaryForeground : colors.foreground, fontSize: 11, fontWeight: '700' }}>
        {initial}
      </Text>
    </View>
  );
}

/** `▣ provider · latency · time` footer under assistant turns. */
export function AssistantFooter({
  providerLabel,
  latencySeconds,
  timestamp,
  colors,
  align = 'left',
}: {
  providerLabel: string;
  latencySeconds?: number | null;
  timestamp?: number;
  colors: any;
  align?: 'left' | 'right';
}) {
  const time = formatMessageTime(timestamp);
  const bits = [providerLabel, latencySeconds != null ? formatTurnLatency(latencySeconds) : null, time].filter(Boolean);
  if (bits.length === 0) return null;
  return (
    <View style={{ flexDirection: 'row', justifyContent: align === 'right' ? 'flex-end' : 'flex-start', marginTop: 2 }}>
      <Text style={{ color: colors.mutedForeground, fontSize: 10 }}>▣ {bits.join(' · ')}</Text>
    </View>
  );
}
