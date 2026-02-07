import { Injectable } from '@nestjs/common';
import { AuthDto } from 'src/dtos/auth.dto';
import { AssetType, Permission } from 'src/enum';
import { BaseService } from 'src/services/base.service';
import { mapAsset, AssetResponseDto } from 'src/dtos/asset-response.dto';
import {
  PdfAssetResponseDto,
  PdfPageResponseDto,
} from '../dto/pdf-response.dto';
import { PdfPageRepository } from '../repositories/pdf-page.repository';
import { PdfRepository } from '../repositories/pdf.repository';
import { searchAssetBuilder } from 'src/utils/database';
import { AssetSearchOptions } from 'src/repositories/search.repository';
import { paginationHelper } from 'src/utils/pagination';
import { InjectKysely } from 'nestjs-kysely';
import { Kysely } from 'kysely';
import { DB } from 'src/schema';

@Injectable()
export class PdfService extends BaseService {
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
    pdfPageRepository: PdfPageRepository,
    pdfRepository: PdfRepository,
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
    @InjectKysely() private db: Kysely<DB>,
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
   * Get all PDF assets for the authenticated user
   * Uses search to find PDF files (type = OTHER with .pdf extension)
   */
  async getPdfAssets(auth: AuthDto): Promise<AssetResponseDto[]> {
    this.requireAccess({
      auth,
      permission: Permission.AssetRead,
      ids: [auth.user.id],
    });

    // Use searchAssetBuilder to find all assets for the user
    // We need to get all assets and filter for PDF files by file extension
    // since PDF files have type AssetType.Other
    const options: AssetSearchOptions = {
      userIds: [auth.user.id],
      type: AssetType.Other,
      // No additional filters needed - we'll filter by file extension
    };

    const assets = await searchAssetBuilder(this.db, options)
      .selectAll('asset')
      .execute();

    // Filter for PDF files by file extension
    const pdfAssets = assets.filter(
      (asset) => asset.originalPath?.toLowerCase().endsWith('.pdf')
    );

    return pdfAssets.map((asset) => mapAsset(asset, { auth }));
  }

  /**
   * Get PDF asset metadata with pages
   */
  async getPdfAsset(auth: AuthDto, assetId: string): Promise<PdfAssetResponseDto> {
    const asset = await this.findPdfAsset(auth, assetId);

    const pdfAsset = await this.pdfRepository.getByAssetId(assetId);
    if (!pdfAsset) {
      throw new Error('PDF metadata not found');
    }

    const pages = await this.pdfPageRepository.getByAssetId(assetId);

    return {
      assetId,
      metadata: {
        pageCount: pdfAsset.pageCount,
        hasText: pdfAsset.hasText,
        isOCRProcessed: pdfAsset.isOCRProcessed,
        fileSizeInByte: Number(pdfAsset.fileSizeInByte),
        author: pdfAsset.author ?? undefined,
        title: pdfAsset.title ?? undefined,
        subject: pdfAsset.subject ?? undefined,
        keywords: pdfAsset.keywords ?? undefined,
        creator: pdfAsset.creator ?? undefined,
        producer: pdfAsset.producer ?? undefined,
        createdAt: pdfAsset.createdAt,
        updatedAt: pdfAsset.updatedAt,
      },
      pages: pages.map((page) => ({
        id: page.id,
        assetId: page.assetId,
        pageNumber: page.pageNumber,
        width: page.width ?? undefined,
        height: page.height ?? undefined,
        textContent: page.textContent ?? undefined,
        thumbnailPath: page.thumbnailPath,
        searchableText: page.searchableText,
        createdAt: page.createdAt,
      })),
    };
  }

  /**
   * Get all pages for a PDF asset
   */
  async getPdfPages(auth: AuthDto, assetId: string): Promise<PdfPageResponseDto[]> {
    const asset = await this.findPdfAsset(auth, assetId);

    const pages = await this.pdfPageRepository.getByAssetId(assetId);

    return pages.map((page) => ({
      id: page.id,
      assetId: page.assetId,
      pageNumber: page.pageNumber,
      width: page.width ?? undefined,
      height: page.height ?? undefined,
      textContent: page.textContent ?? undefined,
      thumbnailPath: page.thumbnailPath,
      searchableText: page.searchableText,
      createdAt: page.createdAt,
    }));
  }

  /**
   * Get a specific page with image
   */
  async getPdfPage(auth: AuthDto, assetId: string, pageNumber: number): Promise<PdfPageResponseDto> {
    const asset = await this.findPdfAsset(auth, assetId);

    const page = await this.pdfPageRepository.getByAssetIdAndPageNumber(assetId, pageNumber);
    if (!page) {
      throw new Error('Page not found');
    }

    return {
      id: page.id,
      assetId: page.assetId,
      pageNumber: page.pageNumber,
      width: page.width ?? undefined,
      height: page.height ?? undefined,
      textContent: page.textContent ?? undefined,
      thumbnailPath: page.thumbnailPath,
      searchableText: page.searchableText,
      createdAt: page.createdAt,
    };
  }

  /**
   * Get the PDF file path for download
   */
  async getPdfDownloadPath(auth: AuthDto, assetId: string): Promise<string> {
    const asset = await this.findPdfAsset(auth, assetId);
    return asset.originalPath;
  }

  /**
   * Get page image path
   */
  async getPageImagePath(pageId: string): Promise<string> {
    const page = await this.pdfPageRepository.getById(pageId);
    if (!page) {
      throw new Error('Page not found');
    }

    const asset = await this.assetRepository.getById(page.assetId);
    if (!asset) {
      throw new Error('Asset not found');
    }

    return page.thumbnailPath;
  }

  /**
   * Find a PDF asset and verify access
   */
  private async findPdfAsset(auth: AuthDto, assetId: string) {
    const asset = await this.assetRepository.getById(assetId);
    if (!asset) {
      throw new Error('Asset not found');
    }

    if (asset.type !== AssetType.Other || !asset.originalPath.toLowerCase().endsWith('.pdf')) {
      throw new Error('Asset is not a PDF');
    }

    this.requireAccess({
      auth,
      permission: Permission.AssetRead,
      ids: [assetId],
    });

    return asset;
  }
}
