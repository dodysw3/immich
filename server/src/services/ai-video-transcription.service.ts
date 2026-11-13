import { Injectable } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { hostname, tmpdir } from 'node:os';
import { join } from 'node:path';
import { OnEvent, OnJob } from 'src/decorators.js';
import {
  AiVideoTranscriptionDocument,
  AiVideoTranscriptionDocumentSchema,
  AiVideoTranscriptionError,
  AiVideoTranscriptionMetrics,
  AiVideoTranscriptionRun,
  AiVideoTranscriptionSegment,
  AiVideoTranscriptionTrigger,
  TranscriptionCoverageCounts,
} from 'src/dtos/ai-video-transcription.dto.js';
import { AssetType, ImmichWorker, JobName, JobStatus, QueueName } from 'src/enum.js';
import { AiVideoTranscriptionRepository } from 'src/repositories/ai-video-transcription.repository.js';
import { AssetJobRepository } from 'src/repositories/asset-job.repository.js';
import { AssetRepository } from 'src/repositories/asset.repository.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import type { ArgOf } from 'src/repositories/event.repository.js';
import { JobRepository } from 'src/repositories/job.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { MediaRepository } from 'src/repositories/media.repository.js';
import {
  AiVideoTranscriptionClient,
  AiVideoTranscriptionClientError,
  AiVideoTranscriptionResponse,
} from 'src/services/ai-video-transcription.client.js';
import type { JobOf } from 'src/types.js';
import {
  AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
  AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
  AI_VIDEO_TRANSCRIPTION_PROMPT_VERSION,
  AI_VIDEO_TRANSCRIPTION_SERVICE,
  AiVideoTranscriptionProducerIdentity,
  assessLegacyTranscriptionRun,
  buildTranscriptionChunkPlan,
  createLegacyVideoTranscriptionRunKey,
  createVideoTranscriptionRunKey,
  isRunActive,
} from 'src/utils/ai-video-transcription.js';
import { batched } from 'src/utils/misc.js';
import { TRANSCRIPT_INDEX_VERSION } from 'src/utils/transcript-index.js';

/** Lease slack beyond the sidecar timeout: extraction time + jitter headroom. */
const LEASE_SLACK_MS = 5 * 60_000;

/** Max enqueue budget per reconciliation sweep: bounded bursts, never the whole library. */
const RECONCILE_ENQUEUE_BUDGET = 2000;

/**
A queued run older than this is declared lost (its BullMQ job no longer
exists, e.g. a Redis wipe) and is re-enqueued with force; waiting behind a
long backlog is not loss.
*/
const RECONCILE_STALE_QUEUED_MS = 24 * 60 * 60_000;

/**
Speech transcription for videos via a faster-whisper CPU sidecar (:51905).
Stores timestamped segments in asset_metadata `video-transcripts-v1` (kept
separate from captions and interpretation so the data survives either
experiment ending). Two delivery paths feed one atomic producer:

- the independent `videoTranscription` queue (`AssetTranscribeVideo`), used by
  upload processing and reconciliation/backfill — failures propagate to the
  queue for BullMQ retry/backoff;
- the AI interpretation job chaining `transcribeIfMissing` (failure-soft), so
  a sidecar outage degrades interpretation instead of failing it.
*/
@Injectable()
export class AiVideoTranscriptionService {
  constructor(
    private logger: LoggingRepository,
    private configRepository: ConfigRepository,
    private assetRepository: AssetRepository,
    private mediaRepository: MediaRepository,
    private transcriptionRepository: AiVideoTranscriptionRepository,
    private client: AiVideoTranscriptionClient,
    private jobRepository: JobRepository,
    private assetJobRepository: AssetJobRepository,
  ) {
    this.logger.setContext(AiVideoTranscriptionService.name);
  }

  /**
  New-video scheduling: transcription is independent of captioning and
  interpretation settings. Metadata extraction (which also supplies the
  duration the producer needs) fires per upload; the enqueue lands on the
  upload priority tier. Interpretation-triggered deliveries go through the
  same atomic producer (claim/lease exclusion), so a concurrent upload job
  and interpretation chain can never create two active transcriptions.
  */
  @OnEvent({ name: 'AssetMetadataExtracted', workers: [ImmichWorker.Microservices] })
  async onAssetMetadataExtracted({ assetId }: ArgOf<'AssetMetadataExtracted'>) {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    if (!config.enabled) {
      return;
    }
    const [asset] = await this.assetRepository.getByIds([assetId]);
    if (!asset || asset.type !== AssetType.Video) {
      return;
    }
    await this.jobRepository.queue({
      name: JobName.AssetTranscribeVideo,
      data: { id: assetId, priority: 2, trigger: 'upload' },
    });
  }

  /**
  Queue handler for the independent transcription lane (upload scheduling and
  reconciliation). Disabled mode skips without touching existing transcripts;
  failures are reported to the queue (thrown) rather than swallowed, so
  BullMQ retry/backoff applies.
  */
  @OnJob({ name: JobName.AssetTranscribeVideo, queue: QueueName.VideoTranscription })
  async handleTranscribeVideo({
    id: assetId,
    trigger = 'reconcile',
    force,
  }: JobOf<JobName.AssetTranscribeVideo>): Promise<JobStatus> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    if (!config.enabled) {
      this.logger.debug(`Video transcription disabled; skipping asset ${assetId} (transcripts preserved)`);
      return JobStatus.Skipped;
    }
    await this.transcribeAsset(assetId, trigger, { force });
    return JobStatus.Success;
  }

  /**
  The transcription producer: disabled/asset checks, coverage prechecks, then
  the chunked full-duration run. Throws on failure — callers decide whether
  that is fatal (queue job) or degradable (interpretation chaining).
  */
  async transcribeAsset(
    assetId: string,
    trigger: AiVideoTranscriptionTrigger,
    options?: { force?: boolean },
  ): Promise<AiVideoTranscriptionRun | undefined> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    if (!config.enabled) {
      return await this.latestCompletedRun(assetId);
    }

    const [asset] = await this.assetRepository.getByIds([assetId]);
    if (!asset || asset.type !== AssetType.Video) {
      return undefined;
    }

    const producerIdentity: AiVideoTranscriptionProducerIdentity = {
      model: config.model,
      producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
      language: config.language,
      coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
    };
    const runKey = createVideoTranscriptionRunKey(producerIdentity);
    const document = await this.transcriptionRepository.get(assetId);
    const existing = document?.runs[runKey];
    // Legacy reuse: runs keyed by model+promptVersion predate the chunked
    // producer. Coverage assessment decides whether a completed legacy run is
    // trustworthy full coverage (reused) or truncated/unverified (scheduled).
    const legacyExisting =
      document?.runs[createLegacyVideoTranscriptionRunKey(config.model, AI_VIDEO_TRANSCRIPTION_PROMPT_VERSION)];
    if (existing && isRunActive(existing) && !(options?.force && existing.status === 'queued')) {
      // The current producer has usable or actively-produced work: completed
      // reuse, queued scheduling, or leased-running exclusion. A running run
      // with an expired/missing lease is abandoned and falls through so the
      // atomic claim below reclaims it.
      return await this.latestCompletedRun(assetId);

      // Forced reconcile delivery: the queued row's BullMQ job was declared
      // lost by the sweep, so reclaim it through the atomic claim instead of
      // skipping forever.
    }
    if (legacyExisting && isRunActive(legacyExisting)) {
      const assessment = assessLegacyTranscriptionRun(legacyExisting);
      if (assessment.verdict === 'reuse') {
        return await this.latestCompletedRun(assetId);
      }
      // Truncated or ambiguous legacy work falls through: the chunked producer
      // schedules full-duration coverage. For legacy no-audio outcomes this is
      // a cheap probe re-verification (no inference), not a retranscription.
      this.logger.debug(`Legacy transcription for asset ${assetId} needs coverage: ${assessment.reason}`);
    }

    await this.transcribeRun(assetId, asset.originalPath, runKey, trigger);
    return await this.latestCompletedRun(assetId);
  }

  @Cron('*/15 * * * *')
  async reconcilePeriodically() {
    if (!this.configRepository.getEnv().aiVideoTranscription.enabled) {
      return;
    }
    await this.jobRepository.queue({ name: JobName.TranscriptionReconcile });
  }

  /**
  Keyset reconciliation over the whole video library (streamed, bounded
  enqueueing): missing, partial (legacy truncated/unverified), and abandoned
  (expired-lease or lost-queued-job) work gets re-enqueued from durable
  run/coverage state — queue existence alone never decides. Failed runs are
  terminal for the sweep: invalid media stays visible for operator retry
  instead of churning.
  */
  @OnJob({ name: JobName.TranscriptionReconcile, queue: QueueName.VideoTranscription })
  async handleReconcile(): Promise<JobStatus> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    if (!config.enabled) {
      return JobStatus.Skipped;
    }
    const enqueued = await this.reconcile();
    if (enqueued > 0) {
      this.logger.log(`Transcription reconciliation enqueued ${enqueued} asset(s)`);
    }
    return JobStatus.Success;
  }

  private async reconcile(budget = RECONCILE_ENQUEUE_BUDGET): Promise<number> {
    const producerIdentity: AiVideoTranscriptionProducerIdentity = {
      model: this.configRepository.getEnv().aiVideoTranscription.model,
      producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
      language: this.configRepository.getEnv().aiVideoTranscription.language,
      coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
    };
    const runKey = createVideoTranscriptionRunKey(producerIdentity);
    const legacyRunKey = createLegacyVideoTranscriptionRunKey(
      producerIdentity.model,
      AI_VIDEO_TRANSCRIPTION_PROMPT_VERSION,
    );
    const staleQueuedBefore = new Date(Date.now() - RECONCILE_STALE_QUEUED_MS).toISOString();

    let enqueued = 0;
    for await (const assets of batched(this.assetJobRepository.streamForTranscriptionReconcile(), 500)) {
      for (const asset of assets) {
        if (enqueued >= budget) {
          return enqueued;
        }
        const decision = this.needsTranscriptionWork(asset.transcriptValue, runKey, legacyRunKey, staleQueuedBefore);
        if (!decision.work) {
          continue;
        }
        await this.jobRepository.queue({
          name: JobName.AssetTranscribeVideo,
          data: { id: asset.id, priority: 3, trigger: 'reconcile', force: decision.force === true },
        });
        enqueued++;
      }
    }
    return enqueued;
  }

  /**
  Decide transcription work from durable source state. `force` is set only for
  stale queued rows whose BullMQ job was declared lost — their re-enqueued
  delivery must reclaim the row instead of skipping it.
  */
  private needsTranscriptionWork(
    transcriptValue: unknown,
    runKey: string,
    legacyRunKey: string,
    staleQueuedBefore: string,
  ): { work: boolean; force?: boolean } {
    if (transcriptValue === null || transcriptValue === undefined) {
      return { work: true };
    }
    let document: AiVideoTranscriptionDocument;
    try {
      document = AiVideoTranscriptionDocumentSchema.parse(transcriptValue);
    } catch {
      // Unparseable metadata is unusable source state: schedule verification.
      return { work: true };
    }

    const current = document.runs[runKey];
    if (current) {
      if (current.status === 'failed') {
        // Terminal for the sweep: invalid media stays visible for operator
        // retry instead of churning through reconciliation forever.
        return { work: false };
      }
      if (current.status === 'queued') {
        // A fresh queued row has a (probably) live BullMQ job; a stale one was
        // declared lost (Redis wipe) and is re-enqueued with force.
        return current.requestedAt < staleQueuedBefore ? { work: true, force: true } : { work: false };
      }
      // Running: work is needed exactly when the run is not active — i.e. the
      // lease is missing or expired (abandoned by a dead worker).
      return { work: !isRunActive(current) };
    }

    const legacy = document.runs[legacyRunKey];
    if (legacy && isRunActive(legacy)) {
      return { work: assessLegacyTranscriptionRun(legacy).verdict === 'schedule' };
    }
    return { work: true };
  }

  /**
  Chained from the AI interpretation job: transcribe this video if no
  completed run exists yet. Never throws — a sidecar outage degrades
  interpretation to captions/thumbnail only. Returns the latest completed run
  for prompt-context composition, or undefined.
  */
  async transcribeIfMissing(
    assetId: string,
    trigger: AiVideoTranscriptionTrigger,
  ): Promise<AiVideoTranscriptionRun | undefined> {
    try {
      return await this.transcribeAsset(assetId, trigger);
    } catch (error) {
      this.logger.warn(`Chained video transcription failed for asset ${assetId}: ${error}`);
      return await this.latestCompletedRun(assetId);
    }
  }

  private async latestCompletedRun(assetId: string): Promise<AiVideoTranscriptionRun | undefined> {
    const document = await this.transcriptionRepository.get(assetId);
    return this.transcriptionRepository.findLatestCompletedRun(document ?? { schemaVersion: 1, runs: {} }) ?? undefined;
  }

  /** Probe → claim → extract audio → sidecar transcription → complete/fail. */
  private async transcribeRun(
    assetId: string,
    originalPath: string,
    runKey: string,
    trigger: AiVideoTranscriptionTrigger,
  ): Promise<void> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    const startedAt = new Date();
    const tempDir = await mkdtemp(join(tmpdir(), 'immich-video-transcribe-'));
    try {
      // Probe failures before the claim are recorded by the catch below when a
      // run row already exists; otherwise they surface to the caller (queue
      // job) as a retryable error without any document state.
      let probe;
      try {
        probe = await this.mediaRepository.probe(originalPath);
      } catch (error) {
        throw new AiVideoTranscriptionClientError('media_error', `probe failed: ${error}`);
      }
      const durationMs = Math.round((probe.format.duration || 0) * 1000);
      if (durationMs <= 0) {
        throw new AiVideoTranscriptionClientError('invalid_output', `asset ${assetId} has no measurable duration`);
      }

      const claim = await this.transcriptionRepository.claim(
        assetId,
        {
          runKey,
          model: config.model,
          promptVersion: AI_VIDEO_TRANSCRIPTION_PROMPT_VERSION,
          config: { language: config.language },
          durationMs,
          trigger,
          producer: {
            service: AI_VIDEO_TRANSCRIPTION_SERVICE,
            model: config.model,
            producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
            language: config.language,
            coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
          },
          targetDurationMs: durationMs,
          chunks: buildTranscriptionChunkPlan(durationMs, config.chunkDurationSec),
        },
        { ownerId: this.leaseOwnerId(), leaseMs: config.timeoutMs + LEASE_SLACK_MS },
        startedAt,
      );
      if (claim.alreadyExists) {
        // A valid completed run or another worker's active lease owns this run;
        // producing again would duplicate or reset their work.
        this.logger.debug(`Video transcription for asset ${assetId} skipped: ${claim.reason}`);
        return;
      }
      if (claim.resumedChunks > 0) {
        this.logger.log(
          `Resuming video transcription for asset ${assetId}: ${claim.resumedChunks} chunk(s) already done`,
        );
      }

      if (probe.audioStreams.length === 0) {
        // Verified absence of audio (the probe saw no audio stream): terminal,
        // completed with no segments. Later deliveries don't re-probe, and
        // interpretation skips the transcript block instead of waiting on the
        // sidecar again.
        await this.transcriptionRepository.complete(assetId, runKey, {
          noAudio: true,
          metrics: this.metrics(startedAt),
        });
        await this.enqueueIndexSync(assetId);
        this.logger.log(`Transcribed video asset ${assetId}: no audio stream`);
        return;
      }

      // Chunked full-duration production: bounded extraction windows with a
      // small overlap, absolute timestamps, and durable per-chunk progress.
      // maxDurationSec remains a legacy whole-file concept — it no longer caps
      // processing (coverage policy is chunked-full-duration-v1), so videos
      // beyond the old 7200s deployment cap complete instead of truncating.
      const overlapMs = config.chunkOverlapSec * 1000;
      const chunks = claim.run.chunks ?? buildTranscriptionChunkPlan(durationMs, config.chunkDurationSec);
      const lease = { ownerId: this.leaseOwnerId(), leaseMs: config.timeoutMs + LEASE_SLACK_MS };
      let producedSegments = 0;
      let language: string | undefined;
      let languageProbability: number | undefined;

      for (const chunk of chunks) {
        if (chunk.status === 'completed') {
          continue;
        }
        // The extraction window is padded with the overlap so a segment
        // straddling the boundary stays intact; the chunk whose responsibility
        // range contains the segment's absolute start keeps it and the
        // neighbor's copy is discarded (overlap deduplication).
        const windowStartMs = Math.max(0, chunk.startMs - overlapMs);
        const windowEndMs = Math.min(durationMs, chunk.endMs + overlapMs);
        let response: AiVideoTranscriptionResponse;
        try {
          const chunkPath = await this.mediaRepository.extractVideoAudioChunk(originalPath, tempDir, {
            startSec: windowStartMs / 1000,
            durationSec: (windowEndMs - windowStartMs) / 1000,
          });
          const audio = await readFile(chunkPath);
          response = await this.client.transcribe(audio, { language: config.language || undefined });
        } catch (error) {
          const transcriptionError: AiVideoTranscriptionError =
            error instanceof AiVideoTranscriptionClientError
              ? { code: error.code, message: error.message }
              : { code: 'media_error', message: error instanceof Error ? error.message : String(error) };
          await this.transcriptionRepository.failChunk(assetId, runKey, chunk.index, transcriptionError);
          // Rethrow in client-error shape so the run-level failure records the
          // same retryable code instead of a generic internal_error.
          throw error instanceof AiVideoTranscriptionClientError
            ? error
            : new AiVideoTranscriptionClientError('media_error', transcriptionError.message);
        }

        const segments: AiVideoTranscriptionSegment[] = response.segments
          .map((segment) => ({
            startMs: windowStartMs + Math.max(0, Math.round(segment.startSec * 1000)),
            endMs: windowStartMs + Math.round(segment.endSec * 1000),
            text: segment.text,
          }))
          .filter((segment) => segment.startMs >= chunk.startMs && segment.startMs < chunk.endMs)
          .map((segment) => ({
            ...segment,
            endMs: Math.min(Math.max(segment.endMs, segment.startMs + 1), durationMs),
          }));

        // Durable progress: segments + coverage window land in the same locked
        // update, so an interrupted worker resumes from real completed chunks.
        await this.transcriptionRepository.completeChunk(assetId, runKey, chunk.index, segments, {
          startMs: windowStartMs,
          endMs: windowEndMs,
        });
        await this.transcriptionRepository.renewLease(assetId, runKey, lease.ownerId, lease.leaseMs);
        producedSegments += segments.length;
        language ??= response.language;
        languageProbability ??= response.languageProbability;
      }

      await this.transcriptionRepository.complete(assetId, runKey, {
        language,
        languageProbability,
        // Successful decode of every chunk without a single usable segment
        // establishes no-speech; nothing here can be confused with an
        // extraction failure (those throw before this point).
        noSpeech: producedSegments === 0 || undefined,
        metrics: this.metrics(startedAt),
      });
      await this.enqueueIndexSync(assetId);
      this.logger.log(
        `Transcribed video asset ${assetId} (${producedSegments === 0 ? 'no speech' : `${producedSegments} segments`} across ${chunks.length} chunk(s), language: ${language ?? 'unknown'}) in ${Date.now() - startedAt.getTime()}ms`,
      );
    } catch (error) {
      const transcriptionError: AiVideoTranscriptionError =
        error instanceof AiVideoTranscriptionClientError
          ? { code: error.code, message: error.message }
          : { code: 'internal_error', message: error instanceof Error ? error.message : String(error) };
      this.logger.warn(
        `Video transcription failed for asset ${assetId}: ${transcriptionError.code} — ${transcriptionError.message}`,
      );
      await this.transcriptionRepository.fail(assetId, runKey, transcriptionError);
      // Rethrow: the document records the failure, and the queue job must end
      // up failed (BullMQ retry/backoff), not silently successful. The
      // interpretation chain catches in transcribeIfMissing instead.
      throw error;
    } finally {
      await rm(tempDir, { recursive: true, force: true }).catch(() => void 0);
    }
  }

  /** Admin coverage totals (see the repository for the SQL classification). */
  async getCoverageCounts(): Promise<TranscriptionCoverageCounts> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    const runKey = createVideoTranscriptionRunKey({
      model: config.model,
      producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
      language: config.language,
      coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
    });
    const legacyRunKey = createLegacyVideoTranscriptionRunKey(config.model, AI_VIDEO_TRANSCRIPTION_PROMPT_VERSION);
    return this.transcriptionRepository.getCoverageCounts(runKey, legacyRunKey, TRANSCRIPT_INDEX_VERSION);
  }

  /** Explicit reconciliation action for operators: queues the deduplicated sweep. */
  async queueReconciliation(): Promise<void> {
    await this.jobRepository.queue({ name: JobName.TranscriptionReconcile });
  }

  /** Completion hook: the derived search index syncs from the stored document. */
  private async enqueueIndexSync(assetId: string): Promise<void> {
    await this.jobRepository.queue({ name: JobName.TranscriptIndexSync, data: { id: assetId } }).catch((error) => {
      // Non-fatal: reconciliation repairs missed syncs.
      this.logger.warn(`Failed to enqueue transcript index sync for asset ${assetId}: ${error}`);
    });
  }

  private metrics(startedAt: Date): AiVideoTranscriptionMetrics {
    return { durationMs: Date.now() - startedAt.getTime() };
  }

  /** Durable lease owner identity: surviving restarts must not look like the same worker. */
  private leaseOwnerId(): string {
    return `${hostname()}:${process.pid}`;
  }
}
