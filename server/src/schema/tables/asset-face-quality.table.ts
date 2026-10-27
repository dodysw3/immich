import { Column, ForeignKeyColumn, Table } from '@immich/sql-tools';
import { AssetFaceTable } from 'src/schema/tables/asset-face.table.js';

// Fork-owned quality signals for a detected face, kept off asset_face so that writing them
// neither bumps the face's sync updateId (clients would re-download unchanged faces) nor
// touches an upstream table.
@Table({ name: 'asset_face_quality' })
export class AssetFaceQualityTable {
  @ForeignKeyColumn(() => AssetFaceTable, { onDelete: 'CASCADE', primary: true })
  faceId!: string;

  // Detector score when the face was re-checked on a standard crop around it at detection time.
  @Column({ type: 'real' })
  verifyScore!: number;
}
