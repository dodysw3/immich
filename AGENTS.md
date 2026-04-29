# Repository Memory

## Project Context
- This repository is a fork of `immich-app/immich`.
- Main fork enhancement is a PDF feature set: upload, metadata/indexing, browsing/search, and viewing.

## PDF Enhancement Summary
- Goal: treat PDFs as a first-class asset flow without destabilizing upstream behavior.
- Coverage: ingestion, storage, indexing hooks, API exposure, list/detail UX, and in-app PDF viewer integration.
- Expected behavior: PDF features should feel native, but stay isolated enough to disable or adjust with low blast radius.

## Fork Delta Baseline (Dody Commits)
- Baseline source: commits authored by `Dody` in `upstream/main..origin/dev`.
- Current measured delta (as of 2026-02-28): `77` commits ahead of `upstream/main`, spanning 2026-02-07 to 2026-02-28.
- Dominant change areas: `server/src` (PDF domain + processing pipeline) and `web/src` (documents UX + PDF viewer).
- Backend additions: PDF-first module with tables (`pdf_document`, `pdf_page`, `pdf_search`), DTOs, repository, controller, service, migrations, and OpenAPI/SDK updates.
- Processing/indexing changes: status model, bounded search + snippets, OCR fallback threshold, feature flags/limits, failure surfacing, manual reprocess, and processing concurrency setting.
- Web additions: `/documents` pages and loaders, searchable/sortable documents UI, status filters/summaries, infinite scroll, and indexed-page navigation.
- Viewer integration: migration to `pdf.js` viewer flow with page controls, indexed-page jump behavior, initial render fixes, and `pdfjs` wasm/JPX loading hardening.
- Upload/asset flow integration: PDF upload via picker, thumbnail generation path, and selective integration touches in media/asset/queue/search/smart-info services.
- ML/edit lifecycle integration: OCR/CLIP/face-detection re-trigger logic after edits, stale OCR cleanup, OCR box rotation fixes, and ML memory/OOM hardening.
- Non-PDF but relevant deltas: face-overlay controls and instant rotate shortcuts in the asset viewer, plus server migration/build compatibility fixes after upstream updates.

## Upstream Merge & Regression Guardrails
- During upstream merges or conflict resolution, review this section first and preserve PDF boundaries before accepting upstream hunks in shared files.
- Highest-risk conflict files: `server/src/services/pdf.service.ts`, `server/src/repositories/pdf.repository.ts`, `server/src/dtos/pdf.dto.ts`, `web/src/routes/(user)/documents/+page.svelte`, `web/src/routes/(user)/documents/[assetId]/+page.svelte`, and `web/src/lib/components/pdf-viewer/PdfViewer.svelte`.
- Highest-risk behavior regressions after merge: PDF upload visibility, document status transitions, OCR/indexing job completion, in-document search snippets, pdf.js page navigation/jump reliability, and wasm JPX decode loading.
- If upstream refactors shared flows (asset/media/queue/search/config), revalidate PDF hooks with additive seams rather than broad rewrites.

## Engineering Constraints
- Minimize divergence from upstream to reduce merge/rebase conflicts and simplify upgrades.
- Prefer plugin-like or adapter-style extension points over invasive core rewrites.
- Keep PDF-specific logic behind clear boundaries (feature flags/modules/interfaces) when possible.
- Avoid broad refactors in shared upstream files unless strictly necessary for the PDF path.
- Choose additive changes first: new modules, hooks, or composition over mutation of core flows.
- Preserve upstream naming, file layout patterns, and conventions unless there is a concrete PDF need.

## Local Runtime Context
- A Docker Compose instance for this fork is already running locally at `~/app/dodysw3-immich`.

## Working Rules For Future Agents
- Before editing, check whether a plugin/extension seam can solve the problem with less upstream conflict risk.
- Keep commits/patches small and targeted; avoid opportunistic cleanup in heavily upstream-owned files.
- If touching core code is unavoidable, isolate PDF-specific conditionals and document why the change is needed.
- Prefer backwards-compatible API and schema changes so upstream merges remain straightforward.

## Operational Memory: Nextcloud Environment
- Remote Nextcloud host is typically accessed from this machine with SSH alias `nc`.
- In Codex sandbox, use wrapper pattern: `sudo bash -lc "sudo -u cangka ssh nc '<remote-command>'"`.
- The `nc` alias depends on mDNS (`nextcloud.local`); disabling `avahi-daemon` on the VM can break resolution.
- Hypervisor on this machine is `libvirt` (`virsh`), not Proxmox `qm`.
- Nextcloud VM domain is `nextcloud`; current tuned profile is 6 GiB RAM with persistent vCPU target 2 (reboot required if live CPU remains 4).
