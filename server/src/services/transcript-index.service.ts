import { Injectable } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { OnJob } from 'src/decorators.js';
import {
  AiVideoTranscriptionDocument,
  AiVideoTranscriptionDocumentSchema,
  AiVideoTranscriptionRun,
} from 'src/dtos/ai-video-transcription.dto.js';
import { JobName, JobStatus, QueueName } from 'src/enum.js';
import { AiVideoTranscriptionRepository } from 'src/repositories/ai-video-transcription.repository.js';
import { AssetJobRepository } from 'src/repositories/asset-job.repository.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { JobRepository } from 'src/repositories/job.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { TranscriptIndexRepository } from 'src/repositories/transcript-index.repository.js';
import type { JobOf } from 'src/types.js';
import {
  classifyTranscriptionRun,
  createLegacyVideoTranscriptionRunKey,
  createTranscriptionRevision,
  createVideoTranscriptionRunKey,
} from 'src/utils/ai-video-transcription.js';
import { batched } from 'src/utils/misc.js';
import { TRANSCRIPT_INDEX_VERSION, planTranscriptPassages } from 'src/utils/transcript-index.js';

/** Max enqueue budget per index-reconciliation sweep. */
const INDEX_RECONCILE_ENQUEUE_BUDGET = 2000;

/**
Derived transcript search index. Indexes completed usable transcripts
(existing, legacy-partial, and freshly produced alike) into passages + tokens
WITHOUT ever calling Whisper: the source is the stored
`video-transcripts-v1` metadata, and this service has no inference client.
Indexing failure marks the state row and preserves source metadata; the
reconciliation sweep repairs missing/stale rows (revision or index-version
mismatch) with bounded enqueueing.
*/
@Injectable()
export class TranscriptIndexService {
  constructor(
    private logger: LoggingRepository,
    private configRepository: ConfigRepository,
    private jobRepository: JobRepository,
    private assetJobRepository: AssetJobRepository,
    private indexRepository: TranscriptIndexRepository,
    private transcriptionRepository: AiVideoTranscriptionRepository,
  ) {
    this.logger.setContext(TranscriptIndexService.name);
  }

  @Cron('7,22,37,52 * * * *')
  async reconcilePeriodically() {
    if (!this.configRepository.getEnv().aiVideoTranscription.enabled) {
      return;
    }
    await this.jobRepository.queue({ name: JobName.TranscriptIndexReconcile });
  }

  @OnJob({ name: JobName.TranscriptIndexReconcile, queue: QueueName.TranscriptIndexSync })
  async handleReconcile(): Promise<JobStatus> {
    if (!this.configRepository.getEnv().aiVideoTranscription.enabled) {
      return JobStatus.Skipped;
    }
    let enqueued = 0;
    for await (const rows of batched(this.assetJobRepository.streamForTranscriptIndexReconcile(), 500)) {
      for (const row of rows) {
        if (enqueued >= INDEX_RECONCILE_ENQUEUE_BUDGET) {
          this.logger.log(`Transcript index reconciliation enqueued ${enqueued} asset(s) (budget reached)`);
          return JobStatus.Success;
        }
        if (!this.isStale(row.transcriptValue, row.indexedRevision, row.indexedVersion, row.indexedError)) {
          continue;
        }
        await this.jobRepository.queue({ name: JobName.TranscriptIndexSync, data: { id: row.assetId } });
        enqueued++;
      }
    }
    if (enqueued > 0) {
      this.logger.log(`Transcript index reconciliation enqueued ${enqueued} asset(s)`);
    }
    return JobStatus.Success;
  }

  @OnJob({ name: JobName.TranscriptIndexSync, queue: QueueName.TranscriptIndexSync })
  async handleIndexSync({ id: assetId }: JobOf<JobName.TranscriptIndexSync>): Promise<JobStatus> {
    const indexed = await this.syncAsset(assetId);
    if (indexed) {
      return JobStatus.Success;
    }
    // Nothing usable to index (no completed run): a skip, not a failure.
    return JobStatus.Skipped;
  }

  /**
  Index one asset from its stored transcript document. Returns true when a
  usable completed run was indexed. Pure DB + CPU work — no Whisper, no
  sidecar, no interpretation access.
  */
  async syncAsset(assetId: string): Promise<boolean> {
    const document = await this.transcriptionRepository.get(assetId);
    if (!document) {
      return false;
    }
    const run = AiVideoTranscriptionRepository.prototype.findLatestCompletedRun.call(null, document);
    if (!run) {
      return false;
    }

    const revision = run.revision ?? createTranscriptionRevision(run);
    const state = await this.indexRepository.getState(assetId);
    if (
      state &&
      state.error === null &&
      state.revision === revision &&
      state.indexVersion === TRANSCRIPT_INDEX_VERSION
    ) {
      return true;
    }

    const coverageState = classifyTranscriptionRun(run);
    const passages = planTranscriptPassages(run.segments);
    try {
      await this.indexRepository.replacePassages(assetId, {
        revision,
        runKey: this.runKeyOf(run),
        indexVersion: TRANSCRIPT_INDEX_VERSION,
        coverageState,
        segmentCount: run.segments.length,
        passages,
      });
    } catch (error) {
      // Source metadata is untouched by design; record the failure for the
      // operator and let reconciliation retry the derived work.
      this.logger.warn(`Transcript indexing failed for asset ${assetId}: ${error}`);
      await this.indexRepository
        .markFailed(
          assetId,
          this.runKeyOf(run),
          TRANSCRIPT_INDEX_VERSION,
          error instanceof Error ? error.message : String(error),
        )
        .catch(() => void 0);
      throw error;
    }
    this.logger.debug(
      `Indexed transcript for asset ${assetId} (${passages.length} passage(s), coverage ${coverageState}, revision ${revision.slice(0, 8)})`,
    );
    return true;
  }

  /** True when the stored transcript needs (re)indexing. */
  private isStale(
    transcriptValue: unknown,
    indexedRevision: string | null,
    indexedVersion: number | null,
    indexedError: string | null,
  ): boolean {
    if (indexedRevision === null || indexedError !== null || indexedVersion !== TRANSCRIPT_INDEX_VERSION) {
      return true;
    }
    const document = this.parseDocument(transcriptValue);
    if (!document) {
      // Unparseable source: leave an existing index as-is rather than drop it.
      return false;
    }
    const run = AiVideoTranscriptionRepository.prototype.findLatestCompletedRun.call(null, document);
    if (!run) {
      return false;
    }
    // A revision change under the same runKey (retry produced new content)
    // must re-index even though the state row exists.
    return (run.revision ?? createTranscriptionRevision(run)) !== indexedRevision;
  }

  /** The run's identity key: chunked runs carry their producer; legacy runs hash model+promptVersion. */
  private runKeyOf(run: AiVideoTranscriptionRun): string {
    return run.producer
      ? createVideoTranscriptionRunKey({
          model: run.producer.model,
          producerVersion: run.producer.producerVersion,
          language: run.producer.language,
          coveragePolicy: run.producer.coveragePolicy,
        })
      : createLegacyVideoTranscriptionRunKey(run.model, run.promptVersion);
  }

  private parseDocument(value: unknown): AiVideoTranscriptionDocument | null {
    if (value === null || value === undefined) {
      return null;
    }
    try {
      return AiVideoTranscriptionDocumentSchema.parse(value);
    } catch {
      return null;
    }
  }
}
