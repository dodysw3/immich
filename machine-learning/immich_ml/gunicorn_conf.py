import os
import sys

from gunicorn.arbiter import Arbiter
from gunicorn.workers.base import Worker

device_ids = os.environ.get("MACHINE_LEARNING_DEVICE_IDS", "0").replace(" ", "").split(",")

# Worker counter for round-robin
_worker_idx = 0


# Round-robin device assignment for each worker
def pre_fork(arbiter: Arbiter, _: Worker) -> None:
    global _worker_idx
    _worker_idx += 1


def post_fork(server: Worker, master: Arbiter) -> None:
    global _worker_idx
    device_id = device_ids[(_worker_idx - 1) % len(device_ids)]
    os.environ["MACHINE_LEARNING_DEVICE_ID"] = device_id
    print(f"Worker assigned to GPU device_id={device_id}", file=sys.stderr, flush=True)
