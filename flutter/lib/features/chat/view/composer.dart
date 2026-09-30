import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/chat/state/composer_controller.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
import 'package:ddagent_app/features/chat/view/composer_model_menu.dart';
import 'package:ddagent_app/features/voice/state/stt_controller.dart';
import 'package:ddagent_app/features/voice/view/stt_config_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
    this.dense = false,
    super.key,
  });

  final String sessionId;
  final String? projectId;
  final String? projectPath;
  final String provider;

  /// `[data-split-rows="2"]` parity — slimmed-down composer: the submit
  /// hint never renders and outer spacing shrinks.
  final bool dense;

  @override
  ConsumerState<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends ConsumerState<ChatComposer> {
  final _input = TextEditingController();
  final _focus = FocusNode();
  final _promptBoxKey = GlobalKey();
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
    // `:focus-within` parity — the prompt box border goes accent.
    _focus.addListener(() {
      if (mounted) setState(() {});
    });
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

  Future<void> _toggleVoice() async {
    final voiceState = ref.read(voiceInputProvider);
    if (voiceState.isRecording) {
      final text = await ref.read(voiceInputProvider.notifier).stopRecording();
      if (text != null && text.isNotEmpty) {
        final current = _input.text;
        _input.text = current.isEmpty ? text : '$current $text';
        _onChanged(_input.text);
      }
    } else {
      await ref.read(voiceInputProvider.notifier).startRecording();
    }
  }

  /// `PromptInputButton` — h-8 w-8 ghost icon, 16px glyph.
  static Widget _toolBtn(
    IconData icon, {
    required String tooltip,
    VoidCallback? onPressed,
    Color? color,
    Widget? child,
  }) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    icon: child ?? Icon(icon, size: 16, color: color),
    visualDensity: VisualDensity.compact,
    padding: EdgeInsets.zero,
    constraints: const BoxConstraints.tightFor(width: 32, height: 32),
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(composerProvider(_arg));
    final sttConfig = ref.watch(sttConfigProvider);
    final voiceState = ref.watch(voiceInputProvider);
    final compact = context.breakpoint.isCompact;
    final c = context.appColors;
    final cs = Theme.of(context).colorScheme;
    if (_input.text != state.input) {
      _input.value = TextEditingValue(
        text: state.input,
        selection: TextSelection.collapsed(offset: state.input.length),
      );
    }

    final running =
        ref.watch(
          transcriptProvider((
            sessionId: widget.sessionId,
            projectId: widget.projectId,
          )).select((s) => s.runStatus),
        ) ==
        'running';
    final hasDraft =
        state.input.trim().isNotEmpty || state.attachments.isNotEmpty;
    final canQueueDraft = running && hasDraft;

    final optionBar = _OptionBar(
      arg: _arg,
      state: state,
      sessionId: widget.sessionId,
      onAttach: _pickFile,
      compact: compact,
      promptBoxKey: _promptBoxKey,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        // `data-slot="prompt-input"` — the oc prompt box: 1px --oc-border,
        // 4px radius, --oc-panel fill, accent border while focused, no
        // shadow. The body has no padding of its own: the `>` caret and the
        // textarea pad themselves (caret left:14 top:8, field pl-7 py-2).
        Container(
          key: _promptBoxKey,
          decoration: BoxDecoration(
            color: c.card,
            border: Border.all(color: _focus.hasFocus ? c.primary : c.border),
            borderRadius: AppRadii.borderSm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.attachments.isNotEmpty)
                // PromptInputHeader px-3 pt-3 + .oc-attachments pb-6.
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      for (var i = 0; i < state.attachments.length; i++)
                        _AttachmentChip(
                          record: state.attachments[i],
                          onRemove: () => ref
                              .read(composerProvider(_arg).notifier)
                              .removeAttachment(i),
                        ),
                    ],
                  ),
                ),
              if (state.pinnedFiles.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: _PinnedFilesBar(files: state.pinnedFiles, arg: _arg),
                ),
              Stack(
                children: [
                  // `>` prompt sign — .oc-input-caret (accent, bold, 14/8).
                  Positioned(
                    left: 14,
                    top: 8,
                    child: IgnorePointer(
                      child: Text(
                        '>',
                        style: TextStyle(
                          color: c.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                  Shortcuts(
                    shortcuts: {
                      const SingleActivator(LogicalKeyboardKey.enter):
                          const _SendIntent(),
                      const SingleActivator(
                        LogicalKeyboardKey.enter,
                        shift: true,
                      ): const _NewlineIntent(),
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
                        // oc textarea: monospace 13px / 1.5 (family comes
                        // from the ocChat theme).
                        style: const TextStyle(fontSize: 13, height: 1.5),
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
                          // `input.placeholder` from the old chat locale.
                          hintText:
                              'Type / for commands, @ for files, or ask '
                              '${providerLabel(widget.provider)} anything...',
                          hintStyle: TextStyle(
                            color: c.mutedForeground.withValues(alpha: 0.5),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          // px-4 py-2 + pl-7 (the `>` caret column).
                          contentPadding: const EdgeInsets.fromLTRB(
                            28,
                            8,
                            16,
                            8,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // `data-slot="prompt-input-footer"` — border-top --oc-elem,
              // px-3 py-2, muted.
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: c.secondary)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  spacing: 4,
                  children: [
                    if (compact)
                      _toolBtn(
                        Icons.add,
                        tooltip: 'More tools',
                        onPressed: () => _showActionSheet(context, optionBar),
                      )
                    else ...[
                      _toolBtn(
                        Icons.attach_file,
                        tooltip: 'Attach file',
                        onPressed: _pickFile,
                      ),
                      if (sttConfig.configured)
                        _toolBtn(
                          voiceState.isRecording ? Icons.mic : Icons.mic_none,
                          tooltip: voiceState.isRecording
                              ? 'Stop recording'
                              : 'Voice input (STT)',
                          color: voiceState.isRecording ? cs.error : null,
                          onPressed: voiceState.isProcessing
                              ? null
                              : _toggleVoice,
                          child: voiceState.isProcessing
                              ? const SizedBox.square(
                                  dimension: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : null,
                        ),
                      // Extra Flutter tools — they sit in the left tools
                      // cluster so the right group stays model+permission
                      // like the web footer.
                      _toolBtn(
                        Icons.push_pin_outlined,
                        tooltip: 'Pin file to context',
                        onPressed: () => _pinDialog(context),
                      ),
                      if (sttConfig.configured)
                        _toolBtn(
                          Icons.settings_voice_outlined,
                          tooltip: 'Voice settings (STT)',
                          onPressed: () => SttConfigDialog.show(context),
                        ),
                    ],
                    const Spacer(),
                    // `.oc-submit-hint` — keyboard hints never render on
                    // compact (touch) or dense (two-row split) layouts.
                    if (!compact && !widget.dense)
                      _SubmitHint(
                        text: canQueueDraft
                            ? state.queue.isNotEmpty
                                  ? 'Enter to update queued message'
                                  : 'Enter to queue your next message'
                            : 'Enter to send • / commands',
                        faded: hasDraft && !canQueueDraft,
                      ),
                    Flexible(
                      // Single line — a Wrap here pushed the trailing icon
                      // buttons onto a second row under the composer.
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        reverse: true,
                        child: optionBar,
                      ),
                    ),
                    _SendButton(
                      arg: _arg,
                      state: state,
                      sessionId: widget.sessionId,
                      onSend: _send,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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

  Future<void> _pinDialog(BuildContext context) async {
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
      ref.read(composerProvider(_arg).notifier).pinFile(path.trim());
    }
  }

  /// `MobileComposerActionSheet` parity — compact panes collapse the
  /// toolbar under `+`.
  void _showActionSheet(BuildContext context, Widget child) {
    final sttConfigured = ref.read(sttConfigProvider).configured;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              dense: true,
              leading: const Icon(Icons.attach_file, size: 18),
              title: const Text('Attach file'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                unawaited(_pickFile());
              },
            ),
            if (sttConfigured)
              ListTile(
                dense: true,
                leading: const Icon(Icons.mic_none, size: 18),
                title: const Text('Voice input (STT)'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  unawaited(_toggleVoice());
                },
              ),
            const SizedBox(height: 4),
            child,
          ],
        ),
      ),
    );
  }
}

class _SendIntent extends Intent {
  const _SendIntent();
}

class _NewlineIntent extends Intent {
  const _NewlineIntent();
}

/// `PromptInputSubmit` — h-10 w-10 rounded-lg primary button with three
/// faces: send (`SendHorizonal`), stop while streaming with an empty draft
/// (filled square), queue while streaming with a draft (`ArrowUp`).
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
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final hasDraft =
        state.input.trim().isNotEmpty || state.attachments.isNotEmpty;
    final style = IconButton.styleFrom(
      fixedSize: const Size(40, 40),
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.borderLg),
      backgroundColor: primary,
      foregroundColor: onPrimary,
      disabledBackgroundColor: primary.withValues(alpha: 0.35),
    );
    if (running) {
      // canQueueDraft — the web swaps the stop square for an arrow that
      // enqueues the draft instead of aborting the run.
      if (hasDraft) {
        return IconButton.filled(
          style: style,
          icon: const Icon(Icons.arrow_upward, size: 16),
          tooltip: 'Queue next message',
          onPressed: onSend,
        );
      }
      return IconButton.filled(
        style: style,
        icon: const Icon(Icons.stop, size: 14),
        tooltip: 'Stop',
        onPressed: () => ref.read(composerProvider(arg).notifier).abort(),
      );
    }
    return IconButton.filled(
      style: style,
      icon: state.uploading
          ? SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: onPrimary,
              ),
            )
          : const Icon(Icons.send, size: 16),
      tooltip: 'Send',
      onPressed: hasDraft ? onSend : null,
    );
  }
}

/// `.oc-submit-hint` — `Enter to send • / commands`, truncating at max-w-56,
/// fading out while the draft is non-empty (web keeps the slot).
class _SubmitHint extends StatelessWidget {
  const _SubmitHint({required this.text, required this.faded});

  final String text;
  final bool faded;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: faded ? 0 : 1,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 224),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: 12,
            color: c.mutedForeground.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

/// `.oc-chip` — attachment chip inside the prompt box: subtle border, 4px
/// radius, thumb or kind tag, 22ch name, size, ×.
class _AttachmentChip extends StatelessWidget {
  const _AttachmentChip({required this.record, required this.onRemove});

  final Map<String, dynamic> record;
  final VoidCallback onRemove;

  static const _imageExts = {'png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp'};

  String get _name => '${record['name'] ?? record['filename'] ?? 'file'}';

  String get _mime => '${record['mimeType'] ?? record['type'] ?? ''}';

  bool get _isImage =>
      _mime.startsWith('image/') ||
      _imageExts.contains(_name.split('.').last.toLowerCase());

  /// File-type tag (`oc-chip-kind`) — the mime suffix or extension, 3 chars.
  String get _kind {
    final tail = _mime.contains('/') ? _mime.split('/').last : '';
    final raw = tail.isEmpty ? _name.split('.').last : tail;
    final tag = raw.toUpperCase();
    return tag.length <= 4 ? tag : tag.substring(0, 3);
  }

  String get _size {
    final n = record['size'];
    if (n is! num || n <= 0) return '';
    if (n >= 1 << 20) return '${(n / (1 << 20)).toStringAsFixed(1)} MB';
    if (n >= 1024) return '${(n / 1024).round()} KB';
    return '${n.round()} B';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final style = Theme.of(context).textTheme.bodySmall
        ?.copyWith(fontSize: 12, color: c.foreground);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3C3C3C)), // subtle
        borderRadius: AppRadii.borderSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          if (_isImage)
            Icon(Icons.image_outlined, size: 14, color: c.mutedForeground)
          else
            Text(
              _kind,
              style: style?.copyWith(
                fontSize: 10,
                color: const Color(0xFF56B6C2), // --oc-info
              ),
            ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160), // ~22ch
            child: Text(
              _name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
          if (_size.isNotEmpty)
            Text(_size, style: style?.copyWith(color: c.mutedForeground)),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close, size: 12, color: c.mutedForeground),
          ),
        ],
      ),
    );
  }
}

class _OptionBar extends ConsumerWidget {
  const _OptionBar({
    required this.arg,
    required this.state,
    required this.sessionId,
    required this.onAttach,
    required this.promptBoxKey,
    this.compact = false,
  });

  final ComposerArg arg;
  final ComposerState state;
  final String sessionId;
  final VoidCallback onAttach;
  final GlobalKey promptBoxKey;

  /// Touch layout: the web keeps the model chip and permission trigger in
  /// the footer and folds the rest into the mobile action sheet.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // `ComposerModelMenu` — chip + anchored popover (Reasoning /
        // Favorites / collapsible Model with pills + search). Always visible
        // so the composer mirrors the web's model chip even before the list
        // finishes loading.
        ComposerModelMenu(
          arg: arg,
          state: state,
          compact: compact,
          promptBoxKey: promptBoxKey,
        ),
        // `.oc-permission-trigger` — 32px icon button, active mode's icon,
        // opens the mode list (web ComposerPermissionMenu). Hidden when the
        // provider capability matrix reports no modes.
        if (state.permissionModes.isNotEmpty)
          _PermissionMenu(
            mode: state.permissionMode,
            modes: state.permissionModes,
            providerLabel: providerLabel(arg.provider),
            onSelect: (m) => ref
                .read(composerProvider(arg).notifier)
                .selectPermissionMode(m),
          ),
        // `ComposerAccountMenu` — the web shows the account pick only in the
        // new-session composer; an active chat's footer is model+permission.
        if (state.accounts.isNotEmpty && !compact && sessionId.isEmpty)
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
      ],
    );
  }
}

/// Web `ComposerPermissionMenu` — a 32×32 trigger carrying the active mode's
/// icon/tone; the menu lists the provider's capability modes.
class _PermissionMenu extends StatelessWidget {
  const _PermissionMenu({
    required this.mode,
    required this.modes,
    required this.providerLabel,
    required this.onSelect,
  });

  final String mode;
  final List<String> modes;
  final String providerLabel;
  final ValueChanged<String> onSelect;

  static const _labels = {
    'default': 'Default',
    'auto': 'Auto',
    'acceptEdits': 'Accept Edits',
    'bypassPermissions': 'Bypass Permissions',
    'plan': 'Plan',
  };

  /// MODE_APPEARANCE from ComposerPermissionMenu.tsx (icon + tone color) —
  /// the web pairs tones per brightness (`text-blue-700 dark:text-blue-300`),
  /// so [isDark] picks the matching stop instead of one mid constant.
  static (IconData, Color) _appearance(String mode, AppColors c, bool isDark) =>
      switch (mode) {
        'auto' => (
          LucideIcons.bot,
          isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8),
        ),
        'acceptEdits' => (
          LucideIcons.smile,
          isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
        ),
        'bypassPermissions' => (
          LucideIcons.triangleAlert,
          isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C),
        ),
        'plan' => (LucideIcons.clipboardList, c.primary),
        'default' => (LucideIcons.hand, c.mutedForeground),
        _ => (LucideIcons.shieldQuestion, c.mutedForeground),
      };

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (icon, tone) = _appearance(mode, c, isDark);
    final heading = 'How should $providerLabel actions be approved?';
    return PopupMenuButton<String>(
      tooltip: heading,
      onSelected: onSelect,
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          enabled: false,
          height: 28,
          child: Text(
            heading,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: c.mutedForeground,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        for (final m in modes)
          PopupMenuItem<String>(
            value: m,
            child: Row(
              spacing: 6,
              children: [
                Icon(
                  _appearance(m, c, isDark).$1,
                  size: 14,
                  color: _appearance(m, c, isDark).$2,
                ),
                Text(_labels[m] ?? m),
                if (m == mode) ...[
                  const Spacer(),
                  Icon(Icons.check, size: 14, color: c.primary),
                ],
              ],
            ),
          ),
      ],
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: tone.withValues(alpha: 0.4)),
          borderRadius: AppRadii.borderSm,
          color: tone.withValues(alpha: 0.08),
        ),
        child: Icon(icon, size: 16, color: tone),
      ),
    );
  }
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
    final c = context.appColors;
    final textStyle = Theme.of(context).textTheme.bodySmall
        ?.copyWith(fontSize: 11.5, color: c.mutedForeground);
    // `.oc-pill` — subtle border, 3px radius, h-7.
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3C3C3C)),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
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

/// Pinned-context strip — same `.oc-chip` shell as attachments, with a
/// push-pin glyph instead of the kind tag.
class _PinnedFilesBar extends ConsumerWidget {
  const _PinnedFilesBar({required this.files, required this.arg});

  final List<String> files;
  final ComposerArg arg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        for (final f in files)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF3C3C3C)),
              borderRadius: AppRadii.borderSm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 6,
              children: [
                Icon(Icons.push_pin, size: 12, color: c.primary),
                Tooltip(
                  message: f,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 160),
                    child: Text(
                      f.split('/').last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(fontSize: 12, color: c.foreground),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      ref.read(composerProvider(arg).notifier).unpinFile(f),
                  child: Icon(Icons.close, size: 12, color: c.mutedForeground),
                ),
              ],
            ),
          ),
      ],
    );
  }
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
