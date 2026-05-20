# Repository Memory

## Project Context
- Fork of `immich-app/immich` (self-hosted photo/video manager).
- Main fork enhancement: PDF feature set (upload, metadata/indexing, browsing/search, in-app viewing).
- Version: `2.7.4` across all packages.

## Monorepo Layout

| Dir | Package name | Stack | Notes |
|---|---|---|---|
| `server/` | `immich` | NestJS + Kysely + Vitest | Backend API, microservices, workers |
| `web/` | `immich-web` | SvelteKit 5 + Vite 8 + Tailwind 4 | Frontend SPA |
| `cli/` | `@immich/cli` | Node/TS + Vite | CLI tool |
| `open-api/typescript-sdk/` | `@immich/sdk` | TS | Generated from server OpenAPI spec |
| `machine-learning/` | `immich-ml` | Python/FastAPI + uv | ML inference service |
| `mobile/` | — | Flutter/Dart | Mobile app |
| `e2e/` | `immich-e2e` | Vitest + Playwright | Integration & browser tests |
| `e2e-auth-server/` | `@immich/e2e-auth-server` | — | Test auth helper |
| `i18n/` | `immich-i18n` | — | Translation files |
| `plugins/` | — | — | Plugin system |

Toolchain: Node 24.14.1, pnpm 10.32.1, Python 3.11, Flutter (via `mise.toml`).

## Key Commands

### Server (`server/`)
```bash
pnpm install --filter immich --frozen-lockfile  # install deps
pnpm --filter immich build                       # nest build (required before many scripts)
pnpm --filter immich lint                        # ESLint (max-warnings 0)
pnpm --filter immich format                      # Prettier check
pnpm --filter immich check                       # tsc --noEmit
pnpm --filter immich test                        # unit tests (vitest, config: test/vitest.config.mjs)
pnpm --filter immich test:medium                 # medium/integration tests (test/medium/)
```

Or via `mise` from `server/`: `mise run install`, `mise run build`, `mise run lint`, `mise run check`, `mise run test`, `mise run checklist`.

### Web (`web/`)
```bash
# SDK must be built first:
pnpm install --filter @immich/sdk --frozen-lockfile && pnpm --filter @immich/sdk build
pnpm install --filter immich-web --frozen-lockfile
pnpm --filter immich-web dev                     # dev server on :3000
pnpm --filter immich-web lint                    # ESLint
pnpm --filter immich-web format                  # Prettier check
pnpm --filter immich-web check:svelte            # svelte-check (required, catches template errors)
pnpm --filter immich-web check:typescript        # tsc --noEmit
pnpm --filter immich-web test                    # vitest
```

Web checks run **two** type checkers: `check:svelte` and `check:typescript` — both must pass.

### Machine Learning (`machine-learning/`)
```bash
uv sync --extra cpu     # install deps
uv run ruff check immich_ml   # lint
uv run ruff format --check immich_ml  # format check
uv run mypy --strict immich_ml/       # type check
uv run pytest --cov=immich_ml        # tests
```

### Makefile shortcuts (from repo root)
```bash
make check-server   # format + lint + tsc for server
make test-server    # server unit tests
make check-web      # format + lint + svelte-check + tsc for web
make test-web       # web unit tests
make open-api       # regenerate OpenAPI clients (dart + typescript)
make sql            # sync SQL files via server dist
make e2e            # run e2e Docker Compose
```

Make package mapping: `server`=`immich`, `web`=`immich-web`, `cli`=`@immich/cli`, `sdk`=`@immich/sdk`, `e2e`=`immich-e2e`.

## Architecture: Server

- **Entrypoint**: `server/src/main.ts` — spawns workers (API via fork, microservices/maintenance via Worker threads).
- **Workers**: `server/src/workers/{api,microservices,maintenance}.ts`.
- **NestJS module**: `server/src/app.module.ts` wires all controllers, services, repositories.
- **Path aliases**: `src/*` and `test/*` (tsconfig paths). Imports use `src/...` not relative paths.
- **ESLint rule**: Relative imports (`../`, `./`) are **banned** in `server/`. Always use `src/...` paths.
- **ORM**: Kysely (not TypeORM). Schema defined in `server/src/schema/tables/*.table.ts`. Migrations in `server/src/schema/migrations/`.
- **SQL queries**: Generated/synced to `server/src/queries/*.repository.sql` via `pnpm sync:sql`.
- **Migrations**: Use `sql-tools` CLI (`pnpm migrations:generate`, `pnpm migrations:run`, etc.). Requires running Postgres + `DB_URL`.
- **OpenAPI spec**: Generated via `pnpm sync:open-api` (needs built server). Output: `open-api/immich-openapi-specs.json`.
- **SDK codegen**: `open-api/bin/generate-open-api.sh` — builds server, generates spec, then generates Dart and/or TypeScript clients.

## Architecture: Web

- **SvelteKit 5** with Svelte 5 runes. Static adapter (`@sveltejs/adapter-static`).
- **Routes**: `web/src/routes/(user)/...` — SvelteKit file-based routing. PDF docs at `routes/(user)/documents/`.
- **pdf.js**: WASM synced via `web/bin/sync-pdfjs-wasm.mjs` (runs automatically on `dev`/`build` via `predev`/`prebuild`).
- **UI library**: `@immich/ui` (external component lib).

## CI Verification Order (from `.github/workflows/test.yml`)

Server: `format -> lint -> check (tsc) -> test`
Web: `lint -> format -> check:svelte -> check:typescript -> test`

## Server Testing

- **Unit tests**: `src/**/*.spec.ts`, config at `test/vitest.config.mjs`. Globals enabled (no need to import `describe`/`it`/`expect`).
- **Medium tests**: `test/medium/**/*.spec.ts`, config at `test/vitest.config.medium.mjs`. Requires Docker/Postgres (uses testcontainers).
- **Coverage**: Covers `src/cores/**`, `src/services/**`, `src/utils/**`, `src/sql-tools/**`.
- **Test factories**: `test/small.factory.ts`, `test/medium.factory.ts`.

## E2E Testing

- **Docker Compose**: `e2e/docker-compose.yml` spins up full stack.
- **API/CLI tests**: Vitest (`pnpm test`, `pnpm test:maintenance`).
- **Web tests**: Playwright (`pnpm test:web`, `pnpm test:web:ui`, `pnpm test:web:maintenance`).
- Requires `open-api/typescript-sdk` and `cli` built first.

## Code Generation & Sync Dependencies

When changing server DTOs/controllers:
1. `pnpm --filter immich build` (build server)
2. `pnpm --filter immich sync:open-api` (regenerate OpenAPI spec)
3. `cd open-api && ./bin/generate-open-api.sh` (regenerate SDK clients)
4. `pnpm --filter immich sync:sql` (sync SQL queries)

When changing `server/src/schema/tables/`:
1. Build server
2. Run migrations against DB: `pnpm migrations:generate`
3. `pnpm sync:sql`

## PDF Enhancement Summary

- Goal: treat PDFs as first-class assets without destabilizing upstream.
- Backend: `pdf.service.ts`, `pdf.repository.ts`, `pdf.controller.ts`, `pdf.dto.ts`, tables (`pdf_document`, `pdf_page`, `pdf_search`), migrations `1769702000000-*`.
- Web: `/documents` pages, `PdfViewer.svelte` (pdf.js viewer), PDF upload via picker.
- Integration points: media/asset/queue/search/smart-info/OCR services.

## Upstream Merge & Regression Guardrails

- Highest-risk conflict files: `server/src/services/pdf.service.ts`, `server/src/repositories/pdf.repository.ts`, `server/src/dtos/pdf.dto.ts`, `web/src/routes/(user)/documents/**`, `web/src/lib/components/pdf-viewer/**`.
- If upstream refactors shared flows (asset/media/queue/search/config), revalidate PDF hooks with additive seams rather than broad rewrites.

## Engineering Constraints

- Minimize divergence from upstream; prefer additive changes (new modules/hooks) over core rewrites.
- Keep PDF logic behind clear boundaries (feature flags/modules/interfaces).
- Preserve upstream naming, file layout, and conventions.
- Backwards-compatible API/schema changes only.

## Local Runtime Context

- Docker Compose instance at `~/app/dodysw3-immich`.
- Dev compose: `docker/docker-compose.dev.yml` (`make dev`).

## Operational Memory: Nextcloud Environment

- Remote Nextcloud accessed via SSH alias `nc` (mDNS `nextcloud.local`; requires `avahi-daemon`).
- In Codex sandbox: `sudo bash -lc "sudo -u cangka ssh nc '<cmd>'"`.
- Hypervisor: `libvirt` (`virsh`), not Proxmox.
- Nextcloud VM: 6 GiB RAM, vCPU target 2.
