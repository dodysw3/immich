import { AssetTable } from 'src/schema/tables/asset.table';
import {
  Column,
  CreateDateColumn,
  ForeignKeyColumn,
  Generated,
  PrimaryGeneratedColumn,
  Table,
  Timestamp,
} from 'src/sql-tools';

@Table('pdf_page')
export class PdfPageTable {
  @PrimaryGeneratedColumn()
  id!: Generated<string>;

  @ForeignKeyColumn(() => AssetTable, { onDelete: 'CASCADE', onUpdate: 'CASCADE' })
  assetId!: string;

  @Column({ type: 'integer' })
  pageNumber!: number;

  @Column({ type: 'integer', nullable: true })
  width!: number | null;

  @Column({ type: 'integer', nullable: true })
  height!: number | null;

  @Column({ type: 'text', nullable: true })
  textContent!: string | null;

  @Column({ type: 'text' })
  thumbnailPath!: string;

  @Column({ type: 'text' })
  searchableText!: string;

  @CreateDateColumn()
  createdAt!: Generated<Timestamp>;
}
