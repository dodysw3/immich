import { createZodDto } from 'nestjs-zod';
import z from 'zod';

export const PDF_DOCUMENT_STATUSES = ['pending', 'processing', 'ready', 'failed'] as const;
export type PdfDocumentStatus = (typeof PDF_DOCUMENT_STATUSES)[number];

const PdfDocumentStatusSchema = z.enum(PDF_DOCUMENT_STATUSES);

const PdfDocumentQuerySchema = z
  .object({
    page: z.coerce.number().int().min(1).default(1).describe('Page number'),
    size: z.coerce.number().int().min(1).default(50).describe('Number of items per page'),
    status: PdfDocumentStatusSchema.optional().describe('Filter documents by processing status'),
  })
  .meta({ id: 'PdfDocumentQueryDto' });

const PdfDocumentSearchSchema = PdfDocumentQuerySchema.extend({
  query: z.string().describe('Search phrase'),
}).meta({ id: 'PdfDocumentSearchDto' });

const PdfInDocumentSearchSchema = z
  .object({
    query: z.string().describe('Search phrase'),
    size: z.coerce.number().int().min(1).max(500).default(100).describe('Max matched pages to return'),
  })
  .meta({ id: 'PdfInDocumentSearchDto' });

const PdfDocumentParamsSchema = z
  .object({
    id: z.uuidv4().describe('PDF document asset ID'),
  })
  .meta({ id: 'PdfDocumentParamsDto' });

const PdfDocumentPageParamsSchema = PdfDocumentParamsSchema.extend({
  pageNumber: z.coerce.number().int().min(1).describe('Page number'),
}).meta({ id: 'PdfDocumentPageParamsDto' });

export class PdfDocumentQueryDto extends createZodDto(PdfDocumentQuerySchema) {}
export class PdfDocumentSearchDto extends createZodDto(PdfDocumentSearchSchema) {}
export class PdfInDocumentSearchDto extends createZodDto(PdfInDocumentSearchSchema) {}
export class PdfDocumentParamsDto extends createZodDto(PdfDocumentParamsSchema) {}
export class PdfDocumentPageParamsDto extends createZodDto(PdfDocumentPageParamsSchema) {}

export interface PdfDocumentResponseDto {
  assetId: string;
  originalFileName: string;
  pageCount: number;
  title: string | null;
  author: string | null;
  processedAt: Date | null;
  status: PdfDocumentStatus;
  lastError: string | null;
  createdAt: Date;
  updatedAt: Date;
}

export interface PdfPageResponseDto {
  id: string;
  assetId: string;
  pageNumber: number;
  text: string;
  textSource: 'embedded' | 'ocr' | 'none';
  width: number | null;
  height: number | null;
}

export interface PdfSearchResultDto extends PdfDocumentResponseDto {
  matchingPages: number[];
}

export interface PdfDocumentStatusSummaryDto {
  total: number;
  pending: number;
  processing: number;
  ready: number;
  failed: number;
}

export interface PdfDocumentListResponseDto {
  items: PdfDocumentResponseDto[];
  nextPage: string | null;
  summary: PdfDocumentStatusSummaryDto;
}

export interface PdfSearchResponseDto {
  items: PdfSearchResultDto[];
  nextPage: string | null;
  summary?: PdfDocumentStatusSummaryDto;
}

export interface PdfInDocumentSearchResultDto {
  pageNumber: number;
  snippet: string;
  matchIndex: number;
}
