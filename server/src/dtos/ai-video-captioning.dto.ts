import z from 'zod';

/**
Experimental per-video captioning documents (LFM3-VL-2B), stored in
asset_metadata under the `video-captions-v1` key. Deliberately separate
from the `ai-interpretation-v1` document so the experiment can be
reverted or its metadata wiped without touching interpretation runs.
*/

export const AiVideoCaptionRunStatusSchema = z.enum(['queued', 'running', 'completed', 'failed']);
export type AiVideoCaptionRunStatus = z.infer<typeof AiVideoCaptionRunStatusSchema>;

const AiVideoCaptionConfigSchema = z
  .object({
    segmentSeconds: z.int().positive(),
    framesPerSegment: z.int().positive(),
    frameEdge: z.int().positive(),
    maxDurationSec: z.int().positive(),
    language: z.string().min(1),
    /** Adaptive (change-driven) window planning; absent = fixed grid. */
    adaptive: z.boolean().optional(),
    /** Probe fps the change signal was measured at (adaptive runs only). */
    probeFps: z.number().positive().optional(),
    /** Adaptive window bounds in seconds (adaptive runs only). */
    minSegmentSeconds: z.number().positive().optional(),
    maxSegmentSeconds: z.number().positive().optional(),
  })
  .meta({ id: 'AiVideoCaptionConfig' });

const AiVideoCaptionSegmentSchema = z
  .object({
    startMs: z.int().nonnegative(),
    endMs: z.int().positive(),
    caption: z.string().min(1),
  })
  .meta({ id: 'AiVideoCaptionSegment' });
export type AiVideoCaptionSegment = z.infer<typeof AiVideoCaptionSegmentSchema>;

const AiVideoCaptionMetricsSchema = z
  .object({
    durationMs: z.int().nonnegative(),
    promptTokens: z.int().nonnegative().optional(),
    completionTokens: z.int().nonnegative().optional(),
  })
  .meta({ id: 'AiVideoCaptionMetrics' });

const AiVideoCaptionErrorSchema = z
  .object({
    code: z.string().min(1),
    message: z.string().min(1),
  })
  .meta({ id: 'AiVideoCaptionError' });

const AiVideoCaptionTriggerSchema = z.enum(['manual', 'auto-interpret']);
export type AiVideoCaptionTrigger = z.infer<typeof AiVideoCaptionTriggerSchema>;

const AiVideoCaptionRunSchema = z
  .object({
    model: z.string().min(1),
    /** Model id reported back by the serving endpoint, when it differs from the requested one. */
    servedModel: z.string().min(1).optional(),
    promptVersion: z.string().min(1),
    status: AiVideoCaptionRunStatusSchema,
    /** 'manual' = viewer menu action, 'auto-interpret' = chained from the AI interpretation job. */
    trigger: AiVideoCaptionTriggerSchema,
    requestedAt: z.iso.datetime({ offset: true }),
    startedAt: z.iso.datetime({ offset: true }).optional(),
    finishedAt: z.iso.datetime({ offset: true }).optional(),
    config: AiVideoCaptionConfigSchema,
    /** Video duration in ms as recorded on the asset, for sidebar timeline scaling. */
    durationMs: z.int().nonnegative().optional(),
    /** True when the video is longer than config.maxDurationSec and only the head was captioned. */
    truncated: z.boolean().optional(),
    segments: z.array(AiVideoCaptionSegmentSchema),
    error: AiVideoCaptionErrorSchema.optional(),
    metrics: AiVideoCaptionMetricsSchema.optional(),
  })
  .superRefine((run, ctx) => {
    if (run.status === 'completed' && run.segments.length === 0) {
      ctx.addIssue({ code: 'custom', message: 'Completed runs must include at least one segment', path: ['segments'] });
    }
    if (run.status === 'failed' && !run.error) {
      ctx.addIssue({ code: 'custom', message: 'Failed runs must include an error', path: ['error'] });
    }
  })
  .meta({ id: 'AiVideoCaptionRun' });

export type AiVideoCaptionRun = z.infer<typeof AiVideoCaptionRunSchema>;

export const AiVideoCaptionDocumentSchema = z
  .object({
    schemaVersion: z.literal(1),
    runs: z.record(z.string().regex(/^[a-f0-9]{64}$/), AiVideoCaptionRunSchema),
  })
  .meta({ id: 'AiVideoCaptionDocument' });

export type AiVideoCaptionDocument = z.infer<typeof AiVideoCaptionDocumentSchema>;
export type AiVideoCaptionConfig = z.infer<typeof AiVideoCaptionConfigSchema>;
export type AiVideoCaptionMetrics = z.infer<typeof AiVideoCaptionMetricsSchema>;
export type AiVideoCaptionError = z.infer<typeof AiVideoCaptionErrorSchema>;
