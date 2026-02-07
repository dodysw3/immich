import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsInt, IsString, Min } from 'class-validator';
import { Optional } from 'src/validation';

export class PdfDocumentResponseDto {
  @ApiProperty({ type: 'string', format: 'uuid' })
  assetId!: string;

  @ApiProperty({ type: 'integer', description: 'Total number of pages' })
  pageCount!: number;

  @ApiPropertyOptional({ type: 'string', description: 'PDF title from metadata' })
  title?: string | null;

  @ApiPropertyOptional({ type: 'string', description: 'PDF author from metadata' })
  author?: string | null;

  @ApiPropertyOptional({ type: 'string', description: 'PDF subject from metadata' })
  subject?: string | null;

  @ApiPropertyOptional({ type: 'string', description: 'PDF creator application' })
  creator?: string | null;

  @ApiPropertyOptional({ type: 'string', description: 'PDF producer' })
  producer?: string | null;

  @ApiPropertyOptional({ type: 'string', format: 'date-time', description: 'PDF creation date' })
  creationDate?: string | null;

  @ApiPropertyOptional({ type: 'string', format: 'date-time', description: 'When processing finished' })
  processedAt?: string | null;

  @ApiPropertyOptional({ type: 'string', description: 'Original filename' })
  originalFileName?: string;

  @ApiPropertyOptional({ type: 'string', format: 'date-time', description: 'Asset creation date' })
  createdAt?: string;
}

export class PdfPageResponseDto {
  @ApiProperty({ type: 'string', format: 'uuid' })
  id!: string;

  @ApiProperty({ type: 'string', format: 'uuid' })
  assetId!: string;

  @ApiProperty({ type: 'integer', description: 'Page number (1-indexed)' })
  pageNumber!: number;

  @ApiProperty({ type: 'string', description: 'Extracted text content' })
  text!: string;

  @ApiProperty({ type: 'string', description: 'Text source: embedded, ocr, or none' })
  textSource!: string;

  @ApiPropertyOptional({ type: 'number', description: 'Page width in points' })
  width?: number | null;

  @ApiPropertyOptional({ type: 'number', description: 'Page height in points' })
  height?: number | null;
}

export class PdfSearchResultDto {
  @ApiProperty({ type: 'string', format: 'uuid' })
  assetId!: string;

  @ApiPropertyOptional({ type: 'string', description: 'PDF title' })
  title?: string | null;

  @ApiProperty({ type: 'integer', description: 'Total pages' })
  pageCount!: number;

  @ApiProperty({ type: 'string', description: 'Original filename' })
  originalFileName!: string;
}

export class PdfSearchQueryDto {
  @ApiProperty({ description: 'Search query text' })
  @IsString()
  query!: string;
}

export class PdfPageNumberDto {
  @ApiProperty({ type: 'integer', description: 'Page number (1-indexed)' })
  @IsInt()
  @Min(1)
  pageNumber!: number;
}
