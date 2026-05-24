# Sync Stream ERR_HTTP_HEADERS_SENT — Investigation & Fix

## Symptom

`ERR_HTTP_HEADERS_SENT` errors in server logs from `POST /api/sync/stream`, ~4 times per 24h.

## Root Cause

The app store mobile client (pre-v3.0.0) requests deprecated sync types like `AssetsV1`. The deprecated handler throws `BadRequestException` mid-stream, but earlier handlers (`AuthUsersV1`, `UsersV1`, `PartnersV1`) have already written data and flushed HTTP headers. The controller's catch block then calls `res.setHeader()` on the already-committed response, producing `ERR_HTTP_HEADERS_SENT` and swallowing the original error.

### Error chain

```
1. AuthUsersV1, UsersV1, PartnersV1 handlers → response.write() → headers sent (200)
2. AssetsV1 handler → throw BadRequestException('deprecated')
3. Controller catch: res.setHeader('Content-Type', 'application/json') → ERR_HTTP_HEADERS_SENT
4. Original BadRequestException is lost
5. ErrorInterceptor logs only the headers-sent error
```

### Affected deprecated handlers

| Handler | Location |
|---------|----------|
| `syncAssetsV1()` | `sync.service.ts:270` |
| `syncPartnerAssetsV1()` | `sync.service.ts:288` |
| `syncAlbumAssetsV1()` | `sync.service.ts:508` |
| `syncAssetFacesV1()` | `sync.service.ts:824` |

## What Was Applied

### Fix kept: controller catch block guard (`sync.controller.ts:33-40`)

```typescript
catch (error: Error | any) {
  if (!res.headersSent) {
    res.setHeader('Content-Type', 'application/json');
  } else {
    res.end();
  }
  this.errorService.handleError(res, error);
}
```

- `res.setHeader` is guarded — no more `ERR_HTTP_HEADERS_SENT`
- `res.end()` terminates hanging streams when headers were already sent
- `handleError` is always called — original errors are properly logged via `GlobalExceptionFilter`
- Test added in `sync.controller.spec.ts`

### Reverted: deprecated handler no-ops (`sync.service.ts`)

Initially converted all 4 deprecated handlers from `throw` to `return Promise.resolve()`. This was reverted because:

1. The app store mobile client is pre-v3.0.0 and incompatible with the server's v3.0.0 sync types
2. Before the fix, the stream was truncated at `AssetsV1` — types like `AlbumUsersV1` were never sent
3. With the no-op fix, the stream completed fully and sent `AlbumUsersV1` data the app store client couldn't parse, causing `SyncAlbumUserV1.fromJson` crashes on Android
4. Restoring the throws masks the version mismatch (stream truncates before reaching incompatible types)

## App Store Client Compatibility Issue

The app store mobile client requests sync types based on a server version check:

- `AssetsV1` (not `AssetsV2`) → client thinks server < v3.0.0
- `PartnerAssetsV1` (not `PartnerAssetsV2`)
- `AlbumsV1` (not `AlbumsV2`)
- `AlbumAssetsV1` (not `AlbumAssetsV2`)

The server is v3.0.0 (custom fork) but the app store client is built from an older release (latest tag is v2.7.5). The SDKs are out of sync — `SyncAlbumUserV1` and other models may expect different fields.

**Resolution:** Build the mobile app from the repo source to match the server version. No pre-built release exists that matches the fork's v3.0.0.

## Current State

| Component | Status |
|-----------|--------|
| `sync.controller.ts` catch block | Fixed — guarded with `headersSent` check |
| `sync.controller.spec.ts` | New test for mid-stream error handling |
| `sync.service.ts` deprecated handlers | Reverted to `throw` (app store compat) |
| `ERR_HTTP_HEADERS_SENT` in logs | Gone (gracefully handled, properly logged) |
| Mobile client crash | No longer occurring (stream truncation restored) |
| Full sync completion | Not possible with app store client — needs source build |

## Commits

1. `5f737955a` — `fix(sync): guard against ERR_HTTP_HEADERS_SENT in stream catch block`
2. `3c3a05d06` — `fix(sync): skip deprecated sync types instead of throwing mid-stream`
3. `7b1946ca5` — `revert(sync): restore deprecated handler throws for app store client compat`
