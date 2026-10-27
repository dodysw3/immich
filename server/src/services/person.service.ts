import { BadRequestException, Injectable, NotFoundException } from '@nestjs/common';
import { Insertable } from 'kysely';
import { isUndefined, omitBy } from 'lodash-es';
import type { SystemConfig } from 'src/dtos/config.dto.js';
import type { JobItem, JobOf } from 'src/types.js';
import { Chunked, OnJob } from 'src/decorators.js';
import { BulkIdErrorReason, BulkIdResponseDto } from 'src/dtos/asset-ids.response.dto.js';
import { mapAsset } from 'src/dtos/asset-response.dto.js';
import { AuthDto } from 'src/dtos/auth.dto.js';
import { AssetEditActionItem } from 'src/dtos/editing.dto.js';
import { PersonAssetsDto, PersonAssetsResponseDto } from 'src/dtos/person-assets.dto.js';
import {
  AssetFaceCreateDto,
  AssetFaceDeleteDto,
  AssetFaceResponseDto,
  AssetFaceUpdateDto,
  FaceDto,
  MergePersonDto,
  PeopleDeleteDto,
  PeopleResponseDto,
  PeopleUpdateDto,
  PeopleUsersUpsertDto,
  PersonCreateDto,
  PersonDeleteDto,
  PersonResponseDto,
  PersonSearchDto,
  PersonStatisticsResponseDto,
  PersonUpdateDto,
  PersonUsersDeleteDto,
  PersonUsersResponseDto,
  PersonUsersSearchDto,
  RecentlyMatchedDto,
  RecentlyMatchedResponseDto,
  mapFaces,
  mapPerson,
  mapPersonUsers,
} from 'src/dtos/person.dto.js';
import {
  AssetType,
  AssetVisibility,
  CacheControl,
  DatabaseLock,
  JobName,
  JobStatus,
  Permission,
  PersonPathType,
  QueueName,
  SourceType,
  SystemMetadataKey,
  VectorIndex,
} from 'src/enum.js';
import { BoundingBox, Face } from 'src/repositories/machine-learning.repository.js';
import { PersonId } from 'src/repositories/person.repository.js';
import { DB } from 'src/schema/index.js';
import { AssetFaceQualityTable } from 'src/schema/tables/asset-face-quality.table.js';
import { AssetFaceTable } from 'src/schema/tables/asset-face.table.js';
import { FaceSearchTable } from 'src/schema/tables/face-search.table.js';
import { PersonUserTable } from 'src/schema/tables/person-user.table.js';
import { BaseService } from 'src/services/base.service.js';
import { getDimensions, getMyPartnerIds } from 'src/utils/asset.util.js';
import { asDateString, asDateTimeString } from 'src/utils/date.js';
import { isWrappedDuplicate } from 'src/utils/face-box.js';
import { ImmichFileResponse } from 'src/utils/file.js';
import { isHttpException } from 'src/utils/logger.js';
import { mimeTypes } from 'src/utils/mime-types.js';
import { batched, findOrFail, hasSomeDefined, isFacialRecognitionEnabled } from 'src/utils/misc.js';
import {
  Point,
  exifOrientationToEdits,
  getOutputDimensions,
  transformFaceBoundingBox,
  transformPoints,
} from 'src/utils/transform.js';

const personKey = ({ ownerId, personGroupId }: PersonId) => `${ownerId}/${personGroupId}`;

// Pass-1 floor in preview pixels: a smaller preview crop is too coarse to embed, whatever its
// size in the original. Held at the value minFaceSize had before it moved to original pixels.
const PREVIEW_MIN_FACE_SIZE = 22;

@Injectable()
export class PersonService extends BaseService {
  async getAll(auth: AuthDto, dto: PersonSearchDto): Promise<PeopleResponseDto> {
    const { withHidden = false, closestAssetId, closestPersonId, page, size, ...filters } = dto;
    const pagination = {
      take: size,
      skip: (page - 1) * size,
    };
    const partnerIds = await getMyPartnerIds({
      userId: auth.user.id,
      repository: this.partnerRepository,
    });
    const { items, hasNextPage, total, hidden } = await this.personRepository.getAllForUser(pagination, auth.user.id, {
      withHidden,
      partnerIds,
      closestFaceAssetId: closestAssetId,
      closestPersonId,
      ...filters,
    });

    return {
      people: items.map((person) => mapPerson(person)),
      hasNextPage,
      total,
      hidden,
    };
  }

  async reassignFaces(auth: AuthDto, personGroupId: string, dto: AssetFaceUpdateDto): Promise<PersonResponseDto[]> {
    const ids = dto.data.map((item) => ({ personGroupId: item.personId, ownerId: item.userId ?? auth.user.id }));

    await this.requirePersonAccess({
      auth,
      permission: Permission.PersonUpdate,
      ids: [{ personGroupId, ownerId: auth.user.id }, ...ids],
    });

    const person = await this.findOrFail(auth, personGroupId);

    const result: PersonResponseDto[] = [];
    const changeFeaturePhoto = new Map<string, PersonId>();
    for (const data of dto.data) {
      const faces = await this.personRepository.getFacesByIds(
        [{ personGroupId: data.personId, assetId: data.assetId }],
        { viewingUserId: auth.user.id },
      );

      for (const face of faces) {
        const ids = await this.checkAccess({ auth, permission: Permission.PersonCreate, ids: [face.id] });

        if (ids.size !== 1) {
          continue;
        }

        if (person.faceAssetId === null) {
          changeFeaturePhoto.set(personKey(person), person);
        }
        if (face.person && face.person.faceAssetId === face.id) {
          changeFeaturePhoto.set(personKey(face.person), face.person);
        }

        await this.personRepository.reassignFace(face.id, person.personGroupId);
      }

      result.push(mapPerson(person));
    }
    if (changeFeaturePhoto.size > 0) {
      await this.createNewFeaturePhoto(changeFeaturePhoto.values().toArray());
    }
    return result;
  }

  async reassignFacesById(auth: AuthDto, personGroupId: string, dto: FaceDto): Promise<PersonResponseDto> {
    await this.requirePersonAccess({
      auth,
      permission: Permission.PersonUpdate,
      ids: [{ personGroupId, ownerId: auth.user.id }],
    });
    await this.requireAccess({ auth, permission: Permission.PersonCreate, ids: [dto.id] });
    const face = await this.personRepository.getFaceById(dto.id, { viewingUserId: auth.user.id });
    const person = await this.findOrFail(auth, personGroupId);

    await this.personRepository.reassignFace(face.id, person.personGroupId);
    if (person.faceAssetId === null) {
      await this.createNewFeaturePhoto([person]);
    }
    if (face.person && face.person.faceAssetId === face.id) {
      await this.createNewFeaturePhoto([face.person]);
    }

    return mapPerson(await this.findOrFail(auth, personGroupId));
  }

  async getFacesById(auth: AuthDto, dto: FaceDto): Promise<AssetFaceResponseDto[]> {
    await this.requireAccess({ auth, permission: Permission.AssetRead, ids: [dto.id] });
    const faces = await this.personRepository.getFaces(dto.id, { viewingUserId: auth.user.id, isVisible: true });
    const asset = await this.assetRepository.getForFaces(dto.id);
    const assetDimensions = getDimensions(asset);

    return faces.map((face) => mapFaces(face, asset.edits, assetDimensions));
  }

  async createNewFeaturePhoto(changeFeaturePhoto: PersonId[]) {
    this.logger.debug(
      `Changing feature photos for ${changeFeaturePhoto.length} ${changeFeaturePhoto.length > 1 ? 'people' : 'person'}`,
    );

    const jobs: JobItem[] = [];
    for (const { ownerId, personGroupId } of changeFeaturePhoto) {
      const assetFace = await this.personRepository.getRandomFace(personGroupId);

      if (!assetFace) {
        continue;
      }

      await this.personRepository.update({ ownerId, personGroupId, faceAssetId: assetFace.id });
      jobs.push({ name: JobName.PersonGenerateThumbnail, data: { ownerId, personGroupId } });
    }

    await this.jobRepository.queueAll(jobs);
  }

  async getById(auth: AuthDto, personGroupId: string): Promise<PersonResponseDto> {
    await this.requirePersonAccess({
      auth,
      permission: Permission.PersonRead,
      ids: [{ personGroupId, ownerId: auth.user.id }],
    });
    return mapPerson(
      await findOrFail(() => this.personRepository.getByGroupId({ ownerId: auth.user.id, personGroupId }), 'Person'),
    );
  }

  async getStatistics(auth: AuthDto, personGroupId: string): Promise<PersonStatisticsResponseDto> {
    await this.requirePersonAccess({
      auth,
      permission: Permission.PersonRead,
      ids: [{ personGroupId, ownerId: auth.user.id }],
    });

    const partnerIds = await getMyPartnerIds({
      userId: auth.user.id,
      repository: this.partnerRepository,
    });
    return this.personRepository.getStatistics(personGroupId, { ownerId: auth.user.id, partnerIds });
  }

  async getPersonAssets(auth: AuthDto, id: string, dto: PersonAssetsDto): Promise<PersonAssetsResponseDto> {
    await this.requirePersonAccess({
      auth,
      permission: Permission.PersonRead,
      ids: [{ personGroupId: id, ownerId: auth.user.id }],
    });

    const { items, total } = await this.personRepository.getPersonAssets(id, {
      page: dto.page,
      limit: dto.limit,
      order: dto.order,
      ownerId: auth.user.id,
    });

    if (items.length === 0) {
      return { assets: [], total: 0 };
    }

    const assets = await this.assetRepository.getByIdsWithAllRelationsButStacks(items.map((i) => i.id));
    const recognizedAtMap = new Map(items.map((i) => [i.id, i.recognizedAt]));

    return {
      assets: assets.map((asset) => ({
        ...mapAsset(asset, { auth }),
        recognizedAt: asDateString(recognizedAtMap.get(asset.id)!)!,
      })),
      total,
    };
  }

  async getRecentlyMatched(auth: AuthDto, dto: RecentlyMatchedDto): Promise<RecentlyMatchedResponseDto> {
    // Owner-scoped by construction; no per-item access checks (same as getAll).
    const { items, total } = await this.personRepository.getRecentlyMatched(auth.user.id, {
      limit: dto.limit,
      offset: dto.offset,
    });

    return {
      total,
      items: items.map((item) => ({
        assetId: item.assetId,
        personId: item.personId,
        personName: item.personName,
        recognizedAt: asDateTimeString(item.recognizedAt)!,
      })),
    };
  }

  async getThumbnail(auth: AuthDto, personGroupId: string): Promise<ImmichFileResponse> {
    await this.requirePersonAccess({
      auth,
      permission: Permission.PersonRead,
      ids: [{ personGroupId, ownerId: auth.user.id }],
    });
    const personGroup = await this.personRepository.getForThumbnail({ ownerId: auth.user.id, personGroupId });
    const thumbnailPath = personGroup?.thumbnailPath || personGroup?.sharedThumbnailPath;
    if (!thumbnailPath) {
      throw new NotFoundException();
    }

    return new ImmichFileResponse({
      path: thumbnailPath,
      contentType: mimeTypes.lookup(thumbnailPath),
      cacheControl: CacheControl.PrivateWithoutCache,
    });
  }

  async create(auth: AuthDto, dto: PersonCreateDto): Promise<PersonResponseDto> {
    const group = await this.personRepository.createGroup(auth.user.id);
    const person = await this.personRepository.create({
      ownerId: auth.user.id,
      personGroupId: group.id,
      name: dto.name,
      birthDate: dto.birthDate,
      isHidden: dto.isHidden,
      isFavorite: dto.isFavorite,
      color: dto.color,
    });

    return mapPerson(person);
  }

  async update(auth: AuthDto, personGroupId: string, dto: PersonUpdateDto): Promise<PersonResponseDto> {
    const { userId: userIdOverride, name, birthDate, isHidden, featureFaceAssetId: assetId, isFavorite, color } = dto;
    const targetOwnerId = userIdOverride ?? auth.user.id;
    const hasSharedProperties = hasSomeDefined([name, birthDate]);
    const hasPersonalProperties = hasSomeDefined([isHidden, isFavorite, color, assetId]);

    if (targetOwnerId !== auth.user.id && hasPersonalProperties) {
      throw new BadRequestException('Only name and birthDate can be updated for other users');
    }

    await this.requirePersonAccess({
      auth,
      permission: Permission.PersonUpdate,
      ids: [{ personGroupId, ownerId: targetOwnerId }],
    });

    if (!userIdOverride && hasSharedProperties) {
      await this.personRepository.updateForWritableOwners({ userId: auth.user.id, personGroupId }, { name, birthDate });
    }

    let faceId: string | undefined;

    if (assetId) {
      await this.requireAccess({ auth, permission: Permission.AssetRead, ids: [assetId] });
      const face = await this.personRepository.getForFeatureFaceUpdate({ personGroupId, assetId });
      if (!face) {
        throw new BadRequestException('Invalid assetId for feature face or asset is offline');
      }

      faceId = face.id;
    }

    const person = await this.personRepository.update({
      ownerId: targetOwnerId,
      personGroupId,
      faceAssetId: faceId,
      name,
      birthDate,
      isHidden,
      isFavorite,
      color,
    });

    if (assetId) {
      await this.jobRepository.queue({
        name: JobName.PersonGenerateThumbnail,
        data: { ownerId: targetOwnerId, personGroupId },
      });
    }

    return mapPerson(person);
  }

  delete(auth: AuthDto, id: string, dto: PersonDeleteDto): Promise<void> {
    return this.deleteAll(auth, { ids: [id], ...dto });
  }

  async updateAll(auth: AuthDto, dto: PeopleUpdateDto): Promise<BulkIdResponseDto[]> {
    const results: BulkIdResponseDto[] = [];
    for (const person of dto.people) {
      try {
        await this.update(auth, person.id, {
          isHidden: person.isHidden,
          name: person.name,
          birthDate: person.birthDate,
          featureFaceAssetId: person.featureFaceAssetId,
          isFavorite: person.isFavorite,
          userId: person.userId,
        });
        results.push({ id: person.id, success: true });
      } catch (error: Error | any) {
        if (!isHttpException(error)) {
          this.logger.error(`Unable to update ${person.id} : ${error}`, error?.stack);
        }
        results.push({ id: person.id, success: false, error: BulkIdErrorReason.UNKNOWN });
      }
    }
    return results;
  }

  async deleteAll(auth: AuthDto, { ids, userId }: PeopleDeleteDto): Promise<void> {
    const ownerId = userId ?? auth.user.id;
    await this.requirePersonAccess({
      auth,
      permission: Permission.PersonDelete,
      ids: ids.map((id) => ({ personGroupId: id, ownerId })),
    });
    await this.removeAllPersonGroups(ids, ownerId);
    await this.personRepository.deleteEmptyGroups();
  }

  @Chunked()
  private async removeAllPersonGroups(groupIds: string[], ownerId?: string) {
    if (groupIds.length === 0) {
      return;
    }

    const people = await this.personRepository.delete(groupIds, ownerId);
    await Promise.all(people.map((person) => this.storageRepository.unlink(person.thumbnailPath)));
    this.logger.debug(`Deleted ${groupIds.length} people`);
  }

  @OnJob({ name: JobName.PersonCleanup, queue: QueueName.BackgroundTask })
  async handlePersonCleanup(): Promise<JobStatus> {
    const { machineLearning } = await this.getConfig({ withCache: false });
    const minFaceSize = machineLearning.facialRecognition.minFaceSize;
    const deleted = await this.personRepository.deleteSmallFaces(minFaceSize);
    if (deleted > 0) {
      this.logger.log(`Deleted ${deleted} undersized faces (min dimension < ${minFaceSize})`);
    }

    // each step can leave the next one something to clean up, so the order matters
    const people = await this.personRepository.getAllWithoutFaces();
    await this.removeAllPersonGroups(people.map((person) => person.personGroupId));

    const personGroups = await this.personRepository.deleteEmptyGroups();
    const clusterGroups = await this.personRepository.deleteOrphanedClusterGroups();

    this.logger.debug(`Deleted ${personGroups} empty person groups and ${clusterGroups} orphaned cluster groups`);

    return JobStatus.Success;
  }

  @OnJob({ name: JobName.AssetDetectFacesQueueAll, queue: QueueName.FaceDetection })
  async handleQueueDetectFaces({ force }: JobOf<JobName.AssetDetectFacesQueueAll>): Promise<JobStatus> {
    const { machineLearning } = await this.getConfig({ withCache: false });
    if (!isFacialRecognitionEnabled(machineLearning)) {
      return JobStatus.Skipped;
    }

    if (force) {
      await this.personRepository.deleteFaces({ sourceType: SourceType.MachineLearning });
      await this.handlePersonCleanup();
      await this.vacuum('asset_face', 'person', 'face_search');
    }

    for await (const assets of batched(this.assetJobRepository.streamForDetectFacesJob(force))) {
      await this.jobRepository.queueAll(
        assets.map((asset) => ({ name: JobName.AssetDetectFaces, data: { id: asset.id } })),
      );
    }

    if (force === undefined) {
      await this.jobRepository.queue({ name: JobName.PersonCleanup });
    }

    return JobStatus.Success;
  }

  // Re-checks faces already stored, in place: unlike a detection refresh, a face is never removed
  // just because detection would not find it again today (a different preview, tiling trigger
  // or model since it was stored), only when its own crop fails the re-check.
  @OnJob({ name: JobName.FaceRecheckQueueAll, queue: QueueName.FaceDetection })
  async handleQueueFaceRecheck(): Promise<JobStatus> {
    const { machineLearning } = await this.getConfig({ withCache: false });
    if (!isFacialRecognitionEnabled(machineLearning) || machineLearning.facialRecognition.minVerifyScore <= 0) {
      return JobStatus.Skipped;
    }

    for await (const rows of batched(this.personRepository.streamAssetIdsForFaceRecheck())) {
      await this.jobRepository.queueAll(
        rows.map(({ assetId }) => ({ name: JobName.FaceRecheck, data: { id: assetId } })),
      );
    }

    return JobStatus.Success;
  }

  @OnJob({ name: JobName.FaceRecheck, queue: QueueName.FaceDetection })
  async handleFaceRecheck({ id }: JobOf<JobName.FaceRecheck>): Promise<JobStatus> {
    const { machineLearning } = await this.getConfig({ withCache: true });
    const minVerifyScore = machineLearning.facialRecognition.minVerifyScore;
    if (!isFacialRecognitionEnabled(machineLearning) || minVerifyScore <= 0) {
      return JobStatus.Skipped;
    }

    const faces = await this.personRepository.getFacesForRecheck(id);
    if (faces.length === 0) {
      return JobStatus.Skipped;
    }

    // all faces of one asset share its storage space; a mismatch means rows stored at different
    // rescalings, and the boxes are then re-checked in the first one's
    const [{ originalPath, imageWidth: width, imageHeight: height }] = faces;
    const boxes = faces.map((face) => ({
      x1: (face.boundingBoxX1 * width) / (face.imageWidth || width),
      y1: (face.boundingBoxY1 * height) / (face.imageHeight || height),
      x2: (face.boundingBoxX2 * width) / (face.imageWidth || width),
      y2: (face.boundingBoxY2 * height) / (face.imageHeight || height),
    }));
    const scores = await this.machineLearningRepository.verifyStoredFaces(
      originalPath,
      machineLearning.facialRecognition,
      { boxes, width, height },
    );
    if (!scores) {
      this.logger.warn(`Could not line up the stored faces of asset ${id} with its original; left unchanged`);
      return JobStatus.Skipped;
    }

    // An old stored box can sit off its face, so a real face may fail on it. A face failing on its
    // stored box keeps the score of a fresh detection that passes the re-check where it is, and is
    // only removed when no such detection overlaps it.
    const failingIndexes = faces.flatMap((_, i) => (scores[i] < minVerifyScore ? [i] : []));
    if (failingIndexes.length > 0) {
      const found = await this.detectPassingFaces(id, machineLearning.facialRecognition);
      for (const i of failingIndexes) {
        const match = found.find((fresh) => this.boundingBoxIou(boxes[i], this.toBoxIn(fresh, width, height)) > 0.3);
        if (match) {
          scores[i] = match.verifyScore;
        }
      }
    }

    await this.personRepository.refreshFaces(
      [],
      [],
      [],
      faces.map((face, i) => ({ faceId: face.id, verifyScore: scores[i] })),
    );
    const failing = faces.filter((_, i) => scores[i] < minVerifyScore).map((face) => face.id);
    const deleted = await this.personRepository.deleteFacesFailingRecheck(failing);
    if (failing.length > 0) {
      this.logger.log(
        `Removed ${deleted} of ${faces.length} stored faces that failed the re-check (score < ${minVerifyScore}) in asset ${id}` +
          (deleted < failing.length ? `; kept ${failing.length - deleted} as a named person's last faces` : ''),
      );
    }

    return JobStatus.Success;
  }

  /** Fresh preview-pass detections that pass the re-check, as normalized boxes in storage space. */
  private async detectPassingFaces(
    id: string,
    facialRecognition: SystemConfig['machineLearning']['facialRecognition'],
  ): Promise<{ x1: number; y1: number; x2: number; y2: number; verifyScore: number }[]> {
    const asset = await this.assetJobRepository.getForDetectFacesJob(id);
    if (!asset?.previewFile) {
      return [];
    }
    const detected = await this.machineLearningRepository.detectFaces(asset.previewFile.path, {
      ...facialRecognition,
      verify: true,
    });
    const { faces, dimensions } = this.toStorageSpace(
      detected.faces.filter(({ verifyScore }) => (verifyScore ?? 0) >= facialRecognition.minVerifyScore),
      { imageWidth: detected.imageWidth, imageHeight: detected.imageHeight },
      asset,
    );
    return faces.map(({ boundingBox, verifyScore }) => ({
      x1: boundingBox.x1 / dimensions.width,
      y1: boundingBox.y1 / dimensions.height,
      x2: boundingBox.x2 / dimensions.width,
      y2: boundingBox.y2 / dimensions.height,
      verifyScore: verifyScore ?? 0,
    }));
  }

  private toBoxIn(box: { x1: number; y1: number; x2: number; y2: number }, width: number, height: number) {
    return { x1: box.x1 * width, y1: box.y1 * height, x2: box.x2 * width, y2: box.y2 * height };
  }

  @OnJob({ name: JobName.AssetDetectFaces, queue: QueueName.FaceDetection })
  async handleDetectFaces({ id }: JobOf<JobName.AssetDetectFaces>): Promise<JobStatus> {
    const { machineLearning } = await this.getConfig({ withCache: true });
    if (!isFacialRecognitionEnabled(machineLearning)) {
      return JobStatus.Skipped;
    }

    const asset = await this.assetJobRepository.getForDetectFacesJob(id);
    const previewFile = asset?.previewFile;
    if (!asset || !previewFile) {
      return JobStatus.Failed;
    }

    if (asset.visibility === AssetVisibility.Hidden) {
      return JobStatus.Skipped;
    }

    const minVerifyScore = machineLearning.facialRecognition.minVerifyScore;
    const verify = minVerifyScore > 0;

    const pass1Start = Date.now();
    const pass1 = await this.machineLearningRepository.detectFaces(previewFile.path, {
      ...machineLearning.facialRecognition,
      verify,
    });
    const pass1Ms = Date.now() - pass1Start;
    const gpuFallbackTag = pass1.gpuFallback ? ' (GPU fallback)' : '';
    this.logger.debug(`Pass 1: ${pass1.faces.length} faces${gpuFallbackTag} detected in ${pass1Ms}ms for asset ${id}`);

    // minFaceSize is measured in original-image pixels, like the stored boxes the nightly cleanup
    // sweeps by it. Pass 2 runs on the tiled source at (about) that resolution; pass 1 runs on
    // the downscaled preview, so its faces are also held to a fixed floor in preview pixels,
    // below which the preview crop is too small to embed. Both must be applied before pass-2
    // boxes are mapped into preview space, whose scale differs from the tiled source.
    const minFaceSize = machineLearning.facialRecognition.minFaceSize;
    const imageHeight = pass1.imageHeight;
    const imageWidth = pass1.imageWidth;
    const originalMaxDim = Math.max(asset.exifInfo?.exifImageWidth ?? 0, asset.exifInfo?.exifImageHeight ?? 0);
    const previewScale = Math.max(1, originalMaxDim / Math.max(imageWidth, imageHeight));
    let faces = this.filterUnverifiedFaces(
      this.filterSmallFaces(
        this.filterSmallFaces(pass1.faces, PREVIEW_MIN_FACE_SIZE, 'pass 1 (preview)', id),
        minFaceSize,
        'pass 1 (preview, in original pixels)',
        id,
        previewScale,
      ),
      minVerifyScore,
      'pass 1 (preview)',
      id,
    );

    const tiling = machineLearning.facialRecognition.tiling;
    if (tiling.enabled && this.shouldRunTiledPass(asset, pass1.faces.length, tiling.triggers)) {
      const sourceFile = this.getTiledSourceFile(asset);
      if (sourceFile) {
        try {
          const pass2Start = Date.now();
          const pass2 = await this.machineLearningRepository.detectFacesTiled(sourceFile.path, {
            modelName: machineLearning.facialRecognition.modelName,
            minScore: machineLearning.facialRecognition.minScore,
            verify,
            tileSize: tiling.tileSize,
            tileOverlap: tiling.tileOverlap,
            maxTiles: tiling.maxTiles,
          });
          const pass2Ms = Date.now() - pass2Start;
          this.logger.debug(
            `Pass 2 (tiled): ${pass2.faces.length} faces from ${sourceFile.path} in ${pass2Ms}ms for asset ${id}`,
          );

          const pass2Faces = this.filterUnverifiedFaces(
            this.filterSmallFaces(pass2.faces, minFaceSize, 'pass 2 (tiled source)', id),
            minVerifyScore,
            'pass 2 (tiled source)',
            id,
          );
          const scaledPass2 = this.mapTiledFaces(pass2Faces, pass2, asset, sourceFile.kind, {
            imageWidth,
            imageHeight,
          });

          faces = this.mergeFaces([...faces, ...scaledPass2], 0.5);
          this.logger.debug(
            `Merged: ${faces.length} faces (pass1=${pass1.faces.length}, pass2=${pass2.faces.length}) for asset ${id}`,
          );
        } catch (error: Error | unknown) {
          this.logger.warn(`Pass 2 (tiled) failed for asset ${id}, using pass 1 only: ${error}`);
        }
      }
    }

    const facesToAdd: (Insertable<AssetFaceTable> & { id: string })[] = [];
    const embeddings: FaceSearchTable[] = [];
    const scores: AssetFaceQualityTable[] = [];
    const mlFaceIds = new Set<string>();
    const matchedFaceIds = new Set<string>();

    for (const face of asset.faces) {
      if (face.sourceType === SourceType.MachineLearning) {
        mlFaceIds.add(face.id);
      }
    }

    // convert detected boxes from detection (edited preview) space into storage space
    // (original-image space) before matching and storing
    const { faces: storedFaces, dimensions: storageDims } = this.toStorageSpace(
      faces,
      { imageWidth, imageHeight },
      asset,
    );

    for (const { boundingBox, embedding, verifyScore } of storedFaces) {
      // compare in normalized coordinates: legacy rows may be stored in an older rescaling
      // of the same geometry
      const match = asset.faces.find((face) => {
        const faceWidth = face.imageWidth || storageDims.width;
        const faceHeight = face.imageHeight || storageDims.height;
        const storedBox = {
          x1: (face.boundingBoxX1 * storageDims.width) / faceWidth,
          y1: (face.boundingBoxY1 * storageDims.height) / faceHeight,
          x2: (face.boundingBoxX2 * storageDims.width) / faceWidth,
          y2: (face.boundingBoxY2 * storageDims.height) / faceHeight,
        };
        return this.boundingBoxIou(storedBox, boundingBox) > 0.5 || isWrappedDuplicate(storedBox, boundingBox);
      });

      if (match) {
        // multiple detections can match the same stored row (pass 1 and pass 2 boxes
        // overlap it); only the first match acts, else refreshFaces would insert two
        // face_search rows with the same faceId
        if (!matchedFaceIds.has(match.id)) {
          matchedFaceIds.add(match.id);
          if (!mlFaceIds.delete(match.id)) {
            embeddings.push({ faceId: match.id, embedding });
          }
          if (verifyScore !== undefined) {
            scores.push({ faceId: match.id, verifyScore });
          }
        }
      } else {
        const faceId = this.cryptoRepository.randomUUID();
        facesToAdd.push({
          id: faceId,
          assetId: asset.id,
          imageWidth: storageDims.width,
          imageHeight: storageDims.height,
          boundingBoxX1: boundingBox.x1,
          boundingBoxY1: boundingBox.y1,
          boundingBoxX2: boundingBox.x2,
          boundingBoxY2: boundingBox.y2,
        });
        embeddings.push({ faceId, embedding });
        if (verifyScore !== undefined) {
          scores.push({ faceId, verifyScore });
        }
      }
    }
    // video-scan-published representatives are reconciled by a re-scan, not
    // by the preview-frame refresh path — never sweep them here
    const videoPublished = (await this.personRepository.getVideoPublishedFaceIds(asset.id)) ?? [];
    const faceIdsToRemove = [...mlFaceIds].filter((faceId) => !videoPublished.includes(faceId));

    if (scores.length > 0) {
      await this.personRepository.refreshFaces(facesToAdd, faceIdsToRemove, embeddings, scores);
    } else if (facesToAdd.length > 0 || faceIdsToRemove.length > 0 || embeddings.length > 0) {
      await this.personRepository.refreshFaces(facesToAdd, faceIdsToRemove, embeddings);
    }

    if (faceIdsToRemove.length > 0) {
      this.logger.log(`Removed ${faceIdsToRemove.length} faces below detection threshold in asset ${id}`);
    }

    if (facesToAdd.length > 0) {
      this.logger.log(`Detected ${facesToAdd.length} new faces in asset ${id}`);
      const jobs = facesToAdd.map((face) => ({ name: JobName.FacialRecognition, data: { id: face.id } }) as const);
      await this.jobRepository.queueAll([{ name: JobName.FacialRecognitionQueueAll, data: { force: false } }, ...jobs]);
    } else if (embeddings.length > 0) {
      this.logger.log(`Added ${embeddings.length} face embeddings for asset ${id}`);
    }

    await this.assetRepository.upsertJobStatus({ assetId: asset.id, facesRecognizedAt: new Date() });

    return JobStatus.Success;
  }

  /**
   * Maps tiled pass-2 detections from the tiled source file's coordinate space into the
   * edited preview space that pass 1 (and the stored faces) use, so that mergeFaces can
   * dedupe a face found by both passes.
   */
  private mapTiledFaces(
    faces: Face[],
    tiled: { imageWidth: number; imageHeight: number },
    asset: {
      edits: AssetEditActionItem[];
      exifInfo?: {
        orientation?: string | null;
        exifImageWidth?: number | null;
        exifImageHeight?: number | null;
      } | null;
    },
    source: 'edited-fullsize' | 'original' | 'fullsize',
    preview: { imageWidth: number; imageHeight: number },
  ): Face[] {
    // boxes on the raw original still need EXIF orientation applied (the ML service decodes
    // with PIL, which ignores it); a server-rendered fullsize file is already oriented, and
    // the edited fullsize render needs nothing at all
    const exif = {
      orientation: asset.exifInfo?.orientation ?? null,
      exifImageWidth: asset.exifInfo?.exifImageWidth ?? null,
      exifImageHeight: asset.exifInfo?.exifImageHeight ?? null,
    };
    const chain =
      source === 'original'
        ? [...exifOrientationToEdits(Number(exif.orientation)), ...asset.edits]
        : source === 'fullsize'
          ? [...asset.edits]
          : [];

    if (chain.length === 0) {
      const sx = preview.imageWidth / tiled.imageWidth;
      const sy = preview.imageHeight / tiled.imageHeight;
      return faces.map((face) => ({
        ...face,
        boundingBox: {
          x1: Math.round(face.boundingBox.x1 * sx),
          y1: Math.round(face.boundingBox.y1 * sy),
          x2: Math.round(face.boundingBox.x2 * sx),
          y2: Math.round(face.boundingBox.y2 * sy),
        },
      }));
    }

    // space the chain is defined in: raw stored dimensions for the original,
    // oriented dimensions for a rendered fullsize file
    const baseDimensions =
      source === 'original'
        ? { width: exif.exifImageWidth ?? 0, height: exif.exifImageHeight ?? 0 }
        : getDimensions(exif);

    if (baseDimensions.width <= 0 || baseDimensions.height <= 0) {
      this.logger.warn('Cannot map tiled face detections without valid asset dimensions, skipping them');
      return [];
    }

    return faces.map((face) => {
      const mapped = transformFaceBoundingBox(
        {
          boundingBoxX1: face.boundingBox.x1,
          boundingBoxY1: face.boundingBox.y1,
          boundingBoxX2: face.boundingBox.x2,
          boundingBoxY2: face.boundingBox.y2,
          imageWidth: tiled.imageWidth,
          imageHeight: tiled.imageHeight,
        },
        chain,
        baseDimensions,
      );
      const sx = preview.imageWidth / mapped.imageWidth;
      const sy = preview.imageHeight / mapped.imageHeight;
      return {
        ...face,
        boundingBox: {
          x1: Math.round(mapped.boundingBoxX1 * sx),
          y1: Math.round(mapped.boundingBoxY1 * sy),
          x2: Math.round(mapped.boundingBoxX2 * sx),
          y2: Math.round(mapped.boundingBoxY2 * sy),
        },
      };
    });
  }

  /**
   * Converts detected boxes from detection (edited preview) space into storage space:
   * original-image space, matching manual faces and the edit chain that API responses
   * (forward transform) and person thumbnail crops (from the original file) apply to
   * stored boxes.
   */
  private toStorageSpace(
    faces: Face[],
    detection: { imageWidth: number; imageHeight: number },
    asset: {
      edits: AssetEditActionItem[];
      exifInfo?: {
        orientation?: string | null;
        exifImageWidth?: number | null;
        exifImageHeight?: number | null;
      } | null;
    },
  ): { faces: Face[]; dimensions: { width: number; height: number } } {
    const exif = {
      orientation: asset.exifInfo?.orientation ?? null,
      exifImageWidth: asset.exifInfo?.exifImageWidth ?? null,
      exifImageHeight: asset.exifInfo?.exifImageHeight ?? null,
    };
    const originalDimensions = getDimensions(exif);
    if (originalDimensions.width <= 0 || originalDimensions.height <= 0) {
      // no usable exif dimensions: keep boxes in detection space
      return { faces, dimensions: { width: detection.imageWidth, height: detection.imageHeight } };
    }

    const editedDimensions = getOutputDimensions(asset.edits, originalDimensions);
    const storedFaces = faces.map((face) => {
      const { points } = transformPoints(
        [
          {
            x: (face.boundingBox.x1 * editedDimensions.width) / detection.imageWidth,
            y: (face.boundingBox.y1 * editedDimensions.height) / detection.imageHeight,
          },
          {
            x: (face.boundingBox.x2 * editedDimensions.width) / detection.imageWidth,
            y: (face.boundingBox.y2 * editedDimensions.height) / detection.imageHeight,
          },
        ],
        asset.edits,
        editedDimensions,
        { inverse: true },
      );
      const [topLeft, bottomRight] = points;
      return {
        ...face,
        boundingBox: {
          x1: Math.round(Math.min(topLeft.x, bottomRight.x)),
          y1: Math.round(Math.min(topLeft.y, bottomRight.y)),
          x2: Math.round(Math.max(topLeft.x, bottomRight.x)),
          y2: Math.round(Math.max(topLeft.y, bottomRight.y)),
        },
      };
    });

    return { faces: storedFaces, dimensions: originalDimensions };
  }

  private shouldRunTiledPass(
    asset: { type: AssetType; exifInfo?: { exifImageWidth?: number | null; exifImageHeight?: number | null } | null },
    pass1FaceCount: number,
    tiling: { minPass1Faces: number; minDimWithFaces: { dim: number; faces: number } },
  ): boolean {
    if (asset.type === AssetType.Video) {
      return false;
    }

    const originalMaxDim = Math.max(asset.exifInfo?.exifImageWidth ?? 0, asset.exifInfo?.exifImageHeight ?? 0);
    if (originalMaxDim <= 1440) {
      return false;
    }

    if (pass1FaceCount >= tiling.minPass1Faces) {
      return true;
    }

    if (originalMaxDim >= tiling.minDimWithFaces.dim && pass1FaceCount >= tiling.minDimWithFaces.faces) {
      return true;
    }

    return false;
  }

  private getTiledSourceFile(asset: {
    originalPath: string;
    fullsizeFile?: string | null;
    editedFullsizeFile?: string | null;
    edits?: AssetEditActionItem[] | null;
  }): { path: string; kind: 'edited-fullsize' | 'original' | 'fullsize' } | null {
    if (asset.edits?.length && asset.editedFullsizeFile) {
      // full-resolution render of the edited image: faces are upright here (detectors trained
      // on upright faces lose recall on rotated ones) and the coordinate space already matches
      // the edited preview pass 1 runs on
      return { path: asset.editedFullsizeFile, kind: 'edited-fullsize' };
    }

    const decodableExtensions = new Set(['.jpg', '.jpeg', '.png', '.webp', '.bmp', '.tiff', '.tif', '.heic', '.heif']);
    const ext = asset.originalPath.toLowerCase().split('.').pop();
    if (ext && decodableExtensions.has(`.${ext}`)) {
      // the ML service decodes the original with PIL, which ignores EXIF orientation,
      // so tiled boxes from this source still need the orientation applied
      return { path: asset.originalPath, kind: 'original' };
    }

    if (asset.fullsizeFile) {
      // a server-rendered file: already EXIF-oriented, but never edited
      return { path: asset.fullsizeFile, kind: 'fullsize' };
    }

    return null;
  }

  // scale converts a box's pixels into the pixel space minFaceSize is measured in
  private filterSmallFaces(faces: Face[], minFaceSize: number, pass: string, assetId: string, scale = 1): Face[] {
    const filtered = faces.filter(
      ({ boundingBox }) =>
        Math.min(boundingBox.x2 - boundingBox.x1, boundingBox.y2 - boundingBox.y1) * scale >= minFaceSize,
    );
    const removed = faces.length - filtered.length;
    if (removed > 0) {
      this.logger.log(
        `Filtered out ${removed} undersized ${pass} faces (min dimension < ${minFaceSize}) in asset ${assetId}`,
      );
    }
    return filtered;
  }

  // A face without a verifyScore was not re-checked (an ML service that predates the option),
  // so it is kept rather than treated as failing.
  private filterUnverifiedFaces(faces: Face[], minVerifyScore: number, pass: string, assetId: string): Face[] {
    if (minVerifyScore <= 0) {
      return faces;
    }
    const filtered = faces.filter(({ verifyScore }) => verifyScore === undefined || verifyScore >= minVerifyScore);
    const removed = faces.length - filtered.length;
    if (removed > 0) {
      this.logger.log(
        `Filtered out ${removed} ${pass} faces that failed the re-check (score < ${minVerifyScore}) in asset ${assetId}`,
      );
    }
    return filtered;
  }

  private mergeFaces(faces: Face[], iouThreshold: number): Face[] {
    const sorted = [...faces].sort((a, b) => b.score - a.score);
    const keep: Face[] = [];
    const suppressed = new Set<number>();

    for (let i = 0; i < sorted.length; i++) {
      if (suppressed.has(i)) {
        continue;
      }
      keep.push(sorted[i]);

      for (let j = i + 1; j < sorted.length; j++) {
        if (suppressed.has(j)) {
          continue;
        }
        if (
          this.boundingBoxIou(sorted[i].boundingBox, sorted[j].boundingBox) > iouThreshold ||
          isWrappedDuplicate(sorted[i].boundingBox, sorted[j].boundingBox)
        ) {
          suppressed.add(j);
        }
      }
    }

    return keep;
  }

  private boundingBoxIou(a: BoundingBox, b: BoundingBox): number {
    const x1 = Math.max(a.x1, b.x1);
    const y1 = Math.max(a.y1, b.y1);
    const x2 = Math.min(a.x2, b.x2);
    const y2 = Math.min(a.y2, b.y2);

    const intersection = Math.max(0, x2 - x1) * Math.max(0, y2 - y1);
    const area1 = (a.x2 - a.x1) * (a.y2 - a.y1);
    const area2 = (b.x2 - b.x1) * (b.y2 - b.y1);
    const union = area1 + area2 - intersection;

    return union > 0 ? intersection / union : 0;
  }

  @OnJob({ name: JobName.FacialRecognitionQueueAll, queue: QueueName.FacialRecognition })
  async handleQueueRecognizeFaces({
    force,
    nightly,
    clusterGroupId,
  }: JobOf<JobName.FacialRecognitionQueueAll>): Promise<JobStatus> {
    return this.databaseRepository.withLock(DatabaseLock.FacialRecognition, async () => {
      const { machineLearning } = await this.getConfig({ withCache: false });
      if (!isFacialRecognitionEnabled(machineLearning)) {
        return JobStatus.Skipped;
      }

      await this.jobRepository.waitForQueueCompletion(QueueName.ThumbnailGeneration, QueueName.FaceDetection);

      if (nightly) {
        const [state, latestFaceDate] = await Promise.all([
          this.systemMetadataRepository.get(SystemMetadataKey.FacialRecognitionState),
          this.personRepository.getLatestFaceDate(),
        ]);

        if (state?.lastRun && latestFaceDate && state.lastRun > latestFaceDate) {
          this.logger.debug('Skipping facial recognition nightly since no face has been added since the last run');
          return JobStatus.Skipped;
        }
      }

      const { waiting } = await this.jobRepository.getJobCounts(QueueName.FacialRecognition);

      if (force) {
        await this.personRepository.unassignFaces({ clusterGroupId, sourceType: SourceType.MachineLearning });
        await this.handlePersonCleanup();
        await this.vacuum('asset_face', 'person');
      } else if (waiting) {
        this.logger.debug(
          `Skipping facial recognition queueing because ${waiting} job${waiting > 1 ? 's are' : ' is'} already queued`,
        );
        return JobStatus.Skipped;
      }

      await this.databaseRepository.prewarm(VectorIndex.Face);

      const lastRun = new Date().toISOString();

      const faces = this.personRepository.getAllFaces(
        force
          ? { clusterGroupId, sourceType: clusterGroupId ? SourceType.MachineLearning : undefined }
          : { personGroupId: null, clusterGroupId, sourceType: SourceType.MachineLearning },
      );
      for await (const batch of batched(faces)) {
        await this.jobRepository.queueAll(
          batch.map((face) => ({ name: JobName.FacialRecognition, data: { id: face.id, deferred: false } })),
        );
      }

      await this.systemMetadataRepository.set(SystemMetadataKey.FacialRecognitionState, { lastRun });

      return JobStatus.Success;
    });
  }

  @OnJob({ name: JobName.FacialRecognition, queue: QueueName.FacialRecognition })
  async handleRecognizeFaces({ id, deferred }: JobOf<JobName.FacialRecognition>): Promise<JobStatus> {
    return this.databaseRepository.withLock(DatabaseLock.FacialRecognition, async () => {
      const { machineLearning } = await this.getConfig({ withCache: true });
      if (!isFacialRecognitionEnabled(machineLearning)) {
        return JobStatus.Skipped;
      }

      const face = await this.personRepository.getFaceForFacialRecognitionJob(id);
      if (!face || !face.asset) {
        this.logger.warn(`Face ${id} not found`);
        return JobStatus.Failed;
      }

      if (face.sourceType !== SourceType.MachineLearning) {
        this.logger.warn(`Skipping face ${id} due to source ${face.sourceType}`);
        return JobStatus.Skipped;
      }

      if (!face.faceSearch?.embedding) {
        this.logger.warn(`Face ${id} does not have an embedding`);
        return JobStatus.Failed;
      }

      if (face.personGroupId) {
        this.logger.debug(`Face ${id} already has a person assigned`);
        return JobStatus.Skipped;
      }

      const { ownerId, clusterGroupId } = face.asset;
      const matches = await this.searchRepository.searchFaces({
        clusterGroupId,
        embedding: face.faceSearch.embedding,
        maxDistance: machineLearning.facialRecognition.maxDistance,
        numResults: machineLearning.facialRecognition.minFaces,
        minBirthDate: new Date(face.asset.fileCreatedAt),
      });

      // `matches` also includes the face itself
      if (machineLearning.facialRecognition.minFaces > 1 && matches.length <= 1) {
        this.logger.debug(`Face ${id} only matched the face itself, skipping`);
        return JobStatus.Skipped;
      }

      this.logger.debug(`Face ${id} has ${matches.length} matches`);

      const isCore =
        matches.length >= machineLearning.facialRecognition.minFaces &&
        face.asset.visibility === AssetVisibility.Timeline;
      if (!isCore && !deferred) {
        this.logger.debug(`Deferring non-core face ${id} for later processing`);
        await this.jobRepository.queue({ name: JobName.FacialRecognition, data: { id, deferred: true } });
        return JobStatus.Skipped;
      }

      let personGroupId = matches.find((match) => match.personGroupId)?.personGroupId;
      if (!personGroupId) {
        const [matchWithPerson] = await this.searchRepository.searchFaces({
          clusterGroupId,
          embedding: face.faceSearch.embedding,
          maxDistance: machineLearning.facialRecognition.maxDistance,
          numResults: 1,
          hasPerson: true,
          minBirthDate: new Date(face.asset.fileCreatedAt),
        });

        personGroupId = matchWithPerson?.personGroupId ?? undefined;
      }

      if (!personGroupId && isCore) {
        const group = await this.personRepository.createGroup(ownerId);
        personGroupId = group.id;
        this.logger.log(`Created person group ${personGroupId} for face ${id}`);
      }

      if (personGroupId) {
        const person = await this.personRepository.getByGroupId({ ownerId, personGroupId });
        if (person) {
          if (person.name === '') {
            const importedName = await this.getImportedName(personGroupId, ownerId);
            if (importedName) {
              await this.personRepository.update({ ownerId, personGroupId, name: importedName });
            }
          }
          this.logger.debug(`Face ${id} matched person ${person.personGroupId}`);
        } else {
          const importedName = await this.getImportedName(personGroupId, ownerId);
          await this.personRepository.create({
            ownerId,
            faceAssetId: face.id,
            personGroupId,
            ...(importedName && { name: importedName }),
          });
          this.logger.log(`Created person for face ${id} in group ${personGroupId}`);
          await this.jobRepository.queue({
            name: JobName.PersonGenerateThumbnail,
            data: { ownerId, personGroupId },
          });
        }

        this.logger.debug(`Assigning face ${id} to person group ${personGroupId}`);
        await this.personRepository.reassignFaces({ faceIds: [id], newPersonGroupId: personGroupId });
      }

      return JobStatus.Success;
    });
  }

  private async getImportedName(personGroupId: string, excludeOwnerId: string): Promise<string | null> {
    const { machineLearning } = await this.getConfig({ withCache: true });
    if (!machineLearning.facialRecognition.importNamesFromOtherAccounts) {
      return null;
    }

    const [candidate] = await this.personRepository.getNameImportCandidates({ personGroupId, excludeOwnerId });
    return candidate ? `${candidate.name} [[assigned from ${candidate.email}]]` : null;
  }

  @OnJob({ name: JobName.PersonFileMigration, queue: QueueName.Migration })
  async handlePersonMigration({ ownerId, personGroupId }: JobOf<JobName.PersonFileMigration>): Promise<JobStatus> {
    const person = await this.personRepository.getByGroupId({ ownerId, personGroupId });
    if (!person) {
      return JobStatus.Failed;
    }

    await this.storageCore.movePersonFile(person, PersonPathType.Face);

    return JobStatus.Success;
  }

  async mergePeople(auth: AuthDto, { ids }: MergePersonDto): Promise<BulkIdResponseDto[]> {
    if (ids.length < 2) {
      throw new BadRequestException('At least two people are required for merging');
    }

    if (new Set(ids).size !== ids.length) {
      throw new BadRequestException('Cannot merge a person into themselves');
    }

    const allowed = await this.checkPersonAccess({
      auth,
      permission: Permission.PersonMerge,
      ids: ids.map((id) => ({ personGroupId: id, ownerId: auth.user.id })),
    });
    const allowedIds = new Set(allowed.values().map((item) => item.personGroupId));
    const results = new Map<string, BulkIdResponseDto>(
      ids.map((id) => [
        id,
        {
          id,
          success: false,
          error: allowedIds.has(id) ? BulkIdErrorReason.NOT_FOUND : BulkIdErrorReason.NO_PERMISSION,
        },
      ]),
    );

    const orderedIds = ids.filter((id) => allowedIds.has(id));
    const [targetId, ...sourceIds] = orderedIds;
    const people = targetId ? await this.personRepository.getForMergePerson(orderedIds) : [];
    const lookup = new Map(people.map((person) => [personKey(person), person]));
    const ownerIds = new Set([auth.user.id, ...people.map((person) => person.ownerId)]);
    const targets = new Map(
      people.filter((person) => person.personGroupId === targetId).map((person) => [person.ownerId, person]),
    );

    if (targets.has(auth.user.id)) {
      results.set(targetId, { id: targetId, success: true });
    }

    for (const id of sourceIds) {
      for (const ownerId of ownerIds) {
        const isAuthUser = ownerId === auth.user.id;
        const source = lookup.get(personKey({ ownerId, personGroupId: id }));
        let target = targets.get(ownerId);
        if (!source) {
          continue;
        }

        // skip other users when there are conflicts
        if (!isAuthUser && target && ((target.name && source.name) || (target.birthDate && source.birthDate))) {
          continue;
        }

        try {
          if (!target) {
            // user has no person in the target group yet, so this one is updated to it
            targets.set(
              ownerId,
              await this.personRepository.updateGroupId({ ownerId, oldPersonGroupId: id, newPersonGroupId: targetId }),
            );
            continue;
          }

          const changes = omitBy(
            {
              name: source.name && !target.name ? source.name : undefined,
              birthDate: source.birthDate && !target.birthDate ? source.birthDate : undefined,
            },
            isUndefined,
          );
          if (Object.keys(changes).length > 0) {
            target = await this.personRepository.update({ ownerId, personGroupId: targetId, ...changes });
            targets.set(ownerId, target);
          }

          await this.personRepository.reassignFaces({ oldPersonGroupId: id, newPersonGroupId: targetId, ownerId });
          await this.removeAllPersonGroups([id], ownerId);
          this.logger.log(`Merged ${source.name || id} into ${target.name || targetId}`);

          if (isAuthUser) {
            results.set(id, { id, success: true });
          }
        } catch (error: any) {
          this.logger.error(`Unable to merge ${id} into ${targetId}: ${error}`, error?.stack);
          if (isAuthUser) {
            results.set(id, { id, success: false, error: BulkIdErrorReason.UNKNOWN });
          }
        }
      }
    }

    await this.personRepository.deleteEmptyGroups();

    return results.values().toArray();
  }

  private findOrFail(auth: AuthDto, personGroupId: string) {
    return findOrFail(() => this.personRepository.getByGroupId({ ownerId: auth.user.id, personGroupId }), 'Person');
  }

  // TODO return a asset face response
  async createFace(auth: AuthDto, dto: AssetFaceCreateDto): Promise<void> {
    await Promise.all([
      this.requireAccess({ auth, permission: Permission.AssetUpdate, ids: [dto.assetId] }),
      this.requirePersonAccess({
        auth,
        permission: Permission.PersonRead,
        ids: [{ personGroupId: dto.personId, ownerId: auth.user.id }],
      }),
    ]);

    const [asset, person] = await Promise.all([
      this.assetRepository.getById(dto.assetId, { edits: true, exifInfo: true }),
      this.findOrFail(auth, dto.personId),
    ]);

    if (!asset) {
      throw new NotFoundException('Asset not found');
    }

    const edits = asset.edits || [];

    let topLeft: Point = { x: dto.x, y: dto.y };
    let bottomRight: Point = { x: dto.x + dto.width, y: dto.y + dto.height };

    // the coordinates received from the client are based on the edited preview image
    // we need to convert them to the coordinate space of the original unedited image
    if (edits.length > 0) {
      if (!asset.width || !asset.height || !asset.exifInfo?.exifImageWidth || !asset.exifInfo?.exifImageHeight) {
        throw new BadRequestException('Asset does not have valid dimensions');
      }

      // convert from preview to full dimensions
      const scaleFactor = asset.width / dto.imageWidth;
      topLeft = { x: topLeft.x * scaleFactor, y: topLeft.y * scaleFactor };
      bottomRight = { x: bottomRight.x * scaleFactor, y: bottomRight.y * scaleFactor };
      const [invertedTopLeft, invertedBottomRight] = transformPoints(
        [topLeft, bottomRight],
        edits,
        { width: asset.width, height: asset.height },
        { inverse: true },
      ).points;

      // make sure topLeft is top-left and bottomRight is bottom-right
      topLeft = {
        x: Math.min(invertedTopLeft.x, invertedBottomRight.x),
        y: Math.min(invertedTopLeft.y, invertedBottomRight.y),
      };
      bottomRight = {
        x: Math.max(invertedTopLeft.x, invertedBottomRight.x),
        y: Math.max(invertedTopLeft.y, invertedBottomRight.y),
      };

      // now coordinates are in original image space
      const originalDimensions = getDimensions(asset.exifInfo);
      dto.imageWidth = originalDimensions.width;
      dto.imageHeight = originalDimensions.height;
    }

    await this.personRepository.createAssetFace({
      personGroupId: person.personGroupId,
      assetId: dto.assetId,
      imageHeight: dto.imageHeight,
      imageWidth: dto.imageWidth,
      boundingBoxX1: Math.round(topLeft.x),
      boundingBoxX2: Math.round(bottomRight.x),
      boundingBoxY1: Math.round(topLeft.y),
      boundingBoxY2: Math.round(bottomRight.y),
      sourceType: SourceType.Manual,
    });

    if (!person.faceAssetId) {
      await this.createNewFeaturePhoto([person]);
    }
  }

  async deleteFace(auth: AuthDto, id: string, dto: AssetFaceDeleteDto): Promise<void> {
    await this.requireAccess({ auth, permission: Permission.FaceDelete, ids: [id] });

    return dto.force ? this.personRepository.deleteAssetFace(id) : this.personRepository.softDeleteAssetFaces(id);
  }

  async getUsersForPeople(auth: AuthDto, dto: PersonUsersSearchDto): Promise<PersonUsersResponseDto> {
    const sharedUsers = await this.personUserRepository.searchPeopleUsers(auth.user.id, dto);

    return mapPersonUsers(sharedUsers);
  }

  async upsertPeopleUsers(auth: AuthDto, dto: PeopleUsersUpsertDto) {
    if (dto.sharedWithIds.includes(auth.user.id)) {
      throw new BadRequestException('Cannot share a person with yourself');
    }

    if (dto.personIds) {
      await this.requirePersonAccess({
        auth,
        permission: Permission.PersonUpdate,
        ids: dto.personIds.map((item) => ({ personGroupId: item, ownerId: auth.user.id })),
      });
    }

    const user = await findOrFail(() => this.userRepository.get(auth.user.id, {}), 'User');
    const clusterGroupUsers = await this.clusterGroupRepository.getUsers({
      clusterGroupId: user.clusterGroupId,
      userId: user.id,
    });
    const clusterGroupUserIds = new Set(clusterGroupUsers.map(({ id }) => id));

    for (const sharedWithId of dto.sharedWithIds) {
      if (!clusterGroupUserIds.has(sharedWithId)) {
        throw new BadRequestException('All users must be in the same cluster group');
      }
    }

    const sharedById = auth.user.id;

    if (dto.personIds) {
      const items: Insertable<PersonUserTable>[] = [];
      for (const sharedWithId of dto.sharedWithIds) {
        for (const personGroupId of dto.personIds) {
          items.push({ personGroupId, sharedById, sharedWithId, role: dto.role });
        }
      }

      await this.personUserRepository.createAll(items);
    } else {
      await this.personUserRepository.createAllForOwner({
        ownerId: sharedById,
        sharedWithIds: dto.sharedWithIds,
        role: dto.role,
      });
    }
  }

  async removeUsersFromPeople(auth: AuthDto, dto: PersonUsersDeleteDto) {
    await this.requirePersonAccess({
      auth,
      permission: Permission.PersonUpdate,
      ids: dto.map((item) => ({ personGroupId: item.personId, ownerId: item.sharedById ?? auth.user.id })),
    });
    await this.personUserRepository.deleteAll(auth.user.id, dto);
  }

  private vacuum(...tables: (keyof DB)[]): Promise<unknown> {
    return Promise.all(
      tables.map((table) =>
        this.databaseRepository
          .vacuum({ analyze: true, table })
          .then(() => this.databaseRepository.reindex(table, { concurrently: true })),
      ),
    );
  }
}
