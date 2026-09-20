/**
 * After the AI edits a source file, chat can nudge the user to run the
 * corresponding test. These helpers are intentionally pure so the path
 * convention logic is unit-testable without a DOM or the file-tree API.
 */

const normalize = (value: string): string => value.replace(/\\/g, '/');

const isTestFile = (path: string): boolean => /\.(test|spec)\.[^./]+$/i.test(path);

/**
 * Plausible sibling test paths for an edited source file, in priority order.
 *
 * For `src/chat/hooks/useFoo.ts` this returns:
 *   src/chat/hooks/useFoo.test.ts
 *   src/chat/hooks/useFoo.test.tsx
 *   src/chat/hooks/__tests__/useFoo.test.ts
 *   src/chat/hooks/__tests__/useFoo.test.tsx
 *
 * Non-TypeScript sources get `.test.js`/`.test.jsx` instead. Paths are always
 * returned with forward slashes. An input that is already a test/spec file
 * returns `[]` — there is nothing to nudge.
 */
export const findTestFileCandidates = (filePath: string): string[] => {
  if (!filePath) {
    return [];
  }

  const normalized = normalize(filePath);
  if (isTestFile(normalized)) {
    return [];
  }

  const extensionMatch = normalized.match(/\.[^./]+$/);
  const extension = extensionMatch ? extensionMatch[0] : '';
  const ext = extension.slice(1).toLowerCase();

  const isTypeScript = ['ts', 'tsx', 'mts', 'cts'].includes(ext);
  const isJavaScript = ['js', 'jsx', 'mjs', 'cjs'].includes(ext);
  if (!isTypeScript && !isJavaScript) {
    return [];
  }

  const base = extension ? normalized.slice(0, -extension.length) : normalized;
  const directory = base.includes('/') ? base.slice(0, base.lastIndexOf('/') + 1) : '';
  const name = base.slice(directory.length);

  const testExtensions = isTypeScript ? ['ts', 'tsx'] : ['js', 'jsx'];
  const candidates: string[] = [];

  for (const testExtension of testExtensions) {
    candidates.push(`${base}.test.${testExtension}`);
  }
  for (const testExtension of testExtensions) {
    candidates.push(`${directory}__tests__/${name}.test.${testExtension}`);
  }

  return candidates;
};

/**
 * First candidate that exists in `projectFiles`, else `null`. Project files are
 * often absolute while the edited path is relative, so a candidate also matches
 * when a project entry ends with `/<candidate>`.
 */
export const findExistingTest = (
  editedFilePath: string,
  projectFiles: string[],
): string | null => {
  const candidates = findTestFileCandidates(editedFilePath);
  if (candidates.length === 0) {
    return null;
  }

  const normalizedFiles = projectFiles
    .map((file) => ({ original: file, normalized: normalize(file) }))
    .filter((file) => Boolean(file.normalized));

  for (const candidate of candidates) {
    const match = normalizedFiles.find(
      (file) => file.normalized === candidate || file.normalized.endsWith(`/${candidate}`),
    );
    if (match) {
      return match.original;
    }
  }

  return null;
};
