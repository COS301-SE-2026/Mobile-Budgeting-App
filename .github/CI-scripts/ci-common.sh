#!/usr/bin/env bash
set -euo pipefail

readonly CI_BOOLEAN_TRUE='true'
readonly CI_BOOLEAN_FALSE='false'

readonly CI_PATH_PREFIX='/'
readonly CI_PATH_RELATIVE_PATH_MESSAGE='Provided path must be relative'
readonly CI_PATH_EMPTY_MESSAGE='Provided relative path must be non-empty'
readonly CI_PATH_TRAVERSAL_MESSAGE='Path traversal is forbidden'

readonly CI_MISSING_OUTPUT_MESSAGE='GITHUB_OUTPUT is not set for boolean output'

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

  sed -n "s/${regex}/\\1/p" | head -n 1
}

ci_first_match() {
  local regex=${1-}
  local file_path=${2-}

  if [ -z "$regex" ] || [ -z "$file_path" ]; then
    printf 'ci_first_match requires a regex and a file path\n' >&2
    return 1
  fi

  sed -n "s/${regex}/\\1/p" "$file_path" | head -n 1
}

ci_repo_root() {
  local repo_root

  if command -v git >/dev/null 2>&1; then
    repo_root=$(git rev-parse --show-toplevel 2>/dev/null || true)
    if [ -n "$repo_root" ]; then
      printf '%s\n' "$repo_root"
      return 0
    fi
  fi

  local script_dir
  script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
  repo_root=$(cd -- "${script_dir}/../.." && pwd)
  printf '%s\n' "$repo_root"
}

ci_is_relative_path_traversal() {
  case "$1" in
    .|..|../*|*/../*|*/..)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

ci_validate_relative_path() {
  local relative_path=${1-}

  if [ -z "$relative_path" ]; then
    printf '%s\n' "$CI_PATH_EMPTY_MESSAGE" >&2
    return 1
  fi

  if [[ "$relative_path" == "$CI_PATH_PREFIX"* ]]; then
    printf '%s: %s\n' "$CI_PATH_RELATIVE_PATH_MESSAGE" "$relative_path" >&2
    return 1
  fi

  if ci_is_relative_path_traversal "$relative_path"; then
    printf '%s: %s\n' "$CI_PATH_TRAVERSAL_MESSAGE" "$relative_path" >&2
    return 1
  fi
}


ci_repo_path() {
  local relative_path=${1-}
  local repo_root

  ci_validate_relative_path "$relative_path"
  repo_root=$(ci_repo_root)
  printf '%s/%s\n' "$repo_root" "$relative_path"
}

ci_write_bool_output() {
  local output_name=${1-}
  local output_value=${2-}

  if [ "$output_value" != "$CI_BOOLEAN_TRUE" ] && [ "$output_value" != "$CI_BOOLEAN_FALSE" ]; then
    printf 'Boolean output %s must be true or false, got: %s\n' "$output_name" "$output_value" >&2
    return 1
  fi

  if [ -z "${GITHUB_OUTPUT:-}" ]; then
    printf '%s %s\n' "$CI_MISSING_OUTPUT_MESSAGE" "$output_name" >&2
    return 1
  fi

  printf '%s=%s\n' "$output_name" "$output_value" >>"$GITHUB_OUTPUT"
}
