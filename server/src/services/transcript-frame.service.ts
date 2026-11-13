import { BadRequestException, Injectable } from '@nestjs/common';
import { createHash } from 'node:crypto';
import { join } from 'node:path';
import { StorageCore } from 'src/cores/storage.core.js';
import { AssetType, CacheControl, StorageFolder } from 'src/enum.js';
import { AccessRepository } from 'src/repositories/access.repository.js';
import { AssetRepository } from 'src/repositories/asset.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { MediaRepository } from 'src/repositories/media.repository.js';
import { StorageRepository } from 'src/repositories/storage.repository.js';
import { TranscriptSearchRepository } from 'src/repositories/transcript-index.repository.js';
import { requireAccess } from 'src/utils/access.js';
import { ImmichFileResponse } from 'src/utils/file.js';

/** Card-size frames: long edge capped, matching gallery card resolution needs. */
const FRAME_MAX_SIDE = 720;
/** Cache format version: bump to invalidate every cached frame. */
const FRAME_FORMAT_VERSION = 1;
/** Bounded private cache: file count cap with oldest-first eviction. */
const CACHE_MAX_FILES = 2000;
/** Concurrent decode cap (ffmpeg seeks are CPU-heavy) + queue cap for dedupe backlog. */
const MAX_CONCURRENT_DECODES = 2;
const MAX_QUEUED_REQUESTS = 10;

/**
Authenticated matching-frame delivery for Transcription search results.

Identity is SERVER-RESOLVED: the caller passes the opaque passage id from its
search result and the service looks up the passage's revision and segment
start itself — no client-controlled file path or arbitrary timestamp. Access
is checked before EVERY response, cached or not, and responses are sent
private/no-store so shared caches can never bypass authorization. The cache
is regenerable derived data (bounded file count, oldest-first eviction);
frame failures fall back to the ordinary thumbnail without hiding the match.
*/
@Injectable()
export class TranscriptFrameService {
  // Resolved lazily: StorageCore's media location is only set by StorageService
  // after DI constructs this service, so a field initializer here would throw
  // "Media location is not set." at boot (crash loop).
  #cacheDir: string | undefined;
  private get cacheDir() {
    return (this.#cacheDir ??= join(StorageCore.getBaseFolder(StorageFolder.Thumbnails), 'transcript-frames'));
  }
  private inflight = new Map<string, Promise<ImmichFileResponse>>();
  private decodeSlots = MAX_CONCURRENT_DECODES;
  private queued = 0;
  private waiters: Array<() => void> = [];

  constructor(
    private logger: LoggingRepository,
    private accessRepository: AccessRepository,
    private assetRepository: AssetRepository,
    private mediaRepository: MediaRepository,
    private storageRepository: StorageRepository,
    private searchRepository: TranscriptSearchRepository,
  ) {
    this.logger.setContext(TranscriptFrameService.name);
  }

  /**
  Resolve the cached-or-fresh frame path for (asset, passage). Throws when
  the passage, asset, or access check fails; callers stream the file with
  private/no-store headers.
  */
  async resolveFrame(
    auth: { user: { id: string } } & Record<string, unknown>,
    assetId: string,
    passageId: string,
  ): Promise<ImmichFileResponse> {
    await requireAccess(this.accessRepository, {
      auth: auth as never,
      permission: 'asset.read' as never,
      ids: [assetId],
    });

    const [asset] = await this.assetRepository.getByIds([assetId]);
    if (!asset || asset.type !== AssetType.Video) {
      throw new BadRequestException('Match frames are only available for video assets');
    }

    const passage = await this.searchRepository.getPassage(passageId);
    if (!passage || passage.assetId !== assetId) {
      throw new BadRequestException('Unknown match passage');
    }

    const startMs = passage.startMs;
    if (startMs < 0) {
      throw new BadRequestException('Invalid match timestamp');
    }
    // Timestamp zero is valid; only clearly-beyond-duration seeks are rejected
    // up front (ffmpeg decode errors surface as fallback-to-thumbnail).
    const durationSec = parseDurationSec(String(asset.duration ?? ''));
    if (durationSec !== null && startMs / 1000 > durationSec + 1) {
      throw new BadRequestException('Match timestamp is beyond the video duration');
    }

    const checksum = Buffer.from(asset.checksum).toString('hex');
    const key = createHash('sha256')
      .update(`${passage.revision}:${checksum}:${startMs}:${FRAME_MAX_SIDE}:${FRAME_FORMAT_VERSION}`)
      .digest('hex');
    const assetPrefix = createHash('sha256').update(assetId).digest('hex').slice(0, 16);
    const cachedPath = join(this.cacheDir, `${assetPrefix}-${key}.jpg`);

    // Auth-before-cache: every response re-checks access above, including hits.
    if (await this.storageRepository.checkFileExists(cachedPath)) {
      return new ImmichFileResponse({
        path: cachedPath,
        contentType: 'image/jpeg',
        cacheControl: CacheControl.PrivateWithoutCache,
      });
    }

    // Same-key request deduplication: concurrent card renders share one decode.
    const existing = this.inflight.get(key);
    if (existing) {
      return existing;
    }

    if (this.queued >= MAX_QUEUED_REQUESTS) {
      throw new BadRequestException('Too many concurrent frame decodes; retry shortly');
    }

    const promise = this.decode(assetPrefix, key, cachedPath, asset.originalPath, startMs).finally(() => {
      this.inflight.delete(key);
    });
    this.inflight.set(key, promise);
    return promise;
  }

  private async decode(
    assetPrefix: string,
    key: string,
    outputPath: string,
    input: string,
    startMs: number,
  ): Promise<ImmichFileResponse> {
    await this.acquireSlot();
    try {
      this.storageRepository.mkdirSync(join(this.cacheDir));
      const seekSec = Math.max(0, startMs / 1000);
      await this.mediaRepository.grabVideoFrame(input, seekSec, outputPath, FRAME_MAX_SIDE);
      this.logger.debug(
        `Match frame decoded for ${assetPrefix.slice(0, 8)}/${key.slice(0, 8)} at ${seekSec.toFixed(3)}s`,
      );
      await this.evict();
      return new ImmichFileResponse({
        path: outputPath,
        contentType: 'image/jpeg',
        cacheControl: CacheControl.PrivateWithoutCache,
      });
    } catch (error) {
      this.logger.warn(`Match frame decode failed for ${assetPrefix.slice(0, 8)}/${key.slice(0, 8)}: ${error}`);
      throw error;
    } finally {
      this.releaseSlot();
    }
  }

  private async acquireSlot(): Promise<void> {
    if (this.decodeSlots > 0) {
      this.decodeSlots--;
      return;
    }
    this.queued++;
    try {
      await new Promise<void>((resolve) => {
        this.waiters.push(resolve);
      });
    } finally {
      this.queued--;
    }
    this.decodeSlots--;
  }

  private releaseSlot(): void {
    this.decodeSlots++;
    const next = this.waiters.shift();
    if (next) {
      next();
    }
  }

  /** Oldest-first eviction keeps the private cache bounded. */
  private async evict(): Promise<void> {
    const entries = await this.storageRepository.readdirWithTypes(this.cacheDir).catch(() => []);
    const files = entries
      .filter((entry) => entry.isFile() && entry.name.endsWith('.jpg'))
      .map((entry) => join(this.cacheDir, entry.name));
    if (files.length <= CACHE_MAX_FILES) {
      return;
    }
    const withTimes = await Promise.all(
      files.map(async (file) => {
        const stats = await this.storageRepository.stat(file);
        return { file, mtime: stats.mtimeMs };
      }),
    );
    withTimes.sort((a, b) => a.mtime - b.mtime);
    const excess = withTimes.slice(0, withTimes.length - CACHE_MAX_FILES);
    for (const { file } of excess) {
      await this.storageRepository.unlink(file).catch(() => void 0);
    }
    this.logger.log(`Evicted ${excess.length} stale match frame(s)`);
  }

  /** Revision/deletion cleanup: drop every cached frame for one asset. */
  async invalidate(assetId: string): Promise<void> {
    const entries = await this.storageRepository.readdirWithTypes(this.cacheDir).catch(() => []);
    const prefix = `${createHash('sha256').update(assetId).digest('hex').slice(0, 16)}-`;
    for (const entry of entries) {
      if (entry.isFile() && entry.name.startsWith(prefix)) {
        await this.storageRepository.unlink(join(this.cacheDir, entry.name)).catch(() => void 0);
      }
    }
  }
}

const parseDurationSec = (duration: string | null | undefined): number | null => {
  if (!duration) {
    return null;
  }
  const parts = duration.split(':').map(Number);
  if (parts.some((part) => Number.isNaN(part))) {
    return null;
  }
  return parts.length === 3 ? parts[0]! * 3600 + parts[1]! * 60 + parts[2]! : null;
};
