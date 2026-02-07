import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Transform } from 'class-transformer';
import { IsInt, IsNotEmpty, IsOptional, IsString, IsUUID, Min } from 'class-validator';

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

  @ApiProperty({ enum: ['pending', 'processing', 'ready', 'failed'] })
  status!: 'pending' | 'processing' | 'ready' | 'failed';

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

export class PdfDocumentListResponseDto {
  @ApiProperty({ type: PdfDocumentResponseDto, isArray: true })
  items!: PdfDocumentResponseDto[];

  @ApiPropertyOptional({ description: 'Next page number as string', nullable: true })
  nextPage!: string | null;
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
