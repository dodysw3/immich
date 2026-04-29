from __future__ import annotations

import psycopg2


def write_direct_db(db_url: str, asset_id: str, lines: list[dict], search_text: str) -> None:
    conn = psycopg2.connect(db_url)
    try:
        with conn.cursor() as cur:
            cur.execute('DELETE FROM asset_ocr WHERE "assetId" = %s', (asset_id,))

            if lines:
                values = [
                    (
                        asset_id,
                        line["x1"],
                        line["y1"],
                        line["x2"],
                        line["y2"],
                        line["x3"],
                        line["y3"],
                        line["x4"],
                        line["y4"],
                        line["boxScore"],
                        line["textScore"],
                        line["text"],
                        True,
                    )
                    for line in lines
                ]
                cur.executemany(
                    '''
                    INSERT INTO asset_ocr
                      ("assetId", x1, y1, x2, y2, x3, y3, x4, y4, "boxScore", "textScore", text, "isVisible")
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    ''',
                    values,
                )

                cur.execute(
                    '''
                    INSERT INTO ocr_search ("assetId", text)
                    VALUES (%s, %s)
                    ON CONFLICT ("assetId") DO UPDATE SET text = EXCLUDED.text
                    ''',
                    (asset_id, search_text),
                )
            else:
                cur.execute('DELETE FROM ocr_search WHERE "assetId" = %s', (asset_id,))

            cur.execute(
                '''
                INSERT INTO asset_job_status ("assetId", "ocrAt")
                VALUES (%s, NOW())
                ON CONFLICT ("assetId") DO UPDATE SET "ocrAt" = EXCLUDED."ocrAt"
                ''',
                (asset_id,),
            )

        conn.commit()
    finally:
        conn.close()
