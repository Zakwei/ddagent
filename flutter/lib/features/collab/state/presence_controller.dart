import 'dart:async';

import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// What the local user is looking at — `{kind: session|card|board, id}` per
/// server `readPresenceViewing`. Null = online but not viewing a surface.
typedef PresenceViewing = ({String kind, String id})?;

/// One roster entry from the `presence-roster` broadcast.
class PresenceEntry {
  const PresenceEntry({required this.userId, required this.username, this.viewing});

  final Object userId;
  final String username;
  final PresenceViewing viewing;
}

/// Parses a `presence-roster` frame into entries; malformed rows are dropped.
List<PresenceEntry> presenceRosterOf(ServerEvent event) {
  final users = event.raw['users'];
  if (users is! List) return const [];
  return [
    for (final u in users)
      if (u is Map && u['userId'] != null && u['username'] is String)
        PresenceEntry(
          userId: u['userId'] as Object,
          username: u['username'] as String,
          viewing: switch (u['viewing']) {
            {'kind': final String k, 'id': final String i} => (kind: k, id: i),
            _ => null,
          },
        ),
  ];
}

/// Per-surface presence controller (port of `usePresence`). The socket treats
/// the first `presence` frame as a subscription, so we announce on every
/// (re)connect; dispose sends `viewing: null`. While disconnected the last
/// roster is stale — it clears to empty until the reconnect re-announces us.
class PresenceController extends Notifier<List<PresenceEntry>> {
  PresenceController(this._viewing);

  final PresenceViewing _viewing;

  StreamSubscription<ServerEvent>? _eventsSub;
  StreamSubscription<WsState>? _statesSub;

  @override
  List<PresenceEntry> build() {
    final channel = ref.watch(chatChannelProvider);
    _eventsSub = channel.events.listen((e) {
      if (e.kind == BroadcastKinds.presenceRoster) state = presenceRosterOf(e);
    });
    _statesSub = channel.states.listen((s) {
      if (s == WsState.open) {
        _announce(channel);
      } else {
        state = const [];
      }
    });
    ref.onDispose(() {
      // Best-effort clear so the roster stops claiming we're still viewing.
      channel.presence(null);
      unawaited(_eventsSub?.cancel());
      unawaited(_statesSub?.cancel());
    });
    // Channel may already be open when this provider first attaches.
    if (channel.wsState == WsState.open) _announce(channel);
    return const [];
  }

  void _announce(ChatChannel channel) =>
      channel.presence(_viewing == null ? null : {'kind': _viewing.kind, 'id': _viewing.id});
}

final presenceProvider =
    NotifierProvider.family<PresenceController, List<PresenceEntry>, PresenceViewing>(
      PresenceController.new,
    );
