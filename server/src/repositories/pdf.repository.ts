import { Injectable } from '@nestjs/common';
import { Insertable, Kysely, Selectable, sql } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import { DummyValue, GenerateSql } from 'src/decorators';
import { AssetType } from 'src/enum';
import { DB } from 'src/schema';
import { PdfDocumentTable } from 'src/schema/tables/pdf-document.table';
import { PdfPageTable } from 'src/schema/tables/pdf-page.table';
import { paginationHelper } from 'src/utils/pagination';

type PdfDocumentRow = Selectable<PdfDocumentTable>;
type PdfPageRow = Selectable<PdfPageTable>;

@Injectable()
export class PdfRepository {
  constructor(@InjectKysely() private db: Kysely<DB>) {}

  @GenerateSql({ params: [DummyValue.UUID] })
  getAssetForProcessing(id: string) {
    return this.db
      .selectFrom('asset')
      .select(['asset.id', 'asset.ownerId', 'asset.originalPath', 'asset.originalFileName', 'asset.type', 'asset.deletedAt'])
      .where('asset.id', '=', id)
      .executeTakeFirst();
  }

  @GenerateSql({ params: [false], stream: true })
  streamPdfAssetIds(force?: boolean) {
    return this.db
      .selectFrom('asset')
      .leftJoin('pdf_document', 'pdf_document.assetId', 'asset.id')
      .select('asset.id')
      .where('asset.type', '=', AssetType.Other)
      .where('asset.deletedAt', 'is', null)
      .where(sql<boolean>`lower("asset"."originalFileName") like '%.pdf'`)
      .$if(!force, (qb) => qb.where('pdf_document.assetId', 'is', null))
      .stream();
  }

  @GenerateSql({
    params: [
      {
        assetId: DummyValue.UUID,
        pageCount: DummyValue.NUMBER,
        title: DummyValue.STRING,
        author: DummyValue.STRING,
        subject: DummyValue.STRING,
        creator: DummyValue.STRING,
        producer: DummyValue.STRING,
        creationDate: DummyValue.DATE,
        processedAt: DummyValue.DATE,
      },
    ],
  })
  upsertDocument(input: Insertable<PdfDocumentTable>) {
    return this.db
      .insertInto('pdf_document')
      .values(input)
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
      .executeTakeFirst();
  }

  @GenerateSql({ params: [DummyValue.UUID, [{ pageNumber: DummyValue.NUMBER, text: DummyValue.STRING }]] })
  replacePages(assetId: string, pages: Array<Insertable<PdfPageTable>>) {
    return this.db.transaction().execute(async (trx) => {
      await trx.deleteFrom('pdf_page').where('assetId', '=', assetId).execute();
      if (pages.length > 0) {
        await trx.insertInto('pdf_page').values(pages).execute();
      }
    });
  }

  @GenerateSql({ params: [DummyValue.UUID, DummyValue.STRING] })
  upsertSearch(assetId: string, text: string) {
    return this.db
      .insertInto('pdf_search')
      .values({ assetId, text })
      .onConflict((oc) => oc.column('assetId').doUpdateSet((eb) => ({ text: eb.ref('excluded.text') })))
      .executeTakeFirst();
  }

  @GenerateSql({ params: [DummyValue.UUID, { page: 1, size: 50 }] })
  async getDocumentsByOwner(ownerId: string, pagination: { page: number; size: number }) {
    const items = await this.db
      .selectFrom('asset')
      .leftJoin('pdf_document', 'pdf_document.assetId', 'asset.id')
      .select([
        'asset.id as assetId',
        'asset.originalFileName',
        'asset.createdAt',
        'pdf_document.pageCount',
        'pdf_document.title',
        'pdf_document.author',
        'pdf_document.processedAt',
      ])
      .where('asset.ownerId', '=', ownerId)
      .where('asset.type', '=', AssetType.Other)
      .where('asset.deletedAt', 'is', null)
      .where(sql<boolean>`lower("asset"."originalFileName") like '%.pdf'`)
      .orderBy('asset.fileCreatedAt', 'desc')
      .limit(pagination.size + 1)
      .offset((pagination.page - 1) * pagination.size)
      .execute();

    return paginationHelper(items, pagination.size);
  }

  @GenerateSql({ params: [DummyValue.UUID, DummyValue.UUID] })
  getDocumentByOwner(ownerId: string, assetId: string) {
    return this.db
      .selectFrom('asset')
      .leftJoin('pdf_document', 'pdf_document.assetId', 'asset.id')
      .select([
        'asset.id as assetId',
        'asset.originalFileName',
        'asset.createdAt',
        'pdf_document.pageCount',
        'pdf_document.title',
        'pdf_document.author',
        'pdf_document.processedAt',
      ])
      .where('asset.ownerId', '=', ownerId)
      .where('asset.id', '=', assetId)
      .where('asset.deletedAt', 'is', null)
      .where(sql<boolean>`lower("asset"."originalFileName") like '%.pdf'`)
      .executeTakeFirst();
  }

  @GenerateSql({ params: [DummyValue.UUID, DummyValue.UUID] })
  getPagesByOwner(ownerId: string, assetId: string): Promise<PdfPageRow[]> {
    return this.db
      .selectFrom('pdf_page')
      .innerJoin('asset', 'asset.id', 'pdf_page.assetId')
      .selectAll('pdf_page')
      .where('asset.ownerId', '=', ownerId)
      .where('asset.id', '=', assetId)
      .orderBy('pdf_page.pageNumber', 'asc')
      .execute();
  }

  @GenerateSql({ params: [DummyValue.UUID, DummyValue.UUID, 1] })
  getPageByOwner(ownerId: string, assetId: string, pageNumber: number): Promise<PdfPageRow | undefined> {
    return this.db
      .selectFrom('pdf_page')
      .innerJoin('asset', 'asset.id', 'pdf_page.assetId')
      .selectAll('pdf_page')
      .where('asset.ownerId', '=', ownerId)
      .where('asset.id', '=', assetId)
      .where('pdf_page.pageNumber', '=', pageNumber)
      .executeTakeFirst();
  }

  @GenerateSql({ params: [DummyValue.UUID, DummyValue.STRING, { page: 1, size: 50 }] })
  async searchByText(ownerId: string, query: string, pagination: { page: number; size: number }) {
    const items = await this.db
      .selectFrom('pdf_search')
      .innerJoin('asset', 'asset.id', 'pdf_search.assetId')
      .leftJoin('pdf_document', 'pdf_document.assetId', 'asset.id')
      .select([
        'asset.id as assetId',
        'asset.originalFileName',
        'asset.createdAt',
        'pdf_document.pageCount',
        'pdf_document.title',
        'pdf_document.author',
        'pdf_document.processedAt',
      ])
      .where('asset.ownerId', '=', ownerId)
      .where('asset.deletedAt', 'is', null)
      .where(sql<boolean>`f_unaccent("pdf_search"."text") %>> f_unaccent(${query})`)
      .orderBy('asset.fileCreatedAt', 'desc')
      .limit(pagination.size + 1)
      .offset((pagination.page - 1) * pagination.size)
      .execute();

    return paginationHelper(items, pagination.size);
  }

  @GenerateSql({ params: [DummyValue.UUID, DummyValue.STRING] })
  getMatchingPages(assetId: string, query: string): Promise<Array<{ pageNumber: number }>> {
    return this.db
      .selectFrom('pdf_page')
      .select(['pageNumber'])
      .where('assetId', '=', assetId)
      .where(sql<boolean>`f_unaccent("pdf_page"."text") %>> f_unaccent(${query})`)
      .orderBy('pageNumber', 'asc')
      .execute();
  }

  @GenerateSql({ params: [DummyValue.UUID, DummyValue.UUID, DummyValue.STRING] })
  searchPagesByOwner(ownerId: string, assetId: string, query: string): Promise<Array<{ pageNumber: number; text: string }>> {
    return this.db
      .selectFrom('pdf_page')
      .innerJoin('asset', 'asset.id', 'pdf_page.assetId')
      .select(['pdf_page.pageNumber', 'pdf_page.text'])
      .where('asset.ownerId', '=', ownerId)
      .where('asset.id', '=', assetId)
      .where(sql<boolean>`f_unaccent("pdf_page"."text") %>> f_unaccent(${query})`)
      .orderBy('pdf_page.pageNumber', 'asc')
      .execute();
  }

  isPdfAsset(row: { originalPath: string; originalFileName: string; type: AssetType }) {
    return row.type === AssetType.Other && row.originalFileName.toLowerCase().endsWith('.pdf');
  }

  emptyDocument(): PdfDocumentRow {
    return {
      assetId: '',
      pageCount: 0,
      title: null,
      author: null,
      subject: null,
      creator: null,
      producer: null,
      creationDate: null,
      processedAt: null,
      createdAt: new Date(),
      updatedAt: new Date(),
    };
  }
}
