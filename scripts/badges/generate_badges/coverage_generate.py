#!/usr/bin/env python3
import argparse
import json
import os
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))
from safe_path import validate_path

FORMAT = r"png"

HIGH_COVERAGE_COLOR = r"36F57C"
MEDIUM_COVERAGE_COLOR = r"F5DB36"
LOW_COVERAGE_COLOR = r"e05d44"

HIGH_COVERAGE_ICON = r"lu%3AShieldCheck"
MEDIUM_COVERAGE_ICON = r"lu%3AShield"
LOW_COVERAGE_ICON = r"lu%3AShieldAlert"

HIGH_COVERAGE_THRESHOLD = 80
MEDIUM_COVERAGE_THRESHOLD = 50


def generate_coverage_badge(metric: str, percent: float) -> str:
    percent_string = f"{percent:.1f}%25"
    if percent >= HIGH_COVERAGE_THRESHOLD:
        color = HIGH_COVERAGE_COLOR
        icon = HIGH_COVERAGE_ICON
    elif percent >= MEDIUM_COVERAGE_THRESHOLD:
        color = MEDIUM_COVERAGE_COLOR
        icon = MEDIUM_COVERAGE_ICON
    else:
        color = LOW_COVERAGE_COLOR
        icon = LOW_COVERAGE_ICON

    return rf"![badge](https://shieldcn.dev/badge/{metric}-{percent_string}-{color}.{FORMAT}?logo={icon})"


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--summary-json", required=True, type=Path)
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(os.path.join(tempfile.gettempdir(), "coverage_badges.json")),
    )
    args = parser.parse_args()

    try:
        summary_path = validate_path(args.summary_json, [Path.cwd()], must_exist=True)
        output_path = validate_path(args.output, [Path.cwd(), Path(tempfile.gettempdir())])
    except (ValueError, FileNotFoundError) as e:
        print(f"::error::{e}", file=sys.stderr)
        sys.exit(1)

    with open(summary_path, encoding="utf-8") as f:
        metrics = json.load(f)

    badges = {
        "lines": generate_coverage_badge("Lines", metrics["lines"]),
        "branches": generate_coverage_badge("Branches", metrics["branches"]),
        "functions": generate_coverage_badge("Functions", metrics["functions"]),
    }

    with open(output_path, "w", encoding="utf-8") as f:
        json.dump(badges, f, indent=2)