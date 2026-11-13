import { Column, ForeignKeyColumn, Table, Timestamp, UpdateDateColumn, type Generated } from '@immich/sql-tools';
import { AssetTable } from 'src/schema/tables/asset.table.js';

/**
Per-video transcript search-index state (one row per video that has been
indexed). Reconciliation compares `revision` (content hash of the selected
source run) and `indexVersion` against the live transcript document to find
missing or stale rows. Derived data — the source transcript in
`asset_metadata` (`video-transcripts-v1`) is never touched here.
*/
@Table('transcript_index_state')
export class TranscriptIndexStateTable {
  @ForeignKeyColumn(() => AssetTable, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
    primary: true,
  })
  assetId!: string;

  /** Content revision (sha256) of the source transcript this index reflects. */
  @Column({ type: 'text' })
  revision!: string;

  /** runKey of the selected source run (retries reuse runKeys; revisions do not). */
  @Column({ type: 'text' })
  runKey!: string;

  /** Index format version; a bump forces re-indexing of every row. */
  @Column({ type: 'integer' })
  indexVersion!: number;

  /** Coverage classification of the source run: complete | partial | no-audio | no-speech. */
  @Column({ type: 'text' })
  coverageState!: string;

  @Column({ type: 'integer' })
  segmentCount!: number;

  @Column({ type: 'integer' })
  passageCount!: number;

  /** Last sync error; current rows have none. */
  @Column({ type: 'text', nullable: true })
  error!: string | null;

  @UpdateDateColumn()
  updatedAt!: Generated<Timestamp>;
}
