import 'dart:async';
import 'dart:convert';

import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:ddagent_app/features/commands/data/commands_repository.dart';
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
    this.accounts = const [],
    this.accountId,
    this.queue = const [],
    this.favorites = const {},
    this.pinnedFiles = const [],
    this.slashCommands = const [],
    this.sendError,
  });

  final String input;
  final List<Map<String, dynamic>> attachments;
  final bool uploading;
  final List<Map<String, dynamic>> models;
  final String? activeModel;
  final String? effort;
  final String permissionMode;
  final List<ProviderAccount> accounts;
  final String? accountId;
  final List<Map<String, dynamic>> queue;
  final Set<String> favorites;
  final List<String> pinnedFiles;
  final List<Map<String, dynamic>> slashCommands;
  final String? sendError;

  /// Effort levels offered by the active model's descriptor (web parity:
  /// `ProviderModelOption.effort.values`).
  List<String> get effortValues {
    for (final m in models) {
      if ((m['id'] ?? m['value']) == activeModel) {
        final vals = (m['effort'] as Map?)?['values'] as List?;
        return [
          for (final v in vals ?? const [])
            (v is Map ? v['value'] : v).toString(),
        ];
      }
    }
    return const ['low', 'medium', 'high'];
  }

  ComposerState copyWith({
    String? input,
    List<Map<String, dynamic>>? attachments,
    bool? uploading,
    List<Map<String, dynamic>>? models,
    String? Function()? activeModel,
    String? Function()? effort,
    String? permissionMode,
    List<ProviderAccount>? accounts,
    String? Function()? accountId,
    List<Map<String, dynamic>>? queue,
    Set<String>? favorites,
    List<String>? pinnedFiles,
    List<Map<String, dynamic>>? slashCommands,
    String? Function()? sendError,
  }) => ComposerState(
    input: input ?? this.input,
    attachments: attachments ?? this.attachments,
    uploading: uploading ?? this.uploading,
    models: models ?? this.models,
    activeModel: activeModel != null ? activeModel() : this.activeModel,
    effort: effort != null ? effort() : this.effort,
    permissionMode: permissionMode ?? this.permissionMode,
    accounts: accounts ?? this.accounts,
    accountId: accountId != null ? accountId() : this.accountId,
    queue: queue ?? this.queue,
    favorites: favorites ?? this.favorites,
    pinnedFiles: pinnedFiles ?? this.pinnedFiles,
    slashCommands: slashCommands ?? this.slashCommands,
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
    );
  }

  Future<void> _init() async {
    final repo = ref.read(sessionsRepositoryProvider);
    final sid = _sessionId;
    try {
      final results = await Future.wait([
        repo.models(_arg.provider),
        if (sid != null) repo.activeModel(_arg.provider, sid),
        ref.read(providerAccountsRepositoryProvider).list(),
        if (sid != null) ref.read(queueRepositoryProvider).list(sid),
        _loadSlashCommands(),
      ]);
      if (!ref.mounted) return;
      final models = results[0] as List<Map<String, dynamic>>;
      final active = (sid != null ? results[1] : null) as Map<String, dynamic>?;
      final accounts = results[sid != null ? 2 : 1] as List<ProviderAccount>;
      final queue = sid != null
          ? results[3] as List<Map<String, dynamic>>
          : const <Map<String, dynamic>>[];
      final commands = results.last as List<Map<String, dynamic>>;
      state = state.copyWith(
        models: models,
        activeModel: () => (active?['id'] ?? active?['modelId'])?.toString(),
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

  Future<List<Map<String, dynamic>>> _loadSlashCommands() async {
    final pid = _projectId;
    if (pid == null) return const [];
    final res = await ref.read(commandsRepositoryProvider).list({
      'projectId': pid,
      'projectPath': ?_arg.projectPath,
    });
    return [
      for (final c in (res['commands'] as List? ?? const []))
        if (c is Map) Map<String, dynamic>.from(c),
    ];
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

  /// @-mention candidates across files, sessions and TaskMaster tasks
  /// (useMentions + useFileMentions parity, merged into one list).
  Future<List<Map<String, String>>> mentions(String query) async {
    final pid = _projectId;
    final out = <Map<String, String>>[];
    if (pid != null) {
      try {
        final files = await ref
            .read(fileTreeRepositoryProvider)
            .search(pid, query, limit: 10);
        for (final f in files.matches) {
          out.add({'kind': 'file', 'label': f.path, 'insert': '@${f.path}'});
        }
        final tm = await ref.read(taskmasterRepositoryProvider).tasks(pid);
        for (final t in (tm['tasks'] as List? ?? const [])) {
          if (t is Map && '$t'.toLowerCase().contains(query.toLowerCase())) {
            out.add({
              'kind': 'task',
              'label': '#${t['id']} ${t['title'] ?? ''}'.trim(),
              'insert': 'task #${t['id']}',
            });
          }
        }
      } on Object {
        // mention search is best-effort
      }
    }
    return out.take(10).toList();
  }
}

final composerProvider =
    NotifierProvider.family<ComposerController, ComposerState, ComposerArg>(
      ComposerController.new,
    );
