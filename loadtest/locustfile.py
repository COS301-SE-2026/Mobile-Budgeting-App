

import os
import random
import uuid
from datetime import datetime, timezone

from locust import HttpUser, between, events, task


QR01_P95_MS = 400             
QR01_CONCURRENT_USERS = 50   
QR02_MAX_ERROR_RATE = 0.01   

REQUEST_NAME = "powersync/upload"
UPLOAD_PATH = "/powersync/upload"
REQUEST_TIMEOUT_S = 10.0

TRANSACTION_TYPES = ("income", "expense")
TRANSACTION_SOURCES = ("manual", "import", "recurring")
CATEGORY_TYPES = ("income", "expense")
CURRENCY = "ZAR"


@events.init_command_line_parser.add_listener
def _add_loadtest_args(parser):
    parser.add_argument(
        "--token",
        type=str,
        default=os.getenv("BUDGETIT_TOKEN", ""),
        help="Cognito Bearer JWT required by /powersync/upload.",
    )
    parser.add_argument(
        "--batch-min",
        type=int,
        default=int(os.getenv("BUDGETIT_BATCH_MIN", "1")),
        help="Minimum number of CRUD ops per upload request.",
    )
    parser.add_argument(
        "--batch-max",
        type=int,
        default=int(os.getenv("BUDGETIT_BATCH_MAX", "5")),
        help="Maximum number of CRUD ops per upload request.",
    )


def _iso_now() -> str:
    return datetime.now(timezone.utc).isoformat()


def _transaction_op() -> dict:
    """A realistic `put` (upsert) for the `transactions` table.

    `user_id` is intentionally omitted: the backend injects it from the JWT's
    `sub` claim for owned tables.
    """
    return {
        "id": str(uuid.uuid4()),
        "op": "put",
        "table": "transactions",
        "data": {
            "amount": f"{random.uniform(1.0, 5000.0):.2f}",
            "type": random.choice(TRANSACTION_TYPES),
            "short_description": f"loadtest-{uuid.uuid4().hex[:8]}",
            "transaction_date": _iso_now(),
            "created_at": _iso_now(),
            "updated_at": _iso_now(),
            "source": random.choice(TRANSACTION_SOURCES),
            "currency": CURRENCY,
        },
    }


def _category_op() -> dict:
    return {
        "id": str(uuid.uuid4()),
        "op": "put",
        "table": "categories",
        "data": {
            "name": f"loadtest-cat-{uuid.uuid4().hex[:6]}",
            "type": random.choice(CATEGORY_TYPES),
            "is_default": False,
            "created_at": _iso_now(),
            "updated_at": _iso_now(),
        },
    }


def _build_payload(batch_min: int, batch_max: int) -> dict:
    n = random.randint(batch_min, batch_max)
    ops = [
        _transaction_op() if random.random() < 0.85 else _category_op()
        for _ in range(n)
    ]
    return {"operations": ops}


class BudgetItUser(HttpUser):
    wait_time = between(0.5, 1.5)

    def on_start(self):
        opts = self.environment.parsed_options
        self.token = opts.token
        self.batch_min = max(1, opts.batch_min)
        self.batch_max = max(self.batch_min, opts.batch_max)

        if not self.token:
            print(
                "[WARN] No --token supplied. /powersync/upload will return 401 "
                "for every request (QR-02 will fail). Provide a Cognito JWT via "
                "--token or the BUDGETIT_TOKEN environment variable."
            )

    @task
    def upload(self):
        self.client.post(
            UPLOAD_PATH,
            json=_build_payload(self.batch_min, self.batch_max),
            headers={"Authorization": f"Bearer {self.token}"},
            name=REQUEST_NAME,
            timeout=REQUEST_TIMEOUT_S,
        )


@events.test_stop.add_listener
def _report_qr_results(environment, **kwargs):
    entry = environment.stats.get(REQUEST_NAME, "POST") or environment.stats.total

    if entry is None or entry.num_requests == 0:
        print("\n[QR-01/QR-02] No /powersync/upload requests were recorded.")
        return

    p95 = entry.get_response_time_percentile(0.95)
    p99 = entry.get_response_time_percentile(0.99)
    error_rate = entry.num_failures / entry.num_requests

    qr01_pass = p95 < QR01_P95_MS
    qr02_pass = error_rate < QR02_MAX_ERROR_RATE

    print("\n================ QR-01 / QR-02 RESULT ================")
    print(f"Requests        : {entry.num_requests}")
    print(f"Failures        : {entry.num_failures}")
    print(f"Avg / p95 / p99 : {entry.avg_response_time:.1f} ms / "
          f"{p95:.1f} ms / {p99:.1f} ms")
    print(f"Error rate      : {error_rate * 100:.2f}%")
    print(f"QR-01 (p95 < {QR01_P95_MS} ms @ {QR01_CONCURRENT_USERS} users): "
          f"{'PASS' if qr01_pass else 'FAIL'}")
    print(f"QR-02 (error rate < {QR02_MAX_ERROR_RATE * 100:.1f}%): "
          f"{'PASS' if qr02_pass else 'FAIL'}")
    print("======================================================\n")
