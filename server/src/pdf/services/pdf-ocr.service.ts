import { Injectable } from '@nestjs/common';
import { createWorker } from 'tesseract.js';

export interface OcrResult {
  text: string;
  confidence: number;
  pageNumber: number;
}

export interface OcrBoundingBox {
  x1: number;
  y1: number;
  x2: number;
  y2: number;
  x3: number;
  y3: number;
  x4: number;
  y4: number;
  text: string;
  confidence: number;
  pageNumber: number;
}

@Injectable()
export class PdfOcrService {
  private worker: Tesseract.Worker | null = null;

  /**
   * Initialize Tesseract worker
   */
  async initialize(): Promise<void> {
    if (this.worker) {
      return;
    }

    this.worker = await createWorker('eng', 1, {
      logger: (m) => {
        if (m.status === 'recognizing text') {
          // Log progress
        }
      },
    });
  }

  /**
   * Perform OCR on a PDF page image
   */
  async performOcr(pageImagePath: string, pageNumber: number): Promise<OcrBoundingBox[]> {
    await this.initialize();

    if (!this.worker) {
      throw new Error('OCR worker not initialized');
    }

    const result = await this.worker.recognize(pageImagePath);
    const results: OcrBoundingBox[] = [];

    // Use the raw OCR data which should contain word-level information
    // Type assertion to handle incomplete type definitions
    const ocrResult = result as {
      data?: {
        lines?: Array<{
          words?: Array<{
            confidence: number;
            text: string;
            bbox?: { x0: number; y0: number; x1: number; y1: number };
          }>;
          bbox?: { x0: number; y0: number; x1: number; y1: number };
        }>;
      };
      width?: number;
      height?: number;
    };

    const lines = ocrResult.data?.lines || [];
    const width = ocrResult.width || 1920;
    const height = ocrResult.height || 1080;

    for (const line of lines) {
      const words = line.words || [];
      for (const word of words) {
        if (word.confidence > 50 && word.text.trim().length > 0) {
          const bbox = word.bbox || line.bbox;
          if (bbox) {
            results.push({
              x1: bbox.x0 / width,
              y1: bbox.y0 / height,
              x2: bbox.x1 / width,
              y2: bbox.y1 / height,
              x3: bbox.x1 / width,
              y3: bbox.y0 / height,
              x4: bbox.x0 / width,
              y4: bbox.y1 / height,
              text: word.text,
              confidence: word.confidence / 100,
              pageNumber,
            });
          }
        }
      }
    }

    return results;
  }

  /**
   * Extract text from a PDF page image (simple text extraction without bounding boxes)
   */
  async extractText(pageImagePath: string, pageNumber: number): Promise<OcrResult> {
    await this.initialize();

    if (!this.worker) {
      throw new Error('OCR worker not initialized');
    }

    const { data } = await this.worker.recognize(pageImagePath);

    return {
      text: data.text,
      confidence: data.confidence / 100,
      pageNumber,
    };
  }

  /**
   * Terminate the OCR worker
   */
  async terminate(): Promise<void> {
    if (this.worker) {
      await this.worker.terminate();
      this.worker = null;
    }
  }

  /**
   * Check if OCR is available
   */
  isAvailable(): boolean {
    return this.worker !== null;
  }
}
