export const IN_APP_BROWSER_EVENT = 'ddagent:open-browser';

/**
 * Asks the workspace to open `url` in a browser pane.
 *
 * Works in the Electron shell and in a plain browser: the pane renders a
 * `<webview>` when the desktop bridge exists and the server-side remote browser
 * otherwise. The pane host claims the event with `preventDefault()`, so the
 * return value says whether a pane actually opened — callers fall back to the
 * system browser when it is false.
 */
export function openInAppBrowser(url: string): boolean {
  if (!/^https?:\/\//i.test(url)) return false;
  const event = new CustomEvent(IN_APP_BROWSER_EVENT, { detail: { url }, cancelable: true });
  return !window.dispatchEvent(event);
}
