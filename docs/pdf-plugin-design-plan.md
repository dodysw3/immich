# PDF Document Plugin Design Plan (Immich Fork)

## Goals

- Accept PDF uploads without breaking existing upload APIs.
- Store each PDF as a single unit linked to the existing asset model.
- Provide page browsing for PDFs (viewer-style pagination).
- Index PDF text for phrase search.
- Run OCR for pages with no extractable text.
- Minimize upstream merge conflicts.
- Avoid breaking existing OpenAPI contracts and mobile app behavior.

## Constraints

- Do not modify existing table schemas.
- Do not remove or change existing OpenAPI endpoints/contracts.
- Keep changes additive and isolated where possible.

## High-Level Strategy

1. Keep PDFs as normal Immich assets (`AssetType.OTHER`) to preserve compatibility.
2. Add an isolated PDF module for ingestion, page extraction, OCR fallback, and page-level indexing.
3. Reuse existing OCR search integration (`ocr_search`) for document-level search compatibility.
4. Add additive internal endpoints for PDF page browsing and page-hit search.

## Why Not Use Existing WASM Workflow Plugins

The current plugin system is workflow-triggered and constrained to limited host functions (e.g. update asset/add to album). It does not provide file ingestion, page rendering, OCR persistence, or indexing primitives required for full PDF support. Implementing this as a server module is lower risk and more maintainable.

## Architecture

### 1) Upload and Asset Lifecycle

- Extend MIME support to include `.pdf` and `application/pdf`.
- Continue using existing asset upload pipeline (`POST /assets`) unchanged.
- Uploaded PDF is persisted as a regular asset row with original file path.
- On `AssetCreate`, detect PDF and enqueue PDF ingest job.

### 2) PDF Module (Additive)

Create a new server module namespace:

- `server/src/plugins/pdf-docs/`

Suggested components:

- `pdf-doc.controller.ts` (optional/additive endpoints)
- `pdf-doc.service.ts`
- `pdf-doc.repository.ts`
- `pdf-doc.jobs.ts` (job handlers)
- `pdf-doc.types.ts`

### 3) Queue and Jobs

Add additive job names (and reuse existing Bull infrastructure):

- `PdfIngest`: open PDF, get page count/size, extract embedded text layer per page.
- `PdfRenderPages`: render page images (for viewer previews and OCR input).
- `PdfOcrPages`: OCR only pages that lack sufficient text.
- `PdfFinalizeIndex`: normalize/merge text and update search stores.

Execution flow:

1. `AssetCreate` (PDF) -> queue `PdfIngest`.
2. `PdfIngest` creates/updates PDF doc + page records, stores text when available.
3. `PdfRenderPages` generates page raster files (lazy or eager based on config).
4. `PdfOcrPages` runs OCR for textless pages.
5. `PdfFinalizeIndex` updates:
   - page-level search table
   - existing `ocr_search` row for the asset (document-level compatibility)

### 4) Data Model (Additive Tables Only)

Add new tables via new migrations only:

- `pdf_document`
  - `assetId` (PK/FK to `asset.id`)
  - `pageCount`
  - `status` (`pending`, `processing`, `ready`, `failed`)
  - `indexedAt`
  - `versionHash` (detect reprocessing needs)
  - timestamps

- `pdf_page`
  - `id` (PK)
  - `assetId` (FK)
  - `pageNumber` (1-based)
  - `width`, `height`
  - `imagePath` (rendered page image path)
  - `hasExtractedText`
  - timestamps
  - unique `(assetId, pageNumber)`

- `pdf_page_text`
  - `pageId` (PK/FK)
  - `text` (full text for page)
  - `searchText` (normalized/tokenized text)
  - index: trigram/GIN expression for phrase matching

- `pdf_page_ocr_block`
  - `id` (PK)
  - `pageId` (FK)
  - bounding polygon coords (normalized)
  - `text`, `score`
  - `isVisible`

Notes:

- Keep existing `asset_ocr` unchanged to avoid schema changes and semantic mismatch for multipage docs.
- Keep existing `ocr_search` table unchanged; populate document-level aggregated text there for compatibility.

### 5) Search Design

#### Document-Level (no contract break)

- Reuse existing OCR search path by upserting aggregate PDF text into `ocr_search.text` for the asset.
- Existing search endpoints that use OCR query will find PDFs with no API changes.

#### Page-Level (additive)

Add optional new endpoint(s):

- `GET /api/pdf-docs/:assetId/search?q=...`
  - returns matching pages with snippet/highlight offsets and confidence metadata.

This is additive and does not break existing OpenAPI contracts.

### 6) Viewer Design

#### Web

- Detect PDF assets by extension/mime and render `PdfViewer` component.
- Use `pdf.js` (or equivalent) for page navigation, zoom, and text layer.
- Overlay OCR blocks when available.
- Add “search in document” that jumps to matching page.

#### Mobile

- Preserve existing behavior for `AssetType.OTHER` (download/open externally).
- Optionally add dedicated PDF viewer later in a separate phase.

## Conflict-Minimizing Design

Primary approach: isolate changes into new files/folders and keep touchpoints minimal.

### New/Isolated Areas

- `server/src/plugins/pdf-docs/**`
- `server/src/schema/tables/pdf-*.table.ts`
- `server/src/schema/migrations/*Pdf*.ts`
- `web/src/lib/components/pdf-docs/**`

### Minimal Existing File Touches

- `server/src/utils/mime-types.ts` (add pdf type)
- `server/src/services/index.ts` (register new service)
- `server/src/controllers/index.ts` (register new controller, if enabled)
- queue enums/config (additive entries only)
- viewer dispatch logic in web asset viewer

## Backward Compatibility

- Existing upload endpoint unchanged.
- Existing asset schemas and response DTOs unchanged.
- Existing mobile clients continue functioning.
- Existing OCR search behavior preserved and extended for PDFs.

## Performance and Operational Notes

- OCR and rendering should be async jobs; never block upload response.
- Add config flags:
  - `PDF_ENABLE`
  - `PDF_RENDER_DPI`
  - `PDF_OCR_ENABLE`
  - `PDF_MAX_PAGES_PER_DOC`
  - `PDF_MAX_FILE_SIZE_MB`
- Add retry/backoff on OCR/render jobs.
- Add status fields and metrics for observability.

## Security and Validation

- Validate MIME + magic bytes for PDF.
- Enforce max upload size/page count limits.
- Sanitize extracted text before indexing.
- Respect existing asset permissions for all PDF endpoints.

## Testing Plan

### Unit

- PDF MIME acceptance.
- Text extraction parser behavior.
- OCR fallback triggers only for textless pages.
- Search tokenization + phrase matching.

### Integration

- Upload PDF -> ingest jobs run -> pages indexed -> searchable.
- Mixed PDFs (some pages text, some image-only).
- Permission checks for PDF endpoints.

### Regression

- Existing image/video upload flows unaffected.
- Existing search and OCR behavior unchanged for non-PDF assets.

## Rollout Plan

### Phase 1

- Accept/store PDF uploads.
- Create PDF metadata/page records.
- Web page browsing viewer (basic).

### Phase 2

- Embedded text extraction + document-level search via `ocr_search`.

### Phase 3

- OCR fallback for image-only pages.
- Page-level search endpoint and highlights.

### Phase 4

- Performance tuning, retries, observability, and hardening.

## Open Decisions

- Eager vs lazy page rendering strategy.
- OCR model choice and concurrency limits.
- Whether to include additive OpenAPI docs for new PDF endpoints now or keep internal first.
