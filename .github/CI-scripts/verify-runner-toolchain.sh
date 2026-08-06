#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "${script_dir}/ci-common.sh"

readonly EXPECTED_FLUTTER_VERSION='3.41.9'
readonly EXPECTED_JAVA_MAJOR_VERSION='17'
readonly EXPECTED_AGP_VERSION='8.11.1'
readonly EXPECTED_KOTLIN_VERSION='2.1.0'
readonly EXPECTED_GRADLE_VERSION='8.14'
readonly EXPECTED_FLUTTER_COMPILE_SDK='36'
readonly EXPECTED_FLUTTER_NDK_VERSION='28.2.13676358'

readonly FLUTTER_VERSION_JSON_REGEX='.*"frameworkVersion"[[:space:]]*:[[:space:]]*"\([^"]*\)".*'
readonly FLUTTER_VERSION_TEXT_REGEX='^Flutter \([0-9][0-9.]*\).*$'
readonly JAVA_VERSION_REGEX='^.*version "\([0-9][0-9._-]*\)".*$'
readonly FLUTTER_COMPILE_SDK_REGEX='^.*val compileSdkVersion: Int = \([0-9][0-9]*\).*$'
readonly FLUTTER_NDK_VERSION_REGEX='^.*val ndkVersion: String = "\([^"]*\)".*$'
readonly AGP_VERSION_REGEX='^.*com.android.application") version "\([^"]*\)" apply false.*$'
readonly KOTLIN_VERSION_REGEX='^.*org.jetbrains.kotlin.android") version "\([^"]*\)" apply false.*$'
readonly GRADLE_VERSION_REGEX='^Gradle \([0-9][0-9.]*\).*$'


readonly PROJECT_COMPILE_SDK_WIRING='compileSdk = flutter.compileSdkVersion'
readonly PROJECT_NDK_WIRING='ndkVersion = flutter.ndkVersion'

readonly ANDROID_SDK_PLATFORM_PREFIX='platforms/android-'
readonly ANDROID_NDK_PREFIX='ndk/'

show_diagnostics=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --diagnostic|--diagnostics)
      show_diagnostics=true
      ;;
    -h|--help)
      cat <<'EOF'
Usage: verify-runner-toolchain.sh [--diagnostic]

Validates the pre-provisioned Flutter / Android / Gradle runner toolchain.
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

failures=()
report_lines=()

print_section() {
  printf '\n' >&2
  ci_log "$1"
}

report_value() {
  report_lines+=("$1: $2")
}

record_failure() {
  failures+=("$1")
}

report_missing_command() {
  local command_name=$1

  report_value "$command_name" 'missing'
  record_failure "Required command is missing: $command_name"
}

validate_required_commands() {
  print_section 'Tool availability'

  if ci_require_cmd flutter java gradle grep sed awk; then
    report_value 'flutter' 'available'
    report_value 'java' 'available'
    report_value 'gradle' 'available'
    report_value 'grep' 'available'
    report_value 'sed' 'available'
    report_value 'awk' 'available'
    return 0
  fi

  for command_name in flutter java gradle grep sed awk; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
      report_missing_command "$command_name"
    fi
  done
}

validate_flutter_version() {
  print_section 'Flutter version'

  local flutter_version_output
  local flutter_version

  flutter_version_output=$(flutter --version --machine 2>&1 || true)
  flutter_version=$(printf '%s\n' "$flutter_version_output" | ci_first_match_in_text "$FLUTTER_VERSION_JSON_REGEX")

  if [ -z "$flutter_version" ]; then
    flutter_version=$(printf '%s\n' "$flutter_version_output" | ci_first_match_in_text "$FLUTTER_VERSION_TEXT_REGEX")
  fi

  report_value 'Flutter version' "${flutter_version:-unknown}"

  if [ -z "$flutter_version" ]; then
    record_failure 'Unable to determine Flutter version'
  elif [ "$flutter_version" != "$EXPECTED_FLUTTER_VERSION" ]; then
    record_failure "Flutter version expected ${EXPECTED_FLUTTER_VERSION} but found version ${flutter_version} instead"
  fi
}

validate_java_version() {
  print_section 'Java version'

  local java_version_output
  local java_version
  local java_major_version

  java_version_output=$(java -version 2>&1 || true)
  java_version=$(printf '%s\n' "$java_version_output" | ci_first_match_in_text "$JAVA_VERSION_REGEX")
  java_major_version=''

  if [ -n "$java_version" ]; then
    case "$java_version" in
      1.*)
        java_major_version=$(printf '%s' "$java_version" | cut -d. -f2)
        ;;
      *)
        java_major_version=$(printf '%s' "$java_version" | cut -d. -f1)
        ;;
    esac
  fi

  report_value 'Java version' "${java_version:-unknown}"
  report_value 'JAVA_HOME' "${JAVA_HOME:-unknown}"

  if [ -z "$java_major_version" ]; then
    record_failure 'Unable to determine Java version'
  elif [ "$java_major_version" != "$EXPECTED_JAVA_MAJOR_VERSION" ]; then
    record_failure "Java major version expected ${EXPECTED_JAVA_MAJOR_VERSION} but found version ${java_major_version} instead"
  fi
}

validate_android_sdk() {
  print_section 'Android SDK and NDK'

  local android_sdk_root
  local compile_sdk_platform_dir
  local ndk_dir

  android_sdk_root=${ANDROID_SDK_ROOT:-${ANDROID_HOME:-}}

  if [ -z "$android_sdk_root" ]; then
    report_value 'Android SDK root' 'missing'
    record_failure 'ANDROID_SDK_ROOT or ANDROID_HOME must be set'
    return 0
  fi

  report_value 'Android SDK root' "$android_sdk_root"
  if [ ! -d "$android_sdk_root" ]; then
    record_failure "Android SDK root does not exist: $android_sdk_root"
    return 0
  fi

  compile_sdk_platform_dir="${android_sdk_root}/${ANDROID_SDK_PLATFORM_PREFIX}${EXPECTED_FLUTTER_COMPILE_SDK}"
  if [ -d "$compile_sdk_platform_dir" ]; then
    report_value 'Android compile SDK platform' "$compile_sdk_platform_dir"
  else
    report_value 'Android compile SDK platform' "missing: $compile_sdk_platform_dir"
    record_failure "Android compile SDK platform is not installed: android-${EXPECTED_FLUTTER_COMPILE_SDK}"
  fi

  ndk_dir="${android_sdk_root}/${ANDROID_NDK_PREFIX}${EXPECTED_FLUTTER_NDK_VERSION}"
  if [ -d "$ndk_dir" ]; then
    report_value 'Android NDK' "$ndk_dir"
  else
    report_value 'Android NDK' "missing: $ndk_dir"
    record_failure "Android NDK is not installed: ${EXPECTED_FLUTTER_NDK_VERSION}"
  fi
}

validate_flutter_gradle_contract() {
  print_section 'Flutter Gradle contract'

  local flutter_extension_file
  local flutter_compile_sdk
  local flutter_ndk_version
  local android_settings_file
  local android_app_file
  local project_agp_version
  local project_kotlin_version

  flutter_extension_file="$(cd -- "$(dirname -- "$(command -v flutter)")/.." && pwd)/packages/flutter_tools/gradle/src/main/kotlin/FlutterExtension.kt"
  flutter_compile_sdk=''
  flutter_ndk_version=''

  if [ -f "$flutter_extension_file" ]; then
    flutter_compile_sdk=$(ci_first_match "$FLUTTER_COMPILE_SDK_REGEX" "$flutter_extension_file")
    flutter_ndk_version=$(ci_first_match "$FLUTTER_NDK_VERSION_REGEX" "$flutter_extension_file")
  fi

  report_value 'Flutter compile SDK' "${flutter_compile_sdk:-unknown}"
  report_value 'Flutter NDK version' "${flutter_ndk_version:-unknown}"

  if [ -z "$flutter_compile_sdk" ]; then
    record_failure 'Unable to determine Flutter compile SDK version'
  elif [ "$flutter_compile_sdk" != "$EXPECTED_FLUTTER_COMPILE_SDK" ]; then
    record_failure "Flutter compile SDK expected ${EXPECTED_FLUTTER_COMPILE_SDK} but found ${flutter_compile_sdk}"
  fi

  if [ -z "$flutter_ndk_version" ]; then
    record_failure 'Unable to determine Flutter NDK version'
  elif [ "$flutter_ndk_version" != "$EXPECTED_FLUTTER_NDK_VERSION" ]; then
    record_failure "Flutter NDK version expected ${EXPECTED_FLUTTER_NDK_VERSION} but found ${flutter_ndk_version}"
  fi

  android_settings_file=$(ci_repo_path 'Flutter/budgetit/android/settings.gradle.kts')
  android_app_file=$(ci_repo_path 'Flutter/budgetit/android/app/build.gradle.kts')

  project_agp_version=''
  project_kotlin_version=''
  if [ -f "$android_settings_file" ]; then
    project_agp_version=$(ci_first_match "$AGP_VERSION_REGEX" "$android_settings_file")
    project_kotlin_version=$(ci_first_match "$KOTLIN_VERSION_REGEX" "$android_settings_file")
  fi

  report_value 'Project AGP version' "${project_agp_version:-unknown}"
  report_value 'Project Kotlin version' "${project_kotlin_version:-unknown}"

  if [ -z "$project_agp_version" ]; then
    record_failure 'Unable to determine Android Gradle Plugin version from settings.gradle.kts'
  elif [ "$project_agp_version" != "$EXPECTED_AGP_VERSION" ]; then
    record_failure "Android Gradle Plugin expected ${EXPECTED_AGP_VERSION} but found ${project_agp_version}"
  fi

  if [ -z "$project_kotlin_version" ]; then
    record_failure 'Unable to determine Kotlin plugin version from settings.gradle.kts'
  elif [ "$project_kotlin_version" != "$EXPECTED_KOTLIN_VERSION" ]; then
    record_failure "Kotlin plugin expected ${EXPECTED_KOTLIN_VERSION} but found version ${project_kotlin_version} instead"
  fi

  if [ -f "$android_app_file" ]; then
    if grep -q "$PROJECT_COMPILE_SDK_WIRING" "$android_app_file"; then
      report_value 'Project compile SDK wiring' 'delegates to flutter.compileSdkVersion'
    else
      report_value 'Project compile SDK wiring' 'unexpected'
      record_failure 'Android app build file does not delegate compileSdk to flutter.compileSdkVersion'
    fi

    if grep -q "$PROJECT_NDK_WIRING" "$android_app_file"; then
      report_value 'Project NDK wiring' 'delegates to flutter.ndkVersion'
    else
      report_value 'Project NDK wiring' 'unexpected'
      record_failure 'Android app build file does not delegate ndkVersion to flutter.ndkVersion'
    fi
  fi
}

validate_gradle_version() {
  print_section 'Gradle version'

  local gradle_version_output
  local gradle_version

  gradle_version_output=$(gradle -v 2>&1 || true)
  gradle_version=$(printf '%s\n' "$gradle_version_output" | ci_first_match_in_text "$GRADLE_VERSION_REGEX")

  report_value 'Gradle version' "${gradle_version:-unknown}"

  if [ -z "$gradle_version" ]; then
    record_failure 'Unable to determine Gradle version'
  elif [ "$gradle_version" != "$EXPECTED_GRADLE_VERSION" ]; then
    record_failure "Gradle version expected ${EXPECTED_GRADLE_VERSION} but found ${gradle_version}"
  fi
}

validate_required_commands
validate_flutter_version
validate_java_version
validate_android_sdk
validate_flutter_gradle_contract
validate_gradle_version

if [ "$show_diagnostics" = true ] || [ "${#failures[@]}" -ne 0 ]; then
  printf '\n' >&2
  ci_log 'Runner toolchain diagnostics'
  for line in "${report_lines[@]}"; do
    printf ' - %s\n' "$line"
  done
fi

if [ "${#failures[@]}" -ne 0 ]; then
  for failure in "${failures[@]}"; do
    ci_error "$failure"
  done
  exit 1
fi

ci_log 'Runner toolchain verification passed'
