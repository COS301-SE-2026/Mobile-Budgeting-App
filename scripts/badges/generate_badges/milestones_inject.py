import argparse
import json
import os
import re
import tempfile


def inject_milestone_badges(readme_path: str, badge_path: str = "", num_demos: int = 4):
    if badge_path == "":
        badge_path = os.path.join(tempfile.gettempdir(), "demo_badges.json")

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
