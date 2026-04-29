from __future__ import annotations

import logging
import select
import time

import psycopg2
from psycopg2 import extensions

logger = logging.getLogger(__name__)


class PgListener:
    def __init__(self, db_url: str, channel: str = "ocr_complete") -> None:
        self.db_url = db_url
        self.channel = channel
        self.conn: extensions.connection | None = None
        self._connect()

    def _connect(self) -> None:
        self.conn = psycopg2.connect(self.db_url)
        self.conn.set_isolation_level(extensions.ISOLATION_LEVEL_AUTOCOMMIT)
        with self.conn.cursor() as cur:
            cur.execute(f"LISTEN {self.channel};")
        logger.info("Listening on PostgreSQL channel '%s'", self.channel)

    def __iter__(self):
        return self

    def __next__(self) -> str:
        while True:
            try:
                assert self.conn is not None
                if select.select([self.conn], [], [], 60) != ([], [], []):
                    self.conn.poll()
                    while self.conn.notifies:
                        notify = self.conn.notifies.pop(0)
                        if notify.payload:
                            return notify.payload
                self._keepalive()
            except (psycopg2.OperationalError, psycopg2.InterfaceError):
                self._reconnect()

    def _keepalive(self) -> None:
        assert self.conn is not None
        try:
            with self.conn.cursor() as cur:
                cur.execute("SELECT 1")
        except Exception:
            self._reconnect()

    def _reconnect(self) -> None:
        logger.warning("PostgreSQL connection lost, reconnecting")
        backoff = 1
        while True:
            try:
                self._connect()
                logger.info("PostgreSQL reconnect succeeded")
                return
            except Exception as error:
                logger.error("Reconnect failed: %s. Retrying in %ss", error, backoff)
                time.sleep(backoff)
                backoff = min(backoff * 2, 60)
