## 1. Contracts and configuration

- [x] 1.1 Add the `ai-interpretation-v1` metadata-key constant, run identity/status types, full metadata document schema, and Muse result validation schema.
- [x] 1.2 Add the exact `image-interpretation-1.0.0` prompt and deterministic SHA-256 tuple-to-run-key helper, with snapshot/unit tests that make prompt changes deliberate.
- [x] 1.3 Add server-only feature settings for enabled state, private Unsloth base URL/credential, fixed model and quant, prompt version, 15-minute timeout, 1600-pixel maximum edge, decoded-pixel limit, and queue concurrency defaulting to one.
- [x] 1.4 Reject generic metadata PUT/DELETE operations for the reserved key while preserving permission-checked metadata reads; cover single and bulk mutation routes with tests.

## 2. Atomic metadata lifecycle

- [x] 2.1 Implement typed repository methods that transactionally create/read/merge `ai-interpretation-v1` while locking concurrent first inserts and subsequent row updates.
- [x] 2.2 Implement an atomic claim that creates one `queued` run for a missing `(model, quant, promptVersion)` and returns `alreadyExists` for every existing status.
- [x] 2.3 Implement guarded `queued -> running` and `running -> completed|failed` transitions that update only the target run and preserve all other runs.
- [x] 2.4 Add repository/service tests for simultaneous identical claims, different tuples, concurrent run updates, malformed stored documents, and terminal-run immutability.

## 3. Bounded image and local inference client

- [x] 3.1 Resolve only the generated unedited preview for an image and prepare an orientation-correct JPEG bounded by configured edge and decoded-pixel limits, with no original-file fallback.
- [x] 3.2 Implement the private OpenAI-compatible multimodal chat-completion client for Muse Glimmer with low temperature, structured response mode, output-token limit, timeout, response parsing, and schema validation.
- [x] 3.3 Ensure client observability records useful timing/token data and sanitized error codes without logging credentials, base64 bytes, or image contents.
- [x] 3.4 Add tests for downsizing, orientation, missing/invalid/oversized previews, valid output, malformed/truncated output, timeout, endpoint errors, and secret/payload redaction.

## 4. Asynchronous orchestration and idempotency

- [x] 4.1 Add the image-interpretation queue and job types, register the handler/service in the server module, expose normal queue health/metrics, and set default concurrency to one.
- [x] 4.2 Extend successful thumbnail-job follow-up handling to claim and enqueue interpretation only for enabled, visible image uploads after preview generation.
- [x] 4.3 Implement the worker so only a successful `queued -> running` transition can issue the single outbound Unsloth request, and all duplicate deliveries exit as skipped.
- [x] 4.4 On preview, network, timeout, JSON, or validation errors, store a terminal sanitized failure without outbound retry; on success, store the structured result and metrics.
- [x] 4.5 Add startup/periodic reconciliation that marks stale `queued` or `running` runs failed without requeueing or calling Unsloth.
- [x] 4.6 Add orchestration tests for disabled mode, upload/non-upload sources, unsupported/hidden assets, deterministic BullMQ job IDs, duplicate events, duplicate deliveries, ambiguous failure, and stale-run reconciliation.

## 5. Raw image Info-panel display

- [x] 5.1 Add a read-only detail-panel component that fetches `ai-interpretation-v1` with the existing SDK metadata-by-key call and renders `metadata.value` as escaped, pretty-printed JSON under an AI-generated label.
- [x] 5.2 Integrate the component for image assets, hiding it when metadata is absent and clearing stale state when navigation changes the selected asset.
- [x] 5.3 Add localization strings and component tests for present, absent, loading, failed-fetch, asset-switch, long JSON, and markup-like output cases.

## 6. Private deployment wiring

- [x] 6.1 Add and document a narrowly scoped Docker-to-host route or authenticated local proxy to `127.0.0.1:8888/v1`; do not expose the unauthenticated Unsloth API to the LAN.
- [x] 6.2 Configure Unsloth to persistently serve `unsloth/Muse-Glimmer-30B-GGUF` `UD-Q3_K_XL`, verify the actual loaded profile, and confirm Immich Server can reach the completion endpoint before enabling the feature.
- [x] 6.3 Document feature flags, secret handling, preview/concurrency tuning, failure semantics, prompt-version rules, and disable-only rollback in the deployment/operations documentation.

## 7. Verification and rollout

- [x] 7.1 Run server lint/type checks and focused unit/integration tests, then run web Svelte and TypeScript checks plus focused component tests.
- [x] 7.2 With a request-capturing test double, verify that inference receives only the bounded preview and versioned prompt—never filename, EXIF/GPS, OCR, tags, person IDs, face matches, names, or face crops.
- [x] 7.3 Upload representative artwork and airport photos and verify asynchronous completion, valid structured metadata, exact model/quant/prompt provenance, and raw Info-panel rendering.
- [x] 7.4 Replay the upload trigger and BullMQ delivery concurrently and verify from client-call metrics/logs that the same tuple produces no second Unsloth request.
- [x] 7.5 Change only promptVersion in a test configuration and verify a second run is appended without modifying the first; verify a failed old tuple remains ineligible.
- [x] 7.6 Monitor both GPUs during the representative run, confirm input dimensions obey the bound and VRAM remains within both 12-GB limits, then enable automatic processing for new uploads.

## 8. Manual photo-viewer trigger

- [x] 8.1 Extend the asset-job contract and SDK with an `interpret-image` action.
- [x] 8.2 Route manual jobs through the guarded interpretation worker, claiming only a missing configured tuple and preserving terminal-run immutability.
- [x] 8.3 Add the owner-only photo-viewer action, localization, tests, and live verification on an existing image.

## 9. Photo-viewer interpretation overlays

- [x] 9.1 Add a metadata-backed interpretation toggle beside the existing OCR and face-recognition viewer controls.
- [x] 9.2 Extract the latest completed run's title and archive summary, rendering fixed screen-relative overlays with responsive wrapping and reserved control/panel space.
- [x] 9.3 Add localization and component tests for metadata presence, latest-run selection, toggle state, navigation reset, missing fields, zoom independence, and long-summary layout classes.

## 10. Photo-viewer session preference

- [x] 10.1 Persist the interpretation toggle in session storage and restore it for subsequent viewer instances in the same browser session.
- [x] 10.2 Add regression coverage for enabling/disabling the toggle across asset and page navigation and safe fallback when session storage is unavailable.

## 11. Interpretation overlay details

- [x] 11.1 Render the interpretation/archive-summary template and confidence-sorted notable-detail tags with confidence colors and significance tooltips.
- [x] 11.2 Add component coverage for summary formatting, detail ordering, tag styling, and tooltip content.

## 12. Retry failed interpretations to eventual consistency (2026-09-12)

- [x] 12.1 Add optional `attempts` and `nextAttemptAt` fields to the run schema and clear them on completion.
- [x] 12.2 Add the exponential retry delay helper (2 min base, doubling, capped at 24 h) with unit coverage.
- [x] 12.3 Make `claim` reset a `failed` run to `queued` (attempt history preserved) so manual and upload triggers can re-run it; queued, running, and completed runs stay single-delivery.
- [x] 12.4 Record the attempt count and schedule `nextAttemptAt` on failure (except `feature_disabled`), including stale-run reaping.
- [x] 12.5 Add `requeue` and `findDueRetries` repository methods with guarded transitions and unit coverage.
- [x] 12.6 Dispatch due retries from the periodic reconcile pass and extend the service tests for retry scheduling and dispatch.
