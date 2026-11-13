import { Column, ForeignKeyColumn, Index, Table, Timestamp, UpdateDateColumn, type Generated } from '@immich/sql-tools';
import { PrimaryGeneratedUuidV7Column } from 'src/decorators.js';
import { AssetTable } from 'src/schema/tables/asset.table.js';

/**
One timestamped passage (a segment or a bounded adjacent-segment window) of a
video transcript, searchable by exact tokens. All passages for one asset
share the source transcript's content `revision`; replacement replaces the
asset's rows transactionally so reads never mix revisions. The GIN full-text
index uses the `simple` configuration (language-neutral tokens, no stemming).
*/
@Table('transcript_passage')
@Index({
  name: 'idx_transcript_passage_fts',
  using: 'gin',
  expression: `to_tsvector('simple', "normalizedText")`,
  synchronize: false,
})
export class TranscriptPassageTable {
  @PrimaryGeneratedUuidV7Column()
  id!: Generated<string>;

  @ForeignKeyColumn(() => AssetTable, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
  })
  assetId!: string;

  /** Content revision (sha256) of the source transcript. */
  @Column({ type: 'text' })
  revision!: string;

  /** Contributing segment range id 'first:last' (window identity within the asset). */
  @Column({ type: 'text' })
  windowId!: string;

  @Column({ type: 'integer' })
  firstSegment!: number;

  @Column({ type: 'integer' })
  lastSegment!: number;

  /** Absolute video offsets (ms) of the passage. */
  @Column({ type: 'integer' })
  startMs!: number;

  @Column({ type: 'integer' })
  endMs!: number;

  /** Original transcript text of the window (display/highlight source). */
  @Column({ type: 'text' })
  text!: string;

  /** Normalized token text joined by spaces (single shared normalization policy). */
  @Column({ type: 'text' })
  normalizedText!: string;

  /** UTF-16 offsets of each contributing segment within `text`. */
  @Column({ type: 'jsonb' })
  segmentSpans!: Array<{ start: number; end: number }>;

  /** Absolute start ms of each contributing segment (match-start attribution). */
  @Column({ type: 'jsonb' })
  segmentStartsMs!: number[];

  @UpdateDateColumn()
  updatedAt!: Generated<Timestamp>;
}
