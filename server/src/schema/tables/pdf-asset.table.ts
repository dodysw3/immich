import { UpdatedAtTrigger } from 'src/decorators';
import { AssetTable } from 'src/schema/tables/asset.table';
import {
  AfterDeleteTrigger,
  Column,
  CreateDateColumn,
  ForeignKeyColumn,
  Generated,
  PrimaryGeneratedColumn,
  Table,
  Timestamp,
  UpdateDateColumn,
} from 'src/sql-tools';
import { asset_delete_audit } from 'src/schema/functions';

@Table('pdf_asset')
@UpdatedAtTrigger('pdf_asset_updatedAt')
@AfterDeleteTrigger({
  scope: 'statement',
  function: asset_delete_audit,
  referencingOldTableAs: 'old',
  when: 'pg_trigger_depth() = 0',
})
export class PdfAssetTable {
  @ForeignKeyColumn(() => AssetTable, {
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE',
    primary: true,
  })
  assetId!: string;

  @Column({ type: 'integer' })
  pageCount!: number;

  @Column({ type: 'boolean', default: false })
  hasText!: Generated<boolean>;

  @Column({ type: 'boolean', default: false })
  isOCRProcessed!: Generated<boolean>;

  @Column({ type: 'bigint' })
  fileSizeInByte!: number;

  @Column({ type: 'text', nullable: true })
  author!: string | null;

  @Column({ type: 'text', nullable: true })
  title!: string | null;

  @Column({ type: 'text', nullable: true })
  subject!: string | null;

  @Column({ type: 'text', nullable: true })
  keywords!: string | null;

  @Column({ type: 'text', nullable: true })
  creator!: string | null;

  @Column({ type: 'text', nullable: true })
  producer!: string | null;

  @CreateDateColumn()
  createdAt!: Generated<Timestamp>;

  @UpdateDateColumn()
  updatedAt!: Generated<Timestamp>;
}
