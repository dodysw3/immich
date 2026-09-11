## Why

Immich currently describes what a photo contains, but it does not preserve a richer, human-readable interpretation of composition, context, and possible meaning. A local vision-language model can add this archival value without sending private photos to an external API or creating usage charges.

## What Changes

- Automatically queue an interpretation after a newly uploaded photo has a small preview available.
- Call the locally hosted Unsloth OpenAI-compatible API with `unsloth/Muse-Glimmer-30B-GGUF`, quant `UD-Q3_K_XL`, and a versioned structured-output prompt.
- Do not provide Immich person associations or person names to the model. Permit a famous-public-person identification only when the model has great visual confidence, and preserve it only as a model claim rather than modifying Immich people or face data.
- Store all attempts in the asset metadata entry `ai-interpretation-v1`, keyed by the unique tuple `(model, quant, promptVersion)`, so different experiments coexist while the same tuple is claimed only once.
- Ignore duplicate automatic triggers and duplicate queue deliveries for a tuple that has already been claimed, regardless of whether its run is queued, running, completed, or failed.
- Render the complete `ai-interpretation-v1` JSON as a read-only raw block in the image Info panel when the metadata exists.
- Add a photo-viewer toggle when the metadata exists, showing the latest completed run's `result.title` at the top and an `[I] result.interpretation // [S] result.archive_summary` summary at the bottom as fixed screen overlays. Show confidence-sorted `result.notable_details` as colored rounded tags with significance tooltips.
- Remember the toggle state for the browser session so it remains enabled or disabled across asset and page navigation.
- Keep the initial scope to newly uploaded image assets. Manual runs, bulk backfill, polished interpretation UI, videos, PDFs, and automatic person-association changes are out of scope.

## Capabilities

### New Capabilities

- `ai-image-interpretation`: Asynchronous local-VLM interpretation, tuple-level idempotency and metadata persistence, privacy constraints, and raw Info-panel display.

### Modified Capabilities

None. The repository does not yet contain established OpenSpec capability specifications.

## Impact

- Server: a new upload-follow-up job and queue handler, local Unsloth client/repository, structured response validation, atomic metadata-run claiming and state transitions, configuration, and tests.
- Database: no new table or migration is expected; the existing `asset_metadata` JSONB row stores the versioned document. Atomic row locking is required to avoid lost updates and duplicate claims.
- Web: read-only Info-panel metadata plus an optional fixed-position title and archive-summary overlay in the asset viewer, using the existing asset-metadata read API.
- Deployment: Immich Server needs a private Docker-to-host route to the local Unsloth endpoint and a persistently served Muse Glimmer quant. The source preview is bounded before base64 transfer to stay inside the dual-12-GB GPU budget.
- Security and privacy: no person-association context is sent, credentials and image payloads must not be logged, the metadata key is server-managed, and normal asset-view permissions continue to gate reads.
