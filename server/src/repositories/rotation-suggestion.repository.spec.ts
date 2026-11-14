import { describe, expect, it, vi } from 'vitest';
import { RotationSuggestionDocument, RotationSuggestionRun } from 'src/dtos/rotation-suggestion.dto.js';
import { RotationSuggestionRepository } from 'src/repositories/rotation-suggestion.repository.js';
import { createRotationSuggestionRunKey } from 'src/utils/rotation-suggestion.js';

const makeRun = (overrides: Partial<RotationSuggestionRun> = {}): RotationSuggestionRun => ({
  model: 'rightwayup',
  tier: 'fast',
  predictedRotation: 90,
  confidence: 0.93,
  abstain: false,
  status: 'pending',
  startedAt: '2026-11-14T00:00:00.000Z',
  finishedAt: '2026-11-14T00:00:00.050Z',
  ...overrides,
});

const makeRepository = () => {
  const db = {
    transaction: () => ({
      execute: (callback: (transaction: unknown) => Promise<unknown>) => Promise.resolve(callback(db)),
    }),
  };
  const repository = new RotationSuggestionRepository(db as never);
  const internals = repository as never as {
    get: ReturnType<typeof vi.fn>;
    getLocked: ReturnType<typeof vi.fn>;
    lockFirstInsert: ReturnType<typeof vi.fn>;
    save: ReturnType<typeof vi.fn>;
  };
  let current: RotationSuggestionDocument | null = null;
  let lockTail = Promise.resolve();
  let activeRelease: (() => void) | undefined;
  internals.get = vi.fn().mockImplementation(async (assetId: string) => (assetId === 'asset-1' ? current : null));
  internals.getLocked = vi.fn().mockImplementation(() => current);
  internals.lockFirstInsert = vi.fn().mockImplementation(async () => {
    const previousLock = lockTail;
    let release!: () => void;
    lockTail = new Promise<void>((resolve) => (release = resolve));
    await previousLock;
    activeRelease = release;
  });
  internals.save = vi.fn().mockImplementation((_transaction, _assetId, next: RotationSuggestionDocument) => {
    current = next;
    activeRelease?.();
    activeRelease = undefined;
    return Promise.resolve();
  });
  Object.assign(repository, internals);
  return { repository, internals };
};

describe(RotationSuggestionRepository.name, () => {
  const runKey = createRotationSuggestionRunKey('rightwayup', 'fast', 'orientation-1.0.0');

  it('records a run and preserves user decisions on same-identity re-runs', async () => {
    const { repository, internals } = makeRepository();
    const first = await repository.recordRun('asset-1', runKey, makeRun());
    expect(first.preserved).toBe(false);
    expect(first.run.status).toBe('pending');

    // A dismissed verdict must not be resurrected by a re-run with the same
    // identity: only a new runKey (model/tier/pipeline change) re-suggests.
    await repository.setStatus('asset-1', runKey, 'dismissed');
    const rerun = await repository.recordRun('asset-1', runKey, makeRun({ predictedRotation: 180 }));
    expect(rerun.preserved).toBe(true);
    expect(rerun.run.status).toBe('dismissed');
    expect(rerun.run.predictedRotation).toBe(90);
    expect(internals.save).toHaveBeenCalledTimes(2);
  });

  it('refreshes a pending run on same-identity re-run', async () => {
    const { repository } = makeRepository();
    await repository.recordRun('asset-1', runKey, makeRun({ predictedRotation: 90 }));
    const rerun = await repository.recordRun('asset-1', runKey, makeRun({ predictedRotation: 0, confidence: 0.88 }));

    expect(rerun.preserved).toBe(false);
    expect(rerun.run.predictedRotation).toBe(0);
    expect(rerun.run.confidence).toBe(0.88);
  });

  it('appends runs with different identities without touching prior statuses', async () => {
    const { repository } = makeRepository();
    const fastKey = runKey;
    const balancedKey = createRotationSuggestionRunKey('rightwayup', 'balanced', 'orientation-1.0.0');

    await repository.recordRun('asset-1', fastKey, makeRun());
    await repository.setStatus('asset-1', fastKey, 'applied');
    await repository.recordRun('asset-1', balancedKey, makeRun({ tier: 'balanced', finishedAt: '2026-11-14T00:00:01.000Z' }));

    const latest = await repository.getLatestRun('asset-1');
    expect(latest?.runKey).toBe(balancedKey);
    const document = await repository.get('asset-1');
    expect(document?.runs[fastKey].status).toBe('applied');
    expect(document?.runs[balancedKey].status).toBe('pending');
  });

  it('setStatus only transitions from pending', async () => {
    const { repository } = makeRepository();
    expect(await repository.setStatus('asset-1', runKey, 'applied')).toBeNull();

    await repository.recordRun('asset-1', runKey, makeRun());
    const applied = await repository.setStatus('asset-1', runKey, 'applied');
    expect(applied?.status).toBe('applied');
    expect(await repository.setStatus('asset-1', runKey, 'dismissed')).toBeNull();
  });

  it('getLatestRun picks the most recently finished run', async () => {
    const { repository } = makeRepository();
    const laterKey = createRotationSuggestionRunKey('rightwayup', 'fast', 'orientation-1.0.1');
    await repository.recordRun('asset-1', runKey, makeRun({ finishedAt: '2026-11-14T00:00:01.000Z' }));
    await repository.recordRun('asset-1', laterKey, makeRun({ finishedAt: '2026-11-14T00:00:02.000Z' }));

    expect((await repository.getLatestRun('asset-1'))?.runKey).toBe(laterKey);
    expect(await repository.getLatestRun('asset-2')).toBeNull();
  });
});
