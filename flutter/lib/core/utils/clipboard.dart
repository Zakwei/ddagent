import 'package:ddagent_app/core/utils/clipboard_fallback_stub.dart'
    if (dart.library.js_interop) 'package:ddagent_app/core/utils/clipboard_fallback_web.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Copies [text] to the system clipboard without UI feedback.
///
/// `Clipboard.setData` can reject (web without transient activation, denied
/// permission, desktop without a clipboard backend) — on web it falls back to
/// `execCommand('copy')`, which still works in non-secure contexts. Returns
/// `true` on success.
Future<bool> copyText(String text) async {
  if (text.trim().isEmpty) return false;
  try {
    await Clipboard.setData(ClipboardData(text: text));
  } on Object {
    return kIsWeb && legacyClipboardCopy(text);
  }
  return true;
}

/// Copies [text] to the system clipboard and always gives the user feedback.
///
/// A swallowed rejection looks exactly like a dead button.
Future<bool> copyTextWithFeedback(BuildContext context, String text) async {
  if (text.trim().isEmpty) return false;
  final t = Translations.of(context).chat.copyMessage;
  if (!await copyText(text)) {
    if (context.mounted) AppToast.error(context, t.failed);
    return false;
  }
  if (context.mounted) AppToast.show(context, t.copied);
  return true;
}
