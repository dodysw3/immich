import { Injectable } from '@nestjs/common';
import { Insertable, Kysely } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import { DummyValue, GenerateSql } from 'src/decorators';
import { DB } from 'src/schema';
import { PdfPageTable } from 'src/schema/tables/pdf-page.table';
import { PdfPageOcrTable } from 'src/schema/tables/pdf-page-ocr.table';

@Injectable()
export class PdfPageRepository {
  constructor(@InjectKysely() private db: Kysely<DB>) {}

  @GenerateSql({ params: [DummyValue.UUID] })
  getByAssetId(assetId: string) {
    return this.db
      .selectFrom('pdf_page')
      .selectAll('pdf_page')
      .where('pdf_page.assetId', '=', assetId)
      .orderBy('pdf_page.pageNumber', 'asc')
      .execute();
  }

  @GenerateSql({ params: [DummyValue.UUID] })
  getById(pageId: string) {
    return this.db
      .selectFrom('pdf_page')
      .selectAll('pdf_page')
      .where('pdf_page.id', '=', pageId)
      .executeTakeFirst();
  }

  @GenerateSql({ params: [DummyValue.UUID, DummyValue.NUMBER] })
  getByAssetIdAndPageNumber(assetId: string, pageNumber: number) {
    return this.db
      .selectFrom('pdf_page')
      .selectAll('pdf_page')
      .where('pdf_page.assetId', '=', assetId)
      .where('pdf_page.pageNumber', '=', pageNumber)
      .executeTakeFirst();
  }

  @GenerateSql({
    params: [
      {
        assetId: DummyValue.UUID,
        pageNumber: DummyValue.NUMBER,
        width: DummyValue.NUMBER,
        height: DummyValue.NUMBER,
        textContent: DummyValue.STRING,
        thumbnailPath: DummyValue.STRING,
        searchableText: DummyValue.STRING,
      },
    ],
  })
  create(page: Insertable<PdfPageTable>) {
    return this.db.insertInto('pdf_page').values(page).returningAll().executeTakeFirstOrThrow();
  }

  @GenerateSql({ params: [DummyValue.UUID] })
  deleteByAssetId(assetId: string) {
    return this.db.deleteFrom('pdf_page').where('assetId', '=', assetId).execute();
  }

  @GenerateSql({ params: [DummyValue.UUID] })
  delete(pageId: string) {
    return this.db.deleteFrom('pdf_page').where('id', '=', pageId).execute();
  }

  @GenerateSql({
    params: [
      DummyValue.UUID,
      {
        textContent: DummyValue.STRING,
        searchableText: DummyValue.STRING,
      },
    ],
  })
  update(pageId: string, updates: Partial<Insertable<PdfPageTable>>) {
    return this.db.updateTable('pdf_page').set(updates).where('id', '=', pageId).execute();
  }

  @GenerateSql({
    params: [
      {
        pdfPageId: DummyValue.UUID,
        pageNumber: DummyValue.NUMBER,
        x1: DummyValue.NUMBER,
        y1: DummyValue.NUMBER,
        x2: DummyValue.NUMBER,
        y2: DummyValue.NUMBER,
        x3: DummyValue.NUMBER,
        y3: DummyValue.NUMBER,
        x4: DummyValue.NUMBER,
        y4: DummyValue.NUMBER,
        text: DummyValue.STRING,
        confidence: DummyValue.NUMBER,
      },
    ],
  })
  createOcr(ocrData: Insertable<PdfPageOcrTable>) {
    return this.db.insertInto('pdf_page_ocr').values(ocrData).execute();
  }

  @GenerateSql({ params: [DummyValue.UUID] })
  getOcrByPageId(pageId: string) {
    return this.db
      .selectFrom('pdf_page_ocr')
      .selectAll('pdf_page_ocr')
      .where('pdf_page_ocr.pdfPageId', '=', pageId)
      .execute();
  }

  @GenerateSql({ params: [DummyValue.UUID] })
  deleteOcrByPageId(pageId: string) {
    return this.db.deleteFrom('pdf_page_ocr').where('pdfPageId', '=', pageId).execute();
  }

  @GenerateSql({ params: [DummyValue.UUID, DummyValue.STRING] })
  upsertSearchText(assetId: string, searchText: string) {
    return this.db
      .insertInto('pdf_search')
      .values({ assetId, text: searchText })
      .onConflict((oc) => oc.column('assetId').doUpdateSet((eb) => ({ text: eb.ref('excluded.text') })))
      .execute();
  }

  @GenerateSql({ params: [DummyValue.UUID] })
  deleteSearchText(assetId: string) {
    return this.db.deleteFrom('pdf_search').where('assetId', '=', assetId).execute();
  }
}
