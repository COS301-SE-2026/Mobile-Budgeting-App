#!/usr/bin/env python3
import argparse
import json
import tempfile

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
    parser.add_argument("--lines", required=True, type=float)
    parser.add_argument("--branches", required=True, type=float)
    parser.add_argument("--functions", required=True, type=float)

    args = parser.parse_args()

    badges = {
        "lines": generate_coverage_badge("Lines", args.lines),
        "branches": generate_coverage_badge("Branches", args.branches),
        "functions": generate_coverage_badge("Functions", args.functions),
    }

    file = tempfile.TemporaryFile(dir="/tmp/coverage_badges.json", mode="w")
    json.dump(badges, file)
