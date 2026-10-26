## ADDED Requirements

### Requirement: Timestamped sighting storage
The system SHALL store each accepted detection as a sighting: video face reference, timestamp (ms, decoded presentation time), bounding box, detection score, and quality evidence; sightings SHALL NOT enter `face_search`.

#### Scenario: Sighting written per detection
- **WHEN** a sampled frame yields an accepted detection assigned to a local identity
- **THEN** a sighting row exists with that frame's decoded timestamp and the detection's box and score

### Requirement: Per-video face records
The system SHALL store one `video_face` record per within-video identity holding the best exemplar reference, first-observed time (minimum sighting timestamp), sighting count, and optional link to the published `asset_face` row.

#### Scenario: First observed is computed, not assumed
- **WHEN** a run analyzes frames out of chronological order
- **THEN** first-observed equals the minimum sighting timestamp across all runs for that identity

### Requirement: Analysis run records
The system SHALL store one `video_face_run` row per scan containing resolved configuration and its hash, model/runtime versions, budgets, counters (frames, detections, embeddings, identities), outcome, and timeline coverage.

#### Scenario: Config change triggers re-scan offer
- **WHEN** a stored run's configuration hash or model version differs from current settings
- **THEN** the asset is eligible for re-scan and the UI can surface staleness

### Requirement: Representative frame time on asset_face
The system SHALL add a nullable `frameTimeMs` column to `asset_face` set to the representative frame's timestamp for video-published faces (null for photos and preview-derived video faces), without breaking existing DTOs or mobile sync.

#### Scenario: Video face row carries its frame time
- **WHEN** a video identity's representative is published
- **THEN** its `asset_face` row has `frameTimeMs` of the representative frame and person thumbnails for that face crop the representative frame, not the asset preview

### Requirement: Additive schema
All new tables and columns SHALL be additive (no modification of existing face table semantics) and cascade on asset delete.

#### Scenario: Asset deletion cleans up
- **WHEN** an asset with video face runs is deleted
- **THEN** its video faces, sightings, and run rows are removed by cascade
