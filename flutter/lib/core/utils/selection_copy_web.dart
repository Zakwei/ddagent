import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Canvas-rendered selections (SelectionArea) copy via `Clipboard.setData` →
/// `navigator.clipboard.writeText`, which does not exist in a non-secure
/// context — the plain-HTTP flutter-web deployment — so Ctrl+C silently did
/// nothing. The DOM `copy` event + `clipboardData.setData` writes the
/// clipboard in any context during a real keypress; we feed it the text the
/// last active selection reported.
String _selectionText = '';
bool _installed = false;

void reportSelectionText(String? text) {
  _selectionText = text ?? '';
  _install();
}

void _install() {
  if (_installed) return;
  _installed = true;
  web.document.addEventListener(
    'copy',
    (web.Event e) {
      final event = e as web.ClipboardEvent;
      // Real DOM selections (textarea in dialogs, monaco, ...) win — canvas
      // selections never populate window.getSelection().
      if (web.window.getSelection()?.toString().isNotEmpty ?? false) return;
      if (_selectionText.isEmpty) return;
      event.clipboardData?.setData('text/plain', _selectionText);
      event.preventDefault();
    }.toJS,
  );
}
