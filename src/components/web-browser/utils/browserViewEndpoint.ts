/**
 * Builds the `/browser-view` websocket URL for the current page.
 *
 * Platform mode bypasses websocket auth, so a missing token is valid there;
 * OSS mode requires the token query parameter. Keeping this pure makes the
 * pane testable without the Vite `import.meta.env` runtime.
 */
export function buildBrowserViewEndpoint(options: {
  protocol: string;
  host: string;
  token: string | null;
}): string {
  const scheme = options.protocol === 'https:' ? 'wss:' : 'ws:';
  const base = `${scheme}//${options.host}/browser-view`;
  return options.token ? `${base}?token=${encodeURIComponent(options.token)}` : base;
}
