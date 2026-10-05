#!/usr/bin/env node
// Release version bump.
//
//   npm run release -- <x.y.z | patch | minor | major>
//
// Runs `npm version <spec>` which bumps package.json + package-lock.json,
// creates the release commit and the `vX.Y.Z` git tag that
// .github/workflows/server-release.yml builds from — its tag guard requires
// tag === 'v' + package.json version, so never tag by hand.
//
// The server tarball's /health `version` comes from package.json.
import { execFileSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const rootDir = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
const spec = process.argv[2];

if (!spec) {
  console.error('Usage: npm run release -- <x.y.z | patch | minor | major>');
  process.exit(1);
}

// `npm version` does bump + release commit + `v*` tag in one step and refuses
// a dirty working tree on its own. The push stays explicit on purpose.
execFileSync('npm', ['version', spec], { cwd: rootDir, stdio: 'inherit' });

const { version } = JSON.parse(readFileSync(path.join(rootDir, 'package.json'), 'utf8'));
console.log(`\nTagged v${version}. Push the commit + tag to trigger the server release build:`);
console.log(`  git push origin HEAD v${version}`);
