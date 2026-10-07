// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

/// Reloads the browser tab so the client re-bootstraps against the restarted
/// server. The web original reloaded here, and the restart copy promises it
/// ("the page will reload when the server is back"). The page unloads
/// immediately, so the return value only satisfies the caller's branch.
bool reloadClient() {
  html.window.location.reload();
  return true;
}
