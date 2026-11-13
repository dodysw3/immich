import { BadRequestException, Injectable } from '@nestjs/common';
import { createHash } from 'node:crypto';
import { mapAsset } from 'src/dtos/asset-response.dto.js';
import type { AuthDto } from 'src/dtos/auth.dto.js';
import {
  TranscriptionMatchDto,
  TranscriptionMomentsDto,
  TranscriptionMomentsResponseDto,
  TranscriptionSearchDto,
  TranscriptionSearchItemDto,
  TranscriptionSearchResponseDto,
} from 'src/dtos/search.dto.js';
import { AssetVisibility } from 'src/enum.js';
import { ConfigRepository } from 'src/repositories/config.repository.js';
import { LoggingRepository } from 'src/repositories/logging.repository.js';
import { PartnerRepository } from 'src/repositories/partner.repository.js';
import { SystemMetadataRepository } from 'src/repositories/system-metadata.repository.js';
import {
  TranscriptCandidateRow,
  TranscriptIndexRepository,
  TranscriptSearchRepository,
} from 'src/repositories/transcript-index.repository.js';
import { requireElevatedPermission } from 'src/utils/access.js';
import { getMyPartnerIds } from 'src/utils/asset.util.js';
import { getConfig } from 'src/utils/config.js';
import { TRANSCRIPT_INDEX_VERSION } from 'src/utils/transcript-index.js';
import {
  compareTranscriptMatches,
  deduplicateTranscriptMatches,
  normalizeTranscript,
  rankTranscriptWindow,
  type TokenSimilarity,
  type TranscriptMatch,
  type TranscriptRankingSettings,
  type TranscriptWindow,
} from 'src/utils/video-transcription-search.js';

/**
Candidate cap: verification is bounded CPU work, but an unbounded common-word
query on a huge library must fail explicitly instead of silently truncating
results (the ranking contract allows no partial pages).
*/
const MAX_CANDIDATES = 20_000;
const MAX_QUERY_TOKENS = 12;

type RankedMatch = TranscriptMatch & {
  videoId: string;
  passageId: string;
  revision: string;
  runKey: string;
};

/**
Dedicated speech-transcript search: exact-first lexical ranking over derived
passages, spelling fallback via trigram similarity only. No embeddings, no
semantic matching, no interpretation or caption text. Access filters apply in
the candidate SQL; grouping, pagination, and counts obey the same rules.
*/
@Injectable()
export class TranscriptSearchService {
  constructor(
    private logger: LoggingRepository,
    private configRepository: ConfigRepository,
    private systemMetadataRepository: SystemMetadataRepository,
    private partnerRepository: PartnerRepository,
    private searchRepository: TranscriptSearchRepository,
    private indexRepository: TranscriptIndexRepository,
  ) {
    this.logger.setContext(TranscriptSearchService.name);
  }

  async searchTranscription(auth: AuthDto, dto: TranscriptionSearchDto): Promise<TranscriptionSearchResponseDto> {
    const settings = await this.rankingSettings();
    const configVersion = this.configVersion(settings);
    const userIds = await this.getUserIdsToSearch(auth, dto.visibility);
    const visibility = dto.visibility ?? (auth.session?.hasElevatedPermission ? undefined : ('not-locked' as const));
    const filters = {
      userIds,
      visibility,
      takenAfter: dto.takenAfter,
      takenBefore: dto.takenBefore,
      isFavorite: dto.isFavorite,
      rating: dto.rating,
      city: dto.city,
      state: dto.state,
      country: dto.country,
      make: dto.make,
      model: dto.model,
      lensModel: dto.lensModel,
      personIds: dto.personIds,
      tagIds: dto.tagIds,
      isNotInAlbum: dto.isNotInAlbum,
      withStacked: dto.withStacked,
    };

    const tokens = this.queryTokens(dto.q);
    if (tokens.length === 0) {
      return { count: 0, items: [], nextCursor: null, configVersion };
    }
    const matches = await this.rankMatches(filters, dto.q, settings);

    // Group best-per-video: ranking uses the best passage, never accumulated
    // occurrence counts; distinct repeated moments stay available.
    const byVideo = new Map<string, RankedMatch[]>();
    for (const match of matches) {
      const list = byVideo.get(match.videoId);
      if (list) {
        list.push(match);
      } else {
        byVideo.set(match.videoId, [match]);
      }
    }

    const videos = [...byVideo]
      .map(([videoId, list]) => {
        const deduped = deduplicateTranscriptMatches(list) as RankedMatch[];
        return { videoId, deduped, best: deduped[0]! };
      })
      .sort(
        (a, b) =>
          compareTranscriptMatches(a.best, b.best) || (a.videoId < b.videoId ? -1 : a.videoId > b.videoId ? 1 : 0),
      );

    const cursor = this.decodeCursor(dto.cursor, configVersion);
    const startIndex = cursor ? videos.findIndex((video) => this.videoKey(video) === cursor.lastKey) + 1 : 0;
    if (cursor && startIndex === 0 && videos.every((video) => this.videoKey(video) !== cursor.lastKey)) {
      throw new BadRequestException('Invalid transcription search cursor');
    }
    const page = videos.slice(Math.max(startIndex, 0), Math.max(startIndex, 0) + dto.size);
    const hasNext = Math.max(startIndex, 0) + dto.size < videos.length;

    const assets = await this.searchRepository.getAssetsByIds(page.map((video) => video.videoId));
    const assetsById = new Map(assets.map((asset) => [asset.id, asset]));

    const items: TranscriptionSearchItemDto[] = [];
    for (const video of page) {
      const asset = assetsById.get(video.videoId);
      if (!asset) {
        continue;
      }
      const [best, ...additional] = video.deduped;
      items.push({
        asset: mapAsset(asset, { auth }),
        bestMatch: this.toMatchDto(best!, dto.explain === true),
        additionalMatches: additional
          .slice(0, settings.additionalMoments)
          .map((match) => this.toMatchDto(match, dto.explain === true)),
        matchCount: video.deduped.length,
      });
    }

    const coverage =
      dto.explain === true
        ? { ...(await this.searchRepository.getScopedCoverage(filters as never, TRANSCRIPT_INDEX_VERSION)) }
        : undefined;

    return {
      count: items.length,
      items,
      nextCursor: hasNext ? this.encodeCursor(this.videoKey(page.at(-1)!), configVersion) : null,
      configVersion,
      coverage,
    };
  }

  async searchMoments(auth: AuthDto, dto: TranscriptionMomentsDto): Promise<TranscriptionMomentsResponseDto> {
    const settings = await this.rankingSettings();
    const configVersion = this.configVersion(settings);
    const userIds = await this.getUserIdsToSearch(auth, undefined);
    const visibility = auth.session?.hasElevatedPermission ? undefined : ('not-locked' as const);
    const tokens = this.queryTokens(dto.q);
    if (tokens.length === 0) {
      return { count: 0, moments: [], nextCursor: null, configVersion };
    }
    const ranked = await this.rankMatches({ userIds, visibility }, dto.q, settings);
    const assetMatches = ranked.filter((match) => match.videoId === dto.assetId);
    const deduped = deduplicateTranscriptMatches(assetMatches) as RankedMatch[];

    const cursor = this.decodeCursor(dto.cursor, configVersion);
    const startIndex = cursor ? deduped.findIndex((match) => this.matchKey(match) === cursor.lastKey) + 1 : 0;
    if (cursor && startIndex === 0 && deduped.every((match) => this.matchKey(match) !== cursor.lastKey)) {
      throw new BadRequestException('Invalid transcription moments cursor');
    }
    const page = deduped.slice(Math.max(startIndex, 0), Math.max(startIndex, 0) + dto.size);
    const hasNext = Math.max(startIndex, 0) + dto.size < deduped.length;

    return {
      count: page.length,
      moments: page.map((match) => this.toMatchDto(match, false)),
      nextCursor: hasNext ? this.encodeCursor(this.matchKey(page.at(-1)!), configVersion) : null,
      configVersion,
    };
  }

  /**
  SQL candidate retrieval (index-backed, access-filtered) followed by exact
  TS verification and ranking. Fuzzy candidates come from the token pool with
  per-pair trigram similarity returned by the same SQL, so the verification
  never guesses similarity values.
  */
  private async rankMatches(
    filters: Record<string, unknown>,
    query: string,
    settings: TranscriptRankingSettings,
  ): Promise<RankedMatch[]> {
    const tokens = this.queryTokens(query);
    if (tokens.length === 0) {
      return [];
    }
    const fuzzyTokens = tokens.filter((token) => token.length >= settings.minimumFuzzyLength);
    const [exact, fuzzy, sims] = await Promise.all([
      this.searchRepository.searchExactCandidates(filters as never, tokens),
      fuzzyTokens.length > 0
        ? this.searchRepository.searchFuzzyCandidates(filters as never, fuzzyTokens, settings.fuzzyThreshold)
        : Promise.resolve([] as TranscriptCandidateRow[]),
      fuzzyTokens.length > 0
        ? this.searchRepository.searchTokenSimilarities(fuzzyTokens, settings.fuzzyThreshold)
        : Promise.resolve([] as Array<{ qtoken: string; token: string; sim: number }>),
    ]);

    const simByKey = new Map<string, number>();
    for (const { qtoken, token, sim } of sims) {
      simByKey.set(`${qtoken}\0${token}`, sim);
    }
    const similarity: TokenSimilarity = (queryToken, passageToken) => {
      const exactMatch = queryToken === passageToken ? 1 : undefined;
      return exactMatch ?? simByKey.get(`${queryToken}\0${passageToken}`) ?? 0;
    };

    const candidates = new Map<string, TranscriptCandidateRow>();
    for (const row of [...exact, ...fuzzy]) {
      candidates.set(row.passageId, row);
    }
    if (candidates.size > MAX_CANDIDATES) {
      throw new BadRequestException(
        `Transcription query matched ${candidates.size} passages; narrow the query (limit is ${MAX_CANDIDATES})`,
      );
    }

    const matches: RankedMatch[] = [];
    for (const row of candidates.values()) {
      const window = this.toWindow(row);
      const match = rankTranscriptWindow(window, tokens.join(' '), similarity, settings);
      if (match) {
        matches.push({
          ...match,
          videoId: row.assetId,
          passageId: row.passageId,
          revision: row.revision,
          runKey: row.runKey,
        });
      }
    }
    return matches;
  }

  /** Rebuild the ranking window from stored columns; token offsets are re-derived from the original text. */
  private toWindow(row: TranscriptCandidateRow): TranscriptWindow {
    return {
      id: row.windowId,
      firstSegment: row.firstSegment,
      lastSegment: row.lastSegment,
      startMs: row.startMs,
      endMs: row.endMs,
      text: row.text,
      tokens: normalizeTranscript(row.text).tokens,
      segmentSpans: row.segmentSpans,
      segmentStartsMs: row.segmentStartsMs,
    };
  }

  private queryTokens(q: string): string[] {
    const tokens = normalizeTranscript(q)
      .tokens.map((token) => token.text)
      .slice(0, MAX_QUERY_TOKENS);
    return [...new Set(tokens)];
  }

  private async rankingSettings(): Promise<TranscriptRankingSettings & { additionalMoments: number }> {
    const config = await getConfig(
      { configRepo: this.configRepository, metadataRepo: this.systemMetadataRepository, logger: this.logger },
      { withCache: true },
    );
    return config.transcriptionSearch;
  }

  private configVersion(settings: TranscriptRankingSettings): string {
    return createHash('sha256').update(JSON.stringify(settings)).digest('hex').slice(0, 16);
  }

  private videoKey(video: { best: TranscriptMatch; videoId: string }): string {
    // The cursor only needs key equality (videos are pre-sorted); the full
    // ordering tuple keeps it stable and debuggable.
    return JSON.stringify([video.best.tier, video.best.score, video.best.startMs, video.videoId, video.best.window.id]);
  }

  private matchKey(match: TranscriptMatch): string {
    return JSON.stringify([match.tier, match.score, match.startMs, match.window.id]);
  }

  private encodeCursor(lastKey: string, configVersion: string): string {
    return Buffer.from(JSON.stringify({ k: lastKey, v: configVersion }), 'utf8').toString('base64url');
  }

  private decodeCursor(cursor: string | undefined, configVersion: string): { lastKey: string } | null {
    if (!cursor) {
      return null;
    }
    let parsed: { k: string; v: string };
    try {
      parsed = JSON.parse(Buffer.from(cursor, 'base64url').toString('utf8'));
    } catch {
      throw new BadRequestException('Invalid transcription search cursor');
    }
    if (parsed.v !== configVersion) {
      // Never mix ranking profiles across a cursor: the client restarts.
      throw new BadRequestException('Ranking configuration changed; restart the search without the cursor');
    }
    return { lastKey: parsed.k };
  }

  private toMatchDto(match: RankedMatch, explain: boolean): TranscriptionMatchDto {
    return {
      passageId: match.passageId,
      revision: match.revision,
      runKey: match.runKey,
      windowId: match.window.id,
      firstSegment: match.window.firstSegment,
      lastSegment: match.window.lastSegment,
      startMs: match.startMs,
      endMs: match.window.endMs,
      snippet: match.window.text,
      spans: match.spans,
      tier: match.tier,
      score: match.score,
      components: explain
        ? { coverage: match.coverage, proximity: match.proximity, similarity: match.similarity }
        : undefined,
    };
  }

  private async getUserIdsToSearch(auth: AuthDto, visibility?: AssetVisibility): Promise<string[]> {
    if (visibility === AssetVisibility.Locked) {
      requireElevatedPermission(auth);
      return [auth.user.id];
    }
    const partnerIds = await getMyPartnerIds({
      userId: auth.user.id,
      repository: this.partnerRepository,
      timelineEnabled: true,
    });
    return [auth.user.id, ...partnerIds];
  }
}
