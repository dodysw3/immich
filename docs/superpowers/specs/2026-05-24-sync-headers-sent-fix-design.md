# Fix ERR_HTTP_HEADERS_SENT in Sync Stream

## Problem

`POST /api/sync/stream` triggers `ERR_HTTP_HEADERS_SENT` when a deprecated sync type
(e.g., `AssetsV1`) is requested. The deprecated handler throws `BadRequestException`
mid-stream, after earlier handlers have already written data and flushed headers.
The controller's catch block then tries `res.setHeader()` on the already-sent response,
producing a secondary error that swallows the original cause.

### Timeline

1. Client requests sync with types including deprecated `AssetsV1`
2. Handlers for `AuthUsersV1`, `UsersV1`, `PartnersV1` stream data — headers sent
3. `AssetsV1` handler throws `BadRequestException('deprecated')`
4. Controller catch: `res.setHeader('Content-Type', 'application/json')` → ERR_HTTP_HEADERS_SENT
5. Original `BadRequestException` is lost; only the headers-sent error is logged

### Affected handlers (all throw mid-stream)

- `syncAssetsV1()` (line 270)
- `syncPartnerAssetsV1()` (line 288)
- `syncAlbumAssetsV1()` (line 512)
- `syncAssetFacesV1()` (line 830)

## Solution

### Change 1: Guard `res.setHeader` in `sync.controller.ts` catch block

Add `if (!res.headersSent)` check before `res.setHeader()`. The
`GlobalExceptionFilter.handleError()` already has this guard, so the error response
won't be sent twice, but the error will still be logged via `logGlobalError()`.

### Change 2: Convert deprecated handlers to no-ops in `sync.service.ts`

Replace `throw new BadRequestException(...)` with `return` in all four deprecated
handlers. Throwing during a stream is fundamentally broken because headers have been
sent by earlier handlers. The client cannot receive the error, so throwing only causes
collateral damage (truncated stream, swallowed errors, log noise).

## Files changed

- `server/src/controllers/sync.controller.ts` — guard catch block
- `server/src/services/sync.service.ts` — no-op deprecated handlers

## Impact

- Clients requesting deprecated types get a complete stream (with `SyncCompleteV1`)
  instead of a truncated one
- No more `ERR_HTTP_HEADERS_SENT` errors in logs
- Original errors from the stream are properly logged via `GlobalExceptionFilter`
