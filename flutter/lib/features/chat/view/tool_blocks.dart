import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/utils/clipboard.dart';
import 'package:ddagent_app/core/widgets/app_markdown.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// T15 — tool blocks: per-tool renderers, display modes, grouping, and the
/// AskUserQuestion interactive panel. Port of the web `tools/` layer
/// (toolConfigs display modes + ContentRenderers + AskUserQuestionPanel),
/// pragmatic subset covering the tools our providers actually emit.

/// Display mode per tool — web `toolConfigs.ts` `type:` field.
enum ToolDisplay { hidden, oneLine, collapsible, plan }

const _hiddenTools = <String>{};

/// TodoWrite/update_todos — collapsible `TodoListContent` from input.todos.
const _todoWriteTools = {'todo_write', 'todowrite', 'update_todos'};

/// TodoRead — one-line input; result content is a JSON todos array.
const _todoReadTools = {'todo_read', 'todoread'};

/// TaskList/TaskGet — one-line input; result text parses into TaskList rows.
const _taskListTools = {'tasklist', 'task_list', 'taskget', 'task_get'};

/// TaskCreate/TaskUpdate — one-line input, result hidden on success.
const _taskWriteTools = {'taskcreate', 'task_create', 'taskupdate', 'task_update'};
const _planTools = {'exit_plan_mode', 'exitplanmode', 'plan', 'plan_review', 'planreview'};
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
const _bashTools = {'bash', 'execute_command', 'run_command', 'shell', 'terminal'};
const _searchTools = {'search_files', 'grep', 'glob', 'list_files', 'web_search', 'websearch'};
const _subagentTools = {'task', 'delegate', 'subagent', 'spawn_agent'};

String _norm(String? toolName) => (toolName ?? '').toLowerCase().replaceAll(' ', '_');

/// Canonical names the renderers below know about (runtime set — the source
/// buckets overlap, e.g. `read_file` is both one-line and a file tool).
final _knownTools = <String>{
  ..._hiddenTools,
  ..._todoWriteTools,
  ..._todoReadTools,
  ..._taskListTools,
  ..._taskWriteTools,
  ..._planTools,
  ..._oneLineTools,
  ..._fileTools,
  ..._bashTools,
  ..._searchTools,
  ..._subagentTools,
  'apply_patch',
  'applypatch',
  'askuserquestion',
  'read',
  'webfetch',
};

/// Web `resolveToolName` — provider titles carry the action in their leading
/// verb ("Edit file", "Wrote ./src/a.ts"); fold those onto the canonical tool
/// so the right renderer (file card vs one-line row) is picked. Names the
/// renderers don't know stay as they are, like the web's Default config.
String resolveToolName(String? toolName) {
  final name = (toolName ?? '').trim();
  if (name.isEmpty) return name;
  final n = _norm(name);
  if (_knownTools.contains(n)) return n;
  // Split the raw lowercased title — `_norm` folds spaces into underscores.
  return switch (name.toLowerCase().split(RegExp(r'\s+')).first) {
    'wrote' || 'write' || 'created' => 'write_file',
    'edited' || 'edit' => 'edit_file',
    'patched' => 'apply_patch',
    _ => name,
  };
}

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
            ? (const Color(0xFF1E3A8A).withValues(alpha: 0.3), const Color(0xFF93C5FD), 'Running')
            : (const Color(0xFFDBEAFE), const Color(0xFF1D4ED8), 'Running'),
      ToolStatus.completed =>
        dark
            ? (const Color(0xFF14532D).withValues(alpha: 0.3), const Color(0xFF86EFAC), 'Completed')
            : (const Color(0xFFDCFCE7), const Color(0xFF15803D), 'Completed'),
      ToolStatus.error =>
        dark
            ? (const Color(0xFF7F1D1D).withValues(alpha: 0.3), const Color(0xFFFCA5A5), 'Error')
            : (const Color(0xFFFEE2E2), const Color(0xFFB91C1C), 'Error'),
      ToolStatus.denied =>
        dark
            ? (const Color(0xFF7C2D12).withValues(alpha: 0.3), const Color(0xFFFDBA74), 'Denied')
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
  const ToolOutputPreview({required this.content, this.isError = false, super.key});

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
        Text(
          displayed,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'monospace',
            height: 1.55,
            color: widget.isError ? Theme.of(context).colorScheme.error : c.mutedForeground,
          ),
        ),
        if (isLong)
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: c.border.withValues(alpha: 0.4))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 6,
                children: [
                  Icon(
                    _expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
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

/// Web `toolConfigs` input labels — the group header names the repeated tool.
String ocToolLabel(String? toolName) => switch (_norm(toolName)) {
  'bash' || 'execute_command' || 'run_command' || 'shell' || 'terminal' => 'Bash',
  'read_file' || 'read' => 'Read',
  'write_file' || 'create_file' || 'update_file' => 'Write',
  'edit_file' => 'Edit',
  'apply_patch' || 'applypatch' => 'Apply Patch',
  'glob' => 'Glob',
  'grep' || 'search_files' => 'Grep',
  'list_files' => 'List',
  'web_search' || 'websearch' => 'Web Search',
  'webfetch' || 'web_fetch' => 'Web Fetch',
  'task' || 'delegate' || 'subagent' || 'spawn_agent' => 'Task',
  _ => (toolName ?? 'Tools').trim(),
};

/// `getToolInputPreview` (ToolGroupContainer.tsx) — one-line input preview for
/// the group header (command / path / pattern, in that order).
String toolGroupPreview(SessionMessage m) {
  final input = m.toolInput is Map
      ? Map<String, dynamic>.from(m.toolInput as Map)
      : <String, dynamic>{};
  final cmd = input['command'] ?? input['cmd'] ?? input['script'];
  if (cmd != null) {
    return cmd.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  }
  final path = input['path'] ?? input['file_path'] ?? input['filePath'];
  if (path != null) return path.toString();
  final pattern = input['pattern'] ?? input['query'];
  if (pattern != null) return pattern.toString();
  return (m.content ?? '').trim();
}

/// `deriveGroupStatus` — any tool without a result keeps the group running,
/// any error result flips it to error, else completed.
ToolStatus groupStatus(List<SessionMessage> messages) {
  if (messages.isEmpty) return ToolStatus.completed;
  if (messages.any((m) => m.kind == 'tool_use' && m.toolResult == null)) {
    return ToolStatus.running;
  }
  if (messages.any(
    (m) =>
        m.isError ||
        m.toolResult?['isError'] == true ||
        (m.toolResult?['exitCode'] is num && m.toolResult!['exitCode'] != 0),
  )) {
    return ToolStatus.error;
  }
  return ToolStatus.completed;
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
    while (j < top.length && (_isToolRow(top[j].kind) || _isThinking(top[j].kind))) {
      j++;
    }
    // Emit in order: consecutive groupable rows of ONE repeated tool collapse
    // when >=3 (web `groupConsecutiveTools` compares resolved tool names, so
    // a different tool closes the run). Ungroupable tools (file edits,
    // subagent parents) are hard boundaries — they flush the pending run and
    // stay as their own row. Thinking rows don't break run continuity:
    // emitted in place, pending keeps growing.
    var pending = <SessionMessage>[];
    String? pendingTool;
    void flush() {
      if (pending.where((m) => m.kind == 'tool_use').length >= 3) {
        rows.add(ToolGroup(pending));
      } else {
        rows.addAll(pending);
      }
      pending = <SessionMessage>[];
      pendingTool = null;
    }

    for (final m in top.sublist(i, j)) {
      if (_isThinking(m.kind)) {
        rows.add(m);
        continue;
      }
      if (!_groupable(m, children)) {
        flush();
        rows.add(m);
        continue;
      }
      // Result rows ride along with the run their tool opened.
      final tool = m.kind == 'tool_use' ? _norm(m.toolName) : pendingTool;
      if (pendingTool != null && tool != null && tool != pendingTool) {
        flush();
      }
      pendingTool ??= tool;
      pending.add(m);
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
  const ToolUseTile({required this.message, required this.childrenMap, this.onFileOpen, super.key});

  final SessionMessage message;
  final Map<String, List<SessionMessage>> childrenMap;

  /// Chat → in-pane editor open (web `onFileOpen` → `openFileInEditor`).
  /// File rows, file-list results and edit-tile titles call it.
  final void Function(String path)? onFileOpen;

  List<SessionMessage> get children =>
      message.toolId == null ? const [] : childrenMap[message.toolId] ?? const [];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final name = message.toolName ?? 'tool';
    final n = resolveToolName(name);
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
              (n == 'plan_review' ? 'Plan review' : 'Plan update'),
          output: _resultText(),
        );
      case ToolDisplay.oneLine:
        // Grep/Glob results carry `toolUseResult.filenames` — web
        // FileListContent renders them as clickable names opening the
        // editor instead of the raw path dump.
        final files = _searchTools.contains(n) ? _resultFilenames() : const <String>[];
        return _ToolRow(
          message: message,
          glyph: ocToolGlyph(name),
          label: _oneLineSummary(n, input),
          extras: [if (files.isNotEmpty) _FileListLinks(files: files, onFileOpen: onFileOpen)],
          output: files.isNotEmpty ? '' : _resultText(),
        );
      case ToolDisplay.collapsible:
        break;
    }

    if (_subagentTools.contains(n)) {
      return _subagent(context, cs, input);
    }
    if (_todoWriteTools.contains(n)) return _todoWrite(context, input);
    if (_todoReadTools.contains(n)) return _todoRead(context);
    if (_taskWriteTools.contains(n)) return _taskWrite(n, input);
    if (_taskListTools.contains(n)) return _taskList(n, input);
    if (_fileTools.contains(n)) return _fileTool(context, cs, n, input);
    // Canonical shell names only — descriptive titles ("Ran grep, curl") fall
    // through to the default one-line row, exactly like the web's Default
    // config for names its catalog doesn't know.
    if (_bashTools.contains(n)) return _bashTool(context, cs, input);
    if (n == 'askuserquestion' || n == 'ask_user_question') {
      return _qaContent(context, cs, input);
    }
    return _default(context, cs, name, input);
  }

  /// Tool output text — the web transcript folds it into the tool row
  /// instead of a second `result` line.
  String _resultText() => message.toolResult?['content']?.toString() ?? message.content ?? '';

  /// `toolUseResult.filenames` — Grep/Glob file-list payloads.
  List<String> _resultFilenames() {
    final res = message.toolResult;
    if (res == null) return const [];
    final tur = res['toolUseResult'];
    if (tur is! Map) return const [];
    final names = tur['filenames'];
    if (names is! List) return const [];
    return [
      for (final f in names)
        if (f != null) f.toString(),
    ];
  }

  /// TodoWrite — collapsible "Updating todo list" + TodoListContent.
  Widget _todoWrite(BuildContext context, Map<String, dynamic> input) {
    final t = Translations.of(context);
    final todos = input['todos'];
    final list = todos is List ? todos : const <dynamic>[];
    return _ToolRow(
      message: message,
      glyph: '☰',
      label: t.chat.tools.updatingTodo,
      extras: [
        if (list.isNotEmpty) TodoListView(todos: list),
        if (toolStatusFor(message) == ToolStatus.completed) const _SuccessLine('Todo list updated'),
      ],
    );
  }

  /// TodoRead — one-line input; the result content is a JSON todos array.
  Widget _todoRead(BuildContext context) {
    final t = Translations.of(context);
    final content = _resultText();
    List<dynamic> todos = const [];
    if (content.trimLeft().startsWith('[')) {
      try {
        final parsed = jsonDecode(content);
        if (parsed is List) todos = parsed;
      } on Object {
        // Fall through — the raw output still renders below.
      }
    }
    return _ToolRow(
      message: message,
      glyph: ocToolGlyph('read'),
      label: t.chat.tools.todoReadLabel,
      extras: [if (todos.isNotEmpty) TodoListView(todos: todos, isResult: true)],
      output: todos.isNotEmpty ? '' : content,
    );
  }

  /// TaskCreate/TaskUpdate — one-line label, result hidden on success
  /// (web `hideOnSuccess`).
  Widget _taskWrite(String n, Map<String, dynamic> input) {
    final label = switch (n) {
      'taskcreate' || 'task_create' => 'Task ${input['subject'] ?? 'Creating task'}',
      _ => () {
        final parts = [
          if (input['taskId'] != null) '#${input['taskId']}',
          if (input['status'] != null) '${input['status']}',
          if (input['subject'] != null) '"${input['subject']}"',
        ].join(' → ');
        return 'Task ${parts.isEmpty ? 'updating' : parts}';
      }(),
    };
    return _ToolRow(
      message: message,
      glyph: '☰',
      label: label,
      output: toolStatusFor(message) == ToolStatus.completed ? '' : _resultText(),
    );
  }

  /// TaskList/TaskGet — one-line input; the result parses into the
  /// `#id [status] subject` TaskListContent rows.
  Widget _taskList(String n, Map<String, dynamic> input) {
    final label = switch (n) {
      'taskget' ||
      'task_get' => 'Task ${input['taskId'] != null ? '#${input['taskId']}' : 'fetching'}',
      _ => 'Tasks listing tasks',
    };
    final content = _resultText();
    return _ToolRow(
      message: message,
      glyph: '☰',
      label: label,
      extras: [if (content.isNotEmpty) TaskListView(content: content)],
      output: '',
    );
  }

  String _oneLineSummary(String n, Map<String, dynamic> input) {
    final path = input['path'] ?? input['file_path'] ?? input['filePath'] ?? input['pattern'];
    final query = input['query'] ?? input['pattern'] ?? input['path'];
    return switch (n) {
      'read_file' => 'Read ${path ?? ''}',
      'list_files' => 'List ${path ?? '.'}',
      'grep' || 'search_files' => 'Search ${input['pattern'] ?? input['query'] ?? ''}',
      'glob' => 'Glob ${path ?? ''}',
      'web_search' || 'websearch' => 'Web: $query',
      _ => query?.toString() ?? path?.toString() ?? '',
    };
  }

  /// `.oc-tool-block` — file tools (Write/Edit/…): square panel block with
  /// a 3px `--oc-bg` left border; the diff expands under the title.
  Widget _fileTool(BuildContext context, ColorScheme cs, String n, Map<String, dynamic> input) {
    final path = input['path'] ?? input['file_path'] ?? input['filePath'] ?? '';
    final diff = input['diff']?.toString() ?? input['edits']?.toString();
    final content = input['content']?.toString() ?? input['new_content']?.toString();
    return _ToolRow(
      message: message,
      glyph: ocToolGlyph(n),
      label: '${_verb(n)} $path',
      copyText: '$path',
      // Web: Edit/Write/ApplyPatch titles open the file in the editor.
      openPath: '$path',
      onFileOpen: onFileOpen,
      extras: [
        AppMarkdown(data: '```diff\n${diff ?? content ?? _json(input)}\n```', selectable: false),
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
  Widget _bashTool(BuildContext context, ColorScheme cs, Map<String, dynamic> input) {
    final cmd = '${input['command'] ?? input['cmd'] ?? input['script'] ?? _json(input)}';
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

  /// Web row label: the tool name followed by the command line.
  String _commandLabel(String cmd) => cmd.replaceAll(RegExp(r'\s+'), ' ').trim();

  Widget _subagent(BuildContext context, ColorScheme cs, Map<String, dynamic> input) {
    final label = input['description'] ?? input['prompt'] ?? input['task'] ?? 'Subagent';
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
                    ? ToolUseTile(message: c, childrenMap: childrenMap, onFileOpen: onFileOpen)
                    : ToolResultTile(message: c),
            ],
          ),
        ),
      ],
    );
  }

  Widget _qaContent(BuildContext context, ColorScheme cs, Map<String, dynamic> input) {
    final questions = input['questions'] is List ? input['questions'] as List : const <dynamic>[];
    final answers = input['answers'] is Map ? input['answers'] as Map : const <dynamic, dynamic>{};
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
                    q['header']?.toString() ?? q['question']?.toString() ?? 'Question',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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

  Widget _default(BuildContext context, ColorScheme cs, String name, Map<String, dynamic> input) =>
      _ToolRow(
        message: message,
        glyph: ocToolGlyph(name),
        label: name,
        copyText: _json(input),
        extras: [Text(_json(input), style: const TextStyle(fontSize: 12, fontFamily: 'monospace'))],
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
    final content = message.toolResult?['content']?.toString() ?? message.content ?? '';
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
        style: TextStyle(fontSize: 12, color: message.isError ? cs.error : cs.outline),
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 8),
            child: Text(
              content,
              maxLines: 40,
              overflow: TextOverflow.ellipsis,
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
  const ToolGroupTile({required this.group, required this.tileBuilder, super.key});

  final ToolGroup group;
  final Widget Function(SessionMessage) tileBuilder;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    // Header mirrors `ToolGroupContainer`: glyph + tool label + `xN` badge +
    // the first two input previews + status badge while not completed.
    final tools = [
      for (final m in group.messages)
        if (m.kind == 'tool_use') m,
    ];
    final name = _norm(tools.firstOrNull?.toolName);
    final status = groupStatus(group.messages);
    final previews = tools.take(2).map(toolGroupPreview).where((p) => p.isNotEmpty).toList();
    final extra = tools.length - previews.length;
    final preview = previews.isEmpty
        ? (extra > 0 ? '+$extra more' : '')
        : extra > 0
        ? '${previews.join(', ')}, +$extra more'
        : previews.join(', ');
    final badgeStyle = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: c.mutedForeground,
    );
    return ExpansionTile(
      dense: true,
      tilePadding: EdgeInsets.zero,
      leading: Text(
        ocToolGlyph(name),
        style: TextStyle(fontFamily: 'monospace', fontSize: 13, color: c.primary),
      ),
      title: Row(
        spacing: 6,
        children: [
          Text(ocToolLabel(name), style: TextStyle(fontSize: 13, color: c.foreground)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(color: c.secondary, borderRadius: BorderRadius.circular(999)),
            child: Text('x${tools.length}', style: badgeStyle),
          ),
          if (preview.isNotEmpty)
            Flexible(
              child: Text(
                preview,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: c.mutedForeground),
              ),
            ),
          if (status != ToolStatus.completed) ToolStatusBadge(status: status),
        ],
      ),
      children: [for (final m in group.messages) tileBuilder(m)],
    );
  }
}

// ---------------------------------------------------------------------------
// AskUserQuestion interactive panel (T15.3/9) — port of AskUserQuestionPanel.

/// Command Code plan-review surface. The CLI's `plan_review`/`exit_plan_mode`
/// approval ask reaches the client as a question whose `planContent` /
/// `planFilePath` fields the server re-attached from `~/.commandcode/plans/`
/// (the ACP bridge drops them) — this panel renders the plan markdown so the
/// user can read it before approving. Scrollable, height-capped, collapsible.
class PlanReviewPanel extends StatefulWidget {
  const PlanReviewPanel({
    required this.content,
    this.filePath,
    this.initiallyExpanded = true,
    super.key,
  });

  final String content;
  final String? filePath;
  final bool initiallyExpanded;

  @override
  State<PlanReviewPanel> createState() => _PlanReviewPanelState();
}

class _PlanReviewPanelState extends State<PlanReviewPanel> {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final fileName = widget.filePath?.split(RegExp(r'[/\\]')).last;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              child: Row(
                children: [
                  Icon(
                    _expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    size: 16,
                    color: cs.outline,
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.description_outlined, size: 14, color: cs.outline),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      fileName ?? 'Plan',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 320),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: cs.outlineVariant)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: AppMarkdown(data: widget.content, selectable: false),
              ),
            ),
        ],
      ),
    );
  }
}

/// True when an option the model offered acts as a free-text entry ("Other",
/// "Inne (wpiszę)", …). The tool schema tells models not to add such an option
/// (the client provides one), but when they do a tap must reveal the text field
/// instead of answering with the bare label.
bool _isFreeTextOption(String label) {
  final hay = label.toLowerCase().trim();
  const needles = <String>[
    'other',
    'custom',
    'wpiszę',
    'wpisze',
    'wpisz',
    'napisz',
    'opisz',
    'własn',
    'wlasn',
    'inne',
    'inny',
    'inna',
    'innego',
    'innych',
    'type something',
    'type your',
    'something else',
  ];
  return needles.any(hay.contains);
}

/// The text the user typed that is not one of the offered option labels.
/// ACP providers (command-code / Devin) can only echo a picked option id, so
/// this is relayed as a normal follow-up message or the agent never sees it.
String extractQuestionFreeText(dynamic input, dynamic updatedInput) {
  final questions = input is Map ? input['questions'] : null;
  final answers = updatedInput is Map ? updatedInput['answers'] : null;
  if (questions is! List || answers is! Map) return '';
  final parts = <String>[];
  for (var i = 0; i < questions.length; i++) {
    final q = questions[i];
    if (q is! Map) continue;
    final labels = <String>{
      for (final o in q['options'] as List? ?? const [])
        if (o is Map) (o['label'] ?? o['text'] ?? '$o').toString() else '$o',
    };
    final raw = answers[q['question']?.toString() ?? 'q$i'];
    final text = raw is String ? raw : (raw is List ? raw.join(', ') : '');
    for (final part in text.split(', ')) {
      final t = part.trim();
      if (t.isNotEmpty && !labels.contains(t)) parts.add(t);
    }
  }
  return parts.join('\n');
}

class AskUserQuestionPanel extends StatefulWidget {
  const AskUserQuestionPanel({
    required this.requestId,
    required this.input,
    required this.onDecision,
    this.autoSubmit = false,
    super.key,
  });

  final String requestId;
  final Map<String, dynamic> input;

  /// `decision(allow, updatedInput)` — mirrors web `onDecision`.
  final void Function(bool allow, Map<String, dynamic> updatedInput) onDecision;

  /// Single-select option tap resolves immediately (advancing to the next
  /// bundled question, or submitting on the last one) — the pending banner
  /// answers one ask at a time so the CLI can fire the follow-up.
  final bool autoSubmit;

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
      if (_otherActive[i] == true && (_otherText[i]?.text.trim().isNotEmpty ?? false)) {
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
    final t = Translations.of(context);
    final cs = Theme.of(context).colorScheme;
    final qs = _questions;
    if (qs.isEmpty) return const SizedBox.shrink();
    if (_step >= qs.length) _step = qs.length - 1;
    final q = qs[_step];
    final options = [
      for (final o in q['options'] as List? ?? const [])
        if (o is Map) o['label']?.toString() ?? o['text']?.toString() ?? '$o' else '$o',
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
                  q['header']?.toString() ?? 'Question ${_step + 1}/${qs.length}',
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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
            Padding(padding: const EdgeInsets.only(top: 4), child: Text(q['question'].toString())),
          if ((q['planContent']?.toString() ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: PlanReviewPanel(
                content: q['planContent'].toString(),
                filePath: q['planFilePath']?.toString(),
              ),
            ),
          const SizedBox(height: 8),
          for (final o in options)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  final freeText = _isFreeTextOption(o);
                  if (multi) {
                    setState(() => selected.contains(o) ? selected.remove(o) : selected.add(o));
                    return;
                  }
                  setState(() {
                    selected
                      ..clear()
                      ..add(o);
                    if (freeText) {
                      _otherActive[_step] = true;
                      _otherText[_step] ??= TextEditingController();
                    }
                  });
                  if (!widget.autoSubmit || freeText) return;
                  if (_step < qs.length - 1) {
                    setState(() => _step++);
                  } else {
                    widget.onDecision(true, {...widget.input, 'answers': _answers()});
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      multi
                          ? (selected.contains(o) ? Icons.check_box : Icons.check_box_outline_blank)
                          : (selected.contains(o)
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off),
                      size: 18,
                      color: selected.contains(o) ? cs.primary : cs.outline,
                    ),
                    const SizedBox(width: 6),
                    Expanded(child: Text(o, style: const TextStyle(fontSize: 13))),
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
                  child: Text(t.common.navigation.back),
                ),
              const Spacer(),
              TextButton(
                onPressed: () =>
                    widget.onDecision(true, {...widget.input, 'answers': <String, dynamic>{}}),
                child: Text(t.chat.askUserQuestion.skip),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _step < qs.length - 1
                    ? () => setState(() => _step++)
                    : () => widget.onDecision(true, {...widget.input, 'answers': _answers()}),
                child: Text(_step < qs.length - 1 ? 'Next' : 'Submit'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _otherField(ColorScheme cs, Set<String> selected) {
    final t = Translations.of(context);
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
              Text(t.chat.askUserQuestion.other, style: TextStyle(fontSize: 13, color: cs.outline)),
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
        decoration: InputDecoration(
          isDense: true,
          hintText: t.chat.askUserQuestion.answerHint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

/// Tool row shell — `.oc-tool-row` bare line when there is nothing to
/// expand; a `rounded-lg border bg-muted/40` card once it carries output
/// (OneLineDisplay) or always for shell calls (BashCommandDisplay), and the
/// square `.oc-tool-block` for file edits.
class _ToolRow extends ConsumerStatefulWidget {
  const _ToolRow({
    required this.message,
    required this.glyph,
    required this.label,
    this.output = '',
    this.extras = const [],
    this.copyText,
    this.alwaysCard = false,
    this.block = false,
    this.openPath,
    this.onFileOpen,
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

  /// File path the label links to (web Edit/Write/ApplyPatch title click →
  /// `onFileOpen`). Renders only when [onFileOpen] is provided.
  final String? openPath;
  final void Function(String path)? onFileOpen;

  @override
  ConsumerState<_ToolRow> createState() => _ToolRowState();
}

class _ToolRowState extends ConsumerState<_ToolRow> {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      child: Row(
        spacing: 7,
        children: [
          // Chevron rotates 90° when open; invisible without a body.
          AnimatedRotation(
            turns: _open ? 0.25 : 0,
            duration: AppMotion.base,
            child: Icon(
              Icons.chevron_right,
              size: 16,
              color: hasBody ? c.mutedForeground : c.mutedForeground.withValues(alpha: 0),
            ),
          ),
          // `.oc-tool-icon` — 2ch glyph; emerald `$` for shell rows.
          Text(
            widget.glyph,
            style: TextStyle(
              fontSize: 13,
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
            // File-tool titles link to the in-pane editor (web onFileOpen).
            child: widget.openPath != null && widget.onFileOpen != null
                ? InkWell(
                    onTap: () => widget.onFileOpen!(widget.openPath!),
                    child: Text(
                      widget.label,
                      maxLines: _open ? 8 : 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                        color: error ? cs.error : c.primary,
                        decoration: error ? TextDecoration.lineThrough : TextDecoration.underline,
                        decorationColor: error ? cs.error : c.primary,
                      ),
                    ),
                  )
                : Text(
                    widget.label,
                    maxLines: _open ? 8 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'monospace',
                      color: error ? cs.error : c.foreground,
                      decoration: error ? TextDecoration.lineThrough : null,
                      decorationColor: cs.error,
                    ),
                  ),
          ),
          // BashCommandDisplay swaps the badge for a spinner; one-line
          // rows keep the `Running` badge. Completed rows carry no badge at
          // all — web `ToolRenderer` passes `status` only when not completed.
          if (status == ToolStatus.running && bash)
            SizedBox.square(
              dimension: 10,
              child: CircularProgressIndicator(strokeWidth: 1.5, color: c.mutedForeground),
            )
          else if (status != ToolStatus.completed)
            ToolStatusBadge(status: status),
          if (hasOutput && !_open)
            Text(
              '$lineCount ${lineCount == 1 ? 'line' : 'lines'}',
              style: TextStyle(
                fontSize: 11,
                color: c.mutedForeground,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          if (widget.copyText != null)
            GestureDetector(
              onTap: () => unawaited(copyTextWithFeedback(context, widget.copyText!)),
              child: Icon(Icons.copy_outlined, size: 13, color: c.mutedForeground),
            ),
        ],
      ),
    );

    final body = !hasBody
        ? null
        : Container(
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: c.border.withValues(alpha: 0.5))),
            ),
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 6,
              children: [
                ...widget.extras,
                // `showRawParameters` pref — web OneLineDisplay appends the
                // raw tool-input JSON inside the expanded body.
                if (ref.watch(uiPreferencesProvider).showRawParameters &&
                    widget.message.toolInput != null)
                  Text(
                    const JsonEncoder.withIndent('  ').convert(widget.message.toolInput),
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: c.mutedForeground,
                    ),
                  ),
                if (hasOutput) ToolOutputPreview(content: output, isError: error),
              ],
            ),
          );

    // `.oc-tool-row` — bare baseline row, nothing to expand.
    if (!widget.alwaysCard && !widget.block && !hasBody) {
      return Padding(padding: const EdgeInsets.only(left: 12, top: 3), child: header);
    }

    final decoration = widget.block
        // `.oc-tool-block` — square, panel bg, left 3px --oc-bg border.
        ? BoxDecoration(
            color: c.card,
            border: Border(left: BorderSide(color: c.background, width: 3)),
          )
        : BoxDecoration(
            color: c.muted.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: error ? cs.error.withValues(alpha: 0.5) : c.border.withValues(alpha: 0.9),
            ),
          );

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: decoration,
      clipBehavior: widget.block ? Clip.none : Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(onTap: hasBody ? () => setState(() => _open = !_open) : null, child: header),
          if (_open && body != null) body,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Todo / task list renderers (T56) — TodoListContent + TaskListContent ports.

/// `TodoListContent` — status-icon rows for TodoWrite/TodoRead payloads.
/// Items are validated `{content, status}` maps; everything else is dropped.
class TodoListView extends StatelessWidget {
  const TodoListView({required this.todos, this.isResult = false, super.key});

  final List<dynamic> todos;

  /// Result rows get the "Todo List (N items)" caption (web isResult).
  final bool isResult;

  static const _statusIcons = {
    'completed': (Icons.check_circle, Color(0xFF22C55E)),
    'in_progress': (Icons.schedule, Color(0xFF3B82F6)),
    'pending': (Icons.radio_button_unchecked, Color(0xFF9CA3AF)),
  };

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final items = [
      for (final todo in todos)
        if (todo is Map && todo['content'] is String && todo['status'] is String) todo,
    ];
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isResult)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              'Todo List (${items.length} ${items.length == 1 ? 'item' : 'items'})',
              style: t.labelSmall?.copyWith(color: c.mutedForeground),
            ),
          ),
        for (final todo in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Icon(
                    (_statusIcons[todo['status']] ?? _statusIcons['pending']!).$1,
                    size: 14,
                    color: (_statusIcons[todo['status']] ?? _statusIcons['pending']!).$2,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${todo['content']}',
                    style: t.bodySmall?.copyWith(
                      decoration: todo['status'] == 'completed' ? TextDecoration.lineThrough : null,
                      color: todo['status'] == 'completed' ? c.mutedForeground : c.foreground,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// `TaskListContent` — parses `#id [status] subject` lines into status rows
/// with a completed/total progress bar. Falls back to raw text when nothing
/// parses (legacy behavior).
class TaskListView extends StatelessWidget {
  const TaskListView({required this.content, super.key});

  final String content;

  static final _lineRe = RegExp(
    r'#(\d+)\.?\s*(?:\[(\w+)\]\s*)?(.+?)(?:\s*\((?:owner:\s*\w+)?\))?$',
  );

  static const _statusColors = {
    'completed': Color(0xFF22C55E),
    'in_progress': Color(0xFF3B82F6),
    'pending': Color(0xFF9CA3AF),
  };

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final tasks = <({String id, String status, String subject})>[];
    for (final line in content.split('\n')) {
      final m = _lineRe.firstMatch(line);
      if (m == null) continue;
      final status = m.group(2) ?? 'pending';
      tasks.add((
        id: m.group(1)!,
        status: const {'completed', 'in_progress'}.contains(status) ? status : 'pending',
        subject: m.group(3)!.trim(),
      ));
    }
    if (tasks.isEmpty) {
      return Text(
        content,
        style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: c.mutedForeground),
      );
    }
    final done = tasks.where((x) => x.status == 'completed').length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$done/${tasks.length} completed',
              style: t.labelSmall?.copyWith(color: c.mutedForeground),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: done / tasks.length,
                  minHeight: 4,
                  backgroundColor: c.muted,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF22C55E)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        for (final task in tasks)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Row(
              children: [
                Icon(
                  task.status == 'completed'
                      ? Icons.check_circle_outline
                      : task.status == 'in_progress'
                      ? Icons.schedule
                      : Icons.radio_button_unchecked,
                  size: 14,
                  color: _statusColors[task.status],
                ),
                const SizedBox(width: 6),
                Text(
                  '#${task.id}',
                  style: t.labelSmall?.copyWith(fontFamily: 'monospace', color: c.mutedForeground),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    task.subject,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.bodySmall?.copyWith(
                      decoration: task.status == 'completed' ? TextDecoration.lineThrough : null,
                      color: task.status == 'completed' ? c.mutedForeground : null,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    border: Border.all(color: _statusColors[task.status]!.withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(3),
                    color: _statusColors[task.status]!.withValues(alpha: 0.12),
                  ),
                  child: Text(
                    task.status.replaceAll('_', ' '),
                    style: TextStyle(fontSize: 10, color: _statusColors[task.status]),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Green check + message — web `success-message` content rows.
class _SuccessLine extends StatelessWidget {
  const _SuccessLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check, size: 12, color: Color(0xFF22C55E)),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF22C55E))),
      ],
    );
  }
}

/// `FileListContent` — comma-separated clickable filenames (Grep/Glob
/// results); each opens the file in the in-pane editor.
class _FileListLinks extends StatelessWidget {
  const _FileListLinks({required this.files, this.onFileOpen});

  final List<String> files;
  final void Function(String path)? onFileOpen;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Wrap(
      spacing: 4,
      runSpacing: 2,
      children: [
        for (var i = 0; i < files.length; i++)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: onFileOpen == null ? null : () => onFileOpen!(files[i]),
                child: Tooltip(
                  message: files[i],
                  child: Text(
                    files[i].split(RegExp(r'[\\/]')).last,
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'monospace',
                      color: c.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: c.primary.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              if (i < files.length - 1)
                Text(',', style: TextStyle(fontSize: 10, color: c.mutedForeground)),
            ],
          ),
      ],
    );
  }
}
