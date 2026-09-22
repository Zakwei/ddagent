import { useEffect, useState } from 'react';
import { useSearchParams } from 'react-router-dom';

import { api } from '../../utils/api';
import type { ProjectSession } from '../../types/app';
import StandaloneShell from '../standalone-shell/view/StandaloneShell';

/**
 * WebView island entry point for the React Native app.
 * URL: /island/terminal?session=<sessionId>&token=<jwt>
 *
 * Lives outside ProtectedRoute: the JWT arrives via query param and is planted
 * into localStorage synchronously during the first render, so every downstream
 * authenticatedFetch (including the /shell socket's token) picks it up.
 */
export default function TerminalIsland() {
  const [searchParams] = useSearchParams();
  const [session, setSession] = useState<ProjectSession | null>(null);
  const [error, setError] = useState<string | null>(null);

  // Plant the token before any child/effect can fire an authed request.
  const [ready] = useState(() => {
    const token = searchParams.get('token');
    if (token) localStorage.setItem('auth-token', token);
    return true;
  });
  void ready;

  const sessionId = searchParams.get('session') ?? '';

  useEffect(() => {
    if (!sessionId) {
      setError('missing session param');
      return;
    }
    api
      .sessionDetails(sessionId)
      .then(async (res) => {
        if (!res.ok) {
          setError(`session lookup failed (${res.status})`);
          return;
        }
        const data = await res.json();
        setSession(data?.session ?? data);
      })
      .catch((err) => setError(err instanceof Error ? err.message : 'load failed'));
  }, [sessionId]);

  if (error) {
    return <div className="flex h-screen items-center justify-center bg-background text-destructive">{error}</div>;
  }
  if (!session) {
    return <div className="flex h-screen items-center justify-center bg-background text-muted-foreground">Loading…</div>;
  }
  return (
    <div className="h-screen w-screen bg-background">
      <StandaloneShell
        session={session}
        autoConnect
        minimal
        showHeader={false}
        onComplete={() => {
          // Report process exit to the React Native host (ignored on web).
          (window as any).ReactNativeWebView?.postMessage(JSON.stringify({ type: 'exit' }));
        }}
      />
    </div>
  );
}
