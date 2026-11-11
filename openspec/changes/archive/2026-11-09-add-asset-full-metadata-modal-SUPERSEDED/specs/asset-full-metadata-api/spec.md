## ADDED Requirements

### Requirement: Full stored metadata endpoint
The server SHALL expose `GET /api/assets/:id/media-metadata` returning the complete stored extraction for the asset: the full `asset_exif` row and, when present, the `asset_video` and `asset_audio` stream rows. Sections with no stored row SHALL be `null` (or omitted), never synthesized. The endpoint SHALL NOT re-extract from the file and SHALL NOT expose `asset_keyframe` data.

#### Scenario: Video returns all three sections
- **WHEN** the owner requests media-metadata for a video with extraction-complete stream rows
- **THEN** the response contains `exif` (including `fps`, `profileDescription`, `colorspace`, `bitsPerSample`, `tags`), `video` (codecName, profile, level, pixelFormat, colorPrimaries, colorTransfer, colorMatrix, Dolby Vision profile/level/blSignalCompatibilityId, bitrate, frameCount, timeBase, formatName, formatLongName, index), and `audio` (codecName, profile, bitrate, index)

#### Scenario: Image omits stream sections
- **WHEN** the owner requests media-metadata for an image
- **THEN** `video` and `audio` are null/absent and `exif` carries the image's stored fields

#### Scenario: Old video without stream rows
- **WHEN** a video predates stream-row persistence (no `asset_video`/`asset_audio` rows, ~52 known on this library)
- **THEN** `video`/`audio` are null/absent and the request still succeeds with the exif section

### Requirement: Owner-only access
The endpoint SHALL be restricted to the asset's owner (and only the owner — admins included are excluded per product decision). Non-owners and shared-link viewers SHALL receive 403.

#### Scenario: Non-owner denied
- **WHEN** an authenticated user who is not the asset owner requests media-metadata for that asset id
- **THEN** the response is 403 and no metadata is returned

#### Scenario: Shared-link viewer denied
- **WHEN** the request authenticates as a shared link covering the asset
- **THEN** the response is 403
