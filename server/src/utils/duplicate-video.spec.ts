import { describe, expect, it } from 'vitest';
import {
  dHash9x8Gray,
  envelopeSimilarity,
  frameSimilarity,
  hammingDistance64,
  jaroWinkler,
  meanAdjacentHamming,
  normalizeVideoFilename,
  passesVideoCheapGate,
  pcmToEnvelope,
  scoreVideoDuplicatePair,
  type VideoDuplicateMeta,
  type VideoFingerprint,
} from 'src/utils/duplicate-video.js';

const FINGERPRINT_BYTES = 72;

// 9x8 gray buffer with each row monotonically descending: every horizontal
// gradient step goes bright->dark, so all 64 dHash bits set.
const stripedFrame = (invert = false) => {
  const buffer = Buffer.alloc(FINGERPRINT_BYTES);
  for (let y = 0; y < 8; y++) {
    for (let x = 0; x < 9; x++) {
      buffer[y * 9 + x] = invert ? x * 20 : 200 - x * 20;
    }
  }
  return buffer;
};

const ALL_BITS = (1n << 64n) - 1n;

const makeMeta = (overrides: Partial<VideoDuplicateMeta> = {}): VideoDuplicateMeta => ({
  id: '00000000-0000-4000-8000-000000000001',
  originalFileName: 'VID-20240727-WA0004.mp4',
  durationMs: 473_942,
  localDateTime: new Date('2024-07-27T04:51:30Z'),
  width: 640,
  height: 360,
  fps: 25,
  checksumHex: 'aa'.repeat(20),
  ...overrides,
});

const makeFingerprint = (overrides: Partial<VideoFingerprint> = {}): VideoFingerprint => ({
  frameHashes: [0n, 0n, 0n, 0n, 0n, 0n, 0n, 0n],
  motionBits: 20,
  // varying envelope: a constant one has zero variance and Pearson returns 0
  audioEnvelope: Float64Array.from({ length: 500 }, (_, i) => Math.sin(i / 10)),
  ...overrides,
});

describe('dHash9x8Gray', () => {
  it('sets all bits on a bright->dark gradient', () => {
    expect(dHash9x8Gray(stripedFrame())).toBe(ALL_BITS);
  });

  it('sets no bits on a dark->bright gradient', () => {
    expect(dHash9x8Gray(stripedFrame(true))).toBe(0n);
  });
});

describe('hammingDistance64', () => {
  it('counts differing bits', () => {
    expect(hammingDistance64(0n, 0n)).toBe(0);
    expect(hammingDistance64(7n, 0n)).toBe(3);
    expect(hammingDistance64(ALL_BITS, 0n)).toBe(64);
  });
});

describe('meanAdjacentHamming', () => {
  it('averages adjacent distances', () => {
    expect(meanAdjacentHamming([0n, 7n, 0n])).toBe(3);
  });

  it('returns null for fewer than two frames', () => {
    expect(meanAdjacentHamming([0n])).toBeNull();
  });
});

describe('frameSimilarity', () => {
  it('is 1 for identical frame sets', () => {
    const hashes = [0n, 5n, 7n];
    expect(frameSimilarity(hashes, hashes)).toBe(1);
  });

  it('is order-insensitive via symmetric best match', () => {
    // a's frame matches b's first perfectly (0 bits); b's mean includes the
    // total mismatch (64) -> 1 - (0 + 32) / 2 / 64 = 0.75
    expect(frameSimilarity([0n], [0n, ALL_BITS])).toBe(0.75);
  });

  it('is 0 for fully disjoint frames', () => {
    expect(frameSimilarity([0n], [ALL_BITS])).toBe(0);
  });

  it('returns null for empty input', () => {
    expect(frameSimilarity([], [0n])).toBeNull();
  });
});

const sinePcm = (cycles: number) => {
  const samples = 40_000;
  const buffer = Buffer.alloc(samples * 2);
  for (let i = 0; i < samples; i++) {
    buffer.writeInt16LE(Math.round(Math.sin((i / samples) * cycles * 2 * Math.PI) * 20_000), i * 2);
  }
  return buffer;
};

describe('pcmToEnvelope + envelopeSimilarity', () => {
  it('is 1 for identical audio', () => {
    const envelope = pcmToEnvelope(sinePcm(40));
    expect(envelopeSimilarity(envelope, envelope, 250)).toBe(1);
  });

  it('recovers a sub-second offset between encodes', () => {
    const pcm = sinePcm(40);
    const envelope = pcmToEnvelope(pcm);
    const shifted = pcmToEnvelope(pcm.subarray(0.5 * 8000 * 2));
    expect(envelopeSimilarity(envelope, shifted, 250)).toBeGreaterThan(0.99);
  });

  it('stays near 0 for unrelated audio', () => {
    const a = pcmToEnvelope(sinePcm(40));
    const b = pcmToEnvelope(sinePcm(400));
    expect(envelopeSimilarity(a, b, 250)).toBeLessThan(0.3);
  });
});

describe('jaroWinkler', () => {
  it('is 1 for identical strings and 0 for empty ones', () => {
    expect(jaroWinkler('abc', 'abc')).toBe(1);
    expect(jaroWinkler('', 'abc')).toBe(0);
  });

  it('matches the MARTHA/MARHTA reference value', () => {
    expect(jaroWinkler('MARTHA', 'MARHTA')).toBeCloseTo(0.961, 3);
  });

  it('scores near-duplicate sequential camera names very high', () => {
    expect(jaroWinkler('20240718 wa0017', '20240718 wa0018')).toBeGreaterThan(0.95);
  });
});

describe('normalizeVideoFilename', () => {
  it('strips extensions, case, separators, and noise tokens', () => {
    // the copy-suffix "(1)" is kept — mirrors the calibrated scanner behavior
    expect(normalizeVideoFilename('VID-20240727-WA0004 (1).MP4')).toBe('20240727 wa0004 (1)');
    expect(normalizeVideoFilename('My Vacation_Copy.mp4')).toBe('my vacation');
    expect(normalizeVideoFilename('clip.720p.x264.mp4')).toBe('clip');
  });
});

describe('passesVideoCheapGate', () => {
  it('passes on equal checksum', () => {
    const a = makeMeta();
    const b = makeMeta({
      id: '00000000-0000-4000-8000-000000000002',
      originalFileName: 'other.mp4',
      localDateTime: null,
    });
    expect(passesVideoCheapGate(a, b, null)).toBe(true);
  });

  it('passes on same name + capture time + duration', () => {
    const a = makeMeta();
    const b = makeMeta({
      id: '00000000-0000-4000-8000-000000000002',
      durationMs: 473_988,
      localDateTime: new Date('2024-07-27T04:51:30Z'),
    });
    expect(passesVideoCheapGate(a, b, null)).toBe(true);
  });

  it('passes on high clip similarity with matching duration', () => {
    const a = makeMeta({ originalFileName: 'holiday.mp4', localDateTime: null });
    const b = makeMeta({
      id: '00000000-0000-4000-8000-000000000002',
      originalFileName: 'renamed.mp4',
      localDateTime: null,
      durationMs: 474_200,
    });
    expect(passesVideoCheapGate(a, b, 0.93)).toBe(true);
  });

  it('rejects unrelated pairs', () => {
    const a = makeMeta();
    const b = makeMeta({
      id: '00000000-0000-4000-8000-000000000002',
      originalFileName: 'totally-different-name.mp4',
      localDateTime: new Date('2019-01-01T00:00:00Z'),
      durationMs: 61_650,
      checksumHex: 'bb'.repeat(20),
    });
    expect(passesVideoCheapGate(a, b, 0.4)).toBe(false);
  });
});

describe('scoreVideoDuplicatePair', () => {
  it('scores a re-encoded duplicate of the same video at ~1', () => {
    const score = scoreVideoDuplicatePair({
      source: makeMeta(),
      candidate: makeMeta({
        id: '00000000-0000-4000-8000-000000000002',
        durationMs: 473_896,
        checksumHex: 'bb'.repeat(20),
      }),
      sourceFingerprint: makeFingerprint(),
      candidateFingerprint: makeFingerprint(),
      clipSimilarity: 0.95,
      groupThreshold: 0.9,
    });
    expect(score.score).toBeGreaterThan(0.95);
    expect(score.reviewCap).toBe(false);
    expect(score.groupFloor).toBe(0.9);
  });

  it('forces score 1 on equal checksum', () => {
    const score = scoreVideoDuplicatePair({
      source: makeMeta(),
      candidate: makeMeta({ id: '00000000-0000-4000-8000-000000000002' }),
      sourceFingerprint: null,
      candidateFingerprint: null,
      clipSimilarity: null,
      groupThreshold: 0.9,
    });
    expect(score.score).toBe(1);
  });

  it('review-caps two near-static videos that are not name+time anchored', () => {
    const score = scoreVideoDuplicatePair({
      source: makeMeta({ originalFileName: 'deskcam-20161223.mp4', localDateTime: new Date('2017-03-01T15:04:08Z') }),
      candidate: makeMeta({
        id: '00000000-0000-4000-8000-000000000002',
        originalFileName: 'deskcam-20161231.mp4',
        localDateTime: new Date('2017-03-01T15:04:08Z'),
        durationMs: 60_041,
      }),
      sourceFingerprint: makeFingerprint({ motionBits: 6, audioEnvelope: null }),
      candidateFingerprint: makeFingerprint({ motionBits: 0.5, audioEnvelope: null }),
      clipSimilarity: 0.97,
      groupThreshold: 0.9,
    });
    expect(score.reviewCap).toBe(true);
  });

  it('does not review-cap near-static videos anchored by name + capture time', () => {
    const score = scoreVideoDuplicatePair({
      source: makeMeta({ originalFileName: 'deskcam-20161223.mp4', localDateTime: new Date('2017-03-01T15:04:08Z') }),
      candidate: makeMeta({
        id: '00000000-0000-4000-8000-000000000002',
        originalFileName: 'deskcam-20161223.mp4',
        localDateTime: new Date('2017-03-01T15:04:09Z'),
        durationMs: 60_041,
      }),
      sourceFingerprint: makeFingerprint({ motionBits: 6, audioEnvelope: null }),
      candidateFingerprint: makeFingerprint({ motionBits: 0.5, audioEnvelope: null }),
      clipSimilarity: 0.97,
      groupThreshold: 0.9,
    });
    expect(score.reviewCap).toBe(false);
  });

  it('review-caps pairs without physical evidence (both fingerprints null)', () => {
    const score = scoreVideoDuplicatePair({
      source: makeMeta({ localDateTime: new Date('2017-04-01T22:02:55Z'), originalFileName: 'origcam-20170311.mp4' }),
      candidate: makeMeta({
        id: '00000000-0000-4000-8000-000000000002',
        localDateTime: new Date('2017-04-01T22:02:55Z'),
        originalFileName: 'origcam-20170319.mp4',
        checksumHex: 'bb'.repeat(20),
      }),
      sourceFingerprint: null,
      candidateFingerprint: null,
      clipSimilarity: 0.93,
      groupThreshold: 0.9,
    });
    expect(score.reviewCap).toBe(true);
  });

  it('raises the group floor to 0.95 for audioless pairs', () => {
    const score = scoreVideoDuplicatePair({
      source: makeMeta(),
      candidate: makeMeta({
        id: '00000000-0000-4000-8000-000000000002',
        durationMs: 473_896,
        checksumHex: 'bb'.repeat(20),
      }),
      sourceFingerprint: makeFingerprint({ audioEnvelope: null }),
      candidateFingerprint: makeFingerprint({ audioEnvelope: null }),
      clipSimilarity: 0.9,
      groupThreshold: 0.9,
    });
    expect(score.groupFloor).toBe(0.95);
  });

  it('keeps the configured floor when audio is available', () => {
    const score = scoreVideoDuplicatePair({
      source: makeMeta(),
      candidate: makeMeta({
        id: '00000000-0000-4000-8000-000000000002',
        durationMs: 473_896,
        checksumHex: 'bb'.repeat(20),
      }),
      sourceFingerprint: makeFingerprint(),
      candidateFingerprint: makeFingerprint(),
      clipSimilarity: 0.9,
      groupThreshold: 0.9,
    });
    expect(score.groupFloor).toBe(0.9);
  });

  it('accepts string localDateTime values', () => {
    const score = scoreVideoDuplicatePair({
      source: makeMeta({ localDateTime: '2024-07-27T04:51:30Z' }),
      candidate: makeMeta({
        id: '00000000-0000-4000-8000-000000000002',
        durationMs: 473_896,
        checksumHex: 'bb'.repeat(20),
      }),
      sourceFingerprint: makeFingerprint(),
      candidateFingerprint: makeFingerprint(),
      clipSimilarity: 0.95,
      groupThreshold: 0.9,
    });
    expect(score.score).toBeGreaterThan(0.95);
  });
});
