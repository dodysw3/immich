## ADDED Requirements

### Requirement: Automatically schedule new image interpretation
The system SHALL schedule an AI interpretation only after a newly uploaded, visible image asset has successfully generated its preview and the feature is enabled.

#### Scenario: Uploaded image preview completes
- **WHEN** preview generation succeeds for a visible image whose job source is `upload`
- **THEN** the system claims and queues the configured interpretation run asynchronously

#### Scenario: Unsupported asset or non-upload processing
- **WHEN** thumbnail generation completes for a video, PDF, hidden asset, library scan, thumbnail regeneration, or other non-upload source
- **THEN** the system does not claim or queue an interpretation run

#### Scenario: Feature is disabled
- **WHEN** an uploaded image preview completes while AI interpretation is disabled
- **THEN** the system does not create interpretation metadata or queue work

### Requirement: Enforce tuple-level at-most-once inference
The system MUST treat the exact `(model, quant, promptVersion)` tuple as the logical run identity for one asset and MUST make its first claim atomic across concurrent server processes.

#### Scenario: First tuple claim
- **WHEN** no run exists for the configured tuple on an asset
- **THEN** exactly one caller creates a `queued` run and queues a deterministic job for it

#### Scenario: Concurrent duplicate claims
- **WHEN** two or more callers concurrently claim the same asset and tuple
- **THEN** one caller creates the run and every other caller reports `alreadyExists` without queueing another inference

#### Scenario: Duplicate trigger for a live or completed run
- **WHEN** a run for the same tuple is already `queued`, `running`, or `completed`
- **THEN** the trigger is ignored and the stored run is not replaced, reset, or rerun

#### Scenario: Trigger on a failed run
- **WHEN** a run for the same tuple is already `failed`
- **THEN** the trigger resets that run to `queued` while preserving its attempt history and last error, and the inference is processed again

#### Scenario: Duplicate queue delivery
- **WHEN** a worker receives a job whose run is not in `queued` status
- **THEN** the worker exits without calling Unsloth

#### Scenario: Different experiment identity
- **WHEN** model, quant, or promptVersion differs from all existing runs on the asset
- **THEN** the new tuple can be claimed while all prior runs remain unchanged

### Requirement: Persist a versioned multi-run metadata document
The system SHALL store AI interpretation state under asset metadata key `ai-interpretation-v1` with `schemaVersion: 1` and a `runs` object keyed by the deterministic digest of the tuple.

#### Scenario: Successful inference
- **WHEN** Unsloth returns output that passes the response schema
- **THEN** the system stores model, quant, promptVersion, completed status, timestamps, bounded-input details, structured result, and available timing/token metrics in that run

#### Scenario: Failed inference
- **WHEN** preview loading, transport, timeout, JSON parsing, or schema validation fails
- **THEN** the system stores a `failed` status with a sanitized error and an incremented attempt count without replacing other runs or sending another immediate inference request

#### Scenario: Concurrent updates to different runs
- **WHEN** two workers update different run keys in the same metadata document
- **THEN** both updates are serialized and neither run is lost

#### Scenario: Client attempts to mutate reserved metadata
- **WHEN** a generic asset-metadata write or delete request targets `ai-interpretation-v1`
- **THEN** the server rejects the mutation while continuing to allow authorized reads

### Requirement: Retry failed runs until they converge
The system SHALL automatically re-dispatch failed interpretation runs with exponentially increasing delays capped at one day and no attempt limit, so interpretation eventually converges when the local endpoint recovers, while manual re-runs remain available at any time.

#### Scenario: Failure schedules a backoff retry
- **WHEN** a run fails with a retryable error (preview, transport, timeout, parsing, schema, or endpoint failure)
- **THEN** the run records the attempt count and a `nextAttemptAt` timestamp computed as exponentially increasing delay starting at two minutes and capped at twenty-four hours

#### Scenario: Non-retryable failure
- **WHEN** a run fails because the feature is disabled
- **THEN** no automatic retry is scheduled, and a manual re-run remains possible

#### Scenario: Reconcile dispatches due retries
- **WHEN** the periodic reconcile pass finds failed runs whose `nextAttemptAt` has elapsed
- **THEN** each run is reset to `queued` exactly once and a deterministic interpretation job is queued for it

#### Scenario: Stale run re-entry
- **WHEN** a `queued` or `running` run expires before completion (for example a server restart lost the job)
- **THEN** the run is marked `failed` with an incremented attempt count and re-enters the retry backoff schedule

#### Scenario: Lost retry job
- **WHEN** a requeued job is lost before processing (for example a queue restart)
- **THEN** the periodic stale-run handling fails the run again and the retry schedule re-arms without human intervention

### Requirement: Use local Muse Glimmer inference
The system SHALL use the configured private OpenAI-compatible Unsloth endpoint with model `unsloth/Muse-Glimmer-30B-GGUF`, serving quant `UD-Q3_K_XL`, for the initial prompt version.

#### Scenario: Inference request
- **WHEN** a worker atomically transitions a run from `queued` to `running`
- **THEN** it sends one multimodal chat-completion request with the configured model, versioned prompt, bounded preview, low temperature, and structured JSON response constraint

#### Scenario: Endpoint is unavailable or response is uncertain
- **WHEN** the local endpoint cannot be reached, times out, or has an indeterminate outcome
- **THEN** the worker records the run as failed and does not retry the outbound inference for that tuple

#### Scenario: Credentials and image payload handling
- **WHEN** the service logs request lifecycle or errors
- **THEN** it omits bearer credentials, base64 image bytes, and raw private image content

### Requirement: Bound image input for GPU safety
The system MUST use the generated image preview, apply orientation, and enforce configured maximum dimensions and decoded pixels before encoding the inference input.

#### Scenario: Preview exceeds the inference bound
- **WHEN** either preview dimension exceeds the configured maximum edge
- **THEN** the system proportionally downsizes the preview before calling Unsloth

#### Scenario: Preview is absent or invalid
- **WHEN** the asset's generated preview cannot be found, decoded, or bounded safely
- **THEN** the system marks the run failed and never falls back to the original asset

#### Scenario: Upload burst
- **WHEN** multiple uploaded images await interpretation
- **THEN** a dedicated queue processes no more than the configured concurrency, initially one

### Requirement: Exclude Immich person identity context
The system MUST NOT provide Immich person IDs, person associations, face matches, associated names, or face crops to the interpretation prompt.

#### Scenario: Asset has named people
- **WHEN** an image with one or more Immich person associations is interpreted
- **THEN** the request contains only the bounded image and versioned prompt, with no associated identity context

#### Scenario: Model believes a famous person is visible
- **WHEN** the model has great confidence that clear visual evidence depicts a widely known public figure
- **THEN** it may include the name as a high-confidence model claim with its visual basis and uncertainty rules

#### Scenario: Person identity is uncertain
- **WHEN** the model cannot meet the great-confidence public-figure condition
- **THEN** it describes the person generically and does not put a guessed name in the title, summary, or keywords

#### Scenario: Interpretation completes with a person identification
- **WHEN** any person name appears in model output
- **THEN** the system stores it only in the interpretation result and does not create or change Immich people, face matches, tags, descriptions, or EXIF metadata

### Requirement: Produce structured archival interpretation
The versioned prompt SHALL require JSON fields for title, literal description, visual analysis, interpretation, context and significance, notable details, identifications, alternative interpretations, uncertainties, archive summary, and search keywords.

#### Scenario: Observation and inference are separated
- **WHEN** the model describes uncertain meaning, authorship, location, event, or identity
- **THEN** it places the claim in an interpretive or uncertainty field rather than presenting it as direct observation

#### Scenario: Low-confidence identification
- **WHEN** an identification has low confidence
- **THEN** the model does not promote it into the title, archive summary, or search keywords

#### Scenario: Semantic prompt changes
- **WHEN** prompt wording or its required output semantics change
- **THEN** the implementation increments promptVersion so the result is stored as a separate run

### Requirement: Display raw interpretation metadata
The image Info panel SHALL retrieve `ai-interpretation-v1` through the existing authorized metadata read API and render its value as escaped, formatted, read-only JSON.

#### Scenario: Metadata exists
- **WHEN** an authorized viewer opens the Info panel for an image with `ai-interpretation-v1`
- **THEN** the panel shows an AI-generated label and the complete formatted metadata value in a readable raw block

#### Scenario: Metadata does not exist
- **WHEN** the metadata-by-key endpoint reports that `ai-interpretation-v1` is absent
- **THEN** the panel omits the interpretation section without showing an error

#### Scenario: Asset navigation or fetch failure
- **WHEN** the viewer changes assets or the metadata request fails
- **THEN** stale JSON is not shown and the rest of the Info panel remains usable

#### Scenario: Raw output contains markup-like text
- **WHEN** a stored model result contains HTML or script-like characters
- **THEN** the panel renders them as text rather than executable markup

### Requirement: Manually schedule existing image interpretation
The system SHALL provide an authorized owner action in the photo viewer to request interpretation for an existing image without interpretation metadata.

#### Scenario: Manual action on an existing image
- **WHEN** an owner selects `Interpret image` for a visible image with a generated preview and no run for the configured tuple
- **THEN** the server queues an asynchronous interpretation job that claims and processes that tuple through the same guarded worker path as uploads

#### Scenario: Manual action on a failed run
- **WHEN** an owner selects `Interpret image` and the configured tuple is `failed`
- **THEN** the run is reset to `queued` (attempt history and last error preserved) and a fresh asynchronous interpretation is processed through the same guarded worker path

#### Scenario: Manual action on a queued, running, or completed run
- **WHEN** an owner selects `Interpret image` and the configured tuple is already `queued`, `running`, or `completed`
- **THEN** the action does not reset the stored run or issue another Unsloth request

#### Scenario: Manual action on an unsupported asset or disabled feature
- **WHEN** an owner selects `Interpret image` for a non-image, hidden image, image without a generated preview, or while the feature is disabled
- **THEN** no inference request is sent and the existing metadata remains unchanged

### Requirement: Toggle latest interpretation overlays in the photo viewer
The photo viewer SHALL offer an interpretation toggle when an authorized image metadata read returns `ai-interpretation-v1`.

#### Scenario: Toggle displays the latest completed result
- **WHEN** the viewer has interpretation metadata with a latest completed run containing string result fields and the viewer toggle is enabled
- **THEN** it renders the title fixed at the screen-relative top left in bold white text with a black shadow and renders the available interpretation and archive summary at the screen-relative bottom in the template `[I] <interpretation> // [S] <archive_summary>` using smaller non-bold white text with the same shadow

#### Scenario: Toggle displays notable details
- **WHEN** the latest completed result contains valid `result.notable_details`
- **THEN** it renders each `detail` as a rounded tag on its own line above the summary, sorted by confidence from highest to lowest, color-coded by confidence, and shows its `significance` in a hover tooltip

#### Scenario: Overlay content does not follow image transforms
- **WHEN** the viewer image is zoomed or panned while interpretation overlays are enabled
- **THEN** the title and archive summary remain screen-relative and do not move with the image

#### Scenario: Long summary remains readable and unobstructed
- **WHEN** the interpretation summary is long or the viewer has action buttons or the Info panel open
- **THEN** the summary wraps within the available screen space and reserves room so it does not overlap the controls or panel

#### Scenario: Missing metadata or fields
- **WHEN** the metadata read is absent, fails, or the latest run lacks valid title, interpretation, archive summary, and notable-detail fields
- **THEN** the interpretation toggle or individual empty overlay is omitted without showing an error in the viewer

#### Scenario: Navigation resets the overlay
- **WHEN** the viewer navigates to another asset
- **THEN** the prior asset's metadata and overlay visibility are cleared before the new asset metadata is applied

#### Scenario: Toggle state persists in the browser session
- **WHEN** a viewer enables or disables the interpretation toggle and later navigates to another asset or page in the same browser session
- **THEN** a new viewer instance restores the same toggle state from session storage once the asset metadata is available
