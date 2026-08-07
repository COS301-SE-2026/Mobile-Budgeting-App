#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "${script_dir}/ci-common.sh"

readonly DEFAULT_STAGE_ROOT='artifacts/test-reports'
readonly DEFAULT_TEST_SCOPE='unit'
readonly DEFAULT_TEST_CONCURRENCY='3'
readonly FLUTTER_APP_ROOT='Flutter/budgetit'
readonly UNIT_TEST_EXCLUSIONS=(
  '-not' '-path' 'test/golden/*'
  '-not' '-path' 'test/performance/*'
  '-not' '-path' 'test/integration/*'
)
readonly SUPPORTED_TEST_SCOPES=(
  'unit'
  'integration'
  'golden'
  'performance'
)

stage_root_relative=${DEFAULT_STAGE_ROOT}
test_scope=${DEFAULT_TEST_SCOPE}
test_concurrency=${DEFAULT_TEST_CONCURRENCY}

usage() {
  cat <<'EOF'
Usage: run-flutter-tests.sh [--scope unit|integration|golden|performance] [--concurrency N] [--stage-root RELATIVE_PATH]

Runs the Flutter tests from within the Flutter/budgetit directory and stores both raw and diagnostic logs in a staging directory.
EOF
}

is_supported_scope() {
  local candidate_scope=${1-}

  local supported_scope
  for supported_scope in "${SUPPORTED_TEST_SCOPES[@]}"; do
    if [ "$candidate_scope" = "$supported_scope" ]; then
      return 0
    fi
  done

  return 1
}

collect_unit_test_targets() {
  local app_dir=${1-}
  local -a unit_test_targets=()

  if [ -z "$app_dir" ]; then
    ci_error 'collect_unit_test_targets requires an app directory'
    return 1
  fi

  mapfile -t unit_test_targets < <(
    cd "$app_dir" &&
      find test \
        \( -type d \( -name .dart_tool -o -name build -o -name coverage \) -prune \) -o \
        \( -type f -name '*_test.dart' "${UNIT_TEST_EXCLUSIONS[@]}" -print \) |
      LC_ALL=C sort
  )

  printf '%s\n' "${unit_test_targets[@]}"
}

run_scope_command() {
  local scope=${1-}
  local report_dir=${2-}
  local app_dir=${3-}
  local raw_log_path="${report_dir}/raw.log"
  local diagnostic_log_path="${report_dir}/diagnostic.log"
  local -a flutter_command=()
  local -a test_targets=()

  case "$scope" in
    unit)
      mapfile -t test_targets < <(collect_unit_test_targets "$app_dir")
      flutter_command=(flutter test --machine --coverage --concurrency="${test_concurrency}")
      if [ "${#test_targets[@]}" -gt 0 ]; then
        flutter_command+=("${test_targets[@]}")
      fi
      ;;
    integration)
      flutter_command=(flutter test --machine --concurrency="${test_concurrency}" test/integration/)
      ;;
    golden)
      flutter_command=(flutter test --machine --concurrency="${test_concurrency}" test/golden)
      ;;
    performance)
      flutter_command=(flutter test --machine --concurrency="${test_concurrency}" test/performance)
      ;;
    *)
      ci_error "Test scope: ${scope} not supported"
      return 1
      ;;
  esac

  mkdir -p "$report_dir"
  : >"$raw_log_path"
  : >"$diagnostic_log_path"

  ci_log "Running Flutter ${scope} tests"
  ci_log "Writing raw output to ${raw_log_path}"
  ci_log "Writing diagnostic output to ${diagnostic_log_path}"

  set +e
  (
    cd "$app_dir"
    "${flutter_command[@]}" >"$raw_log_path" 2>"$diagnostic_log_path"
  )
  test_exit_code=$?
  set -e

  return "$test_exit_code"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --scope)
      shift
      test_scope=${1:-}
      ;;
    --stage-root)
      shift
      stage_root_relative=${1:-}
      ;;
    --concurrency)
      shift
      test_concurrency=${1:-}
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

if ! is_supported_scope "$test_scope"; then
  ci_error "Unsupported test scope: ${test_scope}"
  exit 1
fi

if ! [[ "$test_concurrency" =~ ^[0-9]+$ ]] || [ "$test_concurrency" -lt 1 ]; then
  ci_error "Concurrency must be a positive integer: ${test_concurrency}"
  exit 1
fi

ci_require_cmd find sort flutter mkdir

app_dir=$(ci_repo_path "$FLUTTER_APP_ROOT")
report_root=$(ci_repo_path "$stage_root_relative")
report_dir="${report_root}/${test_scope}"

run_scope_command "$test_scope" "$report_dir" "$app_dir"
