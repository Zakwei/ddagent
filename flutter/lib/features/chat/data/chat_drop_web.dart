import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// One file offered to the composer by a browser paste or drop.
typedef DroppedFile = ({String name, Uint8List bytes});

/// Flutter's web engine only routes *text* pastes to the framework, so image
/// paste and drag-and-drop must be read straight off the DOM — the same thing
/// the legacy React client does (`collectPastedFiles` + `handleDrop`).
///
/// Handlers are kept in locals so the returned disposer can remove the exact
/// same JS functions (a fresh `.toJS` would not match).
void Function() listenForChatFileInputs(void Function(DroppedFile file) onFile) {
  void handlePaste(web.Event event) {
    final e = event as web.ClipboardEvent;
    final items = e.clipboardData?.items;
    if (items == null) return;
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (item.kind != 'file') continue;
      // Images first; `getAsFile()` is null for non-file items.
      final file = item.getAsFile();
      if (file == null) continue;
      _read(file, onFile);
      // Let the browser handle text pastes untouched.
    }
  }

  void handleDragOver(web.Event event) {
    // Needed so the browser fires `drop` instead of opening the file.
    event.preventDefault();
  }

  void handleDrop(web.Event event) {
    final e = event as web.DragEvent;
    event.preventDefault();
    final files = e.dataTransfer?.files;
    if (files == null) return;
    for (var i = 0; i < files.length; i++) {
      _read(files.item(i)!, onFile);
    }
  }

  final pasteJs = handlePaste.toJS;
  final dragOverJs = handleDragOver.toJS;
  final dropJs = handleDrop.toJS;

  web.document.addEventListener('paste', pasteJs);
  web.document.addEventListener('dragover', dragOverJs);
  web.document.addEventListener('drop', dropJs);

  return () {
    web.document.removeEventListener('paste', pasteJs);
    web.document.removeEventListener('dragover', dragOverJs);
    web.document.removeEventListener('drop', dropJs);
  };
}

void _read(web.File file, void Function(DroppedFile file) onFile) {
  final reader = web.FileReader();
  reader.onload = ((web.Event _) {
    final result = reader.result;
    if (result == null) return;
    final bytes = (result as JSArrayBuffer).toDart.asUint8List();
    onFile((name: file.name.isEmpty ? 'pasted-image' : file.name, bytes: bytes));
  }).toJS;
  reader.readAsArrayBuffer(file);
}
