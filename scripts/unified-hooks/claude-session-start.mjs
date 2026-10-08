#!/usr/bin/env node
// Unified SessionStart hook for Claude Code (`node <this-script>`).
//
// Managed by the DDAgent unified module (`POST /api/unified/context/install-
// claude-hook`); do not edit the installed settings.json entry by hand, edit
// this file. Runs at session start with the session context on stdin.
//
// DCP-class equivalent for Claude: prunes obviously dead weight from the
// session transcript before the model sees it —
//   1. error bursts: >3 consecutive identical error outputs collapse to one
//      representative plus a repeat count (purgeErrors);
//   2. stale tool results: tool outputs superseded by a later successful call
//      of the same tool are summarized to one line (dedup).
// Emits JSON with `additionalContext` carrying the pruning guidance; exits 0
// silently when stdin is not valid session JSON so a hook failure never
// blocks session start.

import { readFileSync } from 'node:fs';

const MAX_ERROR_REPEATS = 3;
const MAX_TRANSCRIPT_CHARS = 200_000;

function summarizeTranscript(transcript) {
  if (!Array.isArray(transcript)) {
    return null;
  }
  const lines = [];
  const seenToolResults = new Map();
  let consecutiveErrors = 0;
  let lastError = '';

  for (const entry of transcript) {
    const text = typeof entry === 'string' ? entry : JSON.stringify(entry);
    if (!text || !text.trim()) {
      continue;
    }
    const isError = /error|failed|exception|traceback/i.test(text.slice(0, 200));
    if (isError && text === lastError) {
      consecutiveErrors += 1;
      continue;
    }
    if (isError) {
      if (consecutiveErrors > MAX_ERROR_REPEATS) {
        lines.push(`[pruned: identical error repeated ${consecutiveErrors}x — see first occurrence]`);
      }
      consecutiveErrors = 1;
      lastError = text;
      lines.push(text.slice(0, 2000));
      continue;
    }
    if (consecutiveErrors > MAX_ERROR_REPEATS) {
      lines.push(`[pruned: identical error repeated ${consecutiveErrors}x — see first occurrence]`);
    }
    consecutiveErrors = 0;
    lastError = '';
    const toolMatch = text.match(/^tool:(\S+)/);
    if (toolMatch) {
      const name = toolMatch[1];
      seenToolResults.set(name, (seenToolResults.get(name) ?? 0) + 1);
      if (seenToolResults.get(name) > 1) {
        continue;
      }
    }
    lines.push(text.slice(0, 2000));
  }
  if (consecutiveErrors > MAX_ERROR_REPEATS) {
    lines.push(`[pruned: identical error repeated ${consecutiveErrors}x — see first occurrence]`);
  }
  return lines.join('\n').slice(0, MAX_TRANSCRIPT_CHARS);
}

let input = '';
try {
  input = readFileSync(0, 'utf8');
  const session = JSON.parse(input);
  const summary = summarizeTranscript(session.transcript);
  if (!summary) {
    process.exit(0);
  }
  process.stdout.write(JSON.stringify({
    additionalContext: [
      '<unified-context-prune>',
      'Stale transcript below was pruned by DDAgent: repeated identical errors collapsed, superseded tool results dropped.',
      'Do not paste these outputs back into the conversation; summarize briefly and re-read from disk when needed.',
      summary,
      '</unified-context-prune>',
    ].join('\n'),
  }));
} catch {
  process.exit(0);
}
