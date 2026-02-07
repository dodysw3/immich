import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean, IsInt, IsNotEmpty, IsNumber, IsOptional, IsString, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';
import { ValidateUUID } from 'src/validation';

export class PdfMetadataDto {
  @ApiProperty({ description: 'PDF title' })
  @IsOptional()
  @IsString()
  title?: string;

  @ApiProperty({ description: 'PDF author' })
  @IsOptional()
  @IsString()
  author?: string;

  @ApiProperty({ description: 'PDF subject' })
  @IsOptional()
  @IsString()
  subject?: string;

  @ApiProperty({ description: 'PDF keywords' })
  @IsOptional()
  @IsString()
  keywords?: string;

  @ApiProperty({ description: 'PDF creator' })
  @IsOptional()
  @IsString()
  creator?: string;

  @ApiProperty({ description: 'PDF producer' })
  @IsOptional()
  @IsString()
  producer?: string;

  @ApiProperty({ description: 'Number of pages' })
  @IsInt()
  pageCount!: number;

  @ApiProperty({ description: 'File size in bytes' })
  @IsNumber()
  fileSizeInByte!: number;

  @ApiProperty({ description: 'Whether PDF has extractable text' })
  @IsBoolean()
  hasText!: boolean;

  @ApiProperty({ description: 'Whether OCR processing is complete' })
  @IsBoolean()
  isOCRProcessed!: boolean;
}

export class PdfPageOcrDto {
  @ApiProperty({ description: 'OCR text ID' })
  id!: string;

  @ApiProperty({ description: 'Page number' })
  @IsInt()
  pageNumber!: number;

  @ApiProperty({ description: 'Bounding box coordinates (x1)' })
  @IsNumber()
  x1!: number;

  @ApiProperty({ description: 'Bounding box coordinates (y1)' })
  @IsNumber()
  y1!: number;

  @ApiProperty({ description: 'Bounding box coordinates (x2)' })
  @IsNumber()
  x2!: number;

  @ApiProperty({ description: 'Bounding box coordinates (y2)' })
  @IsNumber()
  y2!: number;

  @ApiProperty({ description: 'Bounding box coordinates (x3)' })
  @IsNumber()
  x3!: number;

  @ApiProperty({ description: 'Bounding box coordinates (y3)' })
  @IsNumber()
  y3!: number;

  @ApiProperty({ description: 'Bounding box coordinates (x4)' })
  @IsNumber()
  x4!: number;

  @ApiProperty({ description: 'Bounding box coordinates (y4)' })
  @IsNumber()
  y4!: number;

  @ApiProperty({ description: 'Extracted text' })
  @IsString()
  text!: string;

  @ApiProperty({ description: 'Confidence score' })
  @IsNumber()
  confidence!: number;
}

export class PdfPageDto {
  @ApiProperty({ description: 'Page ID' })
  id!: string;

  @ApiProperty({ description: 'Asset ID' })
  @ValidateUUID()
  assetId!: string;

  @ApiProperty({ description: 'Page number' })
  @IsInt()
  pageNumber!: number;

  @ApiProperty({ description: 'Page width (pixels)' })
  @IsOptional()
  @IsInt()
  width?: number;

  @ApiProperty({ description: 'Page height (pixels)' })
  @IsOptional()
  @IsInt()
  height?: number;

  @ApiProperty({ description: 'Extracted text content' })
  @IsOptional()
  @IsString()
  textContent?: string;

  @ApiProperty({ description: 'Thumbnail path' })
  @IsString()
  thumbnailPath!: string;

  @ApiProperty({ description: 'Searchable text' })
  @IsString()
  searchableText!: string;

  @ApiProperty({ description: 'OCR data for page regions', type: [PdfPageOcrDto] })
  @ValidateNested({ each: true })
  @Type(() => PdfPageOcrDto)
  ocrData?: PdfPageOcrDto[];
}

export class PdfAssetDto {
  @ApiProperty({ description: 'Asset ID' })
  @ValidateUUID()
  assetId!: string;

  @ApiProperty({ description: 'PDF metadata', type: PdfMetadataDto })
  @ValidateNested()
  @Type(() => PdfMetadataDto)
  metadata!: PdfMetadataDto;

  @ApiProperty({ description: 'PDF pages', type: [PdfPageDto] })
  @ValidateNested({ each: true })
  @Type(() => PdfPageDto)
  pages!: PdfPageDto[];
}

export class PdfUploadDto {
  @ApiProperty({ description: 'PDF file' })
  @IsNotEmpty()
  file!: Express.Multer.File;
}
