## Why

Face detection on videos currently analyzes a single frame — the preview thumbnail, chosen by the thumbnail filter chain for a good thumbnail, not for faces. On the benchmark family video (asset 79962286, 12.47s), that single frame yields 9 face identities, while a 108-frame superset of the same video yields up to 35 identity hypotheses: people who appear mid-video, in the background, or after camera moves are simply never discovered. With 55,828 videos in the library (25,842 already carrying preview-only faces), this is the difference between "faces in the cover frame" and "people in this video".

Two constraints shape the design. First, a critical hazard verified in code: recognition gates person creation on `matches.length >= minFaces` (`person.service.ts:981`) and global clustering assumes ~one face row per person per asset — naively inserting N frames × M detections into `asset_face` lets one stranger seen in 5 frames materialize as a fake person. Second, cost must be bounded: benchmarks on the worst library video (24.6-min 4K HEVC, 9.3GB) show a full-decode scan runs at 0.65× realtime (~16 min), while seek-and-grab extraction costs ~350ms/frame regardless of video length (8 frames from the 9.3GB file in 2.8s).

An exploration design doc (`~/app/immich-app/docs/video-face-discovery-strategy.md`) plus a completed tuning bench on asset 79962286 (`~/app/immich-app/video-face-bench/`) supply the strategy and measured baselines.

## What Changes

- **New VideoFaceScan pipeline**: bounded, budgeted multi-frame sampling across the whole timeline (seek-and-grab extraction, never full-decode), within-video identity grouping before anything is published, exactly one representative per identity into the existing recognition pipeline.
- **New storage**: timestamped sightings and per-video analysis runs in new tables; `asset_face.frameTimeMs` for the representative frame; sightings/identities remain out of `face_search`.
- **New job + admin surface**: dedicated queue (concurrency 1–2) with full resource contract (frame budget, detector-execution cap, embedding cap, run deadline, saturation stop); manual per-video trigger initially; library-wide run later once tuned.
- **Tuning harness**: dry-run CLI + ops bench scripts (already proven in video-face-bench) with contact-sheet review and reviewed corpus metrics (recall, false merges, splits); cache-first superset replay so policy changes simulate in seconds without re-decode.
- **UI**: "Faces in this video" strip with per-identity first-observed timestamps; click a face to seek playback to the observation; timeline markers as follow-up.

## Capabilities

### New Capabilities
- `video-face-scanning`: multi-frame face discovery within video assets — bounded sampling, within-video identity grouping, one representative per identity into recognition, re-run semantics that preserve manual assignments.
- `video-face-sighting-store`: timestamped sightings, per-video faces with best exemplar and first-observed time, analysis-run records with resolved configuration and outcome.
- `video-face-tuning`: dry-run scan CLI, contact-sheet review output, superset detection cache for offline policy simulation, corpus metrics.
- `video-face-viewer`: faces-in-this-video strip and click-to-seek on video assets.

### Modified Capabilities
- `facial-recognition` (existing face pipeline): video assets' published face rows now come from the video scan representative (with `frameTimeMs`) instead of the preview frame; preview-frame detection remains for photos and as the video fallback when scan hasn't run. Person thumbnails for video faces must crop the representative frame, not the asset preview.

## Bench Baselines (2026-10-25, corpus videos 79962286 + 25acaceb)

**Video 1 — 79962286** (12.47s 1080p, owner-verified: 9 people + 1 n/a). Key honest finding: the preview frame happens to contain all 9 people (video opens on a crowded scene) — this asset demonstrates timestamps, exemplar quality, and grouping behavior, not a preview-recall gap.

**Video 2 — 25acaceb** (22.99s 480p WhatsApp clip, owner-verified: 11 identities = 10 named + 1 recurring unidentified "Unknown Face1") — **the recall case, proven**. Production preview finds **2/11 people** (Dody, Milda — everyone arriving after the opener is missed: Arief, Sofi, Nadya, Mazel, Gwen, Dewi, Sri, Laksmi, Unknown Face1). **uniform8 finds 11/11 with 8 frames** — timeline spread, not budget, is what buys people on this video:

| policy | attempts | people found | ML s |
|---|---|---|---|
| preview (production today) | 1 | **2/11** | 0.25 |
| uniform8 | 8 | 11/11 (16 clusters) | 2.4 |
| uniform16 | 16 | 11/11 (19 clusters) | 4.1 |
| keyframes (1s GOP) | 22 | 11/11 (23 clusters) | 5.0 |
| grid@0.4s (57 frames) | 57 | 11/11 (42 clusters @0.45) | 14.9 |

**Grouping threshold, cross-video verdict** (grid path, splits in parens):

| setting | v1 1080p (9 people) | v2 480p (11 people) |
|---|---|---|
| 0.45 (= global maxDistance) | 9/9 (25/15 splits) | 11/11 (42/31) |
| **0.55 + exemplar merge** | **9/9 (15/5)** | **11/11 (24/13)** |
| 0.6 plain | 9/9 (14/4) | 11/11 (22/11) |
| 0.6 + exemplar merge | 9/9 (13/3) | **9/11 — FALSE MERGE (Gwen, Mazel absorbed)** |

The 0.6+merge combination is the observed false-merge cliff: safe on 1080p, absorbs two people on 480p (noisy small-face embeddings). Default therefore 0.55+merge; both knobs config-exposed for corpus tuning.

- Budget trades against fragment count on video 1 (every policy ≥preview finds 9/9) but directly buys people on video 2 — spread across the timeline is the common factor (uniform8 suffices on v2; preview's single opening frame is the floor).
- 9–14 identity-hypotheses exceed 8 sightings per video (minFaces hazard live on both).
- New identities appear as late as the final grid attempt on both videos; a saturation stop of S=6 alone would miss them → saturation requires the minGapMs condition.

## Non-Goals

- Continuous tracking / interpolated face boxes during playback (sparse sightings only; markers mean "seen at", not continuous presence).
- Mobile sync of sightings/timestamps (web-first; `asset_face.frameTimeMs` is additive and tolerated by current DTOs).
- Changing photo face detection, global recognition clustering, or `minFaces` semantics.
- Replacing the existing preview-derived video faces library-wide in this change (coexistence + per-video re-scan instead).
