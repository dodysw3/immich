from __future__ import annotations

from datetime import datetime, timezone
from urllib.parse import quote

import requests


class ImmichClient:
    def __init__(
        self,
        base_url: str,
        api_key: str,
        model_revision: str,
        model_name: str = "microsoft/trocr-base-printed",
    ) -> None:
        self.base_url = base_url.rstrip("/")
        self.model_revision = model_revision
        self.model_name = model_name
        self.session = requests.Session()
        self.session.headers.update({"x-api-key": api_key})

    def get_asset(self, asset_id: str) -> dict:
        response = self.session.get(f"{self.base_url}/api/assets/{asset_id}", timeout=30)
        response.raise_for_status()
        return response.json()

    def download_original(self, asset_id: str) -> bytes:
        response = self.session.get(f"{self.base_url}/api/assets/{asset_id}/original", timeout=120)
        response.raise_for_status()
        return response.content

    def get_asset_ocr(self, asset_id: str) -> list[dict]:
        response = self.session.get(f"{self.base_url}/api/assets/{asset_id}/ocr", timeout=30)
        response.raise_for_status()
        return response.json()

    def get_asset_metadata(self, asset_id: str, key: str) -> dict | None:
        encoded_key = quote(key, safe="")
        response = self.session.get(f"{self.base_url}/api/assets/{asset_id}/metadata/{encoded_key}", timeout=20)

        if response.status_code == 404:
            return None

        # Immich returns 400 when metadata key does not exist on an asset.
        if response.status_code == 400:
            try:
                payload = response.json()
                message = payload.get("message", "")
                if isinstance(message, list):
                    message = " ".join(str(item) for item in message)
            except ValueError:
                message = ""

            if "not found" in str(message).lower():
                return None

        response.raise_for_status()
        return response.json().get("value")

    def write_ocr_result(self, asset_id: str, lines: list[dict], source_checksum: str, search_text: str | None = None) -> dict:
        payload = {
            "provider": "immich-ocr-gpu",
            "model": self.model_name,
            "modelRevision": self.model_revision,
            "sourceChecksum": source_checksum,
            "mode": "replace",
            "processedAt": datetime.now(timezone.utc).isoformat(),
            "lines": lines,
        }

        if search_text is not None:
            payload["searchText"] = search_text

        response = self.session.put(
            f"{self.base_url}/api/external-ocr/assets/{asset_id}/result", json=payload, timeout=30
        )
        response.raise_for_status()
        return response.json()

    def report_failure(self, asset_id: str, reason: str, retry_count: int, retriable: bool) -> None:
        payload = {
            "provider": "immich-ocr-gpu",
            "reason": reason[:1000],
            "retryCount": retry_count,
            "retriable": retriable,
        }
        response = self.session.put(
            f"{self.base_url}/api/external-ocr/assets/{asset_id}/failure", json=payload, timeout=20
        )
        response.raise_for_status()
