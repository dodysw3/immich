# PDF Document Support Plugin for Immich Fork

## Context

This fork needs PDF document management: upload, store, index text content (embedded + OCR for scanned pages), and search by phrase with page-level precision. PDFs are browseable via pdf.js in the browser. The design isolates all changes into new files/tables to minimize upstream merge conflicts.

**Key decisions**: pdf.js for client-side rendering (no per-page image storage), separate `/documents` route (not in photo timeline), mupdf WASM for server-side text extraction, existing ML OCR for scanned pages.

---

## 1. Database Schema (3 new tables)

### `pdf_document` (document-level metadata)
| Column | Type | Notes |
|--------|------|-------|
| assetId | uuid PK, FK→asset(id) CASCADE | One-to-one with asset |
| pageCount | integer NOT NULL | |
| title | text NULL | From PDF metadata |
| author | text NULL | From PDF metadata |
| subject | text NULL | From PDF metadata |
| creator | text NULL | PDF creating app |
| producer | text NULL | PDF producer |
| creationDate | timestamptz NULL | PDF internal date |
| processedAt | timestamptz NULL | When processing finished |

**File**: `server/src/schema/tables/pdf-document.table.ts`

### `pdf_page` (per-page extracted text)
| Column | Type | Notes |
|--------|------|-------|
| id | uuid PK | |
| assetId | uuid FK→asset(id) CASCADE | |
| pageNumber | integer NOT NULL | 1-indexed |
| text | text NOT NULL DEFAULT '' | Extracted or OCR'd text |
| textSource | text NOT NULL DEFAULT 'embedded' | 'embedded' / 'ocr' / 'none' |
| width | real NULL | Page width in points |
| height | real NULL | Page height in points |
| UNIQUE(assetId, pageNumber) | | |

**File**: `server/src/schema/tables/pdf-page.table.ts`

### `pdf_search` (full-text search index, asset-level)
| Column | Type | Notes |
|--------|------|-------|
| assetId | uuid PK, FK→asset(id) CASCADE | |
| text | text NOT NULL | All pages concatenated |
| GIN INDEX | `f_unaccent("text") gin_trgm_ops` | Trigram search |

**File**: `server/src/schema/tables/pdf-search.table.ts`

**Migration**: `server/src/schema/migrations/<timestamp>-CreatePdfTables.ts`

---

## 2. Processing Pipeline

### Trigger mechanism
Listen to `AssetMetadataExtracted` event in `PdfService` via `@OnEvent`. Check if asset's `originalPath` ends with `.pdf`. If so, queue `PdfProcess` job. This avoids modifying `job.service.ts`.

### PdfProcess job (main processing)
Uses `mupdf` (WASM npm package) on the server:

1. **Load PDF**: Open from `asset.originalPath` using mupdf
2. **Extract metadata**: title, author, subject, creator, producer, creation date, page count → INSERT `pdf_document`
3. **Generate thumbnail**: Render page 1 as image → store as asset preview/thumbnail via `asset_file` table (same pattern as `MediaService`). This gives the PDF a thumbnail in the `/documents` grid.
4. **For each page**:
   - Extract embedded text via `page.toStructuredText()` → `getText('text')`
   - Record page dimensions
   - INSERT into `pdf_page` (pageNumber, text, textSource='embedded', width, height)
   - If text is empty/very short (<10 chars): mark textSource='none', schedule OCR
5. **OCR for scanned pages**: For each page needing OCR, render page to image buffer in memory, send to existing ML OCR endpoint (`machineLearningRepository.ocr()`), update `pdf_page.text` and set textSource='ocr'
6. **Build search index**: Concatenate all page texts → INSERT `pdf_search`
7. **Cleanup**: Close mupdf document, free memory

### Job flow diagram
```
Upload PDF → AssetExtractMetadata (existing)
                    ↓ emits AssetMetadataExtracted
              PdfService @OnEvent
                    ↓ checks isPdf
              PdfProcess job
                    ├── Extract metadata → pdf_document
                    ├── Render page 1 → asset preview/thumbnail
                    ├── For each page: extract text → pdf_page
                    ├── OCR scanned pages via ML service → update pdf_page
                    └── Aggregate text → pdf_search
```

---

## 3. New API Endpoints

**Controller**: `server/src/controllers/pdf.controller.ts`
**DTOs**: `server/src/dtos/pdf.dto.ts`

| Method | Path | Description |
|--------|------|-------------|
| GET | `/documents` | List user's PDF documents (paginated, with thumbnail info) |
| GET | `/documents/:id` | Get PDF metadata (page count, title, author, etc.) |
| GET | `/documents/:id/pages` | Get all pages with text for a PDF |
| GET | `/documents/:id/pages/:pageNumber` | Get single page text |
| GET | `/documents/search` | Full-text search across PDFs (returns asset + matching page numbers) |

The original PDF file is served via the existing `GET /assets/:id/original` endpoint (already works for any asset type). pdf.js in the browser fetches from this endpoint.

---

## 4. Frontend

### Routes (SvelteKit file-based routing)
- `web/src/routes/(user)/documents/+page.svelte` - Document grid/list
- `web/src/routes/(user)/documents/[assetId]/+page.svelte` - PDF viewer page

### Components
New directory: `web/src/lib/components/pdf-viewer/`

- **PdfDocumentGrid.svelte** - Grid of PDF thumbnails with title/page count
- **PdfViewer.svelte** - Main viewer wrapping pdf.js
  - Loads PDF from `/api/assets/:id/original`
  - Renders pages via pdf.js Canvas renderer
  - Page navigation (prev/next/goto)
  - Sidebar with page thumbnails
  - Built-in text search (pdf.js `findController`)
  - Zoom controls
- **PdfSearchBar.svelte** - In-document search (delegates to pdf.js find)
- **PdfDocumentInfo.svelte** - Metadata panel (title, author, pages, etc.)

### npm dependency
Add `pdfjs-dist` to `web/package.json` for the frontend pdf.js renderer.

### Navigation
Add "Documents" item to sidebar in `web/src/lib/components/shared-components/side-bar/user-sidebar.svelte` (single line addition).

Add routes to `web/src/lib/route.ts`.

---

## 5. Server-side File Organization

### New files (zero upstream conflict)
```
server/src/schema/tables/pdf-document.table.ts
server/src/schema/tables/pdf-page.table.ts
server/src/schema/tables/pdf-search.table.ts
server/src/schema/migrations/<ts>-CreatePdfTables.ts
server/src/repositories/pdf.repository.ts
server/src/services/pdf.service.ts
server/src/controllers/pdf.controller.ts
server/src/dtos/pdf.dto.ts
web/src/routes/(user)/documents/+page.svelte
web/src/routes/(user)/documents/[assetId]/+page.svelte
web/src/lib/components/pdf-viewer/PdfDocumentGrid.svelte
web/src/lib/components/pdf-viewer/PdfViewer.svelte
web/src/lib/components/pdf-viewer/PdfSearchBar.svelte
web/src/lib/components/pdf-viewer/PdfDocumentInfo.svelte
```

### Existing files modified (minimal, append-only)

| File | Change | Risk |
|------|--------|------|
| `server/src/enum.ts` | Add `PdfProcessing` to QueueName, `PdfProcessQueueAll`/`PdfProcess` to JobName | Low - append to end of enums |
| `server/src/types.ts` | Add 2 JobItem union members at end | Low - append |
| `server/src/utils/mime-types.ts` | Add `.pdf` to `types`, update `isAsset()` | Low - add one entry |
| `server/src/schema/index.ts` | Import + register 3 new tables in `tables[]` and `DB` interface | Low - append |
| `server/src/services/base.service.ts` | Add `PdfRepository` to DI (1 import, 1 array entry, 1 constructor param) | Medium - upstream changes this file |
| `server/src/controllers/index.ts` | Import + add PdfController | Low - append |
| `server/src/services/index.ts` | Import + add PdfService | Low - append |
| `server/src/repositories/index.ts` | Import + add PdfRepository | Low - append |
| `server/src/services/queue.service.ts` | Add `case QueueName.PdfProcessing:` in switch | Low - add one case |
| `web/src/lib/route.ts` | Add `documents` route | Low - append |
| `web/src/lib/components/.../user-sidebar.svelte` | Add NavbarItem for Documents | Low - append |
| `server/package.json` | Add `mupdf` dependency | Low |
| `web/package.json` | Add `pdfjs-dist` dependency | Low |

**Total**: 13 existing files, each with 1-5 line insertions. No structural changes.

---

## 6. Key Design Patterns (following existing codebase)

- **Repository**: `PdfRepository` uses `@InjectKysely()` with typed queries, same as `OcrRepository`
- **Service**: `PdfService extends BaseService`, uses `@OnJob()` and `@OnEvent()` decorators
- **Controller**: `@Authenticated()` + `@Endpoint()` decorators, permission checks via `requireAccess`
- **DTOs**: class-validator decorators, swagger annotations
- **Tables**: `@Table()`, `@Column()`, `@ForeignKeyColumn()` decorators from `src/sql-tools`

Reference pattern: `server/src/services/ocr.service.ts` (closest analog)

---

## 7. Implementation Sequence

**Phase 1: Database foundation**
1. Create 3 table definition files (`pdf-document`, `pdf-page`, `pdf-search`)
2. Create migration file
3. Add enum values to `enum.ts` (QueueName, JobName)
4. Add job types to `types.ts`
5. Register tables in `schema/index.ts`
6. Update `mime-types.ts` to accept `.pdf` uploads

**Phase 2: Repository + Service**
7. Create `PdfRepository` (CRUD for all 3 tables, search queries)
8. Create `PdfService` (event handler, job handlers, API methods)
9. Add `PdfRepository` to `base.service.ts`
10. Register in `repositories/index.ts`, `services/index.ts`
11. Add `mupdf` to `server/package.json` + install

**Phase 3: Controller + API**
12. Create DTOs in `pdf.dto.ts`
13. Create `PdfController`
14. Register in `controllers/index.ts`
15. Add queue start case in `queue.service.ts`

**Phase 4: Frontend**
16. Add `pdfjs-dist` to `web/package.json` + install
17. Create `/documents` route page (grid view)
18. Create `/documents/[assetId]` route page (pdf.js viewer)
19. Create PDF viewer components
20. Update sidebar navigation + route.ts

---

## 8. Verification Plan

1. **Upload**: Upload a PDF via the web UI or API → confirm asset created with type=OTHER, original file stored
2. **Processing**: Check that `PdfProcess` job runs → `pdf_document` row created with correct page count, `pdf_page` rows for each page, `pdf_search` row with aggregated text
3. **Thumbnail**: Confirm first-page thumbnail appears in the `/documents` grid
4. **Viewer**: Navigate to `/documents/:id` → pdf.js loads and renders the PDF, pages are navigable
5. **Text search (server)**: `GET /documents/search?query=hello` returns matching documents with page numbers
6. **Text search (client)**: In-viewer search (Ctrl+F) highlights matches in the rendered PDF
7. **OCR**: Upload a scanned PDF (image-only pages) → confirm OCR runs via ML service, text extracted and searchable
8. **Deletion**: Delete the asset → confirm all `pdf_*` rows cascade-deleted
9. **Upstream merge**: Run `git merge main` → confirm no conflicts in existing files (only append conflicts in `enum.ts`/`index.ts` if upstream also appended)
