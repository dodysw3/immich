import { Injectable } from '@nestjs/common';
import { Insertable, Kysely } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import { DummyValue, GenerateSql } from 'src/decorators';
import { DB } from 'src/schema';
import { PdfAssetTable } from 'src/schema/tables/pdf-asset.table';

@Injectable()
export class PdfRepository {
  constructor(@InjectKysely() private db: Kysely<DB>) {}

  @GenerateSql({ params: [DummyValue.UUID] })
  getByAssetId(assetId: string) {
    return this.db
      .selectFrom('pdf_asset')
      .selectAll('pdf_asset')
      .where('pdf_asset.assetId', '=', assetId)
      .executeTakeFirst();
  }

  @GenerateSql({ params: [DummyValue.UUID] })
  delete(assetId: string) {
    return this.db.deleteFrom('pdf_asset').where('assetId', '=', assetId).execute();
  }

  @GenerateSql({
    params: [
      {
        assetId: DummyValue.UUID,
        pageCount: DummyValue.NUMBER,
        fileSizeInByte: DummyValue.NUMBER,
        hasText: DummyValue.BOOLEAN,
        isOCRProcessed: DummyValue.BOOLEAN,
        author: DummyValue.STRING,
        title: DummyValue.STRING,
        subject: DummyValue.STRING,
        keywords: DummyValue.STRING,
        creator: DummyValue.STRING,
        producer: DummyValue.STRING,
      },
    ],
  })
  create(pdfAsset: Insertable<PdfAssetTable>) {
    return this.db.insertInto('pdf_asset').values(pdfAsset).execute();
  }

  @GenerateSql({
    params: [
      DummyValue.UUID,
      {
        pageCount: DummyValue.NUMBER,
        hasText: DummyValue.BOOLEAN,
        isOCRProcessed: DummyValue.BOOLEAN,
      },
    ],
  })
  update(assetId: string, updates: Partial<Insertable<PdfAssetTable>>) {
    return this.db.updateTable('pdf_asset').set(updates).where('assetId', '=', assetId).execute();
  }

  @GenerateSql()
  getAll() {
    return this.db.selectFrom('pdf_asset').selectAll('pdf_asset').execute();
  }
}
