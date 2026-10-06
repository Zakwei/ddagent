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
import { readFileSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const rootDir = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..');
const spec = process.argv[2];

if (!spec) {
  console.error('Usage: npm run release -- <x.y.z | patch | minor | major>');
  process.exit(1);
}

// Resolve the target version first — the Flutter client's pubspec rides in
// the same release commit, so Android builds get versionName = semver and a
// monotonically increasing versionCode (Play/sideload update requirement).
const pkg = JSON.parse(readFileSync(path.join(rootDir, 'package.json'), 'utf8'));
const [maj, min, pat] = pkg.version.split('.').map(Number);
const next = /^\d+\.\d+\.\d+/.test(spec)
  ? spec
  : spec === 'major' ? `${maj + 1}.0.0`
  : spec === 'minor' ? `${maj}.${min + 1}.0`
  : `${maj}.${min}.${pat + 1}`;
const [nMaj, nMin, nPat] = next.split('.').map(Number);
const pubspecPath = path.join(rootDir, 'flutter', 'pubspec.yaml');
const pubspec = readFileSync(pubspecPath, 'utf8');
const versionLine = `version: ${next}+${nMaj * 10000 + nMin * 100 + nPat}`;
if (!/^version: .+$/m.test(pubspec)) {
  console.error('pubspec.yaml: no version line found');
  process.exit(1);
}
writeFileSync(pubspecPath, pubspec.replace(/^version: .+$/m, versionLine));
execFileSync('git', ['add', 'flutter/pubspec.yaml'], { cwd: rootDir });

// `npm version` refuses to touch a dirty working tree, and pubspec.yaml must
// ride in the same commit — so bump the manifests only, then commit + tag
// by hand. The push stays explicit on purpose.
execFileSync('npm', ['version', '--no-git-tag-version', spec], { cwd: rootDir, stdio: 'inherit' });
const { version } = JSON.parse(readFileSync(path.join(rootDir, 'package.json'), 'utf8'));
execFileSync('git', ['add', 'package.json', 'package-lock.json'], { cwd: rootDir });
execFileSync('git', ['commit', '-m', version], { cwd: rootDir, stdio: 'inherit' });
execFileSync('git', ['tag', `v${version}`], { cwd: rootDir });

console.log(`\nTagged v${version}. Push the commit + tag to trigger the server release build:`);
console.log(`  git push origin HEAD v${version}`);
