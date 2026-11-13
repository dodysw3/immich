import { Column, ForeignKeyColumn, Index, Table } from '@immich/sql-tools';
import { TranscriptPassageTable } from 'src/schema/tables/transcript-passage.table.js';

/**
Distinct normalized token per passage — the trigram candidate pool for
spelling-fallback matching. Comparing query tokens against this (short) table
instead of whole transcripts keeps fuzzy retrieval bounded; exact matching
never touches it.
*/
@Table('transcript_passage_token')
@Index({
  name: 'idx_transcript_passage_token_trgm',
  using: 'gin',
  expression: '"token" gin_trgm_ops',
  synchronize: false,
})
export class TranscriptPassageTokenTable {
  @ForeignKeyColumn(() => TranscriptPassageTable, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
    primary: true,
  })
  passageId!: string;

  /** Normalized token text (distinct per passage). */
  @Column({ type: 'text', primary: true })
  token!: string;
}
