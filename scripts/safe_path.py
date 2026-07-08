#!/usr/bin/env python3
from __future__ import annotations

import os
from pathlib import Path
from typing import Iterable, Union

PathLike = Union[str, os.PathLike]
AllowedBase = Union[PathLike, None]


def repo_root() -> Path:
    return Path(__file__).resolve().parents[1]


def validate_path(
    candidate: PathLike,
    allowed_bases: Iterable[AllowedBase],
    *,
    must_exist: bool = False,
) -> Path:
    resolved = Path(candidate).resolve()

    bases = [Path(b).resolve() for b in allowed_bases if b]
    if not any(resolved.is_relative_to(base) for base in bases):
        raise ValueError(f"Cannot access {resolved}: outside allowed directories")

    if must_exist and not resolved.is_file():
        raise FileNotFoundError(f"File: {resolved} does not exist")

    return resolved
