import { Injectable } from '@nestjs/common';
import { type Insertable, type Kysely } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import { DB } from 'src/schema/index.js';
import { VideoFaceSightingTable } from 'src/schema/tables/video-face.table.js';

export interface VideoFaceRunStart {
  assetId: string;
  configHash: string;
  config: object;
  modelVersions: string;
  deadlineBudgetMs: number;
}

export interface VideoFaceRunFinish {
  outcome: 'saturated' | 'budget_exhausted' | 'deadline' | 'decode_failed';
  extractions: number;
  framesAnalyzed: number;
  detections: number;
  embeddings: number;
  identities: number;
  durationMs: number;
  firstSampledMs: number;
  lastSampledMs: number;
  error?: string | null;
}

// identity as produced by the grouping core, ready to persist
export interface VideoFaceUpsert {
  identityKey: string;
  firstObservedMs: number;
  lastObservedMs: number;
  sightingCount: number;
  bestFrameMs: number;
  bestScore: number;
  bestSizePx: number;
  embedding: number[];
  flagged: boolean;
  sightings: VideoFaceSightingInsert[];
}

export interface VideoFaceSightingInsert {
  timeMs: number;
  x1: number;
  y1: number;
  x2: number;
  y2: number;
  imageWidth: number;
  imageHeight: number;
  score: number;
  quality?: number | null;
}

export interface VideoFaceView {
  id: string;
  identityKey: string;
  firstObservedMs: number;
  lastObservedMs: number;
  sightingCount: number;
  bestFrameMs: number;
  bestScore: number;
  bestSizePx: number;
  flagged: boolean;
  assetFaceId: string | null;
  personGroupId: string | null;
  personName: string | null;
  sightings: { timeMs: number; score: number; x1: number; y1: number; x2: number; y2: number; imageWidth: number; imageHeight: number }[];
}

export interface VideoFaceRunView {
  id: string;
  outcome: string;
  configHash: string;
  framesAnalyzed: number;
  identities: number;
  durationMs: number;
  firstSampledMs: number;
  lastSampledMs: number;
  finishedAt: Date | null;
}

const RECONCILE_DISTANCE = 0.55;

@Injectable()
export class VideoFaceRepository {
  constructor(@InjectKysely() private db: Kysely<DB>) {}

  async createRun(run: VideoFaceRunStart): Promise<string> {
    const row = await this.db
      .insertInto('video_face_run')
      .values({ ...run, outcome: 'deadline', deadlineBudgetMs: run.deadlineBudgetMs })
      .returning('id')
      .executeTakeFirstOrThrow();
    return row.id;
  }

  async finishRun(runId: string, finish: VideoFaceRunFinish): Promise<void> {
    await this.db.updateTable('video_face_run').set({ ...finish, error: finish.error ?? null }).where('id', '=', runId).execute();
  }

  async getLatestRun(assetId: string): Promise<VideoFaceRunView | null> {
    const run = await this.db
      .selectFrom('video_face_run')
      .select([
        'id',
        'outcome',
        'configHash',
        'framesAnalyzed',
        'identities',
        'durationMs',
        'firstSampledMs',
        'lastSampledMs',
        'updatedAt',
      ])
      .where('assetId', '=', assetId)
      .orderBy('createdAt', 'desc')
      .limit(1)
      .executeTakeFirst();
    if (!run) {
      return null;
    }
    const { updatedAt, ...rest } = run;
    return { ...rest, finishedAt: updatedAt };
  }

  /**
   * Persist identities for an asset, reconciling against existing rows by
   * embedding similarity so identityKey and the published assetFaceId link
   * (i.e. manual person assignments through the normal face UI) survive a
   * re-scan. Identities that no longer match anything are deleted (sightings
   * cascade). Returns rows keyed by identityKey with their persisted ids.
   */
  async persistIdentities(
    runId: string,
    assetId: string,
    identities: VideoFaceUpsert[],
  ): Promise<Map<string, string>> {
    const existing = await this.db
      .selectFrom('video_face')
      .select(['id', 'identityKey', 'embedding', 'assetFaceId'])
      .where('assetId', '=', assetId)
      .execute();

    const idByIdentityKey = new Map<string, string>();
    const used = new Set<string>();
    for (const identity of identities) {
      let match: (typeof existing)[number] | undefined;
      let best = Number.POSITIVE_INFINITY;
      for (const row of existing) {
        if (used.has(row.id)) {
          continue;
        }
        const d = cosineDistance(identity.embedding, row.embedding as number[]);
        if (d < best) {
          best = d;
          match = row;
        }
      }
      if (match && best < RECONCILE_DISTANCE) {
        used.add(match.id);
        idByIdentityKey.set(identity.identityKey, match.id);
        await this.db
          .updateTable('video_face')
          .set({
            runId,
            firstObservedMs: identity.firstObservedMs,
            lastObservedMs: identity.lastObservedMs,
            sightingCount: identity.sightingCount,
            bestFrameMs: identity.bestFrameMs,
            bestScore: identity.bestScore,
            bestSizePx: identity.bestSizePx,
            embedding: identity.embedding,
            flagged: identity.flagged,
          })
          .where('id', '=', match.id)
          .execute();
        await this.db.deleteFrom('video_face_sighting').where('videoFaceId', '=', match.id).execute();
      } else {
        const row = await this.db
          .insertInto('video_face')
          .values({
            assetId,
            runId,
            identityKey: identity.identityKey,
            firstObservedMs: identity.firstObservedMs,
            lastObservedMs: identity.lastObservedMs,
            sightingCount: identity.sightingCount,
            bestFrameMs: identity.bestFrameMs,
            bestScore: identity.bestScore,
            bestSizePx: identity.bestSizePx,
            embedding: identity.embedding,
            flagged: identity.flagged,
          })
          .returning('id')
          .executeTakeFirstOrThrow();
        idByIdentityKey.set(identity.identityKey, row.id);
      }
      if (identity.sightings.length > 0) {
        await this.db
          .insertInto('video_face_sighting')
          .values(
            identity.sightings.map(
              (s): Insertable<VideoFaceSightingTable> => ({
                timeMs: s.timeMs,
                score: s.score,
                x1: s.x1,
                y1: s.y1,
                x2: s.x2,
                y2: s.y2,
                imageWidth: s.imageWidth,
                imageHeight: s.imageHeight,
                videoFaceId: idByIdentityKey.get(identity.identityKey)!,
                runId,
              }),
            ),
          )
          .execute();
      }
    }

    // drop identities that no longer exist after this run
    const keep = new Set(idByIdentityKey.values());
    for (const row of existing) {
      if (!keep.has(row.id)) {
        await this.db.deleteFrom('video_face').where('id', '=', row.id).execute();
      }
    }
    return idByIdentityKey;
  }

  async linkAssetFace(videoFaceId: string, assetFaceId: string): Promise<void> {
    await this.db.updateTable('video_face').set({ assetFaceId }).where('id', '=', videoFaceId).execute();
  }

  async getVideoFaces(assetId: string, ownerId: string): Promise<VideoFaceView[]> {
    const faces = await this.db
      .selectFrom('video_face')
      .selectAll('video_face')
      .where('video_face.assetId', '=', assetId)
      .orderBy('video_face.firstObservedMs', 'asc')
      .execute();

    if (faces.length === 0) {
      return [];
    }

    const linkedIds = faces.map((f) => f.assetFaceId).filter((id): id is string => id !== null);
    const personByFaceId = new Map<string, { personGroupId: string | null; personName: string | null }>();
    if (linkedIds.length > 0) {
      const linked = await this.db
        .selectFrom('asset_face')
        .select(['asset_face.id as assetFaceId', 'asset_face.personGroupId as personGroupId'])
        .where('asset_face.id', 'in', linkedIds)
        .execute();
      const groupIds = linked.map((r) => r.personGroupId).filter((id): id is string => id !== null);
      const nameByGroupId = new Map<string, string>();
      if (groupIds.length > 0) {
        const people = await this.db
          .selectFrom('person')
          .selectAll()
          .where('personGroupId', 'in', groupIds)
          .where('ownerId', '=', ownerId)
          .execute();
        for (const person of people) {
          nameByGroupId.set(person.personGroupId, person.name ?? '');
        }
      }
      for (const row of linked) {
        const personGroupId = row.personGroupId ?? null;
        personByFaceId.set(row.assetFaceId, {
          personGroupId,
          personName: personGroupId ? nameByGroupId.get(personGroupId) || null : null,
        });
      }
    }

    const sightings = await this.db
      .selectFrom('video_face_sighting')
      .select(['videoFaceId', 'timeMs', 'score', 'x1', 'y1', 'x2', 'y2', 'imageWidth', 'imageHeight'])
      .where(
        'videoFaceId',
        'in',
        faces.map((f) => f.id),
      )
      .orderBy('timeMs', 'asc')
      .execute();

    const byFace = new Map<string, { timeMs: number; score: number; x1: number; y1: number; x2: number; y2: number; imageWidth: number; imageHeight: number }[]>();
    for (const s of sightings) {
      byFace.set(s.videoFaceId, [
        ...(byFace.get(s.videoFaceId) ?? []),
        {
          timeMs: s.timeMs,
          score: s.score,
          x1: s.x1,
          y1: s.y1,
          x2: s.x2,
          y2: s.y2,
          imageWidth: s.imageWidth,
          imageHeight: s.imageHeight,
        },
      ]);
    }

    return faces.map(
      (face): VideoFaceView => ({
        id: face.id,
        identityKey: face.identityKey,
        firstObservedMs: face.firstObservedMs,
        lastObservedMs: face.lastObservedMs,
        sightingCount: face.sightingCount,
        bestFrameMs: face.bestFrameMs,
        bestScore: face.bestScore,
        bestSizePx: face.bestSizePx,
        flagged: face.flagged,
        assetFaceId: face.assetFaceId,
        ...(personByFaceId.get(face.assetFaceId ?? '') ?? { personGroupId: null, personName: null }),
        sightings: byFace.get(face.id) ?? [],
      }),
    );
  }

  async hasVideoFaces(assetIds: string[]): Promise<Set<string>> {
    if (assetIds.length === 0) {
      return new Set();
    }
    const rows = await this.db
      .selectFrom('video_face')
      .select('assetId')
      .where('assetId', 'in', assetIds)
      .distinct()
      .execute();
    return new Set(rows.map((r) => r.assetId));
  }

  async deleteRunsForAsset(assetId: string): Promise<void> {
    await this.db.deleteFrom('video_face_run').where('assetId', '=', assetId).execute();
  }

  /** Asset + owner cluster needed to run a scan and publish representatives. */
  async getScanAsset(id: string) {
    return await this.db
      .selectFrom('asset')
      .innerJoin('user', 'user.id', 'asset.ownerId')
      .select([
        'asset.id',
        'asset.type',
        'asset.visibility',
        'asset.ownerId',
        'asset.originalPath',
        'user.clusterGroupId as clusterGroupId',
      ])
      .where('asset.id', '=', id)
      .executeTakeFirst();
  }

  /** asset_face ids published by the video scan for this asset (any run). */
  async getPublishedFaceIds(assetId: string): Promise<string[]> {
    const rows = await this.db
      .selectFrom('video_face')
      .select('assetFaceId')
      .where('assetId', '=', assetId)
      .where('assetFaceId', 'is not', null)
      .execute();
    return rows.map((r) => r.assetFaceId!).filter(Boolean);
  }
}

export function cosineDistance(a: number[], b: number[]): number {
  let dot = 0;
  let na = 0;
  let nb = 0;
  const n = Math.min(a.length, b.length);
  for (let i = 0; i < n; i++) {
    dot += a[i] * b[i];
    na += a[i] * a[i];
    nb += b[i] * b[i];
  }
  if (na === 0 || nb === 0) {
    return 1;
  }
  return 1 - dot / Math.sqrt(na * nb);
}
