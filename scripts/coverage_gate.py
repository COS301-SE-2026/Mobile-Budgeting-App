#!/usr/bin/env python3
import argparse
import os
import re
import sys
import tempfile
from pathlib import Path

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

    lines_coverage = coverage_percentage(
        content, LINES_HIT_PATTERN, LINES_FOUND_PATTERN
    )
    branches_coverage = coverage_percentage(
        content, BRANCHES_HIT_PATTERN, BRANCHES_FOUND_PATTERN
    )
    functions_coverage = coverage_percentage(
        content, FUNCTIONS_HIT_PATTERN, FUNCTIONS_FOUND_PATTERN
    )

    return {
        "lines": lines_coverage,
        "branches": branches_coverage,
        "functions": functions_coverage,
    }


def write_output(metrics: dict, output_file: Path) -> None:
    with open(output_file, "a", encoding="utf-8") as f:
        f.write(f"lines={metrics['lines']}\n")
        f.write(f"branches={metrics['branches']}\n")
        f.write(f"functions={metrics['functions']}\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--lcov-file",
        type=Path,
    )

    parser.add_argument(
        "--threshold",
        type=float,
        default=70.0,
    )

    parser.add_argument(
        "--output",
        type=Path,
        default=Path(os.path.join(tempfile.gettempdir(), "coverage_output")),
    )

    parser.add_argument("--quiet", action="store_true", default=False)

    args = parser.parse_args()

    if "COVERAGE_THRESHOLD" in os.environ:
        args.threshold = float(os.environ["COVERAGE_THRESHOLD"])

    try:
        lcov_path = validate_path(args.lcov_file, [Path.cwd()], must_exist=True)
    except (ValueError, FileNotFoundError) as e:
        print(f"::error::{e}", file=sys.stderr)
        sys.exit(1)

    metrics = parse_lcov(lcov_path)

    if not args.quiet:
        print("Coverage Report:")
        print(f"-Lines: {metrics['lines']:.1f}%")
        print(f"-Branches: {metrics['branches']:.1f}%")
        print(f"-Functions: {metrics['functions']:.1f}%")

    output_path = validate_path(
        args.output,
        [
            tempfile.gettempdir(),
            os.environ.get("RUNNER_TEMP"),
            Path(os.environ["GITHUB_OUTPUT"]).parent
            if os.environ.get("GITHUB_OUTPUT")
            else None,
            Path.cwd(),
        ],
    )
    write_output(metrics, output_path)

    if metrics["lines"] < args.threshold:
        print(
            f"::error:: Line coverage below threshold , Line Coverage : {metrics['lines']:.1f}% , Threshold : {args.threshold}%",
            file=sys.stderr,
        )
        sys.exit(1)

    if not args.quiet:
        print(" Coverage Gate Passed ")
