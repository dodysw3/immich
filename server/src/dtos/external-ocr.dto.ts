import { createZodDto } from 'nestjs-zod';
import z from 'zod';

export const EXTERNAL_OCR_MODES = ['replace', 'merge'] as const;
export type ExternalOcrMode = (typeof EXTERNAL_OCR_MODES)[number];

const ExternalOcrLineSchema = z
  .object({
    x1: z.number().min(0).max(1).describe('Bounding box x1'),
    y1: z.number().min(0).max(1).describe('Bounding box y1'),
    x2: z.number().min(0).max(1).describe('Bounding box x2'),
    y2: z.number().min(0).max(1).describe('Bounding box y2'),
    x3: z.number().min(0).max(1).describe('Bounding box x3'),
    y3: z.number().min(0).max(1).describe('Bounding box y3'),
    x4: z.number().min(0).max(1).describe('Bounding box x4'),
    y4: z.number().min(0).max(1).describe('Bounding box y4'),
    boxScore: z.number().min(0).max(1).describe('Detection confidence'),
    textScore: z.number().min(0).max(1).describe('Text recognition confidence'),
    text: z.string().max(4096).describe('Recognized text'),
  })
  .meta({ id: 'ExternalOcrLineDto' });

const ExternalOcrResultSchema = z
  .object({
    provider: z.string().max(128).describe('External OCR provider identifier'),
    model: z.string().max(256).describe('Model family/name'),
    modelRevision: z.string().max(128).describe('Model revision for reprocessing control'),
    sourceChecksum: z.string().max(128).describe('SHA256 of original source bytes'),
    language: z.string().max(64).optional().describe('Language hint'),
    mode: z.enum(EXTERNAL_OCR_MODES).describe('OCR write mode'),
    processedAt: z.string().describe('External OCR completion timestamp (ISO 8601)'),
    lines: z.array(ExternalOcrLineSchema).max(10_000).describe('OCR result lines'),
    searchText: z.string().max(1_000_000).optional().describe('Pre-tokenized search text'),
  })
  .meta({ id: 'ExternalOcrResultDto' });

const ExternalOcrFailureSchema = z
  .object({
    provider: z.string().max(128).describe('External OCR provider identifier'),
    reason: z.string().max(1000).describe('Failure reason'),
    retryCount: z.number().int().min(0).describe('Number of retries attempted'),
    retriable: z.boolean().describe('Whether the failure is retriable'),
  })
  .meta({ id: 'ExternalOcrFailureDto' });

const ExternalOcrWriteResponseSchema = z
  .object({
    written: z.int().describe('Number of records written'),
    searchTextLength: z.int().describe('Length of generated search text'),
  })
  .meta({ id: 'ExternalOcrWriteResponseDto' });

export class ExternalOcrLineDto extends createZodDto(ExternalOcrLineSchema) {}
export class ExternalOcrResultDto extends createZodDto(ExternalOcrResultSchema) {}
export class ExternalOcrFailureDto extends createZodDto(ExternalOcrFailureSchema) {}
export class ExternalOcrWriteResponseDto extends createZodDto(ExternalOcrWriteResponseSchema) {}
