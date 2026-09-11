import { JobName } from 'src/enum';
import { JobRepository } from 'src/repositories/job.repository';
import { describe, expect, it, vi } from 'vitest';

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
});
