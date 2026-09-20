// @ts-nocheck -- web-push does not provide declarations in this project.
import webPush from 'web-push';

import { getConnection } from '../database/index.js';

let cachedKeys = null;
let webPushConfigured = false;
const db = getConnection();

function ensureVapidKeys() {
  if (cachedKeys) return cachedKeys;

  const row = db.prepare('SELECT public_key, private_key FROM vapid_keys ORDER BY id DESC LIMIT 1').get();
  if (row) {
    cachedKeys = { publicKey: row.public_key, privateKey: row.private_key };
    return cachedKeys;
  }

  const keys = webPush.generateVAPIDKeys();
  db.prepare('INSERT INTO vapid_keys (public_key, private_key) VALUES (?, ?)').run(keys.publicKey, keys.privateKey);
  cachedKeys = keys;
  return cachedKeys;
}

function getPublicKey() {
  return ensureVapidKeys().publicKey;
}

function configureWebPush() {
  const keys = ensureVapidKeys();
  webPush.setVapidDetails(
    'mailto:noreply@ddagent.local',
    keys.publicKey,
    keys.privateKey
  );
  webPushConfigured = true;
  console.log('Web Push notifications configured');
}

/** Whether configureWebPush() has run, so Settings can tell if push can send. */
function isWebPushConfigured() {
  return webPushConfigured;
}

export { ensureVapidKeys, getPublicKey, configureWebPush, isWebPushConfigured };
