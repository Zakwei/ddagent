import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/chat/data/chat_drop.dart';
import 'package:ddagent_app/features/chat/state/composer_controller.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:ddagent_app/features/chat/view/activity_indicator.dart';
import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
import 'package:ddagent_app/features/chat/view/command_result_dialog.dart';
import 'package:ddagent_app/features/chat/view/composer_command_menu.dart';
import 'package:ddagent_app/features/chat/view/composer_model_menu.dart';
import 'package:ddagent_app/features/chat/view/composer_permission_menu.dart';
import 'package:ddagent_app/features/git/state/checkpoint_controller.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/voice/state/stt_controller.dart';
import 'package:ddagent_app/features/voice/state/tts_controller.dart';
import 'package:ddagent_app/features/voice/view/stt_config_dialog.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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
    this.initialAccountId,
    this.dense = false,
    this.focusNode,
    super.key,
  });

  final String sessionId;
  final String? projectId;
  final String? projectPath;
  final String provider;

  /// Account picked in the new-chat dialog for a draft session — selected once
  /// on mount so the first send runs under it.
  final String? initialAccountId;

  /// `[data-split-rows="2"]` parity — slimmed-down composer: the submit
  /// hint never renders and outer spacing shrinks.
  final bool dense;

  /// External focus node — the transcript hands its hover-focus node over
  /// so `focusFollowsPointer` can target this field (web `textareaRef`).
  final FocusNode? focusNode;

  @override
  ConsumerState<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends ConsumerState<ChatComposer> {
  final _input = TextEditingController();
  late final _focus = widget.focusNode ?? FocusNode();
  final _promptBoxKey = GlobalKey();
  List<Map<String, String>> _mentions = const [];

  /// Number of live composers; with several panes only the focused one should
  /// claim a document-level paste/drop, and with one it always does.
  static int _mounted = 0;
  void Function()? _detachFileInputs;

  /// `/` and `@` pickers render as overlays anchored above the prompt box —
  /// the web portals them so opening never shifts the composer. Both keep a
  /// selected index driven by arrow keys (web `selectedCommandIndex` /
  /// `selectedMentionIndex` parity).
  OverlayEntry? _slashEntry;
  OverlayEntry? _mentionEntry;
  final _slashTick = ValueNotifier<int>(0);
  final _mentionTick = ValueNotifier<int>(0);
  int _slashIndex = -1;
  int _mentionIndex = -1;
  final _slashSelKey = GlobalKey();
  final _mentionSelKey = GlobalKey();

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
    // Arrow/Enter/Tab/Escape drive the `/` and `@` pickers before the
    // Shortcuts ancestor can claim Enter for send.
    _focus.onKeyEvent = _onComposerKey;
    _mounted++;
    _detachFileInputs = listenForChatFileInputs(_onDroppedFile);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final text = ref.read(composerProvider(_arg)).input;
      if (text.isNotEmpty && _input.text != text) _input.text = text;
      // Draft account chosen in the new-chat dialog — pin it once so the first
      // send carries `accountId` (the load may still be in flight; `_init`
      // preserves the selection when the accounts list lands).
      final initialAccountId = widget.initialAccountId;
      if (initialAccountId != null && ref.read(composerProvider(_arg)).accountId == null) {
        ref.read(composerProvider(_arg).notifier).selectAccount(initialAccountId);
      }
    });
  }

  @override
  void dispose() {
    _mounted--;
    _detachFileInputs?.call();
    _slashEntry?.remove();
    _mentionEntry?.remove();
    _slashTick.dispose();
    _mentionTick.dispose();
    _input.dispose();
    if (widget.focusNode == null) _focus.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    ref.read(composerProvider(_arg).notifier).setInput(v);
    _syncSlash();
    final q = _mentionQuery;
    if (q == null) {
      _closeMention();
    } else {
      unawaited(_searchMentions(q));
    }
    setState(() {});
  }

  /* ── `/` slash commands (`useSlashCommands` + `CommandMenu` parity) ── */

  /// The `/query` token right before the cursor — web regex
  /// `(?:^|\s)(/\S*)$` on the text before the caret, plus the code-block
  /// guard (an odd count of ``` fences suppresses the menu).
  RegExpMatch? get _slashMatch {
    final sel = _input.selection.baseOffset;
    if (sel < 0 || sel > _input.text.length) return null;
    final before = _input.text.substring(0, sel);
    if ('```'.allMatches(before).length.isOdd) return null;
    return RegExp(r'(?:^|\s)(/\S*)$').firstMatch(before);
  }

  bool get _slashOpen => _slashMatch != null;

  String get _slashQuery => _slashMatch?.group(1)?.substring(1) ?? '';

  /// `filterSlashCommands` — `/prefix` matches first; a `:` query or a hit
  /// keeps prefix-only semantics, else name substring, else description.
  List<Map<String, dynamic>> _filteredCommands(List<Map<String, dynamic>> cmds) {
    final q = _slashQuery.trim().toLowerCase();
    if (q.isEmpty) return cmds;
    final prefix = q.startsWith('/') ? q : '/$q';
    final namePrefix = [
      for (final c in cmds)
        if ('${c['name']}'.toLowerCase().startsWith(prefix)) c,
    ];
    if (q.contains(':') || namePrefix.isNotEmpty) return namePrefix;
    final nameSub = [
      for (final c in cmds)
        if ('${c['name']}'.toLowerCase().contains(q)) c,
    ];
    if (nameSub.isNotEmpty) return nameSub;
    return [
      for (final c in cmds)
        if ('${c['description'] ?? ''}'.toLowerCase().contains(q)) c,
    ];
  }

  /// Top-5 commands by per-project usage (`command_history_<projectId>`),
  /// deduplicated out of the regular groups by `SlashCommandList`.
  List<Map<String, dynamic>> _frequentCommands(List<Map<String, dynamic>> cmds) {
    if (cmds.isEmpty) return const [];
    final history = ref.read(composerProvider(_arg).notifier).commandUsageHistory();
    final used = [
      for (final c in cmds)
        if ((history['${c['name']}'] ?? 0) > 0) (c, history['${c['name']}']!),
    ]..sort((a, b) => b.$2.compareTo(a.$2));
    return [for (final e in used.take(5)) e.$1];
  }

  void _syncSlash() {
    if (!_slashOpen) {
      _closeSlash();
      return;
    }
    // Web resets the selection on every query change.
    _slashIndex = -1;
    if (_slashEntry == null) {
      _slashEntry = composerPopoverEntry(
        triggerContext: context,
        promptBoxKey: _promptBoxKey,
        onDismiss: _closeSlash,
        rebuildable: _slashTick,
        builder: (ctx) => Consumer(
          builder: (ctx, ref, _) {
            final cmds = ref.watch(composerProvider(_arg)).slashCommands;
            return SlashCommandList(
              commands: _filteredCommands(cmds),
              frequent: _frequentCommands(cmds),
              selectedIndex: _slashIndex,
              selectedRowKey: _slashSelKey,
              onHover: (i) {
                _slashIndex = i;
                _slashTick.value++;
              },
              onSelect: _selectSlashCommand,
            );
          },
        ),
      );
      Overlay.of(context).insert(_slashEntry!);
    } else {
      _slashTick.value++;
    }
  }

  void _closeSlash() {
    _slashEntry?.remove();
    _slashEntry = null;
    _slashIndex = -1;
  }

  /// Click/Enter selection — `isSkillCommand` inserts the command into the
  /// input, everything else executes through `/api/commands/execute`.
  Future<void> _selectSlashCommand(int i) async {
    final t = Translations.of(context);
    final cmds = _filteredCommands(ref.read(composerProvider(_arg)).slashCommands);
    if (i < 0 || i >= cmds.length) return;
    final c = cmds[i];
    ref.read(composerProvider(_arg).notifier).trackCommandUsage('${c['name']}');
    _closeSlash();
    if (isSkillCommand(c)) {
      _insertSlashCommand(c);
      return;
    }
    // Web `executeCommand`: args come from the text after the command name
    // (`$ARGUMENTS`/`$1` substitute server-side), and `/cost` reads the
    // session's live token budget off `context.tokenUsage`.
    final nameMatch = RegExp('${RegExp.escape('${c['name']}')}\\s*(.*)').firstMatch(_input.text);
    final args = (nameMatch?.group(1)?.trim().split(RegExp(r'\s+')) ?? const <String>[])
        .where((a) => a.isNotEmpty)
        .toList();
    final result = await ref
        .read(composerProvider(_arg).notifier)
        .executeCommand(c, args, tokenUsage: _tokenUsageMap());
    if (!mounted) return;
    if (result.builtin) {
      _handleBuiltinResult(result);
      _focus.requestFocus();
      return;
    }
    final prompt = result.prompt;
    if (prompt == null) {
      _focus.requestFocus();
      return;
    }
    // Web `handleCustomCommand`: the expanded prompt lands in the input and
    // auto-sends — a `!` bash body gates that behind window.confirm first.
    if (result.hasBashCommands) {
      final confirmed = await AppDialog.confirm(
        context,
        title: t.chat.commands.runConfirmTitle,
        message:
            'This command contains bash commands that will be executed. Do you want to proceed?',
        confirmLabel: 'Proceed',
      );
      if (!mounted) return;
      if (!confirmed) {
        AppToast.show(context, t.chat.commands.executionCancelled);
        _focus.requestFocus();
        return;
      }
    }
    _input.value = TextEditingValue(
      text: prompt,
      selection: TextSelection.collapsed(offset: prompt.length),
    );
    _onChanged(prompt);
    // `_send` no-ops without a bound session — the draft composer just keeps
    // the prefilled text (checkpoint + queue-when-running still apply).
    if (widget.sessionId.isNotEmpty) unawaited(_send());
    _focus.requestFocus();
  }

  /// Web `handleBuiltInCommand`: help/models/cost/status open the result
  /// dialog; `/memory` toasts the outcome and opens CLAUDE.md in the editor
  /// when it exists; `/config` navigates to settings.
  void _handleBuiltinResult(CommandExecutionResult result) {
    final router = GoRouter.maybeOf(context);
    switch (result.action) {
      case 'help' || 'models' || 'cost' || 'status':
        unawaited(showCommandResultDialog(context, result: result, arg: _arg));
      case 'memory':
        final data = result.data;
        final message = data['message']?.toString();
        if (data['error'] != null) {
          AppToast.error(context, message ?? '${data['error']}');
          return;
        }
        if (message != null && message.isNotEmpty) {
          AppToast.show(context, message);
        }
        final path = data['path']?.toString();
        final projectId = widget.projectId;
        if (data['exists'] == true && path != null && path.isNotEmpty && projectId != null) {
          router?.go('/editor?projectId=$projectId&file=${Uri.encodeComponent(path)}');
        }
      case 'config':
        router?.go('/settings');
    }
  }

  /// `insertCommandIntoInput` — the command name lands where the `/query`
  /// token started; trailing text after the next space is preserved.
  void _insertSlashCommand(Map<String, dynamic> c) {
    final v = _input.text;
    final sel = _input.selection.baseOffset;
    final ext = _input.selection.extentOffset;
    final m = _slashMatch;
    final slashPos = m != null
        ? m.start + (m.group(0)!.length - m.group(1)!.length)
        : (sel >= 0 ? sel : v.length);
    final before = v.substring(0, slashPos);
    final rest = v.substring(slashPos);
    final sp = rest.indexOf(' ');
    final after = (m != null && sp != -1)
        ? rest.substring(sp).trimLeft()
        : v.substring(ext >= 0 && ext <= v.length ? ext : slashPos);
    final sep = before.isNotEmpty && !before.endsWith(' ') ? ' ' : '';
    final name = '${c['name']}';
    final next = '$before$sep$name${after.isNotEmpty ? ' $after' : ' '}';
    _input.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: '$before$sep$name '.length),
    );
    _onChanged(next);
    _focus.requestFocus();
  }

  /* ── `@` mentions (`useMentions` parity) ── */

  /// The `@query` before the cursor — any '@' opens the picker and the query
  /// may contain spaces (multi-word titles stay searchable); a newline ends
  /// it. Web `useMentions` semantics.
  String? get _mentionQuery {
    final sel = _input.selection.baseOffset;
    if (sel < 0 || sel > _input.text.length) return null;
    final before = _input.text.substring(0, sel);
    final at = before.lastIndexOf('@');
    if (at < 0) return null;
    final after = before.substring(at + 1);
    return after.contains('\n') ? null : after;
  }

  Future<void> _searchMentions(String q) async {
    final res = await ref.read(composerProvider(_arg).notifier).mentions(q);
    if (!mounted || _mentionQuery != q) return;
    _mentions = res;
    // The web only renders the dropdown when it has rows
    // (`showMentionDropdown && filteredMentions.length > 0`).
    if (res.isEmpty) {
      _closeMention();
      return;
    }
    _mentionIndex = -1;
    if (_mentionEntry == null) {
      _mentionEntry = composerPopoverEntry(
        triggerContext: context,
        promptBoxKey: _promptBoxKey,
        onDismiss: _closeMention,
        rebuildable: _mentionTick,
        mention: true,
        builder: (ctx) => MentionMenuList(
          items: _mentions,
          selectedIndex: _mentionIndex,
          selectedRowKey: _mentionSelKey,
          onHover: (i) {
            _mentionIndex = i;
            _mentionTick.value++;
          },
          onSelect: _selectMention,
        ),
      );
      Overlay.of(context).insert(_mentionEntry!);
    } else {
      _mentionTick.value++;
    }
  }

  void _closeMention() {
    _mentionEntry?.remove();
    _mentionEntry = null;
    _mentionIndex = -1;
  }

  void _selectMention(int i) {
    if (i < 0 || i >= _mentions.length) return;
    final insert = _mentions[i]['insert'] ?? '@${_mentions[i]['value'] ?? ''}';
    // `selectMention` — the query runs from '@' to the cursor (it may span
    // words), so it is replaced verbatim, not word-wise.
    final v = _input.text;
    final sel = _input.selection.baseOffset;
    final upto = sel >= 0 ? v.substring(0, sel) : v;
    final rest = sel >= 0 ? v.substring(sel) : '';
    final at = upto.lastIndexOf('@');
    if (at < 0) return;
    final before = upto.substring(0, at);
    final value = insert.startsWith('@') ? insert : '@$insert';
    _input.value = TextEditingValue(
      text: '$before$value $rest',
      selection: TextSelection.collapsed(offset: before.length + value.length + 1),
    );
    _closeMention();
    _onChanged(_input.text);
    _focus.requestFocus();
  }

  /// ArrowUp/Down cycle the open picker (wrapping), Tab/Enter pick the
  /// selected or first row, Escape closes. Runs on the input's FocusNode so
  /// it fires before the send Shortcut.
  KeyEventResult _onComposerKey(FocusNode node, KeyEvent e) {
    if (e is! KeyDownEvent) return KeyEventResult.ignored;
    final slash = _slashEntry != null;
    final mention = _mentionEntry != null;
    if (!slash && !mention) return KeyEventResult.ignored;
    final key = e.logicalKey;
    if (key == LogicalKeyboardKey.escape) {
      if (slash) {
        _closeSlash();
        return KeyEventResult.handled;
      }
      // Web parity: an empty mention list does not swallow Escape.
      if (_mentions.isNotEmpty) {
        _closeMention();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    final count = slash
        ? _filteredCommands(ref.read(composerProvider(_arg)).slashCommands).length
        : _mentions.length;
    if (count == 0) return KeyEventResult.ignored;
    final index = slash ? _slashIndex : _mentionIndex;
    int next;
    if (key == LogicalKeyboardKey.arrowDown) {
      next = index < count - 1 ? index + 1 : 0;
    } else if (key == LogicalKeyboardKey.arrowUp) {
      next = index > 0 ? index - 1 : count - 1;
    } else if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.tab) {
      if (slash) {
        unawaited(_selectSlashCommand(index >= 0 ? index : 0));
      } else {
        _selectMention(index >= 0 ? index : 0);
      }
      return KeyEventResult.handled;
    } else {
      return KeyEventResult.ignored;
    }
    if (slash) {
      _slashIndex = next;
      _slashTick.value++;
      _scrollIntoView(_slashSelKey, down: next > index);
    } else {
      _mentionIndex = next;
      _mentionTick.value++;
      _scrollIntoView(_mentionSelKey, down: next > index);
    }
    return KeyEventResult.handled;
  }

  /// `scrollIntoView({block: 'nearest'})` — keeps the selected row visible;
  /// already-visible rows don't move.
  void _scrollIntoView(GlobalKey key, {required bool down}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = key.currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        alignmentPolicy: down
            ? ScrollPositionAlignmentPolicy.keepVisibleAtEnd
            : ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      );
    });
  }

  /// Live `tokenBudget` snapshot passed as `context.tokenUsage` — `/cost`
  /// and the action-sheet token row read it (web `context.tokenUsage`).
  Map<String, dynamic>? _tokenUsageMap() {
    final sid = widget.sessionId;
    if (sid.isEmpty) return null;
    final usage = ref.read(contextUsageProvider(sid));
    if (usage == null) return null;
    return {
      'used': usage.used,
      'total': usage.total,
      'inputTokens': usage.input,
      'outputTokens': usage.output,
      'cacheReadTokens': usage.cacheRead,
      'cacheCreationTokens': usage.cacheCreation,
    };
  }

  /// `Take photo` — the web's `<input capture="environment">`. image_picker
  /// opens the camera on Android/iOS and a file chooser on web; the row is
  /// hidden on desktop builds (no camera source there).
  bool get _cameraSupported =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  Future<void> _takePhoto() async {
    try {
      final x = await ImagePicker().pickImage(source: ImageSource.camera);
      if (x == null) return;
      final bytes = await x.readAsBytes();
      await ref.read(composerProvider(_arg).notifier).attach(x.name, bytes, isImage: true);
    } on Object catch (e) {
      if (mounted) {
        AppToast.error(context, Translations.of(context).chat.input.cameraUnavailable(error: e));
      }
    }
  }

  /// Token-usage sheet row — the same `/cost` builtin the web's
  /// `onShowTokenUsage` (→ `showCostModal`) opens.
  Future<void> _showTokenUsage() async {
    final result = await ref
        .read(composerProvider(_arg).notifier)
        .executeCommand(
          const {'name': 'cost'},
          const [],
          preserveInput: true,
          tokenUsage: _tokenUsageMap(),
        );
    if (!mounted || !result.builtin) return;
    _handleBuiltinResult(result);
  }

  Future<void> _pickFile() async {
    final f = (await FilePicker.pickFiles()).firstOrNull;
    if (f == null) return;
    final bytes = await f.xFile.readAsBytes();
    await ref
        .read(composerProvider(_arg).notifier)
        .attach(f.name, bytes, isImage: _isImageName(f.name));
  }

  /// Browser paste/drop — Flutter's web engine never surfaces these to the
  /// framework, so the listener in `chat_drop.dart` reads them off the DOM.
  void _onDroppedFile(DroppedFile file) {
    if (!mounted) return;
    // With several panes open, only the focused composer claims the file.
    if (_mounted > 1 && !_focus.hasFocus) return;
    unawaited(
      ref
          .read(composerProvider(_arg).notifier)
          .attach(file.name, file.bytes, isImage: _isImageName(file.name)),
    );
  }

  static const _imageExts = {'png', 'jpg', 'jpeg', 'gif', 'webp', 'bmp', 'avif'};
  static bool _isImageName(String name) => _imageExts.contains(name.split('.').last.toLowerCase());

  Future<void> _send() async {
    // Snapshot before every AI turn so the whole turn can be undone (web
    // `handleBeforeSend` → `createCheckpoint('before AI turn')`). Best-effort:
    // a failed snapshot must not block the send.
    final t = Translations.of(context);
    final projectId = widget.projectId;
    if (projectId != null) {
      unawaited(
        ref
            .read(checkpointProvider(projectId).notifier)
            .create(label: t.chat.checkpoint.beforeAiTurn),
      );
    }
    final running = ref.read(transcriptProvider(widget.sessionId)).runStatus == 'running';
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
    final t = Translations.of(context);
    final state = ref.watch(composerProvider(_arg));
    final sttConfig = ref.watch(sttConfigProvider);
    final voiceState = ref.watch(voiceInputProvider);
    final compact = context.breakpoint.isCompact;
    final c = context.appColors;
    final cs = Theme.of(context).colorScheme;
    final projectId = widget.projectId;
    if (_input.text != state.input) {
      _input.value = TextEditingValue(
        text: state.input,
        selection: TextSelection.collapsed(offset: state.input.length),
      );
      // Programmatic input (draft restore, command prompt, queued message)
      // still has to open/close the `/` picker — deferred, Overlay.insert
      // can't run mid-build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _syncSlash();
      });
    }

    final running =
        ref.watch(transcriptProvider(widget.sessionId).select((s) => s.runStatus)) == 'running';
    final offlineCount = ref.watch(
      transcriptProvider(widget.sessionId).select((s) => s.offlineCount),
    );
    final sendByCtrlEnter = ref.watch(uiPreferencesProvider.select((p) => p.sendByCtrlEnter));
    final hasDraft = state.input.trim().isNotEmpty || state.attachments.isNotEmpty;
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
        // `OfflineQueueCard` — messages parked in Hive while the socket is
        // down; they flush automatically on reconnect (transcript controller).
        if (offlineCount > 0)
          _OfflineQueueCard(
            count: offlineCount,
            onClear: () => unawaited(
              ref.read(transcriptProvider(widget.sessionId).notifier).clearOfflineQueue(),
            ),
          ),
        if (state.queue.isNotEmpty) _QueueCard(arg: _arg, queue: state.queue),
        // `.chat-activity-tab` — spinner + rotating label + elapsed + Stop,
        // pinned above the prompt box while the session is processing
        // (web `ActivityIndicator`, rendered from ChatComposer).
        ActivityIndicator(sessionId: widget.sessionId),
        // The `/` and `@` pickers live in overlay entries (see `_syncSlash` /
        // `_searchMentions`) — the web portals them, so they float above the
        // transcript instead of pushing the composer down.
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
                          onRemove: () =>
                              ref.read(composerProvider(_arg).notifier).removeAttachment(i),
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
                    // useChatComposerState keymap: Ctrl/Cmd+Enter always
                    // sends; plain Enter sends only when `sendByCtrlEnter`
                    // is off — with it on, Enter is a newline like
                    // Shift+Enter.
                    shortcuts: {
                      const SingleActivator(LogicalKeyboardKey.enter, control: true):
                          const _SendIntent(),
                      const SingleActivator(LogicalKeyboardKey.enter, meta: true):
                          const _SendIntent(),
                      if (sendByCtrlEnter)
                        const SingleActivator(LogicalKeyboardKey.enter): const _NewlineIntent()
                      else
                        const SingleActivator(LogicalKeyboardKey.enter): const _SendIntent(),
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
                        // Sans body copy, readable at the composer; code
                        // tools/output opt into mono at their own call sites.
                        style: const TextStyle(fontSize: 14, height: 1.5),
                        onChanged: _onChanged,
                        contentInsertionConfiguration: ContentInsertionConfiguration(
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
                          hintText: t.chat.input.placeholder(
                            provider: providerLabel(widget.provider),
                          ),
                          hintStyle: TextStyle(color: c.mutedForeground.withValues(alpha: 0.5)),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          // px-4 py-2 + pl-7 (the `>` caret column).
                          contentPadding: const EdgeInsets.fromLTRB(28, 8, 16, 8),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  spacing: 4,
                  children: [
                    if (compact)
                      _toolBtn(
                        Icons.add,
                        tooltip: t.chat.input.moreTools,
                        onPressed: () => _showActionSheet(context, optionBar),
                      )
                    else ...[
                      // Web `PromptInputTools` order: attach → auto-read →
                      // mic → checkpoint; the two Flutter-only extras (pin,
                      // STT settings) trail so the web controls stay in place.
                      _toolBtn(
                        Icons.attach_file,
                        tooltip: t.chat.input.attachFiles,
                        onPressed: _pickFile,
                      ),
                      if (widget.sessionId.isNotEmpty) _AutoReadButton(sessionId: widget.sessionId),
                      if (sttConfig.configured)
                        _toolBtn(
                          voiceState.isRecording ? Icons.mic : Icons.mic_none,
                          tooltip: voiceState.isRecording
                              ? t.chat.input.voiceStop
                              : t.chat.input.voiceStart,
                          color: voiceState.isRecording ? cs.error : null,
                          onPressed: voiceState.isProcessing ? null : _toggleVoice,
                          child: voiceState.isProcessing
                              ? const SizedBox.square(
                                  dimension: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : null,
                        ),
                      if (projectId != null) _CheckpointButton(projectId: projectId),
                      _toolBtn(
                        Icons.push_pin_outlined,
                        tooltip: t.chat.input.pinFile,
                        onPressed: () => _pinDialog(context),
                      ),
                      if (sttConfig.configured)
                        _toolBtn(
                          Icons.settings_voice_outlined,
                          tooltip: t.chat.input.voiceSettings,
                          onPressed: () => SttConfigDialog.show(context),
                        ),
                    ],
                    // Hint + option bar form one end-aligned flexible group:
                    // a single tight Expanded absorbs the free space on the
                    // left so the submit button always lands on the row's
                    // right inner edge regardless of pane width.
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        spacing: 4,
                        children: [
                          // `.oc-submit-hint` — keyboard hints never render
                          // on compact (touch) or dense (two-row split)
                          // layouts; Flexible so a narrow pane shrinks it
                          // instead of pushing the submit button out.
                          if (!compact && !widget.dense)
                            Flexible(
                              child: _SubmitHint(
                                text: canQueueDraft
                                    ? state.queue.isNotEmpty
                                          ? t.chat.input.hintText.updateQueued
                                          : t.chat.input.hintText.queue
                                    : sendByCtrlEnter
                                    ? t.chat.input.hintText.ctrlEnter
                                    : t.chat.input.hintText.enter,
                                faded: hasDraft && !canQueueDraft,
                              ),
                            ),
                          Flexible(
                            // Single line — a Wrap here pushed the trailing
                            // icon buttons onto a second row under the
                            // composer.
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              reverse: true,
                              child: optionBar,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _SendButton(
                      key: const ValueKey('composer-send'),
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
            child: Text(state.sendError!, style: TextStyle(color: cs.error, fontSize: 12)),
          ),
      ],
    );
  }

  Future<void> _pinDialog(BuildContext context) async {
    final t = Translations.of(context);
    final c = TextEditingController();
    final path = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.chat.pinFile.title),
        content: TextField(
          controller: c,
          autofocus: true,
          decoration: InputDecoration(hintText: t.chat.pinFile.pathHint),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.chat.orchestrator.summary.cancelTasks),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, c.text),
            child: Text(t.chat.pinFile.action),
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
    // The sheet is a route on top of the window and does not move with the
    // keyboard, so with the composer still focused it would open behind the
    // keyboard — hiding the option bar (model/mode triggers) it re-hosts.
    // Dropping focus closes the keyboard first, like the web sheet does.
    _focus.unfocus();
    final t = Translations.of(context);
    final sttConfigured = ref.read(sttConfigProvider).configured;
    final commandCount = ref.read(composerProvider(_arg)).slashCommands.length;
    final hasInput = _input.text.trim().isNotEmpty;
    final usage = widget.sessionId.isEmpty
        ? null
        : ref.read(contextUsageProvider(widget.sessionId));
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
              title: Text(t.chat.input.attachFiles),
              subtitle: Text(t.chat.input.attachFilesDesc),
              onTap: () {
                Navigator.of(sheetContext).pop();
                unawaited(_pickFile());
              },
            ),
            if (_cameraSupported)
              ListTile(
                dense: true,
                leading: const Icon(Icons.photo_camera_outlined, size: 18),
                title: Text(t.chat.input.takePhoto),
                subtitle: Text(t.chat.input.takePhotoDesc),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  unawaited(_takePhoto());
                },
              ),
            if (sttConfigured)
              ListTile(
                dense: true,
                leading: const Icon(Icons.mic_none, size: 18),
                title: Text(t.chat.input.voice),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  unawaited(_toggleVoice());
                },
              ),
            // Slash-commands row with the catalog count badge; tapping it
            // seeds '/' so the command menu opens over the composer.
            ListTile(
              dense: true,
              leading: const Icon(Icons.chat_bubble_outline, size: 18),
              title: Row(
                spacing: 6,
                children: [
                  Flexible(child: Text(t.chat.input.showAllCommands)),
                  if (commandCount > 0) _SheetBadge(label: '$commandCount'),
                ],
              ),
              subtitle: Text(t.chat.input.commandsDesc),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _input.text = '/';
                _onChanged('/');
                _focus.requestFocus();
              },
            ),
            if (usage != null)
              ListTile(
                dense: true,
                leading: const Icon(Icons.bar_chart, size: 18),
                title: Row(
                  spacing: 6,
                  children: [
                    Flexible(child: Text(t.chat.tokenUsage.title)),
                    _SheetBadge(label: usage.unsupported ? 'N/A' : '${usage.used.round()} tokens'),
                  ],
                ),
                subtitle: Text(t.chat.tokenUsage.desc),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  unawaited(_showTokenUsage());
                },
              ),
            if (hasInput)
              ListTile(
                dense: true,
                leading: const Icon(Icons.close, size: 18),
                title: Text(t.chat.input.clearInput),
                subtitle: Text(t.chat.input.clearInputDesc),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  ref.read(composerProvider(_arg).notifier).setInput('');
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

/// Small count chip used by the action-sheet rows (slash-command count,
/// token total) — the web's rounded primary badge.
class _SheetBadge extends StatelessWidget {
  const _SheetBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
    decoration: BoxDecoration(
      color: context.appColors.primary.withValues(alpha: 0.12),
      borderRadius: AppRadii.borderSm,
    ),
    child: Text(label, style: TextStyle(fontSize: 10, color: context.appColors.primary)),
  );
}

class _SendIntent extends Intent {
  const _SendIntent();
}

class _NewlineIntent extends Intent {
  const _NewlineIntent();
}

/// Web `AudioLines` toggle — arms "read replies aloud" for the session and
/// shows the armed state (accent glyph) in the tools cluster.
class _AutoReadButton extends ConsumerWidget {
  const _AutoReadButton({required this.sessionId});

  final String sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final armed = ref.watch(ttsControllerProvider.select((s) => s.isArmed(sessionId)));
    final c = context.appColors;
    return _ChatComposerState._toolBtn(
      Icons.graphic_eq,
      tooltip: armed ? t.chat.voice.autoReadOn : t.chat.voice.autoReadOff,
      color: armed ? c.primary : null,
      onPressed: () => ref.read(ttsControllerProvider.notifier).toggleAutoRead(sessionId),
    );
  }
}

/// Web `CheckpointButton` — "Undo AI run": restores the working tree to the
/// snapshot taken before the last turn. Hidden until a snapshot exists;
/// shows "Undo AI run" / "Undoing…" / "Undone".
class _CheckpointButton extends ConsumerWidget {
  const _CheckpointButton({required this.projectId});

  final String projectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final st = ref.watch(checkpointProvider(projectId));
    final ctrl = ref.read(checkpointProvider(projectId).notifier);
    if (!st.hasCheckpoint && !st.creating) return const SizedBox.shrink();
    final cs = Theme.of(context).colorScheme;
    final restored = st.undo == UndoState.restored;
    final restoring = st.undo == UndoState.restoring;
    return _ChatComposerState._toolBtn(
      restored ? Icons.check : Icons.rotate_left,
      tooltip: restored
          ? t.chat.checkpoint.undone
          : (restoring ? t.chat.checkpoint.undoing : t.chat.checkpoint.undoAiRun),
      color: restored ? cs.primary : null,
      onPressed: st.creating || restoring
          ? null
          : () async {
              await ctrl.undoLast();
              if (!context.mounted) return;
              // Another pane left a newer checkpoint — restoring ours would
              // also revert that work, so confirm first (web parity).
              if (ref.read(checkpointProvider(projectId)).error == 'newer-checkpoint') {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    content: Text(t.chat.checkpoint.revertChanges),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(t.chat.orchestrator.summary.cancelTasks),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(t.chat.checkpoint.undoAiRun),
                      ),
                    ],
                  ),
                );
                if (ok == true) {
                  ctrl.clearError();
                  await ctrl.forceUndo();
                } else {
                  ctrl.clearError();
                }
              }
            },
    );
  }
}

/// `PromptInputSubmit` — h-10 w-10 rounded-lg primary button with three
/// faces: send (`SendHorizonal`), stop while streaming with an empty draft
/// (filled square), queue while streaming with a draft (`ArrowUp`).
class _SendButton extends ConsumerWidget {
  const _SendButton({
    super.key,
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
    final t = Translations.of(context);
    final running =
        ref.watch(transcriptProvider(sessionId).select((s) => s.runStatus)) == 'running';
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;
    final hasDraft = state.input.trim().isNotEmpty || state.attachments.isNotEmpty;
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
          tooltip: t.chat.input.queue.sendNext,
          onPressed: onSend,
        );
      }
      return IconButton.filled(
        style: style,
        icon: const Icon(Icons.stop, size: 14),
        tooltip: t.chat.input.stop,
        onPressed: () => ref.read(composerProvider(arg).notifier).abort(),
      );
    }
    return IconButton.filled(
      style: style,
      icon: state.uploading
          ? SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: onPrimary),
            )
          : const Icon(Icons.send, size: 16),
      tooltip: t.chat.input.send,
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
      // The text truncates at max-w-56 — the tooltip keeps the full hint
      // readable when it ellipsizes.
      child: Tooltip(
        message: text,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 224),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall
                ?.copyWith(fontSize: 12, color: c.mutedForeground.withValues(alpha: 0.5)),
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
      _mime.startsWith('image/') || _imageExts.contains(_name.split('.').last.toLowerCase());

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
            child: Text(_name, maxLines: 1, overflow: TextOverflow.ellipsis, style: style),
          ),
          if (_size.isNotEmpty) Text(_size, style: style?.copyWith(color: c.mutedForeground)),
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
    final t = Translations.of(context);
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // `ComposerModelMenu` — chip + anchored popover (Reasoning /
        // Favorites / collapsible Model with pills + search). Always visible
        // so the composer mirrors the web's model chip even before the list
        // finishes loading.
        ComposerModelMenu(arg: arg, state: state, compact: compact, promptBoxKey: promptBoxKey),
        // `.oc-permission-trigger` — 32px icon button, active mode's icon,
        // opens the mode list (web ComposerPermissionMenu). Hidden when the
        // provider capability matrix reports no modes.
        if (state.permissionModes.isNotEmpty)
          ComposerPermissionMenu(
            mode: state.permissionMode,
            modes: state.permissionModes,
            providerLabel: providerLabel(arg.provider),
            compact: compact,
            promptBoxKey: promptBoxKey,
            autoContinue: state.autoContinue,
            onToggleAutoContinue: () =>
                ref.read(composerProvider(arg).notifier).toggleAutoContinue(),
            onSelect: (m) => ref.read(composerProvider(arg).notifier).selectPermissionMode(m),
          ),
        // `ComposerAccountMenu` — the web shows the account pick only in the
        // new-session composer; an active chat's footer is model+permission.
        if (state.accounts.isNotEmpty && !compact && sessionId.isEmpty)
          _MiniDropdown(
            label: t.chat.composer.account,
            value: state.accountId,
            items: [null, for (final a in state.accounts) a.id],
            displayFor: (v) => v == null
                ? 'Auto'
                : state.accounts.where((a) => a.id == v).map((a) => a.label ?? a.id).firstOrNull ??
                      v,
            onChanged: (v) => ref.read(composerProvider(arg).notifier).selectAccount(v),
          ),
      ],
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
          hint: Text('$label: ${displayFor?.call(value) ?? value ?? 'auto'}', style: textStyle),
          selectedItemBuilder: (_) => [
            for (final it in items)
              Align(
                alignment: Alignment.centerLeft,
                child: Text('$label: ${displayFor?.call(it) ?? it ?? 'auto'}', style: textStyle),
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
                  onTap: () => ref.read(composerProvider(arg).notifier).unpinFile(f),
                  child: Icon(Icons.close, size: 12, color: c.mutedForeground),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// `QueuedMessageCard` list — one row per server-queued message: status
/// label, content preview, attachment count, send-now / edit / delete.
class _QueueCard extends ConsumerWidget {
  const _QueueCard({required this.arg, required this.queue});

  final ComposerArg arg;
  final List<Map<String, dynamic>> queue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    return Card(
      margin: const EdgeInsets.only(bottom: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final m in queue)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 4, 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  // Primary status dot (web's bg-primary/60 pip).
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c.primary.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 2,
                      children: [
                        Text(
                          m['status'] == 'failed'
                              ? '${t.chat.input.queue.label} · '
                                    '${t.chat.input.queue.failed}'
                              : '${t.chat.input.queue.label} · '
                                    '${t.chat.input.queue.willSend}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4,
                            color: c.primary.withValues(alpha: 0.7),
                          ),
                        ),
                        Text(
                          '${m['content']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                        if (_attachmentCount(m) > 0)
                          Text(
                            _attachmentCount(m) == 1
                                ? '1 file attached'
                                : '${_attachmentCount(m)} files attached',
                            style: TextStyle(fontSize: 11, color: c.mutedForeground),
                          ),
                      ],
                    ),
                  ),
                  _action(
                    Icons.send,
                    tooltip: t.chat.input.queue.sendNow,
                    // 'sending' disables send-now (web `isSending`).
                    onPressed: m['status'] == 'sending'
                        ? null
                        : () => ref.read(composerProvider(arg).notifier).sendNow('${m['id']}'),
                  ),
                  _action(
                    Icons.edit_outlined,
                    tooltip: t.chat.input.queue.edit,
                    onPressed: () =>
                        ref.read(composerProvider(arg).notifier).editQueued('${m['id']}'),
                  ),
                  _action(
                    Icons.close,
                    tooltip: t.chat.input.queue.delete,
                    onPressed: () =>
                        ref.read(composerProvider(arg).notifier).deleteQueued('${m['id']}'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Web `attachmentCount` — `options.attachments` list length on the row.
  static int _attachmentCount(Map<String, dynamic> m) {
    final options = m['options'];
    if (options is! Map) return 0;
    final attachments = options['attachments'];
    return attachments is List ? attachments.length : 0;
  }

  Widget _action(IconData icon, {required String tooltip, required VoidCallback? onPressed}) =>
      IconButton(
        icon: Icon(icon, size: 16),
        tooltip: tooltip,
        onPressed: onPressed,
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 30, height: 30),
      );
}

/// `OfflineQueueCard` — messages parked in Hive while the socket is down;
/// they flush automatically on reconnect. Amber dashed card + Cancel.
class _OfflineQueueCard extends StatelessWidget {
  const _OfflineQueueCard({required this.count, this.onClear});

  final int count;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    const amber = Color(0xFFB45309); // amber-700 (readable on both themes)
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF59E0B).withValues(alpha: 0.08),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
          style: BorderStyle.solid,
        ),
        borderRadius: AppRadii.borderMd,
      ),
      child: Row(
        spacing: 8,
        children: [
          const Icon(Icons.wifi_off, size: 16, color: amber),
          Expanded(
            child: Text(
              count == 1
                  ? t.chat.input.offlineQueue.single
                  : t.chat.input.offlineQueue.multiple(count: count),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: amber),
            ),
          ),
          if (onClear != null)
            TextButton.icon(
              icon: const Icon(Icons.close, size: 14, color: amber),
              label: Text(
                t.chat.input.offlineQueue.clearBtn,
                style: const TextStyle(fontSize: 12, color: amber),
              ),
              onPressed: onClear,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                visualDensity: VisualDensity.compact,
              ),
            ),
        ],
      ),
    );
  }
}
