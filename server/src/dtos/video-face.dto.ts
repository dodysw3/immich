import { createZodDto } from 'nestjs-zod';
import { z } from 'zod';

export const VideoFaceSightingSchema = z.object({
  timeMs: z.int().describe('Decoded presentation timestamp of the sighting'),
  score: z.number().describe('Detection score'),
});

export const VideoFaceDtoSchema = z
  .object({
    id: z.uuidv4(),
    firstObservedMs: z.int().describe('Earliest sighting timestamp'),
    lastObservedMs: z.int().describe('Latest sighting timestamp'),
    sightingCount: z.int(),
    bestFrameMs: z.int().describe('Timestamp of the representative frame'),
    flagged: z.boolean().describe('Single sighting below the stricter quality bar'),
    personGroupId: z.string().nullable(),
    personName: z.string().nullable().describe("Owner's person name, if assigned or matched"),
    assetFaceId: z.string().nullable(),
    sightings: z.array(VideoFaceSightingSchema),
  })
  .meta({ id: 'VideoFaceDto' });

export const VideoFaceRunDtoSchema = z
  .object({
    outcome: z.enum(['saturated', 'budget_exhausted', 'deadline', 'decode_failed']),
    configHash: z.string(),
    framesAnalyzed: z.int(),
    identities: z.int(),
    durationMs: z.int().describe('Video timeline duration'),
    firstSampledMs: z.int(),
    lastSampledMs: z.int(),
    finishedAt: z.string().nullable(),
  })
  .meta({ id: 'VideoFaceRunDto' });

export const VideoFacesResponseSchema = z
  .object({
    faces: z.array(VideoFaceDtoSchema),
    run: VideoFaceRunDtoSchema.nullable().describe('Latest scan run, null when never scanned'),
  })
  .meta({ id: 'VideoFacesResponseDto' });

export class VideoFaceDto extends createZodDto(VideoFaceDtoSchema) {}
export class VideoFaceRunDto extends createZodDto(VideoFaceRunDtoSchema) {}
export class VideoFacesResponseDto extends createZodDto(VideoFacesResponseSchema) {}
