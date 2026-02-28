# External GPU OCR Pipeline for Immich (Unified Plan)

## Goal

Build an external OCR pipeline that:

- Is **automatically triggered** when Immich finishes processing a new asset (no race condition)
- Uses a superior OCR model stack (PaddleOCR detect + TrOCR recognize) on GPU
- **Overwrites** Immich's built-in OCR so results are natively searchable
- Writes through a **bridge API** that reuses Immich's own repository layer (upgrade-safe)
- Tracks provenance (model version, source checksum) for intelligent reprocessing
- Requires only two additions to the fork: one SQL trigger + one additive server module

---

## What Exists Today (This Fork)

- Immich stores OCR in two DB tables:
  - `asset_ocr` — bounding boxes + text + scores per region
  - `ocr_search` — concatenated search text with GIN trigram index (`f_unaccent("text") gin_trgm_ops`)
- OCR search queries `ocr_search.text` via `%>>` trigram operator
- Internal OCR uses RapidOCR on preview-quality images (not originals)
- Job completion is tracked in `asset_job_status.ocrAt`
- There is a read endpoint (`GET /api/assets/:id/ocr`) but no write endpoint for OCR
- Asset metadata API (`PUT /api/assets/:id/metadata`) is **not** used by OCR search

**Implication**: To be searchable via Immich's OCR filter, data must land in `asset_ocr` + `ocr_search`. The bridge API handles this by calling `ocrRepository.upsert()` internally.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│  Immich Stack                                               │
│                                                             │
│  Upload → Thumbnails → [SmartSearch, Faces, Ocr]            │
│                                          │                  │
│                              sets ocrAt ─┘                  │
│                                                             │
│  ┌─────────────────────┐    ┌──────────────────────────┐    │
│  │    PostgreSQL        │    │  immich-server            │    │
│  │                      │    │                          │    │
│  │  asset_job_status    │    │  + Bridge API module     │    │
│  │    ocrAt updated ────┼──► │    PUT /api/external-ocr │    │
│  │    (PG NOTIFY)       │    │    /assets/:id/result    │    │
│  │                      │    │    calls ocrRepository   │    │
│  └──────────────────────┘    │    .upsert() internally  │    │
│                              └─────────▲────────────────┘    │
│                                        │                     │
│  ┌─────────────────────────────────────┼────────────────┐    │
│  │  immich-ocr (new GPU container)     │                │    │
│  │                                     │                │    │
│  │  1. PG LISTEN ocr_complete ─────────┘                │    │
│  │  2. GET /api/assets/:id/original  (fetch image)      │    │
│  │  3. Preprocess → PaddleOCR → TrOCR                   │    │
│  │  4. PUT /api/external-ocr/assets/:id/result          │    │
│  └──────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

### Why This Combination

| Component | Approach | Rationale |
|---|---|---|
| **Trigger** | PG `LISTEN/NOTIFY` on `ocrAt` | Fires *after* internal OCR, no race condition, no server code for triggering |
| **Write-back** | Bridge API in server | Reuses `ocrRepository.upsert()`, survives schema changes, validates input |
| **Image source** | `GET /api/assets/:id/original` | No volume mount needed, proper auth, works across network boundaries |
| **Provenance** | Metadata key + bridge tracking | Model revision + checksum enables smart reprocessing |

---

## Component 1: PG Trigger (SQL-only, no server code)

Fires when Immich's internal OCR completes (sets `ocrAt`). Applied via init script or `docker exec`.

```sql
-- init.sql

CREATE OR REPLACE FUNCTION notify_ocr_complete()
RETURNS trigger AS $$
BEGIN
  IF OLD."ocrAt" IS NULL AND NEW."ocrAt" IS NOT NULL THEN
    PERFORM pg_notify('ocr_complete', NEW."assetId");
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'trg_ocr_complete'
  ) THEN
    CREATE TRIGGER trg_ocr_complete
    AFTER UPDATE ON asset_job_status
    FOR EACH ROW
    EXECUTE FUNCTION notify_ocr_complete();
  END IF;
END;
$$;
```

**Timing guarantee**: The trigger fires only after Immich's OCR has written its results and set `ocrAt`. The external pipeline always runs second, so its `mode=replace` call is the final write.

---

## Component 2: Bridge API (Additive Server Module)

A new controller + service added to the Immich server fork. Kept in a separate module to minimize merge conflicts with upstream.

### New Endpoint: Write OCR Result

```
PUT /api/external-ocr/assets/:id/result
```

**Request payload** (`ExternalOcrResultDto`):

```typescript
{
  provider: string;              // e.g. "immich-ocr-gpu"
  model: string;                 // e.g. "paddleocr+trocr-base-printed"
  modelRevision: string;         // e.g. "v1.0.0"
  sourceChecksum: string;        // SHA256 of processed image
  language?: string;             // e.g. "en"
  mode: "replace" | "merge";     // "replace" = overwrite, "merge" = append
  processedAt: string;           // ISO timestamp
  lines: Array<{
    x1: number; y1: number;      // normalized [0..1] quadrilateral
    x2: number; y2: number;
    x3: number; y3: number;
    x4: number; y4: number;
    boxScore: number;
    textScore: number;
    text: string;
  }>;
  searchText?: string;           // pre-tokenized; if omitted, server tokenizes
}
```

**Server behavior**:

1. Validate asset exists and caller has permission
2. Validate box coordinates are in `[0, 1]` range
3. If `searchText` is omitted, compute it from `lines[].text` using `tokenizeForSearch()`
4. Call `ocrRepository.upsert(assetId, lines, searchText)` — same method Immich's internal OCR uses
5. Set `asset_job_status.ocrAt = now()` (refresh timestamp)
6. Upsert metadata key `external.ocr.v1` with provenance: `{ provider, model, modelRevision, sourceChecksum, processedAt }`
7. Return `{ written: lines.length, searchTextLength: searchText.length }`

### New Endpoint: Report Failure

```
PUT /api/external-ocr/assets/:id/failure
```

**Request payload**:

```typescript
{
  provider: string;
  reason: string;
  retryCount: number;
  retriable: boolean;
}
```

**Server behavior**: Upsert metadata key `external.ocr.status` with failure info. Does not block future retries.

### Implementation Sketch

```
server/src/controllers/external-ocr.controller.ts   # routes
server/src/services/external-ocr.service.ts          # logic
server/src/dtos/external-ocr.dto.ts                  # validation
```

The service injects the existing `OcrRepository` and `AssetRepository` — no new DB code needed.

```typescript
// external-ocr.service.ts (sketch)
@Injectable()
export class ExternalOcrService extends BaseService {
  async writeResult(auth: AuthDto, assetId: string, dto: ExternalOcrResultDto) {
    const asset = await this.assetRepository.getById(assetId);
    if (!asset) throw new NotFoundException();

    const searchText = dto.searchText ?? tokenizeForSearch(
      dto.lines.map(l => l.text).join(' ')
    );

    const ocrDataList = dto.lines.map(line => ({
      assetId,
      ...line,  // x1..y4, boxScore, textScore, text
    }));

    await this.ocrRepository.upsert(assetId, ocrDataList, searchText);
    await this.assetRepository.upsertJobStatus({ assetId, ocrAt: new Date() });

    // Store provenance in asset metadata
    await this.assetRepository.upsertMetadata(assetId, 'external.ocr.v1', {
      provider: dto.provider,
      model: dto.model,
      modelRevision: dto.modelRevision,
      sourceChecksum: dto.sourceChecksum,
      processedAt: dto.processedAt,
    });

    return { written: ocrDataList.length, searchTextLength: searchText.length };
  }
}
```

---

## Component 3: External OCR Service (GPU Container)

A standalone Python service that listens for PG notifications and processes assets.

### Project Structure

```
ocr-service/
├── Dockerfile
├── requirements.txt
├── init.sql                        # PG trigger (applied on first run)
├── src/
│   ├── __init__.py
│   ├── main.py                     # entry point: listener + startup catchup
│   ├── config.py                   # env var config with validation
│   ├── listener.py                 # PG LISTEN/NOTIFY consumer
│   ├── client.py                   # Immich API client (download + bridge)
│   ├── pipeline.py                 # orchestrates preprocess → detect → recognize
│   ├── preprocess.py               # OpenCV image preprocessing
│   ├── detect.py                   # PaddleOCR text detection
│   ├── recognize.py                # TrOCR text recognition (GPU)
│   ├── tokenize.py                 # tokenizeForSearch() port (for pre-tokenization)
│   └── models.py                   # data classes for OCR results
└── tests/
    ├── test_tokenize.py
    ├── test_preprocess.py
    └── test_pipeline.py
```

### Main Loop (`main.py`)

```python
async def main():
    config = Config.from_env()
    config.validate()

    # Load ML models once at startup
    detector = load_detector(config)
    recognizer = load_recognizer(config)
    api = ImmichClient(config.immich_url, config.api_key)

    # 1. Apply init SQL (PG trigger) if not already present
    apply_init_sql(config.db_url)

    # 2. Catchup: process assets missed while container was down
    missed = api.get_assets_needing_external_ocr()
    logger.info(f"Catchup: {len(missed)} assets to process")
    for asset_id in missed:
        process_asset(api, config, detector, recognizer, asset_id)

    # 3. Listen for new OCR completions
    logger.info("Listening for OCR completions...")
    listener = PgListener(config.db_url, channel="ocr_complete")

    for asset_id in listener:
        try:
            process_asset(api, config, detector, recognizer, asset_id)
        except Exception as e:
            logger.error(f"Failed to process {asset_id}: {e}")
            api.report_failure(asset_id, reason=str(e))
```

### Asset Processing (`pipeline.py`)

```python
def process_asset(api, config, detector, recognizer, asset_id: str):
    # 1. Check if already processed with current model version
    meta = api.get_asset_metadata(asset_id, key="external.ocr.v1")
    if meta and meta.get("modelRevision") == config.model_revision:
        logger.debug(f"Skipping {asset_id}: already processed with {config.model_revision}")
        return

    # 2. Download original image via API
    image_bytes = api.download_original(asset_id)
    image = Image.open(io.BytesIO(image_bytes))
    source_checksum = hashlib.sha256(image_bytes).hexdigest()

    # 3. Preprocess
    processed = preprocess(image, max_resolution=config.max_resolution)

    # 4. Detect text regions (CPU)
    boxes = detector.detect(processed)
    if not boxes:
        logger.info(f"No text detected in {asset_id}")
        api.write_ocr_result(asset_id, lines=[], source_checksum=source_checksum)
        return

    # 5. Recognize text (GPU, batched)
    results = recognizer.recognize(processed, boxes, batch_size=config.batch_size)

    # 6. Post-process: merge lines, normalize unicode
    results = postprocess(results)

    # 7. Pre-tokenize search text
    raw_text = ' '.join(r.text for r in results)
    search_text = tokenize_for_search(raw_text)

    # 8. Write back via bridge API
    lines = [r.to_api_dict() for r in results]
    api.write_ocr_result(asset_id, lines=lines,
                         search_text=search_text,
                         source_checksum=source_checksum)

    logger.info(f"Processed {asset_id}: {len(lines)} regions, {len(search_text)} chars")
```

### Immich API Client (`client.py`)

```python
class ImmichClient:
    def __init__(self, base_url: str, api_key: str):
        self.base_url = base_url.rstrip('/')
        self.headers = {"x-api-key": api_key}

    def download_original(self, asset_id: str) -> bytes:
        r = requests.get(f"{self.base_url}/api/assets/{asset_id}/original",
                         headers=self.headers)
        r.raise_for_status()
        return r.content

    def get_asset_metadata(self, asset_id: str, key: str) -> dict | None:
        r = requests.get(f"{self.base_url}/api/assets/{asset_id}/metadata/{key}",
                         headers=self.headers)
        if r.status_code == 404:
            return None
        r.raise_for_status()
        return r.json()

    def write_ocr_result(self, asset_id: str, lines: list, search_text: str = None,
                         source_checksum: str = ""):
        payload = {
            "provider": "immich-ocr-gpu",
            "model": "paddleocr+trocr-base-printed",
            "modelRevision": MODEL_REVISION,
            "sourceChecksum": source_checksum,
            "mode": "replace",
            "processedAt": datetime.utcnow().isoformat() + "Z",
            "lines": lines,
        }
        if search_text:
            payload["searchText"] = search_text
        r = requests.put(f"{self.base_url}/api/external-ocr/assets/{asset_id}/result",
                         headers=self.headers, json=payload)
        r.raise_for_status()
        return r.json()

    def report_failure(self, asset_id: str, reason: str, retry_count: int = 0):
        payload = {
            "provider": "immich-ocr-gpu",
            "reason": reason,
            "retryCount": retry_count,
            "retriable": True,
        }
        r = requests.put(f"{self.base_url}/api/external-ocr/assets/{asset_id}/failure",
                         headers=self.headers, json=payload)
        r.raise_for_status()
```

### PG Listener (`listener.py`)

```python
import psycopg2
import select

class PgListener:
    def __init__(self, db_url: str, channel: str = "ocr_complete"):
        self.conn = psycopg2.connect(db_url)
        self.conn.set_isolation_level(
            psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
        self.channel = channel
        cur = self.conn.cursor()
        cur.execute(f"LISTEN {channel};")

    def __iter__(self):
        return self

    def __next__(self) -> str:
        while True:
            if select.select([self.conn], [], [], 60) != ([], [], []):
                self.conn.poll()
                while self.conn.notifies:
                    notify = self.conn.notifies.pop(0)
                    return notify.payload
            # Timeout: send keepalive / check connection
            self._keepalive()

    def _keepalive(self):
        try:
            cur = self.conn.cursor()
            cur.execute("SELECT 1")
        except Exception:
            self._reconnect()

    def _reconnect(self):
        # Reconnect with backoff...
        pass
```

### Catchup Query

On startup, find assets where Immich has completed OCR but external OCR hasn't run (or model version changed):

```python
def get_assets_needing_external_ocr(self) -> list[str]:
    """Use search/metadata API to find candidates, then filter by metadata key."""
    # Get all assets with OCR completed
    # Filter out those with matching external.ocr.v1.modelRevision
    # This can be done via the metadata search + filtering
    pass
```

Alternatively, a direct SQL query (the PG listener connection can double for this):

```sql
SELECT ajs."assetId"
FROM asset_job_status ajs
WHERE ajs."ocrAt" IS NOT NULL
  AND NOT EXISTS (
    SELECT 1 FROM asset_metadata am
    WHERE am."assetId" = ajs."assetId"
      AND am."key" = 'external.ocr.v1'
      AND am."value"->>'modelRevision' = $1
  );
```

---

## OCR Pipeline Details

### Preprocessing (`preprocess.py`)

Optimized for scanned book pages:

1. **Resize** only if larger than `OCR_MAX_RESOLUTION` (default 4032px long edge)
2. **Deskew** via Hough line transform or projection profile
3. **Convert to grayscale**
4. **Adaptive thresholding** (Gaussian, blockSize=15)
5. **CLAHE contrast normalization** (clipLimit=2.0, tileGridSize=8x8)
6. **Optional mild unsharp mask**

### Text Detection (`detect.py`)

PaddleOCR in detection-only mode (CPU):

```python
from paddleocr import PaddleOCR

detector = PaddleOCR(use_angle_cls=True, lang='en', use_gpu=False,
                      det=True, rec=False, cls=True)
```

- Filter boxes by score >= `OCR_DETECTION_THRESHOLD`
- Remove extremely small boxes
- Sort top-to-bottom, left-to-right (reading order)
- Normalize coordinates to `[0, 1]` range

### Text Recognition (`recognize.py`)

Microsoft TrOCR on GPU with batch inference:

```python
from transformers import TrOCRProcessor, VisionEncoderDecoderModel

processor = TrOCRProcessor.from_pretrained("microsoft/trocr-base-printed")
model = VisionEncoderDecoderModel.from_pretrained(
    "microsoft/trocr-base-printed").to("cuda")

def recognize_batch(image, boxes, batch_size=16):
    results = []
    crops = [image.crop(box.to_pixel_coords(image.size)).convert("RGB")
             for box in boxes]

    for i in range(0, len(crops), batch_size):
        batch = crops[i:i+batch_size]
        pixel_values = processor(batch, return_tensors="pt",
                                  padding=True).pixel_values.to("cuda")
        with torch.no_grad():
            generated = model.generate(pixel_values, max_new_tokens=128)
        texts = processor.batch_decode(generated, skip_special_tokens=True)

        for j, text in enumerate(texts):
            text = text.strip()
            if text:
                results.append(OcrResult(
                    box=boxes[i+j], text=text, score=boxes[i+j].box_score))
    return results
```

### Post-Processing

- Merge broken lines (heuristic: vertical overlap >50% and close horizontal gap)
- Normalize unicode (NFC)
- Preserve paragraph spacing (vertical gap > 1.5x line height = paragraph break)
- Remove duplicate lines
- Strip excessive whitespace

### Tokenization (`tokenize.py`)

Port of Immich's `tokenizeForSearch()` from `server/src/utils/database.ts:266`. Used for pre-computing `searchText` so the bridge API doesn't need to re-tokenize:

```python
def is_cjk(c: int) -> bool:
    return (0x4E00 <= c <= 0x9FFF or 0x3400 <= c <= 0x4DBF or
            0x20000 <= c <= 0x2A6DF or 0x2A700 <= c <= 0x2B73F or
            0x2B740 <= c <= 0x2B81F or 0x2B820 <= c <= 0x2CEAF or
            0xF900 <= c <= 0xFAFF or 0x2F800 <= c <= 0x2FA1F or
            0x3000 <= c <= 0x303F or 0x3040 <= c <= 0x309F or
            0x30A0 <= c <= 0x30FF or 0xAC00 <= c <= 0xD7AF)

def tokenize_for_search(text: str) -> str:
    tokens = []
    i = 0
    while i < len(text):
        c = ord(text[i])
        if c <= 32:
            i += 1
            continue
        if is_cjk(c):
            start = i
            while i < len(text) and is_cjk(ord(text[i])):
                i += 1
            run = text[start:i]
            if len(run) == 1:
                tokens.append(run)
            else:
                for k in range(len(run) - 1):
                    tokens.append(run[k:k+2])
        else:
            start = i
            while i < len(text) and ord(text[i]) > 32 and not is_cjk(ord(text[i])):
                i += 1
            tokens.append(text[start:i])
    return ' '.join(tokens)
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

COPY init.sql .
COPY src/ ./src/

CMD ["python", "-m", "src.main"]
```

### requirements.txt

```
psycopg2-binary>=2.9
paddlepaddle-gpu>=2.5
paddleocr>=2.7
transformers>=4.35
torch>=2.1
Pillow>=10.0
opencv-python-headless>=4.8
numpy>=1.24
requests>=2.31
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
      - immich-server
    environment:
      DB_URL: "postgresql://${DB_USERNAME}:${DB_PASSWORD}@database:5432/${DB_DATABASE_NAME}"
      IMMICH_URL: "http://immich-server:2283"
      IMMICH_API_KEY: "${IMMICH_OCR_API_KEY}"
      OCR_MAX_RESOLUTION: "4032"
      OCR_DETECTION_THRESHOLD: "0.3"
      OCR_RECOGNITION_THRESHOLD: "0.6"
      OCR_MODEL_NAME: "microsoft/trocr-base-printed"
      OCR_MODEL_REVISION: "v1.0.0"
      OCR_BATCH_SIZE: "16"
      LOG_LEVEL: "INFO"
    volumes:
      - model-cache:/root/.cache
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

volumes:
  model-cache:
```

**Key**: The container needs **two connections**:
1. **PG direct** (DB_URL) — for LISTEN/NOTIFY only (read-only, narrow scope)
2. **Immich API** (IMMICH_URL + API key) — for image download + bridge API write

No upload volume mount needed — images are fetched via API.

---

## Configuration

| Env Var | Default | Description |
|---|---|---|
| `DB_URL` | (required) | PostgreSQL connection string (for LISTEN only) |
| `IMMICH_URL` | (required) | Immich server URL |
| `IMMICH_API_KEY` | (required) | API key with asset read + external-ocr write permissions |
| `OCR_MAX_RESOLUTION` | `4032` | Max image dimension (long edge) |
| `OCR_DETECTION_THRESHOLD` | `0.3` | Min PaddleOCR detection score |
| `OCR_RECOGNITION_THRESHOLD` | `0.6` | Min TrOCR confidence |
| `OCR_MODEL_NAME` | `microsoft/trocr-base-printed` | HuggingFace model for recognition |
| `OCR_MODEL_REVISION` | `v1.0.0` | Version string for provenance tracking |
| `OCR_BATCH_SIZE` | `16` | Crops per GPU batch |
| `LOG_LEVEL` | `INFO` | Logging verbosity |

---

## Internal OCR Coexistence

### Recommended: Dual-run, external wins

- Keep Immich internal OCR **enabled**
- Internal OCR runs first (fast, low quality on book pages)
- PG trigger fires → external OCR runs → bridge API overwrites with better results
- Net effect: assets always have *some* OCR quickly, then get upgraded

### Alternative: Disable internal OCR

- Set `machineLearning.ocr.enabled = false` in Immich config
- External pipeline becomes sole OCR writer
- Simpler, but assets have no OCR until external service processes them

---

## "Needs Processing" Rules

Process when all are true:
- `asset_job_status.ocrAt IS NOT NULL` (Immich has finished its pass)
- Asset is visible and not deleted
- Asset type is `IMAGE` (optionally `VIDEO` frame extraction later)
- No `external.ocr.v1` metadata with matching `modelRevision`

Reprocess when:
- Model revision changes (new `OCR_MODEL_REVISION`)
- Asset content changed (different `sourceChecksum`)
- Manual requeue requested

---

## Security

- **API key**: Dedicated key with minimum permissions (`asset.read`, `asset.download`, `external-ocr.write`)
- **Bridge validation**: Reject payloads with coordinates outside `[0, 1]`, oversized text, or invalid asset IDs
- **PG connection**: Read-only for LISTEN (no writes via PG, all writes via API)
- **Rate limiting**: Bridge endpoint rate-limited per API key

---

## Error Handling

- Individual asset failures logged and reported via failure endpoint
- Retry up to 3 times with exponential backoff (1s, 4s, 16s)
- GPU OOM: catch `torch.cuda.OutOfMemoryError`, skip image, clear cache, continue
- PG connection loss: auto-reconnect with backoff
- Immich API down: backoff and retry, notifications accumulate in PG
- Never crash the container — log, report, skip, continue

---

## Observability

Track:
- Queue depth (pending notifications)
- Success/failure rate per hour
- Median processing latency per asset
- OCR character count per asset
- Retry counts and dead-letter assets
- Drift metric: assets where `ocrAt` is set but `external.ocr.v1` is missing/stale

---

## Performance Estimates

| Stage | Time per Image | Device |
|---|---|---|
| API download (original) | ~200ms | Network |
| Preprocess | ~200ms | CPU |
| PaddleOCR detection | ~300ms | CPU |
| TrOCR recognition (30 regions, batched) | ~2-4s | GPU |
| Bridge API write | ~50ms | Network |
| **Total per image** | **~3-5s** | |

At 4s/image, a backlog of 1000 images takes ~67 minutes.

---

## Book-Specific Optimizations

- **Do NOT downscale** below 3200px — small serif text becomes unreadable
- Detection threshold: 0.25-0.3 (lower = catch more text, risk more noise)
- Recognition threshold: 0.5-0.6
- Use `trocr-base-printed` (not `handwritten`) — better for typeset text
- CLAHE + adaptive threshold dramatically improves detection on yellowed pages
- Deskew is essential for photographed (non-flatbed) book scans

---

## Implementation Phases

### Phase 1: Bridge API + Minimal Pipeline
- [ ] Add bridge API module to Immich server (`external-ocr.controller.ts`, `.service.ts`, `.dto.ts`)
- [ ] `init.sql` with PG trigger
- [ ] External service: `config.py`, `listener.py`, `client.py`
- [ ] `pipeline.py` with hardcoded PaddleOCR + TrOCR (no preprocessing)
- [ ] `tokenize.py` (port of `tokenizeForSearch`)
- [ ] Dockerfile + docker-compose.override.yml
- [ ] Test end-to-end with one book page: upload → internal OCR → trigger → external OCR → search works

### Phase 2: Preprocessing + Quality
- [ ] `preprocess.py` (deskew, threshold, CLAHE)
- [ ] Batch GPU inference in `recognize.py`
- [ ] Line merging and paragraph detection
- [ ] Failure endpoint + retry logic

### Phase 3: Production Hardening
- [ ] Catchup query on startup
- [ ] PG connection auto-reconnect
- [ ] GPU OOM handling
- [ ] Schema/version check on startup
- [ ] Structured logging + observability metrics

### Phase 4: Quality Tuning
- [ ] Tune preprocessing for various book scan qualities
- [ ] A/B compare internal vs external OCR on test set
- [ ] Add manual reprocess command (by asset ID or date range)
- [ ] Optional: layout analysis for multi-column pages

---

## Acceptance Criteria

1. New uploads are OCR-processed automatically without manual action
2. OCR text is searchable in Immich via the OCR search filter
3. External OCR overwrites internal OCR deterministically (no race condition)
4. Reprocessing happens when model revision changes
5. Service recovers after restart without duplicating work
6. Failures are visible via metadata, retryable, and don't block the queue
7. No modification to Immich's core OCR code — only additive bridge module + SQL trigger

---

## Fork Maintenance Notes

- Bridge API is a new additive module — no patches to existing controllers/services
- Reuses existing `OcrRepository` and `AssetRepository` — benefits from upstream improvements
- PG trigger is standalone SQL — independent of server code
- If upstream adds webhook/notification support, the PG trigger can be replaced transparently
- Keep the external OCR service in a separate directory (`ocr-service/`) outside the main Immich tree

---

END OF PLAN
