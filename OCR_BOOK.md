# External GPU OCR Pipeline for Immich (Final Unified Plan)

## Goal

Build an external OCR pipeline that:

- Is automatically triggered when Immich processes a new asset
- Uses a higher-quality OCR stack (PaddleOCR detect + TrOCR recognize) on GPU
- Overwrites Immich's built-in OCR so results are natively searchable
- Writes through a bridge API that reuses Immich's own repository layer (upgrade-safe)
- Tracks provenance (model version, source checksum) for intelligent reprocessing
- Can fall back to secondary metadata/description mode if bridge is unavailable
- Minimizes upstream merge risk in this fork

## Scope and Success Conditions

This plan covers:
- Automatic triggering (real-time + reconcile safety net)
- OCR processing (image-first; PDF optional later)
- Write-back integration (primary bridge mode + contingency modes)
- Searchability guarantees
- Idempotency, retries, and restart safety
- Security and upgrade guardrails

Success means:
- New eligible assets are OCR-processed automatically
- OCR text is searchable through Immich's native OCR search filter
- External OCR can become authoritative when configured
- Processing is resilient to restarts and transient failures

---

## What Exists Today (This Fork)

### Internal OCR storage

Immich OCR persists to:
- `asset_ocr` — region boxes + per-line text/scores (overlay data)
- `ocr_search` — denormalized searchable text with GIN trigram index (`f_unaccent("text") gin_trgm_ops`)
- `asset_job_status.ocrAt` — OCR completion marker

### Job flow

```
Upload → AssetGenerateThumbnails → queues [SmartSearch, AssetDetectFaces, Ocr]
                                                                      │
                                               RapidOCR runs on preview image
                                                                      │
                                               writes asset_ocr + ocr_search
                                               sets ocrAt = NOW()
```

### Search path

OCR search uses `ocr_search.text` via trigram operator:
```sql
f_unaccent(ocr_search.text) %>> f_unaccent(tokenized_query)
```

Text is tokenized via `tokenizeForSearch()` which handles CJK bigram splitting.

### What is NOT used by OCR search
- `asset_exif.description` (searched via `ilike`, separate filter)
- Asset metadata key-value pairs (not indexed for search at all)

**Implication**: To be searchable via Immich's OCR filter, external OCR must land in `asset_ocr` + `ocr_search`. Writing only to `description` or metadata is a fallback, not equivalent integration.

### Existing endpoints
- `GET /api/assets/:id/ocr` — read OCR data (exists)
- No public write endpoint for OCR — the bridge API adds this

---

## Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  Immich Stack                                                │
│                                                              │
│  Upload → Thumbnails → [SmartSearch, Faces, Ocr]             │
│                                           │                  │
│                               sets ocrAt ─┘                  │
│                                                              │
│  ┌──────────────────────┐    ┌───────────────────────────┐   │
│  │    PostgreSQL         │    │  immich-server             │   │
│  │                       │    │                           │   │
│  │  asset_job_status     │    │  + Bridge API module      │   │
│  │    ocrAt updated ─────┼──► │    PUT /api/external-ocr  │   │
│  │    (PG NOTIFY)        │    │    /assets/:id/result     │   │
│  │                       │    │    calls ocrRepository    │   │
│  │  ocr_external_state   │    │    .upsert() internally   │   │
│  │    (tracking table)   │    │                           │   │
│  └───────────────────────┘    └──────────▲────────────────┘   │
│                                          │                    │
│  ┌───────────────────────────────────────┼────────────────┐   │
│  │  immich-ocr (new GPU container)       │                │   │
│  │                                       │                │   │
│  │  1. PG LISTEN ocr_complete ───────────┘                │   │
│  │  2. GET /api/assets/:id/original  (fetch image)        │   │
│  │  3. Preprocess → PaddleOCR → TrOCR                     │   │
│  │  4. PUT /api/external-ocr/assets/:id/result            │   │
│  │                                                        │   │
│  │  + Periodic reconcile (safety net)                     │   │
│  └────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────┘
```

### Why This Combination

| Component | Approach | Rationale |
|---|---|---|
| **Trigger** | PG `LISTEN/NOTIFY` on `ocrAt` | Fires *after* internal OCR completes — no race condition, no server code for triggering |
| **Safety net** | Periodic reconcile query | Handles missed notifications, restarts, model revision changes |
| **Write-back** | Bridge API in server | Reuses `ocrRepository.upsert()`, survives schema changes, validates input |
| **Image source** | `GET /api/assets/:id/original` | No volume mount needed, proper auth, works across network boundaries |
| **Provenance** | Metadata key + state table | Model revision + checksum enables smart reprocessing |

---

## Integration Modes

### Mode A (Recommended): Bridge API

Add a small server module in this fork that accepts external OCR payloads and writes through existing repositories.

Benefits:
- Searchable with existing OCR search and overlay UI
- No direct DB credentials needed for writes
- Keeps schema logic centralized in server code
- Lower long-term schema coupling for external worker

Tradeoff:
- Requires small server-side code addition (additive module)

### Mode B (Contingency): Direct DB Write

External OCR service writes directly to PostgreSQL `asset_ocr` and `ocr_search`.

Benefits:
- No Immich server code changes at all
- Fastest to prototype

Tradeoff:
- Tighter coupling to schema details
- External service must validate data itself
- Must replicate `ocrRepository.upsert()` logic in SQL

Direct DB write procedure if using this mode:
```sql
BEGIN;

DELETE FROM asset_ocr WHERE "assetId" = $1;

INSERT INTO asset_ocr ("assetId", x1, y1, x2, y2, x3, y3, x4, y4,
                        "boxScore", "textScore", text, "isVisible")
VALUES ($1, ...);  -- one row per detected region

INSERT INTO ocr_search ("assetId", text)
VALUES ($1, $2)
ON CONFLICT ("assetId") DO UPDATE SET text = EXCLUDED.text;

UPDATE asset_job_status SET "ocrAt" = NOW() WHERE "assetId" = $1;

COMMIT;
```

### Mode C (Fallback): Secondary Metadata/Description

Write OCR to:
- `PUT /api/assets/:id/metadata` with key like `external.ocr.v1`
- `PUT /api/assets/:id` with `description` field for text-search fallback

Limitations:
- Metadata key is not OCR-searchable
- Description is searchable via description filter, not the true OCR search path
- No overlay/bounding box display in UI

**Recommendation**: Start with Mode A. Keep Mode B documented as contingency. Use Mode C only for staged rollout or if you need zero server changes and accept limited searchability.

---

## Component 1: PG Trigger (SQL-only)

Fires when Immich's internal OCR completes (sets `ocrAt`). Applied via init script or `docker exec`.

```sql
-- init.sql

-- 1. Notification trigger
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

-- 2. External OCR state tracking table
CREATE TABLE IF NOT EXISTS ocr_external_state (
  "assetId" uuid PRIMARY KEY REFERENCES assets(id) ON DELETE CASCADE,
  "sourceChecksum" text NOT NULL,
  "modelRevision" text NOT NULL,
  "processedAt" timestamptz,
  "status" text NOT NULL DEFAULT 'pending',
  "retryCount" integer NOT NULL DEFAULT 0,
  "lastError" text
);
```

**Timing guarantee**: The trigger fires only after Immich's OCR has written its results and set `ocrAt`. The external pipeline always runs second, so its `mode=replace` call is the final write.

---

## Component 2: Bridge API (Additive Server Module)

A new controller + service added to the Immich server fork. Kept as a separate module to minimize merge conflicts with upstream.

### Files

```
server/src/controllers/external-ocr.controller.ts   # routes
server/src/services/external-ocr.service.ts          # logic
server/src/dtos/external-ocr.dto.ts                  # validation
```

The service injects the existing `OcrRepository` and `AssetRepository` — no new DB code needed.

### Endpoint: Write OCR Result

```
PUT /api/external-ocr/assets/:id/result
```

**Request payload** (`ExternalOcrResultDto`):

```typescript
{
  provider: string;              // e.g. "immich-ocr-gpu"
  model: string;                 // e.g. "paddleocr+trocr-base-printed"
  modelRevision: string;         // e.g. "v1.0.0"
  sourceChecksum: string;        // SHA256 of original image bytes
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
2. Validate box coordinates are in `[0, 1]` range, reject oversized payloads
3. If `searchText` is omitted, compute it from `lines[].text` using `tokenizeForSearch()`
4. Call `ocrRepository.upsert(assetId, lines, searchText)` — same method Immich's internal OCR uses
5. Set `asset_job_status.ocrAt = now()` (refresh timestamp)
6. Upsert metadata key `external.ocr.v1` with provenance
7. Return `{ written: lines.length, searchTextLength: searchText.length }`

### Endpoint: Report Failure

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

```typescript
// external-ocr.service.ts
@Injectable()
export class ExternalOcrService extends BaseService {
  async writeResult(auth: AuthDto, assetId: string, dto: ExternalOcrResultDto) {
    const asset = await this.assetRepository.getById(assetId);
    if (!asset) throw new NotFoundException();

    // Validate coordinates
    for (const line of dto.lines) {
      for (const coord of [line.x1, line.y1, line.x2, line.y2,
                            line.x3, line.y3, line.x4, line.y4]) {
        if (coord < 0 || coord > 1) throw new BadRequestException('Coordinates must be in [0, 1]');
      }
    }

    const searchText = dto.searchText ?? tokenizeForSearch(
      dto.lines.map(l => l.text).join(' ')
    );

    const ocrDataList = dto.lines.map(line => ({
      assetId,
      x1: line.x1, y1: line.y1, x2: line.x2, y2: line.y2,
      x3: line.x3, y3: line.y3, x4: line.x4, y4: line.y4,
      boxScore: line.boxScore,
      textScore: line.textScore,
      text: line.text,
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

  async reportFailure(auth: AuthDto, assetId: string, dto: ExternalOcrFailureDto) {
    const asset = await this.assetRepository.getById(assetId);
    if (!asset) throw new NotFoundException();

    await this.assetRepository.upsertMetadata(assetId, 'external.ocr.status', {
      provider: dto.provider,
      reason: dto.reason,
      retryCount: dto.retryCount,
      retriable: dto.retriable,
      failedAt: new Date().toISOString(),
    });
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
├── init.sql                        # PG trigger + state table
├── src/
│   ├── __init__.py
│   ├── main.py                     # entry point: listener + reconcile + startup
│   ├── config.py                   # env var config with validation
│   ├── listener.py                 # PG LISTEN/NOTIFY consumer
│   ├── reconcile.py                # periodic catchup for missed assets
│   ├── client.py                   # Immich API client (download + bridge)
│   ├── pipeline.py                 # orchestrates preprocess → detect → recognize
│   ├── preprocess.py               # OpenCV image preprocessing
│   ├── detect.py                   # PaddleOCR text detection (CPU)
│   ├── recognize.py                # TrOCR text recognition (GPU)
│   ├── postprocess.py              # line merge, paragraph detection, unicode normalization
│   ├── tokenize.py                 # tokenizeForSearch() port
│   ├── models.py                   # data classes for OCR results
│   └── writer_db.py                # Mode B contingency: direct DB writer
└── tests/
    ├── test_tokenize.py
    ├── test_preprocess.py
    └── test_pipeline.py
```

### Main Loop (`main.py`)

```python
import logging
import threading

logger = logging.getLogger(__name__)

def main():
    config = Config.from_env()
    config.validate()

    # Load ML models once at startup
    detector = load_detector(config)
    recognizer = load_recognizer(config)
    api = ImmichClient(config.immich_url, config.api_key)

    # 1. Apply init SQL (PG trigger + state table) if not already present
    apply_init_sql(config.db_url)

    # 2. Start periodic reconcile in background thread
    reconciler = Reconciler(config, api, detector, recognizer)
    reconcile_thread = threading.Thread(target=reconciler.run, daemon=True)
    reconcile_thread.start()

    # 3. Catchup: process assets missed while container was down
    missed = get_unprocessed_assets(config.db_url, config.model_revision)
    logger.info(f"Catchup: {len(missed)} assets to process")
    for asset_id in missed:
        safe_process(api, config, detector, recognizer, asset_id)

    # 4. Listen for new OCR completions (blocking main loop)
    logger.info("Listening for OCR completions...")
    listener = PgListener(config.db_url, channel="ocr_complete")

    for asset_id in listener:
        safe_process(api, config, detector, recognizer, asset_id)


def safe_process(api, config, detector, recognizer, asset_id: str):
    try:
        process_asset(api, config, detector, recognizer, asset_id)
    except Exception as e:
        logger.error(f"Failed to process {asset_id}: {e}")
        try:
            api.report_failure(asset_id, reason=str(e))
        except Exception:
            logger.error(f"Failed to report failure for {asset_id}")
```

### Asset Processing (`pipeline.py`)

```python
import hashlib
import io
from PIL import Image

def process_asset(api, config, detector, recognizer, asset_id: str):
    # 1. Check if already processed with current model version
    meta = api.get_asset_metadata(asset_id, key="external.ocr.v1")
    if meta and meta.get("modelRevision") == config.model_revision:
        logger.debug(f"Skipping {asset_id}: already at {config.model_revision}")
        return

    # 2. Download original image via API
    image_bytes = api.download_original(asset_id)
    image = Image.open(io.BytesIO(image_bytes))
    source_checksum = hashlib.sha256(image_bytes).hexdigest()

    # 3. Skip if checksum matches (content unchanged since last run)
    if meta and meta.get("sourceChecksum") == source_checksum:
        logger.debug(f"Skipping {asset_id}: content unchanged")
        return

    # 4. Preprocess
    processed = preprocess(image, max_resolution=config.max_resolution)

    # 5. Detect text regions (CPU)
    boxes = detector.detect(processed)
    if not boxes:
        logger.info(f"No text detected in {asset_id}")
        api.write_ocr_result(asset_id, lines=[], source_checksum=source_checksum)
        return

    # 6. Recognize text (GPU, batched)
    results = recognizer.recognize(processed, boxes, batch_size=config.batch_size)

    # 7. Post-process: merge lines, normalize unicode, reading order
    results = postprocess(results)

    # 8. Pre-tokenize search text
    raw_text = ' '.join(r.text for r in results)
    search_text = tokenize_for_search(raw_text)

    # 9. Write back via bridge API
    lines = [r.to_api_dict() for r in results]
    api.write_ocr_result(asset_id, lines=lines,
                         search_text=search_text,
                         source_checksum=source_checksum)

    logger.info(f"Processed {asset_id}: {len(lines)} regions, {len(search_text)} chars")
```

### Immich API Client (`client.py`)

```python
import requests
from datetime import datetime, timezone

class ImmichClient:
    def __init__(self, base_url: str, api_key: str, model_revision: str = "v1.0.0"):
        self.base_url = base_url.rstrip('/')
        self.headers = {"x-api-key": api_key}
        self.model_revision = model_revision

    def download_original(self, asset_id: str) -> bytes:
        r = requests.get(f"{self.base_url}/api/assets/{asset_id}/original",
                         headers=self.headers, timeout=120)
        r.raise_for_status()
        return r.content

    def get_asset_metadata(self, asset_id: str, key: str) -> dict | None:
        r = requests.get(f"{self.base_url}/api/assets/{asset_id}/metadata/{key}",
                         headers=self.headers, timeout=10)
        if r.status_code == 404:
            return None
        r.raise_for_status()
        return r.json()

    def write_ocr_result(self, asset_id: str, lines: list,
                         search_text: str = None, source_checksum: str = ""):
        payload = {
            "provider": "immich-ocr-gpu",
            "model": "paddleocr+trocr-base-printed",
            "modelRevision": self.model_revision,
            "sourceChecksum": source_checksum,
            "mode": "replace",
            "processedAt": datetime.now(timezone.utc).isoformat(),
            "lines": lines,
        }
        if search_text:
            payload["searchText"] = search_text
        r = requests.put(
            f"{self.base_url}/api/external-ocr/assets/{asset_id}/result",
            headers=self.headers, json=payload, timeout=30)
        r.raise_for_status()
        return r.json()

    def report_failure(self, asset_id: str, reason: str, retry_count: int = 0):
        payload = {
            "provider": "immich-ocr-gpu",
            "reason": reason[:1000],  # truncate long error messages
            "retryCount": retry_count,
            "retriable": True,
        }
        r = requests.put(
            f"{self.base_url}/api/external-ocr/assets/{asset_id}/failure",
            headers=self.headers, json=payload, timeout=10)
        r.raise_for_status()
```

### PG Listener (`listener.py`)

```python
import psycopg2
import psycopg2.extensions
import select
import time
import logging

logger = logging.getLogger(__name__)

class PgListener:
    def __init__(self, db_url: str, channel: str = "ocr_complete"):
        self.db_url = db_url
        self.channel = channel
        self.conn = None
        self._connect()

    def _connect(self):
        self.conn = psycopg2.connect(self.db_url)
        self.conn.set_isolation_level(
            psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT)
        cur = self.conn.cursor()
        cur.execute(f"LISTEN {self.channel};")
        logger.info(f"Listening on PG channel '{self.channel}'")

    def __iter__(self):
        return self

    def __next__(self) -> str:
        while True:
            try:
                if select.select([self.conn], [], [], 60) != ([], [], []):
                    self.conn.poll()
                    while self.conn.notifies:
                        notify = self.conn.notifies.pop(0)
                        return notify.payload
                # Timeout: keepalive
                self._keepalive()
            except (psycopg2.OperationalError, psycopg2.InterfaceError):
                self._reconnect()

    def _keepalive(self):
        try:
            cur = self.conn.cursor()
            cur.execute("SELECT 1")
        except Exception:
            self._reconnect()

    def _reconnect(self):
        logger.warning("PG connection lost, reconnecting...")
        backoff = 1
        while True:
            try:
                self._connect()
                logger.info("PG reconnected")
                return
            except Exception as e:
                logger.error(f"Reconnect failed: {e}, retrying in {backoff}s")
                time.sleep(backoff)
                backoff = min(backoff * 2, 60)
```

### Reconciler (`reconcile.py`)

Periodic safety net that catches missed notifications, restarts, and model revision changes:

```python
import time
import logging

logger = logging.getLogger(__name__)

class Reconciler:
    def __init__(self, config, api, detector, recognizer,
                 interval_seconds: int = 300):
        self.config = config
        self.api = api
        self.detector = detector
        self.recognizer = recognizer
        self.interval = interval_seconds

    def run(self):
        """Run in background thread. Periodically scans for missed assets."""
        while True:
            time.sleep(self.interval)
            try:
                missed = get_unprocessed_assets(
                    self.config.db_url, self.config.model_revision)
                if missed:
                    logger.info(f"Reconcile found {len(missed)} assets to process")
                for asset_id in missed:
                    safe_process(self.api, self.config,
                                 self.detector, self.recognizer, asset_id)
            except Exception as e:
                logger.error(f"Reconcile cycle failed: {e}")


def get_unprocessed_assets(db_url: str, model_revision: str) -> list[str]:
    """Query PG for assets needing external OCR."""
    import psycopg2
    conn = psycopg2.connect(db_url)
    try:
        with conn.cursor() as cur:
            cur.execute("""
                SELECT ajs."assetId"
                FROM asset_job_status ajs
                LEFT JOIN ocr_external_state oes
                  ON oes."assetId" = ajs."assetId"
                WHERE ajs."ocrAt" IS NOT NULL
                  AND (
                    oes."assetId" IS NULL
                    OR oes."status" != 'success'
                    OR oes."modelRevision" != %s
                  )
                ORDER BY ajs."ocrAt" DESC
                LIMIT 500
            """, (model_revision,))
            return [row[0] for row in cur.fetchall()]
    finally:
        conn.close()
```

### Catchup Query (Alternative via API)

If you prefer not to use direct SQL for the catchup, use the Immich metadata API:

```python
def get_assets_needing_external_ocr_via_api(self) -> list[str]:
    """Use search/metadata API to find candidates."""
    # POST /api/search/metadata with filters, then check
    # each asset's external.ocr.v1 metadata key
    pass
```

---

## Triggering Strategy Summary

### Real-time: PG LISTEN/NOTIFY on `ocrAt`

- Fires after Immich's internal OCR completes
- No race condition — external OCR always runs second and overwrites
- Sub-second latency
- No Immich server code required (SQL-only trigger)

### Safety net: Periodic reconcile

- Runs every 5 minutes (configurable)
- Catches: missed notifications, container restarts, model revision changes, retryable failures
- Queries `ocr_external_state` joined with `asset_job_status`

### Optional: AssetCreate event (for external-authoritative mode)

If you disable internal OCR and want external OCR to start on upload without waiting:

- Add `@OnEvent('AssetCreate')` listener in server that enqueues to external service
- Useful when external OCR is the sole provider
- Requires server code change (small, additive)
- Not needed for the default dual-run mode

| Trigger | When it fires | Race-safe | Requires server code |
|---|---|---|---|
| **PG LISTEN/NOTIFY** | After internal OCR completes | Yes | No (SQL only) |
| **Reconcile polling** | Every N minutes | Yes | No |
| **AssetCreate event** | On upload (before internal OCR) | Must dedup | Yes (additive) |

**Default recommendation**: PG trigger + reconcile. Add AssetCreate trigger only if you disable internal OCR.

---

## "Needs Processing" Eligibility Rules

Process asset when all apply:
- `asset_job_status.ocrAt IS NOT NULL` (Immich has finished its pass)
- Asset is visible (`visibility != 'hidden'`) and not deleted (`deletedAt IS NULL`)
- Asset type is eligible (`IMAGE`; optional PDF pipeline later)
- No successful external OCR for current model revision + source checksum

Reprocess when:
- `OCR_MODEL_REVISION` config value changes
- Asset content changed (different source checksum — e.g., after edit)
- Manual requeue requested
- Previous attempt failed and is marked retriable

---

## State Management and Idempotency

### Primary: `ocr_external_state` table (PostgreSQL)

```sql
CREATE TABLE IF NOT EXISTS ocr_external_state (
  "assetId" uuid PRIMARY KEY REFERENCES assets(id) ON DELETE CASCADE,
  "sourceChecksum" text NOT NULL,
  "modelRevision" text NOT NULL,
  "processedAt" timestamptz,
  "status" text NOT NULL DEFAULT 'pending',   -- pending | success | failed
  "retryCount" integer NOT NULL DEFAULT 0,
  "lastError" text
);
```

Benefits:
- Same DB, joins cleanly with `asset_job_status` for catchup queries
- CASCADE delete when asset is removed
- Rich status tracking (success/failed/retry count/error)

### Secondary: Provenance metadata key

`external.ocr.v1` stored via Immich's asset metadata API:
```json
{
  "provider": "immich-ocr-gpu",
  "model": "paddleocr+trocr-base-printed",
  "modelRevision": "v1.0.0",
  "sourceChecksum": "abc123...",
  "processedAt": "2026-02-28T12:00:00Z"
}
```

This is queryable via the Immich API and visible in the UI. The `ocr_external_state` table is the source of truth for the worker; the metadata key is for visibility and API-based querying.

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
- Remove extremely small boxes (area < 0.001 of image)
- Sort top-to-bottom, left-to-right (reading order)
- Normalize all coordinates to `[0, 1]` range (required by `asset_ocr` schema)

### Text Recognition (`recognize.py`)

Microsoft TrOCR on GPU with batch inference:

```python
from transformers import TrOCRProcessor, VisionEncoderDecoderModel
import torch

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

### Post-Processing (`postprocess.py`)

- Sort regions in reading order (top-to-bottom, left-to-right)
- Merge broken lines (heuristic: vertical overlap >50% and close horizontal gap)
- Normalize unicode (NFC)
- Preserve paragraph spacing (vertical gap > 1.5x line height = paragraph break)
- Remove duplicate lines
- Strip excessive whitespace

### Tokenization (`tokenize.py`)

Port of Immich's `tokenizeForSearch()` from `server/src/utils/database.ts:266`. Used for pre-computing `searchText` so the bridge API doesn't need to re-tokenize:

```python
def is_cjk(c: int) -> bool:
    return (0x4E00 <= c <= 0x9FFF or    # CJK Unified Ideographs
            0x3400 <= c <= 0x4DBF or    # CJK Unified Ideographs Extension A
            0x20000 <= c <= 0x2A6DF or  # CJK Unified Ideographs Extension B
            0x2A700 <= c <= 0x2B73F or  # CJK Unified Ideographs Extension C
            0x2B740 <= c <= 0x2B81F or  # CJK Unified Ideographs Extension D
            0x2B820 <= c <= 0x2CEAF or  # CJK Unified Ideographs Extension E
            0xF900 <= c <= 0xFAFF or    # CJK Compatibility Ideographs
            0x2F800 <= c <= 0x2FA1F or  # CJK Compatibility Ideographs Supplement
            0x3000 <= c <= 0x303F or    # CJK Symbols and Punctuation
            0x3040 <= c <= 0x309F or    # Hiragana
            0x30A0 <= c <= 0x30FF or    # Katakana
            0xAC00 <= c <= 0xD7AF)      # Hangul Syllables


def tokenize_for_search(text: str) -> str:
    """Port of Immich's tokenizeForSearch() for search index compatibility.

    Latin text: kept as whitespace-delimited tokens.
    CJK runs: split into overlapping bigrams (single chars kept as-is).
    """
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
      EXTERNAL_OCR_MODE: "bridge"
      OCR_MAX_RESOLUTION: "4032"
      OCR_DETECTION_THRESHOLD: "0.3"
      OCR_RECOGNITION_THRESHOLD: "0.6"
      OCR_MODEL_NAME: "microsoft/trocr-base-printed"
      OCR_MODEL_REVISION: "v1.0.0"
      OCR_BATCH_SIZE: "16"
      OCR_RECONCILE_INTERVAL: "300"
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

**Connections**: The container needs two connections:
1. **PG direct** (`DB_URL`) — for `LISTEN/NOTIFY` and reconcile queries (read-only scope)
2. **Immich API** (`IMMICH_URL` + `IMMICH_API_KEY`) — for image download + bridge API writes

No upload volume mount needed — images are fetched via API.

---

## Configuration

| Env Var | Default | Description |
|---|---|---|
| `DB_URL` | (required) | PostgreSQL connection string (for LISTEN + reconcile queries) |
| `IMMICH_URL` | (required) | Immich server base URL |
| `IMMICH_API_KEY` | (required) | API key with asset read + external-ocr write permissions |
| `EXTERNAL_OCR_MODE` | `bridge` | Write mode: `bridge`, `direct-db`, or `metadata` |
| `OCR_MAX_RESOLUTION` | `4032` | Max image dimension (long edge) |
| `OCR_DETECTION_THRESHOLD` | `0.3` | Min PaddleOCR detection score |
| `OCR_RECOGNITION_THRESHOLD` | `0.6` | Min TrOCR confidence |
| `OCR_MODEL_NAME` | `microsoft/trocr-base-printed` | HuggingFace model for recognition |
| `OCR_MODEL_REVISION` | `v1.0.0` | Version string for provenance + reprocessing logic |
| `OCR_BATCH_SIZE` | `16` | Crops per GPU batch |
| `OCR_RECONCILE_INTERVAL` | `300` | Seconds between reconcile sweeps |
| `LOG_LEVEL` | `INFO` | Logging verbosity |

---

## Internal OCR Coexistence

### Option 1 (Recommended): Dual-run, external wins

- Keep Immich internal OCR **enabled**
- Internal OCR runs first (fast, lower quality on book pages)
- PG trigger fires → external OCR runs → bridge API overwrites with better results
- Net effect: assets always have *some* OCR quickly, then get upgraded
- Timing: PG trigger fires after `ocrAt` is set, so external always writes last

### Option 2: External authoritative

- Set `machineLearning.ocr.enabled = false` in Immich config
- External pipeline becomes sole OCR writer
- Add `AssetCreate` event trigger (requires server code) for real-time processing
- Simpler flow, but assets have no OCR until external service processes them

---

## Security

- **API key scoping**: Dedicated key with minimum permissions (`asset.read`, `asset.download`, `external-ocr.write`)
- **Bridge validation**: Reject payloads with coordinates outside `[0, 1]`, oversized text, invalid asset IDs
- **PG connection**: Used only for `LISTEN` and read-only reconcile queries — no writes via PG
- **Rate limiting**: Bridge endpoint rate-limited per API key
- **Network isolation**: Keep OCR worker in the trusted internal Docker network
- **Webhook signing**: If push triggers are added later, sign payloads with shared secret

---

## Error Handling

- Individual asset failures logged and reported via failure endpoint
- Retry up to 3 times with exponential backoff (1s, 4s, 16s)
- GPU OOM: catch `torch.cuda.OutOfMemoryError`, skip oversized image, clear CUDA cache, continue
- PG connection loss: auto-reconnect with exponential backoff (up to 60s)
- Immich API down: backoff and retry; PG notifications accumulate and are processed on recovery
- Never crash the container — log, report, skip, continue

---

## Observability

Track:
- Queue depth (pending PG notifications)
- Success/failure rate per hour
- Median processing latency per asset
- OCR character count per asset
- Retry counts and dead-letter assets (failed + not retriable)
- Drift metric: assets where `ocrAt` is set but `ocr_external_state` is missing/stale
- Model revision distribution across processed assets

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

### Phase 0: Decision + Baseline
- [ ] Confirm operating mode (bridge recommended)
- [ ] Confirm trigger blend (PG LISTEN + reconcile)
- [ ] Confirm internal OCR coexistence strategy (dual-run recommended)

### Phase 1: MVP (Automatic + Searchable)
- [ ] `init.sql` — PG trigger + `ocr_external_state` table
- [ ] Bridge API module in server (`external-ocr.controller.ts`, `.service.ts`, `.dto.ts`)
- [ ] External service: `config.py`, `listener.py`, `client.py`, `pipeline.py`
- [ ] `tokenize.py` (port of `tokenizeForSearch`)
- [ ] `detect.py` + `recognize.py` (hardcoded PaddleOCR + TrOCR, no preprocessing)
- [ ] Dockerfile + docker-compose.override.yml
- [ ] Test end-to-end: upload → internal OCR → PG trigger → external OCR → search works

### Phase 2: Quality + Preprocessing
- [ ] `preprocess.py` (deskew, threshold, CLAHE)
- [ ] Batch GPU inference in `recognize.py`
- [ ] `postprocess.py` (line merge, paragraph detection, unicode normalization)
- [ ] Failure endpoint + retry logic
- [ ] Coordinate normalization validation

### Phase 3: Production Hardening
- [ ] `reconcile.py` — periodic catchup sweep
- [ ] PG connection auto-reconnect with backoff
- [ ] GPU OOM handling + CUDA cache management
- [ ] Schema/version check on startup (validate `asset_ocr`, `ocr_search` tables exist)
- [ ] Structured logging + observability metrics
- [ ] Health check endpoint

### Phase 4: Quality Tuning + Operations
- [ ] Tune preprocessing for various book scan qualities
- [ ] A/B compare internal vs external OCR on representative test set
- [ ] Add manual reprocess command (by asset ID or date range)
- [ ] Optional: layout analysis for multi-column pages
- [ ] Optional: per-library/tag model selection policies
- [ ] Optional: PDF image-based OCR path

---

## Acceptance Criteria

1. Service starts, loads models, and begins listening for OCR completions
2. New eligible assets are OCR-processed automatically without manual action
3. OCR text is searchable in Immich via the native OCR search filter
4. External OCR overwrites internal OCR deterministically (no race condition)
5. Reprocessing triggers when model revision changes
6. Service recovers after restart without duplicating work (catchup + reconcile)
7. Failures are visible, retryable, and do not stall the queue
8. No modification to Immich's core OCR code — only additive bridge module + SQL trigger

---

## Non-Goals

- Replacing Immich ML container internals
- Cloud OCR dependency
- Sub-second real-time OCR
- Handwriting-first optimization (unless explicitly added later)

---

## Upgrade and Merge Guardrails

- Bridge API is a new additive module — no patches to existing controllers/services
- Reuses existing `OcrRepository` and `AssetRepository` — benefits from upstream improvements
- PG trigger is standalone SQL — independent of server code
- `ocr_external_state` table is in its own namespace, no conflict with Immich schema
- If upstream Immich adds webhook/notification support, the PG trigger can be replaced transparently
- Keep the external OCR service in a separate directory (`ocr-service/`) outside the main Immich tree
- If using Mode B direct DB: run startup schema checks for `asset_ocr`, `ocr_search`, `asset_job_status` column presence before writing

---

END OF PLAN
