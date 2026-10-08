import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/features/chat/state/pending_permissions.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:ddagent_app/features/commands/data/commands_repository.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/features/misc/data/misc_repository.dart';
import 'package:ddagent_app/features/provider_accounts/data/provider_accounts_repository.dart';
import 'package:ddagent_app/features/queue/data/queue_repository.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/settings/state/agent_permissions_controller.dart';
import 'package:ddagent_app/features/settings/state/locale_controller.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_repository.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Composer scope: the session being talked to (or the project for a new
/// chat pane) plus the provider it will send under.
typedef ComposerArg = ({
  String? sessionId,
  String? projectId,
  String provider,
  String? projectPath,
});

class ComposerState {
  const ComposerState({
    this.input = '',
    this.attachments = const [],
    this.uploading = false,
    this.models = const [],
    this.activeModel,
    this.effort,
    this.permissionMode = 'default',
    this.permissionModes = const [],
    this.supportsEffort = true,
    this.supportsLivePermissionMode = true,
    this.accounts = const [],
    this.accountId,
    this.queue = const [],
    this.favorites = const {},
    this.pinnedFiles = const [],
    this.slashCommands = const [],
    this.autoContinue = false,
    this.sendError,
  });

  final String input;
  final List<Map<String, dynamic>> attachments;
  final bool uploading;
  final List<Map<String, dynamic>> models;
  final String? activeModel;
  final String? effort;
  final String permissionMode;

  /// Modes the active provider accepts (backend capability matrix) — the
  /// permission menu hides entirely when the list is empty, web parity.
  final List<String> permissionModes;

  /// Capability flags (absent on older servers → assume supported).
  final bool supportsEffort;

  /// False when a mode change only applies from the next message.
  final bool supportsLivePermissionMode;
  final List<ProviderAccount> accounts;
  final String? accountId;
  final List<Map<String, dynamic>> queue;
  final Set<String> favorites;
  final List<String> pinnedFiles;
  final List<Map<String, dynamic>> slashCommands;

  /// `chat-auto-continue-tasks` — the web stores this toggle in localStorage;
  /// here it lives in the shared `settings` box under the same key.
  final bool autoContinue;
  final String? sendError;

  /// Provider-wide reasoning levels. The active model's own descriptor wins;
  /// when it carries no `effort` (or the catalog has not hydrated yet) these
  /// keep the composer's Reasoning section present for every agent, matching
  /// Command Code — the picker renders the same sections regardless of agent.
  static const _providerEffortValues = <String, List<String>>{
    'claude': ['low', 'medium', 'high', 'xhigh', 'max'],
    'codex': ['low', 'medium', 'high', 'xhigh', 'max', 'ultra'],
    'cursor': ['off', 'high', 'max'],
    'opencode': ['none', 'low', 'medium', 'high', 'xhigh', 'max'],
    'commandcode': ['off', 'high', 'max'],
    // The agy CLI accepts low|medium|high|max.
    'antigravity': ['low', 'medium', 'high', 'max'],
    'devin': ['low', 'medium', 'high', 'xhigh', 'max'],
  };

  /// Shared last resort — Command Code's own tiers — so an unknown provider
  /// still shows a Reasoning section instead of hiding it.
  static const _defaultEffortValues = ['off', 'high', 'max'];

  static List<String> _fallbackEffortValues(String provider) =>
      _providerEffortValues[provider] ?? _defaultEffortValues;

  /// Effort levels offered by the active model's descriptor (web parity:
  /// `ProviderModelOption.effort.values`), else the provider superset.
  List<String> effortValues(String provider) {
    if (!supportsEffort) return const [];
    for (final m in models) {
      if ((m['id'] ?? m['value']) == activeModel) {
        final vals = (m['effort'] as Map?)?['values'] as List?;
        final values = [for (final v in vals ?? const []) (v is Map ? v['value'] : v).toString()];
        if (values.isNotEmpty) return values;
        break;
      }
    }
    return _fallbackEffortValues(provider);
  }

  /// Like [effortValues] but keeps each descriptor's `description` — the web
  /// `ComposerModelMenu` shows it under the effort label.
  List<({String value, String? description})> effortOptions(String provider) {
    if (!supportsEffort) return const [];
    for (final m in models) {
      if ((m['id'] ?? m['value']) == activeModel) {
        final vals = (m['effort'] as Map?)?['values'] as List? ?? const [];
        final options = [
          for (final v in vals)
            v is Map
                ? (value: '${v['value']}', description: v['description']?.toString())
                : (value: '$v', description: null),
        ];
        if (options.isNotEmpty) return options;
        break;
      }
    }
    return [for (final v in _fallbackEffortValues(provider)) (value: v, description: null)];
  }

  ComposerState copyWith({
    String? input,
    List<Map<String, dynamic>>? attachments,
    bool? uploading,
    List<Map<String, dynamic>>? models,
    String? Function()? activeModel,
    String? Function()? effort,
    String? permissionMode,
    List<String>? permissionModes,
    bool? supportsEffort,
    bool? supportsLivePermissionMode,
    List<ProviderAccount>? accounts,
    String? Function()? accountId,
    List<Map<String, dynamic>>? queue,
    Set<String>? favorites,
    List<String>? pinnedFiles,
    List<Map<String, dynamic>>? slashCommands,
    bool? autoContinue,
    String? Function()? sendError,
  }) => ComposerState(
    input: input ?? this.input,
    attachments: attachments ?? this.attachments,
    uploading: uploading ?? this.uploading,
    models: models ?? this.models,
    activeModel: activeModel != null ? activeModel() : this.activeModel,
    effort: effort != null ? effort() : this.effort,
    permissionMode: permissionMode ?? this.permissionMode,
    permissionModes: permissionModes ?? this.permissionModes,
    supportsEffort: supportsEffort ?? this.supportsEffort,
    supportsLivePermissionMode: supportsLivePermissionMode ?? this.supportsLivePermissionMode,
    accounts: accounts ?? this.accounts,
    accountId: accountId != null ? accountId() : this.accountId,
    queue: queue ?? this.queue,
    favorites: favorites ?? this.favorites,
    pinnedFiles: pinnedFiles ?? this.pinnedFiles,
    slashCommands: slashCommands ?? this.slashCommands,
    autoContinue: autoContinue ?? this.autoContinue,
    sendError: sendError != null ? sendError() : this.sendError,
  );
}

/// `/api/commands/execute` response (web `CommandExecutionResult` parity).
/// `builtin` results carry an `action` (`help`/`models`/`cost`/`status` open
/// the command-result dialog; `memory`/`config` are navigation actions the
/// view handles) plus a free-form `data` payload; `custom` results carry the
/// expanded `prompt` plus the bash/file-include flags the server computed
/// (`processedContent.includes('!')`/`includes('@')`).
class CommandExecutionResult {
  const CommandExecutionResult._({
    required this.builtin,
    this.action,
    this.data = const {},
    this.prompt,
    this.hasBashCommands = false,
    this.hasFileIncludes = false,
  });

  const CommandExecutionResult.builtin({String? action, Map<String, dynamic> data = const {}})
    : this._(builtin: true, action: action, data: data);

  const CommandExecutionResult.custom({
    String? prompt,
    bool hasBashCommands = false,
    bool hasFileIncludes = false,
  }) : this._(
         builtin: false,
         prompt: prompt,
         hasBashCommands: hasBashCommands,
         hasFileIncludes: hasFileIncludes,
       );

  final bool builtin;
  final String? action;

  /// Builtin `data` (`HelpCommandData`/`ModelCommandData`/`CostCommandData`/
  /// `StatusCommandData` — loosely typed like the web).
  final Map<String, dynamic> data;

  /// Custom commands: the expanded prompt the web auto-sends.
  final String? prompt;

  /// Gates auto-send behind a confirm dialog (web `window.confirm` parity).
  final bool hasBashCommands;
  final bool hasFileIncludes;
}

/// Composer controller (T14): input/draft, attachments, model/effort/
/// permission/account picks, slash commands, queue, mentions, pinned files,
/// favorites.
class ComposerController extends Notifier<ComposerState> {
  ComposerController(this._arg);

  final ComposerArg _arg;
  StreamSubscription<ServerEvent>? _eventsSub;

  String? get _sessionId => _arg.sessionId;
  String? get _projectId => _arg.projectId;

  static Box<dynamic> get _prefs => Hive.box<dynamic>('settings');
  String get _favoritesKey => 'favorite_models_${_arg.provider}';
  String get _pinnedKey => 'pinned_files_${_projectId ?? ''}';

  @override
  ComposerState build() {
    final channel = ref.watch(chatChannelProvider);
    _eventsSub = channel.events.listen((e) {
      if (e.kind == BroadcastKinds.queuedMessagesUpdated && e.sessionId == _sessionId) {
        unawaited(refreshQueue());
      }
    });
    ref.onDispose(() => unawaited(_eventsSub?.cancel()));
    final sid = _sessionId;
    if (sid != null) {
      // Approving a plan (ExitPlanMode / plan review) leaves plan mode; a
      // composer still on 'plan' would put the agent straight back.
      ref.listen(planExitProvider(sid), (_, exit) {
        if (exit == null || state.permissionMode != 'plan') return;
        final modes = state.permissionModes;
        selectPermissionMode(modes.isEmpty || modes.contains(exit.mode) ? exit.mode : 'default');
      });
    }
    Future(_init);
    return ComposerState(
      input: _sessionId != null
          ? ChatStorage.readDraft(ChatStorage.draftKey(sessionId: _sessionId))
          : ChatStorage.readDraft(ChatStorage.draftKey(projectId: _projectId ?? 'global')),
      favorites: _loadStringSet(_favoritesKey),
      pinnedFiles: _loadStringList(_pinnedKey),
      autoContinue: _prefs.get('chat-auto-continue-tasks') == true,
      // Starting point before the session row resolves: the per-provider
      // default from Settings. `_init` replaces it with the session's pinned
      // mode when the row carries one — nothing else may change it.
      permissionMode: ref.read(agentPermissionsProvider(_arg.provider)).permissionMode,
    );
  }

  /// `active-model` answers with `{model: …}`; older payloads use id/modelId.
  static String? _activeModelId(Map<String, dynamic>? active) =>
      (active?['model'] ?? active?['id'] ?? active?['modelId'])?.toString();

  Future<void> _init() async {
    final repo = ref.read(sessionsRepositoryProvider);
    final sid = _sessionId;
    // Consume a stashed TaskMaster run command for this project (prefill,
    // never auto-send — same as the old composer).
    final pid = _projectId;
    if (pid != null && state.input.isEmpty) {
      final pending = ChatStorage.takeRunTask(pid);
      if (pending != null) {
        if (!ref.mounted) return;
        setInput(pending);
      }
    }
    // Web preloads the mention pools on mount so '@' opens instantly —
    // off the critical path (its own effect, not part of the init wait).
    unawaited(_ensureMentionPools());
    // Favorites are server-backed; load them off the critical path too.
    unawaited(_syncFavorites());
    // Web loads each piece in its own effect — resolve them independently so
    // one failing endpoint can't blank the model label, catalog or accounts.
    // The stored `<provider>-model` rides along as `requestedModel` so an
    // un-pinned session resolves to the user's default server-side instead of
    // the catalog DEFAULT.
    final storedModel = _prefs.get('${_arg.provider}-model')?.toString();
    final storedEffort = _prefs.get('${_arg.provider}-effort')?.toString();
    final modelsF = repo
        .models(_arg.provider)
        .catchError((_) => (options: <Map<String, dynamic>>[], defaultModel: null));
    final activeF = sid != null
        ? repo
              .activeModel(_arg.provider, sid, requestedModel: storedModel)
              .catchError((_) => <String, dynamic>{})
        : Future.value(<String, dynamic>{});
    final accountsF = ref
        .read(providerAccountsRepositoryProvider)
        .list()
        .catchError((_) => <ProviderAccount>[]);
    final queueF = sid != null
        ? ref.read(queueRepositoryProvider).list(sid).catchError((_) => <Map<String, dynamic>>[])
        : Future.value(<Map<String, dynamic>>[]);
    // Phase 1 — the model chip and the permission button are what the user
    // sees first; resolve just their inputs, then paint. Waiting for accounts,
    // the queue and the slash/skill catalog here left the chip stuck on the
    // "Default" fallback for as long as the slowest of those took.
    // The session row is also the source of the pinned permission mode —
    // fetched alongside the critical batch so the chip and the permission
    // button resolve in the same paint.
    final detailsF = sid != null
        ? repo.details(sid).then<Session?>((s) => s).catchError((_) => null)
        : Future<Session?>.value(null);
    try {
      final critical = await Future.wait([modelsF, activeF, _loadCapabilities(), detailsF]);
      if (!ref.mounted) return;
      final catalog = critical[0] as ({List<Map<String, dynamic>> options, String? defaultModel});
      final active = critical[1] as Map<String, dynamic>;
      final caps = critical[2] as Map<String, dynamic>;
      final sessionRaw = (critical[3] as Session?)?.raw;
      // A `source: 'default'` payload is the catalog DEFAULT, not a session
      // pick — without the filter it shadows the stored `<provider>-model`
      // default (web parity: `useChatProviderState` drops `source ===
      // 'default'` before applying its own precedence).
      final sessionPick = active['source'] == 'default' ? null : _activeModelId(active);
      // Provider-specific endpoint may be silent; the session row still
      // carries the model the run is using (web shows it in the chip).
      String? sessionModel;
      if (sid != null && _activeModelId(active) == null) {
        sessionModel = sessionRaw?['model']?.toString();
      }
      // Pinned mode wins over the per-provider default loaded in `build` —
      // unless the user already picked a mode while this fetch was in flight.
      final sessionMode = sessionRaw?['permissionMode']?.toString();
      // `currentProviderModel` parity: session pick → stored <provider>-model
      // default → catalog DEFAULT. Drafts resolve the same way — the banner
      // and chip always show a model like the web does.
      state = state.copyWith(
        models: catalog.options,
        activeModel: () =>
            sessionPick ??
            (sessionModel != null && sessionModel.isNotEmpty ? sessionModel : null) ??
            (storedModel != null && storedModel.isNotEmpty ? storedModel : null) ??
            catalog.defaultModel,
        effort: () => active['effort']?.toString() ?? storedEffort ?? 'default',
        permissionModes: [for (final m in caps['permissionModes'] as List? ?? const []) '$m'],
        supportsEffort: caps['supportsEffort'] != false,
        supportsLivePermissionMode: caps['supportsLivePermissionMode'] != false,
        permissionMode: !_modeManuallySet && sessionMode != null && sessionMode.isNotEmpty
            ? sessionMode
            : null,
      );
    } on Object {
      // Composer must stay usable even when auxiliary loads fail.
    }
    // Phase 2 — accounts, queue and the slash/skill catalog fill in whenever
    // they land; they cannot change the chip, so they must not gate it.
    try {
      final auxiliary = await Future.wait([accountsF, queueF, _loadSlashCommands()]);
      if (!ref.mounted) return;
      state = state.copyWith(
        accounts: (auxiliary[0] as List<ProviderAccount>)
            .where((a) => a.provider == null || a.provider == _arg.provider)
            .toList(),
        queue: auxiliary[1] as List<Map<String, dynamic>>,
        slashCommands: auxiliary[2] as List<Map<String, dynamic>>,
      );
    } on Object {
      // Auto-continue parity: auxiliary loads may fail without killing the bar.
    }
  }

  /// Capability matrix → the permission modes the composer menu offers and
  /// the effort/live-mode flags. Empty on failure — the menu hides rather
  /// than guessing (web parity: `ComposerPermissionMenu` returns null for an
  /// empty list).
  Future<Map<String, dynamic>> _loadCapabilities() async {
    try {
      return await ref.read(sessionsRepositoryProvider).capabilities(_arg.provider);
    } on Object {
      return const {};
    }
  }

  /// `useSlashCommands` fetch parity: `/api/commands/list` returns
  /// `{builtIn, custom}` (no `commands` key — the old mapping always came
  /// back empty), plus provider `/skills` merged as `namespace: 'skill'`.
  /// The merged list is sorted by per-project usage history, like the web.
  Future<List<Map<String, dynamic>>> _loadSlashCommands() async {
    final pid = _projectId;
    if (pid == null) return const [];
    final res = await ref.read(commandsRepositoryProvider).list({
      'projectId': pid,
      'projectPath': ?_arg.projectPath,
    });
    List<Map<String, dynamic>> skills = const [];
    try {
      skills = await ref
          .read(sessionsRepositoryProvider)
          .skills(_arg.provider, workspacePath: _arg.projectPath);
    } on Object {
      // Skills are best-effort — the menu still lists built-in/custom.
    }
    final seenSkillCommands = <String>{};
    final commands = <Map<String, dynamic>>[
      for (final c in (res['builtIn'] as List? ?? const []))
        if (c is Map) {...Map<String, dynamic>.from(c), 'type': 'built-in'},
      for (final s in skills)
        if (s['command'] != null && seenSkillCommands.add('${s['command']}'))
          {
            'name': '${s['command']}',
            'description': s['description']?.toString(),
            'namespace': 'skill',
            'path': s['sourcePath']?.toString(),
            'type': 'skill',
            'metadata': {
              'type': s['scope'],
              'scope': s['scope'],
              'sourcePath': s['sourcePath'],
              'pluginName': s['pluginName'],
              'pluginId': s['pluginId'],
              'skillName': s['name'],
            },
          },
      for (final c in (res['custom'] as List? ?? const []))
        if (c is Map) {...Map<String, dynamic>.from(c), 'type': 'custom'},
    ];
    // Web sort: usage count desc, stable for equal counts (List.sort isn't
    // stable, so compare index as the tiebreaker).
    final history = commandUsageHistory();
    final indexed = [for (var i = 0; i < commands.length; i++) (i, commands[i])];
    indexed.sort((a, b) {
      final ua = history['${a.$2['name']}'] ?? 0;
      final ub = history['${b.$2['name']}'] ?? 0;
      return ua != ub ? ub.compareTo(ua) : a.$1.compareTo(b.$1);
    });
    return [for (final e in indexed) e.$2];
  }

  /// `command_history_<projectId>` — the web keeps per-project command usage
  /// counts in localStorage; here it's the shared `settings` box under the
  /// same key.
  String get _commandHistoryKey => 'command_history_${_projectId ?? ''}';

  Map<String, int> commandUsageHistory() {
    final raw = _prefs.get(_commandHistoryKey);
    if (raw is! String) return {};
    try {
      return {
        for (final e in (jsonDecode(raw) as Map).entries) '${e.key}': (e.value as num).toInt(),
      };
    } on Object {
      return {};
    }
  }

  void trackCommandUsage(String name) {
    final history = commandUsageHistory();
    history[name] = (history[name] ?? 0) + 1;
    unawaited(_prefs.put(_commandHistoryKey, jsonEncode(history)));
  }

  static Set<String> _loadStringSet(String key) {
    final raw = _prefs.get(key);
    return raw is String ? (jsonDecode(raw) as List).cast<String>().toSet() : {};
  }

  static List<String> _loadStringList(String key) {
    final raw = _prefs.get(key);
    return raw is String ? (jsonDecode(raw) as List).cast<String>().toList() : [];
  }

  void setInput(String v) {
    state = state.copyWith(input: v);
    unawaited(
      ChatStorage.writeDraft(
        _sessionId != null
            ? ChatStorage.draftKey(sessionId: _sessionId)
            : ChatStorage.draftKey(projectId: _projectId ?? 'global'),
        v,
      ),
    );
  }

  Map<String, dynamic> _sendOptions() => {
    if (state.activeModel != null) 'model': state.activeModel,
    if (state.effort != null && state.supportsEffort) 'effort': state.effort,
    'permissionMode': state.permissionMode,
    // Orchestrator rows (plans, decisions, summary, report) are generated in
    // this language; without it the server defaults to English.
    'language': ref.read(localeProvider).languageTag,
    if (state.accountId != null) 'accountId': state.accountId,
    if (state.attachments.isNotEmpty) 'attachments': state.attachments,
  };

  /// Web parity: pinned file paths are merged into the prompt text verbatim.
  String _content() {
    final pins = state.pinnedFiles.where((p) => p.trim().isNotEmpty).toList();
    final input = state.input;
    if (pins.isEmpty) return input;
    final prefix = 'Pinned files:\n${pins.map((p) => '- $p').join('\n')}\n\n';
    return '$prefix$input';
  }

  /// Reentrancy lock — the running path awaits the enqueue REST call before
  /// the input clears, so a second Enter/click during that window would queue
  /// a real duplicate turn.
  bool _sending = false;

  /// Send — enqueue server-side while a run is active (web parity), else
  /// WS send (which itself falls back to the offline queue on closed socket).
  Future<void> send({bool running = false}) async {
    if (_sending) return;
    final text = _content().trim();
    final sid = _sessionId;
    // Attachments alone are a valid turn (the server accepts empty content).
    if ((text.isEmpty && state.attachments.isEmpty) || sid == null) return;
    _sending = true;
    try {
      // The queue REST route requires text; an attachment-only draft goes over
      // WS, where the server queues a send that races a live run itself.
      if (running && text.isNotEmpty) {
        await ref
            .read(queueRepositoryProvider)
            .enqueue(sid, content: text, options: _sendOptions());
        await refreshQueue();
      } else {
        ref.read(transcriptProvider(sid).notifier).send(text, options: _sendOptions());
      }
      state = state.copyWith(input: '', attachments: const []);
      unawaited(ChatStorage.writeDraft(ChatStorage.draftKey(sessionId: _sessionId), ''));
    } finally {
      _sending = false;
    }
  }

  void abort() {
    final sid = _sessionId;
    if (sid != null) ref.read(chatChannelProvider).abort(sid);
  }

  /// `/api/queue/:id/send-now` — the active turn keeps running and gets the
  /// message mid-turn where the agent supports it; otherwise it goes next.
  Future<void> sendNow(String id) async {
    try {
      await ref.read(queueRepositoryProvider).sendNow(id);
    } on Object {
      // The dispatch can outlive the request (a long provider turn) or the row
      // may already be gone; the refreshed queue below is authoritative.
    } finally {
      await refreshQueue();
    }
  }

  Future<void> deleteQueued(String id) async {
    await ref.read(queueRepositoryProvider).delete(id);
    await refreshQueue();
  }

  /// QueuedMessageCard edit — put the content back in the input and drop the
  /// queued copy (web `onEdit` → restore draft + remove).
  Future<void> editQueued(String id) async {
    final m = state.queue.where((e) => '${e['id']}' == id).firstOrNull;
    final content = m?['content']?.toString();
    if (content == null) return;
    setInput(content);
    await deleteQueued(id);
  }

  /// Inbox message — lands in the session without interrupting a run
  /// (`source: 'user'`, web parity).
  Future<void> inbox(String text) async {
    final sid = _sessionId;
    if (sid == null || text.trim().isEmpty) return;
    await ref.read(queueRepositoryProvider).inbox(sid, text, source: 'user');
    await refreshQueue();
  }

  Future<void> refreshQueue() async {
    final sid = _sessionId;
    if (sid == null || !ref.mounted) return;
    try {
      final q = await ref.read(queueRepositoryProvider).list(sid);
      if (ref.mounted) state = state.copyWith(queue: q);
    } on Object {
      // stale session — keep prior queue
    }
  }

  Future<void> selectModel(String id) async {
    state = state.copyWith(activeModel: () => id);
    // Shared per-provider default — the web's `${provider}-model` key; new
    // chats inherit this pick.
    unawaited(_prefs.put('${_arg.provider}-model', id));
    final sid = _sessionId;
    if (sid != null) {
      await ref.read(sessionsRepositoryProvider).setActiveModel(_arg.provider, sid, id);
    }
  }

  /// Web `onRefreshModels` — the model menu re-fetches the provider catalog
  /// the first time its Model section expands; a stale list stays on error.
  Future<void> refreshModels() async {
    try {
      final catalog = await ref
          .read(sessionsRepositoryProvider)
          .models(_arg.provider, refresh: true);
      if (ref.mounted) state = state.copyWith(models: catalog.options);
    } on Object {
      // Keep the stale catalog — the menu stays usable.
    }
  }

  Future<void> selectEffort(String value) async {
    state = state.copyWith(effort: () => value);
    unawaited(_prefs.put('${_arg.provider}-effort', value));
    final sid = _sessionId;
    if (sid != null) {
      await ref.read(sessionsRepositoryProvider).setActiveEffort(_arg.provider, sid, value);
    }
  }

  /// Set once the user picks a mode in the permission menu — the pinned
  /// session mode may then only change through this path, never by async
  /// hydration.
  bool _modeManuallySet = false;

  void selectPermissionMode(String mode) {
    _modeManuallySet = true;
    state = state.copyWith(permissionMode: mode);
    final sid = _sessionId;
    if (sid != null) {
      // REST pins the pick on the session row; the WS frame pushes it into a
      // live run. WS alone would lose the change on a closed socket.
      unawaited(
        ref.read(sessionsRepositoryProvider).setSessionPermissionMode(_arg.provider, sid, mode),
      );
      ref.read(chatChannelProvider).setPermissionMode(sid, mode);
    }
  }

  void selectAccount(String? id) => state = state.copyWith(accountId: () => id);

  /// `chat-auto-continue-tasks` toggle (web localStorage → settings box).
  void toggleAutoContinue() {
    final next = !state.autoContinue;
    state = state.copyWith(autoContinue: next);
    unawaited(_prefs.put('chat-auto-continue-tasks', next));
  }

  /// Loads favorites from the server so they survive app updates, reinstalls
  /// and device changes. A legacy Hive set is migrated once — only when the
  /// user has none on the server — and then dropped so it cannot be re-imported.
  Future<void> _syncFavorites() async {
    final repo = ref.read(sessionsRepositoryProvider);
    final legacy = _loadStringSet(_favoritesKey);
    try {
      final server = await repo.favoriteModels(_arg.provider);
      if (!ref.mounted) return;
      if (server.isEmpty && legacy.isNotEmpty) {
        final migrated = await repo.saveFavoriteModels(_arg.provider, legacy.toList());
        if (!ref.mounted) return;
        state = state.copyWith(favorites: migrated.toSet());
      } else {
        state = state.copyWith(favorites: server.toSet());
      }
      if (Hive.isBoxOpen('settings')) {
        unawaited(Hive.box<dynamic>('settings').delete(_favoritesKey));
      }
    } on Object {
      // Offline / not signed in: keep the favorites already shown from Hive.
    }
  }

  void toggleFavorite(String modelId) {
    final previous = state.favorites;
    final next = {...previous};
    next.contains(modelId) ? next.remove(modelId) : next.add(modelId);
    state = state.copyWith(favorites: next);
    unawaited(_persistFavorites(next, previous));
  }

  /// Persists the whole set server-side; a failed write rolls the optimistic
  /// toggle back so the star never lies about what the server holds.
  Future<void> _persistFavorites(Set<String> next, Set<String> previous) async {
    try {
      await ref.read(sessionsRepositoryProvider).saveFavoriteModels(_arg.provider, next.toList());
    } on Object {
      if (ref.mounted) state = state.copyWith(favorites: previous);
    }
  }

  void pinFile(String path) {
    if (state.pinnedFiles.contains(path)) return;
    final next = [...state.pinnedFiles, path];
    state = state.copyWith(pinnedFiles: next);
    unawaited(_prefs.put(_pinnedKey, jsonEncode(next)));
  }

  void unpinFile(String path) {
    final next = state.pinnedFiles.where((p) => p != path).toList();
    state = state.copyWith(pinnedFiles: next);
    unawaited(_prefs.put(_pinnedKey, jsonEncode(next)));
  }

  /// Attach bytes: images go to /api/assets/images (field `images`), the
  /// rest to /api/assets/files (field `files`) — server returns
  /// `{images|attachments: [records]}` (web `uploadAttachmentFiles` parity).
  Future<void> attach(String name, List<int> bytes, {required bool isImage}) async {
    state = state.copyWith(uploading: true);
    try {
      final repo = ref.read(miscRepositoryProvider);
      final form = FormData.fromMap({
        isImage ? 'images' : 'files': MultipartFile.fromBytes(bytes, filename: name),
      });
      final res = isImage ? await repo.uploadImage(form) : await repo.uploadFile(form);
      final records = (res[isImage ? 'images' : 'attachments'] as List? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map((r) => r)
          .toList();
      if (records.isEmpty) {
        state = state.copyWith(uploading: false, sendError: () => t.chat.composer.uploadNoRecords);
        return;
      }
      state = state.copyWith(
        uploading: false,
        attachments: [
          ...state.attachments,
          for (final r in records) {'name': r['name'] ?? r['filename'] ?? name, ...r},
        ],
      );
    } on Object catch (e) {
      state = state.copyWith(uploading: false, sendError: () => '$e');
    }
  }

  void removeAttachment(int i) {
    final next = [...state.attachments]..removeAt(i);
    state = state.copyWith(attachments: next);
  }

  /// Execute a slash command via /api/commands/execute — `builtin` results
  /// clear the input and surface `action`/`data` (the result-dialog payloads;
  /// `memory`/`config` are navigation actions the view handles), `custom`
  /// returns the expanded prompt plus bash/file-include flags (web
  /// `handleBuiltInCommand`/`handleCustomCommand` parity).
  Future<CommandExecutionResult> executeCommand(
    Map<String, dynamic> command,
    List<String> args, {

    /// `preserveInput` — the web keeps the draft when a result modal opens
    /// from outside the slash menu (e.g. the token-usage chip's /cost).
    bool preserveInput = false,

    /// Live `tokenBudget` snapshot — `/cost` reads `context.tokenUsage`.
    Map<String, dynamic>? tokenUsage,
  }) async {
    final res = await ref.read(commandsRepositoryProvider).execute({
      'commandName': command['name'],
      'commandPath': command['path'],
      'args': args,
      'context': {
        'projectPath': ?_arg.projectPath,
        'projectId': ?_projectId,
        'sessionId': ?_sessionId,
        'provider': _arg.provider,
        'model': ?state.activeModel,
        'tokenUsage': ?tokenUsage,
      },
    });
    if (res['type'] == 'builtin') {
      if (!preserveInput) setInput('');
      return CommandExecutionResult.builtin(
        action: res['action']?.toString(),
        data: res['data'] is Map ? Map<String, dynamic>.from(res['data'] as Map) : const {},
      );
    }
    return CommandExecutionResult.custom(
      prompt: (res['prompt'] ?? res['content'])?.toString(),
      hasBashCommands: res['hasBashCommands'] == true,
      hasFileIncludes: res['hasFileIncludes'] == true,
    );
  }

  /// Mention pools (`fileList`/`sessionList`/`taskList` in `useMentions`) —
  /// fetched once per composer like the web's mount effects, then filtered
  /// locally on every keystroke.
  List<Map<String, String>>? _fileMentions;
  List<Map<String, String>>? _sessionMentions;
  List<Map<String, String>>? _taskMentions;

  /// `flattenFileTree` — depth-first file rows (title = basename, subtitle
  /// = relative path).
  static void _flattenFileNodes(List<FileTreeNode> nodes, List<Map<String, String>> out) {
    for (final n in nodes) {
      if (n.isDirectory) {
        _flattenFileNodes(n.children, out);
        continue;
      }
      out.add({'kind': 'file', 'title': n.name, 'subtitle': n.path, 'value': n.path});
    }
  }

  Future<List<Map<String, String>>> _loadSessionMentions() async {
    final cached = _sessionMentions;
    if (cached != null) return cached;
    try {
      final page = await ref.read(sessionsRepositoryProvider).recent(limit: 40);
      _sessionMentions = [
        for (final s in page.sessions)
          if (s.sessionId.isNotEmpty)
            {
              'kind': 'session',
              'title': (s.summary?.isNotEmpty ?? false)
                  ? s.summary!
                  : t.chat.export.sessionTitle(id: s.sessionId),
              'value': (s.summary?.isNotEmpty ?? false) ? s.summary! : 'Session ${s.sessionId}',
            },
      ];
      return _sessionMentions!;
    } on Object {
      return _sessionMentions = const [];
    }
  }

  Future<void> _ensureMentionPools() async {
    final pid = _projectId;
    if (_fileMentions == null) {
      _fileMentions = const [];
      if (pid != null) {
        try {
          final tree = await ref.read(fileTreeRepositoryProvider).listFiles(pid);
          final out = <Map<String, String>>[];
          _flattenFileNodes(tree, out);
          _fileMentions = out;
        } on Object {
          // mention search is best-effort
        }
      }
    }
    if (_taskMentions == null) {
      _taskMentions = const [];
      if (pid != null) {
        try {
          final tm = await ref.read(taskmasterRepositoryProvider).tasks(pid);
          _taskMentions = [
            for (final task in (tm['tasks'] as List? ?? const []))
              // `isOpenTask` — done/cancelled tasks stay out of the picker.
              if (task is Map && !{'done', 'cancelled'}.contains('${task['status']}'))
                {
                  'kind': 'task',
                  'title': '${task['title'] ?? t.chat.mentionMenu.taskTitle(id: '${task['id']}')}',
                  'subtitle': '${task['status'] ?? ''}',
                  // Inserted into the prompt — stays English for the agent.
                  'value': '${task['title'] ?? 'Task ${task['id']}'}',
                },
          ];
        } on Object {
          // mention search is best-effort
        }
      }
    }
    await _loadSessionMentions();
  }

  /// @-mention candidates across files, sessions and TaskMaster tasks —
  /// `useMentions` parity: cached pools, title+subtitle+id matching, files
  /// first on a bare `@` (else sessions → tasks → files), top 15.
  Future<List<Map<String, String>>> mentions(String query) async {
    await _ensureMentionPools();
    final q = query.toLowerCase();
    bool hit(Map<String, String> m) =>
        (m['title'] ?? '').toLowerCase().contains(q) ||
        (m['subtitle'] ?? '').toLowerCase().contains(q) ||
        (m['value'] ?? '').toLowerCase().contains(q);
    final files = _fileMentions ?? const <Map<String, String>>[];
    final sessions = _sessionMentions ?? const <Map<String, String>>[];
    final tasks = _taskMentions ?? const <Map<String, String>>[];
    // Web parity: `mentionableItems` is sessions → tasks → files, but on a
    // bare '@' files surface first so the picker reads as the file picker.
    final pool = q.isEmpty ? [...files, ...sessions, ...tasks] : [...sessions, ...tasks, ...files];
    return pool.where(hit).take(15).toList();
  }
}

final composerProvider = NotifierProvider.family<ComposerController, ComposerState, ComposerArg>(
  ComposerController.new,
);
