import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Copies [text] to the system clipboard and always gives the user feedback.
///
/// `Clipboard.setData` can reject (web without transient activation, denied
/// permission, desktop without a clipboard backend) and a swallowed rejection
/// looks exactly like a dead button. Returns `true` on success.
Future<bool> copyTextWithFeedback(BuildContext context, String text) async {
  if (text.trim().isEmpty) return false;
  final t = Translations.of(context).chat.copyMessage;
  try {
    await Clipboard.setData(ClipboardData(text: text));
  } on Object {
    if (context.mounted) AppToast.error(context, t.failed);
    return false;
  }
  if (context.mounted) AppToast.show(context, t.copied);
  return true;
}
