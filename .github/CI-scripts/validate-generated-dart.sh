#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "${script_dir}/ci-common.sh"

readonly DEFAULT_ARTIFACT_ROOT='artifacts/generated-dart'
readonly GENERATED_DART_MANIFEST_FILE='generated-dart.manifest'
readonly GENERATED_DART_PREFIX='Flutter/budgetit/'

artifact_root_relative=${DEFAULT_ARTIFACT_ROOT}

usage() {
  cat <<'EOF'
Usage: validate-generated-dart.sh [--artifact-root RELATIVE_PATH]

Validates a generated Dart artifact directory and manifest.
EOF
}

has_approved_generated_suffix() {
  case "$1" in
    *.g.dart|*.freezed.dart|*.mocks.dart)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

validate_generated_dart_relative_path() {
  local relative_path=${1-}

  ci_validate_relative_path "$relative_path"

  case "$relative_path" in
    "${GENERATED_DART_PREFIX}"*)
      ;;
    *)
      ci_error "Generated artifact paths must stay under ${GENERATED_DART_PREFIX}: ${relative_path}"
      return 1
      ;;
  esac

  if ! has_approved_generated_suffix "$relative_path"; then
    ci_error "Generated artifact paths must use an approved extension (.g.dart, .freezed.dart, or .mocks.dart): ${relative_path}"
    return 1
  fi
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --artifact-root)
      shift
      artifact_root_relative=${1:-}
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

artifact_root=$(ci_repo_path "$artifact_root_relative")
artifact_root_prefix="${artifact_root}/"
manifest_path="${artifact_root}/${GENERATED_DART_MANIFEST_FILE}"

ci_require_cmd find sort sha256sum

if [ ! -d "$artifact_root" ]; then
  ci_error "Generated artifact root does not exist: ${artifact_root}"
  exit 1
fi

if [ ! -f "$manifest_path" ]; then
  ci_error "Generated artifact manifest does not exist: ${manifest_path}"
  exit 1
fi

declare -A manifest_checksums=()
declare -A manifest_seen_paths=()
manifest_relative_paths=()

while IFS=$'\t' read -r manifest_checksum manifest_relative_path extra_fields || [ -n "${manifest_checksum}${manifest_relative_path}${extra_fields:-}" ]; do
  if [ -z "$manifest_checksum" ] || [ -z "$manifest_relative_path" ]; then
    ci_error "Malformed  manifest entry in ${manifest_path}"
    exit 1
  fi

  if [ -n "${extra_fields:-}" ]; then
    ci_error "Malformed manifest entry - unexpected extra fields in ${manifest_path}: ${manifest_relative_path}"
    exit 1
  fi

  if [[ ! "$manifest_checksum" =~ ^[0-9a-fA-F]{64}$ ]]; then
    ci_error "Manifest checksum is invalid for ${manifest_relative_path}: ${manifest_checksum}"
    exit 1
  fi

  validate_generated_dart_relative_path "$manifest_relative_path"

  if [ -n "${manifest_seen_paths[$manifest_relative_path]+x}" ]; then
    ci_error "Manifest contains a duplicate entry: ${manifest_relative_path}"
    exit 1
  fi

  manifest_seen_paths["$manifest_relative_path"]=true
  manifest_checksums["$manifest_relative_path"]=$manifest_checksum
  manifest_relative_paths+=("$manifest_relative_path")
done < "$manifest_path"

if [ "${#manifest_relative_paths[@]}" -eq 0 ]; then
  ci_error "Artifact manifest does not list any generated files: ${manifest_path}"
  exit 1
fi

for manifest_relative_path in "${manifest_relative_paths[@]}"; do
  artifact_path="${artifact_root}/${manifest_relative_path}"
  if [ ! -f "$artifact_path" ]; then
    ci_error "Artifact is missing expected file: ${manifest_relative_path}"
    exit 1
  fi

  actual_checksum=$(sha256sum "$artifact_path")
  actual_checksum=${actual_checksum%% *}

  if [ "$actual_checksum" != "${manifest_checksums[$manifest_relative_path]}" ]; then
    ci_error "Artifact checksum mismatch for ${manifest_relative_path}"
    exit 1
  fi
done

mapfile -t artifact_files < <(find "$artifact_root" -type f | LC_ALL=C sort)

for artifact_file in "${artifact_files[@]}"; do
  if [ "$artifact_file" = "$manifest_path" ]; then
    continue
  fi

  case "$artifact_file" in
    "${artifact_root_prefix}"*)
      artifact_relative_path=${artifact_file#"${artifact_root_prefix}"}
      ;;
    *)
      ci_error "Artifact contains a path outside the artifact root: ${artifact_file}"
      exit 1
      ;;
  esac

  validate_generated_dart_relative_path "$artifact_relative_path"

  if [ -z "${manifest_seen_paths[$artifact_relative_path]+x}" ]; then
    ci_error "Artifact contains an unexpected file not listed in the manifest: ${artifact_relative_path}"
    exit 1
  fi
done

ci_log "Validated ${#manifest_relative_paths[@]} generated Dart file(s) in ${artifact_root}"
