import 'dart:convert';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_markdown.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// T15 — tool blocks: per-tool renderers, display modes, grouping, and the
/// AskUserQuestion interactive panel. Port of the web `tools/` layer
/// (toolConfigs display modes + ContentRenderers + AskUserQuestionPanel),
/// pragmatic subset covering the tools our providers actually emit.

/// Display mode per tool — web `toolConfigs.ts` `type:` field.
enum ToolDisplay { hidden, oneLine, collapsible, plan }

const _hiddenTools = {
  'todo_write',
  'todowrite',
  'update_todos',
  'tasklist',
  'task_list',
};
const _planTools = {'exit_plan_mode', 'exitplanmode', 'plan'};
const _oneLineTools = {
  'read_file',
  'list_files',
  'glob',
  'grep',
  'search_files',
  'web_search',
  'websearch',
};
const _fileTools = {
  'read_file',
  'write_file',
  'edit_file',
  'create_file',
  'rename_file',
  'move_file',
  'delete_file',
  'update_file',
};
const _bashTools = {
  'bash',
  'execute_command',
  'run_command',
  'shell',
  'terminal',
};
const _searchTools = {
  'search_files',
  'grep',
  'glob',
  'list_files',
  'web_search',
  'websearch',
};
const _subagentTools = {'task', 'delegate', 'subagent', 'spawn_agent'};

String _norm(String? toolName) =>
    (toolName ?? '').toLowerCase().replaceAll(' ', '_');

/// opencode InlineTool glyphs — `OC_TOOL_ICONS` from `OneLineDisplay.tsx`.
/// Rendered as a 2ch accent-colored character in `.oc-tool-icon`.
String ocToolGlyph(String toolName) => switch (_norm(toolName)) {
  'bash' || 'execute_command' || 'run_command' || 'shell' || 'terminal' => r'$',
  'glob' || 'grep' || 'search_files' => '✱',
  'read_file' || 'read' || 'askuserquestion' || 'ask_user_question' => '→',
  'write_file' ||
  'edit_file' ||
  'create_file' ||
  'apply_patch' ||
  'applypatch' ||
  'update_file' => '←',
  'webfetch' || 'web_fetch' => '%',
  'web_search' || 'websearch' => '◈',
  _ => '⚙',
};

/// `ToolStatusBadge` status — web `ToolStatus` from `ToolStatusBadge.tsx`.
enum ToolStatus { running, completed, error, denied }

/// A tool_use row is `running` until its result lands, `error` when the
/// result/exit code flags failure, else `completed` — mirrors how the web
/// renderers feed `ToolStatusBadge`.
ToolStatus toolStatusFor(SessionMessage m) {
  final res = m.toolResult;
  final resExit = res?['exitCode'];
  final failed =
      m.isError ||
      (m.exitCode is num && m.exitCode != 0) ||
      (resExit is num && resExit != 0) ||
      res?['isError'] == true;
  if (failed) return ToolStatus.error;
  final content = res?['content']?.toString() ?? m.content;
  if (res == null && (content ?? '').isEmpty) return ToolStatus.running;
  return ToolStatus.completed;
}

/// `ToolStatusBadge` — rounded px-1.5 py-px text-[10px] badge, blue/green/
/// red/orange tones flipped per brightness like the web dark: classes.
class ToolStatusBadge extends StatelessWidget {
  const ToolStatusBadge({required this.status, super.key});

  final ToolStatus status;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final (bg, fg, label) = switch (status) {
      ToolStatus.running =>
        dark
            ? (
                const Color(0xFF1E3A8A).withValues(alpha: 0.3),
                const Color(0xFF93C5FD),
                'Running',
              )
            : (const Color(0xFFDBEAFE), const Color(0xFF1D4ED8), 'Running'),
      ToolStatus.completed =>
        dark
            ? (
                const Color(0xFF14532D).withValues(alpha: 0.3),
                const Color(0xFF86EFAC),
                'Completed',
              )
            : (const Color(0xFFDCFCE7), const Color(0xFF15803D), 'Completed'),
      ToolStatus.error =>
        dark
            ? (
                const Color(0xFF7F1D1D).withValues(alpha: 0.3),
                const Color(0xFFFCA5A5),
                'Error',
              )
            : (const Color(0xFFFEE2E2), const Color(0xFFB91C1C), 'Error'),
      ToolStatus.denied =>
        dark
            ? (
                const Color(0xFF7C2D12).withValues(alpha: 0.3),
                const Color(0xFFFDBA74),
                'Denied',
              )
            : (const Color(0xFFFFEDD5), const Color(0xFFC2410C), 'Denied'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: fg),
      ),
    );
  }
}

/// `CollapsibleOutput` — mono 12px pre, collapsed to 12 lines / 400 chars,
/// `Show N more lines` / `Show less` toggle.
class ToolOutputPreview extends StatefulWidget {
  const ToolOutputPreview({
    required this.content,
    this.isError = false,
    super.key,
  });

  final String content;
  final bool isError;

  @override
  State<ToolOutputPreview> createState() => _ToolOutputPreviewState();
}

class _ToolOutputPreviewState extends State<ToolOutputPreview> {
  static const _maxLines = 12;
  static const _maxChars = 400;

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final content = widget.content;
    final lines = content.split('\n');
    final isLong = lines.length > _maxLines || content.length > _maxChars;
    final displayed = !isLong || _expanded
        ? content
        : lines.length > _maxLines
        ? lines.sublist(0, _maxLines).join('\n')
        : '${content.substring(0, _maxChars)}…';
    final remaining = lines.length - _maxLines;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SelectableText(
          displayed,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'monospace',
            height: 1.4,
            color: widget.isError
                ? Theme.of(context).colorScheme.error
                : c.mutedForeground,
          ),
        ),
        if (isLong)
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: c.border.withValues(alpha: 0.4)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 6,
                children: [
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 14,
                    color: c.mutedForeground,
                  ),
                  Text(
                    _expanded
                        ? 'Show less'
                        : remaining > 0
                        ? 'Show $remaining more lines'
                        : 'Show more',
                    style: TextStyle(fontSize: 12, color: c.mutedForeground),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

ToolDisplay toolDisplayMode(String? toolName) {
  final n = _norm(toolName);
  if (_hiddenTools.contains(n)) return ToolDisplay.hidden;
  if (_planTools.contains(n)) return ToolDisplay.plan;
  if (_oneLineTools.contains(n)) return ToolDisplay.oneLine;
  return ToolDisplay.collapsible;
}

/// A collapsed run of consecutive tool rows (T15.11, port of toolGrouping).
class ToolGroup {
  ToolGroup(this.messages);
  final List<SessionMessage> messages;
}

/// Result of [groupToolRuns]: display rows (messages or [ToolGroup]) plus the
/// subagent-children index keyed by parent `toolId` (T15.8).
class GroupedTranscript {
  GroupedTranscript(this.rows, this.children);
  final List<Object> rows; // SessionMessage | ToolGroup
  final Map<String, List<SessionMessage>> children;
}

/// Group consecutive tool_use/tool_result rows (≥3) into one collapsible
/// block, and nest subagent children under their parent tool: messages
/// carrying `parentToolUseId` matching a parent's `toolId` are attached to
/// that parent instead of rendered as top-level rows.
GroupedTranscript groupToolRuns(List<SessionMessage> messages) {
  final byToolId = <String, SessionMessage>{
    for (final m in messages)
      if (m.kind == 'tool_use' && m.toolId != null) m.toolId!: m,
  };
  final children = <String, List<SessionMessage>>{};
  final top = <SessionMessage>[];
  for (final m in messages) {
    final p = m.parentToolUseId;
    if (p != null && byToolId.containsKey(p)) {
      (children[p] ??= []).add(m);
    } else {
      top.add(m);
    }
  }
  final rows = <Object>[];
  var i = 0;
  while (i < top.length) {
    if (!_isToolRow(top[i].kind)) {
      rows.add(top[i]);
      i++;
      continue;
    }
    var j = i;
    // thinking/thought_delta rows are display-hidden mid-run — don't split.
    while (j < top.length &&
        (_isToolRow(top[j].kind) || _isThinking(top[j].kind))) {
      j++;
    }
    // Emit in order: consecutive groupable tool rows collapse when >=3.
    // Ungroupable tools (file edits, subagent parents) are hard boundaries —
    // they flush the pending run and stay as their own row. Thinking rows
    // don't break run continuity: emitted in place, pending keeps growing.
    var pending = <SessionMessage>[];
    void flush() {
      if (pending.length >= 3) {
        rows.add(ToolGroup(pending));
      } else {
        rows.addAll(pending);
      }
      pending = <SessionMessage>[];
    }

    for (final m in top.sublist(i, j)) {
      if (_isThinking(m.kind)) {
        rows.add(m);
      } else if (_groupable(m, children)) {
        pending.add(m);
      } else {
        flush();
        rows.add(m);
      }
    }
    flush();
    i = j;
  }
  return GroupedTranscript(rows, children);
}

bool _isToolRow(String kind) => kind == 'tool_use' || kind == 'tool_result';

bool _isThinking(String kind) => kind == 'thinking' || kind == 'thought_delta';

/// Edits are the highest-signal rows for review — web UNGROUPABLE_TOOL_NAMES.
const _ungroupableTools = {
  'edit_file',
  'write_file',
  'create_file',
  'update_file',
  'apply_patch',
  'delete_file',
  'rename_file',
  'move_file',
};

/// Caller pre-filters to tool rows. File edits stay visible (highest-signal
/// for review — web UNGROUPABLE_TOOL_NAMES); subagent parents render their
/// own nested timeline so they can't be group members either.
bool _groupable(SessionMessage m, Map<String, List<SessionMessage>> children) {
  if (_ungroupableTools.contains(_norm(m.toolName))) return false;
  if (m.toolId != null && children.containsKey(m.toolId)) return false;
  return true;
}

// ---------------------------------------------------------------------------
// Per-tool renderers (T15.1/2)

class ToolUseTile extends StatelessWidget {
  const ToolUseTile({
    required this.message,
    required this.childrenMap,
    super.key,
  });

  final SessionMessage message;
  final Map<String, List<SessionMessage>> childrenMap;

  List<SessionMessage> get children => message.toolId == null
      ? const []
      : childrenMap[message.toolId] ?? const [];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final name = message.toolName ?? 'tool';
    final n = _norm(name);
    final input = message.toolInput is Map
        ? Map<String, dynamic>.from(message.toolInput as Map)
        : message.toolInput != null
        ? {'input': message.toolInput}
        : <String, dynamic>{};

    switch (toolDisplayMode(name)) {
      case ToolDisplay.hidden:
        return const SizedBox.shrink();
      case ToolDisplay.plan:
        return _ToolRow(
          message: message,
          glyph: '⚙',
          label:
              input['plan']?.toString() ??
              input['title']?.toString() ??
              'Plan update',
          output: _resultText(),
        );
      case ToolDisplay.oneLine:
        return _ToolRow(
          message: message,
          glyph: ocToolGlyph(name),
          label: _oneLineSummary(n, input),
          output: _resultText(),
        );
      case ToolDisplay.collapsible:
        break;
    }

    if (_subagentTools.contains(n)) {
      return _subagent(context, cs, input);
    }
    if (_fileTools.contains(n)) return _fileTool(context, cs, n, input);
    // Providers label shell calls with their own names ("Ran grep, curl")
    // but still pass a `command` input — render those as bash rows.
    if (_bashTools.contains(n) || _looksLikeCommand(input)) {
      return _bashTool(context, cs, input);
    }
    if (_searchTools.contains(n)) {
      return _ToolRow(
        message: message,
        glyph: ocToolGlyph(name),
        label: _oneLineSummary(n, input),
        output: _resultText(),
      );
    }
    if (n == 'askuserquestion' || n == 'ask_user_question') {
      return _qaContent(context, cs, input);
    }
    return _default(context, cs, name, input);
  }

  /// Tool output text — the web transcript folds it into the tool row
  /// instead of a second `result` line.
  String _resultText() =>
      message.toolResult?['content']?.toString() ?? message.content ?? '';

  String _oneLineSummary(String n, Map<String, dynamic> input) {
    final path =
        input['path'] ??
        input['file_path'] ??
        input['filePath'] ??
        input['pattern'];
    final query = input['query'] ?? input['pattern'] ?? input['path'];
    return switch (n) {
      'read_file' => 'Read ${path ?? ''}',
      'list_files' => 'List ${path ?? '.'}',
      'grep' ||
      'search_files' => 'Search ${input['pattern'] ?? input['query'] ?? ''}',
      'glob' => 'Glob ${path ?? ''}',
      'web_search' || 'websearch' => 'Web: $query',
      _ => query?.toString() ?? path?.toString() ?? '',
    };
  }

  /// `.oc-tool-block` — file tools (Write/Edit/…): square panel block with
  /// a 3px `--oc-bg` left border; the diff expands under the title.
  Widget _fileTool(
    BuildContext context,
    ColorScheme cs,
    String n,
    Map<String, dynamic> input,
  ) {
    final path = input['path'] ?? input['file_path'] ?? input['filePath'] ?? '';
    final diff = input['diff']?.toString() ?? input['edits']?.toString();
    final content =
        input['content']?.toString() ?? input['new_content']?.toString();
    return _ToolRow(
      message: message,
      glyph: ocToolGlyph(n),
      label: '${_verb(n)} $path',
      copyText: '$path',
      extras: [
        AppMarkdown(data: '```diff\n${diff ?? content ?? _json(input)}\n```'),
      ],
      output: _resultText(),
      block: true,
    );
  }

  String _verb(String n) => switch (n) {
    'read_file' => 'read',
    'write_file' || 'create_file' || 'update_file' => 'write',
    'edit_file' => 'edit',
    'delete_file' => 'delete',
    'rename_file' || 'move_file' => 'move',
    _ => n,
  };

  /// `BashCommandDisplay` — always a rounded card: chevron + emerald `$` +
  /// command + status/lines, expanding to the combined stdout/stderr.
  Widget _bashTool(
    BuildContext context,
    ColorScheme cs,
    Map<String, dynamic> input,
  ) {
    final cmd =
        '${input['command'] ?? input['cmd'] ?? input['script'] ?? _json(input)}';
    final description = input['description']?.toString();
    return _ToolRow(
      message: message,
      glyph: r'$',
      label: _commandLabel(cmd),
      copyText: cmd,
      extras: [
        if (description != null && description.isNotEmpty)
          Text(
            description,
            style: TextStyle(
              fontSize: 11,
              fontStyle: FontStyle.italic,
              color: context.appColors.mutedForeground,
            ),
          ),
      ],
      output: _resultText(),
      alwaysCard: true,
    );
  }

  /// A shell tool by payload, whatever the provider named it.
  bool _looksLikeCommand(Map<String, dynamic> input) =>
      input['command'] != null ||
      input['cmd'] != null ||
      input['script'] != null;

  /// Web row label: the tool name followed by the command line.
  String _commandLabel(String cmd) =>
      cmd.replaceAll(RegExp(r'\s+'), ' ').trim();

  Widget _subagent(
    BuildContext context,
    ColorScheme cs,
    Map<String, dynamic> input,
  ) {
    final label =
        input['description'] ?? input['prompt'] ?? input['task'] ?? 'Subagent';
    return ExpansionTile(
      dense: true,
      tilePadding: EdgeInsets.zero,
      leading: const Icon(Icons.account_tree_outlined, size: 18),
      title: Text(
        label is String ? label : '$label',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13),
      ),
      subtitle: children.isEmpty
          ? null
          : Text(
              '${children.length} tool${children.length == 1 ? '' : 's'}',
              style: TextStyle(fontSize: 11, color: cs.outline),
            ),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final c in children)
                c.kind == 'tool_use'
                    ? ToolUseTile(message: c, childrenMap: childrenMap)
                    : ToolResultTile(message: c),
            ],
          ),
        ),
      ],
    );
  }

  Widget _qaContent(
    BuildContext context,
    ColorScheme cs,
    Map<String, dynamic> input,
  ) {
    final questions = input['questions'] is List
        ? input['questions'] as List
        : const <dynamic>[];
    final answers = input['answers'] is Map
        ? input['answers'] as Map
        : const <dynamic, dynamic>{};
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final q in questions)
          if (q is Map)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    q['header']?.toString() ??
                        q['question']?.toString() ??
                        'Question',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  if (q['question'] != null)
                    Text(
                      q['question'].toString(),
                      style: TextStyle(fontSize: 12, color: cs.outline),
                    ),
                  if (answers[q['question']] != null)
                    Text(
                      '→ ${answers[q['question']]}',
                      style: TextStyle(fontSize: 12, color: cs.primary),
                    ),
                ],
              ),
            ),
      ],
    );
  }

  Widget _default(
    BuildContext context,
    ColorScheme cs,
    String name,
    Map<String, dynamic> input,
  ) => _ToolRow(
    message: message,
    glyph: ocToolGlyph(name),
    label: name,
    copyText: _json(input),
    extras: [
      SelectableText(
        _json(input),
        style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
      ),
    ],
    output: _resultText(),
  );

  String _json(Map<String, dynamic> input) =>
      input.isEmpty ? '{}' : const JsonEncoder.withIndent('  ').convert(input);
}

class ToolResultTile extends StatelessWidget {
  const ToolResultTile({required this.message, super.key});

  final SessionMessage message;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final content =
        message.toolResult?['content']?.toString() ?? message.content ?? '';
    return ExpansionTile(
      dense: true,
      tilePadding: EdgeInsets.zero,
      leading: Icon(
        message.isError ? Icons.error_outline : Icons.check_circle_outline,
        size: 18,
        color: message.isError ? cs.error : cs.outline,
      ),
      title: Text(
        message.toolName ?? 'result',
        style: TextStyle(
          fontSize: 12,
          color: message.isError ? cs.error : cs.outline,
        ),
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 8),
            child: SelectableText(
              content,
              maxLines: 40,
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
        ),
      ],
    );
  }
}

/// Collapsed run of tool rows (T15.11).
class ToolGroupTile extends StatelessWidget {
  const ToolGroupTile({
    required this.group,
    required this.tileBuilder,
    super.key,
  });

  final ToolGroup group;
  final Widget Function(SessionMessage) tileBuilder;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasError = group.messages.any((m) => m.isError);
    return ExpansionTile(
      dense: true,
      tilePadding: EdgeInsets.zero,
      leading: Icon(
        hasError ? Icons.error_outline : Icons.account_tree_outlined,
        size: 16,
        color: hasError ? cs.error : cs.outline,
      ),
      title: Text(
        '${group.messages.length} tool calls',
        style: TextStyle(fontSize: 12, color: cs.outline),
      ),
      children: [for (final m in group.messages) tileBuilder(m)],
    );
  }
}

// ---------------------------------------------------------------------------
// AskUserQuestion interactive panel (T15.3/9) — port of AskUserQuestionPanel.

class AskUserQuestionPanel extends StatefulWidget {
  const AskUserQuestionPanel({
    required this.requestId,
    required this.input,
    required this.onDecision,
    super.key,
  });

  final String requestId;
  final Map<String, dynamic> input;

  /// `decision(allow, updatedInput)` — mirrors web `onDecision`.
  final void Function(bool allow, Map<String, dynamic> updatedInput) onDecision;

  @override
  State<AskUserQuestionPanel> createState() => _AskUserQuestionPanelState();
}

class _AskUserQuestionPanelState extends State<AskUserQuestionPanel> {
  int _step = 0;
  final _selections = <int, Set<String>>{};
  final _otherText = <int, TextEditingController>{};
  final _otherActive = <int, bool>{};

  List<Map<String, dynamic>> get _questions => [
    for (final q in widget.input['questions'] as List? ?? const [])
      if (q is Map) Map<String, dynamic>.from(q),
  ];

  Map<String, dynamic> _answers() {
    final out = <String, dynamic>{};
    for (var i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final sel = <String>{...?_selections[i]};
      if (_otherActive[i] == true &&
          (_otherText[i]?.text.trim().isNotEmpty ?? false)) {
        sel.add(_otherText[i]!.text.trim());
      }
      if (sel.isNotEmpty) {
        out[q['question']?.toString() ?? 'q$i'] = sel.join(', ');
      }
    }
    return out;
  }

  @override
  void dispose() {
    for (final c in _otherText.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final qs = _questions;
    if (qs.isEmpty) return const SizedBox.shrink();
    final q = qs[_step];
    final options = [
      for (final o in q['options'] as List? ?? const [])
        if (o is Map)
          o['label']?.toString() ?? o['text']?.toString() ?? '$o'
        else
          '$o',
    ];
    final multi = q['multiSelect'] == true;
    final selected = _selections[_step] ??= {};

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.help_outline, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  q['header']?.toString() ??
                      'Question ${_step + 1}/${qs.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
              if (qs.length > 1)
                Text(
                  '${_step + 1}/${qs.length}',
                  style: TextStyle(fontSize: 11, color: cs.outline),
                ),
            ],
          ),
          if (q['question'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(q['question'].toString()),
            ),
          const SizedBox(height: 8),
          for (final o in options)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () => setState(() {
                  if (multi) {
                    selected.contains(o) ? selected.remove(o) : selected.add(o);
                  } else {
                    selected
                      ..clear()
                      ..add(o);
                  }
                }),
                child: Row(
                  children: [
                    Icon(
                      multi
                          ? (selected.contains(o)
                                ? Icons.check_box
                                : Icons.check_box_outline_blank)
                          : (selected.contains(o)
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off),
                      size: 18,
                      color: selected.contains(o) ? cs.primary : cs.outline,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(o, style: const TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),
          _otherField(cs, selected),
          const SizedBox(height: 8),
          Row(
            children: [
              if (_step > 0)
                TextButton(
                  onPressed: () => setState(() => _step--),
                  child: const Text('Back'),
                ),
              const Spacer(),
              TextButton(
                onPressed: () => widget.onDecision(true, {
                  ...widget.input,
                  'answers': <String, dynamic>{},
                }),
                child: const Text('Skip'),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _step < qs.length - 1
                    ? () => setState(() => _step++)
                    : () => widget.onDecision(true, {
                        ...widget.input,
                        'answers': _answers(),
                      }),
                child: Text(_step < qs.length - 1 ? 'Next' : 'Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _otherField(ColorScheme cs, Set<String> selected) {
    final active = _otherActive[_step] == true;
    if (!active) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () => setState(() {
            _otherActive[_step] = true;
            _otherText[_step] ??= TextEditingController();
          }),
          child: Row(
            children: [
              const Icon(Icons.radio_button_off, size: 18),
              const SizedBox(width: 6),
              Text('Other…', style: TextStyle(fontSize: 13, color: cs.outline)),
            ],
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 4, left: 24),
      child: TextField(
        controller: _otherText[_step],
        autofocus: true,
        style: const TextStyle(fontSize: 13),
        decoration: const InputDecoration(
          isDense: true,
          hintText: 'Type your answer…',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}

/// Tool row shell — `.oc-tool-row` bare line when there is nothing to
/// expand; a `rounded-lg border bg-muted/40` card once it carries output
/// (OneLineDisplay) or always for shell calls (BashCommandDisplay), and the
/// square `.oc-tool-block` for file edits.
class _ToolRow extends StatefulWidget {
  const _ToolRow({
    required this.message,
    required this.glyph,
    required this.label,
    this.output = '',
    this.extras = const [],
    this.copyText,
    this.alwaysCard = false,
    this.block = false,
  });

  final SessionMessage message;
  final String glyph;
  final String label;

  /// Combined stdout/stderr — drives the line counter and the expanded
  /// `ToolOutputPreview`.
  final String output;

  /// Content pinned inside the expanded body above the output (diff/json).
  final List<Widget> extras;
  final String? copyText;

  /// BashCommandDisplay parity — a card even with no output yet.
  final bool alwaysCard;

  /// `.oc-tool-block` — square panel block, no radius.
  final bool block;

  @override
  State<_ToolRow> createState() => _ToolRowState();
}

class _ToolRowState extends State<_ToolRow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final cs = Theme.of(context).colorScheme;
    final status = toolStatusFor(widget.message);
    final error = status == ToolStatus.error;
    final output = widget.output.trim();
    final hasOutput = output.isNotEmpty;
    final hasBody = widget.extras.isNotEmpty || hasOutput;
    final lineCount = hasOutput ? output.split('\n').length : 0;
    final bash = widget.glyph == r'$';

    final header = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        spacing: 6,
        children: [
          // Chevron rotates 90° when open; invisible without a body.
          AnimatedRotation(
            turns: _open ? 0.25 : 0,
            duration: AppMotion.base,
            child: Icon(
              Icons.chevron_right,
              size: 14,
              color: hasBody
                  ? c.mutedForeground
                  : c.mutedForeground.withValues(alpha: 0),
            ),
          ),
          // `.oc-tool-icon` — 2ch glyph; emerald `$` for shell rows.
          Text(
            widget.glyph,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bash ? FontWeight.w600 : FontWeight.w400,
              fontFamily: 'monospace',
              color: bash
                  ? (Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF34D399)
                        : const Color(0xFF10B981))
                  : c.primary,
            ),
          ),
          Expanded(
            // `.oc-tool-label` — ellipsis; failed rows strike through.
            child: Text(
              widget.label,
              maxLines: _open ? 8 : 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: error ? cs.error : c.foreground,
                decoration: error ? TextDecoration.lineThrough : null,
                decorationColor: cs.error,
              ),
            ),
          ),
          // BashCommandDisplay swaps the badge for a spinner; one-line
          // rows keep the `Running` badge.
          if (status == ToolStatus.running && bash)
            SizedBox.square(
              dimension: 10,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: c.mutedForeground,
              ),
            )
          else
            ToolStatusBadge(status: status),
          if (hasOutput && !_open)
            Text(
              '$lineCount ${lineCount == 1 ? 'line' : 'lines'}',
              style: TextStyle(
                fontSize: 10,
                color: c.mutedForeground,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          if (widget.copyText != null)
            GestureDetector(
              onTap: () =>
                  Clipboard.setData(ClipboardData(text: widget.copyText!)),
              child: Icon(
                Icons.copy_outlined,
                size: 12,
                color: c.mutedForeground,
              ),
            ),
        ],
      ),
    );

    final body = !hasBody
        ? null
        : Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: c.border.withValues(alpha: 0.5)),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                ...widget.extras,
                if (hasOutput)
                  ToolOutputPreview(content: output, isError: error),
              ],
            ),
          );

    // `.oc-tool-row` — bare baseline row, nothing to expand.
    if (!widget.alwaysCard && !widget.block && !hasBody) {
      return Padding(
        padding: const EdgeInsets.only(left: 12, top: 3),
        child: header,
      );
    }

    final decoration = widget.block
        // `.oc-tool-block` — square, panel bg, left 3px --oc-bg border.
        ? BoxDecoration(
            color: c.card,
            border: Border(left: BorderSide(color: c.background, width: 3)),
          )
        : BoxDecoration(
            color: c.muted.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: error
                  ? cs.error.withValues(alpha: 0.3)
                  : c.border.withValues(alpha: 0.6),
            ),
          );

    return Container(
      margin: const EdgeInsets.only(top: 6),
      decoration: decoration,
      clipBehavior: widget.block ? Clip.none : Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: hasBody ? () => setState(() => _open = !_open) : null,
            child: header,
          ),
          if (_open && body != null) body,
        ],
      ),
    );
  }
}
