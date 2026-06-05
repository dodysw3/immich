import { createZodDto } from 'nestjs-zod';
import { AssetResponseSchema } from 'src/dtos/asset-response.dto';
import z from 'zod';

const PersonAssetsSchema = z
  .object({
    page: z.coerce.number().int().min(1).default(1).describe('Page number'),
    limit: z.coerce.number().int().min(1).max(100).default(20).describe('Items per page'),
    order: z.enum(['asc', 'desc']).default('desc').describe('Sort direction by recognition time'),
  })
  .meta({ id: 'PersonAssetsDto' });

export class PersonAssetsDto extends createZodDto(PersonAssetsSchema) {}

const PersonAssetsResponseSchema = z
  .object({
    total: z.int().min(0).describe('Total number of assets'),
    assets: z
      .array(
        AssetResponseSchema.extend({
          recognizedAt: z.string().meta({ format: 'date-time' }).describe('When the face was matched to this person'),
        }),
      )
      .describe('Assets sorted by recognition time'),
  })
  .meta({ id: 'PersonAssetsResponseDto' });

export class PersonAssetsResponseDto extends createZodDto(PersonAssetsResponseSchema) {}
