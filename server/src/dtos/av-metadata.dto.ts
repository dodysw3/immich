import { createZodDto } from 'nestjs-zod';
import z from 'zod';

const VideoStreamResponseSchema = z
  .object({
    codecName: z.string().nullish().default(null).describe('Video codec name'),
    formatName: z.string().nullish().default(null).describe('Container format name'),
    formatLongName: z.string().nullish().default(null).describe('Container format long name'),
    pixelFormat: z.string().nullish().default(null).describe('Pixel format'),
    profile: z.int().nullish().default(null).describe('Codec profile number'),
    level: z.int().nullish().default(null).describe('Codec level number'),
    bitrate: z.int().nullish().default(null).describe('Video bitrate in bits per second'),
    frameCount: z.int().nullish().default(null).describe('Frame count'),
    dvProfile: z.int().nullish().default(null).describe('Dolby Vision profile'),
    dvLevel: z.int().nullish().default(null).describe('Dolby Vision level'),
  })
  .describe('Video stream metadata')
  .meta({ id: 'VideoStreamResponseDto' });

const AudioStreamResponseSchema = z
  .object({
    codecName: z.string().nullish().default(null).describe('Audio codec name'),
    profile: z.int().nullish().default(null).describe('Audio codec profile number'),
    bitrate: z.int().nullish().default(null).describe('Audio bitrate in bits per second'),
  })
  .describe('Audio stream metadata')
  .meta({ id: 'AudioStreamResponseDto' });

export const AvMetadataResponseSchema = z
  .object({
    videoStream: VideoStreamResponseSchema.nullish().default(null),
    audioStream: AudioStreamResponseSchema.nullish().default(null),
  })
  .describe('Audio/video stream metadata probed from the original file')
  .meta({ id: 'AvMetadataResponseDto' });

export class AvMetadataResponseDto extends createZodDto(AvMetadataResponseSchema) {}
