import { PdfDocumentTable } from 'src/schema/tables/pdf-document.table';
import { Column, ForeignKeyColumn, Generated, Index, PrimaryGeneratedColumn, Table } from 'src/sql-tools';

export type PdfTextSource = 'embedded' | 'ocr' | 'none';

@Index({ columns: ['assetId', 'pageNumber'], unique: true })
@Table('pdf_page')
export class PdfPageTable {
  @PrimaryGeneratedColumn()
  id!: Generated<string>;

  @ForeignKeyColumn(() => PdfDocumentTable, { onDelete: 'CASCADE', onUpdate: 'CASCADE' })
  assetId!: string;

  @Column({ type: 'integer' })
  pageNumber!: number;

  @Column({ type: 'text', default: '' })
  text!: string;

  @Column({ type: 'text', default: 'embedded' })
  textSource!: PdfTextSource;

  @Column({ type: 'real', nullable: true })
  width!: number | null;

  @Column({ type: 'real', nullable: true })
  height!: number | null;
}
