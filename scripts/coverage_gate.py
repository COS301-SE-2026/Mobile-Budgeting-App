#!/usr/bin/env python3
import argparse
import json
import os
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from safe_path import validate_path


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--coverage-json", type=Path, required=True)
    parser.add_argument("--threshold", type=float, default=70.0)
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
        json_path = validate_path(args.coverage_json, [Path.cwd()], must_exist=True)
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
    except (ValueError, FileNotFoundError) as e:
        print(f"::error::{e}", file=sys.stderr)
        sys.exit(1)

    with open(json_path, encoding="utf-8") as f:
        metrics = json.load(f)

    if not args.quiet:
        print("Coverage Report:")
        print(f"-Lines: {metrics['lines']:.1f}%")
        print(f"-Branches: {metrics['branches']:.1f}%")
        print(f"-Functions: {metrics['functions']:.1f}%")

    with open(output_path, "a", encoding="utf-8") as f:
        f.write(f"lines={metrics['lines']}\n")
        f.write(f"branches={metrics['branches']}\n")
        f.write(f"functions={metrics['functions']}\n")

    if metrics["lines"] < args.threshold:
        print(
            f"::error:: Line coverage below threshold , Line Coverage : {metrics['lines']:.1f}% , Threshold : {args.threshold}%",
            file=sys.stderr,
        )
        sys.exit(1)

    if not args.quiet:
        print(" Coverage Gate Passed ")