#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "${script_dir}/ci-common.sh"

readonly DEFAULT_SOURCE_ROOT='Flutter/budgetit'
readonly DEFAULT_STAGE_ROOT='artifacts/generated-dart'
readonly GENERATED_DART_MANIFEST_FILE='generated-dart.manifest'

source_root_relative=${DEFAULT_SOURCE_ROOT}
stage_root_relative=${DEFAULT_STAGE_ROOT}
expect_generated=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --source-root)
      shift
      source_root_relative=${1:-}
      ;;
    --stage-root)
      shift
      stage_root_relative=${1:-}
      ;;
    --expect-generated)
      expect_generated=true
      ;;
    -h|--help)
      cat <<'EOF'
Usage: collect-generated-dart.sh [--source-root RELATIVE_PATH] [--stage-root RELATIVE_PATH] [--expect-generated]

Collects codegen files into a staging directory and writes a manifest.
EOF
      exit 0
      ;;
    *)
      ci_error "Unknown argument: $1"
      exit 1
      ;;
  esac
  shift
done

source_root=$(ci_repo_path "$source_root_relative")
stage_root=$(ci_repo_path "$stage_root_relative")
manifest_path="${stage_root}/${GENERATED_DART_MANIFEST_FILE}"
ci_require_cmd find sort cp mkdir sha256sum

collectable_files=()
mapfile -t collectable_files < <(
  find "$source_root" \
    \( -type d \( -name .dart_tool -o -name build -o -name coverage \) -prune \) -o \
    \( -type f \( -name '*.g.dart' -o -name '*.freezed.dart' \) -print \) | LC_ALL=C sort
)

if [ "$expect_generated" = true ] && [ "${#collectable_files[@]}" -eq 0 ]; then
  ci_error "Codegen was expected to produce  files under ${source_root}, but none were found"
  exit 1
fi

rm -rf "$stage_root"
mkdir -p "$stage_root"
: > "$manifest_path"

for source_file in "${collectable_files[@]}"; do
  relative_path=${source_file#"${source_root}/"}
  destination_path="${stage_root}/${relative_path}"
  destination_dir=${destination_path%/*}
  file_checksum=''

  mkdir -p "$destination_dir"
  cp "$source_file" "$destination_path"
  file_checksum=$(sha256sum "$destination_path")
  file_checksum=${file_checksum%% *}
  printf '%s\t%s\n' "$file_checksum" "$relative_path" >> "$manifest_path"
done

if [ "${#collectable_files[@]}" -eq 0 ]; then
  ci_log "No codegen files were found under ${source_root}"
else
  ci_log "Collected ${#collectable_files[@]} codegen file(s) into ${stage_root}"
fi
