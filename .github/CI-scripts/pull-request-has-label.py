#!/usr/bin/env python3

from __future__ import annotations

import json
import sys
from pathlib import Path


def main() -> int:
    if len(sys.argv) != 3:
        print(
            "Usage: pull-request-has-label.py JSON_FILE LABEL_NAME",
            file=sys.stderr,
        )
        return 1

    json_path = Path(sys.argv[1])
    label_name = sys.argv[2]

    if not json_path.is_file():
        print(f"JSON file does not exist: {json_path}", file=sys.stderr)
        return 1

    with json_path.open("r", encoding="utf-8") as handle:
        payload = json.load(handle)

    pull_request = payload.get("pull_request")
    if not isinstance(pull_request, dict):
        return 1

    labels = pull_request.get("labels", [])
    if not isinstance(labels, list):
        return 1

    for label in labels:
        if isinstance(label, dict) and label.get("name") == label_name:
            return 0

    return 1


if __name__ == "__main__":
    raise SystemExit(main())
