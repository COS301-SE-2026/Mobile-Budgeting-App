#!/usr/bin/env bash
set -Eeuo pipefail

fail() {
  printf '%s\n' "$1" >&2
  exit 1
}


ci_require_cmd() {
  local missing_commands=()
  local command_name

  for command_name in "$@"; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
      missing_commands+=("$command_name")
    fi
  done

  if [ "${#missing_commands[@]}" -ne 0 ]; then
    printf 'Runner is missing the following required commands: %s\n' "${missing_commands[*]}" >&2
    return 1
  fi
}

ci_first_match_in_text() {
  local regex=${1-}

  if [ -z "$regex" ]; then
    printf 'ci_first_match_in_text requires a regex\n' >&2
    return 1
  fi

  sed -n "
    s/${regex}/\\1/
    t found
    b
    :found
    p
    q
  "
}
