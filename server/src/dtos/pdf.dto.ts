import { ApiProperty } from '@nestjs/swagger';
import { IsInt, Min } from 'class-validator';

export class PdfPageResponseDto {
  @ApiProperty({ description: 'Page asset ID' })
  id!: string;

  @ApiProperty({ description: '0-based page index' })
  pageIndex!: number;

  @ApiProperty({ description: 'Base64 encoded thumbhash', nullable: true })
  thumbhash?: string | null;
}

export class PdfPagesResponseDto {
  @ApiProperty({ description: 'PDF asset ID' })
  pdfId!: string;

  @ApiProperty({ description: 'Total number of pages' })
  pageCount!: number;

  @ApiProperty({ description: '0-based index of the main (cover) page' })
  mainPageIndex!: number;

  @ApiProperty({ description: 'Processing status', enum: ['processing', 'completed', 'failed'] })
  status!: 'processing' | 'completed' | 'failed';

  @ApiProperty({ description: 'List of page assets', type: [PdfPageResponseDto] })
  pages!: PdfPageResponseDto[];
}

export class SetPdfMainPageDto {
  @ApiProperty({ description: '0-based page index to set as main page' })
  @IsInt()
  @Min(0)
  pageIndex!: number;
}
