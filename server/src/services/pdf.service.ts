import { Injectable } from '@nestjs/common';
import * as fs from 'node:fs';
import * as os from 'node:os';
import * as path from 'node:path';
import { StorageCore } from 'src/cores/storage.core';
import { OnEvent, OnJob } from 'src/decorators';
import { AuthDto } from 'src/dtos/auth.dto';
import { AssetFileType, ImageFormat, JobName, JobStatus, Permission, QueueName } from 'src/enum';
import { ArgOf } from 'src/repositories/event.repository';
import { BaseService } from 'src/services/base.service';
import { JobOf } from 'src/types';
import { mimeTypes } from 'src/utils/mime-types';
import { isOcrEnabled } from 'src/utils/misc';

@Injectable()
export class PdfService extends BaseService {
  @OnEvent({ name: 'AssetMetadataExtracted' })
  async onAssetMetadataExtracted({ assetId }: ArgOf<'AssetMetadataExtracted'>) {
    const asset = await this.assetRepository.getById(assetId);
    if (!asset) {
      return;
    }

    if (mimeTypes.isPdf(asset.originalPath)) {
      await this.jobRepository.queue({ name: JobName.PdfProcess, data: { id: assetId } });
    }
  }

  @OnJob({ name: JobName.PdfQueueAll, queue: QueueName.Pdf })
  async handleQueueAll(_data: JobOf<JobName.PdfQueueAll>): Promise<JobStatus> {
    this.logger.debug('PDF queue all triggered');
    return JobStatus.Success;
  }

  @OnJob({ name: JobName.PdfProcess, queue: QueueName.Pdf })
  async handlePdfProcess({ id }: JobOf<JobName.PdfProcess>): Promise<JobStatus> {
    const asset = await this.assetRepository.getById(id);
    if (!asset) {
      this.logger.warn(`Asset not found: ${id}`);
      return JobStatus.Failed;
    }

    if (!mimeTypes.isPdf(asset.originalPath)) {
      return JobStatus.Skipped;
    }

    try {
      const mupdf = await import('mupdf');

      const fileData = fs.readFileSync(asset.originalPath);
      const doc = mupdf.Document.openDocument(fileData, 'application/pdf');

      const pageCount = doc.countPages();

      // Extract metadata
      const title = doc.getMetaData('info:Title') || null;
      const author = doc.getMetaData('info:Author') || null;
      const subject = doc.getMetaData('info:Subject') || null;
      const creator = doc.getMetaData('info:Creator') || null;
      const producer = doc.getMetaData('info:Producer') || null;
      const creationDateStr = doc.getMetaData('info:CreationDate') || null;
      const creationDate = creationDateStr ? this.parsePdfDate(creationDateStr) : null;

      await this.pdfRepository.upsertDocument({
        assetId: id,
        pageCount,
        title,
        author,
        subject,
        creator,
        producer,
        creationDate: creationDate?.toISOString() ?? null,
        processedAt: new Date().toISOString(),
      });

      // Extract text from each page
      const allTexts: string[] = [];
      const pages = [];

      for (let i = 0; i < pageCount; i++) {
        const page = doc.loadPage(i);
        const stext = page.toStructuredText();
        const text = stext.asText();

        const bounds = page.getBounds();
        const width = bounds[2] - bounds[0];
        const height = bounds[3] - bounds[1];

        const textSource = text.trim().length < 10 ? 'none' : 'embedded';

        pages.push({
          assetId: id,
          pageNumber: i + 1,
          text: text || '',
          textSource,
          width,
          height,
        });

        allTexts.push(text || '');
      }

      await this.pdfRepository.upsertPages(pages);

      const fullText = allTexts.join('\n');
      await this.pdfRepository.upsertSearch(id, fullText);

      // Generate thumbnail from page 1
      try {
        await this.generateThumbnail(mupdf, doc, asset);
      } catch (error) {
        this.logger.warn(`Failed to generate PDF thumbnail for ${id}: ${error}`);
      }

      // OCR scanned pages (pages with textSource='none')
      const scannedPages = pages.filter((p) => p.textSource === 'none');
      if (scannedPages.length > 0) {
        await this.ocrScannedPages(mupdf, doc, id, scannedPages);

        // Rebuild search index after OCR
        const updatedPages = await this.pdfRepository.getPagesByAssetId(id);
        const updatedFullText = updatedPages.map((p) => p.text).join('\n');
        await this.pdfRepository.upsertSearch(id, updatedFullText);
      }

      this.logger.debug(`Processed PDF ${id}: ${pageCount} pages, ${scannedPages.length} OCR'd`);
      return JobStatus.Success;
    } catch (error) {
      this.logger.error(`Failed to process PDF ${id}: ${error}`);
      return JobStatus.Failed;
    }
  }

  async getDocuments(auth: AuthDto) {
    return this.pdfRepository.getDocumentsByOwnerId(auth.user.id);
  }

  async getDocument(auth: AuthDto, assetId: string) {
    await this.requireAccess({ auth, permission: Permission.AssetRead, ids: [assetId] });
    return this.pdfRepository.getDocumentByAssetId(assetId);
  }

  async getPages(auth: AuthDto, assetId: string) {
    await this.requireAccess({ auth, permission: Permission.AssetRead, ids: [assetId] });
    return this.pdfRepository.getPagesByAssetId(assetId);
  }

  async getPage(auth: AuthDto, assetId: string, pageNumber: number) {
    await this.requireAccess({ auth, permission: Permission.AssetRead, ids: [assetId] });
    return this.pdfRepository.getPage(assetId, pageNumber);
  }

  async searchDocuments(auth: AuthDto, query: string) {
    return this.pdfRepository.searchByOwner(query, auth.user.id);
  }

  private async generateThumbnail(mupdf: any, doc: any, asset: { id: string; ownerId: string }) {
    const sharp = (await import('sharp')).default;
    const page = doc.loadPage(0);

    // Render at 150 DPI (default PDF is 72 DPI)
    const scale = 150 / 72;
    const pixmap = page.toPixmap(
      [scale, 0, 0, scale, 0, 0],
      mupdf.ColorSpace.DeviceRGB,
      false,
      true,
    );
    const pngBuffer = pixmap.asPNG();

    const previewBuffer = await sharp(Buffer.from(pngBuffer))
      .resize(1440, 1440, { fit: 'inside', withoutEnlargement: true })
      .jpeg({ quality: 80 })
      .toBuffer();

    const thumbnailBuffer = await sharp(Buffer.from(pngBuffer))
      .resize(250, 250, { fit: 'inside', withoutEnlargement: true })
      .webp({ quality: 80 })
      .toBuffer();

    const previewPath = StorageCore.getImagePath(
      { id: asset.id, ownerId: asset.ownerId },
      { fileType: AssetFileType.Preview, format: ImageFormat.Jpeg, isEdited: false },
    );
    const thumbnailPath = StorageCore.getImagePath(
      { id: asset.id, ownerId: asset.ownerId },
      { fileType: AssetFileType.Thumbnail, format: ImageFormat.Webp, isEdited: false },
    );

    fs.mkdirSync(path.dirname(previewPath), { recursive: true });
    fs.writeFileSync(previewPath, previewBuffer);

    fs.mkdirSync(path.dirname(thumbnailPath), { recursive: true });
    fs.writeFileSync(thumbnailPath, thumbnailBuffer);

    await this.assetRepository.upsertFile({ assetId: asset.id, type: AssetFileType.Preview, path: previewPath });
    await this.assetRepository.upsertFile({ assetId: asset.id, type: AssetFileType.Thumbnail, path: thumbnailPath });
  }

  private async ocrScannedPages(
    mupdf: any,
    doc: any,
    assetId: string,
    scannedPages: { pageNumber: number }[],
  ) {
    try {
      const { machineLearning } = await this.getConfig({ withCache: true });
      if (!isOcrEnabled(machineLearning)) {
        return;
      }

      for (const { pageNumber } of scannedPages) {
        const page = doc.loadPage(pageNumber - 1);
        const scale = 300 / 72; // 300 DPI for OCR

        const pixmap = page.toPixmap(
          [scale, 0, 0, scale, 0, 0],
          mupdf.ColorSpace.DeviceRGB,
          false,
          true,
        );
        const pngBuffer = pixmap.asPNG();

        const tmpFile = path.join(os.tmpdir(), `pdf-ocr-${assetId}-${pageNumber}.png`);
        fs.writeFileSync(tmpFile, Buffer.from(pngBuffer));

        try {
          const ocrResult = await this.machineLearningRepository.ocr(tmpFile, machineLearning.ocr);

          if (ocrResult.text && ocrResult.text.length > 0) {
            const ocrText = ocrResult.text.join(' ');
            await this.pdfRepository.upsertPages([
              {
                assetId,
                pageNumber,
                text: ocrText,
                textSource: 'ocr',
                width: null,
                height: null,
              },
            ]);
          }
        } finally {
          fs.unlinkSync(tmpFile);
        }
      }
    } catch (error) {
      this.logger.warn(`OCR failed for PDF ${assetId}: ${error}`);
    }
  }

  private parsePdfDate(dateStr: string): Date | null {
    // PDF dates are in format: D:YYYYMMDDHHmmSSOHH'mm'
    try {
      const match = dateStr.match(/D:(\d{4})(\d{2})(\d{2})(\d{2})?(\d{2})?(\d{2})?/);
      if (!match) {
        return new Date(dateStr);
      }

      const [, year, month, day, hours = '00', minutes = '00', seconds = '00'] = match;
      return new Date(`${year}-${month}-${day}T${hours}:${minutes}:${seconds}Z`);
    } catch {
      return null;
    }
  }
}
