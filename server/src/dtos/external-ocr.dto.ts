import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import {
  ArrayMaxSize,
  IsArray,
  IsBoolean,
  IsDateString,
  IsIn,
  IsInt,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  Max,
  MaxLength,
  Min,
  ValidateNested,
} from 'class-validator';

export const EXTERNAL_OCR_MODES = ['replace', 'merge'] as const;
export type ExternalOcrMode = (typeof EXTERNAL_OCR_MODES)[number];

export class ExternalOcrLineDto {
  @ApiProperty({ type: 'number', format: 'double', minimum: 0, maximum: 1 })
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @Max(1)
  x1!: number;

  @ApiProperty({ type: 'number', format: 'double', minimum: 0, maximum: 1 })
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @Max(1)
  y1!: number;

  @ApiProperty({ type: 'number', format: 'double', minimum: 0, maximum: 1 })
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @Max(1)
  x2!: number;

  @ApiProperty({ type: 'number', format: 'double', minimum: 0, maximum: 1 })
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @Max(1)
  y2!: number;

  @ApiProperty({ type: 'number', format: 'double', minimum: 0, maximum: 1 })
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @Max(1)
  x3!: number;

  @ApiProperty({ type: 'number', format: 'double', minimum: 0, maximum: 1 })
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @Max(1)
  y3!: number;

  @ApiProperty({ type: 'number', format: 'double', minimum: 0, maximum: 1 })
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @Max(1)
  x4!: number;

  @ApiProperty({ type: 'number', format: 'double', minimum: 0, maximum: 1 })
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @Max(1)
  y4!: number;

  @ApiProperty({ type: 'number', format: 'double', minimum: 0, maximum: 1 })
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @Max(1)
  boxScore!: number;

  @ApiProperty({ type: 'number', format: 'double', minimum: 0, maximum: 1 })
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @Max(1)
  textScore!: number;

  @ApiProperty({ type: 'string', maxLength: 4096 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(4096)
  text!: string;
}

export class ExternalOcrResultDto {
  @ApiProperty({ description: 'External OCR provider identifier', example: 'immich-ocr-gpu', maxLength: 128 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(128)
  provider!: string;

  @ApiProperty({ description: 'Model family/name', example: 'paddleocr+trocr-base-printed', maxLength: 256 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(256)
  model!: string;

  @ApiProperty({ description: 'Model revision for reprocessing control', example: 'v1.0.0', maxLength: 128 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(128)
  modelRevision!: string;

  @ApiProperty({ description: 'SHA256 of original source bytes', example: 'abcdef1234', maxLength: 128 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(128)
  sourceChecksum!: string;

  @ApiProperty({ description: 'Language hint', required: false, maxLength: 64 })
  @IsOptional()
  @IsString()
  @MaxLength(64)
  language?: string;

  @ApiProperty({ enum: EXTERNAL_OCR_MODES })
  @IsIn(EXTERNAL_OCR_MODES)
  mode!: ExternalOcrMode;

  @ApiProperty({ description: 'External OCR completion timestamp (ISO 8601)' })
  @IsDateString()
  processedAt!: string;

  @ApiProperty({ type: ExternalOcrLineDto, isArray: true, maxItems: 10000 })
  @IsArray()
  @ArrayMaxSize(10_000)
  @ValidateNested({ each: true })
  @Type(() => ExternalOcrLineDto)
  lines!: ExternalOcrLineDto[];

  @ApiProperty({ required: false, description: 'Pre-tokenized search text', maxLength: 1000000 })
  @IsOptional()
  @IsString()
  @MaxLength(1_000_000)
  searchText?: string;
}

export class ExternalOcrFailureDto {
  @ApiProperty({ description: 'External OCR provider identifier', example: 'immich-ocr-gpu', maxLength: 128 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(128)
  provider!: string;

  @ApiProperty({ description: 'Failure reason', maxLength: 1000 })
  @IsString()
  @IsNotEmpty()
  @MaxLength(1000)
  reason!: string;

  @ApiProperty({ type: 'integer', minimum: 0 })
  @Type(() => Number)
  @IsInt()
  @Min(0)
  retryCount!: number;

  @ApiProperty()
  @IsBoolean()
  retriable!: boolean;
}

export class ExternalOcrWriteResponseDto {
  @ApiProperty({ type: 'integer' })
  written!: number;

  @ApiProperty({ type: 'integer' })
  searchTextLength!: number;
}
