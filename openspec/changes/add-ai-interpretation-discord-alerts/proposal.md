## Why

AI interpretations currently become visible only when someone opens the corresponding photo in Immich. Operators of this multi-account installation want an immediate, recognizable alert when any account's new photo finishes interpretation.

## What Changes

- Send a Discord webhook alert after a new AI image-interpretation run is successfully persisted as completed.
- Identify the owning Immich account by account name in every alert, with the account email as a fallback when the name is empty.
- Include Immich's generated 250-pixel thumbnail in the Discord embed by default, with a server-side configuration option to disable thumbnail sharing.
- Include the original filename, interpreted title, a concise interpretation summary, and a link to the authenticated Immich photo viewer.
- Timestamp the embed with the photo's capture date rather than the later AI completion time, respecting an explicit EXIF timezone and otherwise treating the timezone-less capture clock as `Asia/Jakarta`.
- Show how many AI interpretation jobs are still waiting to start when the alert is delivered.
- Deliver alerts through retryable notification work that is isolated from interpretation success and deduplicated per asset/run.
- Degrade to a text-only alert when thumbnail inclusion is enabled but the generated thumbnail cannot be read.

## Capabilities

### New Capabilities

- `ai-interpretation-discord-alerts`: Discord webhook delivery for completed image interpretations, including multi-account identification, optional generated thumbnails, deduplication, and failure isolation.

### Modified Capabilities

None. The repository does not yet contain established capability specifications under `openspec/specs/`.

## Impact

- Server: completion orchestration, a Discord webhook client, notification-queue job handling, owner lookup, message formatting, retry/deduplication behavior, and tests.
- Configuration: server-only Discord webhook URL and thumbnail-inclusion settings exposed through deployment environment variables.
- Deployment: Immich Server requires outbound HTTPS access to Discord and a protected webhook URL secret.
- Privacy: interpretation text, account name, and—by default—the generated photo thumbnail leave the local Immich installation and are stored by Discord.
- Web: no new user interface is required; alerts link to the existing authenticated `/photos/{assetId}` route.
