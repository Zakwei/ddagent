import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';

import { createNormalizedMessage, isDevinContinuationPrompt, isDevinSummaryArtifact, openSqliteReadonlyDatabase, sliceTailPage } from '../../../../shared/utils.js';
import { sessionsDb } from '../../../../modules/database/index.js';

const PROVIDER = 'devin';
const DEVIN_SESSIONS_DB = path.join(os.homedir(), '.local', 'share', 'devin', 'cli', 'sessions.db');

function parseDevinTimestamp(value) {
    if (value === null || value === undefined) {
        return new Date().toISOString();
    }
    const numeric = Number(value);
    const ms = Number.isFinite(numeric) && numeric < 1_000_000_000_000 ? numeric * 1000 : numeric;
    const date = new Date(ms);
    if (Number.isNaN(date.getTime())) {
        return new Date().toISOString();
    }
    return date.toISOString();
}

function readDevinMessageRecord(chatMessage) {
    try {
        const raw = JSON.parse(chatMessage);
        if (!raw || typeof raw !== 'object') {
            return null;
        }
        return raw;
    } catch {
        return null;
    }
}

function getMessageTimestamp(raw, row) {
    if (typeof raw.created_at === 'string' && raw.created_at.trim()) {
        return raw.created_at;
    }
    const metaCreated = typeof raw.metadata === 'object' && raw.metadata !== null ? raw.metadata.created_at : undefined;
    if (typeof metaCreated === 'string' && metaCreated.trim()) {
        return metaCreated;
    }
    return parseDevinTimestamp(row.created_at);
}

function buildAcpContentParts(raw) {
    const blocks = raw.metadata?.extensions?.['chisel/acp-content-blocks'];
    if (!Array.isArray(blocks)) {
        return { text: '', images: [], files: [] };
    }
    const textParts = [];
    const images = [];
    const files = [];
    for (const block of blocks) {
        if (!block || typeof block !== 'object') {
            continue;
        }
        if (block.type === 'text' && typeof block.text === 'string') {
            textParts.push(block.text);
        } else if (block.type === 'image' && typeof block.data === 'string') {
            images.push({
                data: `data:${block.mimeType || 'image/png'};base64,${block.data}`,
            });
        } else if (block.type === 'resource' && block.resource && typeof block.resource === 'object') {
            const uri = typeof block.resource.uri === 'string' ? block.resource.uri : '';
            const filePath = uri.replace(/^file:\/\//, '');
            if (filePath) {
                files.push({
                    path: filePath,
                    name: path.basename(filePath),
                    mimeType: block.resource.mimeType,
                    size: undefined,
                });
            }
        }
    }
    return {
        text: textParts.join('\n'),
        images,
        files,
    };
}

/**
 * Pasted images that Devin keeps on the raw record (`images[].base64_data`)
 * instead of in the ACP content blocks. Dropping them would strip the
 * attachment from the persisted user turn — the composer showed it
 * optimistically, and the client matches the two rows by their attachments.
 */
function buildRawRecordImages(raw) {
    const images = Array.isArray(raw.images) ? raw.images : [];
    return images
        .filter((image) => image && typeof image.base64_data === 'string' && image.base64_data)
        .map((image) => ({ data: `data:image/png;base64,${image.base64_data}` }));
}

function normalizeUserNode(row, raw, providerSessionId) {
    const { text: textFromBlocks, images, files } = buildAcpContentParts(raw);
    // ACP image blocks win when present; pasted screenshots only live in the
    // raw record.
    const turnImages = images.length > 0 ? images : buildRawRecordImages(raw);
    const rawContent = typeof raw.content === 'string' ? raw.content : '';
    const content = (textFromBlocks || rawContent).trim();
    if (isDevinContinuationPrompt(content)) {
        return [];
    }
    if (!content && turnImages.length === 0 && files.length === 0) {
        return [];
    }
    const id = typeof raw.message_id === 'string' && raw.message_id.trim()
        ? raw.message_id
        : `devin-${providerSessionId}-${row.node_id}`;
    const timestamp = getMessageTimestamp(raw, row);
    return [createNormalizedMessage({
        id,
        sessionId: providerSessionId,
        timestamp,
        provider: PROVIDER,
        kind: 'text',
        role: 'user',
        content,
        images: turnImages.length > 0 ? turnImages : undefined,
        files: files.length > 0 ? files : undefined,
    })];
}

function normalizeAssistantNode(row, raw, providerSessionId) {
    const messages = [];
    const baseId = typeof raw.message_id === 'string' && raw.message_id.trim()
        ? raw.message_id
        : `devin-${providerSessionId}-${row.node_id}`;
    const timestamp = getMessageTimestamp(raw, row);

    // Only show the final assistant's thinking. Tool-call decision nodes
    // produce their own thinking, but surfacing all of them creates a wall of
    // "Thought for a few seconds" blocks in the UI.
    const willEmitText = (typeof raw.content === 'string' ? raw.content : '').trim() &&
        (raw.metadata?.finish_reason === 'stop' || raw.metadata?.finish_reason === 'end_turn' ||
            ((!Array.isArray(raw.tool_calls) || raw.tool_calls.length === 0) && raw.metadata?.finish_reason == null));
    if (willEmitText && raw.thinking && typeof raw.thinking.thinking === 'string' && raw.thinking.thinking.trim()) {
        messages.push(createNormalizedMessage({
            id: `${baseId}_thinking`,
            sessionId: providerSessionId,
            timestamp,
            provider: PROVIDER,
            kind: 'thinking',
            content: raw.thinking.thinking,
        }));
    }

    const toolCalls = Array.isArray(raw.tool_calls) ? raw.tool_calls : [];
    if (toolCalls.length > 0) {
        for (let i = 0; i < toolCalls.length; i += 1) {
            const call = toolCalls[i];
            const toolId = typeof call.id === 'string' && call.id.trim() ? call.id : `${baseId}_call_${i}`;
            const toolName = typeof call.name === 'string' && call.name.trim() ? call.name : 'tool';
            const toolInput = call.arguments && typeof call.arguments === 'object' ? call.arguments : {};
            messages.push(createNormalizedMessage({
                id: toolId,
                sessionId: providerSessionId,
                timestamp,
                provider: PROVIDER,
                kind: 'tool_use',
                toolName,
                toolInput,
                toolId,
            }));
        }
    }

    const content = typeof raw.content === 'string' ? raw.content : '';
    const finishReason = raw.metadata?.finish_reason;
    const hasToolCalls = toolCalls.length > 0;
    const shouldEmitText = content.trim() && (finishReason === 'stop' || finishReason === 'end_turn' || finishReason === 'tool_calls' || (!hasToolCalls && finishReason == null));
    if (shouldEmitText) {
        const finalContent = content.trim();
        if (isDevinSummaryArtifact(finalContent)) {
            // Skip Devin-generated compact summary artifacts; the real final
            // answer lives on an earlier/parallel chain branch.
            return messages;
        }
        messages.push(createNormalizedMessage({
            id: baseId,
            sessionId: providerSessionId,
            timestamp,
            provider: PROVIDER,
            kind: 'text',
            role: 'assistant',
            content: finalContent,
        }));
    }

    return messages;
}

function normalizeToolNode(row, raw, providerSessionId) {
    const content = typeof raw.content === 'string' ? raw.content : (raw.content != null ? JSON.stringify(raw.content) : '');
    const isError = raw.metadata?.status === 'failed' || (typeof content === 'string' && content.startsWith('<tool_use_error>'));
    const toolId = typeof raw.tool_call_id === 'string' && raw.tool_call_id.trim()
        ? raw.tool_call_id
        : (typeof raw.message_id === 'string' && raw.message_id.trim()
            ? raw.message_id
            : `devin-${providerSessionId}-${row.node_id}`);
    const timestamp = getMessageTimestamp(raw, row);
    return [createNormalizedMessage({
        id: `${toolId}__result`,
        sessionId: providerSessionId,
        timestamp,
        provider: PROVIDER,
        kind: 'tool_result',
        toolId,
        content,
        isError,
    })];
}

/** Exported for tests: normalizes one node of Devin's message graph. */
export function normalizeDevinNode(row, raw, providerSessionId) {
    if (!raw || typeof raw !== 'object') {
        return [];
    }
    if (raw.role === 'system') {
        return [];
    }
    if (raw.role === 'user') {
        return normalizeUserNode(row, raw, providerSessionId);
    }
    if (raw.role === 'assistant') {
        return normalizeAssistantNode(row, raw, providerSessionId);
    }
    if (raw.role === 'tool') {
        return normalizeToolNode(row, raw, providerSessionId);
    }
    return [];
}

function readAssistantLeafScore(raw) {
    if (!raw || typeof raw !== 'object' || raw.role !== 'assistant') return 0;
    const content = typeof raw.content === 'string' ? raw.content.trim() : '';
    if (content && isDevinSummaryArtifact(content)) return 0;
    const toolCalls = Array.isArray(raw.tool_calls) ? raw.tool_calls : [];
    const finishReason = raw.metadata?.finish_reason;
    if (content && toolCalls.length === 0 && (finishReason === 'stop' || finishReason === 'end_turn' || finishReason == null)) {
        return 2;
    }
    if (raw.role === 'assistant') return 1;
    return 0;
}

function isBetterLeaf(a, b) {
    if (!b) return true;
    if (a.score !== b.score) return a.score > b.score;
    if (a.created_at !== b.created_at) return a.created_at > b.created_at;
    return a.row_id > b.row_id;
}

function findLatestLeaf(parentRows, leafCandidates, leafRawByNode) {
    if (!leafCandidates || leafCandidates.length === 0) {
        return parentRows.length > 0 ? Math.max(...parentRows.map((r) => r.node_id)) : null;
    }

    let best = null;
    for (const row of leafCandidates) {
        const raw = leafRawByNode?.get(row.node_id) ?? null;
        const score = readAssistantLeafScore(raw);
        const candidate = { ...row, score };
        if (isBetterLeaf(candidate, best)) {
            best = candidate;
        }
    }
    return best?.node_id ?? (parentRows.length > 0 ? Math.max(...parentRows.map((r) => r.node_id)) : null);
}

function buildChain(parentById, leafId) {
    const chainNodeIds = [];
    const visited = new Set();
    let currentId = leafId;
    while (currentId !== null && parentById.has(currentId) && !visited.has(currentId)) {
        visited.add(currentId);
        chainNodeIds.push(currentId);
        currentId = parentById.get(currentId);
    }
    return chainNodeIds;
}

function loadDevinDbHistory(providerSessionId, limit = null, offset = 0) {
    if (!fs.existsSync(DEVIN_SESSIONS_DB)) {
        return [];
    }
    let db;
    try {
        db = openSqliteReadonlyDatabase(DEVIN_SESSIONS_DB);
    } catch (error) {
        console.warn(`[DevinProvider] Could not open Devin sessions DB: ${error instanceof Error ? error.message : error}`);
        return [];
    }

    try {
        const parentRows = db.prepare('SELECT row_id, node_id, parent_node_id, created_at FROM message_nodes WHERE session_id = ?').all(providerSessionId);
        if (parentRows.length === 0) {
            return [];
        }
        const parentById = new Map();
        const hasChild = new Set();
        for (const row of parentRows) {
            parentById.set(row.node_id, row.parent_node_id);
            if (row.parent_node_id !== null && row.parent_node_id !== undefined) {
                hasChild.add(row.parent_node_id);
            }
        }

        // Devin stores subagent work as side branches inside this same message
        // graph (tracked in subagent_heads). The sessions table records the
        // authoritative head of the main chain — prefer it so a child agent's
        // leaf can never be mistaken for the main conversation tail.
        let leafId = null;
        const sessionRow = db.prepare('SELECT main_chain_id FROM sessions WHERE id = ?').get(providerSessionId);
        if (sessionRow?.main_chain_id != null && parentById.has(sessionRow.main_chain_id)) {
            leafId = sessionRow.main_chain_id;
        }

        if (leafId == null) {
            // Devin ACP can produce a branched conversation graph (parallel tool
            // calls and retried turns). node_id is not monotonic, so the highest
            // node_id leaf is often a sibling tool-result branch rather than the
            // final assistant response. Load the most-recent leaf candidates, score
            // them by whether they look like a final assistant answer, and follow
            // that leaf's chain back to the root.
            const LEAF_CANDIDATE_LIMIT = 1000;
            const leafCandidates = parentRows
                .filter((row) => !hasChild.has(row.node_id))
                .sort((a, b) => (b.created_at - a.created_at) || (b.row_id - a.row_id))
                .slice(0, LEAF_CANDIDATE_LIMIT);

            const leafRawByNode = new Map();
            if (leafCandidates.length > 0) {
                const leafPlaceholders = leafCandidates.map(() => '?').join(',');
                const leafRows = db.prepare(`SELECT node_id, chat_message FROM message_nodes WHERE session_id = ? AND node_id IN (${leafPlaceholders})`).all(providerSessionId, ...leafCandidates.map((r) => r.node_id));
                for (const r of leafRows) {
                    leafRawByNode.set(r.node_id, readDevinMessageRecord(r.chat_message));
                }
            }

            leafId = findLatestLeaf(parentRows, leafCandidates, leafRawByNode);
        }
        if (leafId == null) {
            return [];
        }
        let chainNodeIds = buildChain(parentById, leafId);

        if (chainNodeIds.length === 0) {
            return [];
        }

        // Devin ACP can write two consecutive assistant nodes with identical
        // content/thinking (e.g. one for the stream and one for the final turn).
        // Keep the leaf and drop the duplicate parent so the UI doesn't show the
        // same response twice.
        const dedupPlaceholders = chainNodeIds.map(() => '?').join(',');
        const allDataRows = db.prepare(`SELECT node_id, chat_message FROM message_nodes WHERE session_id = ? AND node_id IN (${dedupPlaceholders})`).all(providerSessionId, ...chainNodeIds);
        const dedupRowByNode = new Map();
        for (const r of allDataRows) dedupRowByNode.set(r.node_id, r);
        const deduped = [];
        for (const nodeId of chainNodeIds) {
            const row = dedupRowByNode.get(nodeId);
            const raw = row ? readDevinMessageRecord(row.chat_message) : null;
            if (!raw) {
                deduped.push(nodeId);
                continue;
            }
            const prevRow = deduped.length > 0 ? dedupRowByNode.get(deduped[deduped.length - 1]) : null;
            const prevRaw = prevRow ? readDevinMessageRecord(prevRow.chat_message) : null;
            if (prevRaw && raw.role === 'assistant' && prevRaw.role === 'assistant') {
                const sameContent = (raw.content || '').trim() === (prevRaw.content || '').trim();
                const sameThinking = ((raw.thinking?.thinking) || '').trim() === ((prevRaw.thinking?.thinking) || '').trim();
                if (sameContent && sameThinking) {
                    continue;
                }
            }
            deduped.push(nodeId);
        }
        chainNodeIds = deduped;

        const requestedCount = limit === null ? chainNodeIds.length : Math.max(0, limit + offset);
        const needCount = Math.min(chainNodeIds.length, requestedCount);
        const neededNodeIds = needCount === chainNodeIds.length ? chainNodeIds : chainNodeIds.slice(0, needCount);

        if (neededNodeIds.length === 0) {
            return [];
        }

        const placeholders = neededNodeIds.map(() => '?').join(',');
        const dataRows = db.prepare(`SELECT node_id, chat_message, created_at FROM message_nodes WHERE session_id = ? AND node_id IN (${placeholders})`).all(providerSessionId, ...neededNodeIds);
        const rowByNode = new Map();
        for (const r of dataRows) {
            rowByNode.set(r.node_id, r);
        }

        const messages = [];
        for (let i = neededNodeIds.length - 1; i >= 0; i -= 1) {
            const row = rowByNode.get(neededNodeIds[i]);
            if (!row) {
                continue;
            }
            const raw = readDevinMessageRecord(row.chat_message);
            if (!raw) {
                continue;
            }
            messages.push(...normalizeDevinNode(row, raw, providerSessionId));
        }

        messages.chainLength = chainNodeIds.length;
        return messages;
    } catch (error) {
        console.error(`[DevinProvider] Failed to read Devin DB history for ${providerSessionId}:`, error);
        return [];
    } finally {
        try {
            db.close();
        } catch {
            // Ignore close errors.
        }
    }
}

function getSessionJsonlPath(session, providerSessionId) {
    if (session?.jsonl_path) return session.jsonl_path;
    if (session?.project_path && providerSessionId) {
        return path.join(session.project_path, '.ddagent', 'devin', `${providerSessionId}.jsonl`);
    }
    return null;
}

/**
 * Exported for the provider test suite: reads the ddagent JSONL transcript and
 * collapses the incremental tool-result snapshots the Devin runtime appends.
 */
export function loadDdagentJsonlHistory(jsonlPath, limit = null, offset = 0) {
    if (!jsonlPath || !fs.existsSync(jsonlPath)) {
        return [];
    }
    try {
        const raw = fs.readFileSync(jsonlPath, 'utf8');
        const lines = raw.split(/\r?\n/).filter((line) => line.trim());
        const messages = [];
        // ACP streams tool output as incremental `tool_call_update` snapshots, so
        // one tool call lands here as several `tool_result` rows sharing the id
        // `${toolId}__result` — the trailing one usually carries no content.
        // Keep the first row (its position and timestamp order the call) and fold
        // later snapshots into it, so no consumer attaches an empty result.
        const toolResultIndexById = new Map();
        for (const line of lines) {
            try {
                const record = JSON.parse(line);
                if (!record || typeof record !== 'object') continue;
                if (record.kind === 'text' && record.role === 'user' && isDevinContinuationPrompt(record.content)) continue;
                if (record.kind === 'text' && record.role === 'assistant' && isDevinSummaryArtifact(record.content)) continue;
                if (record.kind === 'text' && record.role === 'assistant' && record.isCompactSummary) continue;
                if (record.kind === 'tool_result' && record.toolId && record.id === record.toolId) {
                    record.id = `${record.toolId}__result`;
                }
                if (record.kind === 'tool_result' && record.id) {
                    const existingIndex = toolResultIndexById.get(record.id);
                    if (existingIndex !== undefined) {
                        const existing = messages[existingIndex];
                        if (record.isError) existing.isError = true;
                        if (typeof record.content === 'string' && record.content.trim()) {
                            existing.content = record.content;
                        }
                        continue;
                    }
                    toolResultIndexById.set(record.id, messages.length);
                }
                messages.push(record);
            } catch {
                // Malformed JSONL line — skip.
            }
        }
        messages.chainLength = messages.length;
        return messages;
    } catch (error) {
        console.warn(`[DevinProvider] Could not read ddagent JSONL ${jsonlPath}:`, error instanceof Error ? error.message : error);
        return [];
    }
}

export class DevinSessionsProvider {
    /**
     * Normalizes a persisted Devin JSONL record into the shared message shape.
     * Records are already normalized when written, so this mostly re-applies
     * the provider/session envelope.
     */
    normalizeMessage(rawMessage, sessionId) {
        if (!rawMessage || typeof rawMessage !== 'object') {
            return [];
        }
        if (rawMessage.kind) {
            return [createNormalizedMessage({ ...rawMessage, sessionId: rawMessage.sessionId ?? sessionId, provider: PROVIDER })];
        }
        return [];
    }

    /**
     * Loads Devin history for a session and returns normalized messages
     * with the same pagination shape used by other providers.
     */
    async fetchHistory(sessionId, options = {}) {
        const { limit = null, offset = 0, skipJsonl = false } = options;
        const session = sessionsDb.getSessionById(sessionId);
        const providerSessionId = options.providerSessionId ?? session?.provider_session_id ?? sessionId;

        // Prefer the ddagent JSONL transcript once it contains at least one
        // assistant answer. Before that point (or for legacy sessions whose
        // JSONL only holds tool/status rows), Devin's SQLite graph is the more
        // complete source of truth, even though it is branched and contains
        // internal artifacts we filter below.
        // Runtime callers that need the canonical final assistant for the
        // current turn can bypass JSONL entirely; the JSONL lags behind the
        // Devin DB and may only hold older assistant rows.
        let sourceMessages = [];
        if (!skipJsonl) {
            const jsonlPath = getSessionJsonlPath(session, providerSessionId);
            sourceMessages = loadDdagentJsonlHistory(jsonlPath, limit, offset);
            let lastUserIndex = -1;
            for (let i = 0; i < sourceMessages.length; i += 1) {
                const m = sourceMessages[i];
                if (m.kind === 'text' && m.role === 'user')
                    lastUserIndex = i;
            }
            const hasAssistantInJsonl = lastUserIndex === -1
                ? sourceMessages.some((m) => m.kind === 'text' && m.role === 'assistant')
                : sourceMessages.slice(lastUserIndex + 1).some((m) => m.kind === 'text' && m.role === 'assistant');
            if (sourceMessages.length === 0 || !hasAssistantInJsonl) {
                sourceMessages = loadDevinDbHistory(providerSessionId, limit, offset);
            }
        } else {
            sourceMessages = loadDevinDbHistory(providerSessionId, limit, offset);
        }
        const chainLength = sourceMessages.chainLength ?? sourceMessages.length;

        const messages = [];
        for (const message of sourceMessages) {
            messages.push(createNormalizedMessage({
                ...message,
                sessionId,
                provider: PROVIDER,
            }));
        }

        const normalizedOffset = Math.max(0, offset);
        const normalizedLimit = limit === null ? null : Math.max(0, limit);
        const { page, hasMore } = sliceTailPage(messages, normalizedLimit, normalizedOffset);

        const hasOlderNodes = limit !== null && chainLength > normalizedLimit + normalizedOffset;

        return {
            messages: page,
            total: limit === null ? messages.length : chainLength,
            hasMore: hasMore || hasOlderNodes,
            offset: normalizedOffset,
            limit: normalizedLimit,
        };
    }
}
