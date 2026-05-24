# Fix ERR_HTTP_HEADERS_SENT in Sync Stream — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Fix the `ERR_HTTP_HEADERS_SENT` error in `POST /api/sync/stream` by guarding the controller's catch block and converting deprecated sync handlers from throw to no-op.

**Architecture:** The sync stream controller manually handles the response via `@Res()`. When a deprecated handler throws mid-stream (after headers are sent), the catch block tries to `res.setHeader()` which crashes. Two fixes: guard the setHeader call, and stop throwing in deprecated handlers.

**Tech Stack:** NestJS, Express, Vitest

---

## File Structure

| File | Action | Purpose |
|------|--------|---------|
| `server/src/controllers/sync.controller.ts:33-35` | Modify | Guard `res.setHeader` with `if (!res.headersSent)` |
| `server/src/controllers/sync.controller.spec.ts` | Modify | Add test for mid-stream error handling |
| `server/src/services/sync.service.ts:270-272` | Modify | `syncAssetsV1`: throw → return |
| `server/src/services/sync.service.ts:288-292` | Modify | `syncPartnerAssetsV1`: throw → return |
| `server/src/services/sync.service.ts:510-514` | Modify | `syncAlbumAssetsV1`: throw → return |
| `server/src/services/sync.service.ts:828-832` | Modify | `syncAssetFacesV1`: throw → return |

---

### Task 1: Add controller test for mid-stream error handling

**Files:**
- Modify: `server/src/controllers/sync.controller.spec.ts`

- [ ] **Step 1: Write the failing test**

Add this test inside the `describe('POST /sync/stream', ...)` block in `sync.controller.spec.ts`, after the existing tests:

```typescript
it('should handle errors after headers are sent', async () => {
  syncService.stream.mockImplementation(async (_auth: any, res: any, _dto: any) => {
    res.write('data\n');
    throw new Error('stream error after headers sent');
  });

  const { status } = await request(ctx.getHttpServer())
    .post('/sync/stream')
    .set('Authorization', 'Bearer test')
    .send({ types: ['AssetsV1'] });

  expect(status).toBe(200);
  expect(errorService.handleError).toHaveBeenCalledWith(
    expect.anything(),
    expect.objectContaining({ message: 'stream error after headers sent' }),
  );
});
```

This test makes `stream()` write to the response (which sends headers) then throw. The controller's catch block should handle this without crashing. Currently, the unguarded `res.setHeader` in the catch block throws `ERR_HTTP_HEADERS_SENT`, causing the request to fail.

- [ ] **Step 2: Run the test to verify it fails**

Run: `pnpm --filter immich test -- --run src/controllers/sync.controller.spec.ts`
Expected: FAIL — the test may time out or fail because the unguarded `res.setHeader` crashes inside the catch block.

---

### Task 2: Fix the controller catch block

**Files:**
- Modify: `server/src/controllers/sync.controller.ts:31-36`

- [ ] **Step 1: Apply the fix**

Change the catch block from:

```typescript
    } catch (error: Error | any) {
      res.setHeader('Content-Type', 'application/json');
      this.errorService.handleError(res, error);
    }
```

To:

```typescript
    } catch (error: Error | any) {
      if (!res.headersSent) {
        res.setHeader('Content-Type', 'application/json');
      }
      this.errorService.handleError(res, error);
    }
```

The `GlobalExceptionFilter.handleError()` already checks `res.headersSent` (line 25 of `global-exception.filter.ts`), so it will log the error via `logGlobalError()` but skip sending an HTTP error response when headers are already sent.

- [ ] **Step 2: Run the test to verify it passes**

Run: `pnpm --filter immich test -- --run src/controllers/sync.controller.spec.ts`
Expected: All tests PASS, including the new mid-stream error test.

- [ ] **Step 3: Commit**

```bash
git add server/src/controllers/sync.controller.ts server/src/controllers/sync.controller.spec.ts
git commit -m "fix(sync): guard against ERR_HTTP_HEADERS_SENT in stream catch block"
```

---

### Task 3: Convert deprecated sync handlers to no-ops

**Files:**
- Modify: `server/src/services/sync.service.ts:270-272` (`syncAssetsV1`)
- Modify: `server/src/services/sync.service.ts:288-292` (`syncPartnerAssetsV1`)
- Modify: `server/src/services/sync.service.ts:510-514` (`syncAlbumAssetsV1`)
- Modify: `server/src/services/sync.service.ts:828-832` (`syncAssetFacesV1`)

- [ ] **Step 1: Change all 4 deprecated handlers**

For each of the four deprecated handlers, replace the `throw` with a bare `return`. The exact changes:

**`syncAssetsV1` (around line 270):** Change from:
```typescript
  private syncAssetsV1(): Promise<void> {
    throw new BadRequestException('SyncRequestType.AssetsV1 is deprecated, use SyncRequestType.AssetsV2 instead');
  }
```
To:
```typescript
  private syncAssetsV1(): Promise<void> {
    return Promise.resolve();
  }
```

**`syncPartnerAssetsV1` (around line 288):** Change from:
```typescript
  private syncPartnerAssetsV1(): Promise<void> {
    throw new BadRequestException(
      'SyncRequestType.PartnerAssetsV1 is deprecated, use SyncRequestType.PartnerAssetsV2 instead',
    );
  }
```
To:
```typescript
  private syncPartnerAssetsV1(): Promise<void> {
    return Promise.resolve();
  }
```

**`syncAlbumAssetsV1` (around line 510):** Change from:
```typescript
  private syncAlbumAssetsV1(): Promise<void> {
    throw new BadRequestException(
      'SyncRequestType.AlbumAssetsV1 is deprecated, use SyncRequestType.AlbumAssetsV2 instead',
    );
  }
```
To:
```typescript
  private syncAlbumAssetsV1(): Promise<void> {
    return Promise.resolve();
  }
```

**`syncAssetFacesV1` (around line 828):** Change from:
```typescript
  private syncAssetFacesV1(): Promise<void> {
    throw new BadRequestException(
      'SyncRequestType.AssetFacesV1 is deprecated, use SyncRequestType.AssetFacesV2 instead',
    );
  }
```
To:
```typescript
  private syncAssetFacesV1(): Promise<void> {
    return Promise.resolve();
  }
```

- [ ] **Step 2: Run the existing tests**

Run: `pnpm --filter immich test -- --run src/controllers/sync.controller.spec.ts`
Expected: All tests PASS.

- [ ] **Step 3: Run the server type check**

Run: `pnpm --filter immich check`
Expected: PASS (no type errors).

- [ ] **Step 4: Run lint**

Run: `pnpm --filter immich lint`
Expected: PASS (no lint errors).

- [ ] **Step 5: Commit**

```bash
git add server/src/services/sync.service.ts
git commit -m "fix(sync): skip deprecated sync types instead of throwing mid-stream"
```

---

### Task 4: Build and deploy verification

**Files:** None (verification only)

- [ ] **Step 1: Build the server**

Run: `pnpm --filter immich build`
Expected: Build succeeds.

- [ ] **Step 2: Rebuild and restart Docker**

Run: `cd ~/app/immich-app && ./build-glm.sh immich-server`
Expected: Container builds and starts successfully.

- [ ] **Step 3: Verify the error is gone**

Wait for a sync request to come in (check logs), or trigger one from a mobile client. Then check:

Run: `docker logs im-s --since 5m 2>&1 | grep "ERR_HTTP_HEADERS_SENT"`
Expected: No output (no more ERR_HTTP_HEADERS_SENT errors).
