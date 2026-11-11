## Context

The fork's asset viewer (`web/src/lib/components/asset-viewer/DetailPanel.svelte`) shows a curated "Details" subset and an owner-only `(i)` icon (`show_file_location`) that toggles `assetViewerManager.isShowAssetPath` to slide open `asset.originalPath`.

Server side, extraction (`server/src/services/metadata.service.ts:280-371`) persists three user-relevant rows per asset:

| Table | Consumed by API today |
|---|---|
| `asset_exif` (`asset-exif.table.ts`) | `ExifResponseDto` — minus `fps`, `profileDescription`, `colorspace`, `bitsPerSample`, `tags` |
| `asset_video` (`asset-av.table.ts`) | nothing (transcode pipeline only) |
| `asset_audio` (`asset-av.table.ts`) | nothing (transcode pipeline only) |

`asset_keyframe` is internal scrubbing data — excluded. No schema changes are needed anywhere in this change: all tables exist; this is a read-surface + web-UI change only.

## Goals / Non-goals

**Goals**: owner sees every extracted field for any asset (image or video) via the existing `(i)` affordance; zero upstream-DTO churn; fork maintainability.

**Non-goals**: live re-extraction / raw exiftool dump (Option B — revisit only if a field is genuinely missing); exposing metadata to shared links or partner viewers; `asset_keyframe`; modifying upstream `ExifResponseDto` or the upstream `:id/metadata` key-value feature.

## Decisions

### D1: Scope = stored data only (Option A)
"Full" means the union of the three stored rows. Verified live coverage 2026-11-09: streams for 52,529/52,581 videos; fps 52,525; DV fields 0 (UI renders DV line conditionally). Gaps hide sections, never error.

### D2: New DTO, not ExifResponseDto extension
`AssetMediaMetadataResponseDto` (new `server/src/dtos/asset-media-metadata.dto.ts`) mirrors the full stored rows and embeds the existing `ExifResponseDto` shape plus the 5 orphan fields. Keeping `ExifResponseDto` untouched avoids widening every asset list response and shrinks the upstream-merge surface. OpenAPI/SDK regen still required (oazapfts pipeline is functional per memory, post-1bda28f9b1 fix).

### D3: Route `GET /api/assets/:id/media-metadata`
`:id/metadata` is taken (upstream user-facing key-value pairs, `asset.controller.ts:163`); `:id/ocr` and `:id/edits` exist too. `media-metadata` reads accurately: exif + media stream metadata. Response:

```
{ exif: {...25 exif fields incl. fps/profileDescription/colorspace/bitsPerSample/tags},
  video: {...16 stream fields} | null,
  audio: {...4 stream fields}  | null }
```

### D4: Owner-only enforced server-side
`@Authenticated` + `access.checkOwnerAccess` (standard owner-scoped pattern). Strictly the owner — admins excluded (product decision: metadata includes server paths; keep the surface minimal). Shared links → 403. Web gate matches (`{#if isOwner}` already on the icon).

### D5: Modal over inline expansion
`web/src/lib/modals/AssetMetadataModal.svelte` using `@immich/ui` `Modal`/`ModalBody` (read-only precedent exists; `FormModal` is for forms). Fetches on open via a TanStack query (`getAssetMediaMetadataQuery`, stale-while-revalidate, ~single indexed-PK read ×3 — cheap). Sections: File / Camera & Exif / Photo·Video properties / Streams / GPS. Absent fields omitted, absent sections hidden.

- ffmpeg color enums (`colorPrimaries` etc.) are raw numbers in the API contract (that's what's stored); the modal maps common values to names (bt709, bt2020, smpte2084…) via a small local table, falling back to the raw number. Bitrate → human units.
- Dolby Vision line renders only when `dvProfile` present (0 assets today).
- Copy-as-JSON copies the raw response body (nulls included) — the display omits nulls, the copy doesn't.

### D6: Retire the inline path reveal
`isShowAssetPath`/`toggleAssetPath` removed from `assetViewerManager`; the path + `go_to_folder` link move into the modal's File section. Path display stays owner-only (inherent — whole modal is owner-only).

## Risks / Trade-offs

- **Upstream merge surface**: one new controller route + one new DTO file + one repo method; low-conflict placement (appended routes, new file).
- **Path exposure**: endpoint returns no paths; the path only appears in the modal (owner-gated). Even so, the endpoint is owner-only by design.
- **52 stream-less videos**: modal hides Streams; no auto re-extraction (metadata sync would backfill if re-run, out of scope).

## Migration Plan

1. Server: DTO → repo method (`getFullMediaMetadata` in `asset.repository.ts`, three PK lookups) → service → controller route → e2e (owner 200 + section shape, non-owner 403, shared-link 403).
2. SDK regen → web query → modal component → wire `(i)` onclick → remove inline reveal → i18n keys (en.json; fork keys stay committed).
3. Checks: `check:svelte` + `check:typescript`; server lint/unit; e2e.
4. Deploy: rebuild via `./build-glm.sh` (CWD), restart `im-s`; verify: curl owner=200 vs non-owner=403 with real ids, modal on one image + one video (Streams visible) + one pre-stream video (Streams hidden).

## Open Questions

- none blocking — field naming/labels refined during implementation; DV/color mapping table grows on demand.
