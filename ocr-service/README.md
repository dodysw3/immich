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
