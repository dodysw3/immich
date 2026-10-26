import { execSync } from 'node:child_process';
import { existsSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { describe, expect, it } from 'vitest';
import {
  VIDEO_FACE_DEFAULT_CONFIG,
  assignIdentityKeys,
  configFingerprint,
  groupDetections,
  nextSampleByGap,
  planUniformSamples,
  shouldStopForSaturation,
  type GroupInput,
  type VideoFaceDetectionCore,
  type VideoFaceScanConfig,
} from 'src/utils/video-face.js';

// deterministic orthogonal-ish embedding builder: person p gets a base vector
// with a distinctive axis, noise is a fixed rotation per call index
function embFor(person: number, variant = 0): number[] {
  const v = new Array(64).fill(0);
  v[person % 64] = 1;
  v[(person * 7 + 13) % 64] += 0.05 * variant;
  const norm = Math.sqrt(v.reduce((s, x) => s + x * x, 0));
  return v.map((x) => x / norm);
}

function det(person: number, sizePx = 80, score = 0.9, variant = 0): VideoFaceDetectionCore {
  return {
    score,
    sizePx,
    x1: 0,
    y1: 0,
    x2: sizePx,
    y2: sizePx,
    imageWidth: 1440,
    imageHeight: 810,
    embedding: embFor(person, variant),
  };
}

const cfg = (overrides: Partial<VideoFaceScanConfig> = {}): VideoFaceScanConfig => ({
  ...VIDEO_FACE_DEFAULT_CONFIG,
  minGapMs: 1500,
  ...overrides,
});

describe('planUniformSamples', () => {
  it('spreads the budget across the whole timeline at midpoints', () => {
    const plan = planUniformSamples(20_000, 8);
    expect(plan.map((p) => p.timeMs)).toEqual([1250, 3750, 6250, 8750, 11250, 13750, 16250, 18750]);
  });

  it('caps the plan at one sample per second of video', () => {
    const plan = planUniformSamples(5000, 32);
    expect(plan).toHaveLength(5);
  });
});

describe('groupDetections', () => {
  it('one stranger in many frames is one identity (minFaces hazard guard)', () => {
    const frames: GroupInput[] = Array.from({ length: 8 }, (_, i) => ({
      timeMs: (i + 1) * 2000,
      detections: [det(3)],
    }));
    const identities = groupDetections(frames, cfg());
    expect(identities).toHaveLength(1);
    expect(identities[0].sightingCount).toBe(8);
    expect(identities[0].firstObservedMs).toBe(2000);
  });

  it('never merges two detections from the same frame', () => {
    // person 5 and person 6 engineered to be near-identical
    const v5: number[] = new Array(64).fill(0).map((_, i) => (i === 5 ? 1 : 0));
    const v6: number[] = v5.slice();
    v6[5] = 0.95;
    v6[21] = 0.31; // ~0.05 cosine distance after normalization
    const frames: GroupInput[] = [{ timeMs: 1000, detections: [{ ...det(5), embedding: v5 }, { ...det(6), embedding: v6 }] }];
    const identities = groupDetections(frames, cfg({ groupThreshold: 0.55 }));
    expect(identities).toHaveLength(2);
  });

  it('exemplar merge collapses fragments of the same person across frames', () => {
    // same person, embeddings drifting beyond the greedy threshold
    const a = embFor(1, 0);
    const b = embFor(1, 3);
    const frames: GroupInput[] = [
      { timeMs: 1000, detections: [{ ...det(1), embedding: a, sizePx: 100, score: 0.9 }] },
      { timeMs: 5000, detections: [{ ...det(1), embedding: b, sizePx: 95, score: 0.88 }] },
    ];
    const merged = groupDetections(frames, cfg({ groupThreshold: 0.55, exemplarMerge: true }));
    expect(merged).toHaveLength(1);
  });

  it('detection gates filter by score and face size', () => {
    const frames: GroupInput[] = [
      { timeMs: 1000, detections: [det(1, 10, 0.9), det(2, 80, 0.3), det(3, 80, 0.9)] },
    ];
    const identities = groupDetections(frames, cfg());
    expect(identities).toHaveLength(1);
  });

  it('flags single sightings below the stricter quality bar but keeps them', () => {
    const frames: GroupInput[] = [
      { timeMs: 1000, detections: [det(1, 30, 0.6), det(2, 90, 0.9)] },
    ];
    const identities = assignIdentityKeys(groupDetections(frames, cfg()));
    const flagged = identities.find((i) => i.flagged);
    expect(flagged).toBeDefined();
    expect(flagged?.sightingCount).toBe(1);
  });

  it('crowd guard keeps the best N identities', () => {
    const frames: GroupInput[] = Array.from({ length: 40 }, (_, i) => ({
      timeMs: (i + 1) * 2000,
      detections: [det(i, 50 + i, 0.9)],
    }));
    const identities = groupDetections(frames, cfg({ identitiesCap: 30 }));
    expect(identities).toHaveLength(30);
    expect(identities[0].bestSizePx).toBeGreaterThanOrEqual(identities[29].bestSizePx);
  });

  it('is deterministic — same input, same output keys and order', () => {
    const frames: GroupInput[] = [
      { timeMs: 4000, detections: [det(2)] },
      { timeMs: 1000, detections: [det(1)] },
      { timeMs: 9000, detections: [det(3), det(1)] },
    ];
    const run = () => assignIdentityKeys(groupDetections(frames, cfg())).map((i) => [i.identityKey, i.firstObservedMs]);
    expect(run()).toEqual(run());
    expect(run()[0]).toEqual(['v0', 1000]);
  });

  it('first observed is the minimum sighting time even from out-of-order frames', () => {
    const frames: GroupInput[] = [
      { timeMs: 12_000, detections: [det(1)] },
      { timeMs: 3000, detections: [det(1)] },
      { timeMs: 7000, detections: [det(1)] },
    ];
    const [identity] = groupDetections(frames, cfg());
    expect(identity.firstObservedMs).toBe(3000);
  });
});

describe('shouldStopForSaturation', () => {
  it('stops only after S consecutive empty samples AND all gaps below minGapMs', () => {
    const empty = (timeMs: number) => ({ timeMs, newIdentityKeys: [] });
    // 6 consecutive empty samples, but spacing is 3s > minGapMs 1.5s
    const wideGaps = [1000, 4000, 7000, 10_000, 13_000, 16_000, 19_000].map(empty);
    expect(shouldStopForSaturation(wideGaps, cfg())).toBe(false);

    const tightGaps = Array.from({ length: 7 }, (_, i) => empty((i + 1) * 1200));
    expect(shouldStopForSaturation(tightGaps, cfg())).toBe(true);
  });

  it('does not stop when the tail contains a new identity', () => {
    const history = Array.from({ length: 7 }, (_, i) => ({
      timeMs: (i + 1) * 1200,
      newIdentityKeys: i === 6 ? ['v9'] : [],
    }));
    expect(shouldStopForSaturation(history, cfg())).toBe(false);
  });
});

describe('nextSampleByGap', () => {
  it('prefers long gaps with differing signatures', () => {
    const state = {
      durationMs: 20_000,
      sampled: [
        { timeMs: 2000, identityKeys: new Set(['a']) },
        { timeMs: 4000, identityKeys: new Set(['a', 'b']) },
      ],
    };
    const next = nextSampleByGap(state, cfg());
    expect(next).not.toBeNull();
    // the widest eligible gap (4000..20000) wins: midpoint 12000
    expect(next?.timeMs).toBe(12_000);
    expect(next?.reason).toBe('gap');
  });

  it('returns null when every gap is below twice minGapMs', () => {
    const state = {
      durationMs: 6000,
      sampled: [
        { timeMs: 1500, identityKeys: new Set(['a']) },
        { timeMs: 3000, identityKeys: new Set(['a']) },
        { timeMs: 4500, identityKeys: new Set(['a']) },
      ],
    };
    expect(nextSampleByGap(state, cfg({ minGapMs: 1500 }))).toBeNull();
  });
});

describe('configFingerprint', () => {
  it('changes when any threshold changes', () => {
    const a = configFingerprint(cfg(), 'buffalo_l');
    const b = configFingerprint(cfg({ groupThreshold: 0.6 }), 'buffalo_l');
    expect(a).not.toEqual(b);
  });
});

// Bench parity: replays the owner-verified superset caches from
// ~/app/immich-app/video-face-bench through the pure core and asserts the
// verified outcomes. Skipped unless the bench directory exists (ops machines).
const BENCH = process.env.IMMICH_VIDEO_FACE_BENCH ?? '/home/cangka/app/immich-app/video-face-bench';
const PARITY_CASES = [
  { tag: '79962286', cache: 'cache', labels: 'out/identity-labels.csv', durMs: 12_466, people: 9 },
  { tag: '25acaceb', cache: 'cache-25acaceb', labels: 'out-25acaceb/identity-labels.csv', durMs: 22_988, people: 11 },
];

describe.skipIf(!existsSync(BENCH))('bench parity (owner-verified corpus)', () => {
  const loadCache = (cacheDir: string) => {
    const frames: { name: string; timeMs: number; detections: VideoFaceDetectionCore[] }[] = [];
    const index = new Map<string, number>();
    for (const line of readFileSync(join(cacheDir, 'index.tsv'), 'utf8').split('\n')) {
      if (!line) {
        continue;
      }
      const [name, , pts] = line.split('\t');
      if (name === 'preview') {
        index.set(name, -1);
      } else if (pts !== 'nan') {
        index.set(name, Math.round(Number(pts) * 1000));
      }
    }
    const files = execSync(`ls ${join(cacheDir, '*.json')}`, { shell: '/bin/bash' })
      .toString()
      .split('\n')
      .filter(Boolean);
    for (const file of files) {
      const name = file.split('/').pop()!.replace('.json', '');
      const timeMs = index.get(name);
      if (timeMs === undefined) {
        continue;
      }
      const json = JSON.parse(readFileSync(file, 'utf8'));
      const detections = (json['facial-recognition'] ?? []).map((face: any) => {
        const bb = face.boundingBox;
        return {
          score: face.score,
          sizePx: Math.min(bb.x2 - bb.x1, bb.y2 - bb.y1),
          x1: bb.x1,
          y1: bb.y1,
          x2: bb.x2,
          y2: bb.y2,
          imageWidth: json.imageWidth,
          imageHeight: json.imageHeight,
          embedding: JSON.parse(face.embedding),
        } satisfies VideoFaceDetectionCore;
      });
      frames.push({ name, timeMs, detections });
    }
    // bench 03-analyze order: preview first, then the rest chronologically
    return frames.sort((a, b) => (a.timeMs === -1 ? -1 : b.timeMs === -1 ? 1 : a.timeMs - b.timeMs));
  };

  // exact replica of the bench reference clustering (greedy centroid @0.45,
  // chronological, NO same-frame rule, no merge pass) so P-numbering matches
  // the owner-labeled identity-labels.csv rows
  const benchReference = (frames: ReturnType<typeof loadCache>) => {
    const clusters: { sum: number[]; count: number; members: { timeMs: number; det: VideoFaceDetectionCore }[] }[] = [];
    for (const frame of frames) {
      for (const det of frame.detections) {
        if (det.sizePx < 22 || det.score < 0.5) {
          continue;
        }
        const norm = Math.sqrt(det.embedding.reduce((s, v) => s + v * v, 0));
        const emb = det.embedding.map((v) => v / norm);
        let best: (typeof clusters)[number] | null = null;
        let bestD = Number.POSITIVE_INFINITY;
        for (const cluster of clusters) {
          const d = 1 - emb.reduce((s, v, i) => s + v * (cluster.sum[i] / cluster.count), 0);
          if (d < bestD) {
            bestD = d;
            best = cluster;
          }
        }
        if (best && bestD < 0.45) {
          best.sum = best.sum.map((v, i) => v + emb[i]);
          best.count += 1;
          best.members.push({ timeMs: frame.timeMs, det });
        } else {
          clusters.push({ sum: emb, count: 1, members: [{ timeMs: frame.timeMs, det }] });
        }
      }
    }
    return clusters;
  };

  const labelOf = (labelsCsv: string) => {
    const rows = readFileSync(labelsCsv, 'utf8').split('\n').slice(1).filter(Boolean);
    const map = new Map<number, string>();
    for (const row of rows) {
      const cols = row.split(',');
      const p = Number(cols[0].slice(1));
      map.set(p, cols[6]?.trim() ?? '');
    }
    return map;
  };

  const coverage = (
    identities: { bestEmbedding: number[] }[],
    reference: ReturnType<typeof benchReference>,
    labels: Map<number, string>,
  ) => {
    const found = new Set<string>();
    for (const identity of identities) {
      let bestD = Number.POSITIVE_INFINITY;
      let bestP = -1;
      reference.forEach((cluster, p) => {
        const d = 1 - identity.bestEmbedding.reduce((s, v, i) => s + v * (cluster.sum[i] / cluster.count), 0);
        if (d < bestD) {
          bestD = d;
          bestP = p;
        }
      });
      const label = labels.get(bestP) ?? '';
      if (label && label.toLowerCase() !== 'n/a') {
        found.add(label);
      }
    }
    return found;
  };

  const uniformPicked = (frames: ReturnType<typeof loadCache>, n: number, durMs: number) => {
    const plan = planUniformSamples(durMs, n).map((p) => p.timeMs);
    const grid = frames.filter((f) => f.timeMs > 0 && f.name.startsWith('g') && !f.name.endsWith('m') && !f.name.endsWith('p'));
    const picked: GroupInput[] = [];
    const used = new Set<string>();
    for (const t of plan) {
      let best: (typeof grid)[number] | undefined;
      for (const g of grid) {
        if (used.has(g.name)) {
          continue;
        }
        if (!best || Math.abs(g.timeMs - t) < Math.abs(best.timeMs - t)) {
          best = g;
        }
      }
      if (best) {
        used.add(best.name);
        picked.push({ timeMs: best.timeMs, detections: best.detections });
      }
    }
    return picked;
  };

  it.each(PARITY_CASES)('$tag: uniform16 + default config finds every person', (c) => {
    const frames = loadCache(join(BENCH, c.cache));
    const reference = benchReference(frames);
    const labels = labelOf(join(BENCH, c.labels));
    const truePeople = new Set([...labels.values()].filter((v) => v && v.toLowerCase() !== 'n/a'));
    expect(truePeople.size).toBe(c.people);

    const picked = uniformPicked(frames, 16, c.durMs);
    const identities = groupDetections(picked, cfg());
    const found = coverage(identities, reference, labels);
    expect([...truePeople].filter((p) => !found.has(p))).toEqual([]);
  });

  // The bench algorithm (no same-frame rule) false-merged Gwen+Mazel at
  // 0.6+merge on this video — that cliff is why the DEFAULT threshold stays
  // 0.55. The core's same-frame guard (greedy AND merge pass) makes 0.6+merge
  // safe; this test guards that safety property itself.
  it('25acaceb: same-frame guard keeps 0.6+merge recall-safe (bench cliff stays behind us)', () => {
    const c = PARITY_CASES[1];
    const frames = loadCache(join(BENCH, c.cache));
    const reference = benchReference(frames);
    const labels = labelOf(join(BENCH, c.labels));
    const picked = uniformPicked(frames, 16, c.durMs);
    const identities = groupDetections(picked, cfg({ groupThreshold: 0.6, exemplarMerge: true }));
    const found = coverage(identities, reference, labels);
    const missing = [...new Set([...labels.values()].filter((v) => v && v.toLowerCase() !== 'n/a'))].filter(
      (p) => !found.has(p),
    );
    expect(missing).toEqual([]);
  });
});
