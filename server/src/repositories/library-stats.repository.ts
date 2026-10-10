import { Injectable } from '@nestjs/common';
import { type Kysely, RawBuilder, sql } from 'kysely';
import { InjectKysely } from 'nestjs-kysely';
import { DB } from 'src/schema/index.js';

export type LabelCount = { label: string; count: number };
export type Quantiles = { p50: number | null; p95: number | null; assets: number };
export type AssetCounts = { photo: number; video: number; pdf: number; total: number; unlocated: number };
export type PersonCounts = { total: number; labeled: number; hidden: number };
export type FaceCounts = { assigned: number; unassigned: number };
export type OcrCounts = { visible: number; hidden: number };

const TOP = 50;

@Injectable()
export class LibraryStatsRepository {
  constructor(@InjectKysely() private db: Kysely<DB>) {}

  private rows<O>(query: RawBuilder<O>): Promise<O[]> {
    return query.execute(this.db).then((result) => result.rows);
  }

  async getAssetCounts(): Promise<AssetCounts> {
    const [typeRows, pdfRows, unlocatedRows] = await Promise.all([
      this.rows(
        sql<{
          type: string;
          count: number;
        }>`select type, count(*)::int as count from asset where "deletedAt" is null group by type`,
      ),
      this.rows(sql<{ count: number }>`select count(*)::int as count from pdf_document`),
      this.rows(sql<{ count: number }>`
        select count(*)::int as count from asset a
        left join asset_exif e on e."assetId" = a.id
        where a."deletedAt" is null and coalesce(e.city, '') = ''
      `),
    ]);

    const photo = Number(typeRows.find((row) => row.type === 'IMAGE')?.count ?? 0);
    const video = Number(typeRows.find((row) => row.type === 'VIDEO')?.count ?? 0);
    const pdf = Number(pdfRows[0]?.count ?? 0);
    const total = typeRows.reduce((sum, row) => sum + Number(row.count), 0);

    return {
      photo,
      video,
      pdf,
      total,
      unlocated: Number(unlocatedRows[0]?.count ?? 0),
    };
  }

  async getPersonCounts(): Promise<PersonCounts> {
    const rows = await this.rows(sql<{ total: number; labeled: number; hidden: number }>`
      select
        (select count(*)::int from person_group) as total,
        (select count(distinct "personGroupId")::int from person where name != '') as labeled,
        (select count(distinct "personGroupId")::int from person where "isHidden") as hidden
    `);

    return rows[0] ?? { total: 0, labeled: 0, hidden: 0 };
  }

  async getFaceCounts(): Promise<FaceCounts> {
    const rows = await this.rows(sql<{ assigned: number; unassigned: number }>`
      select
        coalesce(sum(case when "personGroupId" is not null then 1 else 0 end), 0)::int as assigned,
        coalesce(sum(case when "personGroupId" is null then 1 else 0 end), 0)::int as unassigned
      from asset_face
      where "deletedAt" is null and "isVisible" is true
    `);

    return rows[0] ?? { assigned: 0, unassigned: 0 };
  }

  async getFacesPerPhoto(): Promise<Quantiles> {
    const rows = await this.rows(sql<Quantiles>`
      with per_asset as (
        select "assetId", count(*)::int as n
        from asset_face
        where "deletedAt" is null and "isVisible" is true
        group by "assetId"
      )
      select
        percentile_cont(0.5) within group (order by n)::float as p50,
        percentile_cont(0.95) within group (order by n)::float as p95,
        count(*)::int as assets
      from per_asset
    `);

    return rows[0] ?? { p50: null, p95: null, assets: 0 };
  }

  async getOcrObjectCounts(): Promise<OcrCounts> {
    const rows = await this.rows(sql<OcrCounts>`
      select
        coalesce(sum(case when "isVisible" then 1 else 0 end), 0)::int as visible,
        coalesce(sum(case when not "isVisible" then 1 else 0 end), 0)::int as hidden
      from asset_ocr
    `);

    return rows[0] ?? { visible: 0, hidden: 0 };
  }

  async getOcrCharsPerPhoto(): Promise<Quantiles> {
    const rows = await this.rows(sql<Quantiles>`
      with per_asset as (
        select "assetId", sum(length(text))::int as chars
        from asset_ocr
        group by "assetId"
      )
      select
        percentile_cont(0.5) within group (order by chars)::float as p50,
        percentile_cont(0.95) within group (order by chars)::float as p95,
        count(*)::int as assets
      from per_asset
    `);

    return rows[0] ?? { p50: null, p95: null, assets: 0 };
  }

  getAssetCountsByTag(): Promise<LabelCount[]> {
    return this.rows(sql<LabelCount>`
      select t.value as label, count(*)::int as count
      from tag_asset ta
      join tag t on t.id = ta."tagId"
      join asset a on a.id = ta."assetId" and a."deletedAt" is null
      group by t.value
      order by count desc
      limit ${TOP}
    `);
  }

  getAssetCountsByAlbum(): Promise<LabelCount[]> {
    return this.rows(sql<LabelCount>`
      select al."albumName" as label, count(*)::int as count
      from album_asset aa
      join album al on al.id = aa."albumId"
      join asset a on a.id = aa."assetId" and a."deletedAt" is null
      group by al."albumName"
      order by count desc
      limit ${TOP}
    `);
  }

  getAssetCountsByCity(): Promise<LabelCount[]> {
    return this.rows(sql<LabelCount>`
      select e.city as label, count(*)::int as count
      from asset_exif e
      join asset a on a.id = e."assetId" and a."deletedAt" is null
      where coalesce(e.city, '') != ''
      group by e.city
      order by count desc
      limit ${TOP}
    `);
  }

  getAssetCountsByCountry(): Promise<LabelCount[]> {
    return this.rows(sql<LabelCount>`
      select e.country as label, count(*)::int as count
      from asset_exif e
      join asset a on a.id = e."assetId" and a."deletedAt" is null
      where coalesce(e.country, '') != ''
      group by e.country
      order by count desc
      limit ${TOP}
    `);
  }
}
