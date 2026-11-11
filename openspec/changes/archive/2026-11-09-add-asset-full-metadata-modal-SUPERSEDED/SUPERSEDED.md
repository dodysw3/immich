# SUPERSEDED (2026-11-09)

This proposal was never implemented (0/18 tasks). The same feature was built and deployed the same day
with a different, user-approved design:

- (i) icon expands **inline** in the Info panel (path + General/Dates/Video/Audio groups) — not a modal.
- New endpoint `GET /api/assets/:id/av-metadata` (stream rows only) with **normal AssetRead access**
  (same as every other asset endpoint) — not a strict owner-only `:id/media-metadata`.
- `ExifResponseDto` was **widened** with fps / profileDescription / colorspace / bitsPerSample.
- `isShowAssetPath` / `toggleAssetPath` kept as the toggle (not retired).

Implementation: `web/src/lib/components/asset-viewer/DetailPanelFileMetadata.svelte`,
`server/src/dtos/av-metadata.dto.ts`, `VideoStreamRepository.getAvMetadata`.
Kept here for the design reasoning (data inventory, raw-exiftool option B, color-enum mapping ideas).
