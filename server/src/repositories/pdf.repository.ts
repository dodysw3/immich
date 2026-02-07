import { Injectable } from '@nestjs/common';
import { Insertable, Kysely, sql } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import { DummyValue, GenerateSql } from 'src/decorators';
import { DB } from 'src/schema';
import { PdfDocumentTable } from 'src/schema/tables/pdf-document.table';
import { PdfPageTable } from 'src/schema/tables/pdf-page.table';

@Injectable()
export class PdfRepository {
  constructor(@InjectKysely() private db: Kysely<DB>) {}

  @GenerateSql({ params: [DummyValue.UUID] })
  getDocumentByAssetId(assetId: string) {
    return this.db
      .selectFrom('pdf_document')
      .selectAll('pdf_document')
      .where('pdf_document.assetId', '=', assetId)
      .executeTakeFirst();
  }

  upsertDocument(data: Insertable<PdfDocumentTable>) {
    return this.db
      .insertInto('pdf_document')
      .values(data)
      .onConflict((oc) =>
        oc.column('assetId').doUpdateSet((eb) => ({
          pageCount: eb.ref('excluded.pageCount'),
          title: eb.ref('excluded.title'),
          author: eb.ref('excluded.author'),
          subject: eb.ref('excluded.subject'),
          creator: eb.ref('excluded.creator'),
          producer: eb.ref('excluded.producer'),
          creationDate: eb.ref('excluded.creationDate'),
          processedAt: eb.ref('excluded.processedAt'),
        })),
      )
      .execute();
  }

  upsertPages(pages: Insertable<PdfPageTable>[]) {
    if (pages.length === 0) {
      return;
    }

    return this.db
      .insertInto('pdf_page')
      .values(pages)
      .onConflict((oc) =>
        oc.columns(['assetId', 'pageNumber']).doUpdateSet((eb) => ({
          text: eb.ref('excluded.text'),
          textSource: eb.ref('excluded.textSource'),
          width: eb.ref('excluded.width'),
          height: eb.ref('excluded.height'),
        })),
      )
      .execute();
  }

  @GenerateSql({ params: [DummyValue.UUID] })
  getPagesByAssetId(assetId: string) {
    return this.db
      .selectFrom('pdf_page')
      .selectAll('pdf_page')
      .where('pdf_page.assetId', '=', assetId)
      .orderBy('pdf_page.pageNumber', 'asc')
      .execute();
  }

  @GenerateSql({ params: [DummyValue.UUID, DummyValue.NUMBER] })
  getPage(assetId: string, pageNumber: number) {
    return this.db
      .selectFrom('pdf_page')
      .selectAll('pdf_page')
      .where('pdf_page.assetId', '=', assetId)
      .where('pdf_page.pageNumber', '=', pageNumber)
      .executeTakeFirst();
  }

  upsertSearch(assetId: string, text: string) {
    return this.db
      .insertInto('pdf_search')
      .values({ assetId, text })
      .onConflict((oc) => oc.column('assetId').doUpdateSet((eb) => ({ text: eb.ref('excluded.text') })))
      .execute();
  }

  @GenerateSql({ params: [DummyValue.STRING] })
  search(query: string) {
    return this.db
      .selectFrom('pdf_search')
      .innerJoin('pdf_document', 'pdf_document.assetId', 'pdf_search.assetId')
      .innerJoin('asset', 'asset.id', 'pdf_search.assetId')
      .select([
        'pdf_search.assetId',
        'pdf_document.title',
        'pdf_document.pageCount',
        'asset.originalFileName',
        'asset.ownerId',
      ])
      .where(sql`f_unaccent(pdf_search.text)`, 'ilike', sql`'%' || f_unaccent(${query}) || '%'`)
      .execute();
  }

  @GenerateSql({ params: [DummyValue.UUID] })
  getDocumentsByOwnerId(ownerId: string) {
    return this.db
      .selectFrom('pdf_document')
      .innerJoin('asset', 'asset.id', 'pdf_document.assetId')
      .select([
        'pdf_document.assetId',
        'pdf_document.pageCount',
        'pdf_document.title',
        'pdf_document.author',
        'pdf_document.processedAt',
        'asset.originalFileName',
        'asset.createdAt',
      ])
      .where('asset.ownerId', '=', ownerId)
      .where('asset.deletedAt', 'is', null)
      .orderBy('asset.createdAt', 'desc')
      .execute();
  }

  deleteByAssetId(assetId: string) {
    return this.db.deleteFrom('pdf_document').where('assetId', '=', assetId).execute();
  }

  @GenerateSql({ params: [DummyValue.STRING, DummyValue.UUID] })
  searchByOwner(query: string, ownerId: string) {
    return this.db
      .selectFrom('pdf_search')
      .innerJoin('pdf_document', 'pdf_document.assetId', 'pdf_search.assetId')
      .innerJoin('asset', 'asset.id', 'pdf_search.assetId')
      .select([
        'pdf_search.assetId',
        'pdf_document.title',
        'pdf_document.pageCount',
        'asset.originalFileName',
      ])
      .where('asset.ownerId', '=', ownerId)
      .where('asset.deletedAt', 'is', null)
      .where(sql`f_unaccent(pdf_search.text)`, 'ilike', sql`'%' || f_unaccent(${query}) || '%'`)
      .execute();
  }
}
