import { Injectable } from '@nestjs/common';
import { join } from 'node:path';
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
import { StorageCore } from 'src/cores/storage.core';

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

    // TODO: Implement proper search for PDF files
    // For now, return empty array as a placeholder
    return [];
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
