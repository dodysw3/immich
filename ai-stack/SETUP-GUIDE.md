# Setup Guide — Immich PDF+AI fork with a fully local AI stack

This guide gets you from zero to the complete fork — PDF document archive, on-device photo
interpretation, cross-lingual AI search, tiled face detection — with **no cloud AI and no
API keys**. Everything AI runs on your own hardware via llama.cpp containers.

Total time: **~30–60 minutes**, dominated by one-time downloads (~17 GB of models) and the
Docker image build.

---

## 0. What you need

| Requirement | Minimum | Recommended |
|---|---|---|
| GPU (NVIDIA, for photo interpretation) | 16 GB VRAM (1×16) | 24 GB (1×24 or 2×12) |
| No GPU? | PDFs, faces, OCR, AI search still work — interpretation can be added later | — |
| RAM | 16 GB | 32 GB |
| Disk | ~25 GB (repo build + models) + your photo storage | — |
| Docker | Engine + compose plugin, NVIDIA Container Toolkit if using a GPU | — |

**Why these numbers.** The default vision model (Muse-Glimmer-30B, UD-Q3_K_XL quant) is a
13.4 GB file; with its vision projector and KV cache it lands around 18 GB VRAM at 4
parallel slots. The embedding model (BGE-M3, 635 MB) deliberately runs on CPU — it answers
queries in ~34 ms there.

Smaller quants exist (down to `UD-IQ2_M`), and any OpenAI-compatible vision endpoint works —
see *Advanced* below.

---

## 1. Get the fork

```bash
git clone https://github.com/dodysw3/immich immich-fork
cd immich-fork
```

---

## 2. One command

```bash
./ai-stack/setup-ai-stack.sh
```

The script:

1. Detects your GPU(s) and picks a VRAM profile (override: `--profile 24|16|12|cpu`).
2. Downloads the models (resumable; ~17 GB) into `./llm-models/`:
   - `Muse-Glimmer-30B-UD-Q3_K_XL.gguf` + BF16 mmproj projector (vision LLM)
   - `bge-m3-Q8_0.gguf` (embeddings)
3. Seeds `.env` from `docker/example.env` with a generated database password.
4. Writes `ai-stack/.env.ai` (VRAM profile, slot count, context size, tensor split).
5. Builds the fork's `immich-fork-server` / `immich-fork-machine-learning` images from
   source and starts the whole stack:
   `immich-server`, `immich-machine-learning`, `redis`, `postgres`,
   `immich-llm-vision` (llama.cpp), `immich-llm-embed` (llama.cpp).
6. Health-checks all of it and runs a 1024-dim embedding smoke test.

Useful flags:

```bash
--dry-run          # show everything it would do; touch nothing
--without-vision   # skip the vision LLM (PDFs/faces/OCR/search still work)
--variant UD-Q4_K_XL   # bigger/better vision quant (needs ~2 GB more VRAM)
--models-dir /mnt/big/llm-models
--skip-models      # models already downloaded elsewhere
--uninstall        # remove the two llama.cpp containers (data + models kept)
```

---

## 3. Use it

1. Open **http://localhost:2283**, create your admin account.
2. Upload photos. Each one is automatically: thumbnailed → face-detected (tiled pass on
   large/group photos) → OCR'd → **interpreted by your local vision LLM** → embedded into
   the AI search index. Watch progress in Administration → Job Queues.
3. Search with meaning: search bar → **AI** mode → type a situation in English *or* Bahasa
   Indonesia ("anak bermain di pantai saat matahari terbenam").
4. In the photo viewer, toggle **Show face recognition** and **Text recognition** to see
   the AI's work drawn on the photo, and **AI interpretation** for the full written record.
5. Drop PDFs in — they appear under **Documents** with full-text search and an in-app viewer.

---

## 4. How the pieces talk

```
browser ── immich-server (fork) ──┬─ immich-machine-learning   (faces·OCR·CLIP, CPU or GPU)
                                  ├─ immich-llm-vision         (llama.cpp · Muse-Glimmer-30B, GPU)
                                  ├─ immich-llm-embed          (llama.cpp · BGE-M3, CPU)
                                  ├─ postgres + pgvector       (vectors, trigram text, PDF pages)
                                  └─ redis/valkey              (queues)
```

All communication is HTTP on the compose network — no keys, no egress. The only optional
outbound call is a Discord webhook *you* configure (`IMMICH_AI_IMAGE_INTERPRETATION_DISCORD_WEBHOOK_URL`).

---

## 5. Troubleshooting

| Symptom | Cause / fix |
|---|---|
| `immich-llm-vision` restarts or OOMs | VRAM too small for the profile. Lower `AI_VISION_PARALLEL` or `AI_VISION_TOTAL_CTX` in `ai-stack/.env.ai`, or drop to a smaller `AI_VISION_VARIANT`. |
| ~2 tok/s interpretation | CUDA backend not active. Ensure NVIDIA Container Toolkit is installed and `AI_VISION_IMAGE=server-cuda`. Check the container logs for "CUDA0". |
| "Interpret image" works but AI search finds nothing | Embed server down. `curl localhost:51898/health`. The hourly reconcile sweep back-fills the index automatically once it's back. |
| Interpretations stuck in queue | Expected on big backfills — the queue is honest about ETA (Discord alerts show it). Priority-order via the admin job panel. |
| Port conflicts on 51899/51898 | Change `AI_VISION_PORT` / `AI_EMBED_PORT` in `ai-stack/.env.ai` (these are host-side debug ports only; containers talk over the compose network). |
| Want the scanned-PDF OCR engine too | The default `PDF_OCR_PROVIDER=immich` uses the ML container. The GPU OCR microservice + Unlimited-OCR provider is opt-in: see the repo-root `docker-compose.override.yml` (needs GPU access on the OCR container). |

After changing `ai-stack/.env.ai`: `docker compose ... up -d` again (same command as the
script uses; it is printed by `--dry-run`).

---

## 6. Advanced: host-mode llama.cpp (performance tuning)

The production deployment behind this fork's benchmarks runs llama.cpp **directly on the
host** instead of containers, which allows speculative decoding and precise tensor splits:

- 2×12 GiB GPUs (`RTX 3080 Ti + RTX 3060`), weights split `3.5,6.5`, mmproj + draft model
  pinned to the second card, 8 parallel slots × 8192 ctx, q8_0 KV cache.
- ~10 t/s aggregate on interpretation backfills; the Immich server reaches it at
  `host.docker.internal:51899` (`IMMICH_AI_IMAGE_INTERPRETATION_URL`).

If you go this route, keep the container compose but point the server env at your host:

```env
IMMICH_AI_IMAGE_INTERPRETATION_URL=http://host.docker.internal:51899/v1
IMMICH_AI_INTERPRET_SEARCH_URL=http://host.docker.internal:51898
```

The fork only speaks the OpenAI-compatible protocol (`/v1/chat/completions` with
`response_format` JSON schema, `/v1/embeddings`) — any llama.cpp build from mid-2026
onward works, including CPU-only and Apple Silicon (Metal) builds.

**Swapping the vision model.** Any multimodal GGUF works (Qwen2.5/3-VL, Gemma 3, Pixtral…):
drop the files in `llm-models/vision/`, set `AI_VISION_VARIANT` + the `-m`/`--mmproj` paths,
and update `IMMICH_AI_IMAGE_INTERPRETATION_MODEL`/`_QUANT`. Interpretations are versioned by
(model, quant, prompt) — switching models never corrupts old records; re-interpretation is
always available per photo.

---

## 7. What's included vs optional

| Component | Included by default | Optional |
|---|---|---|
| PDF archive + viewer + search | ✅ | — |
| Tiled face detection, `[n]` face labels, face/OCR overlays | ✅ | — |
| Vision LLM interpretation + AI search | ✅ (GPU ≥ 16 GB) | `--without-vision` |
| External OCR microservice (Surya/TrOCR, GPU) | — | repo-root `docker-compose.override.yml` |
| Discord completion alerts + Queue ETA | — | set `IMMICH_AI_IMAGE_INTERPRETATION_DISCORD_WEBHOOK_URL` in `.env` |
