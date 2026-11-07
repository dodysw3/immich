import z from 'zod';

/**
Experimental per-video speech transcription (faster-whisper CPU sidecar on
:51905), stored in asset_metadata under the `video-transcripts-v1` key.
Deliberately its own document so transcripts can be wiped/shown later without
touching captions (`video-captions-v1`) or interpretation (`ai-interpretation-v1`).
*/

export const AiVideoTranscriptionRunStatusSchema = z.enum(['queued', 'running', 'completed', 'failed']);
export type AiVideoTranscriptionRunStatus = z.infer<typeof AiVideoTranscriptionRunStatusSchema>;

export const AiVideoTranscriptionTriggerSchema = z.enum(['manual', 'auto-interpret']);
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
    /** True when the audio was longer than maxDurationSec and only the head was transcribed. */
    truncated: z.boolean().optional(),
    segments: z.array(AiVideoTranscriptionSegmentSchema),
    error: AiVideoTranscriptionErrorSchema.optional(),
    metrics: AiVideoTranscriptionMetricsSchema.optional(),
  })
  .superRefine((run, ctx) => {
    if (run.status === 'completed' && run.segments.length === 0 && !run.noAudio) {
      ctx.addIssue({
        code: 'custom',
        message: 'Completed runs must include at least one segment or noAudio',
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
    schemaVersion: z.literal(1),
    runs: z.record(z.string().regex(/^[a-f0-9]{64}$/), AiVideoTranscriptionRunSchema),
  })
  .meta({ id: 'AiVideoTranscriptionDocument' });

export type AiVideoTranscriptionDocument = z.infer<typeof AiVideoTranscriptionDocumentSchema>;
export type AiVideoTranscriptionMetrics = z.infer<typeof AiVideoTranscriptionMetricsSchema>;
export type AiVideoTranscriptionError = z.infer<typeof AiVideoTranscriptionErrorSchema>;
