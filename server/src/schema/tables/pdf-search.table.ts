import { AssetTable } from 'src/schema/tables/asset.table';
import { Column, ForeignKeyColumn, Index, Table } from 'src/sql-tools';

@Table('pdf_search')
@Index({
  name: 'idx_pdf_search_text',
  using: 'gin',
  expression: 'f_unaccent("text") gin_trgm_ops',
})
export class PdfSearchTable {
  @ForeignKeyColumn(() => AssetTable, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
    primary: true,
  })
  assetId!: string;

  @Column({ type: 'text' })
  text!: string;
}
