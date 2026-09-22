// Runnable check for the remote-notifications TLS pinning helper — runs under
// plain node (no electron import): node electron/scripts/check-notification-tls.mjs
import crypto from 'node:crypto';

import { fingerprintMatches } from '../tlsPinning.js';

const certRaw = crypto.randomBytes(64);
const digest = crypto.createHash('sha256').update(certRaw).digest('base64');

const cases = [
  ['chromium sha256/ fingerprint matches', fingerprintMatches(`sha256/${digest}`, certRaw) === true],
  ['bare base64 fingerprint matches', fingerprintMatches(digest, certRaw) === true],
  ['different cert is rejected', fingerprintMatches(`sha256/${digest}`, crypto.randomBytes(64)) === false],
  ['missing fingerprint is rejected', fingerprintMatches(null, certRaw) === false],
  ['missing cert is rejected', fingerprintMatches(`sha256/${digest}`, null) === false],
  ['garbage fingerprint is rejected', fingerprintMatches('not-a-fingerprint', certRaw) === false],
];

let failed = false;
for (const [name, ok] of cases) {
  console.log(`${ok ? 'PASS' : 'FAIL'} ${name}`);
  if (!ok) failed = true;
}
process.exit(failed ? 1 : 0);
