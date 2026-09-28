import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/features/chat/state/composer_controller.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Chat composer (T14): multiline input, send/abort, attachments, model /
/// effort / permission / account picks, slash commands, @-mentions, pinned
/// files, queued-send list, favorites — compact layout collapses the option
/// row into a mobile action sheet.
class ChatComposer extends ConsumerStatefulWidget {
  const ChatComposer({
    required this.sessionId,
    this.projectId,
    this.projectPath,
    this.provider = 'claude',
    super.key,
  });

  final String sessionId;
  final String? projectId;
  final String? projectPath;
  final String provider;

  @override
  ConsumerState<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends ConsumerState<ChatComposer> {
  final _input = TextEditingController();
  final _focus = FocusNode();
  List<Map<String, String>> _mentions = const [];
  bool _mentionOpen = false;

  ComposerArg get _arg => (
    sessionId: widget.sessionId,
    projectId: widget.projectId,
    provider: widget.provider,
    projectPath: widget.projectPath,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final text = ref.read(composerProvider(_arg)).input;
      if (text.isNotEmpty && _input.text != text) _input.text = text;
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    ref.read(composerProvider(_arg).notifier).setInput(v);
    final word = _currentWord(v);
    if (word.startsWith('@') && word.length > 1) {
      unawaited(_searchMentions(word.substring(1)));
    } else if (_mentionOpen) {
      setState(() => _mentionOpen = false);
    } else {
      setState(() {});
    }
  }

  String _currentWord(String v) {
    final sel = _input.selection.baseOffset;
    final upto = sel >= 0 && sel <= v.length ? v.substring(0, sel) : v;
    final m = RegExp(r'(^|\s)([@/][^\s]*)$').firstMatch(upto);
    return m?.group(2) ?? '';
  }

  Future<void> _searchMentions(String q) async {
    final res = await ref.read(composerProvider(_arg).notifier).mentions(q);
    if (mounted) {
      setState(() {
        _mentions = res;
        _mentionOpen = res.isNotEmpty;
      });
    }
  }

  void _insertMention(String insert) {
    final v = _input.text;
    final sel = _input.selection.baseOffset;
    final upto = sel >= 0 ? v.substring(0, sel) : v;
    final rest = sel >= 0 ? v.substring(sel) : '';
    final replaced = upto.replaceFirst(RegExp(r'[@/][^\s]*$'), '$insert ');
    _input.text = replaced + rest;
    _input.selection = TextSelection.collapsed(offset: replaced.length);
    _onChanged(_input.text);
    setState(() => _mentionOpen = false);
  }

  List<Map<String, dynamic>> get _filteredCommands {
    final cmds = ref.read(composerProvider(_arg)).slashCommands;
    final word = _currentWord(_input.text);
    if (!_input.text.startsWith('/') && !word.startsWith('/')) return const [];
    final q = word.startsWith('/') ? word.substring(1).toLowerCase() : '';
    return [
      for (final c in cmds)
        if ('${c['name']}'.toLowerCase().contains(q)) c,
    ];
  }

  bool get _slashOpen {
    final sel = _input.selection.baseOffset;
    return _input.text.startsWith('/') &&
        sel > 0 &&
        !_input.text.substring(0, sel).contains(' ');
  }

  Future<void> _pickFile() async {
    final f = (await FilePicker.pickFiles()).firstOrNull;
    if (f == null) return;
    final bytes = await f.xFile.readAsBytes();
    final isImage = switch (f.extension?.toLowerCase()) {
      'png' || 'jpg' || 'jpeg' || 'gif' || 'webp' || 'bmp' => true,
      _ => false,
    };
    await ref
        .read(composerProvider(_arg).notifier)
        .attach(f.name, bytes, isImage: isImage);
  }

  Future<void> _send() async {
    final running =
        ref
            .read(
              transcriptProvider((
                sessionId: widget.sessionId,
                projectId: widget.projectId,
              )),
            )
            .runStatus ==
        'running';
    await ref.read(composerProvider(_arg).notifier).send(running: running);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(composerProvider(_arg));
    final compact = context.breakpoint.isCompact;
    final cs = Theme.of(context).colorScheme;
    if (_input.text != state.input) {
      _input.value = TextEditingValue(
        text: state.input,
        selection: TextSelection.collapsed(offset: state.input.length),
      );
    }

    final optionBar = _OptionBar(
      arg: _arg,
      state: state,
      sessionId: widget.sessionId,
      onAttach: _pickFile,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.pinnedFiles.isNotEmpty)
          _PinnedFilesBar(files: state.pinnedFiles, arg: _arg),
        if (state.queue.isNotEmpty) _QueueCard(arg: _arg, queue: state.queue),
        if (_mentionOpen)
          _MentionPopup(
            items: _mentions,
            onSelect: (m) => _insertMention(m['insert']!),
          ),
        if (_slashOpen)
          _SlashPopup(
            commands: _filteredCommands,
            onSelect: (c) async {
              final prompt = await ref
                  .read(composerProvider(_arg).notifier)
                  .executeCommand(c, const []);
              if (prompt != null) {
                _input.text = prompt;
                _onChanged(prompt);
              }
            },
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (compact)
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _showActionSheet(context, optionBar),
              )
            else
              IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: _pickFile,
              ),
            Expanded(
              child: Shortcuts(
                shortcuts: {
                  const SingleActivator(LogicalKeyboardKey.enter):
                      const _SendIntent(),
                  const SingleActivator(LogicalKeyboardKey.enter, shift: true):
                      const _NewlineIntent(),
                },
                child: Actions(
                  actions: {
                    _SendIntent: CallbackAction<_SendIntent>(
                      onInvoke: (_) {
                        _send();
                        return null;
                      },
                    ),
                    _NewlineIntent: CallbackAction<_NewlineIntent>(
                      onInvoke: (_) {
                        _input.text += '\n';
                        _onChanged(_input.text);
                        return null;
                      },
                    ),
                  },
                  child: TextField(
                    controller: _input,
                    focusNode: _focus,
                    minLines: 1,
                    maxLines: 8,
                    textInputAction: TextInputAction.newline,
                    onChanged: _onChanged,
                    contentInsertionConfiguration:
                        ContentInsertionConfiguration(
                          onContentInserted: (v) {
                            final bytes = v.data;
                            if (bytes == null) return;
                            unawaited(
                              ref
                                  .read(composerProvider(_arg).notifier)
                                  .attach(v.uri, bytes, isImage: true),
                            );
                          },
                        ),
                    decoration: InputDecoration(
                      hintText: 'Message…',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
            _SendButton(
              arg: _arg,
              state: state,
              sessionId: widget.sessionId,
              onSend: _send,
            ),
          ],
        ),
        if (state.attachments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Wrap(
              spacing: 6,
              children: [
                for (var i = 0; i < state.attachments.length; i++)
                  InputChip(
                    label: Text('${state.attachments[i]['name']}'),
                    onDeleted: () => ref
                        .read(composerProvider(_arg).notifier)
                        .removeAttachment(i),
                  ),
              ],
            ),
          ),
        if (!compact) optionBar,
        if (state.sendError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              state.sendError!,
              style: TextStyle(color: cs.error, fontSize: 12),
            ),
          ),
      ],
    );
  }

  void _showActionSheet(BuildContext context, Widget child) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(padding: const EdgeInsets.all(12), child: child),
    );
  }
}

class _SendIntent extends Intent {
  const _SendIntent();
}

class _NewlineIntent extends Intent {
  const _NewlineIntent();
}

class _SendButton extends ConsumerWidget {
  const _SendButton({
    required this.arg,
    required this.state,
    required this.sessionId,
    required this.onSend,
  });

  final ComposerArg arg;
  final ComposerState state;
  final String sessionId;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final running =
        ref.watch(
          transcriptProvider((sessionId: sessionId, projectId: arg.projectId))
              .select((s) => s.runStatus),
        ) ==
        'running';
    if (running) {
      return IconButton.filled(
        icon: const Icon(Icons.stop),
        tooltip: 'Abort',
        onPressed: () => ref.read(composerProvider(arg).notifier).abort(),
      );
    }
    return IconButton.filled(
      icon: state.uploading
          ? const SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.send),
      tooltip: 'Send',
      onPressed: state.input.trim().isEmpty ? null : onSend,
    );
  }
}

class _OptionBar extends ConsumerWidget {
  const _OptionBar({
    required this.arg,
    required this.state,
    required this.sessionId,
    required this.onAttach,
  });

  final ComposerArg arg;
  final ComposerState state;
  final String sessionId;
  final VoidCallback onAttach;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final sortedModels = [...state.models]
      ..sort((a, b) {
        final fa = state.favorites.contains('${a['id'] ?? a['value']}') ? 0 : 1;
        final fb = state.favorites.contains('${b['id'] ?? b['value']}') ? 0 : 1;
        return fa.compareTo(fb);
      });
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Model picker with favorites (T14.3 + T14.12)
        if (sortedModels.isNotEmpty)
          PopupMenuButton<String>(
            tooltip: 'Model',
            onSelected: (id) =>
                ref.read(composerProvider(arg).notifier).selectModel(id),
            itemBuilder: (_) => [
              for (final m in sortedModels)
                PopupMenuItem<String>(
                  value: '${m['id'] ?? m['value']}',
                  child: Row(
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          state.favorites.contains('${m['id'] ?? m['value']}')
                              ? Icons.star
                              : Icons.star_border,
                          size: 16,
                        ),
                        onPressed: () => ref
                            .read(composerProvider(arg).notifier)
                            .toggleFavorite('${m['id'] ?? m['value']}'),
                      ),
                      Expanded(
                        child: Text(
                          '${m['label'] ?? m['name'] ?? m['id'] ?? m['value']}',
                        ),
                      ),
                    ],
                  ),
                ),
            ],
            child: _Pill(
              label: _modelLabel(state),
              icon: Icons.smart_toy_outlined,
              cs: cs,
            ),
          ),
        if (state.effortValues.isNotEmpty)
          _MiniDropdown(
            label: 'Effort',
            value: state.effort ?? 'default',
            items: ['default', ...state.effortValues],
            onChanged: (v) =>
                ref.read(composerProvider(arg).notifier).selectEffort(v!),
          ),
        _MiniDropdown(
          label: 'Permission',
          value: state.permissionMode,
          items: const ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
          onChanged: (v) =>
              ref.read(composerProvider(arg).notifier).selectPermissionMode(v!),
        ),
        if (state.accounts.isNotEmpty)
          _MiniDropdown(
            label: 'Account',
            value: state.accountId,
            items: [null, for (final a in state.accounts) a.id],
            displayFor: (v) => v == null
                ? 'Auto'
                : state.accounts
                          .where((a) => a.id == v)
                          .map((a) => a.label ?? a.id)
                          .firstOrNull ??
                      v,
            onChanged: (v) =>
                ref.read(composerProvider(arg).notifier).selectAccount(v),
          ),
        IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.push_pin_outlined, size: 18),
          tooltip: 'Pin file to context',
          onPressed: () => _pinDialog(context, ref),
        ),
      ],
    );
  }

  String _modelLabel(ComposerState s) {
    for (final m in s.models) {
      if ('${m['id'] ?? m['value']}' == s.activeModel) {
        return '${m['label'] ?? m['name'] ?? s.activeModel}';
      }
    }
    return s.activeModel ?? 'Model';
  }

  Future<void> _pinDialog(BuildContext context, WidgetRef ref) async {
    final c = TextEditingController();
    final path = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pin file'),
        content: TextField(
          controller: c,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'path/to/file.ext'),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, c.text),
            child: const Text('Pin'),
          ),
        ],
      ),
    );
    if (path != null && path.trim().isNotEmpty) {
      ref.read(composerProvider(arg).notifier).pinFile(path.trim());
    }
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.icon, required this.cs});

  final String label;
  final IconData icon;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      border: Border.all(color: cs.outlineVariant),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: cs.outline),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const Icon(Icons.arrow_drop_down, size: 16),
      ],
    ),
  );
}

class _MiniDropdown extends StatelessWidget {
  const _MiniDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.displayFor,
  });

  final String label;
  final String? value;
  final List<String?> items;
  final ValueChanged<String?> onChanged;
  final String Function(String?)? displayFor;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelSmall;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null,
          isDense: true,
          style: textStyle,
          hint: Text(
            '$label: ${displayFor?.call(value) ?? value ?? 'auto'}',
            style: textStyle,
          ),
          selectedItemBuilder: (_) => [
            for (final it in items)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '$label: ${displayFor?.call(it) ?? it ?? 'auto'}',
                  style: textStyle,
                ),
              ),
          ],
          items: [
            for (final it in items)
              DropdownMenuItem<String>(
                value: it,
                child: Text(displayFor?.call(it) ?? it ?? 'auto'),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _PinnedFilesBar extends ConsumerWidget {
  const _PinnedFilesBar({required this.files, required this.arg});

  final List<String> files;
  final ComposerArg arg;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Wrap(
      spacing: 6,
      children: [
        for (final f in files)
          InputChip(
            avatar: const Icon(Icons.push_pin, size: 14),
            label: Text(f.split('/').last),
            tooltip: f,
            onDeleted: () =>
                ref.read(composerProvider(arg).notifier).unpinFile(f),
          ),
      ],
    ),
  );
}

class _QueueCard extends ConsumerWidget {
  const _QueueCard({required this.arg, required this.queue});

  final ComposerArg arg;
  final List<Map<String, dynamic>> queue;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Card(
    margin: const EdgeInsets.only(bottom: 6),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final m in queue)
          ListTile(
            dense: true,
            leading: const Icon(Icons.schedule, size: 18),
            title: Text(
              '${m['content']}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.play_arrow, size: 18),
                  tooltip: 'Send now',
                  onPressed: () => ref
                      .read(composerProvider(arg).notifier)
                      .sendNow('${m['id']}'),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  tooltip: 'Remove',
                  onPressed: () => ref
                      .read(composerProvider(arg).notifier)
                      .deleteQueued('${m['id']}'),
                ),
              ],
            ),
          ),
      ],
    ),
  );
}

class _MentionPopup extends StatelessWidget {
  const _MentionPopup({required this.items, required this.onSelect});

  final List<Map<String, String>> items;
  final ValueChanged<Map<String, String>> onSelect;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 4),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 220),
      child: ListView(
        shrinkWrap: true,
        children: [
          for (final m in items)
            ListTile(
              dense: true,
              leading: Icon(switch (m['kind']) {
                'file' => Icons.insert_drive_file_outlined,
                'task' => Icons.task_alt,
                _ => Icons.alternate_email,
              }, size: 16),
              title: Text(
                m['label'] ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () => onSelect(m),
            ),
        ],
      ),
    ),
  );
}

class _SlashPopup extends StatelessWidget {
  const _SlashPopup({required this.commands, required this.onSelect});

  final List<Map<String, dynamic>> commands;
  final ValueChanged<Map<String, dynamic>> onSelect;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.only(bottom: 4),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 220),
      child: ListView(
        shrinkWrap: true,
        children: [
          for (final c in commands)
            ListTile(
              dense: true,
              leading: const Icon(Icons.slideshow_outlined, size: 16),
              title: Text('/${c['name']}'),
              subtitle: c['description'] != null
                  ? Text(
                      '${c['description']}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              onTap: () => onSelect(c),
            ),
        ],
      ),
    ),
  );
}
