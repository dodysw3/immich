## 1. Configuration and job contracts

- [x] 1.1 Add server-only environment parsing and typed configuration for the optional Discord webhook URL and thumbnail-inclusion boolean, defaulting thumbnail inclusion to true.
- [x] 1.2 Validate that configured webhook URLs use HTTPS and the supported Discord webhook endpoint shape, and add configuration tests for absent, valid, invalid, default-thumbnail, and disabled-thumbnail cases.
- [x] 1.3 Add the typed `SendAiInterpretationDiscordAlert` job payload containing only `assetId` and `runKey`, map it to `QueueName.Notification`, and assign a deterministic asset/run job identity with bounded exponential retry options.
- [x] 1.4 Register the Discord alert client and job-handling service in the server dependency graph without exposing configuration through public or user configuration DTOs.

## 2. Discord payload and transport

- [x] 2.1 Implement a provider-specific Discord alert client that executes the configured webhook with `wait=true`, a short timeout, redirects disabled, and `allowed_mentions.parse` empty.
- [x] 2.2 Implement bounded embed formatting for title fallback, account field, archive-summary/interpretation fallback, completion timestamp, and an optional `/photos/{assetId}` URL only when an explicit external domain exists.
- [x] 2.3 Implement JSON-only delivery without a thumbnail and multipart delivery that uploads a supported generated thumbnail and references it through an `attachment://` embed thumbnail URL.
- [x] 2.4 Classify network errors, timeouts, HTTP 429, and HTTP 5xx as retryable; classify other HTTP 4xx responses as permanent; and sanitize all logging/errors so webhook URLs, response bodies, and image bytes cannot appear.
- [x] 2.5 Add focused client/formatter tests for JSON and multipart requests, account/model mention suppression, every text-length boundary, link inclusion/omission, timeout, rate limiting, server errors, permanent client errors, and credential/payload redaction.
- [x] 2.6 Add the bounded original filename and photo-date timestamp to the Discord embed, and cover normal, mention-like, overlong filename, and distinct photo/completion dates in formatter tests.
- [x] 2.7 Add an `AI interpretations waiting` field to the Discord embed and cover positive and zero counts in formatter tests.

## 3. Notification job handling

- [x] 3.1 Implement the notification-queue handler that reloads the target interpretation document, accepts only the requested completed run, and skips missing, deleted, or no-longer-completed source state.
- [x] 3.2 Resolve the asset owner at delivery time and format the account field as trimmed `user.name`, falling back to `user.email` only when the name is empty; skip when the owner is unavailable.
- [x] 3.3 When enabled, resolve only the generated unedited `AssetFileType.Thumbnail`; attach it when readable and supported, but fall back to text-only delivery on thumbnail absence/read/format failure without using any other asset file.
- [x] 3.4 When thumbnail inclusion is disabled, ensure the handler does not resolve or read image bytes and sends the JSON-only alert.
- [x] 3.5 Add handler tests for multiple owners, empty-name email fallback, duplicate names, missing owner/asset/run, configured/unconfigured integration, thumbnail default/disable/fallback, prohibited image fallbacks, and success/retry/permanent-failure job outcomes.
- [x] 3.6 Resolve the current asset's original filename and canonical photo date at delivery time and pass both to the Discord client with handler coverage.
- [x] 3.7 Read the live `waiting` count for `QueueName.ImageInterpretation` at alert delivery time, exclude active/delayed work, and pass the value to the Discord client with handler coverage.
- [x] 3.8 Resolve the capture instant from the explicit EXIF timezone and original date when available; otherwise reinterpret the asset's timezone-less `localDateTime` as `Asia/Jakarta` before passing the photo date to Discord.
- [x] 3.9 Add handler and repository coverage for explicit-timezone and Jakarta-default photo timestamps, including the reported `2026-09-13 12:10:59` case.

## 4. Interpretation completion orchestration

- [x] 4.1 Capture the guarded `complete` transition result and enqueue the deterministic Discord alert only when a new completion was persisted and the webhook is configured.
- [x] 4.2 Isolate alert enqueueing from the inference try/catch so queue or Discord failures cannot call interpretation `fail`, change completed metadata, or schedule another inference.
- [x] 4.3 Extend interpretation-service tests for successful completion, failed inference, disabled webhook, duplicate completion/delivery, enqueue failure, and unchanged completed state under alert failure.

## 5. Deployment and documentation

- [x] 5.1 Pass the webhook URL and thumbnail-inclusion settings into Immich Server through Docker Compose with alerts disabled when the URL is absent and thumbnails enabled by default when alerts are configured.
- [x] 5.2 Document Discord webhook creation, channel notification settings, secret rotation, outbound HTTPS requirements, external-domain link behavior, restart requirements, and text-only rollback.
- [x] 5.3 Document that the shared Discord channel receives account names and interpretation text from all Immich accounts, that thumbnails are uploaded to Discord by default, and that account email is disclosed only as an empty-name fallback.
- [x] 5.4 Document filename disclosure and configure this deployment's explicit external domain for authenticated photo links.
- [x] 5.5 Document the meaning and timing of the waiting interpretation count.
- [x] 5.6 Document explicit EXIF timezone handling and the `Asia/Jakarta` default for timezone-less capture dates.

## 6. Verification and rollout

- [x] 6.1 Run server formatting, lint, type checks, and focused configuration, client, handler, repository, and interpretation-service tests.
- [x] 6.2 Use a request-capturing webhook test double to verify immediate post-completion dispatch, deterministic job identity, retry classification, valid Discord payloads, and the absence of webhook credentials, originals, previews, edited files, and full-size files.
- [x] 6.3 Configure a restricted Discord test webhook and complete interpretations from at least two Immich accounts; verify account labels, small thumbnail placement, summaries, timestamps, authenticated asset links, and no duplicate under ordinary replay.
- [x] 6.4 Disable thumbnail inclusion and complete another interpretation; verify the alert still arrives, no image attachment is sent, and interpretation metadata remains unchanged throughout notification delivery.
- [x] 6.5 Run focused filename/date tests, validate the extended OpenSpec change, rebuild the server, and verify a live alert contains the filename, photo date, and configured asset link.
- [x] 6.6 Run focused queue-count tests, validate the extended OpenSpec change, rebuild the server, and verify a live alert reports the production waiting count.
- [x] 6.7 Run focused timestamp tests, lint and type checks, validate the extended OpenSpec change, rebuild the server, and verify a live alert for asset `1a2ad22b-b4c1-41cc-b408-8c4ab407c0d4` renders its capture time as 13-Sep-2026 12:10:59 in Jakarta.
