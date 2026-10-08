#!/usr/bin/env node
// Applies a server update staged by the running server (POST /api/system/update
// on a release tarball install) — see updateBundle in
// server/modules/system/system.service.ts.
//
// The bundled start.sh / start.bat run this before every server start, while
// no ddagent process holds the install's files open (Windows cannot replace
// loaded native modules). It moves each top-level entry of `.update/next` over
// the install — keeping the launchers (they are executing right now) and the
// user's `.env` — and parks what it replaced in `.update-previous`.
//
//   node scripts/apply-update.cjs              apply a staged update (no-op without one)
//   node scripts/apply-update.cjs --rollback   put `.update-previous` back
//
// The launchers roll back on their own when the first start after an update
// fails, so a broken release never leaves the server down.
'use strict';

const fs = require('node:fs');
const path = require('node:path');

const root = path.resolve(__dirname, '..');
const updateDirectory = path.join(root, '.update');
const nextDirectory = path.join(updateDirectory, 'next');
const previousDirectory = path.join(root, '.update-previous');
const keep = new Set(['start.sh', 'start.bat', '.env', '.update', '.update-previous']);

/** Moves every top-level entry of [from] over [root], parking replaced ones in [park]. */
function swapIn(from, park) {
  if (park) {
    fs.rmSync(park, { recursive: true, force: true });
    fs.mkdirSync(park, { recursive: true });
  }
  for (const entry of fs.readdirSync(from)) {
    if (keep.has(entry)) continue;
    const target = path.join(root, entry);
    if (fs.existsSync(target)) {
      if (park) fs.renameSync(target, path.join(park, entry));
      else fs.rmSync(target, { recursive: true, force: true });
    }
    fs.renameSync(path.join(from, entry), target);
  }
}

if (process.argv.includes('--rollback')) {
  if (!fs.existsSync(previousDirectory)) process.exit(1);
  try {
    swapIn(previousDirectory, null);
    fs.rmSync(previousDirectory, { recursive: true, force: true });
    console.error('[ddagent] the updated server failed to start — restored the previous version');
  } catch (error) {
    console.error('[ddagent] could not restore the previous version:', error);
    process.exit(1);
  }
  process.exit(0);
}

if (!fs.existsSync(path.join(updateDirectory, 'ready')) || !fs.existsSync(nextDirectory)) {
  process.exit(1);
}

const version = fs.readFileSync(path.join(updateDirectory, 'ready'), 'utf8').trim();
try {
  swapIn(nextDirectory, previousDirectory);
  fs.rmSync(updateDirectory, { recursive: true, force: true });
  console.log(`[ddagent] applied server update ${version}`);
} catch (error) {
  // Leave `.update` in place: the next start retries the remaining entries.
  console.error(`[ddagent] could not apply server update ${version}:`, error);
  process.exit(1);
}
