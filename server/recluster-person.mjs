import { Queue } from 'bullmq';
import pg from 'pg';

const PERSON_ID = process.argv[2];
const DISTANCE_THRESHOLD = parseFloat(process.argv[3]) || 0.45;
const DRY_RUN = process.argv.includes('--dry-run');
const UNASSIGN_ALL = process.argv.includes('--all');

if (!PERSON_ID) {
  console.error('Usage: node recluster-person.mjs <personId> [distanceThreshold] [--dry-run] [--all]');
  console.error('');
  console.error('Arguments:');
  console.error('  personId            The person ID to re-cluster');
  console.error('  distanceThreshold   Max cosine distance from feature face to keep (default: 0.45)');
  console.error('  --dry-run           Show what would happen without making changes');
  console.error('  --all               Unassign ALL faces (not just outliers)');
  console.error('');
  console.error('Examples:');
  console.error('  node recluster-person.mjs aa83df1c-b36d-4cef-af05-9a076c2c7257 0.45 --dry-run');
  console.error('  node recluster-person.mjs aa83df1c-b36d-4cef-af05-9a076c2c7257 0.45');
  console.error('  node recluster-person.mjs aa83df1c-b36d-4cef-af05-9a076c2c7257 0.0 --all');
  process.exit(1);
}

const pgPool = new pg.Pool({
  host: 'im-pg',
  port: 5432,
  database: 'immich',
  user: 'postgres',
  password: process.env.DB_PASSWORD,
});

const recognitionQueue = new Queue('facialRecognition', {
  connection: { host: 'im-r', port: 6379 },
});

async function main() {
  const client = await pgPool.connect();

  try {
    await client.query('BEGIN');

    const personRes = await client.query(
      `SELECT id, name, "faceAssetId", "ownerId" FROM person WHERE id = $1`,
      [PERSON_ID]
    );

    if (personRes.rows.length === 0) {
      console.error(`ERROR: Person ${PERSON_ID} not found`);
      process.exit(1);
    }

    const person = personRes.rows[0];
    console.log(`Person: ${person.name || '(unnamed)'} (${person.id})`);
    console.log(`Feature face: ${person.faceAssetId}`);
    console.log(`Distance threshold: ${DISTANCE_THRESHOLD}`);
    console.log(`Mode: ${UNASSIGN_ALL ? 'UNASSIGN ALL' : 'UNASSIGN OUTLIERS ONLY'}`);
    console.log(`Dry run: ${DRY_RUN}`);
    console.log('');

    const totalRes = await client.query(
      `SELECT COUNT(*) as cnt FROM asset_face WHERE "personId" = $1 AND "deletedAt" IS NULL`,
      [PERSON_ID]
    );
    const totalFaces = parseInt(totalRes.rows[0].cnt);
    console.log(`Total assigned faces: ${totalFaces}`);

    let faceIdsToUnassign;

    if (UNASSIGN_ALL) {
      const res = await client.query(
        `SELECT af.id FROM asset_face af WHERE af."personId" = $1 AND af."deletedAt" IS NULL`,
        [PERSON_ID]
      );
      faceIdsToUnassign = res.rows.map(r => r.id);
    } else {
      const res = await client.query(
        `SELECT af.id,
          (fs.embedding <=> ff.embedding) as distance
        FROM asset_face af
        JOIN face_search fs ON fs."faceId" = af.id
        CROSS JOIN LATERAL (
          SELECT embedding FROM face_search WHERE "faceId" = $2
        ) ff
        WHERE af."personId" = $1
          AND af."deletedAt" IS NULL
          AND (fs.embedding <=> ff.embedding) > $3
        ORDER BY distance DESC`,
        [PERSON_ID, person.faceAssetId, DISTANCE_THRESHOLD]
      );
      faceIdsToUnassign = res.rows.map(r => r.id);
    }

    const keepCount = totalFaces - faceIdsToUnassign.length;
    console.log(`Faces to unassign: ${faceIdsToUnassign.length}`);
    console.log(`Faces to keep: ${keepCount}`);
    console.log('');

    if (faceIdsToUnassign.length === 0) {
      console.log('No faces to unassign. Nothing to do.');
      return;
    }

    if (DRY_RUN) {
      console.log('=== DRY RUN - no changes will be made ===');

      if (!UNASSIGN_ALL) {
        const sampleRes = await client.query(
          `SELECT af.id,
            (fs.embedding <=> ff.embedding) as distance
          FROM asset_face af
          JOIN face_search fs ON fs."faceId" = af.id
          CROSS JOIN LATERAL (
            SELECT embedding FROM face_search WHERE "faceId" = $2
          ) ff
          WHERE af."personId" = $1
            AND af."deletedAt" IS NULL
            AND (fs.embedding <=> ff.embedding) > $3
          ORDER BY distance DESC
          LIMIT 10`,
          [PERSON_ID, person.faceAssetId, DISTANCE_THRESHOLD]
        );
        console.log('');
        console.log('Top 10 most distant faces to be unassigned:');
        for (const row of sampleRes.rows) {
          console.log(`  ${row.id}  distance: ${parseFloat(row.distance).toFixed(4)}`);
        }
      }

      console.log('');
      console.log(`Would unassign ${faceIdsToUnassign.length} faces and queue ${faceIdsToUnassign.length} recognition jobs`);
      return;
    }

    console.log(`Unassigning ${faceIdsToUnassign.length} faces...`);
    const unassignRes = await client.query(
      `UPDATE asset_face SET "personId" = NULL
       WHERE id = ANY($1) AND "personId" = $2 AND "deletedAt" IS NULL`,
      [faceIdsToUnassign, PERSON_ID]
    );
    console.log(`  Updated ${unassignRes.rowCount} rows`);

    console.log(`Queueing ${faceIdsToUnassign.length} facial recognition jobs...`);
    const BATCH_SIZE = 500;
    let queued = 0;
    for (let i = 0; i < faceIdsToUnassign.length; i += BATCH_SIZE) {
      const batch = faceIdsToUnassign.slice(i, i + BATCH_SIZE);
      const jobs = batch.map(id => ({
        name: 'FacialRecognition',
        data: { id, deferred: false },
      }));
      await recognitionQueue.addBulk(jobs);
      queued += batch.length;
      process.stdout.write(`  Queued ${queued}/${faceIdsToUnassign.length}\r`);
    }
    console.log(`  Queued ${queued}/${faceIdsToUnassign.length} jobs`);

    await client.query('COMMIT');
    console.log('');
    console.log('Done! Faces will be re-processed by the recognition queue.');
    console.log('Monitor progress at: Admin > Jobs > Facial Recognition');

  } catch (err) {
    await client.query('ROLLBACK');
    console.error('Error:', err.message);
    throw err;
  } finally {
    client.release();
  }
}

main()
  .then(() => process.exit(0))
  .catch(err => {
    console.error(err);
    process.exit(1);
  });
