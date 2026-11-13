import z from 'zod';

/**
Experimental per-video speech transcription (faster-whisper CPU sidecar on
:51905), stored in asset_metadata under the `video-transcripts-v1` key.
Deliberately its own document so transcripts can be wiped/shown later without
touching captions (`video-captions-v1`) or interpretation (`ai-interpretation-v1`).
*/

export const AiVideoTranscriptionRunStatusSchema = z.enum(['queued', 'running', 'completed', 'failed']);
export type AiVideoTranscriptionRunStatus = z.infer<typeof AiVideoTranscriptionRunStatusSchema>;

export const AiVideoTranscriptionTriggerSchema = z.enum(['manual', 'auto-interpret', 'upload', 'reconcile']);
export type AiVideoTranscriptionTrigger = z.infer<typeof AiVideoTranscriptionTriggerSchema>;

const AiVideoTranscriptionConfigSchema = z
  .object({
    /** ISO 639-1 hint for the transcriber; empty = auto-detect per file. */
    language: z.string(),
  })
  .meta({ id: 'AiVideoTranscriptionConfig' });

const AiVideoTranscriptionSegmentSchema = z
  .object({
    startMs: z.int().nonnegative(),
    endMs: z.int().positive(),
    text: z.string().min(1),
  })
  .meta({ id: 'AiVideoTranscriptionSegment' });
export type AiVideoTranscriptionSegment = z.infer<typeof AiVideoTranscriptionSegmentSchema>;

const AiVideoTranscriptionMetricsSchema = z
  .object({
    durationMs: z.int().nonnegative(),
  })
  .meta({ id: 'AiVideoTranscriptionMetrics' });

const AiVideoTranscriptionErrorSchema = z
  .object({
    code: z.string().min(1),
    message: z.string().min(1),
  })
  .meta({ id: 'AiVideoTranscriptionError' });

/** Absolute video-offset interval (ms) of audio actually fed through the producer. */
export const AiVideoTranscriptionCoverageIntervalSchema = z
  .object({
    startMs: z.int().nonnegative(),
    endMs: z.int().positive(),
  })
  .meta({ id: 'AiVideoTranscriptionCoverageInterval' });
export type AiVideoTranscriptionCoverageInterval = z.infer<typeof AiVideoTranscriptionCoverageIntervalSchema>;

/**
Durable per-chunk progress for bounded audio extraction: a run resumes from
completed chunks instead of re-transcribing the whole video after an
interruption. Timestamps are absolute video offsets.
*/
export const AiVideoTranscriptionChunkSchema = z
  .object({
    index: z.int().nonnegative(),
    startMs: z.int().nonnegative(),
    endMs: z.int().positive(),
    status: z.enum(['pending', 'completed', 'failed']),
    completedAt: z.iso.datetime({ offset: true }).optional(),
    error: AiVideoTranscriptionErrorSchema.optional(),
  })
  .meta({ id: 'AiVideoTranscriptionChunk' });
export type AiVideoTranscriptionChunk = z.infer<typeof AiVideoTranscriptionChunkSchema>;

/**
Full configuration identity that shaped the output. Two runs with different
producer identities are different runs (separate run keys) even when the model
name matches — raised limits, language, or coverage-policy changes must not be
skipped because an older run exists.
*/
export const AiVideoTranscriptionProducerSchema = z
  .object({
    service: z.string().min(1),
    model: z.string().min(1),
    producerVersion: z.string().min(1),
    /** Language hint the run used; empty = auto-detect. */
    language: z.string(),
    coveragePolicy: z.string().min(1),
  })
  .meta({ id: 'AiVideoTranscriptionProducer' });
export type AiVideoTranscriptionProducer = z.infer<typeof AiVideoTranscriptionProducerSchema>;

const AiVideoTranscriptionRunSchema = z
  .object({
    model: z.string().min(1),
    promptVersion: z.string().min(1),
    status: AiVideoTranscriptionRunStatusSchema,
    /** 'manual' = reserved for a future trigger, 'auto-interpret' = chained from the AI interpretation job. */
    trigger: AiVideoTranscriptionTriggerSchema,
    requestedAt: z.iso.datetime({ offset: true }),
    startedAt: z.iso.datetime({ offset: true }).optional(),
    finishedAt: z.iso.datetime({ offset: true }).optional(),
    config: AiVideoTranscriptionConfigSchema,
    /** Video duration in ms as measured by the probe, for future UI scaling. */
    durationMs: z.int().nonnegative().optional(),
    /** Detected source language of the transcription run. */
    language: z.string().min(1).optional(),
    languageProbability: z.number().min(0).max(1).optional(),
    /** True when the video has no audio stream at all (completed, zero segments). */
    noAudio: z.boolean().optional(),
    /** True when the audio contained no usable speech (silence/noise); completed with zero segments. */
    noSpeech: z.boolean().optional(),
    /** True when the audio was longer than maxDurationSec and only the head was transcribed. */
    truncated: z.boolean().optional(),
    segments: z.array(AiVideoTranscriptionSegmentSchema),
    error: AiVideoTranscriptionErrorSchema.optional(),
    metrics: AiVideoTranscriptionMetricsSchema.optional(),
    /**
    Producer identity for runs created by the chunked producer. Legacy runs
    (model + promptVersion only) keep parsing without it.
    */
    producer: AiVideoTranscriptionProducerSchema.optional(),
    /** Full video duration (ms) this run aims to cover, as measured by the probe. */
    targetDurationMs: z.int().positive().optional(),
    /** Intervals of audio actually fed through the producer, for honest coverage. */
    coverage: z.object({ intervals: z.array(AiVideoTranscriptionCoverageIntervalSchema) }).optional(),
    /** Durable chunk progress; completed chunks survive restarts and are reused. */
    chunks: z.array(AiVideoTranscriptionChunkSchema).optional(),
    /**
    Content revision hash over segments + outcome flags. runKey is reused across
    retries and does not identify transcript content; this does.
    */
    revision: z
      .string()
      .regex(/^[a-f0-9]{64}$/)
      .optional(),
    /**
    Worker lease proving an active producer. A running run whose lease is
    missing or expired is abandoned work that another worker may reclaim;
    completed/failed runs never carry one.
    */
    lease: z
      .object({
        ownerId: z.string().min(1),
        expiresAt: z.iso.datetime({ offset: true }),
      })
      .optional(),
  })
  .superRefine((run, ctx) => {
    if (run.status === 'completed' && run.segments.length === 0 && !run.noAudio && !run.noSpeech) {
      ctx.addIssue({
        code: 'custom',
        message: 'Completed runs must include at least one segment, noAudio, or noSpeech',
        path: ['segments'],
      });
    }
    if (run.status === 'failed' && !run.error) {
      ctx.addIssue({ code: 'custom', message: 'Failed runs must include an error', path: ['error'] });
    }
  })
  .meta({ id: 'AiVideoTranscriptionRun' });

export type AiVideoTranscriptionRun = z.infer<typeof AiVideoTranscriptionRunSchema>;

export const AiVideoTranscriptionDocumentSchema = z
  .object({
    /**
    1 = legacy runs (model + promptVersion identity). 2 = chunked producer with
    coverage/producer/revision fields. Both parse; any write upgrades to 2.
    */
    schemaVersion: z.union([z.literal(1), z.literal(2)]),
    runs: z.record(z.string().regex(/^[a-f0-9]{64}$/), AiVideoTranscriptionRunSchema),
  })
  .meta({ id: 'AiVideoTranscriptionDocument' });

export type AiVideoTranscriptionDocument = z.infer<typeof AiVideoTranscriptionDocumentSchema>;
export type AiVideoTranscriptionMetrics = z.infer<typeof AiVideoTranscriptionMetricsSchema>;
export type AiVideoTranscriptionError = z.infer<typeof AiVideoTranscriptionErrorSchema>;

/**
Admin coverage totals over every non-deleted video, per honest coverage
state. Index-side fields are populated by the transcript search index and
read zero until that pipeline has run.
*/
export const TranscriptionCoverageCountsSchema = z
  .object({
    missing: z.int().nonnegative(),
    inProgress: z.int().nonnegative(),
    failed: z.int().nonnegative(),
    partial: z.int().nonnegative(),
    complete: z.int().nonnegative(),
    noAudio: z.int().nonnegative(),
    noSpeech: z.int().nonnegative(),
    indexCurrent: z.int().nonnegative(),
    indexPending: z.int().nonnegative(),
    indexFailed: z.int().nonnegative(),
  })
  .meta({ id: 'TranscriptionCoverageCounts' });
export type TranscriptionCoverageCounts = z.infer<typeof TranscriptionCoverageCountsSchema>;

export const TranscriptionReconcileResponseSchema = z
  .object({ queued: z.boolean() })
  .meta({ id: 'TranscriptionReconcileResponse' });
export type TranscriptionReconcileResponse = z.infer<typeof TranscriptionReconcileResponseSchema>;
