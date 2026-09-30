import { describe, expect, it, vi } from 'vitest';
import { JobName } from 'src/enum.js';
import { JobRepository } from 'src/repositories/job.repository.js';

const makeRepositoryWithRedis = (redis: Record<string, ReturnType<typeof vi.fn>>) => {
  const repository = new JobRepository(
    undefined as never,
    undefined as never,
    undefined as never,
    { setContext: vi.fn() } as never,
  );
  (repository as never as { getQueue: () => { client: Promise<unknown> } }).getQueue = () => ({
    client: Promise.resolve(redis),
  });
  return repository;
};

describe(JobRepository.name, () => {
  it('uses the asset and run tuple as the interpretation job id', () => {
    const repository = new JobRepository(
      undefined as never,
      undefined as never,
      undefined as never,
      { setContext: vi.fn() } as never,
    );
    const getJobOptions = (repository as never as { getJobOptions: (item: unknown) => unknown }).getJobOptions.bind(
      repository,
    );

    expect(getJobOptions({ name: JobName.AssetInterpretImage, data: { id: 'asset-1', runKey: 'run-a' } })).toEqual({
      jobId: 'asset-1/run-a',
    });

    expect(getJobOptions({ name: JobName.AssetInterpretImage, data: { id: 'asset-1' } })).toEqual({
      jobId: 'asset-1',
    });
  });

  it('deduplicates reconciliation jobs', () => {
    const repository = new JobRepository(
      undefined as never,
      undefined as never,
      undefined as never,
      { setContext: vi.fn() } as never,
    );
    const getJobOptions = (repository as never as { getJobOptions: (item: unknown) => unknown }).getJobOptions.bind(
      repository,
    );

    expect(getJobOptions({ name: JobName.AssetInterpretationReconcile })).toEqual({
      deduplication: { id: JobName.AssetInterpretationReconcile },
    });
  });

  it('uses a deterministic Discord alert job id with bounded retries', () => {
    const repository = new JobRepository(
      undefined as never,
      undefined as never,
      undefined as never,
      { setContext: vi.fn() } as never,
    );
    const getJobOptions = (repository as never as { getJobOptions: (item: unknown) => unknown }).getJobOptions.bind(
      repository,
    );

    expect(
      getJobOptions({
        name: JobName.SendAiInterpretationDiscordAlert,
        data: { assetId: 'asset-1', runKey: 'run-a' },
      }),
    ).toEqual({
      jobId: 'discord/asset-1/run-a',
      attempts: 5,
      backoff: { type: 'exponential', delay: 5000 },
    });
  });

  it('records AI interpretation completion timestamps with a bounded TTL', async () => {
    const redis = { zadd: vi.fn().mockResolvedValue(1), pexpire: vi.fn().mockResolvedValue(1) };
    const repository = makeRepositoryWithRedis(redis);
    const completedAt = new Date('2026-09-26T23:00:00.000Z');

    await repository.recordAiInterpretationCompletion('asset-1', 'run-a', completedAt);

    expect(redis.zadd).toHaveBeenCalledWith(
      'immich:ai-interpretation:completions',
      completedAt.getTime(),
      `${completedAt.getTime()}:asset-1:run-a`,
    );
    expect(redis.pexpire).toHaveBeenCalledWith('immich:ai-interpretation:completions', 10 * 60_000);
  });

  it('derives the AI interpretation completion rate from the trailing five-minute window', async () => {
    const redis = {
      zremrangebyscore: vi.fn().mockResolvedValue(0),
      zcount: vi.fn().mockResolvedValue(17),
    };
    const repository = makeRepositoryWithRedis(redis);
    const now = new Date('2026-09-26T23:00:00.000Z');

    await expect(repository.getAiInterpretationCompletionRate(now)).resolves.toBe(3.4);

    expect(redis.zremrangebyscore).toHaveBeenCalledWith(
      'immich:ai-interpretation:completions',
      '-inf',
      `(${now.getTime() - 5 * 60_000}`,
    );
    expect(redis.zcount).toHaveBeenCalledWith(
      'immich:ai-interpretation:completions',
      now.getTime() - 5 * 60_000,
      '+inf',
    );
  });
});
