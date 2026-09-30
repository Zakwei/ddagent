import 'dart:typed_data';

/// One file offered to the composer by a browser paste or drop.
typedef DroppedFile = ({String name, Uint8List bytes});

/// Native/tests build: there is no browser to read pastes or drops from, so
/// this is a no-op that returns a disposer.
void Function() listenForChatFileInputs(
  void Function(DroppedFile file) onFile,
) => () {};
