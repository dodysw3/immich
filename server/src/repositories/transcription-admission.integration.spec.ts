import { Job, Queue, Worker } from 'bullmq';
import { randomUUID } from 'node:crypto';
import { JobName, QueueName } from 'src/enum.js';
import { JobRepository } from 'src/repositories/job.repository.js';
import {
  LIVE_VIDEO_TRANSCRIPTION_PRIORITY,
  TranscriptionDeferred,
  transcriptionDeferralDelay,
} from 'src/utils/transcription-admission.js';

// Opt-in: a disposable Redis/Valkey listener, not the application's database.
const port = Number(process.env.TRANSCRIPTION_TEST_REDIS_PORT);
const connection = { host: '127.0.0.1', port, maxRetriesPerRequest: null };
const queueName = QueueName.VideoTranscription;

const processor = (repo: JobRepository) => (job: Job, token?: string) =>
  (repo as unknown as { processWorkerJob(queue: QueueName, job: Job, token?: string): Promise<void> }).processWorkerJob(
    queueName,
    job,
    token,
  );

it.skipIf(!port)(
  'gives an upload a slot when both backfill workers are active',
  async () => {
    const prefix = `transcription-test-${randomUUID()}`;
    const queue = new Queue(queueName, { connection, prefix });
    const release = Promise.withResolvers<void>();
    const observed = Promise.withResolvers<void>();
    const liveStarted = Promise.withResolvers<void>();
    const releaseLive = Promise.withResolvers<void>();
    let activeBackfill = 0;
    let checks = 0;
    const repo = new JobRepository(
      { get: () => queue } as never,
      {} as never,
      {
        emit: async (_event: string, _queue: QueueName, job: Job) => {
          if (job.id === 'live') {
            liveStarted.resolve();
            await releaseLive.promise;
            return;
          }
          activeBackfill++;
          await release.promise;
          expect(await repo.hasWaitingLiveTranscription()).toBe(true);
          if (++checks === 2) {
            observed.resolve();
          }
          await observed.promise;
          throw new TranscriptionDeferred('live_waiting');
        },
      } as never,
      { setContext() {} } as never,
    );
    const worker = new Worker(queueName, processor(repo), { connection, prefix, concurrency: 2 });
    try {
      for (const jobId of ['backfill-a', 'backfill-b']) {
        await queue.add(JobName.AssetTranscribeVideo, { id: jobId }, { jobId, priority: 3, attempts: 3 });
      }
      await vi.waitFor(() => expect(activeBackfill).toBe(2));
      await queue.add(
        JobName.AssetTranscribeVideo,
        { id: 'live' },
        { jobId: 'live', priority: LIVE_VIDEO_TRANSCRIPTION_PRIORITY },
      );
      await queue.pause();
      expect(await repo.hasWaitingLiveTranscription()).toBe(false);
      expect(worker.isPaused()).toBe(false); // global pause didn't interrupt the two running jobs
      await queue.resume();
      expect(await repo.hasWaitingLiveTranscription()).toBe(true);
      release.resolve();
      await vi.waitFor(async () => expect(await (await queue.getJob('live'))!.getState()).toBe('active'));
      await liveStarted.promise;
      await queue.pause();
      await vi.waitFor(async () => expect(await queue.getDelayedCount()).toBe(2));
      for (const id of ['backfill-a', 'backfill-b']) {
        const same = await queue.getJob(id);
        expect(same?.attemptsMade).toBe(0);
        expect(same?.attemptsStarted).toBe(1);
      }
    } finally {
      release.resolve();
      observed.resolve();
      releaseLive.resolve();
      await worker.close(true);
      await queue.obliterate({ force: true });
      await queue.close();
    }
  },
  10_000,
);

it('bounds capacity retry jitter even after many deferrals', () => {
  expect(transcriptionDeferralDelay('gpu_capacity', 1, 0)).toBe(500);
  expect(transcriptionDeferralDelay('gpu_capacity', 1, 1)).toBe(1000);
  expect(transcriptionDeferralDelay('gpu_capacity', 100, 0)).toBe(15_000);
  expect(transcriptionDeferralDelay('gpu_capacity', 100, 1)).toBe(30_000);
});

it.skipIf(!port)(
  'recovers a crash before moveToDelayed and defers the same job without spending attempts',
  async () => {
    const prefix = `transcription-test-${randomUUID()}`;
    const queue = new Queue(queueName, { connection, prefix });
    const handoff = Promise.withResolvers<void>();
    const abandoned = Promise.withResolvers<void>();
    const later = Promise.withResolvers<void>();
    const workerOptions = { connection, prefix, concurrency: 1, lockDuration: 300, stalledInterval: 300 };
    const jobId = 'asset';
    const crashedWorker = new Worker(
      queueName,
      async () => {
        // The repository test exercises the durable release; here the processor
        // stops in the gap between that release and the Redis delay operation.
        handoff.resolve();
        await abandoned.promise;
      },
      workerOptions,
    );
    let recovered: Worker | undefined;
    try {
      await queue.add(JobName.AssetTranscribeVideo, { id: jobId }, { jobId, priority: 3, attempts: 3 });
      await handoff.promise;
      await crashedWorker.close(true);
      await queue.add(JobName.AssetTranscribeVideo, { id: jobId, duplicate: true }, { jobId, priority: 3 });
      expect(await queue.getActiveCount()).toBe(1);
      expect(await queue.getPrioritizedCount()).toBe(0);
      const repo = new JobRepository(
        { get: () => queue } as never,
        {} as never,
        {
          emit: (_event: string, _queue: QueueName, job: Job) => {
            expect(job.id).toBe(jobId);
            expect(job.data.duplicate).toBeUndefined();
            if (job.attemptsStarted === 2) {
              return Promise.reject(new TranscriptionDeferred('gpu_capacity'));
            }
            later.resolve();
            return Promise.resolve();
          },
        } as never,
        { setContext() {} } as never,
      );
      recovered = new Worker(queueName, processor(repo), workerOptions);
      await vi.waitFor(
        async () => {
          const same = await queue.getJob(jobId);
          expect(await same?.getState()).toBe('delayed');
          expect(same?.attemptsMade).toBe(0);
          expect(same?.attemptsStarted).toBe(2);
        },
        { timeout: 4500 },
      );
      await later.promise;
      await vi.waitFor(async () => expect(await (await queue.getJob(jobId))!.getState()).toBe('completed'));
      expect(await queue.getFailedCount()).toBe(0);
    } finally {
      await crashedWorker.close(true);
      abandoned.resolve();
      await recovered?.close(true);
      await queue.obliterate({ force: true });
      await queue.close();
    }
  },
  10_000,
);
