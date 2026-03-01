# External OCR Service

This service consumes Immich assets and writes OCR results back through `PUT /api/external-ocr/assets/:id/result`.

## Run

```bash
python -m src.main
```

Required environment variables:

- `DB_URL`
- `IMMICH_URL`
- `IMMICH_API_KEY`

## Immich API Key Permissions

`IMMICH_API_KEY` should include the minimum scopes required by this service:

- `asset.read` (fetch asset metadata)
- `asset.download` (download original files)
- `asset.update` (write OCR result/failure via `/api/external-ocr/*`)

Note: there is no separate `external-ocr.write` scope in the current permission model.

## Docker Compose Variable Mapping

If you use the repository `docker-compose.override.yml`, it maps:

- `IMMICH_API_KEY: "${IMMICH_OCR_API_KEY}"`

So `IMMICH_OCR_API_KEY` must be defined in the Compose interpolation source (for example `docker/.env` when using `--env-file`, or exported in your shell).

If it is missing, Docker Compose shows:

```text
WARN[0000] The "IMMICH_OCR_API_KEY" variable is not set. Defaulting to a blank string.
```

Quick fix from repo root:

```bash
cp docker/example.env docker/.env
echo "IMMICH_OCR_API_KEY=<your_immich_api_key>" >> docker/.env
docker compose --env-file docker/.env \
  -f docker/docker-compose.yml \
  -f docker-compose.override.yml up -d
```

## Health and Metrics

- Health: `GET /healthz`
- Metrics JSON: `GET /metrics`

Environment:

- `OCR_HEALTH_HOST` (default `0.0.0.0`)
- `OCR_HEALTH_PORT` (default `8088`)
- `OCR_METRICS_LOG_INTERVAL` (default `60`)

## Model Policy

Use `OCR_MODEL_POLICY_JSON` to route assets by tag/library.

Example:

```json
{
  "default": "microsoft/trocr-base-printed",
  "tag": {
    "manga": "microsoft/trocr-base-printed"
  },
  "library": {
    "6a7d5a2a-9f8f-4e95-9f6f-600000000001": "microsoft/trocr-base-printed"
  }
}
```

Rules:

- Tag policy is evaluated before library policy.
- Tag keys are case-insensitive.
- If no policy matches, `OCR_MODEL_NAME` is used.

Detection model is configured independently with `OCR_DETECTOR_MODEL_NAME` (default `PP-OCRv5_mobile`).

Note: Model policy only applies to the `paddle+trocr` engine. The `surya` engine uses its own built-in models.

## OCR Engine

Environment:

- `OCR_ENGINE` (default `surya`) — `"surya"` or `"paddle+trocr"`
- `SURYA_RECOGNITION_BATCH_SIZE` (default `4`)
- `SURYA_DETECTION_BATCH_SIZE` (default `2`)

The default engine is **Surya**, which runs end-to-end detection + recognition using its own models. It applies a light preprocessing step (resize + RGB convert) instead of the destructive binary thresholding used by the paddle+trocr path. Surya provides real per-line confidence scores filtered by `OCR_RECOGNITION_THRESHOLD`.

Set `OCR_ENGINE=paddle+trocr` to use the legacy PaddleOCR detection + TrOCR recognition pipeline.

Changing the engine is a model-revision-level change — bump `OCR_MODEL_REVISION` to trigger reprocessing of all assets.

## Layout Analysis

Environment:

- `OCR_LAYOUT_ANALYSIS_ENABLED` (default `true`)
- `OCR_LAYOUT_MAX_COLUMNS` (default `3`)
- `OCR_LAYOUT_COLUMN_GAP` (default `0.12`)

This improves ordering for multi-column scans.

## PDF OCR (Optional)

Environment:

- `OCR_PDF_ENABLED` (default `false`)
- `OCR_PDF_MAX_PAGES` (default `25`)
- `OCR_PDF_DPI` (default `200`)

When enabled, `OTHER` assets ending in `.pdf` are rasterized and OCR'd page-by-page.

## Manual Reprocess

By asset IDs:

```bash
python -m src.reprocess --asset-id <asset-id-1> --asset-id <asset-id-2>
```

By OCR date range (UTC):

```bash
python -m src.reprocess --date-from 2026-02-01 --date-to 2026-02-03 --limit 500
```

Dry-run selection only:

```bash
python -m src.reprocess --date-from 2026-02-01 --dry-run
```

## A/B Compare

Compare existing OCR text with external OCR simulation:

```bash
python -m src.ab_compare --asset-file /path/to/asset_ids.txt --output /tmp/ocr-ab.json
```

Or with explicit IDs:

```bash
python -m src.ab_compare --asset-id <asset-id-1> --asset-id <asset-id-2>
```
