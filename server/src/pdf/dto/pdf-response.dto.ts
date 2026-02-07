import { ApiProperty } from '@nestjs/swagger';
import { PdfAssetDto, PdfMetadataDto, PdfPageDto, PdfPageOcrDto } from './pdf.dto';

export class PdfMetadataResponseDto extends PdfMetadataDto {
  @ApiProperty({ description: 'Creation timestamp' })
  createdAt!: Date;

  @ApiProperty({ description: 'Last update timestamp' })
  updatedAt!: Date;
}

export class PdfPageOcrResponseDto extends PdfPageOcrDto {}

export class PdfPageResponseDto {
  @ApiProperty({ description: 'Page ID' })
  id!: string;

  @ApiProperty({ description: 'Asset ID' })
  assetId!: string;

  @ApiProperty({ description: 'Page number' })
  pageNumber!: number;

  @ApiProperty({ description: 'Page width (pixels)', nullable: true })
  width?: number;

  @ApiProperty({ description: 'Page height (pixels)', nullable: true })
  height?: number;

  @ApiProperty({ description: 'Extracted text content', nullable: true })
  textContent?: string;

  @ApiProperty({ description: 'Thumbnail path' })
  thumbnailPath!: string;

  @ApiProperty({ description: 'Searchable text' })
  searchableText!: string;

  @ApiProperty({ description: 'Creation timestamp' })
  createdAt!: Date;
}

export class PdfAssetResponseDto {
  @ApiProperty({ description: 'Asset ID' })
  assetId!: string;

  @ApiProperty({ description: 'PDF metadata', type: PdfMetadataResponseDto })
  metadata!: PdfMetadataResponseDto;

  @ApiProperty({ description: 'PDF pages', type: [PdfPageResponseDto] })
  pages!: PdfPageResponseDto[];
}
