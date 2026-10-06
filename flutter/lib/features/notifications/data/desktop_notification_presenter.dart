import 'package:ddagent_app/features/notifications/data/desktop_notification_presenter_io.dart'
    if (dart.library.js_interop) 'package:ddagent_app/features/notifications/data/desktop_notification_presenter_web.dart';

/// Asks the platform for permission to display notifications.
///
/// Web: triggers the browser permission prompt.
/// Native (Android/iOS/macOS): requests the OS notification permission.
/// Call during a user gesture.
Future<bool> requestDesktopNotificationPermission() => requestPermissionImpl();

/// Displays a notification through the platform surface (web: Notification API;
/// Android/iOS/macOS: an OS notification).
///
/// Returns false when the platform cannot show one — unsupported, permission
/// denied, or a build without a notification surface (Linux/Windows) — so the
/// caller can fall back to an in-app toast.
Future<bool> showDesktopNotification({required String title, required String body}) =>
    showImpl(title: title, body: body);
