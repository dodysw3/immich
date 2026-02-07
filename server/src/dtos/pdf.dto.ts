import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsIn, IsInt, IsNotEmpty, IsOptional, IsString, IsUUID, Max, Min } from 'class-validator';

export const PDF_DOCUMENT_STATUSES = ['pending', 'processing', 'ready', 'failed'] as const;
export type PdfDocumentStatus = (typeof PDF_DOCUMENT_STATUSES)[number];

export class PdfDocumentQueryDto {
  @ApiPropertyOptional({ type: 'integer', default: 1, minimum: 1 })
  @IsOptional()
  @Transform(({ value }) => Number(value))
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiPropertyOptional({ type: 'integer', default: 50, minimum: 1 })
  @IsOptional()
  @Transform(({ value }) => Number(value))
  @IsInt()
  @Min(1)
  size?: number = 50;

  @ApiPropertyOptional({ enum: PDF_DOCUMENT_STATUSES })
  @IsOptional()
  @IsString()
  @IsIn(PDF_DOCUMENT_STATUSES)
  status?: PdfDocumentStatus;
}

export class PdfDocumentSearchDto extends PdfDocumentQueryDto {
  @ApiProperty({ description: 'Search phrase' })
  @IsString()
  @IsNotEmpty()
  query!: string;
}

export class PdfInDocumentSearchDto {
  @ApiProperty({ description: 'Search phrase' })
  @IsString()
  @IsNotEmpty()
  query!: string;

  @ApiPropertyOptional({ type: 'integer', default: 100, minimum: 1, maximum: 500 })
  @IsOptional()
  @Transform(({ value }) => Number(value))
  @IsInt()
  @Min(1)
  @Max(500)
  size?: number = 100;
}

export class PdfDocumentParamsDto {
  @ApiProperty({ format: 'uuid' })
  @IsUUID('4')
  id!: string;
}

export class PdfDocumentPageParamsDto extends PdfDocumentParamsDto {
  @ApiProperty({ type: 'integer', minimum: 1 })
  @Transform(({ value }) => Number(value))
  @IsInt()
  @Min(1)
  pageNumber!: number;
}

export class PdfDocumentResponseDto {
  @ApiProperty({ format: 'uuid' })
  assetId!: string;

  @ApiProperty()
  originalFileName!: string;

  @ApiProperty({ type: 'integer' })
  pageCount!: number;

  @ApiPropertyOptional()
  title!: string | null;

  @ApiPropertyOptional()
  author!: string | null;

  @ApiPropertyOptional()
  processedAt!: Date | null;

  @ApiProperty({ enum: PDF_DOCUMENT_STATUSES })
  status!: PdfDocumentStatus;

  @ApiPropertyOptional()
  lastError!: string | null;

  @ApiProperty()
  createdAt!: Date;
}

export class PdfPageResponseDto {
  @ApiProperty({ format: 'uuid' })
  id!: string;

  @ApiProperty({ format: 'uuid' })
  assetId!: string;

  @ApiProperty({ type: 'integer' })
  pageNumber!: number;

  @ApiProperty()
  text!: string;

  @ApiProperty()
  textSource!: 'embedded' | 'ocr' | 'none';

  @ApiPropertyOptional()
  width!: number | null;

  @ApiPropertyOptional()
  height!: number | null;
}

export class PdfSearchResultDto extends PdfDocumentResponseDto {
  @ApiProperty({ type: 'integer', isArray: true })
  matchingPages!: number[];
}

export class PdfDocumentStatusSummaryDto {
  @ApiProperty({ type: 'integer' })
  total!: number;

  @ApiProperty({ type: 'integer' })
  pending!: number;

  @ApiProperty({ type: 'integer' })
  processing!: number;

  @ApiProperty({ type: 'integer' })
  ready!: number;

  @ApiProperty({ type: 'integer' })
  failed!: number;
}

export class PdfDocumentListResponseDto {
  @ApiProperty({ type: PdfDocumentResponseDto, isArray: true })
  items!: PdfDocumentResponseDto[];

  @ApiPropertyOptional({ description: 'Next page number as string', nullable: true })
  nextPage!: string | null;

  @ApiProperty({ type: PdfDocumentStatusSummaryDto })
  summary!: PdfDocumentStatusSummaryDto;
}

export class PdfSearchResponseDto {
  @ApiProperty({ type: PdfSearchResultDto, isArray: true })
  items!: PdfSearchResultDto[];

  @ApiPropertyOptional({ description: 'Next page number as string', nullable: true })
  nextPage!: string | null;
}

export class PdfInDocumentSearchResultDto {
  @ApiProperty({ type: 'integer' })
  pageNumber!: number;

  @ApiProperty()
  snippet!: string;

  @ApiProperty({ type: 'integer' })
  matchIndex!: number;
}
