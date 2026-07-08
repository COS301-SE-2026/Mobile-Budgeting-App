#!/usr/bin/env python3
import argparse
import json
import re
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from safe_path import validate_path

LINES_HIT_PATTERN = r"^LH:(\d+)"
LINES_FOUND_PATTERN = r"^LF:(\d+)"
BRANCHES_HIT_PATTERN = r"^BRH:(\d+)"
BRANCHES_FOUND_PATTERN = r"BRF:(\d+)"
FUNCTIONS_HIT_PATTERN = r"^FNH:(\d+)"
FUNCTIONS_FOUND_PATTERN = r"^FNF:(\d+)"


def coverage_percentage(content: str, hit_pattern: str, found_pattern: str) -> float:
    hit_total = sum(int(m) for m in re.findall(hit_pattern, content, re.MULTILINE))
    found_total = sum(int(m) for m in re.findall(found_pattern, content, re.MULTILINE))
    if found_total == 0:
        return 0
    return round(hit_total / found_total * 100, 2)


def parse_lcov(lcov_path: Path) -> dict:
    with open(lcov_path, encoding="utf-8") as f:
        content = f.read()
    return {
        "lines": coverage_percentage(content, LINES_HIT_PATTERN, LINES_FOUND_PATTERN),
        "branches": coverage_percentage(content, BRANCHES_HIT_PATTERN, BRANCHES_FOUND_PATTERN),
        "functions": coverage_percentage(content, FUNCTIONS_HIT_PATTERN, FUNCTIONS_FOUND_PATTERN),
    }


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--lcov-file", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    try:
        lcov_path = validate_path(args.lcov_file, [Path.cwd()], must_exist=True)
        output_path = validate_path(
            args.output,
            [Path.cwd(), Path(tempfile.gettempdir())],
        )
    except (ValueError, FileNotFoundError) as e:
        print(f"::error::{e}", file=sys.stderr)
        sys.exit(1)

    metrics = parse_lcov(lcov_path)
    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(metrics, f, indent=2)

    print(f"lines={metrics['lines']}")
    print(f"branches={metrics['branches']}")
    print(f"functions={metrics['functions']}")