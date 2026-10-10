import { snakeCase } from 'lodash-es';
import type { ObservableResult } from '@opentelemetry/api';
import type { ArgOf, ArgsOf } from 'src/repositories/event.repository.js';
import { OnEvent } from 'src/decorators.js';
import { ImmichWorker, JobStatus, QueueName } from 'src/enum.js';
import { BaseService } from 'src/services/base.service.js';

// states that make up a queue's backlog; active is tracked separately by the
// event-driven immich.queues.<name>.active gauge
const QUEUE_COUNT_STATES = ['waiting', 'delayed', 'paused', 'failed'] as const;

export class TelemetryService extends BaseService {
  @OnEvent({ name: 'AppBootstrap', workers: [ImmichWorker.Api] })
  async onBootstrap(): Promise<void> {
    const userCount = await this.userRepository.getCount();
    this.telemetryRepository.api.addToGauge('immich.users.total', userCount);
  }

  @OnEvent({ name: 'AppBootstrap', workers: [ImmichWorker.Microservices] })
  onMicroservicesBootstrap(): void {
    // counts are read from BullMQ at scrape time, so they stay accurate even
    // when the event-driven active gauge drifts (e.g. after a worker crash)
    this.telemetryRepository.jobs.observeGauge(
      'immich.queues.jobs',
      async (result: ObservableResult) => {
        const allCounts = await Promise.all(
          Object.values(QueueName).map(async (queue) => ({
            queue,
            counts: await this.jobRepository.getJobCounts(queue),
          })),
        );

        for (const { queue, counts } of allCounts) {
          for (const state of QUEUE_COUNT_STATES) {
            result.observe(counts[state], { queue_name: snakeCase(queue), state });
          }
        }
      },
      { description: 'Jobs held by each queue, by state' },
    );
  }

  @OnEvent({ name: 'UserCreate' })
  onUserCreate() {
    this.telemetryRepository.api.addToGauge(`immich.users.total`, 1);
  }

  @OnEvent({ name: 'UserTrash' })
  onUserTrash() {
    this.telemetryRepository.api.addToGauge(`immich.users.total`, -1);
  }

  @OnEvent({ name: 'UserRestore' })
  onUserRestore() {
    this.telemetryRepository.api.addToGauge(`immich.users.total`, 1);
  }

  @OnEvent({ name: 'JobStart' })
  onJobStart(...[queueName]: ArgsOf<'JobStart'>) {
    const queueMetric = `immich.queues.${snakeCase(queueName)}.active`;
    this.telemetryRepository.jobs.addToGauge(queueMetric, 1);
  }

  @OnEvent({ name: 'JobSuccess' })
  onJobSuccess({ job, response }: ArgOf<'JobSuccess'>) {
    this.recordJobDuration(job);

    if (!(response && Object.values(JobStatus).includes(response as JobStatus))) {
      return;
    }

    const jobMetric = `immich.jobs.${snakeCase(job.name)}.${response}`;
    this.telemetryRepository.jobs.addToCounter(jobMetric, 1);
  }

  @OnEvent({ name: 'JobError' })
  onJobError({ job }: ArgOf<'JobError'>) {
    this.recordJobDuration(job);

    const jobMetric = `immich.jobs.${snakeCase(job.name)}.${JobStatus.Failed}`;
    this.telemetryRepository.jobs.addToCounter(jobMetric, 1);
  }

  private recordJobDuration(job: ArgOf<'JobSuccess'>['job']): void {
    if (!job.processedOn) {
      return;
    }

    this.telemetryRepository.jobs.recordHistogram(
      'immich.jobs.duration',
      Date.now() - job.processedOn,
      { job_name: snakeCase(job.name) },
      { unit: 'ms', description: 'Duration in ms of each job run, labeled by job name' },
    );
  }

  @OnEvent({ name: 'JobComplete' })
  onJobComplete(...[queueName]: ArgsOf<'JobComplete'>) {
    const queueMetric = `immich.queues.${snakeCase(queueName)}.active`;
    this.telemetryRepository.jobs.addToGauge(queueMetric, -1);
  }

  @OnEvent({ name: 'QueueStart' })
  onQueueStart({ name }: ArgOf<'QueueStart'>) {
    this.telemetryRepository.jobs.addToCounter(`immich.queues.${snakeCase(name)}.started`, 1);
  }
}
