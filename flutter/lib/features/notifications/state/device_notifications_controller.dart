import 'dart:async';
import 'dart:math';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/features/notifications/data/notifications_repository.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DeviceNotificationsState {
  const DeviceNotificationsState({
    this.enabled = false,
    this.loading = true,
    this.busy = false,
    this.error,
  });

  final bool enabled;
  final bool loading;
  final bool busy;
  final String? error;
}

/// "Notify this device" — the native port of the web-push card in
/// `NotificationsSettingsTab.tsx`. Browsers subscribe via the Push API;
/// a native app registers itself as a `desktop` endpoint over the
/// `/desktop-notifications` WS channel (`registerDesktopNotificationClient`
/// server-side). Disable = PATCH `enabled:false` + socket close — the server
/// re-enables endpoints on every `register`, so staying connected while
/// "disabled" would silently re-arm it.
class DeviceNotificationsController extends Notifier<DeviceNotificationsState> {
  static const _boxName = 'settings';
  static const _deviceIdKey = 'desktopNotificationDeviceId';
  static const _enabledKey = 'desktopNotificationsEnabled';
  static const _channel = 'desktop';

  NotificationsRepository get _repo => ref.read(notificationsRepositoryProvider);

  @override
  DeviceNotificationsState build() {
    unawaited(_load());
    return const DeviceNotificationsState();
  }

  String? get _deviceId {
    if (!Hive.isBoxOpen(_boxName)) return null;
    return Hive.box<dynamic>(_boxName).get(_deviceIdKey) as String?;
  }

  Future<void> _load() async {
    try {
      final res = await _repo.endpoints(channel: _channel);
      if (!ref.mounted) return;
      final deviceId = _deviceId;
      final endpoints = res['endpoints'] as List? ?? const [];
      final mine = deviceId == null
          ? null
          : endpoints.whereType<Map<dynamic, dynamic>>().firstWhere(
              (e) => e['endpointId'] == deviceId,
              orElse: () => const <String, dynamic>{},
            );
      final enabled =
          deviceId != null && mine != null && mine.isNotEmpty && mine['enabled'] == true;
      state = DeviceNotificationsState(enabled: enabled, loading: false);
    } on AppError {
      // Server pre-dates the endpoints API — fall back to the local flag.
      if (ref.mounted) {
        final stored = Hive.isBoxOpen(_boxName)
            ? Hive.box<dynamic>(_boxName).get(_enabledKey) == true
            : false;
        state = DeviceNotificationsState(enabled: stored, loading: false);
      }
    }
  }

  Future<void> _persist(String? deviceId, bool enabled) async {
    if (!Hive.isBoxOpen(_boxName)) return;
    final box = Hive.box<dynamic>(_boxName);
    if (deviceId != null) await box.put(_deviceIdKey, deviceId);
    await box.put(_enabledKey, enabled);
  }

  /// Register this device for WS-pushed notifications. Returns an error
  /// message on failure (no `registered` frame / transport error).
  Future<String?> enable() async {
    if (state.busy) return null;
    state = DeviceNotificationsState(enabled: state.enabled, busy: true);
    final deviceId =
        _deviceId ??
        'flutter-${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(1 << 32)}';
    final channel = ref.read(desktopNotificationsChannelProvider);
    try {
      await channel.connect();
      channel.register(
        deviceId: deviceId,
        label: t.notifications.deviceLabel,
        platform: kIsWeb ? 'web' : defaultTargetPlatform.name,
      );
      // Wait briefly for the server's `registered` ack so silent failures
      // (closed socket, missing deviceId) surface instead of a fake "on".
      final ack = await channel.notifications
          .firstWhere((n) => n.isRegistered || n.isError)
          .timeout(const Duration(seconds: 5));
      if (ack.isError) {
        throw ServerError(t.notifications.errors.registrationRejected, 0);
      }
      await _persist(deviceId, true);
      if (!ref.mounted) return null;
      state = const DeviceNotificationsState(enabled: true, loading: false);
      return null;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = DeviceNotificationsState(enabled: false, loading: false, error: e.message);
      }
      return e.message;
    } on TimeoutException {
      final message = t.notifications.errors.noResponse;
      if (ref.mounted) {
        state = DeviceNotificationsState(enabled: false, loading: false, error: message);
      }
      return message;
    } on Object catch (e) {
      if (ref.mounted) {
        state = DeviceNotificationsState(enabled: false, loading: false, error: e.toString());
      }
      return e.toString();
    }
  }

  /// Disable this device's endpoint and drop the socket (see class doc —
  /// the server re-enables on every register frame).
  Future<String?> disable() async {
    if (state.busy) return null;
    final deviceId = _deviceId;
    state = DeviceNotificationsState(enabled: true, busy: true);
    try {
      if (deviceId != null) {
        await _repo.updateEndpoint(_channel, deviceId, {'enabled': false});
      }
      await ref.read(desktopNotificationsChannelProvider).close();
      await _persist(null, false);
      if (!ref.mounted) return null;
      state = const DeviceNotificationsState(enabled: false, loading: false);
      return null;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = DeviceNotificationsState(
          enabled: state.enabled,
          loading: false,
          busy: false,
          error: e.message,
        );
      }
      return e.message;
    }
  }
}

final deviceNotificationsProvider =
    NotifierProvider<DeviceNotificationsController, DeviceNotificationsState>(
      DeviceNotificationsController.new,
    );
