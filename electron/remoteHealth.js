const DEFAULT_TIMEOUT_MS = 5000;

// Node TLS error codes observed through fetch's `err.cause.code`.
const TLS_ERROR_PATTERN = /^(SELF_SIGNED|CERT_|DEPTH_ZERO|UNABLE_TO_|ERR_TLS|HOSTNAME_MISMATCH)/;

function errorCode(error) {
  // Global fetch wraps network failures in `TypeError: fetch failed` and
  // stashes the underlying error (with `.code`) on `.cause`.
  return error?.cause?.code || error?.code || '';
}

function errorMessage(error) {
  return error?.cause?.message || error?.message || '';
}

function isTlsError(error) {
  return TLS_ERROR_PATTERN.test(errorCode(error)) || /certificate/i.test(errorMessage(error));
}

function normalizeBaseUrl(input) {
  const raw = String(input || '').trim();
  if (!raw) return null;

  const withScheme = /^[a-zA-Z][a-zA-Z0-9+.-]*:\/\//.test(raw) ? raw : `https://${raw}`;
  try {
    const parsed = new URL(withScheme);
    if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') return null;
    return parsed.origin;
  } catch {
    return null;
  }
}

export async function checkRemoteServer(url, { timeoutMs = DEFAULT_TIMEOUT_MS } = {}) {
  const base = normalizeBaseUrl(url);
  if (!base) {
    return { ok: false, reason: 'offline', message: `Invalid server URL: ${String(url)}` };
  }

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), timeoutMs);
  try {
    const response = await fetch(`${base}/health`, {
      signal: controller.signal,
      headers: { accept: 'application/json' },
    });

    if (!response.ok) {
      return {
        ok: false,
        reason: `http-${response.status}`,
        message: `Health check returned HTTP ${response.status}.`,
      };
    }

    let body;
    try {
      body = await response.json();
    } catch {
      return { ok: false, reason: 'not-ddagent', message: 'Health check did not return JSON.' };
    }

    if (body?.status !== 'ok') {
      return { ok: false, reason: 'not-ddagent', message: 'Response is not a ddagent health check.' };
    }

    return { ok: true, version: body.version ?? null, installMode: body.installMode ?? null };
  } catch (error) {
    if (controller.signal.aborted || error?.name === 'AbortError' || error?.name === 'TimeoutError') {
      return { ok: false, reason: 'timeout', message: `Health check timed out after ${timeoutMs}ms.` };
    }
    if (isTlsError(error)) {
      return { ok: false, reason: 'tls-error', message: errorMessage(error) || 'TLS certificate error.' };
    }
    return { ok: false, reason: 'offline', message: errorMessage(error) || 'Server is unreachable.' };
  } finally {
    clearTimeout(timer);
  }
}
