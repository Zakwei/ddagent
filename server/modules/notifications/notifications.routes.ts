import express from 'express';

import { notificationChannelEndpointsDb, notificationPreferencesDb } from '@/modules/database/index.js';
import {
  discordChannel,
  getDiscordWebhookUrl,
  getTelegramBotToken,
  isValidDiscordWebhookUrl,
  setDiscordWebhookUrl,
  setTelegramBotToken,
  telegramChannel,
} from '@/modules/notifications/services/messenger-channels.service.js';
import { resolveRemoteApproval } from '@/modules/notifications/services/remote-approval.service.js';
import {
  getDetectedTelegramChats,
  restartTelegramPoller,
} from '@/modules/notifications/services/telegram-poller.service.js';

const router = express.Router();

function readText(value: unknown): string {
  return typeof value === 'string' ? value.trim() : '';
}

function sanitizeEndpoint(endpoint: any) {
  return {
    id: endpoint.id,
    channel: endpoint.channel,
    endpointId: endpoint.endpoint_id,
    label: endpoint.label,
    metadata: notificationChannelEndpointsDb.parseMetadata(endpoint.metadata_json),
    enabled: Boolean(endpoint.enabled),
    lastSeenAt: endpoint.last_seen_at,
    createdAt: endpoint.created_at,
    updatedAt: endpoint.updated_at,
  };
}

function readUserId(req: express.Request): number {
  const userId = Number((req as any).user?.id);
  if (!Number.isInteger(userId) || userId <= 0) {
    throw new Error('Authenticated user is missing');
  }
  return userId;
}

function updateChannelPreference(userId: number, channel: string): unknown {
  const currentPrefs = notificationPreferencesDb.getPreferences(userId);
  const hasEnabledEndpoint = notificationChannelEndpointsDb.getEnabledEndpoints(userId, channel).length > 0;
  return notificationPreferencesDb.updatePreferences(userId, {
    ...currentPrefs,
    channels: { ...currentPrefs.channels, [channel]: hasEnabledEndpoint },
  });
}

router.get('/endpoints', (req, res) => {
  try {
    const channel = readText(req.query.channel);
    if (!channel) {
      return res.status(400).json({ error: 'channel is required' });
    }

    const userId = readUserId(req);
    const endpoints = notificationChannelEndpointsDb
      .getEndpoints(userId, channel)
      .map(sanitizeEndpoint);
    return res.json({ success: true, endpoints });
  } catch (error) {
    console.error('Error fetching notification endpoints:', error);
    return res.status(500).json({ error: 'Failed to fetch notification endpoints' });
  }
});

router.post('/endpoints/current', (req, res) => {
  try {
    const { channel, endpointId, label, metadata = {}, enabled = true } = req.body || {};
    const normalizedChannel = readText(channel);
    const normalizedEndpointId = readText(endpointId);
    if (!normalizedChannel || !normalizedEndpointId) {
      return res.status(400).json({ error: 'channel and endpointId are required' });
    }

    const userId = readUserId(req);
    const endpoint = notificationChannelEndpointsDb.upsertEndpoint({
      userId,
      channel: normalizedChannel,
      endpointId: normalizedEndpointId,
      label,
      metadata: metadata && typeof metadata === 'object' ? metadata : {},
      enabled: enabled !== false,
    });

    const preferences = updateChannelPreference(userId, normalizedChannel);
    return res.json({ success: true, endpoint: sanitizeEndpoint(endpoint), preferences });
  } catch (error) {
    console.error('Error registering notification endpoint:', error);
    return res.status(500).json({ error: 'Failed to register notification endpoint' });
  }
});

router.patch('/endpoints/:channel/:endpointId', (req, res) => {
  try {
    const { channel, endpointId } = req.params;
    const { enabled } = req.body || {};
    if (typeof enabled !== 'boolean') {
      return res.status(400).json({ error: 'enabled must be a boolean' });
    }

    const userId = readUserId(req);
    const updated = notificationChannelEndpointsDb.setEndpointEnabled(userId, channel, endpointId, enabled);
    if (!updated) {
      return res.status(404).json({ error: 'Notification endpoint not found' });
    }

    const endpoint = notificationChannelEndpointsDb.getEndpoint(userId, channel, endpointId);
    const preferences = updateChannelPreference(userId, channel);
    return res.json({ success: true, endpoint: endpoint ? sanitizeEndpoint(endpoint) : null, preferences });
  } catch (error) {
    console.error('Error updating notification endpoint:', error);
    return res.status(500).json({ error: 'Failed to update notification endpoint' });
  }
});

router.delete('/endpoints/:channel/:endpointId', (req, res) => {
  try {
    const { channel, endpointId } = req.params;
    const userId = readUserId(req);
    const removed = notificationChannelEndpointsDb.removeEndpoint(userId, channel, endpointId);
    if (!removed) {
      return res.status(404).json({ error: 'Notification endpoint not found' });
    }

    const preferences = updateChannelPreference(userId, channel);
    return res.json({ success: true, preferences });
  } catch (error) {
    console.error('Error removing notification endpoint:', error);
    return res.status(500).json({ error: 'Failed to remove notification endpoint' });
  }
});

// ---------------------------------------------------------------------------
// Messenger channels (Telegram approvals, Discord notifications)
// ---------------------------------------------------------------------------

const MESSENGER_CHANNELS = new Set(['telegram', 'discord']);

/** Reports whether each messenger channel has its app-level secret configured. */
router.get('/channels/config', (_req, res) => {
  return res.json({
    success: true,
    config: {
      telegram: { configured: Boolean(getTelegramBotToken()) },
      discord: { configured: Boolean(getDiscordWebhookUrl()) },
    },
  });
});

router.put('/channels/:channel/config', async (req, res) => {
  try {
    const channel = readText(req.params.channel);
    if (!MESSENGER_CHANNELS.has(channel)) {
      return res.status(400).json({ error: 'unknown channel' });
    }

    if (channel === 'telegram') {
      const token = readText(req.body?.botToken);
      if (!/^\d{5,}:[A-Za-z0-9_-]{20,}$/.test(token)) {
        return res.status(400).json({ error: 'invalid bot token format' });
      }
      setTelegramBotToken(token);
      await restartTelegramPoller();
    } else {
      const webhookUrl = readText(req.body?.webhookUrl);
      if (!isValidDiscordWebhookUrl(webhookUrl)) {
        return res.status(400).json({ error: 'webhookUrl must be a https://discord.com/api/webhooks/... URL' });
      }
      setDiscordWebhookUrl(webhookUrl);
    }

    return res.json({ success: true });
  } catch (error) {
    console.error('Error saving messenger channel config:', error);
    return res.status(500).json({ error: 'Failed to save channel config' });
  }
});

/** Sends a test message through a messenger channel for the current user. */
router.post('/channels/:channel/test', async (req, res) => {
  try {
    const channel = readText(req.params.channel);
    const userId = readUserId(req);
    const payload = { title: 'ddagent', body: 'Test notification from ddagent' };
    const event = { code: 'agent.notification', meta: {} };

    if (channel === 'telegram') {
      await telegramChannel.send({ userId, event, payload });
    } else if (channel === 'discord') {
      await discordChannel.send({ userId, event, payload });
    } else {
      return res.status(400).json({ error: 'unknown channel' });
    }
    return res.json({ success: true });
  } catch (error) {
    console.error('Error sending messenger test:', error);
    return res.status(500).json({ error: 'Failed to send test message' });
  }
});

/**
 * Pairing helper: chats that recently messaged the bot (seen by the poller)
 * plus already-paired endpoints, so the UI can render one "pair" list.
 */
router.get('/channels/telegram/chats', (req, res) => {
  try {
    const userId = readUserId(req);
    const paired = notificationChannelEndpointsDb
      .getEndpoints(userId, 'telegram')
      .map(sanitizeEndpoint);
    return res.json({
      success: true,
      detected: getDetectedTelegramChats(),
      paired,
    });
  } catch (error) {
    console.error('Error listing telegram chats:', error);
    return res.status(500).json({ error: 'Failed to list telegram chats' });
  }
});

/**
 * REST resolve for a pending tool approval — used by the mobile app and any
 * future client that cannot hold a chat websocket open.
 */
router.post('/approvals/:requestId', (req, res) => {
  try {
    const requestId = readText(req.params.requestId);
    const decision = readText(req.body?.decision);
    const result = resolveRemoteApproval(requestId, decision as 'allow' | 'deny' | 'always');
    if (!result.ok) {
      return res.status(409).json({ success: false, reason: result.reason });
    }
    return res.json({ success: true });
  } catch (error) {
    console.error('Error resolving approval:', error);
    return res.status(500).json({ error: 'Failed to resolve approval' });
  }
});

export default router;
