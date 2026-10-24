import fs from 'node:fs';

/** Directory the server depends on: its code, its database, the user's workspaces. */
type DiskLocation = { kind: 'app' | 'data' | 'workspace'; path: string };

type DiskUsageDependencies = {
  locations: DiskLocation[];
  /** `fs.promises.statfs` / `fs.promises.stat`; injectable for tests. */
  statfs?(path: string): Promise<{ bsize: number; blocks: number; bavail: number }>;
  stat?(path: string): Promise<{ dev: number }>;
};

/**
 * Free space below either limit flags the volume as low — the server stops
 * working once its disk fills, so the client raises a banner well before that.
 */
const LOW_FREE_BYTES = 5 * 1024 ** 3;
const LOW_FREE_RATIO = 0.1;

/**
 * Creates the disk-usage report behind `GET /api/system/disk` (system routes).
 * Locations on the same filesystem collapse into one volume.
 */
export function createDiskUsageService(dependencies: DiskUsageDependencies) {
  const statfs = dependencies.statfs ?? ((p: string) => fs.promises.statfs(p));
  const stat = dependencies.stat ?? ((p: string) => fs.promises.stat(p));

  return {
    async getDiskUsage() {
      const volumes = new Map<number, {
        locations: DiskLocation[];
        totalBytes: number;
        freeBytes: number;
        low: boolean;
      }>();
      for (const location of dependencies.locations) {
        try {
          const { dev } = await stat(location.path);
          const existing = volumes.get(dev);
          if (existing) {
            existing.locations.push(location);
            continue;
          }
          const fsStats = await statfs(location.path);
          const totalBytes = fsStats.blocks * fsStats.bsize;
          const freeBytes = fsStats.bavail * fsStats.bsize;
          volumes.set(dev, {
            locations: [location],
            totalBytes,
            freeBytes,
            low: freeBytes < LOW_FREE_BYTES || freeBytes < totalBytes * LOW_FREE_RATIO,
          });
        } catch {
          // A missing location (e.g. an unset workspace root) is not a disk to report.
        }
      }
      return { volumes: [...volumes.values()] };
    },
  };
}
