import { Injectable } from '@nestjs/common';
import { readFile } from 'node:fs/promises';
import PDFParse from 'pdf-parse';

export interface PdfMetadata {
  title?: string;
  author?: string;
  subject?: string;
  keywords?: string;
  creator?: string;
  producer?: string;
  pageCount: number;
  hasText: boolean;
}

export interface PdfPageText {
  pageNumber: number;
  text: string;
}

export interface PdfExtractionResult {
  metadata: PdfMetadata;
  pages: PdfPageText[];
  fullText: string;
}

@Injectable()
export class PdfExtractorUtil {
  /**
   * Extract metadata and text from a PDF file
   */
  async extractPdf(filePath: string): Promise<PdfExtractionResult> {
    const buffer = await readFile(filePath);
    const data = await PDFParse(buffer);

    const metadata: PdfMetadata = {
      title: data.info?.Title || undefined,
      author: data.info?.Author || undefined,
      subject: data.info?.Subject || undefined,
      keywords: data.info?.Keywords || undefined,
      creator: data.info?.Creator || undefined,
      producer: data.info?.Producer || undefined,
      pageCount: data.numpages,
      hasText: data.text !== undefined && data.text.length > 0,
    };

    // Split text by pages (pdf-parse doesn't give page-by-page text,
    // so we'll return the full text for all pages)
    const pages: PdfPageText[] = [];
    for (let i = 0; i < data.numpages; i++) {
      pages.push({
        pageNumber: i + 1,
        text: data.text || '', // Note: pdf-parse doesn't separate text by page
      });
    }

    return {
      metadata,
      pages,
      fullText: data.text || '',
    };
  }

  /**
   * Extract just the metadata from a PDF file
   */
  async extractMetadata(filePath: string): Promise<PdfMetadata> {
    const result = await this.extractPdf(filePath);
    return result.metadata;
  }

  /**
   * Check if a PDF has extractable text
   */
  async hasText(filePath: string): Promise<boolean> {
    const buffer = await readFile(filePath);
    const data = await PDFParse(buffer);
    return data.text !== undefined && data.text.length > 0;
  }
}
