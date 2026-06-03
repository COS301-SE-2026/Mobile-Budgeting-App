#!/usr/bin/env python3

import argparse
import json
import os
import re
import tempfile


def inject_coverage_badges(readme_path: str, badge_path: str = ""):
    if badge_path == "":
        badge_path = os.path.join(tempfile.gettempdir(), "coverage_badges.json")

    with open(badge_path, "r") as f:
        badge_data = json.load(f)

    with open(readme_path, "r") as f:
        content = f.read()

    for metric in ["lines", "branches", "functions"]:
        badge_content = badge_data.get(metric)
        if badge_content is not None:
            marker = f"shieldcn-coverage-{metric}"
            pattern = (
                rf'<span id="{marker}-start"></span>.*?<span id="{marker}-end"></span>'
            )
            replacement = rf'<span id="{marker}-start"></span>{badge_content}<span id="{marker}-end"></span>'
            content = re.sub(pattern, replacement, content, flags=re.DOTALL)

    with open(readme_path, "w") as f:
        f.write(content)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--readme-path", required=False, type=str, default="README.md")
    parser.add_argument("--badge-path", required=False, type=str, default="")
    args = parser.parse_args()
    inject_coverage_badges(args.readme_path, args.badge_path)
