# PDF Plugin Design Plan (Merged Best-of)

## 1. Goals
- Add PDF support without breaking existing upload and search contracts.
- Keep changes additive to reduce upstream merge conflicts.
- Provide document browsing in a dedicated `/documents` section.
- Enable searchable PDF text (embedded + OCR fallback for scanned pages).

## 2. Constraints
- No destructive schema changes to existing tables.
- No breaking changes to existing OpenAPI/mobile behavior.
- Keep core flow stable; run PDF work in async jobs.

## 3. Key Decisions
- Store PDFs as normal assets (`AssetType.OTHER`) for compatibility.
- Trigger processing from existing metadata event (`AssetMetadataExtracted`) to avoid deep pipeline rewrites.
- Add new `pdf_*` tables only.
- Use server-side extraction + OCR indexing; use `pdf.js` for web rendering.
- Keep PDF UI separate from photo timeline (`/documents` route).

## 4. Data Model (Additive)
- `pdf_document` (1:1 with `asset`)
  - `assetId` PK/FK, `pageCount`, metadata fields (`title`, `author`, `subject`, `creator`, `producer`), `processedAt`, timestamps.
- `pdf_page`
  - `id` PK, `assetId` FK, `pageNumber`, `text`, `textSource` (`embedded|ocr|none`), `width`, `height`, unique `(assetId, pageNumber)`.
- `pdf_search`
  - `assetId` PK/FK, `text` (concatenated document text), GIN trigram index on normalized text.

Migration:
- `server/src/schema/migrations/<timestamp>-CreatePdfTables.ts`

## 5. Processing Pipeline
1. Upload PDF through existing asset upload (accepted via MIME update).
2. `AssetMetadataExtracted` event handler detects PDF and queues `PdfProcess`.
3. `PdfProcess` job:
   - Read PDF metadata and page count -> upsert `pdf_document`.
   - Extract embedded text per page -> upsert `pdf_page`.
   - Mark short/empty pages for OCR.
   - OCR marked pages via existing ML OCR integration -> update `pdf_page.text`, `textSource='ocr'`.
   - Aggregate all page text -> upsert `pdf_search`.
4. Optional: set/refresh preview thumbnail from first page using existing preview mechanism.

Operational rules:
- Upload response must not block on extraction/OCR.
- Retry/backoff for OCR/processing jobs.
- Config flags: `PDF_ENABLE`, `PDF_OCR_ENABLE`, `PDF_MAX_PAGES_PER_DOC`, `PDF_MAX_FILE_SIZE_MB`.

## 6. API Surface (Additive)
New controller: `server/src/controllers/pdf.controller.ts`

- `GET /documents` - list PDF assets (paginated).
- `GET /documents/:id` - document metadata.
- `GET /documents/:id/pages` - page list with text/page info.
- `GET /documents/:id/pages/:pageNumber` - single page detail.
- `GET /documents/search?query=...` - PDF full-text search with matched page numbers.

Reuse existing endpoint for original file:
- `GET /assets/:id/original` for pdf.js loading.

## 7. Frontend
Routes:
- `web/src/routes/(user)/documents/+page.svelte`
- `web/src/routes/(user)/documents/[assetId]/+page.svelte`

Components:
- `web/src/lib/components/pdf-viewer/PdfDocumentGrid.svelte`
- `web/src/lib/components/pdf-viewer/PdfViewer.svelte`
- `web/src/lib/components/pdf-viewer/PdfSearchBar.svelte`
- `web/src/lib/components/pdf-viewer/PdfDocumentInfo.svelte`

Notes:
- Add `pdfjs-dist` dependency.
- Add Documents entry to sidebar and route map.
- Keep timeline behavior unchanged.

## 8. Files to Create/Modify
Create (new modules/tables/DTOs/repository/service/controller/routes/components):
- `server/src/schema/tables/pdf-document.table.ts`
- `server/src/schema/tables/pdf-page.table.ts`
- `server/src/schema/tables/pdf-search.table.ts`
- `server/src/schema/migrations/<timestamp>-CreatePdfTables.ts`
- `server/src/repositories/pdf.repository.ts`
- `server/src/services/pdf.service.ts`
- `server/src/controllers/pdf.controller.ts`
- `server/src/dtos/pdf.dto.ts`
- `web/src/routes/(user)/documents/+page.svelte`
- `web/src/routes/(user)/documents/[assetId]/+page.svelte`
- `web/src/lib/components/pdf-viewer/*`

Modify (append-only where possible):
- `server/src/utils/mime-types.ts` (accept `.pdf` / `application/pdf`)
- `server/src/enum.ts` (job/queue/tag additions)
- `server/src/types.ts` (job union additions)
- `server/src/schema/index.ts` (register tables)
- `server/src/repositories/index.ts` (register repository)
- `server/src/services/index.ts` (register service)
- `server/src/controllers/index.ts` (register controller)
- `server/src/services/queue.service.ts` (queue case)
- `web/src/lib/route.ts` (documents route)
- `web/src/lib/components/shared-components/side-bar/user-sidebar.svelte` (nav item)
- `server/package.json` (`mupdf` or chosen extractor lib)
- `web/package.json` (`pdfjs-dist`)

## 9. Implementation Sequence
Phase 1: Database + registration
1. Add 3 table files and migration.
2. Register tables in schema index.
3. Add queue/job enums and type entries.
4. Update MIME handling for PDF acceptance.

Phase 2: Backend processing
5. Implement `PdfRepository`.
6. Implement `PdfService` with event trigger + job handlers.
7. Register repository/service + queue wiring.
8. Add processing dependencies and adapter utilities.

Phase 3: API + permissions
9. Add `pdf.dto.ts`.
10. Add `PdfController` endpoints under `/documents`.
11. Register controller and permission checks.

Phase 4: Web UI
12. Add `/documents` routes.
13. Build grid + viewer components with pdf.js.
14. Add sidebar/nav integration.

Phase 5: Hardening
15. Add retries, limits, and status metrics.
16. Finalize error mapping and observability.

## 10. Verification Plan
1. Upload text PDF -> `pdf_document`, `pdf_page`, `pdf_search` populated.
2. Upload scanned PDF -> OCR path runs and text becomes searchable.
3. `/documents` list loads with thumbnail/metadata.
4. Viewer loads original PDF via `/assets/:id/original`.
5. `/documents/search` returns document + matching page numbers.
6. Deleting asset cascades `pdf_*` rows cleanly.
7. Regression: non-PDF uploads/search remain unchanged.
8. Upstream merge check: only expected append conflicts in shared index/enum files.

## 11. Resolved Decisions
- Extractor strategy: use Poppler CLI tools already available in runtime (`pdftotext`, `pdfinfo`, `pdftoppm`) with graceful fallback when missing.
- OCR adequacy threshold: configurable via `PDF_MIN_EMBEDDED_TEXT_LENGTH` (default `10`), used to decide `embedded` vs OCR fallback.
- Thumbnail generation timing: lazy (use existing asset thumbnail endpoint and client-side page thumbnails in viewer).
