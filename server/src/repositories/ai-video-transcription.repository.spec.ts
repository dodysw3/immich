import { describe, expect, it, vi } from 'vitest';
import {
  AiVideoTranscriptionDocument,
  AiVideoTranscriptionDocumentSchema,
} from 'src/dtos/ai-video-transcription.dto.js';
import { AiVideoTranscriptionRepository } from 'src/repositories/ai-video-transcription.repository.js';
import {
  AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
  AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
  createVideoTranscriptionRunKey,
} from 'src/utils/ai-video-transcription.js';

const producerIdentity = {
  model: 'faster-whisper-large-v3',
  producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
  language: '',
  coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
};

const runKey = createVideoTranscriptionRunKey(producerIdentity);

const legacyRun = {
  model: 'faster-whisper-large-v3',
  promptVersion: 'video-transcription-0.2.0',
  status: 'completed' as const,
  trigger: 'auto-interpret' as const,
  requestedAt: '2026-10-20T00:00:00.000Z',
  finishedAt: '2026-10-20T00:01:00.000Z',
  config: { language: '' },
  durationMs: 60_000,
  segments: [{ startMs: 0, endMs: 4000, text: 'hello world' }],
};

const legacyKey = 'a'.repeat(64);

const legacyDocument: AiVideoTranscriptionDocument = { schemaVersion: 1, runs: { [legacyKey]: legacyRun } };

const makeRepository = (initial: AiVideoTranscriptionDocument | null = null) => {
  let current: AiVideoTranscriptionDocument | null = initial;
  const db = {
    transaction: () => ({
      execute: (callback: (transaction: unknown) => Promise<unknown>) => Promise.resolve(callback(db)),
    }),
    // Serves get(): same select chain shape the real repository builds.
    selectFrom: () => ({
      select: () => ({
        where: () => ({
          where: () => ({
            executeTakeFirst: () => Promise.resolve(current === null ? undefined : { value: current }),
          }),
        }),
      }),
    }),
  };
  const repository = new AiVideoTranscriptionRepository(db as never);
  const internals = repository as never as {
    getLocked: ReturnType<typeof vi.fn>;
    lockFirstInsert: ReturnType<typeof vi.fn>;
    save: ReturnType<typeof vi.fn>;
  };
  const saved: AiVideoTranscriptionDocument[] = [];
  internals.getLocked = vi.fn(() => current);
  internals.lockFirstInsert = vi.fn(() => Promise.resolve());
  internals.save = vi.fn((_transaction: unknown, _assetId: string, next: AiVideoTranscriptionDocument) => {
    current = next;
    saved.push(next);
    return Promise.resolve();
  });
  Object.assign(repository, internals);
  return { repository, internals, saved, getCurrent: () => current };
};

const claimIdentity = {
  runKey,
  model: producerIdentity.model,
  promptVersion: 'video-transcription-0.2.0',
  config: { language: '' },
  durationMs: 10_000,
  trigger: 'manual' as const,
  producer: {
    service: 'faster-whisper-sidecar',
    model: producerIdentity.model,
    producerVersion: producerIdentity.producerVersion,
    language: producerIdentity.language,
    coveragePolicy: producerIdentity.coveragePolicy,
  },
  targetDurationMs: 10_000,
  chunks: [
    { index: 0, startMs: 0, endMs: 5000, status: 'pending' as const },
    { index: 1, startMs: 4000, endMs: 10_000, status: 'pending' as const },
  ],
};

const lease = { ownerId: 'worker-1', leaseMs: 60_000 };
const at = (iso: string) => new Date(iso);

describe(AiVideoTranscriptionRepository.name, () => {
  it('claims a run stamped with producer identity, target duration, chunk plan and lease', async () => {
    const { repository, saved } = makeRepository();
    const claim = await repository.claim('asset-1', claimIdentity, lease, at('2026-11-11T00:00:00.000Z'));
    expect(claim.alreadyExists).toBe(false);
    if (claim.alreadyExists) {
      return;
    }
    const { run } = claim;

    expect(run.status).toBe('running');
    expect(run.startedAt).toBe('2026-11-11T00:00:00.000Z');
    expect(run.lease).toEqual({ ownerId: 'worker-1', expiresAt: '2026-11-11T00:01:00.000Z' });
    expect(run.producer).toEqual(claimIdentity.producer);
    expect(run.targetDurationMs).toBe(10_000);
    expect(run.chunks).toEqual(claimIdentity.chunks);
    expect(claim.resumedChunks).toBe(0);
    // Storage stays valid under the current document schema after the write.
    expect(AiVideoTranscriptionDocumentSchema.parse(saved[0])).toEqual(saved[0]);
    expect(saved[0].schemaVersion).toBe(2);
  });

  it('excludes a concurrent claim while the lease is live', async () => {
    const { repository } = makeRepository();
    await repository.claim('asset-1', claimIdentity, lease, at('2026-11-11T00:00:00.000Z'));

    const second = await repository.claim(
      'asset-1',
      { ...claimIdentity, trigger: 'auto-interpret' as const },
      { ownerId: 'worker-2', leaseMs: 60_000 },
      at('2026-11-11T00:00:30.000Z'),
    );
    if (!second.alreadyExists) {
      throw new Error('second claim should have been refused');
    }
    expect(second.reason).toBe('active-lease');
    expect(second.run.lease?.ownerId).toBe('worker-1');
  });

  it('reclaims an interrupted run after lease expiry without losing completed chunks', async () => {
    const { repository, getCurrent } = makeRepository();
    await repository.claim('asset-1', claimIdentity, lease, at('2026-11-11T00:00:00.000Z'));
    await repository.completeChunk('asset-1', runKey, 0, [{ startMs: 0, endMs: 4000, text: 'satu' }], {
      startMs: 0,
      endMs: 5000,
    });

    // Worker-1 died; worker-2 arrives after the lease expired.
    const reclaim = await repository.claim(
      'asset-1',
      { ...claimIdentity, trigger: 'auto-interpret' as const },
      { ownerId: 'worker-2', leaseMs: 60_000 },
      at('2026-11-11T00:02:00.000Z'),
    );
    expect(reclaim.alreadyExists).toBe(false);
    if (!reclaim.alreadyExists) {
      expect(reclaim.resumedChunks).toBe(1);
      expect(reclaim.run.lease?.ownerId).toBe('worker-2');
    }
    const run = getCurrent()!.runs[runKey];
    expect(run.status).toBe('running');
    expect(run.segments).toEqual([{ startMs: 0, endMs: 4000, text: 'satu' }]);
    expect(run.coverage).toEqual({ intervals: [{ startMs: 0, endMs: 5000 }] });
    expect(run.chunks![0].status).toBe('completed');
    // The original requestedAt survives the reclaim.
    expect(run.requestedAt).toBe('2026-11-11T00:00:00.000Z');
  });

  it('reclaims a failed run as a retry', async () => {
    const { repository, getCurrent } = makeRepository();
    await repository.claim('asset-1', claimIdentity, lease, at('2026-11-11T00:00:00.000Z'));
    await repository.fail('asset-1', runKey, { code: 'timeout', message: 'sidecar unavailable' });
    expect(getCurrent()!.runs[runKey].status).toBe('failed');

    const retry = await repository.claim(
      'asset-1',
      claimIdentity,
      { ownerId: 'worker-2', leaseMs: 60_000 },
      at('2026-11-11T00:05:00.000Z'),
    );
    expect(retry.alreadyExists).toBe(false);
    const run = getCurrent()!.runs[runKey];
    expect(run.status).toBe('running');
    expect(run.error).toBeUndefined();
    expect(run.lease?.ownerId).toBe('worker-2');
  });

  it('never resets valid completed work', async () => {
    const { repository, getCurrent } = makeRepository();
    await repository.claim('asset-1', claimIdentity, lease, at('2026-11-11T00:00:00.000Z'));
    await repository.appendSegments('asset-1', runKey, [{ startMs: 0, endMs: 4000, text: 'satu' }]);
    await repository.complete('asset-1', runKey, { coverage: { intervals: [{ startMs: 0, endMs: 10_000 }] } });
    const completed = getCurrent()!.runs[runKey];
    expect(completed.status).toBe('completed');
    expect(completed.lease).toBeUndefined();

    // A later delivery with any identity must not disturb the completed run.
    const refused = await repository.claim(
      'asset-1',
      claimIdentity,
      { ownerId: 'worker-2', leaseMs: 60_000 },
      at('2026-11-11T00:30:00.000Z'),
    );
    expect(refused.alreadyExists).toBe(true);
    if (refused.alreadyExists) {
      expect(refused.reason).toBe('completed');
      expect(refused.run).toEqual(completed);
    }
    expect(getCurrent()!.runs[runKey]).toEqual(completed);
  });

  it('renews the lease only for the running owner', async () => {
    const { repository, getCurrent } = makeRepository();
    await repository.claim('asset-1', claimIdentity, lease, at('2026-11-11T00:00:00.000Z'));

    expect(await repository.renewLease('asset-1', runKey, 'worker-2', 60_000, at('2026-11-11T00:00:10.000Z'))).toBe(
      false,
    );
    expect(await repository.renewLease('asset-1', runKey, 'worker-1', 60_000, at('2026-11-11T00:00:10.000Z'))).toBe(
      true,
    );
    expect(getCurrent()!.runs[runKey].lease).toEqual({
      ownerId: 'worker-1',
      expiresAt: '2026-11-11T00:01:10.000Z',
    });

    await repository.complete('asset-1', runKey, {});
    expect(await repository.renewLease('asset-1', runKey, 'worker-1', 60_000)).toBe(false);
  });

  it('accepts and upgrades a legacy schemaVersion 1 document on the next write', async () => {
    const { repository, saved } = makeRepository(legacyDocument);
    const document = await repository.get('asset-1');
    expect(document?.schemaVersion).toBe(1);
    expect(document?.runs[legacyKey].segments).toEqual(legacyRun.segments);

    await repository.claim('asset-1', claimIdentity, lease, at('2026-11-11T00:00:00.000Z'));
    expect(saved[0].schemaVersion).toBe(2);
    // The legacy run survives untouched alongside the new chunked run.
    expect(saved[0].runs[legacyKey]).toEqual(legacyRun);
    expect(saved[0].runs[runKey].chunks).toEqual(claimIdentity.chunks);
    expect(AiVideoTranscriptionDocumentSchema.parse(saved[0])).toEqual(saved[0]);
  });

  it('stamps a content revision on completion and keeps completed runs immutable', async () => {
    const { repository, saved, getCurrent } = makeRepository();
    await repository.claim('asset-1', claimIdentity, lease, at('2026-11-11T00:00:00.000Z'));
    await repository.appendSegments('asset-1', runKey, [{ startMs: 0, endMs: 4000, text: 'hello world' }]);
    await repository.complete('asset-1', runKey, {
      coverage: { intervals: [{ startMs: 0, endMs: 10_000 }] },
    });

    const completed = getCurrent()!.runs[runKey];
    expect(completed.status).toBe('completed');
    expect(completed.revision).toMatch(/^[a-f0-9]{64}$/);
    expect(completed.lease).toBeUndefined();
    expect(AiVideoTranscriptionDocumentSchema.parse(saved.at(-1)!)).toEqual(saved.at(-1));

    // A later delivery cannot re-run a completed run under the same key, so
    // its revision never changes in place; replacements arrive under a new
    // producer identity (new runKey) — see the util spec for revision
    // sensitivity to content changes.
    await repository.claim('asset-1', claimIdentity, lease);
    await repository.appendSegments('asset-1', runKey, [{ startMs: 0, endMs: 4000, text: 'changed text' }]);
    expect(getCurrent()!.runs[runKey]).toEqual(completed);
  });

  it('persists chunk progress: completed chunks keep segments and coverage, failures stay retryable', async () => {
    const { repository, getCurrent } = makeRepository();
    await repository.claim('asset-1', claimIdentity, lease, at('2026-11-11T00:00:00.000Z'));

    await repository.completeChunk('asset-1', runKey, 0, [{ startMs: 0, endMs: 4000, text: 'satu dua' }], {
      startMs: 0,
      endMs: 5000,
    });
    let run = getCurrent()!.runs[runKey];
    expect(run.chunks![0].status).toBe('completed');
    expect(run.chunks![0].completedAt).toBeDefined();
    expect(run.segments).toEqual([{ startMs: 0, endMs: 4000, text: 'satu dua' }]);
    expect(run.coverage).toEqual({ intervals: [{ startMs: 0, endMs: 5000 }] });

    await repository.failChunk('asset-1', runKey, 1, { code: 'timeout', message: 'sidecar unavailable' });
    run = getCurrent()!.runs[runKey];
    expect(run.chunks![1].status).toBe('failed');
    expect(run.chunks![1].error).toEqual({ code: 'timeout', message: 'sidecar unavailable' });
    expect(run.status).toBe('running');

    // Retry the failed chunk: completion replaces the error and grows coverage.
    await repository.completeChunk('asset-1', runKey, 1, [{ startMs: 6000, endMs: 9000, text: 'tiga' }], {
      startMs: 4000,
      endMs: 10_000,
    });
    await repository.complete('asset-1', runKey, {});
    run = getCurrent()!.runs[runKey];
    expect(run.chunks!.map(({ status }) => status)).toEqual(['completed', 'completed']);
    expect(run.coverage!.intervals).toEqual([
      { startMs: 0, endMs: 5000 },
      { startMs: 4000, endMs: 10_000 },
    ]);
    expect(run.revision).toBeDefined();
  });

  it('parses stored legacy documents through the schema on read', async () => {
    const { repository } = makeRepository(legacyDocument);
    const document = await repository.get('asset-1');
    expect(document).toEqual(legacyDocument);
    expect(document!.runs[legacyKey].producer).toBeUndefined();
  });
});
