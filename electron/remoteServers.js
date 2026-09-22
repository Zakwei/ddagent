import crypto from 'node:crypto';
import fs from 'node:fs/promises';
import path from 'node:path';

export function normalizeServerUrl(input) {
  const raw = String(input || '').trim();
  if (!raw) {
    throw new Error('Server URL is required.');
  }

  // `new URL()` alone would read "localhost:10087" as scheme "localhost:", so
  // only keep the input as-is when it carries an explicit `scheme://`.
  const withScheme = /^[a-zA-Z][a-zA-Z0-9+.-]*:\/\//.test(raw) ? raw : `https://${raw}`;

  let parsed;
  try {
    parsed = new URL(withScheme);
  } catch {
    throw new Error(`Invalid server URL: ${raw}`);
  }

  if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') {
    throw new Error('Server URL must use http or https.');
  }

  return parsed.toString().replace(/\/+$/, '');
}

export class RemoteServersStore {
  constructor({ storePath }) {
    this.storePath = storePath;
    this.servers = null;
  }

  async ensureLoaded() {
    if (this.servers) return;
    try {
      const raw = await fs.readFile(this.storePath, 'utf8');
      const stored = JSON.parse(raw);
      this.servers = Array.isArray(stored) ? stored : [];
    } catch {
      this.servers = [];
    }
  }

  async save() {
    await fs.mkdir(path.dirname(this.storePath), { recursive: true });
    await fs.writeFile(this.storePath, JSON.stringify(this.servers, null, 2), 'utf8');
  }

  async list() {
    await this.ensureLoaded();
    return [...this.servers].sort((a, b) => {
      if (a.lastUsedAt === b.lastUsedAt) return 0;
      if (!a.lastUsedAt) return 1;
      if (!b.lastUsedAt) return -1;
      return a.lastUsedAt < b.lastUsedAt ? 1 : -1;
    });
  }

  async add({ url, name } = {}) {
    const normalizedUrl = normalizeServerUrl(url);
    await this.ensureLoaded();

    const existing = this.servers.find((server) => server.url === normalizedUrl);
    if (existing) return existing;

    const entry = {
      id: crypto.randomUUID(),
      name: String(name || '').trim() || new URL(normalizedUrl).hostname,
      url: normalizedUrl,
      lastUsedAt: null,
      createdAt: new Date().toISOString(),
    };
    this.servers.push(entry);
    await this.save();
    return entry;
  }

  async update(id, fields = {}) {
    await this.ensureLoaded();
    const entry = this.servers.find((server) => server.id === id);
    if (!entry) return null;

    if (fields.url !== undefined) {
      entry.url = normalizeServerUrl(fields.url);
    }
    if (fields.name !== undefined) {
      entry.name = String(fields.name || '').trim() || new URL(entry.url).hostname;
    }

    await this.save();
    return entry;
  }

  async remove(id) {
    await this.ensureLoaded();
    const index = this.servers.findIndex((server) => server.id === id);
    if (index === -1) return false;

    this.servers.splice(index, 1);
    await this.save();
    return true;
  }

  async touch(id) {
    await this.ensureLoaded();
    const entry = this.servers.find((server) => server.id === id);
    if (!entry) return null;

    entry.lastUsedAt = new Date().toISOString();
    await this.save();
    return entry;
  }
}
