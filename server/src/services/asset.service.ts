import { BadRequestException, Injectable } from '@nestjs/common';
import _ from 'lodash';
import { DateTime, Duration } from 'luxon';
import { JOBS_ASSET_PAGINATION_SIZE } from 'src/constants';
import { AssetFile } from 'src/database';
import { OnJob } from 'src/decorators';
import { AssetResponseDto, MapAsset, SanitizedAssetResponseDto, mapAsset } from 'src/dtos/asset-response.dto';
import {
  AssetBulkDeleteDto,
  AssetBulkUpdateDto,
  AssetCopyDto,
  AssetJobName,
  AssetJobsDto,
  AssetMetadataResponseDto,
  AssetMetadataUpsertDto,
  AssetStatsDto,
  UpdateAssetDto,
  mapStats,
} from 'src/dtos/asset.dto';
import { AuthDto } from 'src/dtos/auth.dto';
import { AssetOcrResponseDto } from 'src/dtos/ocr.dto';
import { PdfPageResponseDto, PdfPagesResponseDto, SetPdfMainPageDto } from 'src/dtos/pdf.dto';
import {
  AssetFileType,
  AssetMetadataKey,
  AssetStatus,
  AssetType,
  AssetVisibility,
  JobName,
  JobStatus,
  Permission,
  QueueName,
} from 'src/enum';
import { BaseService } from 'src/services/base.service';
import { JobItem, JobOf } from 'src/types';
import { requireElevatedPermission } from 'src/utils/access';
import { getAssetFiles, getMyPartnerIds, onAfterUnlink, onBeforeLink, onBeforeUnlink } from 'src/utils/asset.util';
import { updateLockedColumns } from 'src/utils/database';

@Injectable()
export class AssetService extends BaseService {
  async getStatistics(auth: AuthDto, dto: AssetStatsDto) {
    if (dto.visibility === AssetVisibility.Locked) {
      requireElevatedPermission(auth);
    }

    const stats = await this.assetRepository.getStatistics(auth.user.id, dto);
    return mapStats(stats);
  }

  async getRandom(auth: AuthDto, count: number): Promise<AssetResponseDto[]> {
    const partnerIds = await getMyPartnerIds({
      userId: auth.user.id,
      repository: this.partnerRepository,
      timelineEnabled: true,
    });
    const assets = await this.assetRepository.getRandom([auth.user.id, ...partnerIds], count);
    return assets.map((a) => mapAsset(a, { auth }));
  }

  async getUserAssetsByDeviceId(auth: AuthDto, deviceId: string) {
    return this.assetRepository.getAllByDeviceId(auth.user.id, deviceId);
  }

  async get(auth: AuthDto, id: string): Promise<AssetResponseDto | SanitizedAssetResponseDto> {
    await this.requireAccess({ auth, permission: Permission.AssetRead, ids: [id] });

    const asset = await this.assetRepository.getById(id, {
      exifInfo: true,
      owner: true,
      faces: { person: true },
      stack: { assets: true },
      tags: true,
    });

    if (!asset) {
      throw new BadRequestException('Asset not found');
    }

    if (auth.sharedLink && !auth.sharedLink.showExif) {
      return mapAsset(asset, { stripMetadata: true, withStack: true, auth });
    }

    const data = mapAsset(asset, { withStack: true, auth });

    if (auth.sharedLink) {
      delete data.owner;
    }

    if (data.ownerId !== auth.user.id || auth.sharedLink) {
      data.people = [];
    }

    return data;
  }

  async update(auth: AuthDto, id: string, dto: UpdateAssetDto): Promise<AssetResponseDto> {
    await this.requireAccess({ auth, permission: Permission.AssetUpdate, ids: [id] });

    const { description, dateTimeOriginal, latitude, longitude, rating, ...rest } = dto;
    const repos = { asset: this.assetRepository, event: this.eventRepository };

    let previousMotion: MapAsset | null = null;
    if (rest.livePhotoVideoId) {
      await onBeforeLink(repos, { userId: auth.user.id, livePhotoVideoId: rest.livePhotoVideoId });
    } else if (rest.livePhotoVideoId === null) {
      const asset = await this.findOrFail(id);
      if (asset.livePhotoVideoId) {
        previousMotion = await onBeforeUnlink(repos, { livePhotoVideoId: asset.livePhotoVideoId });
      }
    }

    await this.updateExif({ id, description, dateTimeOriginal, latitude, longitude, rating });

    const asset = await this.assetRepository.update({ id, ...rest });

    if (previousMotion && asset) {
      await onAfterUnlink(repos, {
        userId: auth.user.id,
        livePhotoVideoId: previousMotion.id,
        visibility: asset.visibility,
      });
    }

    if (!asset) {
      throw new BadRequestException('Asset not found');
    }

    return mapAsset(asset, { auth });
  }

  async updateAll(auth: AuthDto, dto: AssetBulkUpdateDto): Promise<void> {
    const {
      ids,
      isFavorite,
      visibility,
      dateTimeOriginal,
      latitude,
      longitude,
      rating,
      description,
      duplicateId,
      dateTimeRelative,
      timeZone,
    } = dto;
    await this.requireAccess({ auth, permission: Permission.AssetUpdate, ids });

    const assetDto = _.omitBy({ isFavorite, visibility, duplicateId }, _.isUndefined);
    const exifDto = _.omitBy(
      {
        latitude,
        longitude,
        rating,
        description,
        dateTimeOriginal,
      },
      _.isUndefined,
    );
    const extractedTimeZone = dateTimeOriginal ? DateTime.fromISO(dateTimeOriginal, { setZone: true }).zone : undefined;

    if (Object.keys(exifDto).length > 0) {
      await this.assetRepository.updateAllExif(ids, exifDto);
    }

    if (
      (dateTimeRelative !== undefined && dateTimeRelative !== 0) ||
      timeZone !== undefined ||
      extractedTimeZone?.type === 'fixed'
    ) {
      await this.assetRepository.updateDateTimeOriginal(ids, dateTimeRelative, timeZone ?? extractedTimeZone?.name);
    }

    if (Object.keys(assetDto).length > 0) {
      await this.assetRepository.updateAll(ids, assetDto);
    }

    if (visibility === AssetVisibility.Locked) {
      await this.albumRepository.removeAssetsFromAll(ids);
    }

    await this.jobRepository.queueAll(ids.map((id) => ({ name: JobName.SidecarWrite, data: { id } })));
  }

  async copy(
    auth: AuthDto,
    {
      sourceId,
      targetId,
      albums = true,
      sidecar = true,
      sharedLinks = true,
      stack = true,
      favorite = true,
    }: AssetCopyDto,
  ) {
    await this.requireAccess({ auth, permission: Permission.AssetCopy, ids: [sourceId, targetId] });
    const sourceAsset = await this.assetRepository.getForCopy(sourceId);
    const targetAsset = await this.assetRepository.getForCopy(targetId);

    if (!sourceAsset || !targetAsset) {
      throw new BadRequestException('Both assets must exist');
    }

    if (sourceId === targetId) {
      throw new BadRequestException('Source and target id must be distinct');
    }

    if (albums) {
      await this.albumRepository.copyAlbums({ sourceAssetId: sourceId, targetAssetId: targetId });
    }

    if (sharedLinks) {
      await this.sharedLinkAssetRepository.copySharedLinks({ sourceAssetId: sourceId, targetAssetId: targetId });
    }

    if (stack) {
      await this.copyStack({ sourceAsset, targetAsset });
    }

    if (favorite) {
      await this.assetRepository.update({ id: targetId, isFavorite: sourceAsset.isFavorite });
    }

    if (sidecar) {
      await this.copySidecar({ sourceAsset, targetAsset });
    }
  }

  private async copyStack({
    sourceAsset,
    targetAsset,
  }: {
    sourceAsset: { id: string; stackId: string | null };
    targetAsset: { id: string; stackId: string | null };
  }) {
    if (!sourceAsset.stackId) {
      return;
    }

    if (targetAsset.stackId) {
      await this.stackRepository.merge({ sourceId: sourceAsset.stackId, targetId: targetAsset.stackId });
      await this.stackRepository.delete(sourceAsset.stackId);
    } else {
      await this.assetRepository.update({ id: targetAsset.id, stackId: sourceAsset.stackId });
    }
  }

  private async copySidecar({
    sourceAsset,
    targetAsset,
  }: {
    sourceAsset: { files: AssetFile[] };
    targetAsset: { id: string; files: AssetFile[]; originalPath: string };
  }) {
    const { sidecarFile: sourceFile } = getAssetFiles(sourceAsset.files);
    if (!sourceFile?.path) {
      return;
    }

    const { sidecarFile: targetFile } = getAssetFiles(targetAsset.files ?? []);
    if (targetFile?.path) {
      await this.storageRepository.unlink(targetFile.path);
    }

    await this.storageRepository.copyFile(sourceFile.path, `${targetAsset.originalPath}.xmp`);
    await this.assetRepository.upsertFile({
      assetId: targetAsset.id,
      path: `${targetAsset.originalPath}.xmp`,
      type: AssetFileType.Sidecar,
    });
    await this.jobRepository.queue({ name: JobName.AssetExtractMetadata, data: { id: targetAsset.id } });
  }

  @OnJob({ name: JobName.AssetDeleteCheck, queue: QueueName.BackgroundTask })
  async handleAssetDeletionCheck(): Promise<JobStatus> {
    const config = await this.getConfig({ withCache: false });
    const trashedDays = config.trash.enabled ? config.trash.days : 0;
    const trashedBefore = DateTime.now()
      .minus(Duration.fromObject({ days: trashedDays }))
      .toJSDate();

    let chunk: Array<{ id: string; isOffline: boolean }> = [];
    const queueChunk = async () => {
      if (chunk.length > 0) {
        await this.jobRepository.queueAll(
          chunk.map(({ id, isOffline }) => ({
            name: JobName.AssetDelete,
            data: { id, deleteOnDisk: !isOffline },
          })),
        );
        chunk = [];
      }
    };

    const assets = this.assetJobRepository.streamForDeletedJob(trashedBefore);
    for await (const asset of assets) {
      chunk.push(asset);
      if (chunk.length >= JOBS_ASSET_PAGINATION_SIZE) {
        await queueChunk();
      }
    }

    await queueChunk();

    return JobStatus.Success;
  }

  @OnJob({ name: JobName.AssetDelete, queue: QueueName.BackgroundTask })
  async handleAssetDeletion(job: JobOf<JobName.AssetDelete>): Promise<JobStatus> {
    const { id, deleteOnDisk } = job;

    const asset = await this.assetJobRepository.getForAssetDeletion(id);

    if (!asset) {
      return JobStatus.Failed;
    }

    // Replace the parent of the stack children with a new asset
    if (asset.stack?.primaryAssetId === id) {
      const stackAssetIds = asset.stack?.assets.map((a) => a.id) ?? [];
      if (stackAssetIds.length > 2) {
        const newPrimaryAssetId = stackAssetIds.find((a) => a !== id)!;
        await this.stackRepository.update(asset.stack.id, {
          id: asset.stack.id,
          primaryAssetId: newPrimaryAssetId,
        });
      } else {
        await this.stackRepository.delete(asset.stack.id);
      }
    }

    await this.assetRepository.remove(asset);
    if (!asset.libraryId) {
      await this.userRepository.updateUsage(asset.ownerId, -(asset.exifInfo?.fileSizeInByte || 0));
    }

    await this.eventRepository.emit('AssetDelete', { assetId: id, userId: asset.ownerId });

    // delete the motion if it is not used by another asset
    if (asset.livePhotoVideoId) {
      const count = await this.assetRepository.getLivePhotoCount(asset.livePhotoVideoId);
      if (count === 0) {
        await this.jobRepository.queue({
          name: JobName.AssetDelete,
          data: { id: asset.livePhotoVideoId, deleteOnDisk },
        });
      }
    }

    const { fullsizeFile, previewFile, thumbnailFile, sidecarFile } = getAssetFiles(asset.files ?? []);
    const files = [thumbnailFile?.path, previewFile?.path, fullsizeFile?.path, asset.encodedVideoPath];

    if (deleteOnDisk && !asset.isOffline) {
      files.push(sidecarFile?.path, asset.originalPath);
    }

    await this.jobRepository.queue({ name: JobName.FileDelete, data: { files: files.filter(Boolean) } });

    return JobStatus.Success;
  }

  async deleteAll(auth: AuthDto, dto: AssetBulkDeleteDto): Promise<void> {
    const { ids, force } = dto;

    await this.requireAccess({ auth, permission: Permission.AssetDelete, ids });
    await this.assetRepository.updateAll(ids, {
      deletedAt: new Date(),
      status: force ? AssetStatus.Deleted : AssetStatus.Trashed,
    });
    await this.eventRepository.emit(force ? 'AssetDeleteAll' : 'AssetTrashAll', {
      assetIds: ids,
      userId: auth.user.id,
    });
  }

  async getMetadata(auth: AuthDto, id: string): Promise<AssetMetadataResponseDto[]> {
    await this.requireAccess({ auth, permission: Permission.AssetRead, ids: [id] });
    return this.assetRepository.getMetadata(id);
  }

  async getOcr(auth: AuthDto, id: string): Promise<AssetOcrResponseDto[]> {
    await this.requireAccess({ auth, permission: Permission.AssetRead, ids: [id] });
    return this.ocrRepository.getByAssetId(id);
  }

  async upsertMetadata(auth: AuthDto, id: string, dto: AssetMetadataUpsertDto): Promise<AssetMetadataResponseDto[]> {
    await this.requireAccess({ auth, permission: Permission.AssetUpdate, ids: [id] });
    return this.assetRepository.upsertMetadata(id, dto.items);
  }

  async getMetadataByKey(auth: AuthDto, id: string, key: AssetMetadataKey): Promise<AssetMetadataResponseDto> {
    await this.requireAccess({ auth, permission: Permission.AssetRead, ids: [id] });

    const item = await this.assetRepository.getMetadataByKey(id, key);
    if (!item) {
      throw new BadRequestException(`Metadata with key "${key}" not found for asset with id "${id}"`);
    }
    return item;
  }

  async deleteMetadataByKey(auth: AuthDto, id: string, key: AssetMetadataKey): Promise<void> {
    await this.requireAccess({ auth, permission: Permission.AssetUpdate, ids: [id] });
    return this.assetRepository.deleteMetadataByKey(id, key);
  }

  async getPdfPages(auth: AuthDto, id: string): Promise<PdfPagesResponseDto> {
    await this.requireAccess({ auth, permission: Permission.AssetRead, ids: [id] });

    const asset = await this.assetRepository.getById(id);
    if (!asset || asset.type !== AssetType.Pdf) {
      throw new BadRequestException('Asset is not a PDF');
    }

    const metadata = await this.assetRepository.getMetadataByKey(id, AssetMetadataKey.PdfInfo);
    const pdfInfo = (metadata?.value as { pageCount?: number; mainPageIndex?: number; status?: string }) || {};
    const pages = await this.assetRepository.getPdfPages(id);

    // Sort pages by pageIndex from metadata
    const sortedPages = pages
      .map((page) => {
        const pageInfo = (page.pageMetadata as { pageIndex?: number }) || {};
        return {
          id: page.id,
          pageIndex: pageInfo.pageIndex ?? 0,
          thumbhash: page.thumbhash ? page.thumbhash.toString('base64') : null,
        } as PdfPageResponseDto;
      })
      .sort((a, b) => a.pageIndex - b.pageIndex);

    return {
      pdfId: id,
      pageCount: pdfInfo.pageCount ?? 0,
      mainPageIndex: pdfInfo.mainPageIndex ?? 0,
      status: (pdfInfo.status as 'processing' | 'completed' | 'failed') ?? 'processing',
      pages: sortedPages,
    };
  }

  async setPdfMainPage(auth: AuthDto, id: string, dto: SetPdfMainPageDto): Promise<AssetResponseDto> {
    await this.requireAccess({ auth, permission: Permission.AssetUpdate, ids: [id] });

    const asset = await this.assetRepository.getById(id);
    if (!asset || asset.type !== AssetType.Pdf) {
      throw new BadRequestException('Asset is not a PDF');
    }

    const pages = await this.assetRepository.getPdfPages(id);
    const targetPage = pages.find((p) => {
      const pageInfo = (p.pageMetadata as { pageIndex?: number }) || {};
      return pageInfo.pageIndex === dto.pageIndex;
    });

    if (!targetPage) {
      throw new BadRequestException('Page index out of range');
    }

    // Update metadata with new main page index
    const metadata = await this.assetRepository.getMetadataByKey(id, AssetMetadataKey.PdfInfo);
    await this.assetRepository.upsertMetadata(id, [
      {
        key: AssetMetadataKey.PdfInfo,
        value: { ...(metadata?.value as object), mainPageIndex: dto.pageIndex },
      },
    ]);

    // Copy thumbnail from new main page to PDF
    const mainPageAsset = await this.assetRepository.getById(targetPage.id, { files: true });
    if (mainPageAsset) {
      const { thumbnailFile, previewFile } = getAssetFiles(mainPageAsset.files ?? []);
      if (thumbnailFile) {
        await this.assetRepository.upsertFile({
          assetId: id,
          path: thumbnailFile.path,
          type: AssetFileType.Thumbnail,
        });
      }
      if (previewFile) {
        await this.assetRepository.upsertFile({
          assetId: id,
          path: previewFile.path,
          type: AssetFileType.Preview,
        });
      }
      if (mainPageAsset.thumbhash) {
        await this.assetRepository.update({ id, thumbhash: mainPageAsset.thumbhash });
      }
    }

    const updated = await this.assetRepository.getById(id, { exifInfo: true, owner: true });
    return mapAsset(updated!, { auth });
  }

  async deletePdfPage(auth: AuthDto, pdfId: string, pageId: string): Promise<void> {
    await this.requireAccess({ auth, permission: Permission.AssetDelete, ids: [pdfId, pageId] });

    const page = await this.assetRepository.getById(pageId);
    if (!page || page.parentId !== pdfId) {
      throw new BadRequestException('Page does not belong to this PDF');
    }

    const pages = await this.assetRepository.getPdfPages(pdfId);
    if (pages.length <= 1) {
      throw new BadRequestException('Cannot delete the last page of a PDF');
    }

    // Get page index of the page being deleted
    const pageMetadata = await this.assetRepository.getMetadataByKey(pageId, AssetMetadataKey.PdfInfo);
    const deletedPageIndex = (pageMetadata?.value as { pageIndex?: number })?.pageIndex ?? 0;

    // Delete the page asset
    await this.assetRepository.remove({ id: pageId });

    // Update page count and main page index in metadata
    const pdfMetadata = await this.assetRepository.getMetadataByKey(pdfId, AssetMetadataKey.PdfInfo);
    const pdfInfo = (pdfMetadata?.value as { pageCount?: number; mainPageIndex?: number; status?: string }) || {};

    let newMainPageIndex = pdfInfo.mainPageIndex ?? 0;
    if (newMainPageIndex === deletedPageIndex) {
      // If main page was deleted, select the first available page
      newMainPageIndex = 0;
    } else if (newMainPageIndex > deletedPageIndex) {
      // If main page is after deleted page, adjust index
      newMainPageIndex--;
    }

    await this.assetRepository.upsertMetadata(pdfId, [
      {
        key: AssetMetadataKey.PdfInfo,
        value: {
          ...pdfInfo,
          pageCount: pages.length - 1,
          mainPageIndex: newMainPageIndex,
        },
      },
    ]);
  }

  async run(auth: AuthDto, dto: AssetJobsDto) {
    await this.requireAccess({ auth, permission: Permission.AssetUpdate, ids: dto.assetIds });

    const jobs: JobItem[] = [];

    for (const id of dto.assetIds) {
      switch (dto.name) {
        case AssetJobName.REFRESH_FACES: {
          jobs.push({ name: JobName.AssetDetectFaces, data: { id } });
          break;
        }

        case AssetJobName.REFRESH_METADATA: {
          jobs.push({ name: JobName.AssetExtractMetadata, data: { id } });
          break;
        }

        case AssetJobName.REGENERATE_THUMBNAIL: {
          jobs.push({ name: JobName.AssetGenerateThumbnails, data: { id } });
          break;
        }

        case AssetJobName.TRANSCODE_VIDEO: {
          jobs.push({ name: JobName.AssetEncodeVideo, data: { id } });
          break;
        }
      }
    }

    await this.jobRepository.queueAll(jobs);
  }

  private async findOrFail(id: string) {
    const asset = await this.assetRepository.getById(id);
    if (!asset) {
      throw new BadRequestException('Asset not found');
    }
    return asset;
  }

  private async updateExif(dto: {
    id: string;
    description?: string;
    dateTimeOriginal?: string;
    latitude?: number;
    longitude?: number;
    rating?: number;
  }) {
    const { id, description, dateTimeOriginal, latitude, longitude, rating } = dto;
    const extractedTimeZone = dateTimeOriginal ? DateTime.fromISO(dateTimeOriginal, { setZone: true }).zone : undefined;
    const writes = _.omitBy(
      {
        description,
        dateTimeOriginal,
        timeZone: extractedTimeZone?.type === 'fixed' ? extractedTimeZone.name : undefined,
        latitude,
        longitude,
        rating,
      },
      _.isUndefined,
    );

    if (Object.keys(writes).length > 0) {
      await this.assetRepository.upsertExif(
        updateLockedColumns({
          assetId: id,
          ...writes,
        }),
        { lockedPropertiesBehavior: 'append' },
      );
      await this.jobRepository.queue({ name: JobName.SidecarWrite, data: { id } });
    }
  }
}
