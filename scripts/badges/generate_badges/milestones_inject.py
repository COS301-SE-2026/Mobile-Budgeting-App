import argparse
import json
import os
import re
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[2]))
from safe_path import PathLike, repo_root, validate_path  # noqa: E402


def inject_milestone_badges(
    readme_path: PathLike, badge_path: PathLike = "", num_demos: int = 4
):
    if badge_path == "":
        badge_path = os.path.join(tempfile.gettempdir(), "demo_badges.json")
    badge_path = validate_path(
        badge_path, [tempfile.gettempdir(), repo_root()], must_exist=True
    )
    readme_path = validate_path(readme_path, [repo_root()])

    with open(badge_path, "r") as f:
        milestone_badges = json.load(f)

    if milestone_badges == {}:
        return

    with open(readme_path, "r") as f:
        content = f.read()

    for i in range(1, num_demos + 1):
        badge_content = milestone_badges[f"Demo{i}"]
        if badge_content is not None:
            marker = rf"demo{i}-progress"
            pattern = rf'<span id="shieldcn-{marker}-start"></span>.*?<span id="shieldcn-{marker}-end"></span>'
            replacement = rf'<span id="shieldcn-{marker}-start"></span>{badge_content}<span id="shieldcn-{marker}-end"></span>'
            content = re.sub(pattern, replacement, content, flags=re.DOTALL)

    with open(readme_path, "w") as f:
        f.write(content)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--readme-path", required=False, type=str, default="../../../README.md"
    )
    parser.add_argument("--badge-path", required=False, type=str, default="")
    parser.add_argument("--num-demos", required=False, type=int, default=4)
    args = parser.parse_args()
    inject_milestone_badges(args.readme_path, args.badge_path, args.num_demos)
