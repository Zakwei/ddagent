export const GITHUB_REPO_URL = 'https://github.com/Zakwei/ddagent';
export const DISCORD_URL = 'https://discord.gg/buxwujPNRE';
export const DOCS_URL = 'https://github.com/Zakwei/ddagent/docs';

export type ReleaseRelation = 'current' | 'newer' | 'older';

export function compareVersions(a: string, b: string): number {
  const pa = a.split('.').map(Number);
  const pb = b.split('.').map(Number);
  for (let i = 0; i < Math.max(pa.length, pb.length); i += 1) {
    const x = pa[i] || 0;
    const y = pb[i] || 0;
    if (x !== y) return x - y;
  }
  return 0;
}

export function stripVersionTag(tag: string): string {
  return tag.replace(/^v/, '');
}

export function releaseRelation(tag: string, currentVersion: string): ReleaseRelation {
  const cmp = compareVersions(stripVersionTag(tag), currentVersion);
  if (cmp === 0) return 'current';
  return cmp > 0 ? 'newer' : 'older';
}
