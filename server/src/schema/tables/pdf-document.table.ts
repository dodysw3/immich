import {
  Column,
  CreateDateColumn,
  ForeignKeyColumn,
  type Generated,
  Table,
  type Timestamp,
  UpdateDateColumn,
} from '@immich/sql-tools';
import { AssetTable } from 'src/schema/tables/asset.table.js';

export type PdfDocumentStatus = 'pending' | 'processing' | 'ready' | 'failed';

@Table('pdf_document')
export class PdfDocumentTable {
  @ForeignKeyColumn(() => AssetTable, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
    primary: true,
  })
  assetId!: string;

  @Column({ type: 'integer', default: 0 })
  pageCount!: number;

  @Column({ type: 'text', nullable: true })
  title!: string | null;

  @Column({ type: 'text', nullable: true })
  author!: string | null;

  @Column({ type: 'text', nullable: true })
  subject!: string | null;

  @Column({ type: 'text', nullable: true })
  creator!: string | null;

  @Column({ type: 'text', nullable: true })
  producer!: string | null;

  @Column({ type: 'timestamp with time zone', nullable: true })
  creationDate!: Timestamp | null;

  @Column({ type: 'timestamp with time zone', nullable: true })
  processedAt!: Timestamp | null;

  @Column({ type: 'text', default: 'pending' })
  status!: PdfDocumentStatus;

  @Column({ type: 'text', nullable: true })
  lastError!: string | null;

  @CreateDateColumn()
  createdAt!: Generated<Timestamp>;

  @UpdateDateColumn()
  updatedAt!: Generated<Timestamp>;
}
