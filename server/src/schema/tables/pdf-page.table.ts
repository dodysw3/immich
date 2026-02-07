import { AssetTable } from 'src/schema/tables/asset.table';
import { Column, ForeignKeyColumn, Generated, PrimaryGeneratedColumn, Table, Unique } from 'src/sql-tools';

@Table('pdf_page')
@Unique({ columns: ['assetId', 'pageNumber'] })
export class PdfPageTable {
  @PrimaryGeneratedColumn()
  id!: Generated<string>;

  @ForeignKeyColumn(() => AssetTable, { onDelete: 'CASCADE', onUpdate: 'CASCADE' })
  assetId!: string;

  @Column({ type: 'integer' })
  pageNumber!: number;

  @Column({ type: 'text', default: '' })
  text!: Generated<string>;

  @Column({ type: 'text', default: 'embedded' })
  textSource!: Generated<string>;

  @Column({ type: 'real', nullable: true })
  width!: number | null;

  @Column({ type: 'real', nullable: true })
  height!: number | null;
}
