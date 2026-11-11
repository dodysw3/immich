import z from 'zod';

/**
Per-video environmental-sound events from the YAMNet tagging sidecar (:51906),
stored in asset_metadata under the `video-audio-events-v1` key. Deliberately
its own document, like `video-transcripts-v1`, so events can be wiped or
re-tagged without touching captions, transcripts, or interpretation.
*/

export const AiAudioEventsRunStatusSchema = z.enum(['queued', 'running', 'completed', 'failed']);
export type AiAudioEventsRunStatus = z.infer<typeof AiAudioEventsRunStatusSchema>;

export const AiAudioEventsTriggerSchema = z.enum(['manual', 'auto-interpret']);
export type AiAudioEventsTrigger = z.infer<typeof AiAudioEventsTriggerSchema>;

const AiAudioEventsConfigSchema = z
  .object({
    /** Minimum frame score for a class to count as an event (assembly threshold). */
    threshold: z.number().min(0).max(1),
  })
  .meta({ id: 'AiAudioEventsConfig' });

const AiAudioEventSchema = z
  .object({
    /** AudioSet machine id (e.g. /m/09x0r) — stable even if a display label changes. */
    mid: z.string().min(1),
    /** AudioSet display name at tagging time, e.g. "Beep, bleep". */
    label: z.string().min(1),
    /** Highest frame score inside the span. */
    score: z.number().min(0).max(1),
    startMs: z.int().nonnegative(),
    endMs: z.int().positive(),
  })
  .meta({ id: 'AiAudioEvent' });
export type AiAudioEvent = z.infer<typeof AiAudioEventSchema>;

const AiAudioEventsMetricsSchema = z
  .object({
    durationMs: z.int().nonnegative(),
    /** Sidecar inference time and frame count, when the sidecar was called. */
    inferMs: z.int().nonnegative().optional(),
    frameCount: z.int().nonnegative().optional(),
  })
  .meta({ id: 'AiAudioEventsMetrics' });

const AiAudioEventsErrorSchema = z
  .object({
    code: z.string().min(1),
    message: z.string().min(1),
  })
  .meta({ id: 'AiAudioEventsError' });

const AiAudioEventsRunSchema = z
  .object({
    model: z.string().min(1),
    promptVersion: z.string().min(1),
    status: AiAudioEventsRunStatusSchema,
    /** 'manual' = reserved for a future trigger, 'auto-interpret' = chained from the AI interpretation job. */
    trigger: AiAudioEventsTriggerSchema,
    requestedAt: z.iso.datetime({ offset: true }),
    startedAt: z.iso.datetime({ offset: true }).optional(),
    finishedAt: z.iso.datetime({ offset: true }).optional(),
    config: AiAudioEventsConfigSchema,
    /** Video duration in ms as measured by the probe. */
    durationMs: z.int().nonnegative().optional(),
    /** True when the video has no audio stream at all (completed, zero events). */
    noAudio: z.boolean().optional(),
    /** True when the audio was longer than maxDurationSec and only the head was tagged. */
    truncated: z.boolean().optional(),
    /** True when speech-family events were dropped because the transcript had segments at tagging time. */
    speechSuppressed: z.boolean().optional(),
    /** Completed with zero events is legal: a silent video (or only sub-threshold sound). */
    events: z.array(AiAudioEventSchema),
    error: AiAudioEventsErrorSchema.optional(),
    metrics: AiAudioEventsMetricsSchema.optional(),
  })
  .superRefine((run, ctx) => {
    if (run.status === 'failed' && !run.error) {
      ctx.addIssue({ code: 'custom', message: 'Failed runs must include an error', path: ['error'] });
    }
  })
  .meta({ id: 'AiAudioEventsRun' });

export type AiAudioEventsRun = z.infer<typeof AiAudioEventsRunSchema>;

export const AiAudioEventsDocumentSchema = z
  .object({
    schemaVersion: z.literal(1),
    runs: z.record(z.string().regex(/^[a-f0-9]{64}$/), AiAudioEventsRunSchema),
  })
  .meta({ id: 'AiAudioEventsDocument' });

export type AiAudioEventsDocument = z.infer<typeof AiAudioEventsDocumentSchema>;
export type AiAudioEventsMetrics = z.infer<typeof AiAudioEventsMetricsSchema>;
export type AiAudioEventsError = z.infer<typeof AiAudioEventsErrorSchema>;
