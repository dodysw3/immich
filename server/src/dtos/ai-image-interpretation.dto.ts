import z from 'zod';

export const AiInterpretationRunStatusSchema = z.enum(['queued', 'running', 'completed', 'failed']);
export type AiInterpretationRunStatus = z.infer<typeof AiInterpretationRunStatusSchema>;

const AiInterpretationInputSchema = z
  .object({
    source: z.literal('preview'),
    width: z.int().positive(),
    height: z.int().positive(),
    mimeType: z.literal('image/jpeg'),
  })
  .meta({ id: 'AiInterpretationInput' });

const AiInterpretationMetricsSchema = z
  .object({
    durationMs: z.int().nonnegative(),
    promptTokens: z.int().nonnegative().optional(),
    completionTokens: z.int().nonnegative().optional(),
  })
  .meta({ id: 'AiInterpretationMetrics' });

const AiInterpretationErrorSchema = z
  .object({
    code: z.string().min(1),
    message: z.string().min(1),
  })
  .meta({ id: 'AiInterpretationError' });

export const MuseInterpretationResultSchema = z
  .object({
    title: z.string(),
    literal_description: z.string(),
    visual_analysis: z.string(),
    interpretation: z.string(),
    context_and_significance: z.string(),
    notable_details: z.array(
      z.object({
        detail: z.string(),
        significance: z.string(),
        confidence: z.enum(['high', 'medium', 'low']),
      }),
    ),
    identifications: z.array(
      z.object({
        name: z.string(),
        type: z.enum(['person', 'place', 'artwork', 'object', 'organization', 'other']),
        confidence: z.enum(['high', 'medium', 'low']),
        basis: z.string(),
      }),
    ),
    alternative_interpretations: z.array(z.string()),
    uncertainties: z.array(z.string()),
    archive_summary: z.string(),
    search_keywords: z.array(z.string()),
  })
  .meta({ id: 'MuseInterpretationResult' });

export type MuseInterpretationResult = z.infer<typeof MuseInterpretationResultSchema>;

const AiInterpretationRunSchema = z
  .object({
    model: z.string().min(1),
    quant: z.string().min(1),
    promptVersion: z.string().min(1),
    status: AiInterpretationRunStatusSchema,
    trigger: z.literal('upload'),
    requestedAt: z.iso.datetime({ offset: true }),
    startedAt: z.iso.datetime({ offset: true }).optional(),
    finishedAt: z.iso.datetime({ offset: true }).optional(),
    input: AiInterpretationInputSchema.optional(),
    result: MuseInterpretationResultSchema.optional(),
    error: AiInterpretationErrorSchema.optional(),
    metrics: AiInterpretationMetricsSchema.optional(),
    attempts: z.int().nonnegative().optional(),
    nextAttemptAt: z.iso.datetime({ offset: true }).optional(),
  })
  .superRefine((run, ctx) => {
    if (run.status === 'completed' && !run.result) {
      ctx.addIssue({ code: 'custom', message: 'Completed runs must include a result', path: ['result'] });
    }
    if (run.status === 'failed' && !run.error) {
      ctx.addIssue({ code: 'custom', message: 'Failed runs must include an error', path: ['error'] });
    }
  })
  .meta({ id: 'AiInterpretationRun' });

export type AiInterpretationRun = z.infer<typeof AiInterpretationRunSchema>;

export const AiInterpretationDocumentSchema = z
  .object({
    schemaVersion: z.literal(1),
    runs: z.record(z.string().regex(/^[a-f0-9]{64}$/), AiInterpretationRunSchema),
  })
  .meta({ id: 'AiInterpretationDocument' });

export type AiInterpretationDocument = z.infer<typeof AiInterpretationDocumentSchema>;
export type AiInterpretationInput = z.infer<typeof AiInterpretationInputSchema>;
export type AiInterpretationMetrics = z.infer<typeof AiInterpretationMetricsSchema>;
export type AiInterpretationError = z.infer<typeof AiInterpretationErrorSchema>;

export const MUSE_RESULT_JSON_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  required: [
    'title',
    'literal_description',
    'visual_analysis',
    'interpretation',
    'context_and_significance',
    'notable_details',
    'identifications',
    'alternative_interpretations',
    'uncertainties',
    'archive_summary',
    'search_keywords',
  ],
  properties: {
    title: { type: 'string' },
    literal_description: { type: 'string' },
    visual_analysis: { type: 'string' },
    interpretation: { type: 'string' },
    context_and_significance: { type: 'string' },
    notable_details: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['detail', 'significance', 'confidence'],
        properties: {
          detail: { type: 'string' },
          significance: { type: 'string' },
          confidence: { type: 'string', enum: ['high', 'medium', 'low'] },
        },
      },
    },
    identifications: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        required: ['name', 'type', 'confidence', 'basis'],
        properties: {
          name: { type: 'string' },
          type: { type: 'string', enum: ['person', 'place', 'artwork', 'object', 'organization', 'other'] },
          confidence: { type: 'string', enum: ['high', 'medium', 'low'] },
          basis: { type: 'string' },
        },
      },
    },
    alternative_interpretations: { type: 'array', items: { type: 'string' } },
    uncertainties: { type: 'array', items: { type: 'string' } },
    archive_summary: { type: 'string' },
    search_keywords: { type: 'array', items: { type: 'string' } },
  },
} as const;
