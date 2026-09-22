import { useEffect, useState } from 'react';
import { useSearchParams } from 'react-router-dom';

import MermaidDiagram from '../code-editor/view/subcomponents/markdown/MermaidDiagram';

/**
 * WebView island for React Native: renders one ```mermaid block.
 * URL: /island/mermaid?code=<base64url>
 *
 * The diagram auto-fits the WebView viewport (max-width/max-height 100%),
 * so the host can size the WebView and the SVG scales inside it.
 */
export default function MermaidIsland() {
  const [searchParams] = useSearchParams();
  const [code, setCode] = useState<string | null>(null);

  useEffect(() => {
    const raw = searchParams.get('code') ?? '';
    try {
      // base64url in the query keeps arbitrary diagram source intact.
      const normalized = raw.replace(/-/g, '+').replace(/_/g, '/');
      setCode(decodeURIComponent(escape(atob(normalized))));
    } catch {
      setCode('');
    }
  }, [searchParams]);

  if (code === null) {
    return <div className="flex h-screen items-center justify-center bg-background text-muted-foreground">…</div>;
  }
  if (!code) {
    return <div className="flex h-screen items-center justify-center bg-background text-destructive">invalid diagram</div>;
  }
  return (
    <div className="flex h-screen w-screen items-center justify-center overflow-auto bg-background p-2 [&_svg]:max-w-full">
      <MermaidDiagram code={code} />
    </div>
  );
}
