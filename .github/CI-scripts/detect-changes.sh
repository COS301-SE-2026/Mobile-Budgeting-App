#!/usr/bin/env bash

set -euo pipefail


script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "${script_dir}/ci-common.sh"


readonly GENERATED_DART_PATTERNS=(
  '*.g.dart'
  '*.freezed.dart'
  '*.mocks.dart'
)
readonly DOCS_PATTERNS=(
  '*.md'
  'docs/*'
)


readonly FLUTTER_APP_ROOT='Flutter/budgetit/'
readonly BACKEND_ROOT='backend/'
readonly GITHUB_ROOT='.github/'
readonly SCRIPTS_ROOT='scripts/'
readonly DOCKER_ROOT='docker/'


readonly ALL_ZERO_SHA='0000000000000000000000000000000000000000'

usage() {
  cat <<'EOF'
Usage: detect-changes.sh [--event-name NAME] [--event-path PATH] [--base-ref REF] [--head-ref REF]

Categorizes repo changes for CI policy choosing.
EOF
}



event_name=${GITHUB_EVENT_NAME:-}
event_path=${GITHUB_EVENT_PATH:-}
summary_file=${GITHUB_STEP_SUMMARY:-}
manual_base_ref=''
manual_head_ref=''


while [ "$#" -gt 0 ]; do
  case "$1" in
    --event-name)
      shift
      event_name=${1:-}
      ;;
    --event-path)
      shift
      event_path=${1:-}
      ;;
    --base-ref)
      shift
      manual_base_ref=${1:-}
      ;;
    --head-ref)
      shift
      manual_head_ref=${1:-}
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      ci_error "Unknown argument: $1"
      exit 1
      ;;
  esac
  shift
done


ci_require_cmd git python3 sort awk

if [ -z "$event_name" ]; then
  ci_error 'GITHUB_EVENT_NAME must be set or --event-name must be provided'
  exit 1
fi


read_event_value() {
  local json_path=${1-}
  local key_path=${2-}
  local reader_script="${script_dir}/read-json-value.py"

  if [ -z "$json_path" ] || [ -z "$key_path" ]; then
    ci_error 'read_event_value requires a JSON path and key path'
    exit 1
  fi

  if [ ! -f "$json_path" ]; then
    ci_error "GitHub event payload does not exist: ${json_path}"
    exit 1
  fi

  python3 "$reader_script" "$json_path" "$key_path"
}


resolve_commit_ref() {
  local ref_name=${1-}

  if [ -z "$ref_name" ]; then
    ci_error 'resolve_commit_ref requires a ref name'
    exit 1
  fi

  git rev-parse --verify "${ref_name}^{commit}"
}


is_generated_dart_path() {
  local pattern

  for pattern in "${GENERATED_DART_PATTERNS[@]}"; do
    case "$1" in
      ${FLUTTER_APP_ROOT}${pattern})
        return 0
        ;;
    esac
  done

  return 1
}


is_docs_path() {
  local pattern

  for pattern in "${DOCS_PATTERNS[@]}"; do
    case "$1" in
      ${pattern})
        return 0
        ;;
    esac
  done

  return 1
}

is_flutter_app_path() {
  case "$1" in
    ${FLUTTER_APP_ROOT}*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

is_backend_path() {
  case "$1" in
    ${BACKEND_ROOT}*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

is_shared_path() {
  case "$1" in
    ${GITHUB_ROOT}*|${SCRIPTS_ROOT}*|${DOCKER_ROOT}*|Dockerfile*|Makefile)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

classify_path() {
  local relative_path=${1-}

  if is_generated_dart_path "$relative_path"; then
    printf '%s\n' 'ignored-generated'
  elif is_docs_path "$relative_path"; then
    printf '%s\n' 'docs'
  elif is_flutter_app_path "$relative_path"; then
    printf '%s\n' 'dart'
  elif is_backend_path "$relative_path"; then
    printf '%s\n' 'backend'
  elif is_shared_path "$relative_path"; then
    printf '%s\n' 'shared'
  else
    printf '%s\n' 'shared'
  fi
}


collect_changed_files_from_range() {
  local start_ref=${1-}
  local end_ref=${2-}

  if [ -z "$start_ref" ] || [ -z "$end_ref" ]; then
    ci_error 'collect_changed_files_from_range requires both start and end refs'
    exit 1
  fi

  git diff --name-only "$start_ref" "$end_ref" | LC_ALL=C sort -u
}

collect_changed_files_from_commit() {
  local commit_ref=${1-}

  if [ -z "$commit_ref" ]; then
    ci_error 'collect_changed_files_from_commit requires a commit ref'
    exit 1
  fi

  git diff-tree --root --no-commit-id -r --name-only "$commit_ref" | LC_ALL=C sort -u
}


load_manual_dispatch_inputs() {
  if [ -z "$manual_base_ref" ] && [ -n "$event_path" ] && [ -f "$event_path" ]; then
    manual_base_ref=$(read_event_value "$event_path" 'inputs.base_ref' 2>/dev/null || true)
  fi

  if [ -z "$manual_head_ref" ] && [ -n "$event_path" ] && [ -f "$event_path" ]; then
    manual_head_ref=$(read_event_value "$event_path" 'inputs.head_ref' 2>/dev/null || true)
  fi
}


load_changed_files_for_commit() {
  local commit_ref=${1-}
  local label=${2-}

  if [ -z "$commit_ref" ] || [ -z "$label" ]; then
    ci_error 'load_changed_files_for_commit requires a commit ref and label'
    exit 1
  fi

  comparison_label=$label
  mapfile -t changed_files < <(collect_changed_files_from_commit "$commit_ref")
}


load_changed_files_for_range() {
  local start_ref=${1-}
  local end_ref=${2-}
  local label=${3-}

  if [ -z "$start_ref" ] || [ -z "$end_ref" ] || [ -z "$label" ]; then
    ci_error 'load_changed_files_for_range requires start ref, end ref, and label'
    exit 1
  fi

  comparison_label=$label
  mapfile -t changed_files < <(collect_changed_files_from_range "$start_ref" "$end_ref")
}


load_changed_files_for_workflow_dispatch() {
  load_manual_dispatch_inputs

  if [ -z "$manual_base_ref" ] || [ -z "$manual_head_ref" ]; then
    ci_error 'workflow_dispatch change detection requires --base-ref/--head-ref or inputs.base_ref/inputs.head_ref'
    exit 1
  fi

  load_changed_files_for_range \
    "$(resolve_commit_ref "$manual_base_ref")" \
    "$(resolve_commit_ref "$manual_head_ref")" \
    "${manual_base_ref}..${manual_head_ref}"
}


load_changed_files_for_pull_request() {
  if [ -z "$event_path" ]; then
    ci_error 'GITHUB_EVENT_PATH must be set for pull request change detection'
    exit 1
  fi

  base_sha=$(read_event_value "$event_path" 'pull_request.base.sha')
  head_sha=$(read_event_value "$event_path" 'pull_request.head.sha')
  load_changed_files_for_range "$base_sha" "$head_sha" "${base_sha}..${head_sha}"
}


load_changed_files_for_push() {
  if [ -n "${GITHUB_REF_TYPE:-}" ] && [ "$GITHUB_REF_TYPE" = 'tag' ]; then
    load_changed_files_for_commit \
      "$(resolve_commit_ref "${GITHUB_SHA:-}")" \
      "${GITHUB_REF_NAME:-${GITHUB_SHA:-}} (tag commit)"
    return 0
  fi

  if [ -z "$event_path" ]; then
    ci_error 'GITHUB_EVENT_PATH must be set for push change detection'
    exit 1
  fi

  before_sha=$(read_event_value "$event_path" 'before')
  after_sha=$(read_event_value "$event_path" 'after')

  if [ -z "$before_sha" ] || [ "$before_sha" = "$ALL_ZERO_SHA" ]; then
    load_changed_files_for_commit "$after_sha" "${before_sha}..${after_sha}"
  else
    load_changed_files_for_range "$before_sha" "$after_sha" "${before_sha}..${after_sha}"
  fi
}

load_changed_files_for_tag_commit() {
  load_changed_files_for_commit "$(resolve_commit_ref "${GITHUB_SHA:-}")" "${GITHUB_REF_NAME:-${GITHUB_SHA:-}} (tag commit)"
}

changed_files=()
comparison_label=''

case "$event_name" in
  workflow_dispatch)
    load_changed_files_for_workflow_dispatch
    ;;
  pull_request|pull_request_target)
    load_changed_files_for_pull_request
    ;;
  push)
    load_changed_files_for_push
    ;;
  *)
    if [ -n "${GITHUB_REF_TYPE:-}" ] && [ "$GITHUB_REF_TYPE" = 'tag' ]; then
      load_changed_files_for_tag_commit
    else
      ci_error "Unsupported GitHub event for change detection: ${event_name}"
      exit 1
    fi
    ;;
esac


trimmed_changed_files=()
has_docs_change=false
has_non_docs_change=false

dart_changed=false
backend_changed=false
shared_changed=false
ignored_generated_count=0


for relative_path in "${changed_files[@]}"; do
  [ -n "$relative_path" ] || continue

  category=$(classify_path "$relative_path")

  if [ "$category" = 'ignored-generated' ]; then
    ignored_generated_count=$((ignored_generated_count + 1))
    continue
  fi

  trimmed_changed_files+=("$relative_path")

  case "$category" in
    dart)
      dart_changed=true
      has_non_docs_change=true
      ;;
    backend)
      backend_changed=true
      has_non_docs_change=true
      ;;
    shared)
      shared_changed=true
      has_non_docs_change=true
      ;;
    docs)
      has_docs_change=true
      ;;
    *)
      shared_changed=true
      has_non_docs_change=true
      ;;
  esac

done

if [ "$has_docs_change" = true ] && [ "$has_non_docs_change" = false ]; then
  docs_only=true
else
  docs_only=false
fi

run_full_ci=$shared_changed

ci_write_bool_output 'dart_changed' "$dart_changed"
ci_write_bool_output 'backend_changed' "$backend_changed"
ci_write_bool_output 'shared_changed' "$shared_changed"
ci_write_bool_output 'docs_only' "$docs_only"
ci_write_bool_output 'run_full_ci' "$run_full_ci"

if [ -n "$summary_file" ]; then
  {
    printf '# Change detection summary\n\n'
    printf '| Key | Value |\n'
    printf '|---|---|\n'
    printf '| Event | `%s` |\n' "$event_name"
    printf '| Comparison | `%s` |\n' "$comparison_label"
    printf '| Ignored generated Dart files | `%s` |\n' "$ignored_generated_count"
    printf '| dart_changed | `%s` |\n' "$dart_changed"
    printf '| backend_changed | `%s` |\n' "$backend_changed"
    printf '| shared_changed | `%s` |\n' "$shared_changed"
    printf '| docs_only | `%s` |\n' "$docs_only"
    printf '| run_full_ci | `%s` |\n' "$run_full_ci"
    printf '\n'

    if [ "${#trimmed_changed_files[@]}" -eq 0 ]; then
      printf '_No non-generated changed files were detected._\n'
    else
      printf '| Changed file | Category |\n'
      printf '|---|---|\n'
      for relative_path in "${trimmed_changed_files[@]}"; do
        printf '| `%s` | `%s` |\n' "$relative_path" "$(classify_path "$relative_path")"
      done
    fi
  } >> "$summary_file"
fi

ci_log "Categorized ${#trimmed_changed_files[@]} changed file(s) for ${comparison_label}"
