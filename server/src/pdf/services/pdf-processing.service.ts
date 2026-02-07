import { Injectable } from '@nestjs/common';
import { join } from 'node:path';
import { StorageCore } from 'src/cores/storage.core';
import { AuthDto } from 'src/dtos/auth.dto';
import { AssetType } from 'src/enum';
import { JobName, JobStatus, QueueName } from 'src/enum';
import { BaseService } from 'src/services/base.service';
import { OnJob } from 'src/decorators';
import { JobOf } from 'src/types';
import { PdfExtractorUtil } from '../utils/pdf-extractor.util';
import { PdfThumbnailUtil } from '../utils/pdf-thumbnail.util';
import { PdfOcrService } from './pdf-ocr.service';
import { Insertable } from 'kysely';
import { PdfAssetTable } from 'src/schema/tables/pdf-asset.table';
import { PdfPageTable } from 'src/schema/tables/pdf-page.table';
import { StorageFolder } from 'src/enum';
import { mkdir, writeFile, readFile, rm } from 'node:fs/promises';
import { randomUUID } from 'node:crypto';
import { exec } from 'node:child_process';
import { promisify } from 'node:util';
import sharp from 'sharp';

const execAsync = promisify(exec);

export interface PdfProcessingOptions {
  performOcr: boolean;
  generateThumbnails: boolean;
  ocrLanguage?: string;
}

@Injectable()
export class PdfProcessingService extends BaseService {
  constructor(
    logger: any,
    accessRepository: any,
    activityRepository: any,
    albumRepository: any,
    albumUserRepository: any,
    apiKeyRepository: any,
    appRepository: any,
    assetRepository: any,
    assetEditRepository: any,
    assetJobRepository: any,
    auditRepository: any,
    configRepository: any,
    cronRepository: any,
    cryptoRepository: any,
    databaseRepository: any,
    downloadRepository: any,
    duplicateRepository: any,
    emailRepository: any,
    eventRepository: any,
    jobRepository: any,
    libraryRepository: any,
    machineLearningRepository: any,
    mapRepository: any,
    mediaRepository: any,
    memoryRepository: any,
    metadataRepository: any,
    moveRepository: any,
    notificationRepository: any,
    oauthRepository: any,
    ocrRepository: any,
    partnerRepository: any,
    pdfPageRepository: any,
    pdfRepository: any,
    personRepository: any,
    pluginRepository: any,
    processRepository: any,
    searchRepository: any,
    serverInfoRepository: any,
    sessionRepository: any,
    sharedLinkRepository: any,
    sharedLinkAssetRepository: any,
    stackRepository: any,
    storageRepository: any,
    syncRepository: any,
    syncCheckpointRepository: any,
    systemMetadataRepository: any,
    tagRepository: any,
    telemetryRepository: any,
    trashRepository: any,
    userRepository: any,
    versionRepository: any,
    viewRepository: any,
    websocketRepository: any,
    workflowRepository: any,
    private pdfExtractorUtil: PdfExtractorUtil,
    private pdfThumbnailUtil: PdfThumbnailUtil,
    private pdfOcrService: PdfOcrService,
  ) {
    super(
      logger,
      accessRepository,
      activityRepository,
      albumRepository,
      albumUserRepository,
      apiKeyRepository,
      appRepository,
      assetRepository,
      assetEditRepository,
      assetJobRepository,
      auditRepository,
      configRepository,
      cronRepository,
      cryptoRepository,
      databaseRepository,
      downloadRepository,
      duplicateRepository,
      emailRepository,
      eventRepository,
      jobRepository,
      libraryRepository,
      machineLearningRepository,
      mapRepository,
      mediaRepository,
      memoryRepository,
      metadataRepository,
      moveRepository,
      notificationRepository,
      oauthRepository,
      ocrRepository,
      partnerRepository,
      pdfPageRepository,
      pdfRepository,
      personRepository,
      pluginRepository,
      processRepository,
      searchRepository,
      serverInfoRepository,
      sessionRepository,
      sharedLinkRepository,
      sharedLinkAssetRepository,
      stackRepository,
      storageRepository,
      syncRepository,
      syncCheckpointRepository,
      systemMetadataRepository,
      tagRepository,
      telemetryRepository,
      trashRepository,
      userRepository,
      versionRepository,
      viewRepository,
      websocketRepository,
      workflowRepository,
    );
  }

  /**
   * Process a PDF asset (job handler)
   */

  /**
   * Queue all PDFs for processing (job handler)
   */
  @OnJob({ name: JobName.PdfQueueAll, queue: QueueName.Pdf })
  async handleQueueAllPdf({ force }: JobOf<JobName.PdfQueueAll>): Promise<JobStatus> {
    let queue: { name: JobName.PdfProcessing; data: { id: string } }[] = [];

    // Stream all PDF assets that need processing
    for await (const asset of this.assetJobRepository.streamForPdfProcessing(force)) {
      queue.push({ name: JobName.PdfProcessing, data: { id: asset.id } });

      if (queue.length >= 100) {
        await this.jobRepository.queueAll(queue);
        queue = [];
      }
    }

    // Queue any remaining items
    if (queue.length > 0) {
      await this.jobRepository.queueAll(queue);
    }

    return JobStatus.Success;
  }
@OnJob({ name: JobName.PdfProcessing, queue: QueueName.Pdf })
async handlePdfProcessing({ id }: JobOf<JobName.PdfProcessing>): Promise<JobStatus> {
    const asset = await this.assetRepository.getById(id);
    if (!asset) {
      return JobStatus.Failed;
    }

    // Verify it's a PDF file
    if (asset.type !== AssetType.Other || !asset.originalPath.toLowerCase().endsWith('.pdf')) {
      return JobStatus.Skipped;
    }

    // Get PDF storage path
    const pdfPath = asset.originalPath;
    const options: PdfProcessingOptions = {
      performOcr: true,
      generateThumbnails: true,
    };

    try {
      await this.processPdf(id, asset.ownerId, pdfPath, options);
      return JobStatus.Success;
    } catch (error) {
      this.logger.error(`Failed to process PDF ${id}: ${error}`);
      return JobStatus.Failed;
    }
  }

  /**
   * Process a PDF file: extract metadata, text, generate thumbnails, perform OCR
   */
  async processPdf(
    assetId: string,
    userId: string,
    pdfPath: string,
    options: PdfProcessingOptions,
  ): Promise<void> {
    // Extract PDF metadata and text
    const extractionResult = await this.pdfExtractorUtil.extractPdf(pdfPath);

    // Get or create PDF storage directories
    const pagesDir = this.getPdfPagesDir(userId, assetId);
    const thumbnailsDir = this.getPdfThumbnailsDir(userId, assetId);

    // Create PDF asset record
    const pdfAssetData: Insertable<PdfAssetTable> = {
      assetId,
      pageCount: extractionResult.metadata.pageCount,
      hasText: extractionResult.metadata.hasText,
      isOCRProcessed: false,
      fileSizeInByte: extractionResult.metadata.pageCount, // Will be updated with actual file size
      author: extractionResult.metadata.author || null,
      title: extractionResult.metadata.title || null,
      subject: extractionResult.metadata.subject || null,
      keywords: extractionResult.metadata.keywords || null,
      creator: extractionResult.metadata.creator || null,
      producer: extractionResult.metadata.producer || null,
    };

    await this.pdfRepository.create(pdfAssetData);

    // Create page records and generate thumbnails
    const allSearchableText: string[] = [];

    // Create pages directory for temporary PNG files
    await mkdir(pagesDir, { recursive: true });

    for (const pageData of extractionResult.pages) {
      // Create page thumbnail path
      const thumbnailPath = join(thumbnailsDir, `page-${pageData.pageNumber.toString().padStart(3, '0')}-thumb.webp`);

      // Convert PDF page to PNG and get dimensions
      const pageImagePath = join(pagesDir, `page-${pageData.pageNumber.toString().padStart(3, '0')}.png`);
      let pageWidth: number | null = null;
      let pageHeight: number | null = null;

      try {
        const dimensions = await this.convertPdfPageToImage(pdfPath, pageData.pageNumber, pageImagePath);
        pageWidth = dimensions.width;
        pageHeight = dimensions.height;

        // Generate thumbnail from the PNG
        const thumbnailResult = await this.pdfThumbnailUtil.generateThumbnail(
          pageImagePath,
          thumbnailsDir,
          pageData.pageNumber,
        );

        // Clean up the temporary PNG file
        await rm(pageImagePath, { force: true });
      } catch (error) {
        this.logger.warn(`Failed to convert page ${pageData.pageNumber} to image: ${error}`);
        // Continue without thumbnail - the page record will still be created
      }

      // Create page record
      const pageDataToInsert: Insertable<PdfPageTable> = {
        assetId,
        pageNumber: pageData.pageNumber,
        width: pageWidth,
        height: pageHeight,
        textContent: pageData.text || null,
        thumbnailPath,
        searchableText: pageData.text || '',
      };

      const createdPage = await this.pdfPageRepository.create(pageDataToInsert);
      allSearchableText.push(pageData.text || '');
    }

    // Update search index with extracted text
    const fullSearchText = allSearchableText.join(' ');
    if (fullSearchText.trim().length > 0) {
      await this.pdfPageRepository.upsertSearchText(assetId, fullSearchText);
    }

    this.logger.debug(`Processed PDF ${assetId} with ${extractionResult.metadata.pageCount} pages`);
  }

  /**
   * Convert a PDF page to an image using pdf-poppler (pdftoppm)
   */
  private async convertPdfPageToImage(
    pdfPath: string,
    pageNumber: number,
    outputPath: string,
  ): Promise<{ width: number; height: number }> {
    // Ensure output directory exists
    const outputDir = outputPath.substring(0, outputPath.lastIndexOf('/'));
    await mkdir(outputDir, { recursive: true });

    // Use pdftoppm to convert PDF page to image
    // -png: output as PNG
    // -f <page>: first page to convert
    // -l <page>: last page to convert
    // -singlefile: output only one file
    // <pdf> <output-prefix>
    const outputPrefix = outputPath.replace('.png', '');
    await execAsync(`pdftoppm -png -f ${pageNumber} -l ${pageNumber} -singlefile "${pdfPath}" "${outputPrefix}"`);

    // Get image dimensions using sharp
    const metadata = await sharp(outputPath).metadata();
    const width = metadata.width || 1920;
    const height = metadata.height || 1080;

    return { width, height };
  }

  /**
   * Get the path to a PDF file
   */
  private getPdfPath(userId: string, assetId: string): string {
    return join(StorageCore.getFolderLocation(StorageFolder.Upload, userId), 'pdf', assetId, 'original.pdf');
  }

  /**
   * Get the directory for PDF page images
   */
  private getPdfPagesDir(userId: string, assetId: string): string {
    return join(StorageCore.getFolderLocation(StorageFolder.Upload, userId), 'pdf', assetId, 'pages');
  }

  /**
   * Get the directory for PDF page thumbnails
   */
  private getPdfThumbnailsDir(userId: string, assetId: string): string {
    return join(StorageCore.getFolderLocation(StorageFolder.Upload, userId), 'pdf', assetId, 'thumbnails');
  }
}
