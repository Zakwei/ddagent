import { useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';

import CodeEditor from '../code-editor/view/CodeEditor';
import type { CodeEditorFile } from '../code-editor/types/types';

/**
 * WebView island entry point for the React Native app.
 * URL: /island/editor?project=<projectId>&path=<filePath>&token=<jwt>
 *
 * Same token-via-query trick as TerminalIsland — the JWT is planted into
 * localStorage synchronously so CodeEditor's saveFile/readFile calls auth.
 */
export default function EditorIsland() {
  const [searchParams] = useSearchParams();
  const [closed, setClosed] = useState(false);

  useState(() => {
    const token = searchParams.get('token');
    if (token) localStorage.setItem('auth-token', token);
    return true;
  });

  const file = useMemo<CodeEditorFile | null>(() => {
    const path = searchParams.get('path');
    const projectId = searchParams.get('project') ?? undefined;
    if (!path) return null;
    return { name: path.split('/').pop() ?? path, path, projectId };
  }, [searchParams]);

  if (!file) {
    return <div className="flex h-screen items-center justify-center bg-background text-destructive">missing path param</div>;
  }
  if (closed) {
    return <div className="flex h-screen items-center justify-center bg-background text-muted-foreground">Closed</div>;
  }
  return (
    <div className="h-screen w-screen bg-background">
      <CodeEditor file={file} onClose={() => setClosed(true)} isExpanded />
    </div>
  );
}
