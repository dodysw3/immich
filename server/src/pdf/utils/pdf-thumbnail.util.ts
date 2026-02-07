import { Injectable } from '@nestjs/common';
import { mkdir, writeFile } from 'node:fs/promises';
import { join } from 'node:path';
import sharp from 'sharp';

export interface PageThumbnailOptions {
  width?: number;
  height?: number;
  quality?: number;
  format?: 'webp' | 'jpeg' | 'png';
}

export interface PageThumbnailResult {
  thumbnailPath: string;
  width: number;
  height: number;
}

@Injectable()
export class PdfThumbnailUtil {
  private readonly defaultWidth = 300;
  private readonly defaultHeight = 400;
  private readonly defaultQuality = 80;
  private readonly defaultFormat = 'webp';

  /**
   * Generate a thumbnail for a PDF page
   * This requires the page to be converted to an image first using a tool like pdftoppm or pdf-poppler
   */
  async generateThumbnail(
    pageImagePath: string,
    outputDir: string,
    pageNumber: number,
    options: PageThumbnailOptions = {},
  ): Promise<PageThumbnailResult> {
    const {
      width = this.defaultWidth,
      height = this.defaultHeight,
      quality = this.defaultQuality,
      format = this.defaultFormat,
    } = options;

    // Ensure output directory exists
    await mkdir(outputDir, { recursive: true });

    const filename = `page-${pageNumber.toString().padStart(3, '0')}-thumb.${format}`;
    const thumbnailPath = join(outputDir, filename);

    // Get image dimensions and generate thumbnail
    const image = sharp(pageImagePath);
    const metadata = await image.metadata();

    // Calculate aspect ratio
    const aspectRatio = (metadata.width || width) / (metadata.height || height);
    let thumbnailWidth = width;
    let thumbnailHeight = height;

    if (aspectRatio > 1) {
      thumbnailHeight = Math.round(width / aspectRatio);
    } else {
      thumbnailWidth = Math.round(height * aspectRatio);
    }

    // Generate thumbnail
    await image
      .resize(thumbnailWidth, thumbnailHeight, { fit: 'inside', withoutEnlargement: true })
      .webp({ quality })
      .toFile(thumbnailPath);

    return {
      thumbnailPath,
      width: thumbnailWidth,
      height: thumbnailHeight,
    };
  }

  /**
   * Generate a page preview image (larger than thumbnail)
   */
  async generatePagePreview(
    pageImagePath: string,
    outputDir: string,
    pageNumber: number,
    options: PageThumbnailOptions = {},
  ): Promise<PageThumbnailResult> {
    const { width = 1920, height = 1080, quality = 85, format = 'webp' } = options;

    await mkdir(outputDir, { recursive: true });

    const filename = `page-${pageNumber.toString().padStart(3, '0')}.${format}`;
    const previewPath = join(outputDir, filename);

    const image = sharp(pageImagePath);
    const metadata = await image.metadata();

    const aspectRatio = (metadata.width || width) / (metadata.height || height);
    let previewWidth = width;
    let previewHeight = height;

    if (aspectRatio > 1) {
      previewHeight = Math.round(width / aspectRatio);
    } else {
      previewWidth = Math.round(height * aspectRatio);
    }

    await image
      .resize(previewWidth, previewHeight, { fit: 'inside', withoutEnlargement: true })
      .webp({ quality })
      .toFile(previewPath);

    return {
      thumbnailPath: previewPath,
      width: previewWidth,
      height: previewHeight,
    };
  }

  /**
   * Convert image buffer to WebP format
   */
  async convertToWebP(buffer: Buffer, outputPath: string, quality = 85): Promise<void> {
    await sharp(buffer).webp({ quality }).toFile(outputPath);
  }
}
