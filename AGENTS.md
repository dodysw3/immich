# Repository Memory

## Project Context
- This repository is a fork of `immich-app/immich`.
- Main fork enhancement is a PDF feature set: upload, metadata/indexing, browsing/search, and viewing.

## PDF Enhancement Summary
- Goal: treat PDFs as a first-class asset flow without destabilizing upstream behavior.
- Coverage: ingestion, storage, indexing hooks, API exposure, list/detail UX, and in-app PDF viewer integration.
- Expected behavior: PDF features should feel native, but stay isolated enough to disable or adjust with low blast radius.

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
