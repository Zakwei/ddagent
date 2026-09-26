import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const rootDir = path.resolve(__dirname, '../..');

export function generateThirdPartyNotices({
  rootDir: targetRootDir = rootDir,
  outputPath = path.join(rootDir, 'THIRD_PARTY_NOTICES.md'),
} = {}) {
  const lockFilePath = path.join(targetRootDir, 'package-lock.json');
  if (!fs.existsSync(lockFilePath)) {
    throw new Error(`package-lock.json not found at ${lockFilePath}`);
  }

  const lockFile = JSON.parse(fs.readFileSync(lockFilePath, 'utf8'));
  const packages = lockFile.packages || {};

  const collected = new Map();

  for (const [pkgPath, meta] of Object.entries(packages)) {
    if (!pkgPath || meta.dev) continue; // skip root and pure dev dependencies

    const packageName = meta.name || pkgPath.replace(/^.*node_modules\//, '');
    const version = meta.version;
    const key = `${packageName}@${version}`;

    if (collected.has(key)) continue;

    const fullPkgDir = path.join(targetRootDir, pkgPath);
    let licenseText = '';
    let author = meta.author || '';
    let repository = '';

    if (fs.existsSync(fullPkgDir)) {
      try {
        const pkgJsonPath = path.join(fullPkgDir, 'package.json');
        if (fs.existsSync(pkgJsonPath)) {
          const pkgJson = JSON.parse(fs.readFileSync(pkgJsonPath, 'utf8'));
          if (!author && pkgJson.author) {
            author = typeof pkgJson.author === 'string'
              ? pkgJson.author
              : `${pkgJson.author.name || ''} ${pkgJson.author.email ? `<${pkgJson.author.email}>` : ''}`.trim();
          }
          if (pkgJson.repository) {
            repository = typeof pkgJson.repository === 'string'
              ? pkgJson.repository
              : pkgJson.repository.url || '';
          }
        }

        const entries = fs.readdirSync(fullPkgDir);
        const match = entries.find((file) => /^(licen[sc]e|copying|notice)(\.|$)/i.test(file));
        if (match) {
          licenseText = fs.readFileSync(path.join(fullPkgDir, match), 'utf8').trim();
        }
      } catch {
        // Ignore read errors for individual packages
      }
    }

    collected.set(key, {
      name: packageName,
      version,
      license: meta.license || 'UNKNOWN',
      author,
      repository,
      licenseText,
    });
  }

  const sorted = [...collected.values()].sort((a, b) => a.name.localeCompare(b.name));

  let output = `# Third-Party Software Notices and Licenses

This file contains notices and license texts for third-party open-source software
packages bundled or distributed with this application.

Total third-party packages: ${sorted.length}

---
`;

  for (const pkg of sorted) {
    output += `\n## ${pkg.name} (${pkg.version})\n\n`;
    output += `- License: ${pkg.license}\n`;
    if (pkg.author) output += `- Author: ${pkg.author}\n`;
    if (pkg.repository) output += `- Repository: ${pkg.repository}\n`;
    output += '\n';

    if (pkg.licenseText) {
      output += '```\n';
      output += pkg.licenseText;
      output += '\n```\n\n---\n';
    } else {
      output += `(License text not found in package distribution. Declared license: ${pkg.license})\n\n---\n`;
    }
  }

  fs.writeFileSync(outputPath, output, 'utf8');
  console.log(`Generated ${outputPath} with ${sorted.length} package notices.`);
  return outputPath;
}

if (process.argv[1] === __filename) {
  generateThirdPartyNotices();
}
