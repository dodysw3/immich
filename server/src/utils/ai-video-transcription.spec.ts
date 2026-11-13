import { describe, expect, it } from 'vitest';
import {
  AiVideoTranscriptionChunkSchema,
  AiVideoTranscriptionDocument,
  AiVideoTranscriptionDocumentSchema,
  AiVideoTranscriptionRun,
} from 'src/dtos/ai-video-transcription.dto.js';
import {
  AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
  AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
  assessLegacyTranscriptionRun,
  buildTranscriptionChunkPlan,
  classifyTranscriptionRun,
  coversTranscriptionCoverage,
  createTranscriptionRevision,
  createVideoTranscriptionRunKey,
  isRunActive,
  isTranscriptionSegmentAudible,
  mergeCoverageIntervals,
} from 'src/utils/ai-video-transcription.js';

const segment = (startMs: number, endMs: number, text: string) => ({ startMs, endMs, text });

const producerIdentity = {
  model: 'faster-whisper-large-v3',
  producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
  language: '',
  coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
};

const legacyRun: AiVideoTranscriptionRun = {
  model: 'faster-whisper-large-v3',
  promptVersion: 'video-transcription-0.2.0',
  status: 'completed',
  trigger: 'auto-interpret',
  requestedAt: '2026-10-20T00:00:00.000Z',
  startedAt: '2026-10-20T00:00:01.000Z',
  finishedAt: '2026-10-20T00:01:00.000Z',
  config: { language: '' },
  durationMs: 60_000,
  segments: [segment(0, 4000, 'hello world'), segment(4500, 9000, 'second line')],
};

describe('ai-video-transcription utils', () => {
  describe('createVideoTranscriptionRunKey', () => {
    it('derives a stable 64-hex key from the full producer identity', () => {
      const base = createVideoTranscriptionRunKey(producerIdentity);
      expect(base).toMatch(/^[a-f0-9]{64}$/);
      // Any producer/config change is a different run: raised limits, language
      // changes, or producer updates must not be skipped by an older key.
      for (const changed of [
        { ...producerIdentity, model: 'faster-whisper-medium' },
        { ...producerIdentity, producerVersion: 'video-transcription-producer-2.0.0' },
        { ...producerIdentity, language: 'id' },
        { ...producerIdentity, coveragePolicy: 'whole-file-v0' },
      ]) {
        expect(createVideoTranscriptionRunKey(changed)).not.toBe(base);
      }
      expect(createVideoTranscriptionRunKey(producerIdentity)).toBe(base);
    });
  });

  describe('createTranscriptionRevision', () => {
    it('revisions content by segments and outcome flags, not identity', () => {
      expect(createTranscriptionRevision(legacyRun)).toMatch(/^[a-f0-9]{64}$/);
      expect(createTranscriptionRevision({ ...legacyRun })).toBe(createTranscriptionRevision(legacyRun));
      expect(createTranscriptionRevision({ ...legacyRun, segments: [segment(0, 4000, 'changed world')] })).not.toBe(
        createTranscriptionRevision(legacyRun),
      );
      expect(createTranscriptionRevision({ ...legacyRun, noSpeech: true })).not.toBe(
        createTranscriptionRevision(legacyRun),
      );
    });
  });

  describe('coverage', () => {
    it('merges overlapping and adjacent intervals', () => {
      expect(
        mergeCoverageIntervals([
          { startMs: 4000, endMs: 10_000 },
          { startMs: 0, endMs: 4000 },
          { startMs: 20_000, endMs: 25_000 },
        ]),
      ).toEqual([
        { startMs: 0, endMs: 10_000 },
        { startMs: 20_000, endMs: 25_000 },
      ]);
    });

    it('requires the union to span the target duration within tolerance', () => {
      const target = 10_000;
      expect(coversTranscriptionCoverage([{ startMs: 0, endMs: target }], target)).toBe(true);
      expect(
        coversTranscriptionCoverage(
          [
            { startMs: 0, endMs: 5000 },
            { startMs: 4000, endMs: target },
          ],
          target,
        ),
      ).toBe(true);
      // 200ms boundary gap is inside the 1s tolerance.
      expect(
        coversTranscriptionCoverage(
          [
            { startMs: 0, endMs: 4900 },
            { startMs: 5100, endMs: target },
          ],
          target,
        ),
      ).toBe(true);
      expect(
        coversTranscriptionCoverage(
          [
            { startMs: 0, endMs: 4000 },
            { startMs: 6000, endMs: target },
          ],
          target,
        ),
      ).toBe(false);
      // 9s of 10 is inside the 1s end tolerance; 8s is not.
      expect(coversTranscriptionCoverage([{ startMs: 0, endMs: 9000 }], target)).toBe(true);
      expect(coversTranscriptionCoverage([{ startMs: 0, endMs: 8000 }], target)).toBe(false);
      expect(coversTranscriptionCoverage([{ startMs: 0, endMs: target }], 0)).toBe(false);
    });
  });

  describe('buildTranscriptionChunkPlan', () => {
    it('builds contiguous non-overlapping responsibility ranges with a bounded tail', () => {
      const chunks = buildTranscriptionChunkPlan(7_300_000, 300);
      expect(chunks).toHaveLength(25);
      expect(chunks[0]).toMatchObject({ index: 0, startMs: 0, endMs: 300_000, status: 'pending' });
      expect(chunks[1]).toMatchObject({ index: 1, startMs: 300_000, endMs: 600_000 });
      expect(chunks.at(-1)).toMatchObject({ index: 24, startMs: 7_200_000, endMs: 7_300_000 });
      for (let i = 1; i < chunks.length; i++) {
        expect(chunks[i].startMs).toBe(chunks[i - 1].endMs);
      }
    });

    it('produces a single chunk for short videos and rejects invalid durations', () => {
      expect(buildTranscriptionChunkPlan(120_000, 300)).toEqual([
        { index: 0, startMs: 0, endMs: 120_000, status: 'pending' },
      ]);
      expect(() => buildTranscriptionChunkPlan(0, 300)).toThrow();
      expect(() => buildTranscriptionChunkPlan(-1, 300)).toThrow();
    });
  });

  describe('classifyTranscriptionRun', () => {
    it('classifies full, partial, no-audio, no-speech and in-flight outcomes', () => {
      const chunked: AiVideoTranscriptionRun = {
        ...legacyRun,
        producer: {
          service: 'faster-whisper-sidecar',
          model: 'faster-whisper-large-v3',
          producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
          language: '',
          coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
        },
        targetDurationMs: 10_000,
        chunks: [
          { index: 0, startMs: 0, endMs: 5000, status: 'completed', completedAt: '2026-11-11T00:00:00.000Z' },
          { index: 1, startMs: 4000, endMs: 10_000, status: 'completed', completedAt: '2026-11-11T00:01:00.000Z' },
        ],
        coverage: {
          intervals: [
            { startMs: 0, endMs: 5000 },
            { startMs: 4000, endMs: 10_000 },
          ],
        },
      };
      expect(classifyTranscriptionRun(chunked)).toBe('complete');
      expect(classifyTranscriptionRun({ ...chunked, coverage: { intervals: [{ startMs: 0, endMs: 5000 }] } })).toBe(
        'partial',
      );
      expect(classifyTranscriptionRun({ ...chunked, truncated: true })).toBe('partial');
      expect(classifyTranscriptionRun({ ...legacyRun, noAudio: true, segments: [] })).toBe('no-audio');
      expect(classifyTranscriptionRun({ ...legacyRun, noSpeech: true, segments: [] })).toBe('no-speech');
      expect(
        classifyTranscriptionRun({
          ...legacyRun,
          status: 'running',
          startedAt: '2026-11-11T00:00:00.000Z',
          chunks: [{ index: 0, startMs: 0, endMs: 300_000, status: 'pending' }],
        }),
      ).toBe('running');
      expect(classifyTranscriptionRun({ ...legacyRun, status: 'queued' })).toBe('queued');
      expect(
        classifyTranscriptionRun({ ...legacyRun, status: 'failed', error: { code: 'timeout', message: 'boom' } }),
      ).toBe('failed');
      expect(classifyTranscriptionRun(undefined)).toBe('missing');
    });

    it('keeps legacy completed runs partial — usable, but not proven full-duration coverage', () => {
      // A 10-minute video fully transcribed under the old whole-file producer
      // has no coverage evidence on the document; classification stays honest
      // and legacy trust rules (scheduling) decide separately.
      expect(classifyTranscriptionRun(legacyRun)).toBe('partial');
    });
  });

  describe('document parsing', () => {
    it('accepts legacy schemaVersion 1 documents unchanged', () => {
      const document: AiVideoTranscriptionDocument = {
        schemaVersion: 1,
        runs: {
          [createVideoTranscriptionRunKey({
            ...producerIdentity,
            producerVersion: 'legacy',
            coveragePolicy: 'legacy',
          })]: legacyRun,
        },
      };
      expect(AiVideoTranscriptionDocumentSchema.parse(document)).toEqual(document);
    });

    it('accepts chunked documents with producer, coverage, chunks and revision', () => {
      const run: AiVideoTranscriptionRun = {
        ...legacyRun,
        producer: {
          service: 'faster-whisper-sidecar',
          model: 'faster-whisper-large-v3',
          producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
          language: '',
          coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
        },
        targetDurationMs: 10_000,
        chunks: [
          { index: 0, startMs: 0, endMs: 5000, status: 'completed', completedAt: '2026-11-11T00:00:00.000Z' },
          { index: 1, startMs: 4000, endMs: 10_000, status: 'failed', error: { code: 'timeout', message: 'x' } },
        ],
        coverage: { intervals: [{ startMs: 0, endMs: 5000 }] },
        revision: createTranscriptionRevision(legacyRun),
      };
      const document: AiVideoTranscriptionDocument = {
        schemaVersion: 2,
        runs: { [createVideoTranscriptionRunKey(producerIdentity)]: run },
      };
      expect(AiVideoTranscriptionDocumentSchema.parse(document)).toEqual(document);
      expect(AiVideoTranscriptionChunkSchema.parse(run.chunks![1])).toEqual(run.chunks![1]);
    });

    it('rejects unknown schema versions and malformed revisions', () => {
      expect(() => AiVideoTranscriptionDocumentSchema.parse({ schemaVersion: 3, runs: {} })).toThrow();
      expect(() =>
        AiVideoTranscriptionDocumentSchema.parse({
          schemaVersion: 2,
          runs: { [createVideoTranscriptionRunKey(producerIdentity)]: { ...legacyRun, revision: 'not-a-hash' } },
        }),
      ).toThrow();
    });
  });

  describe('isTranscriptionSegmentAudible', () => {
    it('should keep confident speech segments', () => {
      expect(isTranscriptionSegmentAudible({ noSpeechProb: 0.1, avgLogProb: -0.5 })).toBe(true);
    });

    it('should drop low-speech-probability and low-confidence segments (the noise hallucination guard)', () => {
      expect(isTranscriptionSegmentAudible({ noSpeechProb: 0.9, avgLogProb: -1.5 })).toBe(false);
    });

    it('should keep borderline segments that fail only one of the two thresholds', () => {
      // confident log-prob even with elevated no-speech probability
      expect(isTranscriptionSegmentAudible({ noSpeechProb: 0.9, avgLogProb: -0.5 })).toBe(true);
      // low confidence but speech likely present
      expect(isTranscriptionSegmentAudible({ noSpeechProb: 0.1, avgLogProb: -1.5 })).toBe(true);
    });

    it('should treat missing metadata as audible (never silently drop segments)', () => {
      expect(isTranscriptionSegmentAudible({})).toBe(true);
    });
  });

  describe('isRunActive', () => {
    const base: AiVideoTranscriptionRun = { ...legacyRun, status: 'running' };
    const now = new Date('2026-11-11T00:10:00.000Z');

    it('treats completed and queued runs as active work', () => {
      expect(isRunActive({ ...base, status: 'completed' }, now)).toBe(true);
      expect(isRunActive({ ...base, status: 'queued' }, now)).toBe(true);
    });

    it('treats a leased running run as active only while the lease is live', () => {
      expect(isRunActive({ ...base, lease: { ownerId: 'w1', expiresAt: '2026-11-11T00:11:00.000Z' } }, now)).toBe(true);
      expect(isRunActive({ ...base, lease: { ownerId: 'w1', expiresAt: '2026-11-11T00:09:00.000Z' } }, now)).toBe(
        false,
      );
    });

    it('treats a running run without a lease as abandoned (reclaimable)', () => {
      expect(isRunActive(base, now)).toBe(false);
      expect(isRunActive({ ...base, status: 'failed', error: { code: 'timeout', message: 'x' } }, now)).toBe(false);
    });
  });

  describe('assessLegacyTranscriptionRun', () => {
    it('reuses trustworthy full coverage and verified no-speech outcomes', () => {
      // The legacy truncated flag was evaluated per-run with the cap in
      // effect, so a completed run without it covered the whole video.
      expect(assessLegacyTranscriptionRun(legacyRun)).toEqual({ verdict: 'reuse', reason: 'full-coverage' });
      expect(assessLegacyTranscriptionRun({ ...legacyRun, noSpeech: true, segments: [] })).toEqual({
        verdict: 'reuse',
        reason: 'no-speech',
      });
    });

    it('schedules truncated runs for missing full-duration coverage', () => {
      expect(assessLegacyTranscriptionRun({ ...legacyRun, truncated: true })).toEqual({
        verdict: 'schedule',
        reason: 'truncated',
      });
    });

    it('schedules legacy no-audio outcomes for cheap probe re-verification', () => {
      // The legacy producer also recorded extraction failures as no-audio, so
      // this is never trusted as terminal without a probe.
      expect(assessLegacyTranscriptionRun({ ...legacyRun, noAudio: true, segments: [] })).toEqual({
        verdict: 'schedule',
        reason: 'unverified-no-audio',
      });
    });

    it('schedules non-completed legacy runs as missing coverage', () => {
      expect(
        assessLegacyTranscriptionRun({ ...legacyRun, status: 'failed', error: { code: 'timeout', message: 'x' } }),
      ).toEqual({ verdict: 'schedule', reason: 'missing-coverage' });
    });
  });
});
