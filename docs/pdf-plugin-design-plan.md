# PDF Plugin for Immich - Implementation Plan

## Overview
Add PDF upload, storage, OCR, and search capabilities to Immich as an isolated module that minimizes merge conflicts with upstream.

## Key Design Decisions (Based on User Input)
- **Dedicated `/pdf/upload` endpoint** - Separate from image uploads for maximum isolation
- **Separate PDF section in UI** - PDFs not mixed with photos in timeline
- **Separate PDF OCR service** - Dedicated OCR processing for PDFs, not reusing image OCR
- **Custom storage path** - Page thumbnails use custom directory structure, not asset_file table

## Key Constraints
- **No changes to existing table schemas** (asset, asset_exif, etc.)
- **No changes to existing OpenAPI contracts** (don't break mobile apps)
- **Minimal changes to core asset processing flow**
- **Easy to maintain during upstream merges**

## Design Approach

### 1. Asset Type Strategy
**Use `AssetType.OTHER` for PDFs**
- Avoids modifying the `AssetType` enum (prevents merge conflicts)
- PDFs are already categorized as "OTHER" by the current system
- Detection via MIME type (`application/pdf`) and file extension

### 2. Database Schema (New Tables Only)

**Create `pdf_asset` table** (stores PDF-specific metadata):
```typescript
- id: string (PK, references asset.id)
- pageCount: number
- hasText: boolean (whether PDF has extractable text)
- isOCRProcessed: boolean
- fileSizeInByte: bigint
- author: string | null
- title: string | null
- subject: string | null
- keywords: string[] | null
- creator: string | null
- producer: string | null
- createdAt, updatedAt
```

**Create `pdf_page` table** (stores individual page data):
```typescript
- id: string (PK)
- assetId: string (FK to asset.id, CASCADE)
- pageNumber: number
- width: number | null
- height: number | null
- textContent: text | null (extracted text for this page)
- thumbnailPath: string (path to page preview image)
- searchableText: text (for full-text search)
```

**Create `pdf_page_ocr` table** (OCR data for page regions):
```typescript
- id: string (PK)
- pdfPageId: string (FK to pdf_page.id, CASCADE)
- pageNumber: number
- x1, y1, x2, y2, x3, y3, x4, y4: real (bounding box)
- text: text
- confidence: real
```

**Create `pdf_search` table** (full-text search index):
```typescript
- assetId: string (PK, FK to asset.id, CASCADE)
- text: text (concatenated searchable text from all pages)
```
With GIN index: `CREATE INDEX idx_pdf_search_text ON pdf_search USING gin (f_unaccent("text") gin_trgm_ops)`

### 3. File Structure (New Module)

```
server/src/
├── pdf/                           # New PDF module (isolated)
│   ├── dto/
│   │   ├── pdf.dto.ts            # PDF-specific DTOs
│   │   └── pdf-response.dto.ts   # Response DTOs
│   ├── repositories/
│   │   ├── pdf.repository.ts     # PDF data access
│   │   └── pdf-page.repository.ts
│   ├── services/
│   │   ├── pdf.service.ts        # Main PDF service
│   │   ├── pdf-processing.service.ts  # PDF processing logic
│   │   └── pdf-ocr.service.ts    # OCR for PDFs
│   ├── controllers/
│   │   └── pdf.controller.ts     # New API endpoints
│   ├── jobs/
│   │   └── pdf-processor.job.ts  # Background job
│   └── utils/
│       ├── pdf-extractor.util.ts # PDF parsing (pdf-parse)
│       └── pdf-thumbnail.util.ts # Page thumbnail generation
├── schema/tables/
│   ├── pdf-asset.table.ts        # New
│   ├── pdf-page.table.ts         # New
│   ├── pdf-page-ocr.table.ts     # New
│   └── pdf-search.table.ts       # New
└── schema/migrations/
    └── {timestamp}-AddPdfTables.ts  # New migration
```

### 4. Storage Strategy

**File Layout (custom paths per user requirement):**
```
{uploadLibrary}/pdf/
└── {userId}/
    └── {assetId}/
        ├── original.pdf              # Original PDF file
        ├── pages/
        │   ├── page-001.webp         # Page preview images
        │   ├── page-002.webp
        │   └── ...
        └── thumbnails/
            ├── page-001-thumb.webp   # Small thumbnails for grid view
            └── ...
```

**Storage approach:**
- Original PDF stored in custom `pdf/` subdirectory
- NOT using `asset_file` table for pages/thumbnails (custom path structure)
- Paths stored directly in `pdf_page.thumbnailPath` column
- Immich's existing storage service utilities can be reused for file operations

### 5. Upload Flow

**Dedicated PDF upload endpoint (per user requirement):**

```
POST /api/pdf/upload
```

**Flow:**
1. User uploads PDF via dedicated endpoint
2. PdfController receives file and creates:
   - `asset` record (type=OTHER)
   - `pdf_asset` record (metadata)
3. Original PDF saved to `{uploadLibrary}/pdf/{userId}/{assetId}/original.pdf`
4. Background job queued: `PdfProcessing`
5. Returns PDF asset ID to client

**Minimal integration with existing code:**
- Still creates standard `asset` record for consistency
- Uses existing user authentication/permissions
- Leverages existing storage service for file operations

### 6. Processing Pipeline

```
PDF Upload → Asset Creation → Queue PdfProcessing Job →

1. Extract PDF metadata (page count, author, title, etc.)
   → Store in pdf_asset table

2. Extract text from PDF (if available)
   → Store text per page in pdf_page table
   → Update hasText flag

3. If no text or incomplete text → Run PDF OCR (separate service per user requirement)
   → Convert each page to image
   → Run dedicated PDF OCR service (Tesseract.js)
   → Store results in pdf_page_ocr table

4. Generate page thumbnails
   → Create preview images for each page
   → Store paths in pdf_page table

5. Index for search
   → Concatenate all page text
   → Store in pdf_search table with GIN index
```

### 7. API Endpoints (New Controller)

**Path prefix: `/api/pdf`** (new controller, no existing contract changes)

```
POST   /api/pdf/upload              # Dedicated PDF upload endpoint
GET    /api/pdf/assets              # List all PDFs (separate section)
GET    /api/pdf/assets/:id          # Get PDF metadata with pages
GET    /api/pdf/assets/:id/pages    # Get all pages for a PDF
GET    /api/pdf/assets/:id/pages/:n # Get specific page with image
GET    /api/pdf/assets/:id/download # Download original PDF
GET    /api/pdf/page/:pageId/image  # Get page image
```

**Separate PDF UI section:**
- PDFs have their own dedicated section in the UI
- NOT mixed with photos in the main timeline
- Consistent with "separate PDF section" user requirement

**Search Extension:**
- Extend existing `/api/search/metadata` to support PDF content search
- Add new search option: `pdfText?: string` (optional, non-breaking)

### 8. Search Integration

**Extend `searchAssetBuilder` function:**
```typescript
// In server/src/utils/database.ts
.$if(!!options.pdfText, (qb) =>
  qb
    .innerJoin('pdf_search', 'asset.id', 'pdf_search.assetId')
    .where(() => sql`f_unaccent(pdf_search.text) %>> f_unaccent(${options.pdfText})`),
)
```

### 9. Dependencies

**New npm packages:**
- `pdf-parse` - Extract text and metadata from PDFs
- `pdf-poppler` or `sharp` - Convert PDF pages to images for OCR/thumbnails
- `tesseract.js` - OCR processing (or use existing Tesseract setup)

### 10. Code Changes Summary

**Files to CREATE:**
| Path | Purpose |
|------|---------|
| `server/src/pdf/dto/pdf.dto.ts` | PDF DTOs |
| `server/src/pdf/dto/pdf-response.dto.ts` | Response DTOs |
| `server/src/pdf/repositories/pdf.repository.ts` | PDF data access |
| `server/src/pdf/repositories/pdf-page.repository.ts` | Page data access |
| `server/src/pdf/services/pdf.service.ts` | Main PDF service |
| `server/src/pdf/services/pdf-processing.service.ts` | Processing logic |
| `server/src/pdf/services/pdf-ocr.service.ts` | OCR service |
| `server/src/pdf/controllers/pdf.controller.ts` | API endpoints |
| `server/src/pdf/jobs/pdf-processor.job.ts` | Background job |
| `server/src/pdf/utils/pdf-extractor.util.ts` | PDF parsing utilities |
| `server/src/pdf/utils/pdf-thumbnail.util.ts` | Thumbnail generation |
| `server/src/schema/tables/pdf-asset.table.ts` | DB schema |
| `server/src/schema/tables/pdf-page.table.ts` | DB schema |
| `server/src/schema/tables/pdf-page-ocr.table.ts` | DB schema |
| `server/src/schema/tables/pdf-search.table.ts` | DB schema |
| `server/src/schema/migrations/{timestamp}-AddPdfTables.ts` | Migration |

**Files to MODIFY (minimal changes - only additive):**
| Path | Change | Merge Conflict Risk |
|------|--------|---------------------|
| `server/src/schema/index.ts` | Add new tables to DB interface | **Low** - Additive only |
| `server/src/services/index.ts` | Add new services to exports | **Low** - Additive only |
| `server/src/controllers/index.ts` | Add PDF controller | **Low** - Additive only |
| `server/src/enum.ts` | Add JobName.PdfProcessing, QueueName.PdfProcessing, ApiTag.PdfAssets | **Low** - Additive only |
| `server/src/dtos/search.dto.ts` | Add optional `pdfText?: string` field | **Low** - Additive only |
| `server/src/utils/database.ts` | Extend searchAssetBuilder for PDF search | **Medium** - Add condition |

**Note: With dedicated `/api/pdf/upload` endpoint, NO changes needed to `asset-media.service.ts`**

### 11. Module Registration

**New NestJS Module structure:**
```typescript
// server/src/pdf/pdf.module.ts
@Module({
  imports: [ConfigModule],
  controllers: [PdfController],
  providers: [
    PdfService,
    PdfProcessingService,
    PdfOcrService,
    PdfRepository,
    PdfPageRepository,
  ],
  exports: [PdfService],
})
export class PdfModule {}
```

### 12. Verification & Testing

**Testing Checklist:**
1. Upload a PDF with text → Verify metadata extraction, page indexing
2. Upload a scanned PDF (no text) → Verify OCR runs
3. Search for text within PDF → Verify search returns correct PDFs
4. Browse PDF pages → Verify thumbnails load correctly
5. Download PDF → Verify original file intact
6. Delete PDF → Verify cascade deletes all PDF-related data
7. Test with mobile apps → Verify no API contract breaks

**Integration Tests:**
- Test PDF upload flow
- Test OCR processing job
- Test search functionality
- Test page retrieval

## Implementation Phases

### Phase 1: Database & Core Structure
- Create new table definitions
- Create migration
- Set up module structure
- Register in schema index

### Phase 2: Upload & Storage
- Create PDF upload endpoint
- Integrate with asset upload flow
- Store original PDF files
- Create background job

### Phase 3: Processing Pipeline
- PDF metadata extraction
- Text extraction
- Page thumbnail generation
- OCR integration

### Phase 4: Search & Browse
- Create search indexing
- Extend search service
- Create browse endpoints
- Page viewer API

### Phase 5: Testing & Polish
- Integration tests
- Error handling
- Performance optimization
- Documentation

## Key Files for Reference

**Existing patterns to follow:**
- `server/src/services/ocr.service.ts` - OCR implementation pattern
- `server/src/repositories/ocr.repository.ts` - Repository pattern
- `server/src/schema/tables/asset-ocr.table.ts` - Table definition pattern
- `server/src/services/asset-media.service.ts` - Upload handling
- `server/src/utils/database.ts` - Search builder pattern

**OpenAPI documentation:**
- Uses `@nestjs/swagger` decorators
- `@ApiTags()` for grouping
- `@Endpoint()` for documentation
- New controller will have its own tag (`ApiTag.PdfAssets`)
