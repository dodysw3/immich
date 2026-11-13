/**
Near-duplicate VIDEO detection math. CLIP preview embeddings cannot separate
two encodes of the same video — the preview frame comes from an ffmpeg scene
heuristic, so re-encodes usually get a different poster and land far above
the maxDistance threshold (measured 0.05-0.19 for true re-copies). These
pure helpers score a candidate pair on physical signals instead: sampled
frame dHash grids, an audio RMS-envelope correlation, and metadata
(filename, capture time, resolution/fps), with guards for the false-weld
classes measured on a 54k-video library (see scoreVideoDuplicatePair).

Extraction (ffmpeg) lives in MediaRepository; orchestration in
DuplicateService. Weight/threshold values are calibrated — changing them
needs a recalibration pass against known duplicate and non-duplicate pairs.
*/

export interface VideoDuplicateMeta {
  id: string;
  originalFileName: string;
  durationMs: number;
  localDateTime: Date | string | null;
  width: number | null;
  height: number | null;
  fps: number | null;
  checksumHex: string;
}

export interface VideoFingerprint {
  /** 64-bit dHash per sampled frame, timeline order; null when extraction failed */
  frameHashes: bigint[] | null;
  /** mean adjacent-frame dHash distance in bits — near-static scenes stay low */
  motionBits: number | null;
  /** log-RMS envelope at 20ms windows over 8kHz mono PCM; null when no audio */
  audioEnvelope: Float64Array | null;
}

export interface VideoPairSignals {
  frames: number | null;
  audio: number | null;
  clip: number | null;
  filename: number | null;
  time: number | null;
  meta: number | null;
  motionA: number | null;
  motionB: number | null;
}

export interface VideoPairScore {
  score: number;
  signals: VideoPairSignals;
  /** never auto-group this pair (static-scene / no-physical-evidence guards) */
  reviewCap: boolean;
  /** effective GROUP threshold for this pair (raised when audioless) */
  groupFloor: number;
}

// Composite weights; renormalized over the signals that are available.
export const VIDEO_NEAR_DUP_WEIGHTS = {
  frames: 0.4,
  audio: 0.25,
  clip: 0.1,
  filename: 0.1,
  time: 0.1,
  meta: 0.05,
} as const;

// Cheap-gate arms (no ffmpeg): a pair must match at least one before
// extraction runs. Calibrated on 41.6M raw duration-bucket pairs: loose
// gates (clip >= 0.75 alone = 1.34M pairs) are useless — sequential WhatsApp
// names are Jaro-Winkler ~0.97 apart and personal-video CLIP runs hot.
export const VIDEO_NEAR_DUP_GATE = {
  name: 0.98,
  timeSec: 300,
  durationMsA: 1500,
  clip: 0.9,
  durationMsB: 1000,
} as const;

// Mean adjacent-frame dHash distance below which a video counts as
// near-static: measured 0.1-6.6 bits for a daily fixed-camera series vs
// >= 12 bits for moving content. Two near-static videos look identical
// regardless of recording day, so frame similarity carries no signal.
export const VIDEO_STATIC_MOTION_BITS = 8;

// Without audio evidence the weights renormalize toward frames+clip+filename,
// which welded semistatic series (broken device clocks make the capture-time
// signal useless there). Require a higher bar for audioless pairs.
export const VIDEO_AUDIOLESS_GROUP_FLOOR = 0.95;

export function dHash9x8Gray(buffer: Buffer): bigint {
  // 9x8 grayscale rawvideo: 8 horizontal gradient bits per row = 64 bits.
  let hash = 0n;
  let bit = 0n;
  for (let y = 0; y < 8; y++) {
    const row = y * 9;
    for (let x = 0; x < 8; x++) {
      if (buffer[row + x] > buffer[row + x + 1]) {
        hash |= 1n << bit;
      }
      bit++;
    }
  }
  return hash;
}

export function hammingDistance64(a: bigint, b: bigint): number {
  let x = a ^ b;
  let count = 0;
  while (x) {
    x &= x - 1n;
    count++;
  }
  return count;
}

export function meanAdjacentHamming(hashes: bigint[]): number | null {
  if (hashes.length < 2) {
    return null;
  }
  let sum = 0;
  for (let i = 1; i < hashes.length; i++) {
    sum += hammingDistance64(hashes[i - 1], hashes[i]);
  }
  return sum / (hashes.length - 1);
}

// Symmetric best-match mean hamming -> similarity in [0, 1]. Order-insensitive,
// robust to poster-frame selection and re-encode artifacts.
const bestHamming = (hash: bigint, other: bigint[]) => Math.min(...other.map((o) => hammingDistance64(hash, o)));

export function frameSimilarity(a: bigint[], b: bigint[]): number | null {
  if (a.length === 0 || b.length === 0) {
    return null;
  }
  const meanA = a.reduce((sum, hash) => sum + bestHamming(hash, b), 0) / a.length;
  const meanB = b.reduce((sum, hash) => sum + bestHamming(hash, a), 0) / b.length;
  return 1 - (meanA + meanB) / 2 / 64;
}

const ENV_WINDOW = 160; // 20ms at 8kHz

// 8kHz mono s16le PCM -> log-compressed RMS envelope. Log scale keeps the
// correlation robust to loudness/gain differences between encodes.
export function pcmToEnvelope(pcm: Buffer): Float64Array {
  const windows = Math.floor(pcm.length / 2 / ENV_WINDOW);
  const envelope = new Float64Array(windows);
  for (let w = 0; w < windows; w++) {
    let sum = 0;
    const base = w * ENV_WINDOW;
    for (let i = 0; i < ENV_WINDOW; i++) {
      const sample = pcm.readInt16LE((base + i) * 2);
      sum += sample * sample;
    }
    envelope[w] = Math.log10(Math.sqrt(sum / ENV_WINDOW) / 32_768 + 1e-6);
  }
  return envelope;
}

export function pearson(a: Float64Array | number[], b: Float64Array | number[]): number {
  const n = Math.min(a.length, b.length);
  if (n < 25) {
    return 0;
  }
  let sumA = 0;
  let sumB = 0;
  for (let i = 0; i < n; i++) {
    sumA += a[i];
    sumB += b[i];
  }
  const meanA = sumA / n;
  const meanB = sumB / n;
  let num = 0;
  let denA = 0;
  let denB = 0;
  for (let i = 0; i < n; i++) {
    const x = a[i] - meanA;
    const y = b[i] - meanB;
    num += x * y;
    denA += x * x;
    denB += y * y;
  }
  const den = Math.sqrt(denA * denB);
  return den > 0 ? num / den : 0;
}

// Envelope correlation with offset search (250 windows = ±5s at 20ms): tolerates
// container start offsets between encodes. Clamped at 0 — anti-correlation is
// evidence of difference, not of similarity.
export function envelopeSimilarity(a: Float64Array, b: Float64Array, maxOffsetWindows: number): number | null {
  if (a.length === 0 || b.length === 0) {
    return null;
  }
  let best = -1;
  for (let offset = -maxOffsetWindows; offset <= maxOffsetWindows; offset++) {
    let left: Float64Array;
    let right: Float64Array;
    if (offset >= 0) {
      left = a.subarray(offset);
      right = b.subarray(0, b.length - offset);
    } else {
      left = a.subarray(0, a.length + offset);
      right = b.subarray(-offset);
    }
    const r = pearson(left, right);
    if (r > best) {
      best = r;
    }
  }
  return Math.max(0, best);
}

const VIDEO_FILENAME_NOISE_TOKENS = new Set([
  'copy',
  'final',
  'converted',
  'encoded',
  'trim',
  'video',
  'vid',
  'mp4',
  'mov',
  'avi',
  'mkv',
  'webm',
  '720p',
  '1080p',
  '480p',
  '360p',
  '2160p',
  '4k',
  'x264',
  'x265',
  'h264',
  'h265',
  'hevc',
  'avc',
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
]);

export function normalizeVideoFilename(name: string): string {
  let normalized = name.normalize('NFC').toLowerCase();
  normalized = normalized.replace(/\.[a-z0-9]{2,5}$/, '');
  normalized = normalized.replaceAll(/[\s_\-.]+/g, ' ').trim();
  const tokens = normalized.split(' ').filter((token) => token && !VIDEO_FILENAME_NOISE_TOKENS.has(token));
  return tokens.join(' ') || normalized;
}

export function jaroWinkler(a: string, b: string): number {
  if (a === b) {
    return 1;
  }
  if (a.length === 0 || b.length === 0) {
    return 0;
  }
  const range = Math.floor(Math.max(a.length, b.length) / 2) - 1;
  const aMatch: boolean[] = Array.from({ length: a.length }, () => false);
  const bMatch: boolean[] = Array.from({ length: b.length }, () => false);
  let matches = 0;
  for (let i = 0; i < a.length; i++) {
    const lo = Math.max(0, i - range);
    const hi = Math.min(b.length - 1, i + range);
    for (let j = lo; j <= hi; j++) {
      if (!bMatch[j] && a[i] === b[j]) {
        aMatch[i] = true;
        bMatch[j] = true;
        matches++;
        break;
      }
    }
  }
  if (matches === 0) {
    return 0;
  }
  let transpositions = 0;
  let k = 0;
  for (let i = 0; i < a.length; i++) {
    if (!aMatch[i]) {
      continue;
    }
    while (!bMatch[k]) {
      k++;
    }
    if (a[i] !== b[k]) {
      transpositions++;
    }
    k++;
  }
  const m = matches;
  const jaro = (m / a.length + m / b.length + (m - transpositions / 2) / m) / 3;
  let prefix = 0;
  for (let i = 0; i < Math.min(4, a.length, b.length); i++) {
    if (a[i] === b[i]) {
      prefix++;
    } else {
      break;
    }
  }
  return jaro + prefix * 0.1 * (1 - jaro);
}

function asEpochMs(value: Date | string | null | undefined): number | null {
  if (!value) {
    return null;
  }
  const ms = value instanceof Date ? value.getTime() : new Date(value).getTime();
  return Number.isFinite(ms) ? ms : null;
}

function timeDeltaSec(a: VideoDuplicateMeta, b: VideoDuplicateMeta): number | null {
  const epochA = asEpochMs(a.localDateTime);
  const epochB = asEpochMs(b.localDateTime);
  if (epochA === null || epochB === null) {
    return null;
  }
  return Math.abs(epochA - epochB) / 1000;
}

function timeSimilarity(a: VideoDuplicateMeta, b: VideoDuplicateMeta): number | null {
  const delta = timeDeltaSec(a, b);
  if (delta === null) {
    return null;
  }
  if (delta <= 2) {
    return 1;
  }
  if (delta <= 30) {
    return 1 - (delta - 2) / 28;
  }
  return 0;
}

function metaSimilarity(a: VideoDuplicateMeta, b: VideoDuplicateMeta): number {
  // NaN-safe equality: null/undefined dimensions never count as equal
  const sameWidth = (a.width ?? NaN) === (b.width ?? NaN) && a.width !== null;
  const sameHeight = (a.height ?? NaN) === (b.height ?? NaN) && a.height !== null;
  const resolutionEqual = sameWidth && sameHeight ? 1 : 0;
  const fpsEqual = Math.abs((a.fps ?? NaN) - (b.fps ?? NaN)) < 0.5 ? 1 : 0;
  return resolutionEqual * 0.6 + fpsEqual * 0.4;
}

// Cheap-gate: true when the pair shows at least one strong metadata/visual
// anchor, so ffmpeg verification is worth its cost.
export function passesVideoCheapGate(
  a: VideoDuplicateMeta,
  b: VideoDuplicateMeta,
  clipSimilarity: number | null,
): boolean {
  if (a.checksumHex === b.checksumHex) {
    return true;
  }
  const durationDelta = Math.abs(a.durationMs - b.durationMs);
  if (
    jaroWinkler(normalizeVideoFilename(a.originalFileName), normalizeVideoFilename(b.originalFileName)) >=
      VIDEO_NEAR_DUP_GATE.name &&
    (timeDeltaSec(a, b) ?? Infinity) <= VIDEO_NEAR_DUP_GATE.timeSec &&
    durationDelta <= VIDEO_NEAR_DUP_GATE.durationMsA
  ) {
    return true;
  }
  if (
    clipSimilarity !== null &&
    clipSimilarity >= VIDEO_NEAR_DUP_GATE.clip &&
    durationDelta <= VIDEO_NEAR_DUP_GATE.durationMsB
  ) {
    return true;
  }
  return false;
}

const AUDIO_MAX_OFFSET_WINDOWS = 250; // ±5s at 20ms windows

// Composite similarity for one candidate pair. Guards baked into the result:
// - static-scene: two near-static videos look identical regardless of recording
//   day (daily webcam dumps welded transitively); only group when anchored by
//   identical filename AND capture time.
// - no-physical-evidence: frames AND audio unavailable (missing/corrupt file)
//   leaves only metadata, and every metadata signal can lie (broken clocks,
//   sequential names, shared ingest dates) -> review cap.
// - audioless: raised group floor (VIDEO_AUDIOLESS_GROUP_FLOOR).
// - checksumEqual: byte-identical is always a duplicate, score 1.
export function scoreVideoDuplicatePair(options: {
  source: VideoDuplicateMeta;
  candidate: VideoDuplicateMeta;
  sourceFingerprint: VideoFingerprint | null;
  candidateFingerprint: VideoFingerprint | null;
  clipSimilarity: number | null;
  groupThreshold: number;
}): VideoPairScore {
  const { source, candidate, sourceFingerprint, candidateFingerprint, clipSimilarity, groupThreshold } = options;
  const checksumEqual = source.checksumHex === candidate.checksumHex;

  const signals: VideoPairSignals = {
    frames: null,
    audio: null,
    clip: clipSimilarity,
    filename: jaroWinkler(
      normalizeVideoFilename(source.originalFileName),
      normalizeVideoFilename(candidate.originalFileName),
    ),
    time: timeSimilarity(source, candidate),
    meta: metaSimilarity(source, candidate),
    motionA: sourceFingerprint?.motionBits ?? null,
    motionB: candidateFingerprint?.motionBits ?? null,
  };
  if (sourceFingerprint?.frameHashes && candidateFingerprint?.frameHashes) {
    signals.frames = frameSimilarity(sourceFingerprint.frameHashes, candidateFingerprint.frameHashes);
  }
  if (sourceFingerprint?.audioEnvelope && candidateFingerprint?.audioEnvelope) {
    signals.audio = envelopeSimilarity(
      sourceFingerprint.audioEnvelope,
      candidateFingerprint.audioEnvelope,
      AUDIO_MAX_OFFSET_WINDOWS,
    );
  }

  const available = Object.entries(VIDEO_NEAR_DUP_WEIGHTS).filter(
    ([key]) => signals[key as keyof VideoPairSignals] !== null,
  );
  let score = 0;
  if (available.length > 0) {
    let weightSum = 0;
    for (const [key, weight] of available) {
      score += weight * (signals[key as keyof VideoPairSignals] as number);
      weightSum += weight;
    }
    score /= weightSum;
  }

  const bothStatic =
    (signals.motionA ?? Infinity) <= VIDEO_STATIC_MOTION_BITS &&
    (signals.motionB ?? Infinity) <= VIDEO_STATIC_MOTION_BITS;
  const deltaSec = timeDeltaSec(source, candidate);
  const anchored =
    (signals.filename ?? 0) >= VIDEO_NEAR_DUP_GATE.name && deltaSec !== null && deltaSec <= VIDEO_NEAR_DUP_GATE.timeSec;
  const noPhysicalEvidence = signals.frames === null && signals.audio === null && !checksumEqual;
  const reviewCap = (bothStatic && !anchored) || noPhysicalEvidence;
  const groupFloor =
    signals.audio === null && !checksumEqual ? Math.max(groupThreshold, VIDEO_AUDIOLESS_GROUP_FLOOR) : groupThreshold;

  if (checksumEqual) {
    score = 1;
  }

  return { score, signals, reviewCap, groupFloor };
}
