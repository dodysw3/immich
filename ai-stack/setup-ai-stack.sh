#!/usr/bin/env bash
#
# setup-ai-stack.sh — one-command setup of the Immich PDF+AI fork's local AI stack.
#
# What it does:
#   1. Preflight: docker, compose, GPU detection, disk space.
#   2. Picks a VRAM profile (or takes --profile) for the vision LLM.
#   3. Downloads the GGUF models (vision LLM + mmproj projector + BGE-M3 embeddings).
#   4. Seeds .env (from docker/example.env) and writes ai-stack/.env.ai.
#   5. Builds the fork's server/ML images and starts everything via compose.
#   6. Health-checks the two AI servers and Immich, then runs an end-to-end
#      embedding smoke test.
#
# Usage:
#   ./setup-ai-stack.sh [--profile auto|24|16|12|cpu] [--variant <gguf>]
#                       [--without-vision] [--skip-build] [--skip-models]
#                       [--models-dir <dir>] [--uninstall] [--dry-run]
#
# Everything is re-runnable: models are resumed (HTTP Range), .env.ai is
# regenerated, compose is idempotent.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

# ------------------------------------------------------------------ defaults
PROFILE="auto"
VARIANT=""                 # vision GGUF variant; resolved from profile
WITHOUT_VISION=0
SKIP_BUILD=0
SKIP_MODELS=0
UNINSTALL=0
DRY_RUN=0
MODELS_DIR="${AI_MODELS_DIR:-${REPO_DIR}/llm-models}"
VISION_REPO="https://huggingface.co/unsloth/Muse-Glimmer-30B-GGUF/resolve/main"
EMBED_URL="https://huggingface.co/gpustack/bge-m3-GGUF/resolve/main/bge-m3-Q8_0.gguf"
EMBED_FILE="bge-m3-Q8_0.gguf"
EMBED_BYTES=635            # MB, approximate (verified against gpustack/bge-m3-GGUF)

say()  { printf '\033[1;35m[ai-stack]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[ai-stack]\033[0m %s\n' "$*"; }
die()  { printf '\033[1;31m[ai-stack]\033[0m %s\n' "$*" >&2; exit 1; }

usage() { grep '^#   ' "${BASH_SOURCE[0]}" | sed 's/^#   //'; exit 0; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --profile)       PROFILE="$2"; shift 2 ;;
    --variant)       VARIANT="$2"; shift 2 ;;
    --without-vision) WITHOUT_VISION=1; shift ;;
    --skip-build)    SKIP_BUILD=1; shift ;;
    --skip-models)   SKIP_MODELS=1; shift ;;
    --models-dir)    MODELS_DIR="$2"; shift 2 ;;
    --uninstall)     UNINSTALL=1; shift ;;
    --dry-run)       DRY_RUN=1; shift ;;
    -h|--help)       usage ;;
    *) die "unknown option: $1 (see --help)" ;;
  esac
done

compose() {
  local base=(docker compose -f docker/docker-compose.yml -f ai-stack/docker-compose.ai.yml --env-file .env --env-file ai-stack/.env.ai --project-directory docker)
  if [[ $DRY_RUN == 1 ]]; then echo "${base[*]} $*"; else (cd "$REPO_DIR" && "${base[@]}" "$@"); fi
}

# ---------------------------------------------------------------- uninstall
if [[ $UNINSTALL == 1 ]]; then
  say "removing AI stack containers (models and Immich data are kept)"
  compose rm -sf immich-llm-vision immich-llm-embed
  say "note: the immich-server env still points at the AI servers; re-run without"
  say "      ai-stack/docker-compose.ai.yml if you want a plain-upstream runtime."
  exit 0
fi

# ---------------------------------------------------------------- preflight
command -v docker >/dev/null || die "docker is required (https://docs.docker.com/engine/install/)"
docker compose version >/dev/null 2>&1 || die "docker compose plugin is required"
[[ -f "${REPO_DIR}/docker/docker-compose.yml" ]] || die "run this script from the fork repo (expected ${REPO_DIR}/docker/docker-compose.yml)"

GPU_INFO=""
TOTAL_VRAM_MB=0
if command -v nvidia-smi >/dev/null 2>&1 && nvidia-smi -L >/dev/null 2>&1; then
  GPU_INFO=$(nvidia-smi --query-gpu=name,memory.total --format=csv,noheader,nounits)
  TOTAL_VRAM_MB=$(echo "$GPU_INFO" | awk -F', ' '{ s += $2 } END { print s }')
  say "GPU(s): $(echo "$GPU_INFO" | tr '\n' ';' | sed 's/;$/\n/')"
  say "total VRAM: ${TOTAL_VRAM_MB} MiB"
else
  say "no NVIDIA GPU detected — vision model will run on CPU (very slow) unless --without-vision"
fi

GPU_COUNT=$(echo "$GPU_INFO" | grep -c . || true)

# ---------------------------------------------------------------- profile
# Profile = {variant, mmproj variant+offload, parallel slots, total ctx, gpu layers}
# VRAM math (q8_0 KV ≈ 27.6 KiB/token): weights + mmproj(if offloaded) + KV + ~1 GB CUDA overhead.
resolve_profile() {
  case "$PROFILE" in
    24) VARIANT="${VARIANT:-UD-Q3_K_XL}";  MMPROJ="BF16"; OFFLOAD=1; PARALLEL=4; TOTAL_CTX=32768; GPU_LAYERS=99; IMAGE_TAG=cuda ;;
    16) VARIANT="${VARIANT:-UD-Q3_K_XL}";  MMPROJ="Q8_0"; OFFLOAD=1; PARALLEL=2; TOTAL_CTX=16384; GPU_LAYERS=99; IMAGE_TAG=cuda ;;
    12) die "profile 12 needs manual tuning — use --without-vision (PDF, faces, OCR and search of already-interpreted photos still work) or a smaller setup; see SETUP-GUIDE.md" ;;
    cpu) VARIANT="${VARIANT:-UD-Q3_K_XL}"; MMPROJ="Q8_0"; OFFLOAD=0; PARALLEL=1; TOTAL_CTX=8192;  GPU_LAYERS=0;  IMAGE_TAG="" ;;
    auto)
      if [[ $TOTAL_VRAM_MB -ge 22000 ]]; then PROFILE=24
      elif [[ $TOTAL_VRAM_MB -ge 14000 ]]; then PROFILE=16
      elif [[ $TOTAL_VRAM_MB -ge 1000 ]];  then PROFILE=cpu; WITHOUT_VISION=1
        warn "auto: <14 GiB VRAM — enabling interpretation on CPU is impractical; defaulting to --without-vision."
        warn "      (force it with --profile cpu if you really want ~2 tok/s.)"
      else PROFILE=cpu; WITHOUT_VISION=1; fi
      resolve_profile ;;
    *) die "unknown profile: $PROFILE" ;;
  esac
}
resolve_profile

if [[ $WITHOUT_VISION == 1 ]]; then
  VARIANT="none"; MMPROJ="none"; OFFLOAD=0; PARALLEL=1; TOTAL_CTX=8192; GPU_LAYERS=0; IMAGE_TAG=""
fi

say "profile: ${PROFILE}  variant=${VARIANT} mmproj=${MMPROJ}(offload=${OFFLOAD}) slots=${PARALLEL} ctx=${TOTAL_CTX}"

# tensor-split: multi-GPU hosts split weights evenly so the 30B model fits
# cards that couldn't hold it alone. Override via AI_TENSOR_SPLIT in .env.ai.
TENSOR_SPLIT=""
if [[ $WITHOUT_VISION -eq 0 && $GPU_COUNT -ge 2 ]]; then
  TENSOR_SPLIT=$(awk -v n="$GPU_COUNT" 'BEGIN{s=""; for(i=1;i<=n;i++){printf "%s%.1f", s, 100/n; s=","}}')
  say "multi-GPU: even tensor split (${TENSOR_SPLIT})"
fi

# ---------------------------------------------------------------- models
download() { # url dest approx_mb
  local url="$1" dest="$2" approx="$3"
  if [[ -f "$dest" && -s "$dest" ]]; then
    say "have $(basename "$dest") ($(du -m "$dest" | cut -f1) MB)"
    return 0
  fi
  say "downloading $(basename "$dest") (~${approx} MB) → $(dirname "$dest")"
  mkdir -p "$(dirname "$dest")"
  if [[ $DRY_RUN == 1 ]]; then echo "curl -L -C - --retry 5 --retry-delay 3 -o '$dest' '$url'"; return 0; fi
  curl -L -C - --retry 5 --retry-delay 3 --progress-bar -o "$dest" "$url"
}

if [[ $SKIP_MODELS == 0 ]]; then
  DISK_FREE_GB=$(df -PBG "$REPO_DIR" | tail -1 | awk '{gsub(/G/,"",$4); print $4}')
  NEED_GB=1
  if [[ $WITHOUT_VISION -eq 0 ]]; then NEED_GB=19; fi
  if [[ $DISK_FREE_GB -lt $NEED_GB ]]; then
    die "only ${DISK_FREE_GB} GB free at ${REPO_DIR}; need ~${NEED_GB} GB for models (use --models-dir to relocate)"
  fi
  mkdir -p "${MODELS_DIR}/vision" "${MODELS_DIR}/embed"
  download "${EMBED_URL}" "${MODELS_DIR}/embed/${EMBED_FILE}" 635
  if [[ $WITHOUT_VISION -eq 0 ]]; then
    download "${VISION_REPO}/Muse-Glimmer-30B-${VARIANT}.gguf"        "${MODELS_DIR}/vision/Muse-Glimmer-30B-${VARIANT}.gguf" 14000
    download "${VISION_REPO}/mmproj-Muse-Glimmer-30B-${MMPROJ}.gguf"  "${MODELS_DIR}/vision/mmproj-Muse-Glimmer-30B-${MMPROJ}.gguf" 3950
  fi
fi

# ---------------------------------------------------------------- env files
if [[ ! -f "${REPO_DIR}/.env" ]]; then
  say "seeding .env from docker/example.env"
  if [[ $DRY_RUN == 1 ]]; then echo "cp docker/example.env .env"; else
    cp "${REPO_DIR}/docker/example.env" "${REPO_DIR}/.env"
    sed -i "s/^DB_PASSWORD=.*/DB_PASSWORD=$(openssl rand -hex 24)/" "${REPO_DIR}/.env"
  fi
fi

mkdir -p "${SCRIPT_DIR}"
ENV_AI="${SCRIPT_DIR}/.env.ai"
say "writing ${ENV_AI}"
if [[ $DRY_RUN == 1 ]]; then
  cat <<EOF
COMPOSE_PROFILES=$([[ $WITHOUT_VISION -eq 1 ]] && echo "" || echo vision)
AI_MODELS_DIR=${MODELS_DIR}
AI_VISION_IMAGE=${IMAGE_TAG:+server-cuda}
AI_VISION_VARIANT=${VARIANT}
AI_MMPROJ_VARIANT=${MMPROJ}
AI_MMPROJ_OFFLOAD=${OFFLOAD}
AI_VISION_PARALLEL=${PARALLEL}
AI_VISION_TOTAL_CTX=${TOTAL_CTX}
AI_GPU_LAYERS=${GPU_LAYERS}
AI_TENSOR_SPLIT=${TENSOR_SPLIT}
AI_EMBED_THREADS=8
AI_ENABLE_INTERPRETATION=$( [[ $WITHOUT_VISION -eq 1 ]] && echo false || echo true )
EOF
else
  cat > "${ENV_AI}" <<EOF
# Generated by setup-ai-stack.sh — safe to edit, re-run overwrites it.
# COMPOSE_PROFILES gates the vision LLM service (empty = vision disabled).
COMPOSE_PROFILES=$([[ $WITHOUT_VISION -eq 1 ]] && echo "" || echo vision)
AI_MODELS_DIR=${MODELS_DIR}
AI_VISION_IMAGE=${IMAGE_TAG:+server-cuda}
AI_VISION_VARIANT=${VARIANT}
AI_MMPROJ_VARIANT=${MMPROJ}
AI_MMPROJ_OFFLOAD=${OFFLOAD}
AI_VISION_PARALLEL=${PARALLEL}
AI_VISION_TOTAL_CTX=${TOTAL_CTX}
AI_GPU_LAYERS=${GPU_LAYERS}
AI_TENSOR_SPLIT=${TENSOR_SPLIT}
AI_EMBED_THREADS=8
AI_ENABLE_INTERPRETATION=$( [[ $WITHOUT_VISION -eq 1 ]] && echo false || echo true )
EOF
fi

# ---------------------------------------------------------------- up
if [[ $DRY_RUN == 1 ]]; then
  say "dry-run: nothing was written or started. Would now run:"
  compose up -d --build
  exit 0
fi
BUILD_ARGS=()
if [[ $SKIP_BUILD == 1 ]]; then BUILD_ARGS+=(--no-build); fi
say "building fork images + starting stack (first build takes a while)"
compose up -d --build "${BUILD_ARGS[@]}"

# ---------------------------------------------------------------- verify
VISION_HOST="127.0.0.1:${AI_VISION_PORT:-51899}"
EMBED_HOST="127.0.0.1:${AI_EMBED_PORT:-51898}"
probe() { curl -sf -m 5 "$1" >/dev/null; }

wait_for() { # url label tries
  local url="$1" label="$2" tries="${3:-60}" i=0
  say "waiting for ${label} (${url})"
  until probe "$url"; do
    i=$((i+1)); [[ $i -ge $tries ]] && die "${label} did not become healthy: ${url}"
    sleep 2
  done
  say "${label} is up"
}

wait_for "http://${EMBED_HOST}/health" "embed server (BGE-M3)"
if [[ $WITHOUT_VISION -eq 0 ]]; then
  wait_for "http://${VISION_HOST}/health" "vision server (llama.cpp)"
fi
wait_for "http://127.0.0.1:2283/api/server/ping" "immich server"

say "embedding smoke test:"
if [[ $DRY_RUN == 1 ]]; then echo "curl POST http://${EMBED_HOST}/v1/embeddings"; else
  RESP=$(curl -sf -m 30 -X POST "http://${EMBED_HOST}/v1/embeddings" \
    -H 'Content-Type: application/json' \
    -d "{\"model\":\"bge-m3-Q8_0\",\"input\":[\"warung dengan papan menu hijau\"]}")
  DIMS=$(echo "$RESP" | python3 -c 'import json,sys; d=json.load(sys.stdin); print(len(d["data"][0]["embedding"]))' 2>/dev/null || echo "?")
  [[ "$DIMS" == "1024" ]] && say "  OK — 1024-dim embedding returned" || die "  unexpected embedding response (dims=${DIMS}): ${RESP:0:200}"
fi

say ""
say "AI stack is ready. Next steps:"
say "  1. Open http://localhost:2283 and create your admin account."
say "  2. Upload photos — interpretation + AI search run automatically."
say "     Search them via the new 'AI' mode in the search bar (English or Bahasa Indonesia)."
say "  3. Drop PDFs in — they appear under Documents."
if [[ $WITHOUT_VISION -eq 1 ]]; then
  say "  NOTE: vision interpretation is disabled (<14 GiB VRAM). PDFs, faces, OCR and"
  say "  the AI-search index for any photos you interpret later still work; add a GPU"
  say "  (or a bigger one) and re-run this script to enable interpretation."
fi
say "  Models live in: ${MODELS_DIR} (delete to reclaim ~19 GB after --uninstall)."
