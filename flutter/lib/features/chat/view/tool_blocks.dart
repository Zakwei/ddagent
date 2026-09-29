import 'dart:convert';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_markdown.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:flutter/material.dart';

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
        return _row(
          context,
          cs,
          icon: Icons.map_outlined,
          label:
              input['plan']?.toString() ??
              input['title']?.toString() ??
              'Plan update',
        );
      case ToolDisplay.oneLine:
        return _row(
          context,
          cs,
          icon: _icon(n),
          label: _oneLineSummary(n, input),
        );
      case ToolDisplay.collapsible:
        break;
    }

    if (_subagentTools.contains(n)) {
      return _subagent(context, cs, input);
    }
    if (_fileTools.contains(n)) return _fileTool(context, cs, n, input);
    if (_bashTools.contains(n)) return _bashTool(context, cs, input);
    if (_searchTools.contains(n)) {
      return _row(
        context,
        cs,
        icon: _icon(n),
        label: _oneLineSummary(n, input),
      );
    }
    if (n == 'askuserquestion' || n == 'ask_user_question') {
      return _qaContent(context, cs, input);
    }
    return _default(context, cs, name, input);
  }

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

  IconData _icon(String n) => switch (n) {
    _ when _fileTools.contains(n) => Icons.description_outlined,
    _ when _bashTools.contains(n) => Icons.terminal,
    _ when _searchTools.contains(n) => Icons.search,
    _ => Icons.build_outlined,
  };

  /// `> • <label>` header shared by every tool row.
  Widget _header(BuildContext context, String label, {bool error = false}) {
    final c = context.appColors;
    final params = message.toolInput is Map
        ? (message.toolInput as Map).length
        : 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        spacing: AppSpacing.sm,
        children: [
          Text('>', style: TextStyle(fontSize: 12, color: c.mutedForeground)),
          Icon(
            Icons.circle,
            size: 7,
            color: error ? Theme.of(context).colorScheme.error : c.primary,
          ),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13, color: c.foreground),
            ),
          ),
          if (params > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
              decoration: BoxDecoration(
                border: Border.all(color: c.border),
                borderRadius: AppRadii.borderSm,
              ),
              child: Text(
                '$params params',
                style: TextStyle(fontSize: 10, color: c.mutedForeground),
              ),
            ),
        ],
      ),
    );
  }

  /// One-line tool row — `> • Ran npx, sleep … 2 params` (oc tool row).
  /// Rows with output expand in place; the web transcript never renders a
  /// second `result` line.
  Widget _row(
    BuildContext context,
    ColorScheme cs, {
    required IconData icon,
    required String label,
  }) {
    final row = _header(context, label, error: message.isError);
    return _ToolRow(
      error: message.isError,
      header: row,
      body: _resultBlock(cs),
    );
  }

  /// Tool output appended to a row's expanded body — the web transcript
  /// keeps the result inside the tool row instead of a second line.
  Widget _resultBlock(ColorScheme cs) {
    final content =
        message.toolResult?['content']?.toString() ?? message.content ?? '';
    if (content.trim().isEmpty) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, top: 4, bottom: 8),
        child: SelectableText(
          content,
          maxLines: 60,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'monospace',
            color: message.isError ? cs.error : null,
          ),
        ),
      ),
    );
  }

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
      error: message.isError,
      header: _header(context, '${_verb(n)} $path', error: message.isError),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: AppMarkdown(
                data: '```diff\n${diff ?? content ?? _json(input)}\n```',
              ),
            ),
          ),
          _resultBlock(cs),
        ],
      ),
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

  Widget _bashTool(
    BuildContext context,
    ColorScheme cs,
    Map<String, dynamic> input,
  ) {
    final cmd =
        input['command'] ?? input['cmd'] ?? input['script'] ?? _json(input);
    final exitCode = message.toolResult?['exitCode'] ?? message.exitCode;
    final failed = exitCode is num && exitCode != 0;
    return _ToolRow(
      error: failed,
      header: _header(context, _commandLabel('$cmd'), error: failed),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 24, bottom: 8),
              child: AppMarkdown(data: '```sh\n$cmd\n```'),
            ),
          ),
          _resultBlock(cs),
        ],
      ),
    );
  }

  /// `Ran <command>` — the web row prints the command line itself.
  String _commandLabel(String cmd) =>
      'Ran ${cmd.replaceAll(RegExp(r'\s+'), ' ').trim()}';

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
    error: message.isError,
    header: _header(context, name, error: message.isError),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 8),
            child: SelectableText(
              _json(input),
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
        ),
        _resultBlock(cs),
      ],
    ),
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

/// Compact tool row (oc parity): `> • <label> [n params]`, no chevron —
/// the whole row toggles the tool output, like the web transcript.
class _ToolRow extends StatefulWidget {
  const _ToolRow({
    required this.header,
    required this.body,
    this.error = false,
  });

  final Widget header;
  final Widget body;
  final bool error;

  @override
  State<_ToolRow> createState() => _ToolRowState();
}

class _ToolRowState extends State<_ToolRow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final hasBody = widget.body is! SizedBox;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: hasBody ? () => setState(() => _open = !_open) : null,
          child: widget.header,
        ),
        if (_open) widget.body,
      ],
    );
  }
}
