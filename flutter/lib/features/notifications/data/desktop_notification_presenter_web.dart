import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Browser permission prompt for the Notification API.
Future<bool> requestPermissionImpl() async {
  try {
    final result = await web.Notification.requestPermission().toDart;
    return result.toDart == 'granted';
  } on Object {
    return false;
  }
}

/// Shows a browser notification when permission has been granted.
Future<bool> showImpl({required String title, required String body}) async {
  try {
    if (web.Notification.permission != 'granted') return false;
    web.Notification(title, web.NotificationOptions(body: body));
    return true;
  } on Object {
    return false;
  }
}
