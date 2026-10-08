import 'dart:io' show Platform;

import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Native notification surface for Android, iOS, macOS, Linux (freedesktop
/// D-Bus) and Windows (toast) via `flutter_local_notifications`. When a call
/// fails the caller falls back to an in-app toast.
final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
bool _initialized = false;

bool get _hasNativeSurface =>
    Platform.isAndroid ||
    Platform.isIOS ||
    Platform.isMacOS ||
    Platform.isLinux ||
    Platform.isWindows;

Future<void> _ensureInitialized() async {
  if (_initialized) return;
  const settings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    // Permissions are requested explicitly on the enable gesture, not on init.
    iOS: DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    ),
    macOS: DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    ),
    linux: LinuxInitializationSettings(defaultActionName: 'Open'),
    // Unpackaged (Inno Setup) build: the plugin registers this AUMID/GUID
    // itself. Keep both stable — changing them orphans the toast registration.
    windows: WindowsInitializationSettings(
      appName: 'DDAgent',
      appUserModelId: 'DDNet.DDAgent',
      guid: '6f1c2a3e-8b4d-4e7a-9c55-2d0f3b8a7e41',
    ),
  );
  await _plugin.initialize(settings: settings);
  _initialized = true;
}

/// Requests the OS notification permission — Android 13+ `POST_NOTIFICATIONS`
/// or the alert permission on iOS/macOS. Must be called from a user gesture.
/// Linux/Windows have no runtime permission — initializing is enough.
Future<bool> requestPermissionImpl() async {
  if (!_hasNativeSurface) return false;
  try {
    await _ensureInitialized();
    if (Platform.isAndroid) {
      return await _plugin
              .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
              ?.requestNotificationsPermission() ??
          false;
    }
    if (Platform.isLinux || Platform.isWindows) return true;
    if (Platform.isIOS) {
      return await _plugin
              .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    return await _plugin
            .resolvePlatformSpecificImplementation<MacOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, badge: true, sound: true) ??
        false;
  } on Object {
    return false;
  }
}

/// Shows an OS notification. Returns false when the platform has no surface or
/// the OS rejects the post (e.g. permission denied), so the caller can fall
/// back to an in-app toast.
Future<bool> showImpl({required String title, required String body}) async {
  if (!_hasNativeSurface) return false;
  try {
    await _ensureInitialized();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'ddagent_alerts',
        t.notifications.androidChannel.name,
        channelDescription: t.notifications.androidChannel.description,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
      macOS: const DarwinNotificationDetails(),
    );
    // A per-notification id keeps alerts stacked instead of replacing one another.
    final id = DateTime.now().microsecondsSinceEpoch.remainder(1 << 31);
    await _plugin.show(id: id, title: title, body: body, notificationDetails: details);
    return true;
  } on Object {
    return false;
  }
}
