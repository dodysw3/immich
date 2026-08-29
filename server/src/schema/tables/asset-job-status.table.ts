import { AfterUpdateTrigger, Column, ForeignKeyColumn, Table, Timestamp } from '@immich/sql-tools';
import { notify_ocr_complete } from 'src/schema/functions';
import { AssetTable } from 'src/schema/tables/asset.table';

@Table('asset_job_status')
@AfterUpdateTrigger({ name: 'trg_ocr_complete', scope: 'row', function: notify_ocr_complete })
export class AssetJobStatusTable {
  @ForeignKeyColumn(() => AssetTable, { onDelete: 'CASCADE', onUpdate: 'CASCADE', primary: true })
  assetId!: string;

  @Column({ type: 'timestamp with time zone', nullable: true })
  facesRecognizedAt!: Timestamp | null;

  @Column({ type: 'timestamp with time zone', nullable: true })
  metadataExtractedAt!: Timestamp | null;

  @Column({ type: 'timestamp with time zone', nullable: true })
  duplicatesDetectedAt!: Timestamp | null;

  @Column({ type: 'timestamp with time zone', nullable: true })
  ocrAt!: Timestamp | null;
}
