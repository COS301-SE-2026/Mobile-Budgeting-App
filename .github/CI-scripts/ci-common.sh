#!/usr/bin/env bash
set -euo pipefail

readonly CI_ANNOTATION_WARNING_PREFIX='::warning::'
readonly CI_ANNOTATION_ERROR_PREFIX='::error::'

readonly CI_BOOLEAN_TRUE='true'
readonly CI_BOOLEAN_FALSE='false'

readonly CI_PATH_PREFIX='/'
readonly CI_PATH_RELATIVE_PATH_MESSAGE='Provided path must be relative'
readonly CI_PATH_EMPTY_MESSAGE='Provided relative path must be non-empty'
readonly CI_PATH_TRAVERSAL_MESSAGE='Path traversal is forbidden'

readonly CI_MISSING_OUTPUT_MESSAGE='GITHUB_OUTPUT is not set for boolean output'

ci_log() {
  printf '[Ci] %s\n' "$*" >&2
}

ci_warn() {
  printf '%s%s\n' "$CI_ANNOTATION_WARNING_PREFIX" "$(ci_escape_github_message "$*")"
}

ci_error() {
  printf '%s%s\n' "$CI_ANNOTATION_ERROR_PREFIX" "$(ci_escape_github_message "$*")"
}

ci_escape_github_message() {
  local raw_message=${1-}
  local escaped_message

  escaped_message=${raw_message//'%'/'%25'}
  escaped_message=${escaped_message//$'\r'/'%0D'}
  escaped_message=${escaped_message//$'\n'/'%0A'}

  printf '%s' "$escaped_message"
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
    ci_error "Runner is missing the following required command\s: ${missing_commands[*]}"
    return 1
  fi
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
    ci_error "$CI_PATH_EMPTY_MESSAGE"
    return 1
  fi

  if [[ "$relative_path" == "$CI_PATH_PREFIX"* ]]; then
    ci_error "${CI_PATH_RELATIVE_PATH_MESSAGE}: ${relative_path}"
    return 1
  fi

  if ci_is_relative_path_traversal "$relative_path"; then
    ci_error "${CI_PATH_TRAVERSAL_MESSAGE}: ${relative_path}"
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
    ci_error "Boolean output ${output_name} must be true or false, got: ${output_value}"
    return 1
  fip

  if [ -z "${GITHUB_OUTPUT:-}" ]; then
    ci_error "${CI_MISSING_OUTPUT_MESSAGE} ${output_name}"
    return 1
  fi

  printf '%s=%s\n' "$output_name" "$output_value" >>"$GITHUB_OUTPUT"
}
