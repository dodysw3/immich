import type { TranscriptPassageInsert } from 'src/repositories/transcript-index.repository.js';
import { buildTranscriptWindows, type TranscriptSegment } from 'src/utils/video-transcription-search.js';

/**
Index format version: bump to force re-indexing of every video (schema or
window-policy changes). Reconciliation compares this against
transcript_index_state.indexVersion.
*/
export const TRANSCRIPT_INDEX_VERSION = 1;

/** Map transcript segments to indexable passages (bounded adjacent-segment windows). */
export const planTranscriptPassages = (segments: readonly TranscriptSegment[]): TranscriptPassageInsert[] =>
  buildTranscriptWindows(segments).map((window) => ({
    windowId: window.id,
    firstSegment: window.firstSegment,
    lastSegment: window.lastSegment,
    startMs: window.startMs,
    endMs: window.endMs,
    text: window.text,
    // Space-joined normalized token text: the FTS vector is built from this
    // with the `simple` configuration.
    normalizedText: window.tokens.map((token) => token.text).join(' '),
    tokens: window.tokens.map((token) => token.text),
    segmentSpans: window.segmentSpans,
    segmentStartsMs: window.segmentStartsMs,
  }));
