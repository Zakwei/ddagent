/** Pure URL helpers — no RN/storage deps, so they run under plain Node too. */

/** Normalizes user input into a base URL (adds https://, strips trailing /). */
export const normalizeServerUrl = (raw: string): string => {
  let url = raw.trim();
  if (!url) return '';
  if (!/^https?:\/\//i.test(url)) url = `https://${url}`;
  return url.replace(/\/+$/, '');
};

/** WS base for a given http(s) server URL. */
export const wsBaseFor = (base: string): string =>
  base.replace(/^http:/, 'ws:').replace(/^https:/, 'wss:');
