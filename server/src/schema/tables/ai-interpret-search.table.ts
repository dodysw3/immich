import { Column, ForeignKeyColumn, type Generated, Index, Table, Timestamp, UpdateDateColumn } from '@immich/sql-tools';
import { AssetTable } from 'src/schema/tables/asset.table.js';

@Table('ai_interpret_search')
@Index({
  name: 'ai_interpret_index',
  using: 'hnsw',
  expression: `embedding vector_cosine_ops`,
  with: `ef_construction = 300, m = 16`,
  synchronize: false,
})
@Index({
  name: 'idx_ai_interpret_search_text',
  using: 'gin',
  expression: 'f_unaccent("text") gin_trgm_ops',
})
export class AiInterpretSearchTable {
  @ForeignKeyColumn(() => AssetTable, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
    primary: true,
  })
  assetId!: string;

  @Column({ type: 'text' })
  text!: string;

  @Column({ type: 'vector', length: 1024, storage: 'external', synchronize: false })
  embedding!: string;

  /** run key of the interpretation run this row was built from (staleness marker) */
  @Column({ type: 'text' })
  runKey!: string;

  /** identity of the embedding model that produced the vector (staleness marker) */
  @Column({ type: 'text' })
  model!: string;

  @UpdateDateColumn()
  updatedAt!: Generated<Timestamp>;
}
