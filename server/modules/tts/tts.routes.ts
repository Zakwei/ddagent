import { Router } from 'express';

import { getCuratedVoices, synthesizeSpeech } from './tts.service.js';

// Consumed by server/index.ts, mounted at /api/tts behind authenticateToken.
export const ttsRoutes = Router();

const MAX_TTS_TEXT_LENGTH = 4000;

ttsRoutes.get('/voices', async (_req, res, next) => {
  try {
    res.json({ voices: await getCuratedVoices() });
  } catch (error) {
    next(error);
  }
});

const handleSynthesize = async (
  req: { body?: unknown; query: Record<string, unknown> },
  res: import('express').Response,
  next: import('express').NextFunction,
) => {
  try {
    const body = (req.body ?? {}) as { text?: unknown; voice?: unknown };
    const text = typeof body.text === 'string' ? body.text : req.query.text;
    const voice = typeof body.voice === 'string' ? body.voice : req.query.voice;
    if (typeof text !== 'string' || !text.trim()) {
      res.status(400).json({ error: 'text is required' });
      return;
    }
    const audio = await synthesizeSpeech(
      text.slice(0, MAX_TTS_TEXT_LENGTH),
      typeof voice === 'string' ? voice : undefined,
    );
    res.setHeader('Content-Type', 'audio/mpeg');
    // pipe() does not forward source errors: a stream that fails after the
    // headers were sent would leave the response open forever.
    audio.on('error', (error) => {
      if (res.headersSent) res.destroy();
      else next(error);
    });
    audio.pipe(res);
  } catch (error) {
    next(error);
  }
};

// GET mirrors POST so the client can hand the URL straight to an <audio>
// element and start playback on the first chunk instead of buffering a blob.
ttsRoutes.post('/', handleSynthesize);
ttsRoutes.get('/', handleSynthesize);
