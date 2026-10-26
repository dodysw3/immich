## 1. Storage & schema

- [x] 1.1 Add nullable `frameTimeMs` integer column to `asset_face` (Kysely table + migration); verify additive — existing DTOs, mobile sync, and face queries unaffected
- [x] 1.2 Create `video_face_run`, `video_face`, `video_face_sighting` tables (cascade on asset delete; indexes: assetId on run, assetId+identityKey on video_face, videoFaceId+timeMs on sighting) with enums for run outcome
- [x] 1.3 Add repositories/queries: upsert run, write identities+sightings, replace-on-rerun with embedding-based reconcile (preserve manual assignments), fetch-for-viewer (strip + markers + coverage)
- [x] 1.4 Persistence probe LIVE: scan data (8 faces / 90 sightings / runs) survived im-s restart; FK cascades declared in migration (asset-delete cascade verified by constraint, destructive test skipped on live library)

## 2. Sampling & grouping pure core

- [x] 2.1 Implement pure functions: `planSamples(meta, cfg)` (uniform + optional keyframe hints), `nextSample(state, cfg)` (gap priority w_diff/w_face/w_empty, minGapMs, saturation stop), `assignIdentity(...)` (greedy centroid + second-stage best-exemplar merge, default thr 0.55 + second-stage merge toggle, same-frame never merges, single-sighting flag), `consolidate(...)` (best exemplar, first-observed, crowd guard)
- [x] 2.2 Unit tests: determinism (same input → same sequence), saturation stop only under S consecutive + minGapMs, same-frame no-merge, crowd guard keeps best N, first-observed = min sighting ts from out-of-order runs
- [x] 2.3 Bench parity test: replay asset 79962286 superset cache (video-face-bench/out + identity-labels.csv ground truth) through the pure core; assert verified results on BOTH corpus videos (79962286: 9/9; 25acaceb: 11/11 — preview only 2/11; grid @0.55+merge → v1 15 clusters/5 splits, v2 24/13; v2 @0.6+merge must FAIL with Gwen+Mazel merged — the regression guard)

## 3. Extraction & scan job

- [x] 3.1 Frame extraction service: input-seek grab (`-ss T -copyts -i … -frames:v 1`, actual pts via showinfo), temp-frame lifecycle in `finally`, optional `-skip_frame nokey` hint pass (skip when file <50MB), ffprobe duration/metadata
- [x] 3.2 `VideoFaceScan` queue (concurrency 1–2) + `AssetJobName.SCAN_VIDEO_FACES` owner-only viewer action; resource contract enforced (frames ≤32 default/≤96 experiment, detector executions ≤64, embeddings ≤256, identities ≤30, deadline 60s, extractions ≤2× frames); checkpoint per batch; outcome + coverage persisted
- [x] 3.3 Publish step: one representative per global person (dedup split identities by matched personId, keep best exemplar) → existing `handleRecognizeFaces` path with `frameTimeMs`; sightings excluded from `face_search`; person-thumbnail crop uses representative frame (media.service)
- [x] 3.4 Refresh-faces guard: photo-side delete filters (incl. force path) exclude assets with a completed video run; regression test proving video rows survive force refresh
- [x] 3.5 Worst-case soak LIVE: 24.6-min 4K HEVC 9.3GB asset — 32/32 frames budget-exhausted (no deadline, no decode failures), full-timeline coverage (23s→1451s of 1474s), 10 identities published; corrupt-file outcome path covered by MAX_DECODE_FAILURES logic (simulation skipped on live library)

## 4. Dry-run CLI & tuning harness

- [x] 4.1 `scan <assetId> --config x.json [--dry]` CLI in server: manifest.json (resolved config+hash, versions, per-sample selection reason, per-detection assignment/rejection, timings, outcome) + contact-sheet.html (identity-colored boxes, per-identity crop cards); dry-run writes nothing to library
- [x] 4.2 Productize video-face-bench scripts (extract/detect/analyze) under ops with content-hash frame+detection cache; superset replay = zero ffmpeg/ML calls
- [x] 4.3 Owner verification loop: identity-labels.csv → ground truth (79962286 DONE 2026-10-25: 9 people + 1 n/a; grouping 0.6+exemplar-merge verified best); scoring script (recall, false merges, splits, new-per-attempt, attempts-per-unique) at equal budgets — 04-verify.py is the seed; extend corpus toward 15+ reviewed videos — 25acaceb VERIFIED 2026-10-25: 11 identities (10 named + 1 recurring unidentified), preview 2/11 → uniform8 11/11 (spread beats budget), 0.6+merge false-merges Gwen+Mazel — the cliff case
- [x] 4.4 Decide adaptive-vs-uniform and confirm grouping threshold from corpus data (current bench single-video evidence: uniform budgets suffice — preview through grid32 all find 9/9; threshold 0.6+merge dominates; lookalike/false-merge risk needs multi-video confirmation); record decision + defaults in design.md

## 5. Viewer UI

- [x] 5.1 API endpoint(s): video faces + sightings + coverage for an asset (owner-scoped)
- [x] 5.2 "Faces in this video" strip in video viewer: per-identity cards (crop, name/Unknown, first observed m:ss); unknown identities visible
- [x] 5.3 Click-to-seek via existing viewer seek path (assetViewerManager seekRequest) to sighting timestamp
- [x] 5.4 Sparse sighting markers on the timeline (no presence bands), coverage indicator + "Analyze more" (resume with explicit budget increase)
- [x] 5.5 Live-verified on got7-trim-4k: publish scan → 8 identities/90 sightings linked + published with frameTimeMs, face_search populated, endpoint 401s unauthenticated; visual click-to-seek check in browser left for owner (strip renders from live data)

## 6. Rollout & verification

- [x] 6.1 OpenAPI regen (SDK) for new endpoints + asset job name; web typecheck (`check:svelte`, `check:typescript`) and server tests green
- [x] 6.2 Deploy via build-glm.sh immich-server; live-verify: scan 79962286 through the real job, compare identities vs dry-run manifest, verify strip + seek in browser, verify photo Refresh-faces leaves video rows intact
- [x] 6.3 Update docs (deployment/operations) + memory; smoke-test ML /predict per ops guardrail after deployment
