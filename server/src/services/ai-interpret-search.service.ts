import { BadRequestException, Injectable } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';
import { LRUMap } from 'mnemonist';
import type { EnvData } from 'src/repositories/config.repository.js';
import type { JobOf } from 'src/types.js';
import { OnEvent, OnJob } from 'src/decorators.js';
import { AiInterpretationDocument, AiInterpretationDocumentSchema } from 'src/dtos/ai-image-interpretation.dto.js';
import { mapAsset } from 'src/dtos/asset-response.dto.js';
import { AuthDto } from 'src/dtos/auth.dto.js';
import { AiInterpretSearchDto, AiInterpretSearchItemDto, AiInterpretSearchResponseDto } from 'src/dtos/search.dto.js';
import { AssetVisibility, ImmichWorker, JobName, JobStatus, QueueName } from 'src/enum.js';
import { AiImageInterpretationRepository } from 'src/repositories/ai-image-interpretation.repository.js';
import { AiInterpretBranchRow, AiInterpretSearchRepository } from 'src/repositories/ai-interpret-search.repository.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { JobRepository } from 'src/repositories/job.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { PartnerRepository } from 'src/repositories/partner.repository.js';
import { AiInterpretSearchClient } from 'src/services/ai-interpret-search.client.js';
import { requireElevatedPermission } from 'src/utils/access.js';
import {
  buildAiInterpretDenseDoc,
  buildAiInterpretLexicalDoc,
  findLatestCompletedRun,
  toPgvectorString,
} from 'src/utils/ai-interpret-search.js';
import { getMyPartnerIds } from 'src/utils/asset.util.js';

// Reciprocal rank fusion constant; 60 is the canonical value from the RRF
// paper and dampens deep ranks so top hits from either branch dominate.
const RRF_K = 60;

type FusedEntry = { assetId: string; score: number; bestScore: number; branch: 'dense' | 'lexical' };

const fuse = (dense: AiInterpretBranchRow[], lexical: AiInterpretBranchRow[]): FusedEntry[] => {
  const entries = new Map<string, FusedEntry>();
  const contribute = (rows: AiInterpretBranchRow[], branch: 'dense' | 'lexical') => {
    for (const [index, { assetId }] of rows.entries()) {
      const contribution = 1 / (RRF_K + index + 1);
      const entry = entries.get(assetId);
      if (!entry) {
        entries.set(assetId, { assetId, score: contribution, bestScore: contribution, branch });
        continue;
      }

      entry.score += contribution;
      // provenance reports the branch that ranked this asset best; ties stay with dense
      if (!(contribution > entry.bestScore)) {
        continue;
      }

      entry.branch = branch;
      entry.bestScore = contribution;
    }
  };

  contribute(dense, 'dense');
  contribute(lexical, 'lexical');
  return entries
    .values()
    .toArray()
    .sort((a, b) => b.score - a.score || (a.assetId < b.assetId ? -1 : 1));
};

@Injectable()
export class AiInterpretSearchService {
  private embeddingCache = new LRUMap<string, string>(100);
  private reconcileRunning = false;

  constructor(
    private logger: LoggingRepository,
    private configRepository: ConfigRepository,
    private jobRepository: JobRepository,
    private interpretationRepository: AiImageInterpretationRepository,
    private partnerRepository: PartnerRepository,
    private repository: AiInterpretSearchRepository,
    private embeddingClient: AiInterpretSearchClient,
  ) {
    this.logger.setContext(AiInterpretSearchService.name);
  }

  @OnEvent({ name: 'AppBootstrap', workers: [ImmichWorker.Microservices] })
  async onBootstrap() {
    if (this.configRepository.getEnv().aiInterpretSearch.enabled) {
      await this.jobRepository.queue({ name: JobName.AiInterpretSearchReconcile });
    }
  }

  // The sweep re-covers rows the sync jobs could not write (endpoint outage,
  // lost queue state, model swaps) and performs the initial backfill of
  // existing interpretations; the post-completion hook covers the common case.
  @Cron('0 * * * *')
  async reconcilePeriodically() {
    if (
      this.configRepository.getWorker() !== ImmichWorker.Microservices ||
      !this.configRepository.getEnv().aiInterpretSearch.enabled
    ) {
      return;
    }

    await this.jobRepository.queue({ name: JobName.AiInterpretSearchReconcile });
  }

  @OnJob({ name: JobName.AiInterpretSearchSync, queue: QueueName.AiInterpretSearch })
  async handleSync({ id: assetId }: JobOf<JobName.AiInterpretSearchSync>): Promise<JobStatus> {
    const config = this.configRepository.getEnv().aiInterpretSearch;
    if (!config.enabled) {
      this.logger.debug(`Skipping AI interpret search sync for ${assetId}: feature is disabled`);
      return JobStatus.Skipped;
    }

    const latest = findLatestCompletedRun(await this.interpretationRepository.get(assetId));
    if (!latest) {
      this.logger.debug(`Skipping AI interpret search sync for ${assetId}: no completed interpretation run`);
      return JobStatus.Skipped;
    }

    const [vector] = await this.embeddingClient.embed([buildAiInterpretDenseDoc(latest.result)]);
    await this.repository.upsert({
      assetId,
      text: buildAiInterpretLexicalDoc(latest.result),
      embedding: toPgvectorString(vector),
      runKey: latest.runKey,
      model: config.model,
    });

    return JobStatus.Success;
  }

  @OnJob({ name: JobName.AiInterpretSearchReconcile, queue: QueueName.AiInterpretSearch })
  async handleReconcile(): Promise<JobStatus> {
    const config = this.configRepository.getEnv().aiInterpretSearch;
    if (!config.enabled || this.reconcileRunning) {
      return JobStatus.Skipped;
    }

    // Sweeps can run for hours during the initial backfill; hourly cron and
    // bootstrap triggers must not stack a second sweep on top of a live one.
    this.reconcileRunning = true;
    try {
      const limit = 500;
      let cursor: string | undefined;
      let enqueued = 0;
      let scanned = 0;

      do {
        const page = await this.repository.pageAssetsWithRuns({ cursor, limit });
        const stored = await this.repository.getStoredByAssetIds(page.items.map(({ assetId }) => assetId));

        for (const { assetId, value } of page.items) {
          const latest = findLatestCompletedRun(this.parseDocument(value));
          if (!latest) {
            continue;
          }

          const row = stored.get(assetId);
          if (row && row.runKey === latest.runKey && row.model === config.model) {
            continue;
          }

          await this.jobRepository.queue({ name: JobName.AiInterpretSearchSync, data: { id: assetId } });
          enqueued++;
        }

        scanned += page.items.length;
        cursor = page.nextCursor ?? undefined;
      } while (cursor);

      if (enqueued > 0) {
        this.logger.log(
          `AI interpret search reconcile enqueued ${enqueued} sync job(s) after scanning ${scanned} interpreted asset(s)`,
        );
      } else {
        this.logger.debug(`AI interpret search reconcile found nothing stale after scanning ${scanned} asset(s)`);
      }
    } finally {
      this.reconcileRunning = false;
    }

    return JobStatus.Success;
  }

  async searchAiInterpret(auth: AuthDto, dto: AiInterpretSearchDto): Promise<AiInterpretSearchResponseDto> {
    const config = this.configRepository.getEnv().aiInterpretSearch;
    if (!config.enabled) {
      throw new BadRequestException('AI interpret search is not enabled');
    }

    if (dto.visibility === AssetVisibility.Locked) {
      requireElevatedPermission(auth);
    }

    const userIds = await this.getUserIdsToSearch(auth, dto.visibility);
    const visibility = dto.visibility ?? (auth.session?.hasElevatedPermission ? undefined : 'not-locked');
    const embedding = await this.resolveQueryEmbedding(dto.q, config);
    const page = dto.page ?? 1;
    const size = dto.size;

    // Both branches are fused from a window that grows with the requested
    // page, so the fused ordering is stable across pages.
    const window = page * size;
    const [dense, lexical] = await Promise.all([
      this.repository.searchDense({ limit: window + 1 }, { embedding, userIds, visibility, minScore: config.minScore }),
      this.repository.searchLexical({ limit: window + 1 }, { q: dto.q, userIds, visibility }),
    ]);

    const denseRows = dense.slice(0, window);
    const lexicalRows = lexical.slice(0, window);
    const fused = fuse(denseRows, lexicalRows);
    // Each branch is fetched with window+1 rows: a full page in either branch
    // (or a fused list spilling past the window) means more pages remain.
    const hasNextPage = fused.length > window || dense.length > window || lexical.length > window;
    const pageEntries = fused.slice((page - 1) * size, page * size);

    const assets = await this.repository.getAssetsByIds(pageEntries.map(({ assetId }) => assetId));
    const assetsById = new Map(assets.map((asset) => [asset.id, asset]));

    const items: AiInterpretSearchItemDto[] = [];
    for (const { assetId, score, branch } of pageEntries) {
      const asset = assetsById.get(assetId);
      if (!asset) {
        continue;
      }

      items.push({ asset: mapAsset(asset, { auth }), score, branch });
    }

    return {
      total: fused.length,
      count: items.length,
      items,
      nextPage: hasNextPage ? (page + 1).toString() : null,
    };
  }

  private async resolveQueryEmbedding(q: string, config: EnvData['aiInterpretSearch']): Promise<string> {
    const key = config.model + q;
    let embedding = this.embeddingCache.get(key);
    if (!embedding) {
      const [vector] = await this.embeddingClient.embed([q]);
      embedding = toPgvectorString(vector);
      this.embeddingCache.set(key, embedding);
    }

    return embedding;
  }

  private async getUserIdsToSearch(auth: AuthDto, visibility?: AssetVisibility): Promise<string[]> {
    // Locked assets are personal. Never include partner IDs, regardless of A's elevated session.
    if (visibility === AssetVisibility.Locked) {
      return [auth.user.id];
    }

    const partnerIds = await getMyPartnerIds({
      userId: auth.user.id,
      repository: this.partnerRepository,
      timelineEnabled: true,
    });
    return [auth.user.id, ...partnerIds];
  }

  private parseDocument(value: unknown): AiInterpretationDocument | null {
    const parsed = AiInterpretationDocumentSchema.safeParse(value);
    return parsed.success ? parsed.data : null;
  }
}
