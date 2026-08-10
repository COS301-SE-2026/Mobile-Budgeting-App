#!/usr/bin/env bash
set -Eeuo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "${script_dir}/ci-common.sh"

readonly FLUTTER_VERSION='3.41.9'
readonly JAVA_MAJOR='17'
readonly GRADLE_VERSION='8.14'
readonly COMPILE_SDK='36'
readonly NDK_VERSION='28.2.13676358'

readonly FLUTTER_VERSION_RE='.*"frameworkVersion"[[:space:]]*:[[:space:]]*"\([^"]*\)".*'
readonly JAVA_VERSION_RE='^.*version "\([0-9][0-9._-]*\)".*$'
readonly GRADLE_VERSION_RE='^Gradle \([0-9][0-9.]*\).*$'

show_diagnostics=false
errors=()

usage() {
  cat <<'EOF'
Usage: verify-runner-toolchain.sh [--diagnostic]

Checks the Flutter and Android tools needed to build the APK.
The script only checks the runner. It does not install anything.
EOF
}

parse_args() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
      --diagnostic|--diagnostics)
        show_diagnostics=true
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        fail "Unknown option: $1"
        ;;
    esac
    shift
  done
}

section() {
  printf '\n%s\n' "$1"
}

add_error() {
  errors+=("$1")
  printf 'Error: %s\n' "$1" >&2
}

check_version() {
  local name=$1
  local actual=$2
  local expected=$3

  printf '%s: %s\n' "$name" "${actual:-unknown}"

  if [ -z "$actual" ]; then
    add_error "Could not read the ${name} version."
  elif [ "$actual" != "$expected" ]; then
    add_error "Expected ${name} ${expected}, found ${actual}."
  fi
}

check_directory() {
  local name=$1
  local path=$2

  if [ -d "$path" ]; then
    printf '%s: %s\n' "$name" "$path"
  else
    add_error "Missing ${name}: ${path}"
  fi
}

check_file() {
  local name=$1
  shift

  local path
  for path in "$@"; do
    if [ -f "$path" ]; then
      printf '%s: %s\n' "$name" "$path"
      return 0
    fi
  done

  add_error "Missing ${name}."
}

check_commands() {
  section 'Tools'
  ci_require_cmd flutter dart java gradle sed || exit 1

  if [ "$show_diagnostics" = true ]; then
    local command_name
    for command_name in flutter dart java gradle; do
      printf '%s: %s\n' "$command_name" "$(command -v "$command_name")"
    done
  fi
}

check_flutter() {
  local output=''
  local version=''

  if output=$(flutter --version --machine 2>&1); then
    version=$(printf '%s\n' "$output" | ci_first_match_in_text "$FLUTTER_VERSION_RE")
  fi

  check_version 'Flutter' "$version" "$FLUTTER_VERSION"
}

check_dart() {
  local output=''

  if output=$(dart --version 2>&1); then
    printf 'Dart: %s\n' "$output"
  else
    add_error 'Could not run dart --version.'
  fi
}

check_java() {
  local output=''
  local version=''
  local major=''

  if output=$(java -version 2>&1); then
    version=$(printf '%s\n' "$output" | ci_first_match_in_text "$JAVA_VERSION_RE")
  fi

  if [ -n "$version" ]; then
    if [[ "$version" == 1.* ]]; then
      major=${version#1.}
    else
      major=$version
    fi
    major=${major%%.*}
  fi

  check_version 'Java' "$major" "$JAVA_MAJOR"

  if [ "$show_diagnostics" = true ]; then
    printf 'Java details: %s\n' "${version:-unknown}"
    printf 'JAVA_HOME: %s\n' "${JAVA_HOME:-unset}"
  fi
}

check_gradle() {
  local output=''
  local version=''

  if output=$(gradle -v 2>&1); then
    version=$(printf '%s\n' "$output" | ci_first_match_in_text "$GRADLE_VERSION_RE")
  fi

  check_version 'Gradle' "$version" "$GRADLE_VERSION"
}

check_android_sdk() {
  section 'Android SDK'

  local sdk_root=${ANDROID_SDK_ROOT:-${ANDROID_HOME:-}}
  if [ -z "$sdk_root" ]; then
    add_error 'ANDROID_SDK_ROOT or ANDROID_HOME is not set.'
    return
  fi

  check_directory 'SDK root' "$sdk_root"
  check_directory "Android SDK ${COMPILE_SDK}" "${sdk_root}/platforms/android-${COMPILE_SDK}"
  check_directory "Android NDK ${NDK_VERSION}" "${sdk_root}/ndk/${NDK_VERSION}"
}

check_android_project() {
  section 'Android project'

  local repo_root
  local android_dir
  repo_root=$(cd -- "${script_dir}/../.." && pwd)
  android_dir="${repo_root}/Flutter/budgetit/android"

  check_file 'settings Gradle file' \
    "${android_dir}/settings.gradle.kts" \
    "${android_dir}/settings.gradle"

  check_file 'app Gradle file' \
    "${android_dir}/app/build.gradle.kts" \
    "${android_dir}/app/build.gradle"

  check_file 'root Gradle file' \
    "${android_dir}/build.gradle.kts" \
    "${android_dir}/build.gradle"

  check_file 'Gradle properties' "${android_dir}/gradle.properties"
}

main() {
  parse_args "$@"

  check_commands

  section 'Versions'
  check_flutter
  check_dart
  check_java
  check_gradle

  check_android_sdk
  check_android_project

  if [ "${#errors[@]}" -gt 0 ]; then
    printf '\n%d check(s) failed.\n' "${#errors[@]}" >&2
    exit 1
  fi

  printf '\nRunner checks passed.\n'
}

main "$@"
