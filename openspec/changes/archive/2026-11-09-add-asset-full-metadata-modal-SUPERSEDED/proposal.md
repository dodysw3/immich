## Why

The asset viewer's info panel has a small `(i)` icon next to the filename (`DetailPanel.svelte`, aria-label `show_file_location`). Today it only slides open the server file path. The full metadata the server already extracted and persists is mostly invisible to the owner:

- `asset_exif` stores 5 fields the API never maps (`fps`, `profileDescription`, `colorspace`, `bitsPerSample`, EXIF `tags[]`).
- `asset_video` (codec, profile/level, pixelFormat, color primaries/transfer/matrix, Dolby Vision fields, bitrate, frameCount, timeBase, format) and `asset_audio` (codec, profile, bitrate) are written at extraction time but consumed only by the transcode pipeline — no API reads them.

Coverage on this library (verified 2026-11-09, live `im-pg`): video streams 52,529/52,581 videos (99.9%), audio streams 51,159, fps 52,525, Dolby Vision 0, colorspace 392,012/640,557 exif rows, bitsPerSample 615,970, profileDescription 115,707, keyword tags 157,705.

## What Changes

- **New owner-only endpoint** `GET /api/assets/:id/media-metadata` returning the complete *stored* extraction: full `asset_exif` row (including the 5 unmapped fields), plus the `asset_video` and `asset_audio` stream rows when present. Scope is deliberately **Option A** — everything Immich already extracted and stored; no live re-extraction (raw exiftool dumps stay out of scope).
- **Web modal**: the `(i)` icon now opens a full-metadata modal (`AssetMetadataModal.svelte`) with grouped sections — File (path + folder link, size, orientation, modified), Camera/Exif, Photo/Video properties (dims, fps, color profile, colorspace, bits), Streams (video + audio, video assets only), GPS/city. Empty sections are hidden (covers the ~52 older videos without stream rows). A copy-as-JSON affordance exposes the same payload verbatim.
- **Entry stays owner-only** (as the current icon is) and is now enforced server-side too: non-owners and shared-link viewers get 403.
- The inline path-reveal (`isShowAssetPath` / `toggleAssetPath`) is retired; the path moves into the modal's File section (folder link preserved).

Non-goals: raw exiftool dumps (Option B), `asset_keyframe` exposure (internal scrubbing aid), changes to the existing `ExifResponseDto` or upstream's `:id/metadata` key-value feature (route name chosen to avoid both — `:id/metadata` is taken).

## Capabilities

### New Capabilities
- `asset-full-metadata-api`: owner-only endpoint surfacing the complete stored extraction (exif row + video/audio stream rows) for images and videos.
- `asset-full-metadata-modal`: viewer info-panel modal presenting the full metadata, grouped and adaptive to asset type, hiding absent sections.

### Modified Capabilities
- none (no existing spec capability is altered; the retired inline path reveal has no spec)
