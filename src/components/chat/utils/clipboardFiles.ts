/**
 * Files carried by a paste event.
 *
 * `files` is the canonical list; `items[].getAsFile()` is only a fallback for
 * browsers that leave it empty. Reading both would attach one clipboard image
 * twice: getAsFile() mints a fresh File (with a new `lastModified`) on every
 * call, so the two views of the same paste cannot be told apart.
 */
export function collectPastedFiles(clipboardData: DataTransfer): File[] {
  const files = Array.from(clipboardData.files);
  if (files.length > 0) {
    return files;
  }

  const fallback: File[] = [];
  for (const item of Array.from(clipboardData.items)) {
    if (item.kind !== 'file') {
      continue;
    }
    const file = item.getAsFile();
    if (file) {
      fallback.push(file);
    }
  }
  return fallback;
}
