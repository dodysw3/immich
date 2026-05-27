# Android Client Compatibility: Server Rollback Analysis

## Context

The fork's server tracks upstream `main` (v3.0.0) with ~104 fork commits (PDF pipeline, face overlay UX, tiling ML, OCR pipeline, etc.). The Android app store client is built from a v2.7.x release and requests V1 sync types (`AssetsV1`, `PartnerAssetsV1`, etc.) that the v3.0.0 server deprecated.

Current state: deprecated handlers throw `BadRequestException`, which truncates the sync stream. The `ERR_HTTP_HEADERS_SENT` error is fixed (guarded with `headersSent` check in `sync.controller.ts:33-40`). Sync is partial but the app doesn't crash — other functionality (browse, search, upload, backup) works normally.

## Problem

App store Android client can't complete a full sync against the v3.0.0 server because:
1. It requests V1 sync types, which the server rejects
2. If no-oped, the stream sends V2 types the client can't parse → crashes

## Approaches Considered

### A. Cherry-pick fork changes onto v2.7.5 temp branch
Create `temp/v2.7.5-glm` from tag, cherry-pick face overlay + tiling ML commits. Blocked because `f6df56553` (face overlay reuse) depends on the upstream overlay system added *after* v2.7.5. Tiling ML touches `person.service.ts` and config code that changed between v2.7.5→v3.0.0. Heavy conflict resolution needed.

### B. Use pre-v2.7.5 face overlay from feature branch
Same as A but using the older face overlay from `feature/face-overlay` (based on v2.7.4). Still blocked by tiling ML conflicts and the DB schema gap below.

### C. Build Android APK from source
Fix the client instead. No server/DB changes. Blocked by distribution logistics (sideloading, no app store path).

### D. Downgrade server to v2.7.5 official image
Use `ghcr.io/immich-app/immich-server:v2.7.5`. Keep custom ML container (tiling ML). Downside: lose face overlay + tiling ML temporarily.

## Database Schema Incompatibility (D Blocker)

11 migrations applied since v2.7.5. 4 are backward-incompatible:

| Migration | Severity | Impact |
|-----------|----------|--------|
| `1776263790468-DropDeviceIdAndDeviceAssetId` | 🔴 HIGH | Drops `deviceAssetId`/`deviceId` from `asset`. v2.7.5 reads/writes these columns — crashes on startup or sync query |
| `1776848612954-MigrateAlbumOwnerIdToAlbumUser` | 🔴 HIGH | Drops `album.ownerId`, moves ownership to `album_user`. v2.7.5 queries for `album.ownerId` — fails on any album access |
| `1777667825574-ChangeDurationToInteger` | 🟡 MED | `duration` varchar→integer. v2.7.5 expects string — crashes in timeline/search |
| `1776217577402-DropAuditTable` | 🟢 LOW | Drops `audit` table. v2.7.5 may or may not reference it |

Each has a `down()` migration, but reverting on production is risky:
- `DropDeviceIdAndDeviceAssetId` down adds back NOT NULL columns — needs backfill for all existing assets
- `MigrateAlbumOwnerIdToAlbumUser` down must reconstruct `album.ownerId` from `album_user` rows where role='owner' — partial down migration exists
- When v3.0 client arrives, all up migrations would need to re-run

## Recommendation: Status Quo

Stay on `agent/glm` (v3.0.0 server + fork changes). The sync truncation is handled gracefully. Full app functionality works except for sync. When the v3.0 Android client releases on the app store, everything works without changes.

## Down Migration Steps (If Needed Later)

Only if the status quo becomes untenable:

```bash
# 1. Back up database
docker exec im-pg pg_dump -U postgres -d immich -Fc > /tmp/immich-backup-$(date +%Y%m%d).dump

# 2. Run down migrations (server startup will auto-run these if present)
docker exec -w /usr/src/app/server im-s node -e "
const {Kysely, sql} = require('kysely');
const {Pool} = require('pg');
async function down() {
  const db = new Kysely({dialect: new Pool({connectionString: process.env.DB_URL})});
  // Run in dependency order (do NOT do this lightly)
  // ... execute down() for each of the 11 post-v2.7.5 migrations in reverse order
}
down().catch(console.error);
"

# 3. Deploy v2.7.5 server image
```

**Strongly discouraged** on a production instance with real data.

## When v3.0 Android Client Arrives

No action needed. The server is already running v3.0.0. Sync will begin working immediately.
