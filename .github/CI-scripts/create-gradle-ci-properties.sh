#!/usr/bin/env bash
set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

source "${script_dir}/ci-common.sh"

readonly CI_GRADLE_PROPERTY_JVMARGS='org.gradle.jvmargs=-Xmx3g -XX:MaxMetaspaceSize=768m -Dfile.encoding=UTF-8'
readonly CI_GRADLE_PROPERTY_WORKERS_MAX='org.gradle.workers.max=3'
readonly CI_GRADLE_PROPERTY_PARALLEL='org.gradle.parallel=true'
readonly CI_GRADLE_PROPERTY_CACHING='org.gradle.caching=true'
readonly CI_GRADLE_PROPERTY_CONFIGURATION_CACHE='org.gradle.configuration-cache=true'
readonly CI_GRADLE_PROPERTY_KOTLIN_DAEMON_JVMARGS='kotlin.daemon.jvmargs=-Xmx1536m -XX:MaxMetaspaceSize=384m'

readonly CI_GRADLE_PROPERTIES="${CI_GRADLE_PROPERTY_JVMARGS}
${CI_GRADLE_PROPERTY_WORKERS_MAX}
${CI_GRADLE_PROPERTY_PARALLEL}
${CI_GRADLE_PROPERTY_CACHING}
${CI_GRADLE_PROPERTY_CONFIGURATION_CACHE}
${CI_GRADLE_PROPERTY_KOTLIN_DAEMON_JVMARGS}"

readonly GRADLE_PROPERTIES_FILE_NAME='gradle.properties'
readonly GRADLE_PROPERTIES_BACKUP_PREFIX='gradle.properties.ci-backup'
readonly GRADLE_PROPERTIES_STATE_PREFIX='gradle.properties.ci-state'

mode=${1:-apply}
gradle_home=${GRADLE_USER_HOME:-${HOME}/.gradle}
properties_file="${gradle_home}/${GRADLE_PROPERTIES_FILE_NAME}"
backup_suffix="${GITHUB_RUN_ID:-manual}-${GITHUB_RUN_ATTEMPT:-1}"
backup_file="${gradle_home}/${GRADLE_PROPERTIES_BACKUP_PREFIX}-${backup_suffix}"
state_file="${gradle_home}/${GRADLE_PROPERTIES_STATE_PREFIX}-${backup_suffix}"

apply_ci_properties() {
  mkdir -p "$gradle_home"

  if [ -f "$properties_file" ]; then
    cp "$properties_file" "$backup_file"
  fi

  printf '%s\n' "$CI_GRADLE_PROPERTIES" > "$properties_file"
  : > "$state_file"
  ci_log "Applied CI Gradle properties to ${properties_file}"
}

restore_ci_properties() {
  if [ ! -f "$state_file" ]; then
    ci_log "No CI Gradle properties were applied for this run"
    return 0
  fi

  if [ -f "$backup_file" ]; then
    mv "$backup_file" "$properties_file"
    ci_log "Restored previous Gradle properties from ${backup_file}"
  else
    rm -f "$properties_file"
    ci_log "Removed CI Gradle properties from ${properties_file}"
  fi

  rm -f "$state_file"
}

case "$mode" in
  apply)
    apply_ci_properties
    ;;
  restore)
    restore_ci_properties
    ;;
  *)
    ci_error "Unknown mode: ${mode}"
    exit 1
    ;;
esac
