import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:ddagent_app/features/commands/data/commands_repository.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/features/misc/data/misc_repository.dart';
import 'package:ddagent_app/features/provider_accounts/data/provider_accounts_repository.dart';
import 'package:ddagent_app/features/queue/data/queue_repository.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_repository.dart';
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

  /// Effort levels offered by the active model's descriptor (web parity:
  /// `ProviderModelOption.effort.values`); an unknown model falls back to the
  /// provider superset from `FALLBACK_PROVIDER_EFFORT_VALUES` while the
  /// catalog hydrates.
  List<String> effortValues(String provider) {
    for (final m in models) {
      if ((m['id'] ?? m['value']) == activeModel) {
        final vals = (m['effort'] as Map?)?['values'] as List?;
        return [
          for (final v in vals ?? const [])
            (v is Map ? v['value'] : v).toString(),
        ];
      }
    }
    return const {
      'claude': ['low', 'medium', 'high', 'xhigh', 'max'],
      'codex': ['low', 'medium', 'high', 'xhigh', 'max', 'ultra'],
      'opencode': ['none', 'low', 'medium', 'high', 'xhigh', 'max'],
      'devin': ['low', 'medium', 'high', 'xhigh', 'max'],
    }[provider] ?? const [];
  }

  /// Like [effortValues] but keeps each descriptor's `description` — the web
  /// `ComposerModelMenu` shows it under the effort label.
  List<({String value, String? description})> effortOptions(String provider) {
    for (final m in models) {
      if ((m['id'] ?? m['value']) == activeModel) {
        final vals = (m['effort'] as Map?)?['values'] as List?;
        return [
          for (final v in vals ?? const [])
            v is Map
                ? (
                    value: '${v['value']}',
                    description: v['description']?.toString(),
                  )
                : (value: '$v', description: null),
        ];
      }
    }
    return [
      for (final v in effortValues(provider)) (value: v, description: null),
    ];
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
      if (e.kind == BroadcastKinds.queuedMessagesUpdated &&
          e.sessionId == _sessionId) {
        unawaited(refreshQueue());
      }
    });
    ref.onDispose(() => unawaited(_eventsSub?.cancel()));
    Future(_init);
    return ComposerState(
      input: _sessionId != null
          ? ChatStorage.readDraft(ChatStorage.draftKey(sessionId: _sessionId))
          : ChatStorage.readDraft(
              ChatStorage.draftKey(projectId: _projectId ?? 'global'),
            ),
      favorites: _loadStringSet(_favoritesKey),
      pinnedFiles: _loadStringList(_pinnedKey),
      autoContinue: _prefs.get('chat-auto-continue-tasks') == true,
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
    try {
      final results = await Future.wait([
        repo.models(_arg.provider),
        if (sid != null) repo.activeModel(_arg.provider, sid),
        ref.read(providerAccountsRepositoryProvider).list(),
        if (sid != null) ref.read(queueRepositoryProvider).list(sid),
        _loadSlashCommands(),
        _loadPermissionModes(),
      ]);
      if (!ref.mounted) return;
      final models = results[0] as List<Map<String, dynamic>>;
      final active = (sid != null ? results[1] : null) as Map<String, dynamic>?;
      // Provider-specific endpoint may be silent; the session row still
      // carries the model the run is using (web shows it in the chip).
      String? sessionModel;
      if (sid != null && _activeModelId(active) == null) {
        try {
          sessionModel = (await repo.details(sid)).raw['model']?.toString();
        } on Object {
          sessionModel = null;
        }
        if (!ref.mounted) return;
      }
      final accounts = results[sid != null ? 2 : 1] as List<ProviderAccount>;
      final queue = sid != null
          ? results[3] as List<Map<String, dynamic>>
          : const <Map<String, dynamic>>[];
      final commands = results[results.length - 2] as List<Map<String, dynamic>>;
      final permissionModes = results.last as List<String>;
      state = state.copyWith(
        models: models,
        activeModel: () =>
            _activeModelId(active) ??
            (sessionModel != null && sessionModel.isNotEmpty
                ? sessionModel
                : null),
        permissionModes: permissionModes,
        accounts: accounts
            .where((a) => a.provider == null || a.provider == _arg.provider)
            .toList(),
        queue: queue,
        slashCommands: commands,
      );
    } on Object {
      // Composer must stay usable even when auxiliary loads fail.
    }
  }

  /// Capability matrix → the permission modes the composer menu offers.
  /// Empty on failure — the menu hides rather than guessing (web parity:
  /// `ComposerPermissionMenu` returns null for an empty list).
  Future<List<String>> _loadPermissionModes() async {
    try {
      final caps = await ref
          .read(sessionsRepositoryProvider)
          .capabilities(_arg.provider);
      return [
        for (final m in caps['permissionModes'] as List? ?? const []) '$m',
      ];
    } on Object {
      return const [];
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
        if (c is Map)
          {...Map<String, dynamic>.from(c), 'type': 'built-in'},
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
    final indexed = [
      for (var i = 0; i < commands.length; i++) (i, commands[i]),
    ];
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
        for (final e in (jsonDecode(raw) as Map).entries)
          '${e.key}': (e.value as num).toInt(),
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
    return raw is String
        ? (jsonDecode(raw) as List).cast<String>().toSet()
        : {};
  }

  static List<String> _loadStringList(String key) {
    final raw = _prefs.get(key);
    return raw is String
        ? (jsonDecode(raw) as List).cast<String>().toList()
        : [];
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
    if (state.effort != null) 'effort': state.effort,
    'permissionMode': state.permissionMode,
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

  /// Send — enqueue server-side while a run is active (web parity), else
  /// WS send (which itself falls back to the offline queue on closed socket).
  Future<void> send({bool running = false}) async {
    final text = _content().trim();
    final sid = _sessionId;
    if (text.isEmpty || sid == null) return;
    if (running) {
      await ref
          .read(queueRepositoryProvider)
          .enqueue(sid, content: text, options: _sendOptions());
      await refreshQueue();
    } else {
      ref
          .read(
            transcriptProvider((sessionId: sid, projectId: _projectId))
                .notifier,
          )
          .send(text, options: _sendOptions());
    }
    state = state.copyWith(input: '', attachments: const []);
    unawaited(
      ChatStorage.writeDraft(ChatStorage.draftKey(sessionId: _sessionId), ''),
    );
  }

  void abort() {
    final sid = _sessionId;
    if (sid != null) ref.read(chatChannelProvider).abort(sid);
  }

  /// `/api/queue/:id/send-now` — aborts the active turn and dispatches.
  Future<void> sendNow(String id) async {
    await ref.read(queueRepositoryProvider).sendNow(id);
    await refreshQueue();
  }

  Future<void> deleteQueued(String id) async {
    await ref.read(queueRepositoryProvider).delete(id);
    await refreshQueue();
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
    final sid = _sessionId;
    if (sid != null) {
      await ref
          .read(sessionsRepositoryProvider)
          .setActiveModel(_arg.provider, sid, id);
    }
  }

  /// Web `onRefreshModels` — the model menu re-fetches the provider catalog
  /// the first time its Model section expands; a stale list stays on error.
  Future<void> refreshModels() async {
    try {
      final models = await ref
          .read(sessionsRepositoryProvider)
          .models(_arg.provider);
      if (ref.mounted) state = state.copyWith(models: models);
    } on Object {
      // Keep the stale catalog — the menu stays usable.
    }
  }

  Future<void> selectEffort(String value) async {
    state = state.copyWith(effort: () => value);
    final sid = _sessionId;
    if (sid != null) {
      await ref
          .read(sessionsRepositoryProvider)
          .setActiveEffort(_arg.provider, sid, value);
    }
  }

  void selectPermissionMode(String mode) {
    state = state.copyWith(permissionMode: mode);
    final sid = _sessionId;
    if (sid != null) {
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

  void toggleFavorite(String modelId) {
    final next = {...state.favorites};
    next.contains(modelId) ? next.remove(modelId) : next.add(modelId);
    state = state.copyWith(favorites: next);
    unawaited(_prefs.put(_favoritesKey, jsonEncode(next.toList())));
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
  Future<void> attach(
    String name,
    List<int> bytes, {
    required bool isImage,
  }) async {
    state = state.copyWith(uploading: true);
    try {
      final repo = ref.read(miscRepositoryProvider);
      final form = FormData.fromMap({
        isImage ? 'images' : 'files': MultipartFile.fromBytes(
          bytes,
          filename: name,
        ),
      });
      final res = isImage
          ? await repo.uploadImage(form)
          : await repo.uploadFile(form);
      final records =
          (res[isImage ? 'images' : 'attachments'] as List? ?? const [])
              .whereType<Map<String, dynamic>>()
              .map((r) => r)
              .toList();
      if (records.isEmpty) {
        state = state.copyWith(
          uploading: false,
          sendError: () => 'Upload returned no records',
        );
        return;
      }
      state = state.copyWith(
        uploading: false,
        attachments: [
          ...state.attachments,
          for (final r in records)
            {'name': r['name'] ?? r['filename'] ?? name, ...r},
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
  /// clear the input, `custom` returns prompt text to send.
  Future<String?> executeCommand(
    Map<String, dynamic> command,
    List<String> args,
  ) async {
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
      },
    });
    if (res['type'] == 'builtin') {
      setInput('');
      return null;
    }
    return (res['prompt'] ?? res['content'])?.toString();
  }

  /// Mention pools (`fileList`/`sessionList`/`taskList` in `useMentions`) —
  /// fetched once per composer like the web's mount effects, then filtered
  /// locally on every keystroke.
  List<Map<String, String>>? _fileMentions;
  List<Map<String, String>>? _sessionMentions;
  List<Map<String, String>>? _taskMentions;

  /// `flattenFileTree` — depth-first file rows (title = basename, subtitle
  /// = relative path).
  static void _flattenFileNodes(
    List<FileTreeNode> nodes,
    List<Map<String, String>> out,
  ) {
    for (final n in nodes) {
      if (n.isDirectory) {
        _flattenFileNodes(n.children, out);
        continue;
      }
      out.add({
        'kind': 'file',
        'title': n.name,
        'subtitle': n.path,
        'value': n.path,
      });
    }
  }

  Future<List<Map<String, String>>> _loadSessionMentions() async {
    final cached = _sessionMentions;
    if (cached != null) return cached;
    try {
      final page = await ref
          .read(sessionsRepositoryProvider)
          .recent(limit: 40);
      _sessionMentions = [
        for (final s in page.sessions)
          if (s.sessionId.isNotEmpty)
            {
              'kind': 'session',
              'title': (s.summary?.isNotEmpty ?? false)
                  ? s.summary!
                  : 'Session ${s.sessionId}',
              'value': (s.summary?.isNotEmpty ?? false)
                  ? s.summary!
                  : 'Session ${s.sessionId}',
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
          final tree = await ref
              .read(fileTreeRepositoryProvider)
              .listFiles(pid);
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
            for (final t in (tm['tasks'] as List? ?? const []))
              // `isOpenTask` — done/cancelled tasks stay out of the picker.
              if (t is Map &&
                  !{'done', 'cancelled'}.contains('${t['status']}'))
                {
                  'kind': 'task',
                  'title': '${t['title'] ?? 'Task ${t['id']}'}',
                  'subtitle': '${t['status'] ?? ''}',
                  'value': '${t['title'] ?? 'Task ${t['id']}'}',
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
    final pool = q.isEmpty
        ? [...files, ...sessions, ...tasks]
        : [...sessions, ...tasks, ...files];
    return pool.where(hit).take(15).toList();
  }
}

final composerProvider =
    NotifierProvider.family<ComposerController, ComposerState, ComposerArg>(
      ComposerController.new,
    );
