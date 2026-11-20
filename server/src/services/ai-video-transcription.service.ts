import { Injectable } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { randomUUID } from 'node:crypto';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { OnEvent, OnJob } from 'src/decorators.js';
import { AiAudioEventsDocumentSchema, AiAudioEventsRun } from 'src/dtos/ai-audio-events.dto.js';
import {
  AiVideoTranscriptionChunkEvidence,
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
import { AiAudioEventsRepository } from 'src/repositories/ai-audio-events.repository.js';
import { AiVideoTranscriptionRepository } from 'src/repositories/ai-video-transcription.repository.js';
import { AssetJobRepository } from 'src/repositories/asset-job.repository.js';
import { AssetRepository } from 'src/repositories/asset.repository.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import type { ArgOf } from 'src/repositories/event.repository.js';
import { JobRepository } from 'src/repositories/job.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { MediaRepository } from 'src/repositories/media.repository.js';
import { TelemetryRepository } from 'src/repositories/telemetry.repository.js';
import {
  AiVideoTranscriptionClient,
  AiVideoTranscriptionClientError,
  AiVideoTranscriptionResponse,
  type TranscriptionRequestClass,
} from 'src/services/ai-video-transcription.client.js';
import type { JobOf } from 'src/types.js';
import { buildVoiceIsolationEvidence } from 'src/utils/ai-audio-events.js';
import {
  AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
  AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
  AI_VIDEO_TRANSCRIPTION_PROMPT_VERSION,
  AI_VIDEO_TRANSCRIPTION_SERVICE,
  AI_VIDEO_TRANSCRIPTION_VOICE_ISOLATION,
  AiVideoTranscriptionProducerIdentity,
  acceptsIsolatedTranscript,
  assessLegacyTranscriptionRun,
  buildTranscriptionChunkPlan,
  createLegacyVideoTranscriptionRunKey,
  createVideoTranscriptionRunKey,
  evaluateVoiceIsolationGate,
  isRunActive,
  type VoiceIsolationGateReason,
} from 'src/utils/ai-video-transcription.js';
import { batched } from 'src/utils/misc.js';
import { TRANSCRIPT_INDEX_VERSION } from 'src/utils/transcript-index.js';
import { LIVE_VIDEO_TRANSCRIPTION_PRIORITY, TranscriptionDeferred } from 'src/utils/transcription-admission.js';

/** Lease slack beyond the sidecar timeout: extraction time + jitter headroom. */
const LEASE_SLACK_MS = 5 * 60_000;

/** Max enqueue budget per reconciliation sweep: bounded bursts, never the whole library. */
const RECONCILE_ENQUEUE_BUDGET = 2000;
const DUAL_GPU_ISOLATION_BUDGET_CAP = 200;

/**
A queued run older than this is declared lost (its BullMQ job no longer
exists, e.g. a Redis wipe) and is re-enqueued with force; waiting behind a
long backlog is not loss.
*/
const RECONCILE_STALE_QUEUED_MS = 24 * 60 * 60_000;

/**
Service-level failed runs re-enter the sweep after this cool-down; a retry
that fails again refreshes `finishedAt`, bounding churn to ≤1 attempt/day.
Media-level codes never retry (invalid media stays visible for operator
retry), and a failed run without `finishedAt` is treated as fresh.
*/
const TRANSCRIPTION_FAILURE_RETRY_COOLDOWN_MS = 24 * 60 * 60_000;
const RETRYABLE_TRANSCRIPTION_ERROR_CODES = new Set([
  'endpoint_error',
  'internal_error',
  'timeout',
  'network_error',
  'invalid_json',
]);

/** Fixed-label voice-isolation metrics: four gate reasons, three run outcomes. */
const VOICE_ISOLATION_GATE_METRIC = 'immich.transcription.voice_isolation.gate';
const VOICE_ISOLATION_RUN_METRIC = 'immich.transcription.voice_isolation.run';
const VOICE_ISOLATION_DURATION_METRIC = 'immich.transcription.voice_isolation.duration';

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
    private eventsRepository: AiAudioEventsRepository,
    private client: AiVideoTranscriptionClient,
    private jobRepository: JobRepository,
    private assetJobRepository: AssetJobRepository,
    private telemetryRepository: TelemetryRepository,
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
      data: { id: assetId, priority: LIVE_VIDEO_TRANSCRIPTION_PRIORITY, trigger: 'upload' },
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
    mode,
  }: JobOf<JobName.AssetTranscribeVideo>): Promise<JobStatus> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    if (!config.enabled) {
      this.logger.debug(`Video transcription disabled; skipping asset ${assetId} (transcripts preserved)`);
      return JobStatus.Skipped;
    }
    if (mode === 'isolation') {
      // Backlog sweep delivery: never touch the raw run, only add (or retry)
      // the gated second pass.
      await this.runVoiceIsolationOnly(assetId, trigger);
      return JobStatus.Success;
    }
    this.logger.debug(`Video transcription job for asset ${assetId} (trigger=${trigger}, force=${force === true})`);
    await this.transcribeAsset(assetId, trigger, { force, fromQueue: true });
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
    options?: { force?: boolean; fromQueue?: boolean },
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
    const fromQueue = options?.fromQueue === true;
    const resumeQueued = existing?.status === 'queued' && (options?.force || (fromQueue && existing.startedAt));
    if (existing && isRunActive(existing) && !resumeQueued) {
      // The current producer has usable or actively-produced work: completed
      // reuse, queued scheduling, or leased-running exclusion. A running run
      // with an expired/missing lease is abandoned and falls through so the
      // atomic claim below reclaims it.
      if (existing.status === 'completed') {
        // A completed raw run is also the backfill entry point: reconciliation
        // reconfirms it here, and this is where the gated isolation pass gets
        // its chance if it has not run yet.
        await this.maybeRunVoiceIsolation(assetId, asset.originalPath, runKey, trigger, { fromQueue });
      }
      return await this.latestCompletedRun(assetId);

      // Forced reconcile delivery: the queued row's BullMQ job was declared
      // lost by the sweep, so reclaim it through the atomic claim instead of
      // skipping forever.
    }
    if (legacyExisting && isRunActive(legacyExisting)) {
      const assessment = assessLegacyTranscriptionRun(legacyExisting);
      if (assessment.verdict === 'reuse') {
        // Legacy evidence counts as the raw run for gating purposes.
        await this.maybeRunVoiceIsolation(assetId, asset.originalPath, runKey, trigger, { fromQueue });
        return await this.latestCompletedRun(assetId);
      }
      // Truncated or ambiguous legacy work falls through: the chunked producer
      // schedules full-duration coverage. For legacy no-audio outcomes this is
      // a cheap probe re-verification (no inference), not a retranscription.
      this.logger.debug(`Legacy transcription for asset ${assetId} needs coverage: ${assessment.reason}`);
    }

    await this.transcribeRun(assetId, asset.originalPath, runKey, trigger, { fromQueue });
    // Best-effort second pass: the raw transcript is already stored and is
    // never rolled back by an isolation failure.
    await this.maybeRunVoiceIsolation(assetId, asset.originalPath, runKey, trigger, { fromQueue });
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
  run/coverage state — queue existence alone never decides. Media-level
  failed runs are terminal for the sweep (invalid media stays visible for
  operator retry); service-level failed runs retry after a 24h cool-down.
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

  /**
  Hourly backlog nudge: only when the isolator is configured and the kill
  switch is on. The sweep itself is deduplicated, so an operator-triggered run
  and this cron never overlap.
  */
  @Cron('17 * * * *')
  async scheduleVoiceIsolationBackfill(): Promise<void> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    if (!config.enabled || !config.voiceIsolationUrl || !config.voiceIsolationEnabled) {
      return;
    }
    await this.jobRepository.queue({ name: JobName.VoiceIsolationBackfill });
  }

  @OnJob({ name: JobName.VoiceIsolationBackfill, queue: QueueName.VideoTranscription })
  async handleVoiceIsolationBackfill(): Promise<JobStatus> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    if (!config.enabled || !config.voiceIsolationUrl || !config.voiceIsolationEnabled) {
      return JobStatus.Skipped;
    }
    const scheduled = await this.runVoiceIsolationBackfill(this.voiceIsolationBackfillBudget());
    if (scheduled > 0) {
      this.logger.log(`Voice-isolation backfill scheduled ${scheduled} asset(s)`);
    }
    return JobStatus.Success;
  }

  /**
  Bounded, resumable sweep over already-completed raw runs. Selection happens
  in SQL (keyset by asset id, no completed isolated run, failed passes past the
  cool-down); the gate is re-evaluated here with the joined audio-event
  evidence so only eligible assets are scheduled. Re-running is safe: queued
  work is excluded from selection and completed runs leave the candidate set.
  */
  private async runVoiceIsolationBackfill(budget: number): Promise<number> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    const identity = this.producerIdentity(config);
    const rawRunKey = createVideoTranscriptionRunKey(identity);
    const isolatedRunKey = createVideoTranscriptionRunKey({
      ...identity,
      voiceIsolation: AI_VIDEO_TRANSCRIPTION_VOICE_ISOLATION,
    });
    const retryableBefore = new Date(Date.now() - TRANSCRIPTION_FAILURE_RETRY_COOLDOWN_MS).toISOString();

    let scheduled = 0;
    let afterId = await this.jobRepository.getVoiceIsolationBackfillCursor();
    while (scheduled < budget) {
      const page = await this.transcriptionRepository.streamVoiceIsolationCandidates({
        rawRunKey,
        isolatedRunKey,
        limit: Math.min(250, budget - scheduled),
        afterId,
        retryableBefore,
      });
      if (page.length === 0) {
        // Reached the end of the library: restart from the head next time so
        // newly completed raw runs with lower ids are not skipped forever.
        await this.jobRepository.setVoiceIsolationBackfillCursor(null);
        return scheduled;
      }

      for (const candidate of page) {
        afterId = candidate.id;
        const baseline = this.parseTranscriptDocument(candidate.transcriptValue)?.runs[rawRunKey];
        if (!baseline || baseline.status !== 'completed' || baseline.noAudio) {
          continue;
        }
        const evidence = buildVoiceIsolationEvidence(this.parseAudioEvents(candidate.audioEventsValue)?.events ?? []);
        const decision = evaluateVoiceIsolationGate({
          noSpeech: baseline.noSpeech === true,
          meanAvgLogProb: baseline.quality?.meanAvgLogProb,
          languageProbability: baseline.languageProbability,
          evidence,
          thresholds: {
            minSpeechScore: config.voiceIsolationMinSpeechScore,
            minSpeechMs: config.voiceIsolationMinSpeechMs,
            musicDominanceRatio: config.voiceIsolationMusicDominanceRatio,
            musicExclusion: config.voiceIsolationMusicExclusion,
          },
        });
        if (!decision.isolate) {
          continue;
        }
        await this.jobRepository.queue({
          name: JobName.AssetTranscribeVideo,
          data: { id: candidate.id, priority: 3, trigger: 'reconcile', mode: 'isolation' },
        });
        scheduled++;
        if (scheduled >= budget) {
          break;
        }
      }

      // Persist the keyset position after every page, including a page that
      // was fully gate-excluded, so the next run resumes past it.
      await this.jobRepository.setVoiceIsolationBackfillCursor(afterId ?? null);
    }
    return scheduled;
  }

  /** Queue the deduplicated backlog sweep; returns immediately. */
  async queueVoiceIsolationBackfill(): Promise<{ queued: boolean; budget: number }> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    const budget = this.voiceIsolationBackfillBudget();
    if (!config.enabled || !config.voiceIsolationUrl || !config.voiceIsolationEnabled) {
      return { queued: false, budget };
    }
    await this.jobRepository.queue({ name: JobName.VoiceIsolationBackfill });
    return { queued: true, budget };
  }

  private voiceIsolationBackfillBudget(): number {
    const { dualGpu, voiceIsolationBackfillBudget } = this.configRepository.getEnv().aiVideoTranscription;
    return dualGpu
      ? Math.min(DUAL_GPU_ISOLATION_BUDGET_CAP, voiceIsolationBackfillBudget)
      : voiceIsolationBackfillBudget;
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
    const retryableBefore = new Date(Date.now() - TRANSCRIPTION_FAILURE_RETRY_COOLDOWN_MS).toISOString();

    let enqueued = 0;
    for await (const assets of batched(this.assetJobRepository.streamForTranscriptionReconcile(), 500)) {
      for (const asset of assets) {
        if (enqueued >= budget) {
          return enqueued;
        }
        const decision = this.needsTranscriptionWork(
          asset.transcriptValue,
          runKey,
          legacyRunKey,
          staleQueuedBefore,
          retryableBefore,
        );
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
    retryableBefore: string,
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
        // Media-level failures are terminal for the sweep: invalid media stays
        // visible for operator retry instead of churning through reconciliation
        // forever. Service-level failures (endpoint/network/parse) re-enter the
        // sweep once the cool-down has elapsed — a failed retry refreshes
        // finishedAt, so an outage costs ≤1 attempt per day.
        const code = current.error?.code;
        if (
          !code ||
          !RETRYABLE_TRANSCRIPTION_ERROR_CODES.has(code) ||
          current.finishedAt === undefined ||
          current.finishedAt >= retryableBefore
        ) {
          return { work: false };
        }
        return { work: true };
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
      if (!(error instanceof TranscriptionDeferred)) {
        this.logger.warn(`Chained video transcription failed for asset ${assetId}: ${error}`);
      }
      return await this.latestCompletedRun(assetId);
    }
  }

  private async latestCompletedRun(assetId: string): Promise<AiVideoTranscriptionRun | undefined> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    const document = await this.transcriptionRepository.get(assetId);
    return (
      this.transcriptionRepository.findLatestCompletedRun(document ?? { schemaVersion: 1, runs: {} }, {
        voiceIsolationEnabled: config.voiceIsolationEnabled,
      }) ?? undefined
    );
  }

  /** Probe → claim → extract audio → sidecar transcription → complete/fail. */
  private async transcribeRun(
    assetId: string,
    originalPath: string,
    runKey: string,
    trigger: AiVideoTranscriptionTrigger,
    options: {
      voiceIsolation?: boolean;
      baseline?: AiVideoTranscriptionRun;
      fromQueue?: boolean;
      isolationOnly?: boolean;
    } = {},
  ): Promise<void> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    const voiceIsolation = options.voiceIsolation === true ? AI_VIDEO_TRANSCRIPTION_VOICE_ISOLATION : undefined;
    const requestClass: TranscriptionRequestClass | undefined = config.dualGpu
      ? options.isolationOnly || trigger === 'reconcile'
        ? 'backfill'
        : 'live'
      : undefined;
    const stageOptions = requestClass ? { requestClass } : {};
    const lease = { ownerId: randomUUID(), leaseMs: (voiceIsolation ? 2 : 1) * config.timeoutMs + LEASE_SLACK_MS };
    const yieldToLive = async () => {
      if (
        requestClass === 'backfill' &&
        options.fromQueue &&
        (await this.jobRepository.hasWaitingLiveTranscription())
      ) {
        throw new TranscriptionDeferred('live_waiting');
      }
    };
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
          config: { language: config.language, ...(voiceIsolation && { voiceIsolation }) },
          durationMs,
          trigger,
          producer: {
            service: AI_VIDEO_TRANSCRIPTION_SERVICE,
            model: config.model,
            producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
            language: config.language,
            coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
            ...(voiceIsolation && { voiceIsolation }),
          },
          targetDurationMs: durationMs,
          chunks: buildTranscriptionChunkPlan(durationMs, config.chunkDurationSec),
          ...(options.fromQueue && { resumeQueued: true }),
        },
        lease,
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
      let producedSegments = claim.run.segments.length;
      let language: string | undefined;
      let languageProbability: number | undefined;
      let logProbSum = 0;
      let logProbCount = 0;
      let speechRatio: number | undefined;
      const addEvidence = (evidence?: AiVideoTranscriptionChunkEvidence) => {
        if (!evidence) {
          return;
        }
        language ??= evidence.language;
        languageProbability ??= evidence.languageProbability;
        if (evidence.meanAvgLogProb !== undefined) {
          const weight = Math.max(1, evidence.segmentCount);
          logProbSum += evidence.meanAvgLogProb * weight;
          logProbCount += weight;
        }
        speechRatio ??= evidence.speechRatio;
      };

      for (const chunk of chunks) {
        if (chunk.status === 'completed') {
          addEvidence(chunk.evidence);
          continue;
        }
        await yieldToLive();
        // The extraction window is padded with the overlap so a segment
        // straddling the boundary stays intact; the chunk whose responsibility
        // range contains the segment's absolute start keeps it and the
        // neighbor's copy is discarded (overlap deduplication).
        const windowStartMs = Math.max(0, chunk.startMs - overlapMs);
        const windowEndMs = Math.min(durationMs, chunk.endMs + overlapMs);
        let response: AiVideoTranscriptionResponse;
        try {
          // The isolation lane extracts at 48 kHz (the isolator's native rate)
          // and gets 16 kHz back; the raw lane keeps today's 16 kHz path.
          const chunkPath = await this.mediaRepository.extractVideoAudioChunk(originalPath, tempDir, {
            startSec: windowStartMs / 1000,
            durationSec: (windowEndMs - windowStartMs) / 1000,
            ...(voiceIsolation && { sampleRate: 48_000 }),
          });
          const extracted = await readFile(chunkPath);
          await yieldToLive();
          const audio = voiceIsolation
            ? await this.client.isolateVoice(extracted, { outputSampleRate: 16_000, ...stageOptions })
            : extracted;
          if (voiceIsolation) {
            await yieldToLive();
          }
          response = await this.client.transcribe(audio, { language: config.language || undefined, ...stageOptions });
        } catch (error) {
          if (error instanceof TranscriptionDeferred) {
            throw error;
          }
          if (error instanceof AiVideoTranscriptionClientError && error.code === 'gpu_capacity') {
            throw new TranscriptionDeferred('gpu_capacity');
          }
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
        const evidence = {
          language: response.language,
          languageProbability: response.languageProbability,
          segmentCount: response.diagnostics?.segmentCount ?? response.segments.length,
          meanAvgLogProb: response.diagnostics?.meanAvgLogProb,
          speechRatio: response.diagnostics?.speechRatio,
        };
        await this.transcriptionRepository.completeChunk(
          assetId,
          runKey,
          chunk.index,
          segments,
          { startMs: windowStartMs, endMs: windowEndMs },
          ...(voiceIsolation || config.dualGpu ? ([{ evidence }] as const) : []),
        );
        await this.transcriptionRepository.renewLease(assetId, runKey, lease.ownerId, lease.leaseMs);
        producedSegments += segments.length;
        addEvidence(evidence);
      }

      const meanAvgLogProb = logProbCount > 0 ? Math.round((logProbSum / logProbCount) * 1000) / 1000 : undefined;
      const isolatedAccepted = voiceIsolation
        ? acceptsIsolatedTranscript({
            segments: producedSegments,
            meanAvgLogProb,
            languageProbability,
            language,
            baselineLanguage: options.baseline?.language,
            baselineLanguageProbability: options.baseline?.languageProbability,
          })
        : undefined;

      await this.transcriptionRepository.complete(assetId, runKey, {
        language,
        languageProbability,
        // Successful decode of every chunk without a single usable segment
        // establishes no-speech; nothing here can be confused with an
        // extraction failure (those throw before this point).
        noSpeech: producedSegments === 0 || undefined,
        metrics: this.metrics(startedAt),
        quality: { meanAvgLogProb, speechRatio },
        ...(voiceIsolation && { voiceIsolation: { accepted: isolatedAccepted === true } }),
      });
      if (voiceIsolation) {
        const outcome = isolatedAccepted === true ? 'accepted' : 'rejected';
        const durationMs = Date.now() - startedAt.getTime();
        this.telemetryRepository.jobs.recordCounter(VOICE_ISOLATION_RUN_METRIC, 1, { outcome });
        this.telemetryRepository.jobs.recordHistogram(VOICE_ISOLATION_DURATION_METRIC, durationMs, { outcome });
        this.logger.log(`Voice isolation ${outcome} for asset ${assetId} in ${durationMs}ms`);
      }
      await this.enqueueIndexSync(assetId);
      this.logger.log(
        `Transcribed video asset ${assetId} (${producedSegments === 0 ? 'no speech' : `${producedSegments} segments`} across ${chunks.length} chunk(s), language: ${language ?? 'unknown'}) in ${Date.now() - startedAt.getTime()}ms`,
      );
    } catch (error) {
      if (error instanceof TranscriptionDeferred) {
        await this.transcriptionRepository.releaseLease(assetId, runKey, lease.ownerId, options.fromQueue === true);
        throw error;
      }
      const transcriptionError: AiVideoTranscriptionError =
        error instanceof AiVideoTranscriptionClientError
          ? { code: error.code, message: error.message }
          : { code: 'internal_error', message: error instanceof Error ? error.message : String(error) };
      this.logger.warn(
        `Video transcription failed for asset ${assetId}: ${transcriptionError.code} — ${transcriptionError.message}`,
      );
      await this.transcriptionRepository.fail(assetId, runKey, transcriptionError);
      if (voiceIsolation) {
        this.telemetryRepository.jobs.recordCounter(VOICE_ISOLATION_RUN_METRIC, 1, { outcome: 'failed' });
      }
      // Rethrow: the document records the failure, and the queue job must end
      // up failed (BullMQ retry/backoff), not silently successful. The
      // interpretation chain catches in transcribeIfMissing instead.
      throw error;
    } finally {
      await rm(tempDir, { recursive: true, force: true }).catch(() => void 0);
    }
  }

  /** Backlog delivery: resolve the completed raw run, then run only the second pass. */
  private async runVoiceIsolationOnly(assetId: string, trigger: AiVideoTranscriptionTrigger): Promise<void> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    if (!config.voiceIsolationUrl || !config.voiceIsolationEnabled) {
      return;
    }
    const [asset] = await this.assetRepository.getByIds([assetId]);
    if (!asset || asset.type !== AssetType.Video) {
      return;
    }
    const rawRunKey = createVideoTranscriptionRunKey(this.producerIdentity(config));
    await this.maybeRunVoiceIsolation(assetId, asset.originalPath, rawRunKey, trigger, {
      fromQueue: true,
      isolationOnly: true,
    });
  }

  private parseTranscriptDocument(value: unknown): AiVideoTranscriptionDocument | null {
    if (value === null || value === undefined) {
      return null;
    }
    try {
      return AiVideoTranscriptionDocumentSchema.parse(value);
    } catch {
      return null;
    }
  }

  private parseAudioEvents(value: unknown): AiAudioEventsRun | null {
    if (value === null || value === undefined) {
      return null;
    }
    try {
      return this.eventsRepository.findLatestCompletedRun(AiAudioEventsDocumentSchema.parse(value));
    } catch {
      return null;
    }
  }

  /**
  Gated voice-isolation second pass (experiment 2026-11-19).

  Runs only when the raw-audio run looks untrustworthy and — for a completely
  empty transcript — YAMNet already heard speech. On the 22-clip bench that
  combination recovered 3 transcripts and improved 4 while leaving the 7
  already-good clips and the music-only controls untouched. The isolated run is
  stored under its own producer identity; it becomes the effective transcript
  only when it passes acceptance (see `acceptsIsolatedTranscript`).

  Genuine second-pass failures leave the raw transcript in place. Only the
  scheduler's deferral signal propagates to the caller.
  */
  private async maybeRunVoiceIsolation(
    assetId: string,
    originalPath: string,
    baselineRunKey: string,
    trigger: AiVideoTranscriptionTrigger,
    options: { fromQueue?: boolean; isolationOnly?: boolean } = {},
  ): Promise<void> {
    const config = this.configRepository.getEnv().aiVideoTranscription;
    if (!config.voiceIsolationUrl || !config.voiceIsolationEnabled) {
      return;
    }

    const document = await this.transcriptionRepository.get(assetId);
    const baseline = document?.runs[baselineRunKey];
    if (!baseline || baseline.status !== 'completed' || baseline.noAudio) {
      return;
    }

    const isolatedRunKey = createVideoTranscriptionRunKey({
      ...this.producerIdentity(config),
      voiceIsolation: AI_VIDEO_TRANSCRIPTION_VOICE_ISOLATION,
    });
    const existing = document?.runs[isolatedRunKey];
    if (existing) {
      // A completed pass (accepted or rejected) is terminal: reconciliation,
      // job retries, and repeated triggers never execute it again.
      if (isRunActive(existing) && !(options.fromQueue && existing.status === 'queued' && existing.startedAt)) {
        return;
      }
      // Old partials cannot produce a comparable verdict without evidence
      // from their completed chunks. Leave them untouched in dual mode.
      if (config.dualGpu && existing.chunks?.some((chunk) => chunk.status === 'completed' && !chunk.evidence)) {
        this.logger.warn(`Dual GPU skipped legacy partial isolation run for ${assetId}: missing chunk evidence`);
        return;
      }
      // Failed passes retry only after the same cool-down the raw sweep uses,
      // so a broken sidecar is not re-probed on every reconcile delivery.
      if (existing.status === 'failed' && existing.finishedAt !== undefined) {
        const retryableAt = Date.parse(existing.finishedAt) + TRANSCRIPTION_FAILURE_RETRY_COOLDOWN_MS;
        if (retryableAt > Date.now()) {
          return;
        }
      }
    }

    const evidence = await this.voiceIsolationEvidence(assetId);
    const decision = evaluateVoiceIsolationGate({
      noSpeech: baseline.noSpeech === true,
      meanAvgLogProb: baseline.quality?.meanAvgLogProb,
      languageProbability: baseline.languageProbability,
      evidence,
      thresholds: {
        minSpeechScore: config.voiceIsolationMinSpeechScore,
        minSpeechMs: config.voiceIsolationMinSpeechMs,
        musicDominanceRatio: config.voiceIsolationMusicDominanceRatio,
        musicExclusion: config.voiceIsolationMusicExclusion,
      },
    });
    this.recordVoiceIsolationGate(decision.reason);
    if (!decision.isolate) {
      this.logger.debug(
        `Voice isolation skipped for asset ${assetId} (${decision.reason}): ` +
          `noSpeech=${baseline.noSpeech === true}, meanAvgLogProb=${baseline.quality?.meanAvgLogProb ?? 'n/a'}, ` +
          `languageProbability=${baseline.languageProbability ?? 'n/a'}, ` +
          `speechMs=${evidence.speechMs}, speechPeak=${evidence.speechPeak}, musicMs=${evidence.musicMs}`,
      );
      return;
    }

    this.logger.log(
      `Voice isolation second pass for asset ${assetId}: first pass unreliable ` +
        `(noSpeech=${baseline.noSpeech === true}, meanAvgLogProb=${baseline.quality?.meanAvgLogProb ?? 'n/a'}, ` +
        `languageProbability=${baseline.languageProbability ?? 'n/a'}, ` +
        `speechMs=${evidence.speechMs}, speechPeak=${evidence.speechPeak}, musicMs=${evidence.musicMs})`,
    );
    try {
      await this.transcribeRun(assetId, originalPath, isolatedRunKey, trigger, {
        voiceIsolation: true,
        baseline,
        ...options,
      });
    } catch (error) {
      if (error instanceof TranscriptionDeferred) {
        throw error;
      }
      // The isolated run already recorded its own failure; the raw transcript
      // stays authoritative, so this must not fail the queue job.
      this.logger.warn(`Voice isolation second pass failed for asset ${assetId}: ${error}`);
    }
  }

  /** Sustained speech/music evidence from the latest completed audio-event run. */
  private async voiceIsolationEvidence(assetId: string) {
    const document = await this.eventsRepository.get(assetId).catch(() => null);
    const run = document ? this.eventsRepository.findLatestCompletedRun(document) : null;
    return buildVoiceIsolationEvidence(run?.events ?? []);
  }

  /** Gate decisions carry a fixed reason label so dashboards can split them. */
  private recordVoiceIsolationGate(reason: VoiceIsolationGateReason): void {
    this.telemetryRepository.jobs.recordCounter(VOICE_ISOLATION_GATE_METRIC, 1, { reason });
  }

  private producerIdentity(config: { model: string; language: string }): AiVideoTranscriptionProducerIdentity {
    return {
      model: config.model,
      producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
      language: config.language,
      coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
    };
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
    const isolatedRunKey = createVideoTranscriptionRunKey({
      model: config.model,
      producerVersion: AI_VIDEO_TRANSCRIPTION_PRODUCER_VERSION,
      language: config.language,
      coveragePolicy: AI_VIDEO_TRANSCRIPTION_COVERAGE_POLICY,
      voiceIsolation: AI_VIDEO_TRANSCRIPTION_VOICE_ISOLATION,
    });
    return this.transcriptionRepository.getCoverageCounts(runKey, legacyRunKey, TRANSCRIPT_INDEX_VERSION, {
      isolatedRunKey,
      voiceIsolationEnabled: config.voiceIsolationEnabled,
    });
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
}
