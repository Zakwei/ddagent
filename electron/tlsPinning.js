import crypto from 'node:crypto';

// Chromium's certificate-error event reports fingerprints as
// 'sha256/<base64-der-digest>' while a Node TLS socket exposes the peer cert
// as raw DER bytes — compare digests so the formats never have to match.
export function fingerprintMatches(trustedFingerprint, certRaw) {
  const expected = String(trustedFingerprint || '').replace(/^sha256\//i, '').trim();
  if (!expected || !certRaw) return false;
  try {
    return crypto.createHash('sha256').update(certRaw).digest('base64') === expected;
  } catch {
    return false;
  }
}
