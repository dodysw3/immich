## Context

Immich already has the primitives needed for this feature: generated preview files, BullMQ-backed asynchronous jobs, and per-asset JSONB metadata keyed by `(assetId, key)`. The asset viewer also has an Info panel and the SDK exposes the existing metadata-by-key read endpoint.

The selected inference service is a local Unsloth Studio/llama.cpp OpenAI-compatible endpoint serving `unsloth/Muse-Glimmer-30B-GGUF` with `UD-Q3_K_XL`. It runs on two 12-GB GPUs, so the server must send a bounded preview and serialize work conservatively. The Immich application runs in Docker while Unsloth currently listens on the host, so deployment must provide a private Docker-to-host route.

The metadata document must preserve multiple experiments but prevent a second inference call for the same `(model, quant, promptVersion)` tuple. This requires atomic server-side claiming; a client-side existence check or BullMQ job ID alone is not sufficient under concurrent uploads or duplicate deliveries.

## Goals / Non-Goals

**Goals:**

- Run one asynchronous local-VLM interpretation for each newly uploaded image after its preview exists.
- Make the inference identity and exact prompt version visible and reproducible.
- Preserve outputs from different model, quant, or prompt-version combinations in one metadata document.
- Guarantee that only one worker can claim a tuple and that duplicate events/jobs do not call the model again.
- Allow an authorized owner to manually request interpretation for an existing image from the photo viewer.
- Send no Immich person IDs, face matches, or associated names to the model.
- Keep GPU use bounded, expose the stored JSON in a minimal read-only Info-panel view, and provide an optional fixed-position viewer overlay for the latest result.

**Non-Goals:**

- Bulk backfill and deletion/reset of server-owned runs.
- A polished prose UI, editing model output, or using interpretation text for search.
- Video, PDF, Live Photo motion, or hidden-asset interpretation.
- Managing Unsloth model loading from Immich or automatically switching serving profiles.
- Creating or changing Immich people, face matches, tags, descriptions, or EXIF fields.
- Exactly-once completion across an indeterminate network failure. The stricter invariant is at most one outbound inference request per claimed tuple.

## Decisions

### 1. Trigger after successful preview generation

Add an `AssetInterpretImage` job to the successful `AssetGenerateThumbnails` follow-up path in `JobService`. Queue it only when `item.data.source === 'upload'`, the feature is enabled, and the asset is a visible `AssetType.Image`. This point is later than metadata extraction and guarantees the generated preview file is available.

The job data contains only `assetId` and the computed run identity. It contains no person data. Library scans, thumbnail regeneration, editor updates, videos, PDFs, and backfill queues do not trigger interpretation in this version.

Alternative considered: subscribing to `AssetMetadataExtracted`. That event can occur before preview generation, so the worker would need race-prone polling or an original-file fallback.

### 2. Use a dedicated single-concurrency queue

Add `QueueName.ImageInterpretation` and assign `AssetInterpretImage` to it with default concurrency `1`. BullMQ provides buffering and operational visibility while one active request limits peak local-GPU pressure. A later benchmark may safely raise concurrency without changing stored identities or behavior.

Alternative considered: reuse `BackgroundTask`. Its unrelated concurrency and workload make GPU pressure less predictable.

### 3. Represent each tuple with a deterministic run key

The logical unique identity is:

```text
(model, quant, promptVersion)
```

The JSON object key `runKey` is the lowercase SHA-256 hex digest of the canonical UTF-8 string:

```text
model + "\n" + quant + "\n" + promptVersion
```

The unhashed fields are also stored in every run for readability. A digest avoids JSON-path escaping problems caused by repository slashes and punctuation while preserving exact tuple equality.

The value under asset metadata key `ai-interpretation-v1` has this shape:

```json
{
  "schemaVersion": 1,
  "runs": {
    "<runKey>": {
      "model": "unsloth/Muse-Glimmer-30B-GGUF",
      "quant": "UD-Q3_K_XL",
      "promptVersion": "image-interpretation-1.0.0",
      "status": "queued | running | completed | failed",
      "trigger": "upload",
      "requestedAt": "ISO-8601 timestamp",
      "startedAt": "ISO-8601 timestamp or absent",
      "finishedAt": "ISO-8601 timestamp or absent",
      "input": {
        "source": "preview",
        "width": 0,
        "height": 0,
        "mimeType": "image/jpeg"
      },
      "result": {},
      "error": {
        "code": "stable_machine_code",
        "message": "sanitized operator-facing message"
      },
      "metrics": {
        "durationMs": 0,
        "promptTokens": 0,
        "completionTokens": 0
      }
    }
  }
}
```

`result` exists only for `completed`; `error` exists only for `failed`; token counts are optional when the endpoint does not return them. Timestamps and source dimensions make the result auditable without storing another copy of the image.

Alternative considered: one metadata row per run. That would make database uniqueness simpler but would violate the selected single `ai-interpretation-v1` structure and make raw retrieval fragmented.

### 4. Claim and update runs atomically in PostgreSQL

Create typed repository methods for this server-owned document. In a transaction, take a row-level lock on `(assetId, 'ai-interpretation-v1')`; when the row does not yet exist, also use a deterministic PostgreSQL transaction advisory lock so concurrent first inserts serialize. Read and validate the whole document, then:

1. If `runs[runKey]` exists in any status, return `alreadyExists` without mutating it.
2. Otherwise insert the `queued` entry and commit the claim.
3. Enqueue a deterministic BullMQ job ID derived from `assetId` and `runKey`.

The handler atomically changes only `queued -> running`. A delivery observing `running`, `completed`, or `failed` exits as skipped. Completion/failure updates merge only that run under the same lock, preserving other experiments.

The generic client metadata PUT and DELETE paths reject the reserved key so a client cannot bypass the invariant. Existing read permission remains authoritative.

There is no automatic second inference request after the handler starts the outbound call. A transport timeout, invalid JSON, schema failure, or uncertain response is recorded as `failed`. A startup reconciliation pass may mark stale `queued`/`running` entries failed, but must not requeue them. This honors the requirement that an existing tuple is never redone. A future explicit admin reset workflow can be designed separately.

### 5. Send a bounded generated preview, never the original

Resolve the unedited `AssetFileType.Preview` generated by Immich. Decode it with orientation applied and downscale only if necessary to a configurable maximum edge of `1600` pixels, with an additional maximum decoded-pixel guard. Encode as JPEG at quality 85 before base64 transfer. Never fall back to the original asset; a missing or unreadable preview produces a failed run.

This size is deliberately below the preview used in the local Muse benchmark and leaves headroom on the dual-12-GB setup. The bound and queue concurrency remain configuration values so they can be tuned without changing the output schema. Image bytes/base64 and credentials are never logged.

### 6. Use a one-shot, schema-constrained OpenAI-compatible request

Introduce a small `ImageInterpretationRepository` rather than coupling this archival feature to Immich's CLIP/face ML client. It calls `${baseUrl}/chat/completions` with the selected model, the versioned text prompt, one base64 preview, low temperature (`0.2`), and an output budget of 6400 tokens to accommodate the deployed Muse serving limit. Use `response_format: json_schema` when supported by the deployed llama.cpp server; always validate the returned JSON with the server schema. The request also includes a concise field-shape reminder because the deployed compatibility layer accepts the schema envelope but may otherwise omit required properties.

The request timeout must be long enough for the local 30B model (initial default: 15 minutes). Do not have Immich call Unsloth's model-load endpoint. Deployment is responsible for keeping the exact Muse/quant profile loaded. Because the OpenAI model list may not prove the quant, stored quant provenance is the operator-configured serving profile and should be verified during deployment.

### 7. Version and store the exact prompt

Keep the prompt in a dedicated server source file alongside the output schema. Any semantic prompt or schema change increments `promptVersion`, which intentionally creates a new eligible run.

Initial system prompt (`image-interpretation-1.0.0`):

```text
You are an archival image interpreter. Analyze only evidence visible in the supplied image. Distinguish direct observation from interpretation and from uncertain contextual inference. Explain not only what is present, but how composition, gesture, light, setting, and relationships may shape the image's meaning.

No Immich face matches, person IDs, or associated names are provided. Do not guess or invent a person's identity. You may name someone only when they are a widely known public figure and you have great confidence from clear, distinctive visual evidence in this image. Otherwise use a generic description such as "a person" and put the identity limitation in uncertainties. A name is a model claim, not a verified fact. Do not infer sensitive personal traits. Do not infer exact places, dates, authorship, brands, or events unless visible evidence strongly supports them.

Return only JSON matching the supplied schema. Keep literal_description observational. Put hypotheses in interpretation or alternative_interpretations, state their evidence, and include meaningful uncertainty. Never promote a low-confidence identification into title, archive_summary, or search_keywords.
```

Initial result schema:

```json
{
  "title": "string",
  "literal_description": "string",
  "visual_analysis": "string",
  "interpretation": "string",
  "context_and_significance": "string",
  "notable_details": [
    { "detail": "string", "significance": "string", "confidence": "high | medium | low" }
  ],
  "identifications": [
    {
      "name": "string",
      "type": "person | place | artwork | object | organization | other",
      "confidence": "high | medium | low",
      "basis": "string"
    }
  ],
  "alternative_interpretations": ["string"],
  "uncertainties": ["string"],
  "archive_summary": "string",
  "search_keywords": ["string"]
}
```

The application sends no filename, EXIF, GPS, captions, tags, OCR text, face crops, or person associations in v1. This makes the output an image-only interpretation and keeps prompt experiments comparable.

### 8. Render the raw document in the Info panel

Add a small `DetailPanelAiInterpretation` component near the existing description/people sections. On image assets, request metadata key `ai-interpretation-v1` through the existing generated SDK function. Hide the section on the endpoint's not-found response. When present, show a localized heading and a scrollable, wrapping `<pre>` containing `JSON.stringify(metadata.value, null, 2)`.

The component is read-only and exposes no retry/delete controls. It relies on normal asset-read authorization and handles loading, navigation between assets, and request failure without breaking the rest of the Info panel.

### 9. Configure connectivity without exposing Unsloth publicly

Add server-side settings for enabled state, private base URL, API credential if used, model, quant, prompt version, timeout, maximum preview edge, and queue concurrency. Secrets are accepted from deployment configuration and are never returned to the web client.

For this installation, route the Immich Server container to a narrowly bound host proxy or Docker host-gateway address that forwards to Unsloth on `127.0.0.1:8888/v1`. Do not bind an unauthenticated Unsloth API to the LAN. A deployment health check must confirm the configured model endpoint is reachable and the intended Muse Q3 profile is loaded before enabling automatic jobs.

### 10. Reuse the asset-job endpoint for manual interpretation

Extend the existing `AssetJobName` contract with `interpret-image` and expose it as an owner-only image action in the photo viewer's action menu. The action submits the existing `POST /assets/jobs` request, preserving the normal asset permission checks and queue observability.

The server queues an `AssetInterpretImage` delivery without a run key for this action. The worker claims the configured `(model, quant, promptVersion)` tuple immediately before processing. A missing tuple is interpreted; any existing `queued`, `running`, `completed`, or `failed` tuple is skipped. This supports older images that have no interpretation metadata without weakening the at-most-once or terminal-run guarantees. The action is a request control, not a reset/retry control; the Info panel can be reopened after the asynchronous job completes to view the result.

### 11. Toggle fixed-position interpretation overlays

Add a viewer control alongside the existing OCR and face-recognition controls when the authorized metadata read returns `ai-interpretation-v1`. Select the latest run by `requestedAt`; only a completed run with a structured `result` contributes overlay text. The toggle is reset when the viewer navigates to another asset.

Render `result.title` in a fixed screen-relative top-left container using bold, white text with a black shadow. Render the bottom content in a fixed screen-relative container using smaller, non-bold white text with the same shadow. When present, the summary uses `[I] result.interpretation // [S] result.archive_summary`; absent or non-string parts are omitted while preserving the available prefix. Render valid `result.notable_details` above the summary as one rounded tag per line, sorted by confidence from high to low, with confidence-specific colors and the significance shown in a hover tooltip. Both containers wrap and reserve space for the viewer controls and detail panel; they do not render inside the zoomable image overlay slot, so image zoom and pan do not move them. Missing or non-string fields are omitted without affecting the toggle or Info panel.

### 12. Persist the viewer toggle for the browser session

Store the boolean overlay preference in `sessionStorage` under a namespaced key. Initialize each viewer instance from that value and write it whenever the user toggles the control. Do not use durable local storage: closing the browser session clears the preference, while navigating between assets or routes in the same session restores it. Metadata and overlay content still remain asset-specific and are cleared while a new asset's metadata request is pending.

## Risks / Trade-offs

- **Model hallucination, especially names and artwork attribution** → Separate observations from inference, require uncertainty, permit public-person names only at high confidence, display raw provenance, and never alter person records automatically.
- **A failed/ambiguous request cannot be retried under the strict tuple rule** → Record a clear failed state and error; use a new prompt version for the initial release. Design an explicit audited reset later if operational experience requires it.
- **Process death between database claim and queue insertion can leave `queued` forever** → Mark stale claims failed during reconciliation and never automatically requeue. This favors the user's no-redo guarantee over eventual completion.
- **JSONB read-modify-write can lose concurrent experiments** → Serialize both first insert and subsequent updates with transaction/advisory locks and validate the whole document before commit.
- **Large previews or concurrent requests can exhaust VRAM** → Enforce max dimensions/pixels, use the preview only, keep the dedicated queue at concurrency one, and set request-size limits.
- **Configured quant provenance may not match the actually served quant** → Verify the Unsloth serving profile during deployment and surface the configured identity in every stored run.
- **Raw JSON may be visually noisy or include an unsafe model claim** → Label it as AI-generated, keep it read-only, escape through normal Svelte text rendering, and defer a curated UI until the schema proves stable.
- **Metadata documents can grow with many experiments** → Accept bounded growth for the experiment phase; later add retention/export tooling if needed.

## Migration Plan

1. Add schemas, typed storage/locking methods, the reserved metadata key, and tests without enabling inference.
2. Add the Unsloth client, job type/queue/handler, post-preview trigger, and server configuration; default the feature to disabled.
3. Add the raw Info-panel component and web tests.
4. Configure the private Docker-to-host endpoint, ensure Muse Glimmer `UD-Q3_K_XL` is persistently served, and run a health/preflight check.
5. Enable the feature and upload two representative photos; verify one completed run per tuple, no person-association context in the request, bounded preview dimensions, and raw Info-panel rendering.
6. Send duplicate event/job deliveries and confirm that no second Unsloth request occurs.
7. Use the photo viewer action on an existing image without interpretation metadata and verify that it queues the same guarded worker path.

Rollback by disabling the feature and stopping the new queue consumer. Existing `ai-interpretation-v1` metadata remains readable and syncable; no database rollback is required. Removing stored results is intentionally not part of rollback.

## Open Questions

- Confirm whether the deployed llama.cpp build accepts strict `json_schema`; if not, use `json_object` plus the same server-side validation without changing the prompt version unless prompt text changes.
- Confirm the private container-to-host URL and whether the local proxy requires a bearer token.
- Confirm whether this fork's preferred queue concurrency setting belongs in system configuration or deployment-only environment configuration; the behavioral default remains one.
