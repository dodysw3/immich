## MODIFIED Requirements

### Requirement: Video asset face publication
For video assets with a completed video face scan, the published `asset_face` rows SHALL come from the scan's per-identity representatives (one per within-video identity, each with `frameTimeMs`); preview-frame detection remains the fallback for unscanned videos and for photos. Tiled pass 2 remains disabled for the preview path but MAY run per-frame within the video scan under the detector-execution budget for high-resolution frames.

#### Scenario: Scanned video publishes representatives
- **WHEN** a video face scan completes with 12 identities (≤ identity cap)
- **THEN** at most 12 machine-learning face rows exist for the asset, one per identity, each carrying its representative frame time

#### Scenario: Unscanned video keeps today's behavior
- **WHEN** a video has no scan run
- **THEN** face detection and recognition behave exactly as before (preview frame, no tiling)

### Requirement: Person thumbnails from the representative frame
Person thumbnails for video-derived faces SHALL crop the representative frame at its timestamp, not the asset preview.

#### Scenario: Thumbnail matches the face
- **WHEN** a video face's representative is at 7.4s but the asset preview is from 0.9s
- **THEN** the person thumbnail crops the 7.4s frame
