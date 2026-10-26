## Context

Strategy is fully developed in `~/app/immich-app/docs/video-face-discovery-strategy.md` (authoritative; pipeline, resource contract, storage model, sampling policies, UI). This design records the fork-specific decisions and the measured baseline that lock that strategy into implementable form. Code references verified 2026-10-25 on the fork tree.

Verified codebase anchors:
- Detection today: `person.service.ts` `handleDetectFaces` — preview frame only; tiled pass 2 hard-skips videos (`shouldRunTiledPass` returns false for `AssetType.Video`, `person.service.ts:772`).
- minFaces hazard: `person.service.ts:981` `matches.length >= minFaces` (live config: minFaces 8, minScore 0.5, maxDistance 0.45) — N same-video sightings of one stranger satisfy it alone.
- ML request shape: `machine-learning.repository.ts` `detectFaces(imagePath, {modelName, minScore})` → multipart `/predict` with detection+recognition entries; embeddings returned per face.
- Re-detection reconcile: IoU > 0.5 against existing rows — meaningless across different frames.
- No asset-level duration column since upstream 3.3 restructure (`asset_video` 5.6% coverage, `asset_keyframe` 6%); ffprobe at runtime is the only reliable source.

Bench baseline (asset 79962286, 12.47s 1080p HEVC family video; superset = 13 keyframes + 0.4s grid + ±0.15s bursts + preview = 108 frames, 908 detections, ML 0.61s/frame mean on shared GPU): preview→9 identities, uniform8→12, keyframes13→17, uniform16→20, grid32→25, all→35. Threshold sweep 0.45/0.5/0.55/0.6 → 35/28/19/16. Yield is non-uniform: new identities appear as late as the final attempt (t=12.4s); a saturation stop of S=6 on grid32 would have stopped at attempt ~30 and missed identities found at 31–32.

## Goals / Non-Goals

**Goals:**
- Discover as many unique people per video as practical under a hard work budget.
- Bounded cost on the worst library video (24.6-min 4K HEVC 9.3GB): seek-and-grab O(K) extraction, never full-decode; measured ~350ms/grab.
- Every attempt likely to surface someone new (adaptive gap priority; saturation stop only when consecutive samples yield no new identity AND gaps < minGapMs).
- Deterministic, replayable tuning: pure-core sampling/grouping functions + dry-run CLI + contact sheets + superset detection cache.
- Publish safely: within-video grouping first; exactly one representative per identity into existing recognition; sightings out of `face_search`.
- Click-to-seek UI on first-observed timestamps.

**Non-Goals:**
- Continuous tracking/interpolated boxes in playback; mobile sync of sightings; changing photo detection or global clustering/minFaces semantics; library-wide replacement of preview-derived video faces in this change.

## Decisions

1. **Extraction = input-seek grab, keyframe-hinted.** `ffmpeg -ss T -i V -frames:v 1` (O(K), measured 350ms worst case). Optional keyframe hint pass (`-skip_frame nokey`) supplies the shot map + duration in one disk-bound read (~93s for 9.3GB; skip for files <50MB where grid≈keyframes on 1s GOPs — bench video: keyframes every 1.0s). Use actual decoded presentation timestamps (`-copyts` + showinfo), never requested T.
2. **Sampling = deterministic uniform baseline; adaptive gap bisection behind a config flag.** Gap priority `length × (signature differs ? w_diff : 1) × (any faces ? w_face : w_empty)`; saturation stop S=6, minGapMs=1500. Bench evidence gates promotion of adaptive over uniform: default profile uniform16–grid32; adaptive only wins if it beats uniform at equal attempts on the corpus.
3. **Within-video grouping = greedy centroid clustering + second-stage best-exemplar merge at threshold 0.55.** Cross-video verified (v1 1080p 9 people, v2 480p 11 people incl. one unidentified): 0.55+merge keeps full recall on both (9/9, 11/11) with zero destructive merges and the best split reduction short of the failure point (v1 grid: 25/15 splits @0.45 → 15/5 @0.55+merge; v2: 42/31 → 24/13). **0.6+exemplar-merge is the observed cliff**: on 480p faces it absorbs two distinct people (Gwen, Mazel → 9/11) — plain 0.6 is safe but the merge pass at 0.6 is not; 0.6 also had 0 false merges on the 1080p video, so the failure is quality-dependent (small/noisy embeddings at 480p). Splits concentrate on minFaceSize-floor faces; publish-time dedup by global personId + single-sighting quality bar handle the residue. Default 0.55+merge; expose threshold and merge on/off as config for corpus tuning.
4. **Publish one representative per identity, deduped by global person.** Best exemplar = max(size × score); after matching representatives against global persons, identities matching the SAME person publish only the best one — this preserves the app-wide one-row-per-person-per-asset assumption even when within-video grouping splits a person. `asset_face.frameTimeMs` = representative frame's pts; sightings stay out of `face_search`. Person thumbnail for video faces must crop the representative frame (media.service change), not the preview.
5. **Storage: 3 new tables + 1 column.** `asset_face.frameTimeMs` (nullable int ms); `video_face` (local identity: assetId, best exemplar refs, firstObservedMs, optional assetFaceId); `video_face_sighting` (videoFaceId, timeMs, bbox, score, quality); `video_face_run` (config hash, model versions, budgets, counters, outcome). Re-runs reconcile by embedding similarity (NOT IoU) so manual person assignments survive.
6. **Own queue `VideoFaceScan`, concurrency 1–2, manual trigger first.** New `AssetJobName.SCAN_VIDEO_FACES` viewer action (video + owner only). Photo-side "Refresh faces" must NOT delete video-published rows: extend its delete filter to exclude assets with a video_face_run (the force path deletes ML-source `asset_face` rows library-wide today — without this guard it silently destroys video results; this is the one blocking semantic, decided here).
7. **Resource contract per run** (defaults; bench-informed): analyzed frames ≤32 (experiment ≤96), detector executions ≤64 (tiling counts; tiling off initially, on for ≥4K frames), embeddings ≤256, identities ≤30 (crowd guard, keep best N), deadline 60s cumulative, candidate extractions ≤2× frame budget. Checkpoint after each batch; explicit outcome (`saturated` / `budget_exhausted` / `deadline` / `decode_failed`) + coverage written to the run row.
8. **Tuning harness = the proven video-face-bench pattern, productized.** Dry-run CLI `scan <assetId> --config x.json` → manifest.json + contact-sheet.html, writes nothing to library. Ops-side superset cache (frames + detections JSONL keyed by frame hash) makes any ≤budget picker simulatable offline in seconds. Metrics per config: recall, false merges, splits, new-identities-per-attempt, attempts-per-unique, decode ms, ML ms. Corpus: 15+ owner-reviewed videos; asset 79962286 review (identity-labels.csv) is the first entry.

## Risks / Trade-offs

- **Fixed budget ≠ guaranteed completeness** (someone visible only between sampled frames is missed). Mitigation: coverage visible in UI, "Analyze more" resume with explicit budget increase.
- **Within-video over-splitting inflates identities** (35 hypotheses in a 12s video) → fake "new person" candidates. Mitigation: stricter-than-global grouping, single-sighting quality bar, corpus tuning against owner ground truth; published representatives face the same global clustering as photos.
- **Shared-GPU contention** (ML 0.61s/frame while interpretation backlog runs). Mitigation: concurrency 1–2 on own queue; deadline; batched checkpoint/yield.
- **Long-tail decode pathologies** (corrupt files, VFR, nonzero start pts). Mitigation: use decoded pts not requested T; `-copyts`; decode-failure outcome recorded and run marked, not retried beyond cap.
- **Upstream sync surface**: new tables/columns are additive; the `RefreshFacesJob` delete-filter extension and `shouldRunTiledPass` video branch are the two upstream-merge hotspots.
