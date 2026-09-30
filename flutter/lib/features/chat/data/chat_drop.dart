/// Attaches browser-level paste (Ctrl+V) and drag-and-drop listeners for chat
/// attachments. Flutter's web engine only forwards text pastes to the
/// framework, so images pasted or dropped into the chat would otherwise be
/// ignored — this reads them off the DOM like the legacy web client.
library;

export 'package:ddagent_app/features/chat/data/chat_drop_stub.dart'
    if (dart.library.js_interop) 'package:ddagent_app/features/chat/data/chat_drop_web.dart';
