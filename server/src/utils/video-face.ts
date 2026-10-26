// Pure video-face discovery core: sampling plans, within-video identity
// grouping, and consolidation. No I/O — the scan job and the dry-run CLI both
// drive these functions. Deterministic: same inputs and config produce the
// same outputs.

export interface VideoFaceScanConfig {
  // analyzed-frame cap per run
  framesBudget: number;
  // never bisect or sample below this spacing
  minGapMs: number;
  // consecutive samples with no new identity (and all gaps < minGapMs) that end a run early
  saturation: number;
  // within-video grouping threshold (cosine distance); 0.55 is the
  // cross-video-verified default — 0.6 + exemplar merge false-merges on 480p
  groupThreshold: number;
  // second-stage merge of clusters whose best exemplars are within threshold
  exemplarMerge: boolean;
  // crowd guard: max identities kept per video (best N by quality)
  identitiesCap: number;
  // cumulative wall-clock deadline per run, including decode
  deadlineMs: number;
  // detection gates
  minScore: number;
  minFaceSizePx: number;
  // single-sighting identities below this quality are flagged, not published
  singleSightingMinPx: number;
  singleSightingMinScore: number;
  // adaptive gap-bisection weights (used only when policy = 'adaptive')
  wDiff: number;
  wFace: number;
  wEmpty: number;
}

export const VIDEO_FACE_DEFAULT_CONFIG: VideoFaceScanConfig = {
  framesBudget: 32,
  minGapMs: 1500,
  saturation: 6,
  groupThreshold: 0.55,
  exemplarMerge: true,
  identitiesCap: 30,
  deadlineMs: 120_000,
  minScore: 0.5,
  minFaceSizePx: 22,
  singleSightingMinPx: 60,
  singleSightingMinScore: 0.8,
  wDiff: 3,
  wFace: 1.5,
  wEmpty: 0.7,
};

export type SampleReason = 'seed' | 'gap' | 'burst';

export interface SampledFrame {
  timeMs: number;
  reason: SampleReason;
  // detections accepted by the gates, embeddings normalized
  detections: VideoFaceDetectionCore;
}

export interface VideoFaceDetectionCore {
  score: number;
  sizePx: number;
  x1: number;
  y1: number;
  x2: number;
  y2: number;
  imageWidth: number;
  imageHeight: number;
  embedding: number[];
}

export interface VideoFaceIdentity {
  identityKey: string;
  firstObservedMs: number;
  lastObservedMs: number;
  sightingCount: number;
  bestFrameMs: number;
  bestScore: number;
  bestSizePx: number;
  bestEmbedding: number[];
  flagged: boolean;
  droppedByCrowdGuard?: boolean;
  sightings: {
    timeMs: number;
    score: number;
    sizePx: number;
    x1: number;
    y1: number;
    x2: number;
    y2: number;
    imageWidth: number;
    imageHeight: number;
  }[];
}

/** Uniform seed plan: budget frames at midpoint spacing across the timeline. */
export function planUniformSamples(durationMs: number, budget: number): { timeMs: number; reason: SampleReason }[] {
  const n = Math.max(1, Math.min(budget, Math.floor(durationMs / 1000) || 1));
  const points: { timeMs: number; reason: SampleReason }[] = [];
  for (let i = 0; i < n; i++) {
    points.push({ timeMs: Math.round((durationMs * (i + 0.5)) / n), reason: 'seed' });
  }
  return points;
}

export interface GapBisectState {
  sampled: { timeMs: number; identityKeys: Set<string> }[];
  durationMs: number;
}

/**
 * Adaptive gap bisection: next sample = midpoint of the highest-priority
 * unsampled gap. Priority = length x (signatures differ ? wDiff : 1) x
 * (gap has any faces ? wFace : wEmpty). Deterministic tie-break: earliest gap.
 */
export function nextSampleByGap(state: GapBisectState, cfg: VideoFaceScanConfig): { timeMs: number; reason: SampleReason } | null {
  const times = [...state.sampled.map((s) => s.timeMs)].sort((a, b) => a - b);
  const bounds = [0, ...times, state.durationMs];
  let best: { mid: number; priority: number } | null = null;
  for (let i = 0; i < bounds.length - 1; i++) {
    const start = bounds[i];
    const end = bounds[i + 1];
    const length = end - start;
    if (length < 2 * cfg.minGapMs) {
      continue; // cannot fit a new sample with min spacing
    }
    // interior gaps sit between two sampled points; edge gaps against 0/duration
    const before = i > 0 ? state.sampled.find((s) => s.timeMs === start) : undefined;
    const after = i + 1 < bounds.length - 1 ? state.sampled.find((s) => s.timeMs === end) : undefined;
    const sigDiffers =
      before && after && !setsEqual(before.identityKeys, after.identityKeys) ? cfg.wDiff : 1;
    const anyFaces = before?.identityKeys.size || after?.identityKeys.size ? cfg.wFace : cfg.wEmpty;
    const priority = length * sigDiffers * anyFaces;
    const mid = Math.round((start + end) / 2);
    if (!best || priority > best.priority || (priority === best.priority && mid < best.mid)) {
      best = { mid, priority };
    }
  }
  return best ? { timeMs: best.mid, reason: 'gap' } : null;
}

/**
 * Saturation stop: last `saturation` samples contributed no new identity AND
 * every gap between consecutive samples is below minGapMs. Either condition
 * failing keeps the run going — new identities can appear at the very end of
 * the timeline (bench: 10 identities in the final 2.4s of a 23s video).
 */
export function shouldStopForSaturation(
  history: { timeMs: number; newIdentityKeys: string[] }[],
  cfg: VideoFaceScanConfig,
): boolean {
  if (history.length < cfg.saturation) {
    return false;
  }
  const tail = history.slice(-cfg.saturation);
  if (tail.some((s) => s.newIdentityKeys.length > 0)) {
    return false;
  }
  const times = history.map((s) => s.timeMs).sort((a, b) => a - b);
  const gaps = times.slice(1).map((t, i) => t - times[i]);
  return gaps.every((g) => g < cfg.minGapMs);
}

export interface GroupInput {
  timeMs: number;
  detections: VideoFaceDetectionCore[];
}

function normalize(embedding: number[]): number[] {
  const norm = Math.sqrt(embedding.reduce((sum, v) => sum + v * v, 0));
  return norm === 0 ? embedding : embedding.map((v) => v / norm);
}

export function cosineDistance(a: number[], b: number[]): number {
  let dot = 0;
  for (let i = 0; i < Math.min(a.length, b.length); i++) {
    dot += a[i] * b[i];
  }
  return 1 - dot;
}

interface WorkingIdentity {
  sum: number[];
  count: number;
  members: { timeMs: number; det: VideoFaceDetectionCore }[];
}

/**
 * Group detections into within-video identities.
 *
 * Greedy centroid clustering in chronological order; two detections from the
 * same decoded frame (same timeMs) never merge into one identity. Optional
 * second stage merges clusters whose best exemplars (max size x score) are
 * within the threshold — halves splits at 0.55 without false merges.
 */
export function groupDetections(frames: GroupInput[], cfg: VideoFaceScanConfig): VideoFaceIdentity[] {
  const identities: WorkingIdentity[] = [];

  const sorted = [...frames].sort((a, b) => a.timeMs - b.timeMs);
  for (const frame of sorted) {
    for (const det of frame.detections) {
      if (det.score < cfg.minScore || det.sizePx < cfg.minFaceSizePx) {
        continue;
      }
      const emb = normalize(det.embedding);
      let best: WorkingIdentity | null = null;
      let bestD = Number.POSITIVE_INFINITY;
      for (const identity of identities) {
        if (identity.members.some((m) => m.timeMs === frame.timeMs)) {
          continue; // same-frame rule: one identity, one face per frame
        }
        const centroid = identity.sum.map((v) => v / identity.count);
        const d = cosineDistance(emb, centroid);
        if (d < bestD) {
          bestD = d;
          best = identity;
        }
      }
      if (best && bestD < cfg.groupThreshold) {
        best.sum = best.sum.map((v, i) => v + emb[i]);
        best.count += 1;
        best.members.push({ timeMs: frame.timeMs, det });
      } else {
        identities.push({ sum: emb, count: 1, members: [{ timeMs: frame.timeMs, det }] });
      }
    }
  }

  const exemplar = (identity: WorkingIdentity) =>
    identity.members.reduce((best, m) => {
      const quality = m.det.sizePx * m.det.score;
      const bestQuality = best.det.sizePx * best.det.score;
      return quality > bestQuality ? m : best;
    });

  if (cfg.exemplarMerge) {
    let changed = true;
    while (changed) {
      changed = false;
      outer: for (let i = 0; i < identities.length; i++) {
        for (let j = i + 1; j < identities.length; j++) {
          // same-frame rule applies to the merge pass too: clusters that both
          // have a face from one frame are two different people
          const framesI = new Set(identities[i].members.map((m) => m.timeMs));
          if (identities[j].members.some((m) => framesI.has(m.timeMs))) {
            continue;
          }
          const a = exemplar(identities[i]);
          const b = exemplar(identities[j]);
          if (cosineDistance(normalize(a.det.embedding), normalize(b.det.embedding)) < cfg.groupThreshold) {
            identities[i] = {
              sum: identities[i].sum.map((v, k) => v + identities[j].sum[k]),
              count: identities[i].count + identities[j].count,
              members: [...identities[i].members, ...identities[j].members],
            };
            identities.splice(j, 1);
            changed = true;
            break outer;
          }
        }
      }
    }
  }

  const consolidated = identities.map((identity) => {
    const times = identity.members.map((m) => m.timeMs);
    const best = exemplar(identity);
    const singleSighting =
      identity.count === 1 &&
      best.det.sizePx < cfg.singleSightingMinPx &&
      best.det.score < cfg.singleSightingMinScore;
    return {
      identityKey: '', // assigned by caller (stable per asset)
      droppedByCrowdGuard: false,
      firstObservedMs: Math.min(...times),
      lastObservedMs: Math.max(...times),
      sightingCount: identity.count,
      bestFrameMs: best.timeMs,
      bestScore: best.det.score,
      bestSizePx: best.det.sizePx,
      bestEmbedding: normalize(best.det.embedding),
      flagged: singleSighting,
      sightings: identity.members
        .map((m) => ({
          timeMs: m.timeMs,
          score: m.det.score,
          sizePx: m.det.sizePx,
          x1: m.det.x1,
          y1: m.det.y1,
          x2: m.det.x2,
          y2: m.det.y2,
          imageWidth: m.det.imageWidth,
          imageHeight: m.det.imageHeight,
        }))
        .sort((a, b) => a.timeMs - b.timeMs),
    } satisfies VideoFaceIdentity;
    }) as VideoFaceIdentity[];

  // crowd guard: keep the best N by quality (size x score of exemplar), drop the rest
  consolidated.sort((a, b) => b.bestSizePx * b.bestScore - a.bestSizePx * a.bestScore);
  for (let i = 0; i < consolidated.length; i++) {
    consolidated[i].droppedByCrowdGuard = i >= cfg.identitiesCap;
  }
  return consolidated.filter((c) => !c.droppedByCrowdGuard);
}

/**
 * Assign stable identity keys: order identities by first observation (then
 * quality) so the same video + config yields the same keys on re-run.
 */
export function assignIdentityKeys(identities: VideoFaceIdentity[]): VideoFaceIdentity[] {
  const sorted = [...identities].sort(
    (a, b) => a.firstObservedMs - b.firstObservedMs || b.bestSizePx * b.bestScore - a.bestSizePx * a.bestScore,
  );
  return sorted.map((identity, i) => ({ ...identity, identityKey: `v${i}` }));
}

/** sha256-ready stable stringification of the resolved config for hashing. */
export function configFingerprint(cfg: VideoFaceScanConfig, modelVersions: string): string {
  return JSON.stringify({ cfg: { ...cfg }, modelVersions });
}

function setsEqual(a: Set<string>, b: Set<string>): boolean {
  if (a.size !== b.size) {
    return false;
  }
  for (const v of a) {
    if (!b.has(v)) {
      return false;
    }
  }
  return true;
}
