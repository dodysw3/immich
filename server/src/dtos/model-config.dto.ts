import { createZodDto } from 'nestjs-zod';
import z from 'zod';

const TaskConfigSchema = z
  .object({
    enabled: z.boolean().describe('Whether the task is enabled'),
  })
  .meta({ id: 'TaskConfig' });

const ModelConfigSchema = TaskConfigSchema.extend({
  modelName: z.string().describe('Name of the model to use'),
});

export const CLIPConfigSchema = ModelConfigSchema.meta({ id: 'CLIPConfig' });

export const DuplicateDetectionConfigSchema = TaskConfigSchema.extend({
  maxDistance: z
    .number()
    .meta({ format: 'double' })
    .min(0.001)
    .max(0.1)
    .describe('Maximum distance threshold for duplicate detection'),
}).meta({ id: 'DuplicateDetectionConfig' });

export const FacialRecognitionConfigSchema = ModelConfigSchema.extend({
  minScore: z
    .number()
    .meta({ format: 'double' })
    .min(0.1)
    .max(1)
    .describe('Minimum confidence score for face detection'),
  maxDistance: z
    .number()
    .meta({ format: 'double' })
    .min(0.1)
    .max(2)
    .describe('Maximum distance threshold for face recognition'),
  minFaces: z.int().min(1).describe('Minimum number of faces required for recognition'),
  tiling: FaceDetectionTilingConfigSchema,
}).meta({ id: 'FacialRecognitionConfig' });

const FaceDetectionTilingMinDimWithFacesConfigSchema = z
  .object({
    dim: z.int().min(1).describe('Minimum original image dimension to consider tiling'),
    faces: z.int().min(1).describe('Minimum pass-1 face count when original dim threshold is met'),
  })
  .meta({ id: 'FaceDetectionTilingMinDimWithFacesConfig' });

const FaceDetectionTilingTriggersConfigSchema = z
  .object({
    minPass1Faces: z.int().min(1).describe('Minimum pass-1 face count to trigger tiling'),
    minDimWithFaces: FaceDetectionTilingMinDimWithFacesConfigSchema,
  })
  .meta({ id: 'FaceDetectionTilingTriggersConfig' });

const FaceDetectionTilingConfigSchema = z
  .object({
    enabled: z.boolean().describe('Enable tiled face detection for large/group photos'),
    tileSize: z.int().min(128).describe('Tile size in pixels for tiled detection'),
    tileOverlap: z.number().meta({ format: 'double' }).min(0).max(0.9).describe('Overlap ratio between adjacent tiles'),
    maxTiles: z.int().min(1).describe('Maximum number of tiles before downscaling'),
    triggers: FaceDetectionTilingTriggersConfigSchema,
  })
  .meta({ id: 'FaceDetectionTilingConfig' });

export const OcrConfigSchema = ModelConfigSchema.extend({
  maxResolution: z.int().min(1).describe('Maximum resolution for OCR processing'),
  minDetectionScore: z
    .number()
    .meta({ format: 'double' })
    .min(0.1)
    .max(1)
    .describe('Minimum confidence score for text detection'),
  minRecognitionScore: z
    .number()
    .meta({ format: 'double' })
    .min(0.1)
    .max(1)
    .describe('Minimum confidence score for text recognition'),
}).meta({ id: 'OcrConfig' });

export class CLIPConfig extends createZodDto(CLIPConfigSchema) {}
