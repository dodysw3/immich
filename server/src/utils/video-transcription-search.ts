import { createHash } from 'node:crypto';
import { unicodeCaseFold } from 'src/utils/unicode-case-folding.js';

export interface TranscriptSegment {
  startMs: number;
  endMs: number;
  text: string;
}

export interface TextSpan {
  start: number;
  end: number;
}

export interface TranscriptToken extends TextSpan {
  text: string;
}

export interface NormalizedTranscript {
  text: string;
  offsets: TextSpan[];
  tokens: TranscriptToken[];
}

/** Offsets and spans are UTF-16 offsets into the original display string. */
export function normalizeTranscript(original: string): NormalizedTranscript {
  let text = '';
  const offsets: TextSpan[] = [];
  const graphemes = new Intl.Segmenter('und', { granularity: 'grapheme' });
  for (const { segment, index } of graphemes.segment(original)) {
    const normalized = unicodeCaseFold(segment.normalize('NFKD')).normalize('NFKD').replaceAll(/\p{M}/gu, '');
    text += normalized;
    for (let i = 0; i < normalized.length; i++) {
      offsets.push({ start: index, end: index + segment.length });
    }
  }
  const tokens: TranscriptToken[] = Array.from(text.matchAll(/[\p{L}\p{N}]+/gu), (match) => ({
    text: match[0],
    start: offsets[match.index].start,
    end: offsets[match.index + match[0].length - 1].end,
  }));
  return { text, offsets, tokens };
}

export interface TranscriptWindow {
  id: string;
  firstSegment: number;
  lastSegment: number;
  startMs: number;
  endMs: number;
  text: string;
  tokens: TranscriptToken[];
  segmentSpans: TextSpan[];
  segmentStartsMs: number[];
}

export function transcriptContentRevision(segments: readonly TranscriptSegment[]): string {
  return createHash('sha256')
    .update(JSON.stringify(segments.map(({ startMs, endMs, text }) => [startMs, endMs, text])))
    .digest('hex');
}

export function buildTranscriptWindows(segments: readonly TranscriptSegment[]): TranscriptWindow[] {
  const windows: TranscriptWindow[] = [];
  for (let first = 0; first < segments.length; first++) {
    let text = '';
    const segmentSpans: TextSpan[] = [];
    for (let last = first; last < Math.min(segments.length, first + 3); last++) {
      const segment = segments[last];
      if (
        last > first &&
        (segment.startMs - segments[last - 1].endMs > 2000 || segment.endMs - segments[first].startMs > 30_000)
      ) {
        break;
      }
      if (last > first) text += ' ';
      const start = text.length;
      text += segment.text;
      segmentSpans.push({ start, end: text.length });
      windows.push({
        id: `${first}:${last}`,
        firstSegment: first,
        lastSegment: last,
        startMs: segments[first].startMs,
        endMs: segment.endMs,
        text,
        tokens: normalizeTranscript(text).tokens,
        segmentSpans: [...segmentSpans],
        segmentStartsMs: segments.slice(first, last + 1).map((item) => item.startMs),
      });
    }
  }
  return windows;
}

export type TranscriptMatchTier = 'exact-phrase' | 'exact-all' | 'fuzzy' | 'partial';
export interface TranscriptRankingSettings {
  coverageWeight: number;
  proximityWeight: number;
  similarityWeight: number;
  minimumCoverage: number;
  fuzzyThreshold: number;
  minimumFuzzyLength: number;
}
export const DEFAULT_TRANSCRIPT_RANKING: TranscriptRankingSettings = {
  coverageWeight: 0.5,
  proximityWeight: 0.3,
  similarityWeight: 0.2,
  minimumCoverage: 1,
  fuzzyThreshold: 0.5,
  minimumFuzzyLength: 4,
};

/** Supplied from SQL strict_word_similarity(queryToken, passageToken); values must be in [0, 1]. */
export type TokenSimilarity = (queryToken: string, passageToken: string) => number;
export interface TranscriptMatch {
  window: TranscriptWindow;
  tier: TranscriptMatchTier;
  score: number;
  coverage: number;
  proximity: number;
  similarity: number;
  spans: TextSpan[];
  startMs: number;
  matchedSegments: number[];
}

export function rankTranscriptWindow(
  window: TranscriptWindow,
  query: string,
  similarity: TokenSimilarity,
  settings: TranscriptRankingSettings = DEFAULT_TRANSCRIPT_RANKING,
): TranscriptMatch | undefined {
  const weight = settings.coverageWeight + settings.proximityWeight + settings.similarityWeight;
  if (
    [settings.coverageWeight, settings.proximityWeight, settings.similarityWeight].some(
      (n) => !Number.isFinite(n) || n < 0,
    ) ||
    !Number.isFinite(weight) ||
    weight <= 0 ||
    !Number.isFinite(settings.minimumCoverage) ||
    settings.minimumCoverage <= 0 ||
    settings.minimumCoverage > 1 ||
    !Number.isFinite(settings.fuzzyThreshold) ||
    settings.fuzzyThreshold < 0 ||
    settings.fuzzyThreshold > 1 ||
    !Number.isSafeInteger(settings.minimumFuzzyLength) ||
    settings.minimumFuzzyLength < 1
  )
    throw new Error('Invalid transcript ranking settings');
  const q = normalizeTranscript(query).tokens.map((token) => token.text);
  if (q.length === 0) return;
  const t = window.tokens;
  let phrase = -1;
  for (let i = 0; i <= t.length - q.length; i++) {
    if (q.every((word, j) => word === t[i + j].text)) {
      phrase = i;
      break;
    }
  }
  let best: { indices: number[]; sum: number; exact: number };
  if (phrase >= 0) {
    best = { indices: q.map((_, i) => phrase + i), sum: q.length, exact: q.length };
  } else {
    const used = new Set<number>();
    const exactIndices = q.map((word) => {
      const index = t.findIndex((token, i) => token.text === word && !used.has(i));
      if (index !== -1) used.add(index);
      return index;
    });
    if (exactIndices.every((i) => i >= 0)) {
      best = { indices: exactIndices, sum: q.length, exact: q.length };
    } else {
      // Rectangular Hungarian assignment, including one unmatched column per query token.
      // Coverage dominates exact count, which dominates total spelling similarity.
      const columns = t.length + q.length;
      const values = q.map((word) =>
        t.map((token) => {
          if (word === token.text) return 1;
          const value = word.length >= settings.minimumFuzzyLength ? similarity(word, token.text) : 0;
          if (!Number.isFinite(value) || value < 0 || value > 1) throw new Error('Invalid token similarity');
          return value > 0 && value >= settings.fuzzyThreshold ? value : 0;
        }),
      );
      const u = Array.from({ length: q.length + 1 }, (): number => 0);
      const v = Array.from({ length: columns + 1 }, (): number => 0);
      const assigned = Array.from({ length: columns + 1 }, (): number => 0);
      const previous = Array.from({ length: columns + 1 }, (): number => 0);
      for (let row = 1; row <= q.length; row++) {
        assigned[0] = row;
        let column = 0;
        const min = Array.from({ length: columns + 1 }, (): number => Infinity);
        const visited = Array.from({ length: columns + 1 }, (): boolean => false);
        do {
          visited[column] = true;
          const current = assigned[column];
          let delta = Infinity;
          let next = 0;
          for (let j = 1; j <= columns; j++) {
            if (visited[j]) continue;
            const value = j <= t.length ? values[current - 1][j - 1] : 0;
            const exact = j <= t.length && q[current - 1] === t[j - 1].text;
            const cost = value > 0 ? -((q.length + 1) ** 2 + Number(exact) * (q.length + 1) + value) : 0;
            const reduced = cost - u[current] - v[j];
            if (reduced < min[j]) {
              min[j] = reduced;
              previous[j] = column;
            }
            if (!(min[j] < delta)) {
              continue;
            }

            delta = min[j];
            next = j;
          }
          for (let j = 0; j <= columns; j++) {
            if (visited[j]) {
              u[assigned[j]] += delta;
              v[j] -= delta;
            } else min[j] -= delta;
          }
          column = next;
        } while (assigned[column] !== 0);
        do {
          const next = previous[column];
          assigned[column] = assigned[next];
          column = next;
        } while (column !== 0);
      }
      best = { indices: [], sum: 0, exact: 0 };
      for (let j = 1; j <= t.length; j++) {
        const row = assigned[j] - 1;
        if (row < 0 || values[row][j - 1] === 0) continue;
        best.indices.push(j - 1);
        best.sum += values[row][j - 1];
        best.exact += Number(q[row] === t[j - 1].text);
      }
    }
  }
  const coverage = best.indices.length / q.length;
  if (coverage < settings.minimumCoverage || coverage === 0) return;
  const exactAll = best.indices.length === q.length && best.exact === q.length;
  const tier: TranscriptMatchTier =
    phrase >= 0 ? 'exact-phrase' : exactAll ? 'exact-all' : coverage === 1 ? 'fuzzy' : 'partial';
  const indices = best.indices.toSorted((a, b) => a - b);
  const proximity = indices.length === 1 ? 1 : (indices.length - 1) / (indices.at(-1)! - indices[0]);
  const spelling = best.sum / indices.length;
  const spans = indices.map((i) => ({ start: t[i].start, end: t[i].end }));
  const matchedSegments = window.segmentSpans
    .map((segment, i) => ({ segment, index: window.firstSegment + i }))
    .filter(({ segment }) => spans.some((span) => span.start < segment.end && span.end > segment.start))
    .map(({ index }) => index);
  return {
    window,
    tier,
    score:
      (coverage * settings.coverageWeight +
        proximity * settings.proximityWeight +
        spelling * settings.similarityWeight) /
      weight,
    coverage,
    proximity,
    similarity: spelling,
    spans,
    startMs: window.segmentStartsMs[matchedSegments[0] - window.firstSegment],
    matchedSegments,
  };
}

const tiers: Record<TranscriptMatchTier, number> = { 'exact-phrase': 0, 'exact-all': 1, fuzzy: 2, partial: 3 };
export function compareTranscriptMatches(a: TranscriptMatch, b: TranscriptMatch): number {
  return (
    tiers[a.tier] - tiers[b.tier] ||
    b.score - a.score ||
    a.startMs - b.startMs ||
    a.window.id.localeCompare(b.window.id, 'en')
  );
}

/** Windows describing the same matched token occurrences collapse; repeated moments remain distinct. */
export function deduplicateTranscriptMatches(matches: readonly TranscriptMatch[]): TranscriptMatch[] {
  const sorted = [...matches].sort(compareTranscriptMatches);
  const seen = new Set<string>();
  return sorted.filter((match) => {
    const key = match.spans
      .map((span) => {
        const i = match.window.segmentSpans.findIndex(
          (segment) => span.start >= segment.start && span.start < segment.end,
        );
        return `${match.window.firstSegment + i}:${span.start - match.window.segmentSpans[i].start}:${span.end - match.window.segmentSpans[i].start}`;
      })
      .join(',');
    if (seen.has(key)) return false;
    seen.add(key);
    return true;
  });
}
