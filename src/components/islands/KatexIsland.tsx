import { useMemo } from 'react';
import { useSearchParams } from 'react-router-dom';
import katex from 'katex';

import 'katex/dist/katex.min.css';

/**
 * WebView island for React Native: renders one math block with KaTeX.
 * URL: /island/katex?code=<base64url>&display=1
 *
 * KaTeX needs no runtime beyond renderToString + the CSS import — safe to
 * load eagerly inside the island chunk.
 */
export default function KatexIsland() {
  const [searchParams] = useSearchParams();

  const html = useMemo(() => {
    const raw = searchParams.get('code') ?? '';
    if (!raw) return '';
    try {
      const normalized = raw.replace(/-/g, '+').replace(/_/g, '/');
      const code = decodeURIComponent(escape(atob(normalized)));
      return katex.renderToString(code, {
        displayMode: searchParams.get('display') === '1',
        throwOnError: false,
        output: 'html',
      });
    } catch {
      return '';
    }
  }, [searchParams]);

  if (!html) {
    return <div className="flex h-screen items-center justify-center bg-background text-destructive">invalid math</div>;
  }
  return (
    <div
      className="flex min-h-screen w-screen items-center justify-center overflow-auto bg-background p-3 text-foreground"
      // KaTeX emits sanitized classed markup — same trust level as web chat.
      dangerouslySetInnerHTML={{ __html: html }}
    />
  );
}
