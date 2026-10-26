import { Injectable } from '@nestjs/common';
import { createHash } from 'node:crypto';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import sharp from 'sharp';
import { OnJob } from 'src/decorators.js';
import type { AuthDto } from 'src/dtos/auth.dto.js';
import { VideoFaceRunDto, VideoFacesResponseDto, type VideoFaceDto } from 'src/dtos/video-face.dto.js';
import { requireAccess } from 'src/utils/access.js';
import { AssetType, AssetVisibility, CacheControl, JobName, JobStatus, QueueName, Permission } from 'src/enum.js';
import type { JobOf } from 'src/types.js';
import { AccessRepository } from 'src/repositories/access.repository.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { CryptoRepository } from 'src/repositories/crypto.repository.js';
import { JobRepository } from 'src/repositories/job.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { MachineLearningRepository } from 'src/repositories/machine-learning.repository.js';
import { MediaRepository } from 'src/repositories/media.repository.js';
import { PersonRepository } from 'src/repositories/person.repository.js';
import { SearchRepository } from 'src/repositories/search.repository.js';
import { SystemMetadataRepository } from 'src/repositories/system-metadata.repository.js';
import { VideoFaceRepository, type VideoFaceUpsert } from 'src/repositories/video-face.repository.js';
import { getConfig } from 'src/utils/config.js';
import { ImmichFileResponse } from 'src/utils/file.js';
import {
  VIDEO_FACE_DEFAULT_CONFIG,
  assignIdentityKeys,
  configFingerprint,
  groupDetections,
  planUniformSamples,
  shouldStopForSaturation,
  type GroupInput,
  type VideoFaceIdentity,
  type VideoFaceScanConfig,
} from 'src/utils/video-face.js';

const MAX_DECODE_FAILURES = 3;

export type VideoFaceScanOutcome = 'saturated' | 'budget_exhausted' | 'deadline' | 'decode_failed';

export interface ScanSample {
  requestedMs: number;
  timeMs: number;
  grabMs: number;
  mlMs: number;
  detections: number;
  failed: boolean;
}

/** Everything a scan produced — the dry-run CLI consumes this directly. */
export interface ScanResult {
  outcome: VideoFaceScanOutcome;
  durationMs: number;
  extractions: number;
  detections: number;
  frames: GroupInput[];
  samples: ScanSample[];
  identities: VideoFaceIdentity[];
  /** decoded timeMs -> temp jpg path (valid until cleanup) */
  framePaths: Map<number, string>;
  tempDir: string;
  config: VideoFaceScanConfig;
  modelVersions: string;
  configHash: string;
}

@Injectable()
export class VideoFaceService {
  private readonly logger: LoggingRepository;

  constructor(
    private accessRepository: AccessRepository,
    private configRepository: ConfigRepository,
    logger: LoggingRepository,
    private systemMetadataRepository: SystemMetadataRepository,
    private cryptoRepository: CryptoRepository,
    private jobRepository: JobRepository,
    private mediaRepository: MediaRepository,
    private machineLearningRepository: MachineLearningRepository,
    private personRepository: PersonRepository,
    private searchRepository: SearchRepository,
    private videoFaceRepository: VideoFaceRepository,
  ) {
    this.logger = logger;
    this.logger.setContext(VideoFaceService.name);
  }

  resolvedConfig(budgetOverride?: number) {
    const env = this.configRepository.getEnv().videoFaceScan;
    const cfg: VideoFaceScanConfig = {
      ...VIDEO_FACE_DEFAULT_CONFIG,
      framesBudget: budgetOverride ?? env.framesBudget,
      deadlineMs: env.deadlineMs,
      groupThreshold: env.groupThreshold,
      exemplarMerge: env.exemplarMerge,
      minGapMs: env.minGapMs,
      saturation: env.saturation,
      identitiesCap: env.identitiesCap,
    };
    return { cfg, env };
  }

  /**
   * Dry run: full sampling + grouping pipeline, nothing written to the
   * library. Caller must `cleanup(result)` when done with frame files.
   */
  async scanDryRun(assetId: string, budgetOverride?: number, overrides: Partial<VideoFaceScanConfig> = {}): Promise<ScanResult> {
    const asset = await this.videoFaceRepository.getScanAsset(assetId);
    if (!asset || asset.type !== AssetType.Video) {
      throw new Error(`asset ${assetId} is not a video`);
    }
    const { machineLearning } = await getConfig(
      { configRepo: this.configRepository, metadataRepo: this.systemMetadataRepository, logger: this.logger },
      { withCache: true },
    );
    const { cfg } = this.resolvedConfig(budgetOverride);
    return await this.executeScan(asset, { ...cfg, ...overrides }, machineLearning);
  }

  /** Publish path for the CLI: runs the full scan + persist + publish flow. */
  async scanPublish(assetId: string, budgetOverride?: number): Promise<JobStatus> {
    return await this.handleAssetVideoFaceScan({ id: assetId, budgetOverride });
  }

  async cleanup(result: ScanResult): Promise<void> {
    await rm(result.tempDir, { recursive: true, force: true });
  }

  @OnJob({ name: JobName.AssetVideoFaceScan, queue: QueueName.VideoFaceScan })
  async handleAssetVideoFaceScan({ id, budgetOverride }: JobOf<JobName.AssetVideoFaceScan>): Promise<JobStatus> {
    const { cfg, env } = this.resolvedConfig(budgetOverride);
    if (!env.enabled) {
      return JobStatus.Skipped;
    }

    const asset = await this.videoFaceRepository.getScanAsset(id);
    if (!asset || asset.type !== AssetType.Video || asset.visibility === AssetVisibility.Hidden) {
      return JobStatus.Skipped;
    }

    const { machineLearning } = await getConfig(
      { configRepo: this.configRepository, metadataRepo: this.systemMetadataRepository, logger: this.logger },
      { withCache: true },
    );
    if (!machineLearning.facialRecognition.enabled) {
      return JobStatus.Skipped;
    }

    const runId = await this.videoFaceRepository.createRun({
      assetId: id,
      configHash: cfg ? createHash('sha256').update(configFingerprint(cfg, this.modelVersions(machineLearning))).digest('hex').slice(0, 16) : '',
      config: cfg as unknown as object,
      modelVersions: this.modelVersions(machineLearning),
      deadlineBudgetMs: cfg.deadlineMs,
    });

    let result: ScanResult | null = null;
    try {
      result = await this.executeScan(asset, cfg, machineLearning);

      const upserts: VideoFaceUpsert[] = result.identities.map((identity) => ({
        identityKey: identity.identityKey,
        firstObservedMs: identity.firstObservedMs,
        lastObservedMs: identity.lastObservedMs,
        sightingCount: identity.sightingCount,
        bestFrameMs: identity.bestFrameMs,
        bestScore: identity.bestScore,
        bestSizePx: identity.bestSizePx,
        embedding: identity.bestEmbedding,
        flagged: identity.flagged,
        sightings: identity.sightings,
      }));

      const previousPublished = await this.videoFaceRepository.getPublishedFaceIds(id);
      const idMap = await this.videoFaceRepository.persistIdentities(runId, id, upserts);
      const publishedCount = await this.publish(id, asset.clusterGroupId, result.identities, idMap, previousPublished, machineLearning);

      await this.videoFaceRepository.finishRun(runId, {
        outcome: result.outcome,
        extractions: result.extractions,
        framesAnalyzed: result.frames.length,
        detections: result.detections,
        embeddings: result.detections,
        identities: result.identities.length,
        durationMs: result.durationMs,
        firstSampledMs: result.frames.length > 0 ? Math.min(...result.frames.map((f) => f.timeMs)) : 0,
        lastSampledMs: result.frames.length > 0 ? Math.max(...result.frames.map((f) => f.timeMs)) : 0,
      });

      this.logger.log(
        `Video face scan ${id}: ${result.outcome} — ${result.frames.length} frames, ${result.detections} detections, ` +
          `${result.identities.length} identities (${publishedCount} published), ${result.durationMs}ms timeline`,
      );
      return JobStatus.Success;
    } catch (error) {
      this.logger.error(`Video face scan failed for asset ${id}: ${error}`);
      await this.videoFaceRepository.finishRun(runId, {
        outcome: 'decode_failed',
        extractions: result?.extractions ?? 0,
        framesAnalyzed: result?.frames.length ?? 0,
        detections: result?.detections ?? 0,
        embeddings: result?.detections ?? 0,
        identities: 0,
        durationMs: result?.durationMs ?? 0,
        firstSampledMs: result && result.frames.length > 0 ? Math.min(...result.frames.map((f) => f.timeMs)) : 0,
        lastSampledMs: result && result.frames.length > 0 ? Math.max(...result.frames.map((f) => f.timeMs)) : 0,
        error: String(error),
      });
      return JobStatus.Failed;
    } finally {
      if (result) {
        await this.cleanup(result);
      }
    }
  }

  /** Faces-in-this-video strip data (owner-scoped read). */
  async getVideoFaces(auth: AuthDto, assetId: string): Promise<VideoFacesResponseDto> {
    await requireAccess(this.accessRepository, { auth, permission: Permission.AssetRead, ids: [assetId] });
    const asset = await this.videoFaceRepository.getScanAsset(assetId);
    if (!asset) {
      throw new Error('asset not found');
    }
    const faces = await this.videoFaceRepository.getVideoFaces(assetId, asset.ownerId);
    const run = await this.videoFaceRepository.getLatestRun(assetId);
    return {
      faces: faces.map(
        (face): VideoFaceDto => ({
          id: face.id,
          firstObservedMs: face.firstObservedMs,
          lastObservedMs: face.lastObservedMs,
          sightingCount: face.sightingCount,
          bestFrameMs: face.bestFrameMs,
          flagged: face.flagged,
          personGroupId: face.personGroupId,
          personName: face.personName,
          assetFaceId: face.assetFaceId,
          sightings: face.sightings,
        }),
      ),
      run: run ? ({ ...run, finishedAt: run.finishedAt?.toISOString() ?? null } as VideoFaceRunDto) : null,
    };
  }

  /** Crop of a face's representative frame for the strip card. */
  async getFaceThumbnail(auth: AuthDto, assetId: string, videoFaceId: string): Promise<ImmichFileResponse> {
    await requireAccess(this.accessRepository, { auth, permission: Permission.AssetRead, ids: [assetId] });
    const asset = await this.videoFaceRepository.getScanAsset(assetId);
    if (!asset) {
      throw new Error('asset not found');
    }
    const face = (await this.videoFaceRepository.getVideoFaces(assetId, asset.ownerId)).find((f) => f.id === videoFaceId);
    if (!face) {
      throw new Error('video face not found');
    }
    const sighting = face.sightings.find((s) => s.timeMs === face.bestFrameMs) ?? face.sightings[0];
    if (!sighting) {
      throw new Error('video face has no sightings');
    }

    const dir = await mkdtemp(join(tmpdir(), 'immich-video-face-thumb-'));
    try {
      const framePath = join(dir, 'f.jpg');
      await this.mediaRepository.grabVideoFrame(asset.originalPath, face.bestFrameMs / 1000, framePath);
      // pad 25% around the box, clamped to the frame — overflow makes sharp throw
      const boxW = sighting.x2 - sighting.x1;
      const boxH = sighting.y2 - sighting.y1;
      const left = Math.max(0, Math.round(sighting.x1 - boxW * 0.25));
      const top = Math.max(0, Math.round(sighting.y1 - boxH * 0.25));
      const width = Math.min(Math.max(8, Math.round(boxW * 1.5)), sighting.imageWidth - left);
      const height = Math.min(Math.max(8, Math.round(boxH * 1.5)), sighting.imageHeight - top);
      const buffer = await sharp(framePath)
        .extract({
          left,
          top,
          width,
          height,
        })
        .resize(160, 160, { fit: 'inside', withoutEnlargement: true })
        .webp({ quality: 80 })
        .toBuffer();
      return new ImmichFileResponse({
        buffer,
        contentType: 'image/webp',
        cacheControl: CacheControl.PrivateWithCache,
      });
    } finally {
      await rm(dir, { recursive: true, force: true });
    }
  }

    private modelVersions(machineLearning: Awaited<ReturnType<typeof getConfig>>['machineLearning']): string {
    return `${machineLearning.facialRecognition.modelName}/scan-core-1`;
  }

  private async executeScan(
    asset: { id: string; originalPath: string },
    cfg: VideoFaceScanConfig,
    machineLearning: Awaited<ReturnType<typeof getConfig>>['machineLearning'],
  ): Promise<ScanResult> {
    // idempotent; the CLI command context never receives ConfigInit
    this.machineLearningRepository.setup(machineLearning);
    const modelVersions = this.modelVersions(machineLearning);
    const configHash = createHash('sha256').update(configFingerprint(cfg, modelVersions)).digest('hex').slice(0, 16);
    const deadline = Date.now() + cfg.deadlineMs;
    const tempDir = await mkdtemp(join(tmpdir(), 'immich-video-face-'));
    const frames: GroupInput[] = [];
    const samples: ScanSample[] = [];
    const framePaths = new Map<number, string>();
    const history: { timeMs: number; newIdentityKeys: string[] }[] = [];
    let outcome: VideoFaceScanOutcome = 'budget_exhausted';
    let extractions = 0;
    let detections = 0;
    let decodeFailures = 0;
    let durationMs = 0;

    try {
      const probe = await this.mediaRepository.probe(asset.originalPath);
      durationMs = Math.round((probe.format.duration || 0) * 1000);
      if (durationMs <= 0) {
        outcome = 'decode_failed';
        return {
          outcome,
          durationMs,
          extractions,
          detections,
          frames,
          samples,
          identities: [],
          framePaths,
          tempDir,
          config: cfg,
          modelVersions,
          configHash,
        };
      }

      const plan = planUniformSamples(durationMs, cfg.framesBudget);
      let seenIdentityCount = 0;

      for (const point of plan) {
        if (Date.now() > deadline) {
          outcome = 'deadline';
          break;
        }

        const framePath = join(tempDir, `f-${point.timeMs}.jpg`);
        let actualSec: number;
        const grabStart = Date.now();
        try {
          actualSec = await this.mediaRepository.grabVideoFrame(asset.originalPath, point.timeMs / 1000, framePath);
          extractions += 1;
        } catch (error) {
          decodeFailures += 1;
          samples.push({
            requestedMs: point.timeMs,
            timeMs: 0,
            grabMs: Date.now() - grabStart,
            mlMs: 0,
            detections: 0,
            failed: true,
          });
          this.logger.warn(`Frame grab failed at ${point.timeMs}ms for asset ${asset.id}: ${error}`);
          if (decodeFailures >= MAX_DECODE_FAILURES) {
            outcome = 'decode_failed';
            break;
          }
          continue;
        }

        const mlStart = Date.now();
        const result = await this.machineLearningRepository.detectFaces(framePath, machineLearning.facialRecognition);
        const mlMs = Date.now() - mlStart;
        detections += result.faces.length;
        const timeMs = Math.round(actualSec * 1000);
        framePaths.set(timeMs, framePath);
        frames.push({
          timeMs,
          detections: result.faces.map((face) => ({
            score: face.score,
            sizePx: Math.min(face.boundingBox.x2 - face.boundingBox.x1, face.boundingBox.y2 - face.boundingBox.y1),
            x1: Math.round(face.boundingBox.x1),
            y1: Math.round(face.boundingBox.y1),
            x2: Math.round(face.boundingBox.x2),
            y2: Math.round(face.boundingBox.y2),
            imageWidth: result.imageWidth,
            imageHeight: result.imageHeight,
            embedding: typeof face.embedding === 'string' ? (JSON.parse(face.embedding) as number[]) : face.embedding,
          })),
        });
        samples.push({
          requestedMs: point.timeMs,
          timeMs,
          grabMs: Date.now() - grabStart - mlMs,
          mlMs,
          detections: result.faces.length,
          failed: false,
        });

        // incremental identity count feeds the run telemetry; the saturation
        // stop is NOT applied to uniform sampling — dense grids cover the
        // whole timeline by construction, and quiet stretches don't predict
        // later appearances (bench: identities arrived at 0:01–0:43)
        const count = groupDetections(frames, cfg).length;
        history.push({ timeMs, newIdentityKeys: count > seenIdentityCount ? ['new'] : [] });
        seenIdentityCount = count;
        void shouldStopForSaturation;
      }

      const identities = assignIdentityKeys(groupDetections(frames, cfg));
      return {
        outcome,
        durationMs,
        extractions,
        detections,
        frames,
        samples,
        identities,
        framePaths,
        tempDir,
        config: cfg,
        modelVersions,
        configHash,
      };
    } catch (error) {
      this.logger.error(`Video face scan loop failed for asset ${asset.id}: ${error}`);
      await rm(tempDir, { recursive: true, force: true });
      throw error;
    }
  }

  /**
   * Publish one representative per global person: representatives matching the
   * same existing person collapse to the best; each unmatched identity
   * publishes its own representative (normal recognition + minFaces applies
   * downstream). Previously published rows that were not re-published are
   * removed. Returns the number of published face rows.
   */
  private async publish(
    assetId: string,
    clusterGroupId: string,
    identities: VideoFaceIdentity[],
    idMap: Map<string, string>,
    previousPublished: string[],
    machineLearning: Awaited<ReturnType<typeof getConfig>>['machineLearning'],
  ): Promise<number> {
    const publishable = identities.filter((identity) => !identity.flagged);
    if (publishable.length === 0) {
      if (previousPublished.length > 0) {
        await this.personRepository.refreshFaces([], previousPublished, []);
      }
      return 0;
    }

    // match each representative against existing persons
    const byPerson = new Map<string | null, VideoFaceIdentity[]>();
    const personOf = new Map<VideoFaceIdentity, string | null>();
    for (const identity of publishable) {
      let personGroupId: string | null = null;
      try {
        const [match] = await this.searchRepository.searchFaces({
          clusterGroupId,
          embedding: toPgVector(identity.bestEmbedding),
          maxDistance: machineLearning.facialRecognition.maxDistance,
          numResults: 1,
          hasPerson: true,
        });
        personGroupId = match?.personGroupId ?? null;
      } catch {
        personGroupId = null;
      }
      personOf.set(identity, personGroupId);
      byPerson.set(personGroupId, [...(byPerson.get(personGroupId) ?? []), identity]);
    }

    const chosen: VideoFaceIdentity[] = [];
    for (const [personGroupId, group] of byPerson) {
      if (personGroupId === null) {
        chosen.push(...group);
      } else {
        chosen.push(group.reduce((best, i) => (i.bestSizePx * i.bestScore > best.bestSizePx * best.bestScore ? i : best)));
      }
    }

    const facesToAdd: Parameters<typeof this.personRepository.refreshFaces>[0] = [];
    const embeddings: Parameters<typeof this.personRepository.refreshFaces>[2] = [];
    const faceIdByVideoFaceId = new Map<string, string>();
    const unmatched: VideoFaceIdentity[] = [];
    for (const identity of chosen) {
      const faceId = this.cryptoRepository.randomUUID();
      const best = identity.sightings.find((s) => s.timeMs === identity.bestFrameMs) ?? identity.sightings[0];
      // persons matched at publish time are assigned inline — the recognition
      // queue can hold a six-figure backlog, so published faces must not wait
      // on it for a name
      const personGroupId = personOf.get(identity) ?? null;
      facesToAdd.push({
        id: faceId,
        assetId,
        imageWidth: best.imageWidth,
        imageHeight: best.imageHeight,
        boundingBoxX1: best.x1,
        boundingBoxY1: best.y1,
        boundingBoxX2: best.x2,
        boundingBoxY2: best.y2,
        frameTimeMs: identity.bestFrameMs,
        personGroupId: personGroupId ?? undefined,
      });
      embeddings.push({ faceId, embedding: toPgVector(identity.bestEmbedding) });
      if (!personGroupId) {
        unmatched.push(identity);
      }
      const videoFaceId = idMap.get(identity.identityKey);
      if (videoFaceId) {
        faceIdByVideoFaceId.set(videoFaceId, faceId);
      }
    }

    // remove rows published by a previous run that were not re-published
    const keep = new Set(faceIdByVideoFaceId.values());
    const toRemove = previousPublished.filter((faceId) => !keep.has(faceId));
    if (facesToAdd.length > 0 || toRemove.length > 0) {
      await this.personRepository.refreshFaces(facesToAdd, toRemove, embeddings);
    }

    for (const [videoFaceId, faceId] of faceIdByVideoFaceId) {
      await this.videoFaceRepository.linkAssetFace(videoFaceId, faceId);
    }

    if (unmatched.length > 0) {
      const faceIds = unmatched.map((identity) => faceIdByVideoFaceId.get(idMap.get(identity.identityKey)!)!);
      try {
        await this.jobRepository.queueAll(
          faceIds.filter(Boolean).map((id) => ({ name: JobName.FacialRecognition, data: { id } }) as const),
        );
      } catch (error) {
        // CLI context: no Bull workers are registered; recognition picks the
        // new faces up on its next queue-all pass
        this.logger.warn(`Could not queue facial recognition (${unmatched.length} faces): ${error}`);
      }
    }
    return facesToAdd.length;
  }
}

function toPgVector(embedding: number[]): string {
  return `[${embedding.join(',')}]`;
}
