# External GPU OCR Pipeline for Immich (Book Archive Optimized)

## Objective

Build a standalone Docker-based OCR service that:

* Runs as a sidecar container alongside Immich
* Is **automatically triggered** when Immich finishes its built-in OCR on a new asset
* Uses a superior OCR model pipeline (PaddleOCR detect + TrOCR recognize) on GPU
* **Overwrites** Immich's built-in OCR results directly in the database
* Results are immediately searchable via Immich's native OCR search (`%>>` trigram)
* Requires zero modification to Immich server/ML source code

---

## How Immich OCR Works Internally (Context)

Understanding the internals is critical for correct integration.

### Job Flow

```
Upload → AssetGenerateThumbnails
           ↓ (on success, job.service.ts queues follow-up jobs)
         SmartSearch (CLIP embedding)
         AssetDetectFaces
         Ocr ← this is what we hook into
```

### Immich's Built-in OCR

* **Model**: RapidOCR (in `machine-learning/immich_ml/models/ocr/`)
* **Input**: The asset's preview file (not the original), via ML microservice HTTP `/predict`
* **Output**: Text regions with bounding boxes and confidence scores

### Database Tables

1. **`asset_ocr`** — individual text regions with normalized bounding box coordinates:
   ```
   id | assetId | x1..x4, y1..y4 | boxScore | textScore | text | isVisible
   ```

2. **`ocr_search`** — denormalized concatenated text for search:
   ```
   assetId (PK, FK) | text
   ```
   Has GIN trigram index: `f_unaccent("text") gin_trgm_ops`

3. **`asset_job_status`** — tracks job completion:
   ```
   assetId | facesRecognizedAt | metadataExtractedAt | duplicatesDetectedAt | ocrAt
   ```
   `ocrAt` is set to `NOW()` when Immich's OCR completes for an asset.

### How Search Uses OCR

```sql
-- Immich search query (from server/src/utils/database.ts)
f_unaccent(ocr_search.text) %>> f_unaccent(tokenized_query)
```

Text is tokenized via `tokenizeForSearch()` which handles CJK bigram splitting. Latin text is stored as-is with spaces between regions.

### Key Insight

To make external OCR results searchable in exactly the same way as built-in OCR, we must write to the **same two tables** (`asset_ocr` + `ocr_search`). The `description` field or metadata API would use different search paths and would not appear in OCR search results.

---

## High-Level Architecture

```
┌──────────────────────────────────────────────────────────┐
│  Immich Stack (existing docker-compose)                  │
│                                                          │
│  immich-server ──► immich-ml ──► (RapidOCR runs)         │
│       │                              │                   │
│       │  sets ocrAt in               │                   │
│       │  asset_job_status            │                   │
│       ▼                              ▼                   │
│  ┌─────────────────────────────────────┐                 │
│  │         PostgreSQL                  │                 │
│  │  asset_job_status.ocrAt  ◄──────────│                 │
│  │  asset_ocr               ◄──────────│                 │
│  │  ocr_search              ◄──────────│                 │
│  └──────────┬──────────────────────────┘                 │
│             │ LISTEN/NOTIFY                              │
│             ▼                                            │
│  ┌──────────────────────────┐                            │
│  │  immich-ocr (new)        │  ◄── GPU container         │
│  │                          │                            │
│  │  1. Receives PG notify   │                            │
│  │  2. Fetches original img │                            │
│  │  3. Runs PaddleOCR+TrOCR│                            │
│  │  4. Writes to asset_ocr  │                            │
│  │     + ocr_search         │                            │
│  └──────────────────────────┘                            │
└──────────────────────────────────────────────────────────┘
```

---

## Trigger Mechanism: PostgreSQL LISTEN/NOTIFY

This is the cleanest automatic trigger that requires **no Immich code changes**.

### Setup (one-time, via init SQL or migration)

Create a PostgreSQL trigger function:

```sql
-- Trigger: fires when Immich sets ocrAt (meaning built-in OCR just finished)
CREATE OR REPLACE FUNCTION notify_ocr_complete()
RETURNS trigger AS $$
BEGIN
  -- Only fire when ocrAt transitions from NULL to non-NULL
  IF OLD."ocrAt" IS NULL AND NEW."ocrAt" IS NOT NULL THEN
    PERFORM pg_notify('ocr_complete', NEW."assetId");
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ocr_complete
AFTER UPDATE ON asset_job_status
FOR EACH ROW
EXECUTE FUNCTION notify_ocr_complete();
```

### Listener (in the OCR service)

```python
import psycopg2
import select

conn = psycopg2.connect(DB_URL)
conn.set_isolation_level(psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
cur = conn.cursor()
cur.execute("LISTEN ocr_complete;")

while True:
    if select.select([conn], [], [], 60) != ([], [], []):
        conn.poll()
        while conn.notifies:
            notify = conn.notifies.pop(0)
            asset_id = notify.payload
            queue_for_processing(asset_id)
```

### Why This Approach

| Approach | Auto-trigger | No Immich modification | Latency |
|---|---|---|---|
| Poll API periodically | Yes (delayed) | Yes | 30s–5min |
| Watch filesystem | Unreliable | Yes | Seconds |
| **PG LISTEN/NOTIFY** | **Yes (instant)** | **Yes (just SQL)** | **<1 second** |
| Modify Immich job handler | Yes | No | Instant |

The PG trigger is a SQL-only addition (can be applied via `docker exec` or init script), doesn't touch Immich code, and fires within milliseconds of Immich's OCR completion.

### Backfill / Catchup on Startup

On service startup, also query for assets that have Immich OCR but haven't been processed by external OCR:

```sql
SELECT ajs."assetId"
FROM asset_job_status ajs
LEFT JOIN ocr_external_state oes ON oes."assetId" = ajs."assetId"
WHERE ajs."ocrAt" IS NOT NULL
  AND oes."processedAt" IS NULL;
```

This handles: container restarts, missed notifications, backlog processing.

---

## Write-Back Strategy: Direct Database

### Why Not the REST API?

| Method | Searchable via OCR filter | Overwrites built-in OCR | Clean |
|---|---|---|---|
| `PUT /assets/{id}` (description) | No (uses `ilike` on `asset_exif.description`) | No | Yes |
| `PUT /assets/{id}/metadata` (key-value) | No (not indexed for search) | No | Yes |
| **Direct DB write to `ocr_search` + `asset_ocr`** | **Yes** | **Yes** | Moderate |

### Write Procedure

For each processed asset:

```sql
-- 1. Delete existing OCR regions for this asset
DELETE FROM asset_ocr WHERE "assetId" = $1;

-- 2. Insert new OCR regions (one per detected text box)
INSERT INTO asset_ocr ("assetId", x1, y1, x2, y2, x3, y3, x4, y4,
                        "boxScore", "textScore", text, "isVisible")
VALUES ($1, ...);

-- 3. Upsert concatenated search text
INSERT INTO ocr_search ("assetId", text)
VALUES ($1, $2)
ON CONFLICT ("assetId") DO UPDATE SET text = EXCLUDED.text;
```

This exactly mirrors what `OcrRepository.upsert()` does internally (see `server/src/repositories/ocr.repository.ts:59-75`).

### Text Tokenization

Must replicate Immich's `tokenizeForSearch()` from `server/src/utils/database.ts:266`:

* Latin text: keep as-is, split on whitespace
* CJK characters: split into bigrams (overlapping pairs)
* Single CJK char: keep as single token

Python equivalent:

```python
def tokenize_for_search(text: str) -> str:
    tokens = []
    i = 0
    while i < len(text):
        c = ord(text[i])
        if c <= 32:  # whitespace
            i += 1
            continue
        if is_cjk(c):
            start = i
            while i < len(text) and is_cjk(ord(text[i])):
                i += 1
            cjk_run = text[start:i]
            if len(cjk_run) == 1:
                tokens.append(cjk_run)
            else:
                for k in range(len(cjk_run) - 1):
                    tokens.append(cjk_run[k:k+2])
        else:
            start = i
            while i < len(text) and ord(text[i]) > 32 and not is_cjk(ord(text[i])):
                i += 1
            tokens.append(text[start:i])
    return ' '.join(tokens)
```

---

## State Tracking

Create a lightweight tracking table (external to Immich schema, in a separate schema or using a local SQLite):

### Option A: PostgreSQL table (recommended, same DB)

```sql
CREATE TABLE IF NOT EXISTS ocr_external_state (
  "assetId" uuid PRIMARY KEY REFERENCES assets(id) ON DELETE CASCADE,
  "processedAt" timestamp with time zone NOT NULL DEFAULT NOW(),
  "modelVersion" text NOT NULL,
  "textLength" integer NOT NULL DEFAULT 0
);
```

### Option B: Local SQLite (if you prefer not to touch PG)

```python
# state.db
CREATE TABLE processed (
  asset_id TEXT PRIMARY KEY,
  processed_at TEXT NOT NULL,
  model_version TEXT NOT NULL
);
```

**Recommendation**: Option A. It's in the same DB, supports the catchup query above, and is cleaned up automatically via CASCADE when assets are deleted.

---

## Design Principles

1. **No Immich source code modifications** — only SQL additions (trigger + optional state table)
2. **Overwrites built-in OCR** — writes to the same `asset_ocr` and `ocr_search` tables
3. **Instant trigger** — PG LISTEN/NOTIFY, sub-second latency after Immich OCR completes
4. **Idempotent** — safe to re-run, uses DELETE+INSERT pattern
5. **Restart-safe** — catchup query on startup processes any missed assets
6. **GPU required** — CUDA 11.8+ for TrOCR recognition
7. **Book-optimized** — preprocessing tuned for dense serif text on scanned pages

---

## Project Structure

```
ocr-service/
├── Dockerfile
├── requirements.txt
├── docker-compose.override.yml     # adds immich-ocr service
├── init.sql                        # PG trigger + state table creation
├── src/
│   ├── __init__.py
│   ├── main.py                     # entry point: listener + startup catchup
│   ├── config.py                   # env var config with validation
│   ├── db.py                       # PostgreSQL connection, listener, write-back
│   ├── pipeline.py                 # orchestrates preprocess → detect → recognize → write
│   ├── preprocess.py               # OpenCV image preprocessing
│   ├── detect.py                   # PaddleOCR text detection
│   ├── recognize.py                # TrOCR text recognition
│   ├── tokenize.py                 # tokenizeForSearch() port
│   └── models.py                   # data classes for OCR results
└── tests/
    ├── test_tokenize.py
    ├── test_preprocess.py
    └── test_pipeline.py
```

---

## Docker Setup

### Dockerfile

```dockerfile
FROM pytorch/pytorch:2.1.0-cuda11.8-cudnn8-runtime

RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1-mesa-glx libglib2.0-0 libpq-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ ./src/
COPY init.sql .

CMD ["python", "-m", "src.main"]
```

### requirements.txt

```
psycopg2-binary>=2.9
paddlepaddle-gpu>=2.5   # or paddleocr
paddleocr>=2.7
transformers>=4.35
torch>=2.1
Pillow>=10.0
opencv-python-headless>=4.8
numpy>=1.24
```

### docker-compose.override.yml

```yaml
services:
  immich-ocr:
    build: ./ocr-service
    container_name: immich-ocr
    restart: unless-stopped
    shm_size: "1g"
    depends_on:
      - database
    environment:
      DB_URL: "postgresql://${DB_USERNAME}:${DB_PASSWORD}@database:5432/${DB_DATABASE_NAME}"
      IMMICH_UPLOAD_DIR: /data/uploads
      OCR_MAX_RESOLUTION: 4032
      OCR_DETECTION_THRESHOLD: 0.3
      OCR_RECOGNITION_THRESHOLD: 0.6
      OCR_MODEL_NAME: "microsoft/trocr-base-printed"
      OCR_CONCURRENCY: 1
    volumes:
      - ${UPLOAD_LOCATION}:/data/uploads:ro
      - model-cache:/root/.cache
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    networks:
      - immich-network

volumes:
  model-cache:
```

Key: the container connects to Immich's **PostgreSQL directly** (same `database` service), not the Immich API. It reads images from the upload volume.

---

## Core Pipeline

### 1. Image Loading

```python
def load_image(upload_dir: str, asset_id: str) -> Image:
    # Query DB for the asset's originalPath
    # Read from /data/uploads/{originalPath}
    # Only process: .jpg, .jpeg, .png, .tiff, .webp
    # Skip if file doesn't exist (deleted/moved)
```

Must query the `asset_files` table to resolve the asset ID to a file path:

```sql
SELECT af."path"
FROM asset_files af
WHERE af."assetId" = $1 AND af."type" = 'original';
```

### 2. Preprocessing (`preprocess.py`)

Optimized for scanned book pages:

* Resize only if larger than `OCR_MAX_RESOLUTION` (default 4032px long edge)
* Deskew via Hough line transform or projection profile
* Convert to grayscale
* Adaptive thresholding (Gaussian, blockSize=15)
* CLAHE contrast normalization (clipLimit=2.0, tileGridSize=8x8)
* Optional mild unsharp mask

Returns preprocessed PIL Image.

### 3. Text Detection (`detect.py`)

PaddleOCR in detection-only mode:

```python
from paddleocr import PaddleOCR

detector = PaddleOCR(use_angle_cls=True, lang='en', use_gpu=False,
                      det=True, rec=False, cls=True)

def detect(image) -> list[BoundingBox]:
    results = detector.ocr(image, det=True, rec=False, cls=True)
    boxes = []
    for box in results[0]:
        score = box[1] if len(box) > 1 else 1.0
        if score >= DETECTION_THRESHOLD:
            boxes.append(normalize_box(box[0], image.size))
    return sorted(boxes, key=lambda b: (b.y_center, b.x_center))
```

Detection runs on CPU (low VRAM usage). GPU reserved for recognition.

### 4. Text Recognition (`recognize.py`)

Microsoft TrOCR on GPU:

```python
from transformers import TrOCRProcessor, VisionEncoderDecoderModel

processor = TrOCRProcessor.from_pretrained("microsoft/trocr-base-printed")
model = VisionEncoderDecoderModel.from_pretrained("microsoft/trocr-base-printed").to("cuda")

def recognize(image, boxes: list[BoundingBox]) -> list[OcrResult]:
    results = []
    for box in boxes:
        crop = image.crop(box.to_pixel_coords(image.size))
        pixel_values = processor(crop.convert("RGB"), return_tensors="pt").pixel_values.to("cuda")
        with torch.no_grad():
            generated = model.generate(pixel_values, max_new_tokens=128)
        text = processor.batch_decode(generated, skip_special_tokens=True)[0].strip()
        if text and len(text) > 0:
            results.append(OcrResult(box=box, text=text, score=box.box_score))
    return results
```

**Batch optimization**: Group crops into batches of 16-32 for GPU efficiency:

```python
# Batch inference for GPU throughput
pixel_batch = processor(crops, return_tensors="pt", padding=True).pixel_values.to("cuda")
with torch.no_grad():
    generated = model.generate(pixel_batch, max_new_tokens=128)
texts = processor.batch_decode(generated, skip_special_tokens=True)
```

### 5. Post-Processing

* Merge broken lines (heuristic: if two boxes overlap vertically >50% and are close horizontally, merge)
* Normalize unicode (NFC)
* Strip excessive whitespace
* Preserve paragraph spacing (gap > 1.5x line height = paragraph break)

### 6. Write to Database

```python
def write_ocr_results(conn, asset_id: str, results: list[OcrResult]):
    search_text = tokenize_for_search(' '.join(r.text for r in results))

    with conn.cursor() as cur:
        # Delete existing OCR data (overwrites Immich's built-in OCR)
        cur.execute('DELETE FROM asset_ocr WHERE "assetId" = %s', (asset_id,))

        # Insert new regions
        for r in results:
            cur.execute('''
                INSERT INTO asset_ocr ("assetId", x1, y1, x2, y2, x3, y3, x4, y4,
                                        "boxScore", "textScore", text, "isVisible")
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, true)
            ''', (asset_id, *r.box.as_flat(), r.box.box_score, r.score, r.text))

        # Upsert search text
        cur.execute('''
            INSERT INTO ocr_search ("assetId", text) VALUES (%s, %s)
            ON CONFLICT ("assetId") DO UPDATE SET text = EXCLUDED.text
        ''', (asset_id, search_text))

        # Track in external state
        cur.execute('''
            INSERT INTO ocr_external_state ("assetId", "processedAt", "modelVersion", "textLength")
            VALUES (%s, NOW(), %s, %s)
            ON CONFLICT ("assetId") DO UPDATE
            SET "processedAt" = NOW(), "modelVersion" = EXCLUDED."modelVersion",
                "textLength" = EXCLUDED."textLength"
        ''', (asset_id, MODEL_VERSION, len(search_text)))

    conn.commit()
```

---

## Main Entry Point (`main.py`)

```python
async def main():
    config = Config.from_env()
    config.validate()

    # Load ML models once at startup
    detector = load_detector(config)
    recognizer = load_recognizer(config)

    # Connect to PostgreSQL
    conn = connect_db(config.db_url)

    # 1. Apply init SQL (trigger + state table) if not exists
    apply_init_sql(conn)

    # 2. Catchup: process any assets missed while container was down
    missed = get_unprocessed_assets(conn)
    logger.info(f"Catchup: {len(missed)} assets to process")
    for asset_id in missed:
        process_asset(conn, config, detector, recognizer, asset_id)

    # 3. Listen for new assets
    logger.info("Listening for new OCR completions...")
    listen_conn = connect_db(config.db_url)  # separate connection for LISTEN
    listen_conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    cur = listen_conn.cursor()
    cur.execute("LISTEN ocr_complete;")

    while True:
        if select.select([listen_conn], [], [], 60) != ([], [], []):
            listen_conn.poll()
            while listen_conn.notifies:
                notify = listen_conn.notifies.pop(0)
                asset_id = notify.payload
                try:
                    process_asset(conn, config, detector, recognizer, asset_id)
                except Exception as e:
                    logger.error(f"Failed to process {asset_id}: {e}")
```

---

## Configuration (`config.py`)

| Env Var | Default | Description |
|---|---|---|
| `DB_URL` | (required) | PostgreSQL connection string |
| `IMMICH_UPLOAD_DIR` | `/data/uploads` | Mount path for Immich uploads |
| `OCR_MAX_RESOLUTION` | `4032` | Max image dimension (long edge) |
| `OCR_DETECTION_THRESHOLD` | `0.3` | Min PaddleOCR detection score |
| `OCR_RECOGNITION_THRESHOLD` | `0.6` | Min TrOCR recognition confidence |
| `OCR_MODEL_NAME` | `microsoft/trocr-base-printed` | HuggingFace model for recognition |
| `OCR_BATCH_SIZE` | `16` | Crops per GPU batch |
| `OCR_CONCURRENCY` | `1` | Parallel asset processing |
| `LOG_LEVEL` | `INFO` | Logging verbosity |

---

## Book-Specific Optimizations

For dense scanned book pages:

* **Do NOT downscale** below 3200px — small serif text becomes unreadable
* Detection threshold: 0.25-0.3 (lower = catch more text, risk more noise)
* Recognition threshold: 0.5-0.6
* Use `trocr-base-printed` (not `handwritten`) — better for typeset text
* CLAHE + adaptive threshold dramatically improves detection on yellowed pages
* Deskew is essential for photographed (non-flatbed) book scans

---

## Error Handling

* Individual asset failures are logged and skipped (never crash the container)
* Retry up to 3 times with exponential backoff (1s, 4s, 16s)
* Track failed assets in `ocr_external_state` with NULL `processedAt` for retry
* PG connection: auto-reconnect with backoff on connection loss
* GPU OOM: catch `torch.cuda.OutOfMemoryError`, skip oversized images, clear cache

---

## Performance Estimates

| Stage | Time per Image | Device |
|---|---|---|
| Image load + preprocess | ~200ms | CPU |
| PaddleOCR detection | ~300ms | CPU |
| TrOCR recognition (30 regions) | ~2-4s | GPU |
| DB write | ~10ms | - |
| **Total per image** | **~3-5s** | |

At 4s/image, a backlog of 1000 images takes ~67 minutes.

---

## Risk: Immich Upgrades

Direct DB writes carry schema coupling risk. Mitigations:

1. **Version check on startup**: query `ocr_search` and `asset_ocr` schema, refuse to start if columns are missing/changed
2. **Pin Immich version** in docker-compose and test before upgrading
3. The `ocr_search` and `asset_ocr` tables are new (added in recent migrations) so their schema is likely stable
4. Worst case: if Immich re-runs OCR, it will overwrite our data; our LISTEN trigger will fire again and we'll re-overwrite. This is safe because we always run after Immich's OCR.

---

## Alternative: Additive Mode (Non-Destructive)

If you prefer to **not** overwrite Immich's built-in OCR:

1. **Append to `ocr_search.text`** instead of replacing:
   ```sql
   UPDATE ocr_search SET text = text || ' ' || $2 WHERE "assetId" = $1;
   ```

2. **Add to `asset_ocr`** with a tag (e.g., use `boxScore = -1.0` as a sentinel for external OCR)

3. **Use `description` field** via REST API as a secondary searchable field:
   ```
   PUT /api/assets/{id} { "description": "<external OCR text>" }
   ```
   Searchable via Immich's description filter, but not via OCR filter.

**Recommendation**: Overwrite mode is better for book pages because Immich's RapidOCR typically produces lower quality results on dense text, and having duplicate/conflicting OCR text in search degrades relevance.

---

## Implementation Phases

### Phase 1: Minimal Working Pipeline
- [ ] `init.sql` with PG trigger and state table
- [ ] `config.py` + `db.py` (connection, listener, write-back)
- [ ] `tokenize.py` (port of `tokenizeForSearch`)
- [ ] `pipeline.py` with hardcoded PaddleOCR + TrOCR
- [ ] `main.py` entry point with catchup + listener
- [ ] Dockerfile + docker-compose.override.yml
- [ ] Test with one book page image

### Phase 2: Preprocessing + Quality
- [ ] `preprocess.py` (deskew, threshold, CLAHE)
- [ ] Batch GPU inference in `recognize.py`
- [ ] Line merging and paragraph detection in post-processing
- [ ] Error handling + retry logic

### Phase 3: Production Hardening
- [ ] Schema version check on startup
- [ ] GPU OOM handling
- [ ] Structured logging
- [ ] Health check endpoint
- [ ] Metrics (processed count, avg time, error rate)

---

## Acceptance Criteria

1. Container starts, connects to PG, loads models, begins listening
2. When a new image is uploaded to Immich, external OCR runs automatically within seconds
3. OCR text is searchable via Immich's search bar (OCR filter)
4. Results are superior to Immich's built-in OCR on book page images
5. Service survives container restart (catchup processes missed assets)
6. No duplicate processing of same asset (idempotent writes)
7. No Immich server/ML source code modified

---

## Non-Goals

* Replacing Immich's ML container or built-in OCR pipeline
* Cloud-based OCR (everything runs locally)
* Real-time <1s processing
* Handwriting recognition
* PDF text extraction (images only)

---

END OF PLAN
