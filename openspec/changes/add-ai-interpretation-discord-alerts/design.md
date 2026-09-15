## Context

The image-interpretation worker already owns the guarded transition from a run in `running` state to a persisted `completed` result. The same asset lookup exposes the asset owner and generated image files, while Immich's existing notification queue provides an appropriate failure boundary for outbound delivery.

This installation has multiple Immich accounts but will use one shared Discord destination. Each alert therefore needs an owner label. The integration is outbound-only: Discord incoming webhooks accept rich embeds and multipart file attachments without requiring a Discord bot or a persistent connection.

Discord becomes a new privacy boundary. Interpretation text and account identity always leave Immich when alerts are enabled, and generated thumbnails leave Immich by default. Configuration and documentation must make that behavior explicit.

## Goals / Non-Goals

**Goals:**

- Enqueue an alert without intentional delay after a newly completed interpretation is durably stored.
- Keep interpretation success independent from Discord availability and alert-delivery failures.
- Label every alert with the owning Immich account name, using email only when the name is empty.
- Present the result as a compact Discord embed with title, original filename, summary, the photo date, the live waiting-queue count, and an authenticated Immich link when an external domain is configured.
- Attach the generated unedited thumbnail by default and allow operators to disable all thumbnail uploads.
- Retry transient Discord failures and suppress ordinary duplicate queue deliveries for the same asset/run.
- Keep credentials, image bytes, and full webhook URLs out of logs.

**Non-Goals:**

- Telegram support, Discord bot commands, direct messages, interactive controls, or inbound Discord events.
- Separate Discord destinations or notification preferences per Immich account.
- Sending original assets, previews, edited images, videos, PDFs, or hidden assets.
- A web-admin settings screen; the first version is deployment-configured.
- A transactional database outbox or a mathematical exactly-once guarantee across an ambiguous external response.
- Alerting on queued, running, failed, retried-but-still-failed, or historical completed runs.

## Decisions

### 1. Use one Discord incoming webhook configured by environment

Add server-only environment settings:

```text
IMMICH_AI_IMAGE_INTERPRETATION_DISCORD_WEBHOOK_URL=<optional HTTPS Discord webhook URL>
IMMICH_AI_IMAGE_INTERPRETATION_DISCORD_INCLUDE_THUMBNAIL=true
```

The presence of the webhook URL enables alerts; a separate enabled flag would create invalid combinations without adding value. Thumbnail inclusion defaults to `true` when omitted. Validate the URL at startup as HTTPS and as a Discord webhook endpoint. Never expose either setting through user/public configuration DTOs or log the webhook URL, whose path contains the credential.

Alternative considered: store the webhook in Immich system configuration. That would require new admin UI/API handling and careful secret redaction, which is unnecessary for this deployment-scoped integration.

### 2. Queue only after a successful guarded completion

Capture the boolean returned by `AiImageInterpretationRepository.complete`. Only when it returns `true` and a webhook URL is configured does the worker enqueue `SendAiInterpretationDiscordAlert` immediately. The alert job uses the existing `QueueName.Notification` queue and carries only `assetId` and `runKey`.

The queue operation must sit outside the inference failure path: failure to enqueue or deliver an alert must never call `fail` on a completed interpretation. Enqueue failures are logged as alert failures with sanitized context.

Use a deterministic BullMQ job identity derived from `assetId`, `runKey`, and the Discord-alert job name. The alert handler also re-reads the stored run and proceeds only when it remains completed. This suppresses duplicate internal deliveries without claiming exactly-once behavior from an external HTTP API.

Alternative considered: send the webhook inline from the interpretation handler. That couples Discord latency and failure to GPU job completion and risks misclassifying a successfully persisted interpretation as failed.

Alternative considered: add a transactional alert outbox table. It would close the small process-crash window between interpretation commit and queue insertion, but adds a migration and reconciliation lifecycle beyond the reliability requested for the first version. The plan retains this as a future hardening option.

### 3. Resolve authoritative alert data when the notification job runs

The notification handler reads the completed run by `assetId` and `runKey`, then reads the asset and its owner. It formats the owner as:

```text
user.name.trim() || user.email
```

The email is therefore a fallback, not routinely disclosed. If the asset, completed run, or owning user no longer exists, the job exits as skipped because it can no longer construct an authorized, useful alert. Reading current state keeps the queue payload small and avoids copying interpretation text or account information into Redis.

Alternative considered: put the complete result and account name into the queued payload. This survives asset deletion but duplicates potentially sensitive content in Redis and can alert for content that no longer exists.

### 4. Send a constrained embed and prevent mention injection

The Discord request uses `wait=true` so a successful response confirms message creation. The embed contains:

- title: the interpreted title, falling back to `AI interpretation complete`;
- account field: resolved owner label;
- filename field: the asset's original filename, bounded to Discord's field limit;
- queue field: the current number of image-interpretation jobs waiting to start;
- description: a bounded archive summary, falling back to a bounded interpretation excerpt;
- URL: `<externalDomain>/photos/<assetId>` only when Immich has an explicit external domain;
- timestamp: the asset's capture instant, using EXIF `dateTimeOriginal` when an explicit timezone is recorded and otherwise interpreting `localDateTime` as an `Asia/Jakarta` wall clock;
- thumbnail: an uploaded attachment when enabled and available.

All model- and user-controlled strings are truncated to Discord's field limits. Set `allowed_mentions.parse` to an empty list so names or model output cannot trigger `@everyone`, role, or user mentions. Use a short request timeout and accept no redirects, preventing the secret-bearing webhook request from being redirected to another host.

Resolve the queue count at alert-delivery time through `JobRepository.getJobCounts(QueueName.ImageInterpretation)` and show only its `waiting` count. Excluding active jobs avoids counting the just-completed interpretation during the brief interval before its worker records completion; delayed retries are also not presented as immediately waiting work.

Alternative considered: plain message content. Embeds give predictable field boundaries, a compact thumbnail position, and safer formatting for model-generated text.

Immich stores `localDateTime` as a timezone-less wall clock encoded in a UTC-shaped database timestamp. It must not be sent directly to Discord because Discord treats an ISO timestamp as an instant and applies the viewer's timezone again. When `asset_exif.timeZone` and `asset_exif.dateTimeOriginal` are both present, `dateTimeOriginal` is already the capture instant and is sent unchanged. Otherwise, the handler reinterprets the UTC-shaped components of `localDateTime` in `Asia/Jakarta` and sends the resulting instant. This makes a stored timezone-less `2026-09-13 12:10:59+00` render as 12:10:59 in Jakarta instead of 19:10:59.

### 5. Attach only the generated unedited thumbnail

When thumbnail inclusion is enabled, resolve `AssetFileType.Thumbnail` with `isEdited: false`, read that generated file, and upload it in the same multipart request. Reference the file from the embed as `attachment://ai-interpretation-thumbnail.<ext>` so Discord renders it in the small thumbnail position. Do not fall back to `Preview`, `FullSize`, or the original asset.

If the thumbnail is missing, unreadable, or in an unsupported format, log a sanitized warning and send the text/embed alert without a file. If thumbnail inclusion is disabled, do not resolve or read the thumbnail and send a JSON-only webhook request.

Alternative considered: expose an authenticated Immich thumbnail URL to Discord. Discord could not fetch it without an Immich session, and making it public would weaken asset authorization.

### 6. Retry transient delivery failures independently

Treat network failures, timeouts, HTTP 429, and HTTP 5xx responses as retryable notification-job failures. Configure a bounded attempt count with exponential backoff; respect Discord's `Retry-After` signal when available. Treat other HTTP 4xx responses as permanent configuration/payload failures and record a sanitized error without retrying indefinitely.

Never include the webhook URL, response bodies that might echo secrets, or thumbnail bytes in errors. Normal successful delivery returns `JobStatus.Success`; missing/deleted source state returns `JobStatus.Skipped`.

Because Discord has no idempotency key for incoming webhook execution, a process failure after Discord accepts a message but before the worker records success can produce a rare duplicate. Avoiding missed alerts is preferred to suppressing every possible duplicate.

### 7. Keep notification code provider-specific but isolated

Introduce a small Discord-alert client/service boundary rather than adding Discord concerns to the Unsloth client. The interpretation service only enqueues a typed job, while the notification handler owns account lookup, formatting, file attachment, HTTP behavior, and logging. This keeps a future Telegram implementation possible without pretending the two provider payloads are identical today.

## Risks / Trade-offs

- **Shared-channel privacy:** Every channel member can see all account names, interpretation summaries, and default thumbnails → Document the boundary prominently and allow thumbnail uploads to be disabled globally.
- **Webhook credential leakage:** Anyone with the URL can post to the channel → Keep it server-only, redact it from logs/errors, validate redirects, and support rotation by restarting with a new environment value.
- **Alert lost between commit and enqueue:** BullMQ cannot cover a process death before the alert job is inserted → Accept the narrow v1 window and identify a transactional outbox/reconciler as future hardening.
- **Rare duplicate after an ambiguous webhook outcome:** Discord provides no idempotency key → Use deterministic internal job IDs and bounded retries, while documenting at-least-once external delivery semantics.
- **Notification-queue backlog delays “immediate” delivery:** Email or other notification work may share the queue → Enqueue without delay and monitor queue latency; move to a dedicated outbound-alert queue only if operational data shows contention.
- **Account names can be duplicated:** The requested name label may not uniquely identify two accounts → Use email only for empty names in v1; adding an always-visible email or storage label remains a configurable future enhancement.
- **Thumbnail disappears before delivery:** Asset maintenance or deletion can remove files → Fall back to a text-only alert rather than failing the alert.
- **Discord payload limits:** Long model output can be rejected → Truncate every embed field deterministically and test boundary lengths.

## Migration Plan

1. Add typed environment configuration, job contract, Discord client, and focused tests while leaving the webhook URL unset.
2. Add post-completion enqueueing and the notification-queue handler, then run server lint, type checks, and focused unit tests.
3. Create a restricted Discord channel webhook, set the URL and default thumbnail setting in deployment configuration, rebuild, and restart Immich Server.
4. Upload photos from at least two Immich accounts and verify owner labels, filenames, small thumbnails, authenticated links, deduplication, and failure isolation.
5. Temporarily disable thumbnail inclusion and verify no image bytes are read or sent while text alerts continue.

Rollback by removing the webhook URL and restarting Immich Server. Existing interpretations and their metadata remain unchanged; queued alert jobs safely skip when the integration is no longer configured.

## Open Questions

None for the proposed scope. Per-account destinations and stronger outbox-backed delivery can be evaluated after observing the shared channel in use.
