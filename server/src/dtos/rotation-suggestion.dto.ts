import { createZodDto } from 'nestjs-zod';
import z from 'zod';

export const RotationSuggestionStatusSchema = z.enum(['pending', 'applied', 'dismissed']);
export type RotationSuggestionStatus = z.infer<typeof RotationSuggestionStatusSchema>;

export const RotationModelTierSchema = z.enum(['fast', 'balanced']);
export type RotationModelTier = z.infer<typeof RotationModelTierSchema>;

const RotationAngleSchema = z.union([z.literal(0), z.literal(90), z.literal(180), z.literal(270)]);

const RotationSuggestionRunSchema = z
  .object({
    model: z.string().min(1).describe('Orientation model identity that produced this run'),
    tier: RotationModelTierSchema.describe('RightWayUp tier used for inference'),
    // An abstaining run has no rotation class — abstention must never be
    // representable as a fifth rotation value.
    predictedRotation: RotationAngleSchema.nullable().describe('Suggested rotation in degrees clockwise'),
    confidence: z.number().min(0).max(1).meta({ format: 'double' }).describe('Model confidence of the snapped rotation class'),
    abstain: z.boolean().describe('True when the model (or the confidence threshold) declined to suggest'),
    status: RotationSuggestionStatusSchema.describe('Lifecycle status of this suggestion run'),
    startedAt: z.iso.datetime({ offset: true }),
    finishedAt: z.iso.datetime({ offset: true }),
  })
  .superRefine((run, ctx) => {
    if (run.abstain && run.predictedRotation !== null) {
      ctx.addIssue({
        code: 'custom',
        message: 'Abstaining runs must not carry a rotation class',
        path: ['predictedRotation'],
      });
    }
    if (!run.abstain && run.predictedRotation === null) {
      ctx.addIssue({
        code: 'custom',
        message: 'Non-abstaining runs must carry a rotation class',
        path: ['predictedRotation'],
      });
    }
  })
  .meta({ id: 'RotationSuggestionRun' });

export type RotationSuggestionRun = z.infer<typeof RotationSuggestionRunSchema>;

export const RotationSuggestionDocumentSchema = z
  .object({
    schemaVersion: z.literal(1),
    runs: z.record(z.string().regex(/^[a-f0-9]{64}$/), RotationSuggestionRunSchema),
  })
  .meta({ id: 'RotationSuggestionDocument' });

export type RotationSuggestionDocument = z.infer<typeof RotationSuggestionDocumentSchema>;

const RotationSuggestionResponseSchema = z
  .object({
    assetId: z.uuidv4().describe('Asset the suggestion belongs to'),
    runKey: z.string().regex(/^[a-f0-9]{64}$/).describe('Content-hashed identity of the run'),
    model: z.string().min(1),
    tier: RotationModelTierSchema,
    status: RotationSuggestionStatusSchema,
    abstain: z.boolean(),
    predictedRotation: RotationAngleSchema.nullable().describe('Suggested rotation in degrees clockwise (null when abstaining)'),
    confidence: z.number().min(0).max(1).meta({ format: 'double' }),
    startedAt: z.iso.datetime({ offset: true }),
    finishedAt: z.iso.datetime({ offset: true }),
  })
  .meta({ id: 'RotationSuggestionResponseDto' });

export class RotationSuggestionResponseDto extends createZodDto(RotationSuggestionResponseSchema) {}

export const RotationSuggestionListResponseSchema = z
  .array(RotationSuggestionResponseSchema)
  .meta({ id: 'RotationSuggestionListResponseDto' });

export class RotationSuggestionListResponseDto extends createZodDto(RotationSuggestionListResponseSchema) {}

const RotationSuggestionDismissDtoSchema = z
  .object({
    runKey: z.string().regex(/^[a-f0-9]{64}$/).optional().describe('Target a specific run; defaults to the latest run'),
  })
  .default({})
  .meta({ id: 'RotationSuggestionDismissDto' });

export class RotationSuggestionDismissDto extends createZodDto(RotationSuggestionDismissDtoSchema) {}

const RotationSuggestionApplyDtoSchema = RotationSuggestionDismissDtoSchema.meta({ id: 'RotationSuggestionApplyDto' });

export class RotationSuggestionApplyDto extends createZodDto(RotationSuggestionApplyDtoSchema) {}
