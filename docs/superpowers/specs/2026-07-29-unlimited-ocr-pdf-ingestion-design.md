# Unlimited-OCR for PDF ingestion

## Goal

Allow operators to opt in to a [Baidu Unlimited-OCR](https://github.com/baidu/Unlimited-OCR) HTTP deployment for OCR of PDF pages that do not contain enough embedded text. Existing image OCR and the default Immich PDF OCR path remain unchanged.

## Provider contract

Immich sends a `multipart/form-data` `POST` request to the operator-configured endpoint. The rendered PNG is supplied in the `file` part. If an API key is configured, it is sent as a bearer token.

The adapter accepts the following JSON response shapes so it can sit in front of different Unlimited-OCR serving configurations:

- `{ "text": "..." }`
- `{ "markdown": "..." }`
- `{ "result": { "text": "..." } }`
- `{ "data": { "text": "..." } }`
- OpenAI-compatible `{ "choices": [{ "message": { "content": "..." } }] }`

The endpoint must return UTF-8 JSON. A non-2xx response, invalid JSON, a response larger than 8 MiB, or a response without textual output is a per-page OCR failure.

## Configuration

| Variable | Default | Purpose |
| --- | --- | --- |
| `PDF_OCR_PROVIDER` | `immich` | `immich` or `unlimited-ocr` |
| `UNLIMITED_OCR_URL` | unset | Full HTTP inference endpoint; required when the provider is selected |
| `UNLIMITED_OCR_API_KEY` | unset | Optional bearer token |
| `UNLIMITED_OCR_TIMEOUT_MS` | `120000` | Per-page request timeout |

Selecting Unlimited-OCR without a URL is rejected during environment parsing. Credentials are never logged.

## Processing flow

1. Extract PDF metadata and embedded page text as before.
2. Select pages whose embedded text is below `PDF_MIN_EMBEDDED_TEXT_LENGTH`.
3. Render each selected page to a temporary PNG with `pdftoppm`.
4. Dispatch the PNG to the selected provider.
5. Store non-empty provider output with `textSource = 'ocr'`.
6. Remove the PNG and its temporary directory in a `finally` path.

Provider errors remain isolated to the affected page. The document can still finish ingestion with that page marked `none`, matching the existing best-effort behavior.

## Non-goals

- Replacing OCR for image assets.
- Vendoring or modifying Unlimited-OCR.
- Automatically falling back between providers.
- Changing the PDF database schema or public API.

## Acceptance tests

- Default configuration continues to invoke Immich machine-learning OCR.
- `unlimited-ocr` configuration invokes only the Unlimited-OCR adapter.
- Empty and failed provider responses leave the page unmodified.
- Temporary files are cleaned up for successful and failed requests.
- Invalid provider configuration fails at startup.
