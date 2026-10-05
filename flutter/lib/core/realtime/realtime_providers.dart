import 'dart:async';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/realtime/browser_view_channel.dart';
import 'package:ddagent_app/core/realtime/chat_channel.dart';
import 'package:ddagent_app/core/realtime/notifications_channel.dart';
import 'package:ddagent_app/core/realtime/shell_channel.dart';
import 'package:ddagent_app/core/realtime/sse_client.dart';
import 'package:ddagent_app/core/realtime/ws_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Builds an authenticated WS URI for a gateway path — `?token=<jwt>` is
/// re-read on every connect attempt, so reconnects always carry a fresh token.
Future<Uri> Function() wsUrlBuilder(Ref ref, String path) {
  final base = ref.watch(serverBaseUrlProvider);
  final tokens = ref.watch(authTokenStoreProvider);
  return () async {
    // Embedded/same-origin builds (the web bundle served by the sidecar)
    // carry no configured server URL — resolve the socket against the page
    // origin, mirroring how the relative `/api/...` REST base reaches the
    // same host.
    final parsed = base.isEmpty && kIsWeb ? Uri.base : Uri.parse(base);
    final scheme = switch (parsed.scheme) {
      'https' || 'wss' => 'wss',
      _ => 'ws',
    };
    final token = await tokens.token;
    return Uri(
      scheme: scheme,
      host: parsed.host,
      port: parsed.hasPort ? parsed.port : null,
      path: path,
      queryParameters: {'token': ?token},
    );
  };
}

WsClient _ws(Ref ref, String path) => WsClient(urlBuilder: wsUrlBuilder(ref, path));

/// Single shared chat socket — the app has one /ws connection for chat,
/// presence, and all broadcasts. `start()` only wires the listeners, so the
/// provider owns the initial `connect()`; reconnects are handled inside
/// [WsClient] after that.
final chatChannelProvider = Provider<ChatChannel>((ref) {
  final channel = ChatChannel(_ws(ref, '/ws'))..start();
  unawaited(channel.connect());
  ref.onDispose(channel.dispose);
  return channel;
});

/// Shell PTY channel — one instance per `projectPath_sessionId` key
/// (family param = server session key suffix).
final shellChannelProvider = Provider.family<ShellChannel, String>((ref, sessionKey) {
  final channel = ShellChannel(_ws(ref, '/shell'))..start();
  ref.onDispose(channel.dispose);
  return channel;
});

final browserViewChannelProvider = Provider<BrowserViewChannel>((ref) {
  final channel = BrowserViewChannel(_ws(ref, '/browser-view'))..start();
  ref.onDispose(channel.dispose);
  return channel;
});

final desktopNotificationsChannelProvider = Provider<DesktopNotificationsChannel>((ref) {
  final channel = DesktopNotificationsChannel(_ws(ref, '/desktop-notifications'))..start();
  ref.onDispose(channel.dispose);
  return channel;
});

/// Inbound `/desktop-notifications` frames filtered to actual notifications.
/// The app root listens to this to surface an OS notification / toast; the
/// [DeviceNotificationsController] owns connecting and registering the socket.
final desktopNotificationEventsProvider = StreamProvider<DesktopNotification>(
  (ref) => ref
      .watch(desktopNotificationsChannelProvider)
      .notifications
      .where((notification) => notification.isNotification),
);

final sseClientProvider = Provider<SseClient>((ref) => SseClient(ref.watch(dioProvider)));
