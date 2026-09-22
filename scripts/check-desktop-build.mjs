// Preflight for `npm run test:desktop` — the in-proc smoke boots the REAL
// production bundles (dist/ is served over ddagent-app:// by
// protocol.handle, dist-server/ is the embedded backend). Fail fast with a
// clear message instead of letting Electron boot into a broken app.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const required = ['dist/index.html', 'dist-server/server/index.js'];
const missing = required.filter((rel) => !fs.existsSync(path.join(root, rel)));

if (missing.length) {
  console.error(`test:desktop needs the built app — missing: ${missing.join(', ')}`);
  console.error('Run `npm run build` first (builds dist/ + dist-server/).');
  process.exit(1);
}
