import {
  AiInterpretationDocument,
  AiInterpretationInput,
  AiInterpretationMetrics,
  AiInterpretationRun,
  MuseInterpretationResult,
} from 'src/dtos/ai-image-interpretation.dto.js';
import {
  AiImageInterpretationRepository,
  AiInterpretationIdentity,
} from 'src/repositories/ai-image-interpretation.repository.js';
import { createAiInterpretationRunKey } from 'src/utils/ai-image-interpretation.js';
import { describe, expect, it, vi } from 'vitest';

const identity: AiInterpretationIdentity = {
  model: 'model-a',
  quant: 'quant-a',
  promptVersion: 'prompt-a',
};

const input: AiInterpretationInput = {
  source: 'preview',
  width: 100,
  height: 80,
  mimeType: 'image/jpeg',
};

const result: MuseInterpretationResult = {
  title: 'Test image',
  literal_description: 'A test image.',
  visual_analysis: 'The image is clear.',
  interpretation: 'It records a test case.',
  context_and_significance: 'It verifies the metadata contract.',
  notable_details: [],
  identifications: [],
  alternative_interpretations: [],
  uncertainties: [],
  archive_summary: 'A test image for repository coverage.',
  search_keywords: ['test'],
};

const metrics: AiInterpretationMetrics = { durationMs: 1000, promptTokens: 10, completionTokens: 20 };

const makeRepository = (document: AiInterpretationDocument | null = null) => {
  const db = {
    transaction: () => ({
      execute: (callback: (transaction: unknown) => Promise<unknown>) => Promise.resolve(callback(db)),
    }),
  };
  const repository = new AiImageInterpretationRepository(db as never);
  const internals = repository as never as {
    getLocked: ReturnType<typeof vi.fn>;
    lockFirstInsert: ReturnType<typeof vi.fn>;
    save: ReturnType<typeof vi.fn>;
  };
  let current = document;
  let lockTail = Promise.resolve();
  let activeRelease: (() => void) | undefined;
  internals.getLocked = vi.fn().mockImplementation(() => current);
  internals.lockFirstInsert = vi.fn().mockImplementation(async () => {
    const previousLock = lockTail;
    let release!: () => void;
    lockTail = new Promise<void>((resolve) => (release = resolve));
    await previousLock;
    activeRelease = release;
  });
  internals.save = vi.fn().mockImplementation((_transaction, _assetId, next: AiInterpretationDocument) => {
    current = next;
    activeRelease?.();
    activeRelease = undefined;
    return Promise.resolve();
  });
  Object.assign(repository, internals);
  return { repository, internals };
};

describe(AiImageInterpretationRepository.name, () => {
  it('claims one tuple and returns alreadyExists for a duplicate claim', async () => {
    const { repository, internals } = makeRepository();
    const [first, second] = await Promise.all([
      repository.claim('asset-1', identity, new Date('2026-09-11T00:00:00.000Z')),
      repository.claim('asset-1', identity, new Date('2026-09-11T00:01:00.000Z')),
    ]);

    expect([first, second].filter(({ alreadyExists }) => !alreadyExists)).toHaveLength(1);
    expect([first, second].filter(({ alreadyExists }) => alreadyExists)).toHaveLength(1);
    expect(first.runKey).toBe(createAiInterpretationRunKey(identity.model, identity.quant, identity.promptVersion));
    expect(second.runKey).toBe(first.runKey);
    expect(internals.lockFirstInsert).toHaveBeenCalledTimes(2);
    expect(internals.save).toHaveBeenCalledTimes(1);
  });

  it('appends different tuples and guards terminal transitions', async () => {
    const { repository } = makeRepository();
    const first = await repository.claim('asset-1', identity);
    const second = await repository.claim('asset-1', { ...identity, promptVersion: 'prompt-b' });

    expect(await repository.transitionToRunning('asset-1', first.runKey)).toBe(true);
    expect(await repository.complete('asset-1', first.runKey, input, result, metrics)).toBe(true);
    expect(await repository.complete('asset-1', first.runKey, input, result, metrics)).toBe(false);
    expect(await repository.fail('asset-1', first.runKey, { code: 'late', message: 'late failure' })).toBeNull();
    expect(await repository.fail('asset-1', second.runKey, { code: 'network_error', message: 'unavailable' })).toEqual(
      expect.objectContaining({ status: 'failed', attempts: 1 }),
    );
  });

  it('records attempts and schedules capped retries on failure', async () => {
    const { repository } = makeRepository();
    const first = await repository.claim('asset-1', identity, new Date('2026-09-11T00:00:00.000Z'));
    await repository.transitionToRunning('asset-1', first.runKey);

    const failed = await repository.fail(
      'asset-1',
      first.runKey,
      { code: 'timeout', message: 'timed out' },
      undefined,
      undefined,
      new Date('2026-09-11T00:10:00.000Z'),
    );
    expect(failed).toEqual(
      expect.objectContaining({
        status: 'failed',
        attempts: 1,
        nextAttemptAt: '2026-09-11T00:12:00.000Z',
        error: { code: 'timeout', message: 'timed out' },
      }),
    );

    expect(await repository.requeue('asset-1', first.runKey, new Date('2026-09-11T00:12:00.000Z'))).toBe(true);
    expect(await repository.transitionToRunning('asset-1', first.runKey)).toBe(true);
    const secondFailure = await repository.fail(
      'asset-1',
      first.runKey,
      { code: 'timeout', message: 'timed out again' },
      undefined,
      undefined,
      new Date('2026-09-11T00:12:30.000Z'),
    );
    expect(secondFailure).toEqual(
      expect.objectContaining({ status: 'failed', attempts: 2, nextAttemptAt: '2026-09-11T00:16:30.000Z' }),
    );
  });

  it('keeps queued and completed runs single-delivery on claim and requeue', async () => {
    const { repository } = makeRepository();
    const claim = await repository.claim('asset-1', identity, new Date('2026-09-11T00:00:00.000Z'));

    await expect(repository.claim('asset-1', identity, new Date('2026-09-11T00:01:00.000Z'))).resolves.toEqual(
      expect.objectContaining({ alreadyExists: true }),
    );
    expect(await repository.requeue('asset-1', claim.runKey)).toBe(false);

    await repository.transitionToRunning('asset-1', claim.runKey);
    await repository.complete('asset-1', claim.runKey, input, result, metrics);
    await expect(repository.claim('asset-1', identity, new Date('2026-09-11T01:00:00.000Z'))).resolves.toEqual(
      expect.objectContaining({ alreadyExists: true }),
    );
    expect(await repository.requeue('asset-1', claim.runKey)).toBe(false);
    expect(await repository.fail('asset-1', claim.runKey, { code: 'late', message: 'late failure' })).toBeNull();
  });

  it('requeues a failed run on claim with attempt history preserved', async () => {
    const { repository } = makeRepository();
    const claim = await repository.claim('asset-1', identity, new Date('2026-09-11T00:00:00.000Z'));
    await repository.transitionToRunning('asset-1', claim.runKey);
    const failed = await repository.fail(
      'asset-1',
      claim.runKey,
      { code: 'timeout', message: 'timed out' },
      undefined,
      undefined,
      new Date('2026-09-11T00:10:00.000Z'),
    );
    expect(failed).toEqual(expect.objectContaining({ status: 'failed', attempts: 1 }));

    const reclaimed = await repository.claim('asset-1', identity, new Date('2026-09-11T02:00:00.000Z'));
    expect(reclaimed).toEqual(
      expect.objectContaining({
        alreadyExists: false,
        runKey: claim.runKey,
        run: expect.objectContaining({
          status: 'queued',
          requestedAt: '2026-09-11T02:00:00.000Z',
          startedAt: undefined,
          nextAttemptAt: undefined,
          attempts: 1,
          error: { code: 'timeout', message: 'timed out' },
        }),
      }),
    );

    await repository.transitionToRunning('asset-1', claim.runKey);
    await repository.fail(
      'asset-1',
      claim.runKey,
      { code: 'timeout', message: 'timed out again' },
      undefined,
      undefined,
      new Date('2026-09-11T02:05:00.000Z'),
    );
    expect(await repository.requeue('asset-1', claim.runKey)).toBe(true);
    expect(await repository.requeue('asset-1', claim.runKey)).toBe(false);
  });

  it('finds only failed runs whose retry delay has elapsed', async () => {
    const runKey = createAiInterpretationRunKey(identity.model, identity.quant, identity.promptVersion);
    const run = (status: string, nextAttemptAt?: string) => ({
      model: identity.model,
      quant: identity.quant,
      promptVersion: identity.promptVersion,
      status,
      trigger: 'upload',
      requestedAt: '2026-09-11T00:00:00.000Z',
      error: status === 'failed' ? { code: 'timeout', message: 'timed out' } : undefined,
      nextAttemptAt,
    });
    const rows = [
      {
        assetId: 'asset-due',
        value: { schemaVersion: 1, runs: { [runKey]: run('failed', '2026-09-11T01:00:00.000Z') } },
      },
      {
        assetId: 'asset-future',
        value: { schemaVersion: 1, runs: { [runKey]: run('failed', '2026-09-11T03:00:00.000Z') } },
      },
      {
        assetId: 'asset-running',
        value: { schemaVersion: 1, runs: { [runKey]: run('running', '2026-09-11T01:00:00.000Z') } },
      },
    ];
    const db = {
      transaction: () => ({ execute: (callback: (transaction: unknown) => Promise<unknown>) => callback(db) }),
      selectFrom: vi.fn().mockReturnValue({
        select: vi.fn().mockReturnThis(),
        where: vi.fn().mockReturnThis(),
        execute: vi.fn().mockResolvedValue(rows),
      }),
    };
    const repository = new AiImageInterpretationRepository(db as never);

    await expect(repository.findDueRetries(new Date('2026-09-11T02:00:00.000Z'))).resolves.toEqual([
      { assetId: 'asset-due', runKey },
    ]);
  });

  it('fails stale running runs and orphaned queued runs, sparing queued runs with a live job', async () => {
    const runKey = createAiInterpretationRunKey(identity.model, identity.quant, identity.promptVersion);
    const run = (
      status: AiInterpretationRun['status'],
      overrides: Partial<AiInterpretationRun> = {},
    ): AiInterpretationRun => ({
      model: identity.model,
      quant: identity.quant,
      promptVersion: identity.promptVersion,
      status,
      trigger: 'upload',
      requestedAt: '2026-09-11T00:00:00.000Z',
      ...overrides,
    });
    const documents: Record<string, AiInterpretationDocument> = {
      'asset-stale-running': {
        schemaVersion: 1,
        runs: { [runKey]: run('running', { startedAt: '2026-09-11T00:05:00.000Z' }) },
      },
      'asset-live-queued': { schemaVersion: 1, runs: { [runKey]: run('queued') } },
      'asset-orphaned-queued': { schemaVersion: 1, runs: { [runKey]: run('queued') } },
      'asset-fresh-running': {
        schemaVersion: 1,
        runs: { [runKey]: run('running', { startedAt: '2026-09-11T02:01:00.000Z' }) },
      },
    };
    const rows = Object.entries(documents).map(([assetId, value]) => ({ assetId, value }));
    const db = {
      transaction: () => ({ execute: (callback: (transaction: unknown) => Promise<unknown>) => callback(db) }),
      selectFrom: vi.fn().mockReturnValue({
        select: vi.fn().mockReturnThis(),
        where: vi.fn().mockReturnThis(),
        execute: vi.fn().mockResolvedValue(rows),
      }),
    };
    const repository = new AiImageInterpretationRepository(db as never);
    const internals = repository as never as { getLocked: ReturnType<typeof vi.fn>; save: ReturnType<typeof vi.fn> };
    internals.getLocked = vi
      .fn()
      .mockImplementation((_transaction: unknown, assetId: string) => documents[assetId] ?? null);
    internals.save = vi
      .fn()
      .mockImplementation((_transaction: unknown, assetId: string, document: AiInterpretationDocument) => {
        documents[assetId] = document;
      });
    const hasPendingJob = vi.fn().mockImplementation((assetId: string) => assetId !== 'asset-orphaned-queued');

    const failed = await repository.failStale(
      new Date('2026-09-11T02:00:00.000Z'),
      hasPendingJob,
      new Date('2026-09-11T02:05:00.000Z'),
    );

    expect(failed).toBe(2);
    expect(hasPendingJob).toHaveBeenCalledTimes(2);
    expect(hasPendingJob).toHaveBeenCalledWith('asset-live-queued', runKey);
    expect(hasPendingJob).toHaveBeenCalledWith('asset-orphaned-queued', runKey);
    expect(documents['asset-stale-running']?.runs[runKey]).toMatchObject({
      status: 'failed',
      attempts: 1,
      error: { code: 'stale_run' },
    });
    expect(documents['asset-orphaned-queued']?.runs[runKey]).toMatchObject({
      status: 'failed',
      attempts: 1,
      nextAttemptAt: '2026-09-11T02:07:00.000Z',
      error: { code: 'job_lost' },
    });
    expect(documents['asset-live-queued']?.runs[runKey]).toMatchObject({ status: 'queued' });
    expect(documents['asset-fresh-running']?.runs[runKey]).toMatchObject({ status: 'running' });
  });

  it('rejects malformed stored documents before a claim can proceed', () => {
    const { repository } = makeRepository();
    expect(() => (repository as never as { parseDocument: (value: unknown) => unknown }).parseDocument({})).toThrow();
  });
});
