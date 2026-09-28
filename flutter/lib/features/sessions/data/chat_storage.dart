import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

/// Draft + offline-queue persistence (T43.6) — parity with
/// `chatStorage.ts` key scheme, stored in a `chat` Hive box instead of
/// localStorage.
class ChatStorage {
  static const _boxName = 'chat';

  static Box<dynamic> get _box => Hive.box<dynamic>(_boxName);

  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) await Hive.openBox<dynamic>(_boxName);
  }

  // ─── Drafts ──────────────────────────────────────────────────────────────

  /// `draft_input_session_<sid>` for session-bound composers,
  /// `draft_input_<projectId>[_<paneId>]` for new-chat panes — the pane id
  /// keeps two split-grid draft panes from overwriting each other.
  static String draftKey({
    String? sessionId,
    String? projectId,
    String? paneId,
  }) {
    if (sessionId != null) return 'draft_input_session_$sessionId';
    return paneId != null
        ? 'draft_input_${projectId}_$paneId'
        : 'draft_input_$projectId';
  }

  static String readDraft(String key) => _box.get(key) as String? ?? '';

  static Future<void> writeDraft(String key, String text) =>
      text.isEmpty ? _box.delete(key) : _box.put(key, text);

  // ─── Offline queue ───────────────────────────────────────────────────────

  static String offlineQueueKey(String projectId) =>
      'ddagent_offline_queue_$projectId';

  static List<Map<String, dynamic>> readOfflineQueue(String projectId) {
    final raw = _box.get(offlineQueueKey(projectId));
    if (raw is! String || raw.isEmpty) return [];
    try {
      final parsed = jsonDecode(raw);
      if (parsed is! List) return [];
      return [
        for (final e in parsed)
          if (e is Map && e['content'] is String) Map<String, dynamic>.from(e),
      ];
    } on Object {
      return [];
    }
  }

  static Future<void> writeOfflineQueue(
    String projectId,
    List<Map<String, dynamic>> entries,
  ) => _box.put(offlineQueueKey(projectId), jsonEncode(entries));

  static Future<void> enqueueOffline(
    String projectId,
    Map<String, dynamic> message,
  ) async {
    final q = readOfflineQueue(projectId)..add(message);
    await writeOfflineQueue(projectId, q);
  }

  /// Remove a session's draft + its queued offline messages across all
  /// projects — a deleted session must not leave entries that later flush
  /// into SESSION_NOT_FOUND drops.
  static Future<void> purgeSessionLocalState(String sessionId) async {
    await _box.delete('draft_input_session_$sessionId');
    for (final key in _box.keys.toList()) {
      if (key is! String || !key.startsWith('ddagent_offline_queue_')) {
        continue;
      }
      final projectId = key.substring('ddagent_offline_queue_'.length);
      final queue = readOfflineQueue(projectId);
      final next = [
        for (final e in queue)
          if (e['sessionId'] != sessionId) e,
      ];
      if (next.length != queue.length) {
        await writeOfflineQueue(projectId, next);
      }
    }
  }
}
