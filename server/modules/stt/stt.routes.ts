import { Router, raw } from 'express';

import { getSttConfig, isSttConfigured, setSttConfig, transcribeAudio } from './stt.service.js';

// Consumed by server/services.ts, mounted at /api/stt behind authenticateToken.
export const sttRoutes = Router();

const MAX_AUDIO_BYTES = 25 * 1024 * 1024;
const LANGUAGE_PATTERN = /^[a-z]{2}(-[a-zA-Z]{2,4})?$/;

const audioParser = raw({
  type: ['application/octet-stream', 'audio/*', 'multipart/form-data'],
  limit: MAX_AUDIO_BYTES,
});

/**
 * Minimal single-part multipart extractor — the React Native app uploads via
 * FormData (the only file-upload path RN fetch supports), browsers send the
 * MediaRecorder blob raw. Only the first part's bytes and content-type are
 * needed, so no multipart library is pulled in.
 */
export function extractAudio(
  body: Buffer,
  contentType: string
): { data: Buffer; mimeType: string } | null {
  if (!contentType.startsWith('multipart/form-data')) {
    return body.length ? { data: body, mimeType: contentType || 'audio/webm' } : null;
  }
  const boundaryMatch = /boundary=([^;]+)/.exec(contentType);
  if (!boundaryMatch) return null;
  const boundary = `--${boundaryMatch[1].trim().replace(/^"|"$/g, '')}`;
  const start = body.indexOf(boundary);
  if (start === -1) return null;
  const headersEnd = body.indexOf('\r\n\r\n', start);
  if (headersEnd === -1) return null;
  const headers = body.subarray(start, headersEnd).toString('latin1');
  const mimeMatch = /content-type:\s*([^\r\n;]+)/i.exec(headers);
  const endMarker = `\r\n${boundary}`;
  let end = body.indexOf(endMarker, headersEnd);
  if (end === -1) end = body.length;
  const data = body.subarray(headersEnd + 4, end);
  return data.length
    ? { data, mimeType: mimeMatch?.[1]?.trim() ?? 'application/octet-stream' }
    : null;
}

/** Whether voice input is usable — the composer hides the mic when false. */
sttRoutes.get('/config', (_req, res) => {
  const config = getSttConfig();
  res.json({
    configured: isSttConfigured(),
    endpointUrl: config.endpointUrl,
    model: config.model,
    hasApiKey: Boolean(config.apiKey),
  });
});

sttRoutes.put('/config', (req, res) => {
  const body = (req.body ?? {}) as Record<string, unknown>;
  const endpointUrl = typeof body.endpointUrl === 'string' ? body.endpointUrl : undefined;
  if (endpointUrl !== undefined && endpointUrl.trim() && !/^https?:\/\//.test(endpointUrl.trim())) {
    return res.status(400).json({ error: 'endpointUrl must be an http(s) URL' });
  }
  setSttConfig({
    endpointUrl,
    apiKey: typeof body.apiKey === 'string' ? body.apiKey : undefined,
    model: typeof body.model === 'string' ? body.model : undefined,
  });
  return res.json({ success: true, configured: isSttConfigured() });
});

/**
 * Raw audio upload (application/octet-stream or audio/*) — the browser sends
 * MediaRecorder output as-is, the service wraps it in whisper FormData. Raw
 * body keeps this one line instead of a multipart parser.
 */
sttRoutes.post('/', audioParser, async (req, res, next) => {
  try {
    if (!isSttConfigured()) {
      return res.status(503).json({ error: 'STT is not configured' });
    }
    const rawBody = req.body as Buffer | undefined;
    if (!Buffer.isBuffer(rawBody) || rawBody.length === 0) {
      return res.status(400).json({ error: 'audio body is required' });
    }
    const extracted = extractAudio(rawBody, String(req.headers['content-type'] ?? ''));
    if (!extracted) {
      return res.status(400).json({ error: 'could not extract audio from body' });
    }
    const language = typeof req.query.language === 'string' ? req.query.language : undefined;
    if (language !== undefined && !LANGUAGE_PATTERN.test(language)) {
      return res.status(400).json({ error: 'invalid language' });
    }
    const result = await transcribeAudio({
      audio: extracted.data,
      mimeType: extracted.mimeType,
      language,
    });
    return res.json(result);
  } catch (error) {
    return next(error);
  }
});
