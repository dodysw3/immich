import { Column, ForeignKeyColumn, Generated, PrimaryGeneratedColumn, Table } from 'src/sql-tools';
import { PdfPageTable } from 'src/schema/tables/pdf-page.table';

@Table('pdf_page_ocr')
export class PdfPageOcrTable {
  @PrimaryGeneratedColumn()
  id!: Generated<string>;

  @ForeignKeyColumn(() => PdfPageTable, { onDelete: 'CASCADE', onUpdate: 'CASCADE' })
  pdfPageId!: string;

  @Column({ type: 'integer' })
  pageNumber!: number;

  @Column({ type: 'real' })
  x1!: number;

  @Column({ type: 'real' })
  y1!: number;

  @Column({ type: 'real' })
  x2!: number;

  @Column({ type: 'real' })
  y2!: number;

  @Column({ type: 'real' })
  x3!: number;

  @Column({ type: 'real' })
  y3!: number;

  @Column({ type: 'real' })
  x4!: number;

  @Column({ type: 'real' })
  y4!: number;

  @Column({ type: 'text' })
  text!: string;

  @Column({ type: 'real' })
  confidence!: number;
}
