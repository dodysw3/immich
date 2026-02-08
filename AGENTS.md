# Repository Memory

## Project Context
- This repository is a fork of `immich-app/immich`.
- The fork adds a PDF feature set: upload, indexing, browsing, and viewing.

## Engineering Constraints
- Minimize divergence from upstream to reduce merge/rebase conflicts.
- Prefer plugin-like, modular extension points over invasive core modifications.
- When implementing PDF functionality, favor designs that can be isolated and toggled with minimal impact to upstream code paths.

## Local Runtime Context
- A Docker Compose instance for this fork is already running locally at `~/app/dodysw3-immich`.
