/// Native/desktop: `Clipboard.setData` is authoritative — there is no
/// execCommand equivalent to fall back to, so a failure there is a real
/// failure.
bool legacyClipboardCopy(String text) => false;
