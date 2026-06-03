#!/usr/bin/env python3
import argparse
import json
import os
import tempfile

FORMAT = r"png"


NOT_STARTED_COLOR = r"6e6e6e"
IN_PROGRESS_COLOR = r"F5DB36"
COMPLETE_COLOR = r"36F57C"

IN_PROGRESS_ICON = r"lu%3ALoaderCircle"
COMPLETE_ICON = r"lu%3ACheck"
NOT_STARTED_ICON = r"false"


COMPLETE_THRESHOLD = 0.9


def generate_milestone_badge(demo_num: int, percent: float) -> str:
    BADGE_LABEL = rf"Demo%20{demo_num}%20%3A%20"
    color = None
    icon = None
    message = None
    if percent <= 0.0:
        color = NOT_STARTED_COLOR
        icon = NOT_STARTED_ICON
        message = r"Not%20Started"

    elif percent >= COMPLETE_THRESHOLD:
        message = r"Completed"
        color = COMPLETE_COLOR
        icon = COMPLETE_ICON
    else:
        message = rf"In%20Progress%20{percent * 100:.2f}%25"
        color = IN_PROGRESS_COLOR
        icon = IN_PROGRESS_ICON

    return rf"![badge](https://shieldcn.dev/badge/{BADGE_LABEL}-{message}-{color}.{FORMAT}?logo={icon}&size=default)"


if __name__ == "__main__":
    demo_badges = {}
    parser = argparse.ArgumentParser()
    parser.add_argument("--demo1-percent", required=False, type=float)
    parser.add_argument("--demo2-percent", required=False, type=float)
    parser.add_argument("--demo3-percent", required=False, type=float)
    parser.add_argument("--demo4-percent", required=False, type=float)

    args = parser.parse_args()
    if args.demo1_percent is not None:
        demo_badges["Demo1"] = generate_milestone_badge(1, args.demo1_percent)
    if args.demo2_percent is not None:
        demo_badges["Demo2"] = generate_milestone_badge(2, args.demo2_percent)
    if args.demo3_percent is not None:
        demo_badges["Demo3"] = generate_milestone_badge(3, args.demo3_percent)
    if args.demo4_percent is not None:
        demo_badges["Demo4"] = generate_milestone_badge(4, args.demo4_percent)

    badge_path = os.path.join(tempfile.gettempdir(), "demo_badges.json")

    with open(badge_path, "w") as f:
        json.dump(demo_badges, f)
