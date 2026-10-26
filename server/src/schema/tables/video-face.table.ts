import {
  Column,
  CreateDateColumn,
  ForeignKeyColumn,
  type Generated,
  Index,
  PrimaryGeneratedColumn,
  Table,
  type Timestamp,
  UpdateDateColumn,
} from '@immich/sql-tools';
import { UpdateIdColumn, UpdatedAtTrigger } from 'src/decorators.js';
import { AssetFaceTable } from 'src/schema/tables/asset-face.table.js';
import { AssetTable } from 'src/schema/tables/asset.table.js';

// One row per multi-frame scan run of a video asset.
@UpdatedAtTrigger('video_face_run_updatedAt')
@Table('video_face_run')
export class VideoFaceRunTable {
  @PrimaryGeneratedColumn()
  id!: Generated<string>;

  @ForeignKeyColumn(() => AssetTable, { onDelete: 'CASCADE', onUpdate: 'CASCADE' })
  assetId!: string;

  // sha256 of the resolved configuration + algorithm version; a different
  // hash on the latest run means the asset is stale for re-scan offers.
  @Column({ type: 'text' })
  configHash!: string;

  @Column({ type: 'jsonb' })
  config!: object;

  @Column({ type: 'text' })
  modelVersions!: string;

  // saturated | budget_exhausted | deadline | decode_failed
  @Column({ type: 'text' })
  outcome!: string;

  @Column({ type: 'integer', default: 0 })
  extractions!: Generated<number>;

  @Column({ type: 'integer', default: 0 })
  framesAnalyzed!: Generated<number>;

  @Column({ type: 'integer', default: 0 })
  detections!: Generated<number>;

  @Column({ type: 'integer', default: 0 })
  embeddings!: Generated<number>;

  @Column({ type: 'integer', default: 0 })
  identities!: Generated<number>;

  @Column({ type: 'integer', default: 0 })
  durationMs!: Generated<number>;

  @Column({ type: 'integer', default: 0 })
  firstSampledMs!: Generated<number>;

  @Column({ type: 'integer', default: 0 })
  lastSampledMs!: Generated<number>;

  @Column({ type: 'integer', default: 0 })
  deadlineBudgetMs!: Generated<number>;

  @Column({ type: 'text', nullable: true })
  error!: string | null;

  @CreateDateColumn()
  createdAt!: Generated<Timestamp>;

  @UpdateDateColumn()
  updatedAt!: Generated<Timestamp>;

  @UpdateIdColumn()
  updateId!: Generated<string>;
}

// One row per within-video local identity (best exemplar + first observed).
@UpdatedAtTrigger('video_face_updatedAt')
@Index({ columns: ['assetId', 'identityKey'], unique: true })
@Index({ columns: ['runId'] })
@Table('video_face')
export class VideoFaceTable {
  @PrimaryGeneratedColumn()
  id!: Generated<string>;

  @ForeignKeyColumn(() => AssetTable, { onDelete: 'CASCADE', onUpdate: 'CASCADE', index: true })
  assetId!: string;

  @ForeignKeyColumn(() => VideoFaceRunTable, { onDelete: 'CASCADE', onUpdate: 'CASCADE', index: false })
  runId!: string;

  // stable within the asset across re-runs (reconcile by embedding updates in place)
  @Column({ type: 'text' })
  identityKey!: string;

  @Column({ type: 'integer' })
  firstObservedMs!: number;

  @Column({ type: 'integer' })
  lastObservedMs!: number;

  @Column({ type: 'integer' })
  sightingCount!: number;

  @Column({ type: 'integer' })
  bestFrameMs!: number;

  @Column({ type: 'real' })
  bestScore!: number;

  @Column({ type: 'integer' })
  bestSizePx!: number;

  // normalized recognition embedding of the best exemplar (JSON float array)
  @Column({ type: 'jsonb' })
  embedding!: number[];

  // single-sighting below the stricter quality bar — kept for review, flagged
  @Column({ type: 'boolean', default: false })
  flagged!: Generated<boolean>;

  // link to the published asset_face row (SET NULL when that row is deleted)
  @ForeignKeyColumn(() => AssetFaceTable, { onDelete: 'SET NULL', onUpdate: 'CASCADE', nullable: true })
  assetFaceId!: string | null;

  @CreateDateColumn()
  createdAt!: Generated<Timestamp>;

  @UpdateDateColumn()
  updatedAt!: Generated<Timestamp>;

  @UpdateIdColumn()
  updateId!: Generated<string>;
}

// One row per accepted detection (a sighting of a local identity in one decoded frame).
@Index({ columns: ['videoFaceId', 'timeMs'] })
@Index({ columns: ['runId'] })
@Table('video_face_sighting')
export class VideoFaceSightingTable {
  @PrimaryGeneratedColumn()
  id!: Generated<string>;

  @ForeignKeyColumn(() => VideoFaceTable, { onDelete: 'CASCADE', onUpdate: 'CASCADE', index: false })
  videoFaceId!: string;

  @ForeignKeyColumn(() => VideoFaceRunTable, { onDelete: 'CASCADE', onUpdate: 'CASCADE', index: false })
  runId!: string;

  // decoded presentation timestamp
  @Column({ type: 'integer' })
  timeMs!: number;

  @Column({ type: 'integer' })
  x1!: number;

  @Column({ type: 'integer' })
  y1!: number;

  @Column({ type: 'integer' })
  x2!: number;

  @Column({ type: 'integer' })
  y2!: number;

  @Column({ type: 'integer' })
  imageWidth!: number;

  @Column({ type: 'integer' })
  imageHeight!: number;

  @Column({ type: 'real' })
  score!: number;

  @Column({ type: 'real', nullable: true })
  quality!: number | null;

  @CreateDateColumn()
  createdAt!: Generated<Timestamp>;

  @UpdateIdColumn()
  updateId!: Generated<string>;
}
