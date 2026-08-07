#!/usr/bin/env python3

from __future__ import annotations

import json
import sys
from pathlib import Path


def main() -> int:
    if len(sys.argv) != 3:
        print(
            "Usage: read-json-value.py JSON_FILE DOTTED_KEY_PATH",
            file=sys.stderr,
        )
        return 1

    json_path = Path(sys.argv[1])
    key_path = sys.argv[2]

    if not json_path.is_file():
        print(f"JSON file does not exist: {json_path}", file=sys.stderr)
        return 1

    with json_path.open("r", encoding="utf-8") as handle:
        payload = json.load(handle)

    value = payload
    for part in key_path.split("."):
        if isinstance(value, dict) and part in value:
            value = value[part]
        else:
            return 1

    if isinstance(value, bool):
        print("true" if value else "false")
    elif value is None:
        return 1
    else:
        print(value)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
