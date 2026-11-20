import { Mocked, vitest } from 'vitest';
import { JobRepository } from 'src/repositories/job.repository.js';
import type { RepositoryInterface } from 'src/types.js';

export const newJobRepositoryMock = (): Mocked<RepositoryInterface<JobRepository>> => {
  return {
    setup: vitest.fn(),
    startWorkers: vitest.fn(),
    watchWorkers: vitest.fn(),
    teardown: vitest.fn(),
    run: vitest.fn(),
    setConcurrency: vitest.fn(),
    empty: vitest.fn(),
    pause: vitest.fn(),
    resume: vitest.fn(),
    searchJobs: vitest.fn(),
    queue: vitest.fn().mockImplementation(() => Promise.resolve()),
    queueAll: vitest.fn().mockImplementation(() => Promise.resolve()),
    isActive: vitest.fn(),
    isPaused: vitest.fn(),
    hasWaitingLiveTranscription: vitest.fn().mockResolvedValue(false),
    getJobCounts: vitest.fn(),
    recordAiInterpretationCompletion: vitest.fn().mockImplementation(() => Promise.resolve()),
    getAiInterpretationCompletionRate: vitest.fn().mockImplementation(() => Promise.resolve(0)),
    getVoiceIsolationBackfillCursor: vitest.fn().mockImplementation(() => Promise.resolve(undefined)),
    setVoiceIsolationBackfillCursor: vitest.fn().mockImplementation(() => Promise.resolve()),
    clear: vitest.fn(),
    waitForQueueCompletion: vitest.fn(),
    jobExists: vitest.fn().mockImplementation(() => Promise.resolve(true)),
    removeJob: vitest.fn(),
  };
};
