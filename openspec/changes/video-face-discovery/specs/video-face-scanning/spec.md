## ADDED Requirements

### Requirement: Bounded multi-frame sampling
The video face scan SHALL sample multiple frames across the whole timeline using input-seek extraction (`-ss` before `-i`, bounded frame decode), never full-video decode, and SHALL record the actual decoded presentation timestamp of each analyzed frame (not the requested seek time).

#### Scenario: Long 4K video stays bounded
- **WHEN** a 24-minute 4K HEVC video (worst library case) is scanned with a 32-frame budget
- **THEN** extraction work scales with the budget (seek-and-grab, ~350ms/frame measured), not duration, and the run completes within the configured deadline

#### Scenario: Timestamps are decode-accurate
- **WHEN** a seek lands between keyframes or the stream has variable frame rate or nonzero start time
- **THEN** the recorded sighting time is the decoded frame's presentation timestamp and click-to-seek uses that value

### Requirement: Work budget and resource contract
Each scan run SHALL enforce: analyzed-frame cap, detector-execution cap (tiling and fallbacks count), embedding cap, identities-per-video cap (crowd guard), candidate-extraction cap, and a cumulative run deadline. The run SHALL checkpoint after small batches and record one of `saturated`, `budget_exhausted`, `deadline`, `decode_failed` as its outcome, with actual timeline coverage.

#### Scenario: Saturation stop
- **WHEN** 6 consecutive samples yield no new within-video identity and all gaps are below minGapMs (1500ms)
- **THEN** the run stops early, records outcome `saturated`, and reports the unused budget

#### Scenario: Crowded scene guard
- **WHEN** grouping produces more identities than the cap (default 30)
- **THEN** the best-quality N are kept, the remainder are recorded as dropped with counts in the run row

### Requirement: Within-video identity grouping before publish
The scan SHALL group detections into within-video identities using embedding similarity (baseline threshold 0.55 with a second-stage best-exemplar merge; cross-video verified: full recall on both corpus videos, zero destructive merges — 0.6+merge is the observed false-merge cliff on 480p faces), SHALL never merge two detections from the same frame into one identity, and SHALL publish at most one representative per global person per asset — when multiple within-video identities match the same global person, only the best exemplar is published.

#### Scenario: One stranger in many frames is one identity
- **WHEN** a person appears in 8 sampled frames and matches nothing globally
- **THEN** they contribute exactly one representative face row (with `frameTimeMs`) and one local identity — never 8 rows — so global `minFaces` cannot be satisfied by a single video

#### Scenario: Splits of the same person publish once
- **WHEN** within-video grouping splits a small-face person into 3 identities and all three representatives match the same global person
- **THEN** only the best representative is published as a face row for that person on this asset

#### Scenario: Single-sighting quality bar
- **WHEN** an identity has exactly one sighting below the stricter bar (size < 60px and score < 0.8)
- **THEN** it is kept as a local identity for review but flagged, not silently dropped

### Requirement: Deterministic, replayable sampling
The same video, configuration, and model versions SHALL produce the same sample sequence, grouping, and published representatives. Configuration hashes and model/algorithm versions SHALL be stored on each run row.

#### Scenario: Re-run stability
- **WHEN** a scan is re-run with identical configuration and no library changes
- **THEN** the chosen timestamps and grouping match the previous run

### Requirement: Re-run preserves manual work
Re-scanning an asset SHALL reconcile new identities against existing video faces by embedding similarity (not IoU), preserving manual person assignments and merging surviving sightings into the existing local identities.

#### Scenario: Manual assignment survives re-scan
- **WHEN** the owner named a person on a video face and the video is re-scanned
- **THEN** the named assignment persists and the identity's sightings are updated in place

### Requirement: Refresh-faces coexistence
The existing photo-side face refresh (including its force path that deletes machine-learning source rows) SHALL NOT delete face rows or video faces published by the video scan for assets that have a completed video face run.

#### Scenario: Photo refresh does not destroy video results
- **WHEN** the owner runs "Refresh faces" (or force re-detection) while the library contains video-published faces
- **THEN** video-published rows survive and only photo-path rows are replaced

### Requirement: Manual per-video trigger with own queue
Video face scanning SHALL run on a dedicated queue (concurrency 1–2) and be triggerable per-video from the viewer by the asset owner (video assets only); library-wide queuing is out of scope for initial rollout.

#### Scenario: Owner triggers scan from viewer
- **WHEN** the owner opens a video's viewer menu and selects the scan action
- **THEN** a VideoFaceScan job is enqueued for that asset and progress is observable via the run row
