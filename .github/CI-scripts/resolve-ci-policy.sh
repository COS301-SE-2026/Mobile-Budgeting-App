#!/usr/bin/env bash

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

source "${script_dir}/ci-common.sh"


readonly EVENT_NAME_WORKFLOW_DISPATCH='workflow_dispatch'
readonly EVENT_NAME_PULL_REQUEST='pull_request'
readonly EVENT_NAME_PULL_REQUEST_TARGET='pull_request_target'
readonly EVENT_NAME_PUSH='push'


readonly REF_TYPE_BRANCH='branch'
readonly REF_TYPE_TAG='tag'

readonly POLICY_FEATURE='feature'
readonly POLICY_DEV='dev'
readonly POLICY_MAIN='main'

readonly POLICY_RELEASE_CANDIDATE='release-candidate'

readonly POLICY_FEATURE_TEST='feature-test'
readonly POLICY_DEV_TEST='dev-test'
readonly POLICY_MAIN_TEST='main-test'

readonly POLICY_PRODUCTION_RELEASE='production-release'

readonly ALLOWED_POLICIES=(
  "$POLICY_FEATURE"
  "$POLICY_DEV"
  "$POLICY_MAIN"
  "$POLICY_RELEASE_CANDIDATE"
  "$POLICY_FEATURE_TEST"
  "$POLICY_DEV_TEST"
  "$POLICY_MAIN_TEST"
  "$POLICY_PRODUCTION_RELEASE"
)


readonly BRANCH_MAIN='main'
readonly BRANCH_DEV='dev'
readonly BRANCH_NEW_DEV='newdev'
readonly BRANCH_FEATURE='feature'
readonly BRANCH_FEATURE_DOCKER='feature/docker'
readonly BRANCH_FEATURE_PREFIX='feature/'


readonly RELEASE_TAG_PREFIX='release-'
readonly CI_MAIN_TEST_TAG_PREFIX='ci-main-test-'
readonly CI_DEV_TEST_TAG_PREFIX='ci-dev-test-'
readonly CI_FEATURE_TEST_TAG_PREFIX='ci-feature-test-'

readonly REF_PREFIX_HEADS='refs/heads/'
readonly REF_PREFIX_TAGS='refs/tags/'

readonly EVENT_INPUT_POLICY='inputs.policy'
readonly EVENT_INPUT_POLICY_NAME='inputs.policy_name'
readonly EVENT_INPUT_BASE_REF='inputs.base_ref'
readonly EVENT_INPUT_HEAD_REF='inputs.head_ref'
readonly EVENT_PULL_REQUEST_BASE_REF='pull_request.base.ref'

readonly PULL_REQUEST_LABEL_RELEASE_CANDIDATE='release-candidate'

readonly PULL_REQUEST_LABEL_CHECK_SCRIPT="${script_dir}/pull-request-has-label.py"

usage() {
  cat <<'EOF'
Usage: resolve-ci-policy.sh [--event-name NAME] [--event-path PATH] [--ref-type TYPE] [--ref-name NAME] [--base-ref REF] [--head-ref REF] [--manual-policy POLICY]

Resolves the CI policy name for the current event context.
EOF
}




event_name=${GITHUB_EVENT_NAME:-}
event_path=${GITHUB_EVENT_PATH:-}
ref_type=${GITHUB_REF_TYPE:-}
ref_name=${GITHUB_REF_NAME:-}
base_ref=''
head_ref=''
manual_policy=''


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
    --ref-type)
      shift
      ref_type=${1:-}
      ;;
    --ref-name)
      shift
      ref_name=${1:-}
      ;;
    --base-ref)
      shift
      base_ref=${1:-}
      ;;
    --head-ref)
      shift
      head_ref=${1:-}
      ;;
    --manual-policy|--policy)
      shift
      manual_policy=${1:-}
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

ci_require_cmd python3

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
    return 1
  fi

  python3 "$reader_script" "$json_path" "$key_path"
}


read_event_value_or_empty() {
  local json_path=${1-}
  local key_path=${2-}

  read_event_value "$json_path" "$key_path" 2>/dev/null || true
}

normalize_ref_name() {
  local candidate_ref=${1-}

  case "$candidate_ref" in
    "${REF_PREFIX_HEADS}"*)
      printf '%s\n' "${candidate_ref#${REF_PREFIX_HEADS}}"
      ;;
    "${REF_PREFIX_TAGS}"*)
      printf '%s\n' "${candidate_ref#${REF_PREFIX_TAGS}}"
      ;;
    *)
      printf '%s\n' "$candidate_ref"
      ;;
  esac
}

is_valid_policy() {
  local policy_name=${1-}
  local allowed_policy

  for allowed_policy in "${ALLOWED_POLICIES[@]}"; do
    if [ "$policy_name" = "$allowed_policy" ]; then
      return 0
    fi
  done

  return 1
}

print_policy_or_fail() {
  local candidate_policy=${1-}

  if ! is_valid_policy "$candidate_policy"; then
    ci_error "Invalid CI policy: ${candidate_policy}"
    exit 1
  fi

  printf '%s\n' "$candidate_policy"
}


resolve_manual_dispatch_policy() {
  case "$event_name" in
    "$EVENT_NAME_WORKFLOW_DISPATCH")
      if [ -n "$manual_policy" ]; then
        print_policy_or_fail "$manual_policy"
        return 0
      fi

      if [ -n "$event_path" ]; then
        manual_policy=$(read_event_value_or_empty "$event_path" "$EVENT_INPUT_POLICY")
        if [ -z "$manual_policy" ]; then
          manual_policy=$(read_event_value_or_empty "$event_path" "$EVENT_INPUT_POLICY_NAME")
        fi
      fi

      if [ -n "$manual_policy" ]; then
        print_policy_or_fail "$manual_policy"
        return 0
      fi
      ;;
  esac

  return 1
}


resolve_branch_policy() {
  local candidate_ref=${1-}

  case "$candidate_ref" in
    "$BRANCH_MAIN"|"$BRANCH_FEATURE_DOCKER")
      printf '%s\n' "$POLICY_MAIN"
      ;;
    "$BRANCH_DEV"|"$BRANCH_NEW_DEV")
      printf '%s\n' "$POLICY_DEV"
      ;;
    "$BRANCH_FEATURE"|"${BRANCH_FEATURE_PREFIX}"*)
      printf '%s\n' "$POLICY_FEATURE"
      ;;
    *)
      printf '%s\n' "$POLICY_MAIN"
      ;;
  esac
}


resolve_tag_policy() {
  local candidate_ref=${1-}

  case "$candidate_ref" in
    "${RELEASE_TAG_PREFIX}"*)
      printf '%s\n' "$POLICY_PRODUCTION_RELEASE"
      ;;
    "${CI_MAIN_TEST_TAG_PREFIX}"*)
      printf '%s\n' "$POLICY_MAIN_TEST"
      ;;
    "${CI_DEV_TEST_TAG_PREFIX}"*)
      printf '%s\n' "$POLICY_DEV_TEST"
      ;;
    "${CI_FEATURE_TEST_TAG_PREFIX}"*)
      printf '%s\n' "$POLICY_FEATURE_TEST"
      ;;
    *)
      return 1
      ;;
  esac
}

resolve_push_policy() {
  case "$ref_type" in
    "$REF_TYPE_TAG")
      if ! resolve_tag_policy "$ref_name"; then
        printf '%s\n' "$POLICY_MAIN"
      fi
      ;;
    *)
      resolve_branch_policy "$ref_name"
      ;;
  esac
}

resolve_release_candidate_policy() {
  local target_ref=${1-}

  case "$event_name" in
    "$EVENT_NAME_PULL_REQUEST"|"$EVENT_NAME_PULL_REQUEST_TARGET")
      ;;
    *)
      return 1
      ;;
  esac

  if [ -z "$target_ref" ] && [ -n "$event_path" ]; then
    target_ref=$(read_event_value_or_empty "$event_path" "$EVENT_PULL_REQUEST_BASE_REF")
  fi

  target_ref=$(normalize_ref_name "$target_ref")
  case "$target_ref" in
    "$BRANCH_MAIN")
      ;;
    *)
      return 1
      ;;
  esac

  if [ -z "$event_path" ] || [ ! -f "$event_path" ]; then
    return 1
  fi

  if "${PULL_REQUEST_LABEL_CHECK_SCRIPT}" "$event_path" "$PULL_REQUEST_LABEL_RELEASE_CANDIDATE"; then
    printf '%s\n' "$POLICY_RELEASE_CANDIDATE"
    return 0
  fi

  return 1
}

resolve_pull_request_policy() {
  local target_ref=${1-}

  if resolve_release_candidate_policy "$target_ref"; then
    return 0
  fi

  resolve_branch_policy "$target_ref"
}

resolve_policy_from_fallback() {
  case "$ref_type" in
    "$REF_TYPE_TAG")
      if ! resolve_tag_policy "$ref_name"; then
        printf '%s\n' "$POLICY_MAIN"
      fi
      ;;
    *)
      resolve_branch_policy "$ref_name"
      ;;
  esac
}


resolve_policy() {
  local candidate_policy=''

  if candidate_policy=$(resolve_manual_dispatch_policy); then
    printf '%s\n' "$candidate_policy"
    return 0
  fi

  case "$event_name" in
    "$EVENT_NAME_PUSH")
      candidate_policy=$(resolve_push_policy)
      ;;

    "$EVENT_NAME_PULL_REQUEST"|"$EVENT_NAME_PULL_REQUEST_TARGET")
      candidate_policy=$(resolve_pull_request_policy "$base_ref")
      ;;

    "$EVENT_NAME_WORKFLOW_DISPATCH")
      candidate_policy=$(resolve_branch_policy "$base_ref")
      ;;

    *)
      candidate_policy=$(resolve_policy_from_fallback)
      ;;
  esac

  print_policy_or_fail "$candidate_policy"
}


policy=$(resolve_policy)


if [ -n "${GITHUB_OUTPUT:-}" ]; then
  printf 'policy=%s\n' "$policy" >> "$GITHUB_OUTPUT"
fi

ci_log "Resolved CI policy: ${policy}"
printf '%s\n' "$policy"
