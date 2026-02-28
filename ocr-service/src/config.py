from __future__ import annotations

import json
import os
from dataclasses import dataclass, field


@dataclass(slots=True)
class Config:
    db_url: str
    immich_url: str
    immich_api_key: str
    external_ocr_mode: str = "bridge"
    ocr_max_resolution: int = 4032
    ocr_detection_threshold: float = 0.3
    ocr_recognition_threshold: float = 0.6
    ocr_model_name: str = "microsoft/trocr-base-printed"
    ocr_model_revision: str = "v1.0.0"
    ocr_model_policy: dict = field(default_factory=dict)
    ocr_batch_size: int = 16
    ocr_reconcile_interval: int = 300
    ocr_channel: str = "ocr_complete"
    ocr_preprocess_block_size: int = 15
    ocr_preprocess_threshold_c: int = 9
    ocr_preprocess_clahe_clip: float = 2.0
    ocr_preprocess_unsharp_amount: float = 1.4
    ocr_layout_analysis_enabled: bool = True
    ocr_layout_max_columns: int = 3
    ocr_layout_column_gap: float = 0.12
    ocr_pdf_enabled: bool = False
    ocr_pdf_max_pages: int = 25
    ocr_pdf_dpi: int = 200
    log_level: str = "INFO"
    init_sql_path: str = "/app/init.sql"
    max_retries: int = 3
    metrics_log_interval: int = 60
    health_host: str = "0.0.0.0"
    health_port: int = 8088

    @classmethod
    def from_env(cls) -> "Config":
        model_policy = _parse_model_policy(os.getenv("OCR_MODEL_POLICY_JSON", "{}"))

        return cls(
            db_url=os.getenv("DB_URL", ""),
            immich_url=os.getenv("IMMICH_URL", ""),
            immich_api_key=os.getenv("IMMICH_API_KEY", ""),
            external_ocr_mode=os.getenv("EXTERNAL_OCR_MODE", "bridge"),
            ocr_max_resolution=int(os.getenv("OCR_MAX_RESOLUTION", "4032")),
            ocr_detection_threshold=float(os.getenv("OCR_DETECTION_THRESHOLD", "0.3")),
            ocr_recognition_threshold=float(os.getenv("OCR_RECOGNITION_THRESHOLD", "0.6")),
            ocr_model_name=os.getenv("OCR_MODEL_NAME", "microsoft/trocr-base-printed"),
            ocr_model_revision=os.getenv("OCR_MODEL_REVISION", "v1.0.0"),
            ocr_model_policy=model_policy,
            ocr_batch_size=int(os.getenv("OCR_BATCH_SIZE", "16")),
            ocr_reconcile_interval=int(os.getenv("OCR_RECONCILE_INTERVAL", "300")),
            ocr_channel=os.getenv("OCR_CHANNEL", "ocr_complete"),
            ocr_preprocess_block_size=int(os.getenv("OCR_PREPROCESS_BLOCK_SIZE", "15")),
            ocr_preprocess_threshold_c=int(os.getenv("OCR_PREPROCESS_THRESHOLD_C", "9")),
            ocr_preprocess_clahe_clip=float(os.getenv("OCR_PREPROCESS_CLAHE_CLIP", "2.0")),
            ocr_preprocess_unsharp_amount=float(os.getenv("OCR_PREPROCESS_UNSHARP_AMOUNT", "1.4")),
            ocr_layout_analysis_enabled=_as_bool(os.getenv("OCR_LAYOUT_ANALYSIS_ENABLED", "true")),
            ocr_layout_max_columns=int(os.getenv("OCR_LAYOUT_MAX_COLUMNS", "3")),
            ocr_layout_column_gap=float(os.getenv("OCR_LAYOUT_COLUMN_GAP", "0.12")),
            ocr_pdf_enabled=_as_bool(os.getenv("OCR_PDF_ENABLED", "false")),
            ocr_pdf_max_pages=int(os.getenv("OCR_PDF_MAX_PAGES", "25")),
            ocr_pdf_dpi=int(os.getenv("OCR_PDF_DPI", "200")),
            log_level=os.getenv("LOG_LEVEL", "INFO"),
            init_sql_path=os.getenv("OCR_INIT_SQL_PATH", "/app/init.sql"),
            max_retries=int(os.getenv("OCR_MAX_RETRIES", "3")),
            metrics_log_interval=int(os.getenv("OCR_METRICS_LOG_INTERVAL", "60")),
            health_host=os.getenv("OCR_HEALTH_HOST", "0.0.0.0"),
            health_port=int(os.getenv("OCR_HEALTH_PORT", "8088")),
        )

    def validate(self) -> None:
        missing = []
        if not self.db_url:
            missing.append("DB_URL")
        if not self.immich_url:
            missing.append("IMMICH_URL")
        if not self.immich_api_key:
            missing.append("IMMICH_API_KEY")
        if missing:
            raise ValueError(f"Missing required environment variables: {', '.join(missing)}")

        if self.external_ocr_mode not in {"bridge", "direct-db", "metadata"}:
            raise ValueError("EXTERNAL_OCR_MODE must be one of: bridge, direct-db, metadata")

        if self.ocr_batch_size <= 0:
            raise ValueError("OCR_BATCH_SIZE must be > 0")

        if self.ocr_reconcile_interval < 0:
            raise ValueError("OCR_RECONCILE_INTERVAL must be >= 0")

        if self.ocr_preprocess_block_size < 3 or self.ocr_preprocess_block_size % 2 == 0:
            raise ValueError("OCR_PREPROCESS_BLOCK_SIZE must be an odd integer >= 3")

        if self.ocr_preprocess_clahe_clip <= 0:
            raise ValueError("OCR_PREPROCESS_CLAHE_CLIP must be > 0")

        if self.ocr_preprocess_unsharp_amount < 0:
            raise ValueError("OCR_PREPROCESS_UNSHARP_AMOUNT must be >= 0")

        if self.ocr_layout_max_columns < 1:
            raise ValueError("OCR_LAYOUT_MAX_COLUMNS must be >= 1")

        if self.ocr_layout_column_gap < 0:
            raise ValueError("OCR_LAYOUT_COLUMN_GAP must be >= 0")

        if self.ocr_pdf_max_pages < 1:
            raise ValueError("OCR_PDF_MAX_PAGES must be >= 1")

        if self.ocr_pdf_dpi < 72:
            raise ValueError("OCR_PDF_DPI must be >= 72")

        if self.metrics_log_interval < 0:
            raise ValueError("OCR_METRICS_LOG_INTERVAL must be >= 0")

        if self.health_port <= 0 or self.health_port > 65535:
            raise ValueError("OCR_HEALTH_PORT must be in range 1..65535")


def _as_bool(raw: str) -> bool:
    value = (raw or "").strip().lower()
    return value in {"1", "true", "yes", "on"}


def _parse_model_policy(raw: str) -> dict:
    if not raw.strip():
        return {}

    data = json.loads(raw)
    if not isinstance(data, dict):
        raise ValueError("OCR_MODEL_POLICY_JSON must be a JSON object")

    policy: dict[str, object] = {}
    default_value = data.get("default")
    if default_value is not None:
        if not isinstance(default_value, str) or not default_value.strip():
            raise ValueError("OCR_MODEL_POLICY_JSON.default must be a non-empty string")
        policy["default"] = default_value.strip()

    for section in ("tag", "library"):
        value = data.get(section, {})
        if value is None:
            value = {}
        if not isinstance(value, dict):
            raise ValueError(f"OCR_MODEL_POLICY_JSON.{section} must be an object")

        mapped: dict[str, str] = {}
        for key, model in value.items():
            if not isinstance(model, str) or not model.strip():
                raise ValueError(f"OCR_MODEL_POLICY_JSON.{section}.{key} must be a non-empty string")
            normalized_key = str(key).strip().lower() if section == "tag" else str(key).strip()
            if not normalized_key:
                raise ValueError(f"OCR_MODEL_POLICY_JSON.{section} contains an empty key")
            mapped[normalized_key] = model.strip()

        policy[section] = mapped

    return policy
