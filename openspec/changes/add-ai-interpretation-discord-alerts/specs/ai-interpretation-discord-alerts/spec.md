## ADDED Requirements

### Requirement: Configure Discord interpretation alerts securely
The system SHALL enable Discord interpretation alerts only when a valid server-only webhook URL is configured and SHALL enable thumbnail inclusion by default unless explicitly disabled.

#### Scenario: Webhook URL is absent
- **WHEN** the Discord webhook URL is not configured
- **THEN** completed interpretations do not queue or send Discord alerts

#### Scenario: Webhook URL is configured
- **WHEN** a valid HTTPS Discord webhook URL is configured
- **THEN** Discord interpretation alerts are enabled without requiring a separate enabled flag

#### Scenario: Thumbnail configuration is omitted
- **WHEN** alerts are enabled and the thumbnail-inclusion setting is absent
- **THEN** the system treats thumbnail inclusion as enabled

#### Scenario: Secret handling
- **WHEN** configuration, request lifecycle, or errors are logged or returned
- **THEN** the system does not expose the webhook URL or its embedded credential to clients or logs

### Requirement: Schedule an alert for each newly completed interpretation
The system SHALL enqueue one Discord alert without intentional delay only after a guarded interpretation transition has successfully persisted a completed result.

#### Scenario: Interpretation completes
- **WHEN** a run transitions from `running` to `completed` and Discord alerts are enabled
- **THEN** the system immediately queues a Discord alert identified by that asset and run key

#### Scenario: Interpretation does not complete
- **WHEN** an interpretation remains queued, is running, or fails
- **THEN** the system does not queue a completion alert for that state

#### Scenario: Duplicate completion or queue delivery
- **WHEN** the same asset and run completion is observed or delivered more than once internally
- **THEN** deterministic job identity and completed-run validation suppress ordinary duplicate Discord sends

#### Scenario: Alert enqueueing fails
- **WHEN** a completed interpretation cannot enqueue its Discord alert
- **THEN** the interpretation remains completed and the system records a sanitized alert-delivery error

### Requirement: Identify the owning Immich account
Every Discord interpretation alert MUST show the human-facing account name of the asset owner, using the account email only when the name is empty.

#### Scenario: Owner has an account name
- **WHEN** an alert is built for an owner whose trimmed account name is non-empty
- **THEN** the alert's account field contains that name and does not routinely disclose the email address

#### Scenario: Owner name is empty
- **WHEN** an alert is built for an owner whose account name is empty or whitespace
- **THEN** the alert's account field contains the owner's email address as a fallback

#### Scenario: Owning account is unavailable
- **WHEN** the owning account no longer exists when the alert job runs
- **THEN** the job is skipped without sending an ambiguously attributed alert

### Requirement: Send a concise and safe Discord embed
The system SHALL send a bounded Discord embed containing the interpretation title, account label, original filename, concise summary, photo date, current waiting interpretation count, and an authenticated Immich photo link when an explicit external domain is configured.

#### Scenario: Completed result has normal content
- **WHEN** a valid completed run is delivered
- **THEN** the embed uses its title and archive summary, shows the asset's original filename, and timestamps the message with the asset's photo date

#### Scenario: Interpretation completes after the photo date
- **WHEN** the interpretation completion time is later than the asset's photo date
- **THEN** the embed timestamp uses the photo date and not the interpretation completion time

#### Scenario: Photo records an explicit timezone
- **WHEN** the photo has both an EXIF capture date and an explicit timezone
- **THEN** the embed timestamp represents that recorded capture instant and Discord can display it correctly in Jakarta

#### Scenario: Photo has no explicit timezone
- **WHEN** the photo's capture clock has no explicit EXIF timezone
- **THEN** the system interprets its `localDateTime` wall clock as `Asia/Jakarta` before sending the embed timestamp

#### Scenario: Filename exceeds the provider limit
- **WHEN** the asset's original filename exceeds Discord's field limit
- **THEN** the filename is deterministically truncated while retaining a valid embed

#### Scenario: Interpretations remain queued
- **WHEN** an alert is delivered while image-interpretation jobs are waiting to start
- **THEN** the embed shows the current waiting-job count without including active or delayed jobs

#### Scenario: No interpretations remain queued
- **WHEN** an alert is delivered with no image-interpretation jobs waiting to start
- **THEN** the embed shows a waiting count of zero

#### Scenario: Preferred text is absent
- **WHEN** the title or archive summary is empty
- **THEN** the embed uses a stable title fallback and a bounded interpretation excerpt when available

#### Scenario: External domain is configured
- **WHEN** Immich has an explicit external domain
- **THEN** the embed links to that asset at `/photos/{assetId}` without exposing an unauthenticated media URL

#### Scenario: External domain is absent
- **WHEN** Immich has no explicit external domain
- **THEN** the alert is sent without inventing a public link

#### Scenario: Content contains mentions or exceeds provider limits
- **WHEN** account or model-generated text contains mention syntax or exceeds a Discord field limit
- **THEN** mentions are disabled and each field is deterministically truncated to a valid length

### Requirement: Include a generated thumbnail by default
The system SHALL upload only the generated unedited thumbnail for the asset and render it in the Discord embed's small thumbnail position when thumbnail inclusion is enabled.

#### Scenario: Default thumbnail is available
- **WHEN** thumbnail inclusion is enabled and the generated unedited thumbnail is readable in a supported format
- **THEN** the system uploads it in the webhook request and references the attachment from the embed thumbnail

#### Scenario: Thumbnail inclusion is disabled
- **WHEN** the operator configures thumbnail inclusion as false
- **THEN** the system neither reads nor uploads an image and sends the alert without a thumbnail

#### Scenario: Thumbnail is unavailable
- **WHEN** thumbnail inclusion is enabled but the generated thumbnail is missing, unreadable, or unsupported
- **THEN** the system sends the text/embed alert without a thumbnail and records only a sanitized warning

#### Scenario: Generated thumbnail fallback is prohibited
- **WHEN** the generated unedited thumbnail cannot be used
- **THEN** the system does not fall back to an edited image, preview, full-size file, or original asset

### Requirement: Isolate and retry Discord delivery
The system MUST keep Discord delivery independent of interpretation state and SHALL retry only transient webhook failures with bounded backoff.

#### Scenario: Discord accepts the alert
- **WHEN** Discord confirms message creation
- **THEN** the alert job completes successfully without changing the stored interpretation result

#### Scenario: Transient delivery failure
- **WHEN** delivery encounters a network error, timeout, HTTP 429, or HTTP 5xx response
- **THEN** the notification job retries with bounded backoff while the interpretation remains completed

#### Scenario: Permanent delivery failure
- **WHEN** Discord returns a non-rate-limit HTTP 4xx response
- **THEN** the job records a sanitized permanent failure without retrying indefinitely or changing the interpretation state

#### Scenario: Integration is disabled before a queued job runs
- **WHEN** a queued Discord alert starts after the webhook URL has been removed
- **THEN** the job skips without making an outbound request

#### Scenario: Source asset or run is unavailable
- **WHEN** the asset is deleted or the target run is absent or no longer completed before delivery
- **THEN** the job skips without making an outbound request

#### Scenario: Outbound request observability
- **WHEN** delivery succeeds or fails
- **THEN** logs contain the asset/run identity and sanitized status but omit webhook credentials, response bodies, and image bytes
