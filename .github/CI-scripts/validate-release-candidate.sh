#!/usr/bin/env bash
set -Eeuo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
repo_root=$(cd -- "${script_dir}/../.." && pwd)
source "${script_dir}/ci-common.sh"

release_tag=${1-}
target=${2-}
env_file=${3-}
repo=${GITHUB_REPOSITORY:-}

release_sha=''
main_sha=''
pr_number=''
pr_json=''
candidate_sha=''
candidate_tag=''

usage() {
  cat <<'EOF'
Usage: validate-release-candidate.sh <release-tag> <apk|pages> <env-file>

Checks that a release tag has a matching APK or Pages candidate.
EOF
}

section() {
  printf '\n%s\n' "$1"
}

json_value() {
  local json=$1
  local filter=$2
  jq -r "$filter" <<<"$json"
}

check_args() {
  if [ "$release_tag" = '-h' ] || [ "$release_tag" = '--help' ]; then
    usage
    exit 0
  fi

  if [ -z "$release_tag" ] || [ -z "$target" ] || [ -z "$env_file" ]; then
    usage >&2
    exit 1
  fi

  case "$target" in
    apk|pages)
      ;;
    *)
      fail "Unknown target: $target"
      ;;
  esac

  if [ -z "$repo" ]; then
    fail 'GITHUB_REPOSITORY is not set.'
  fi

  ci_require_cmd git gh jq grep || exit 1
}

check_tag() {
  case "$target" in
    apk)
      if [[ ! "$release_tag" =~ ^release-[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        fail "Expected an APK tag like release-1.2.3, got: $release_tag"
      fi
      ;;
    pages)
      if [[ ! "$release_tag" =~ ^release-landing-[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        fail "Expected a Pages tag like release-landing-1.2.3, got: $release_tag"
      fi
      ;;
  esac
}

check_release_commit() {
  section 'Release'

  release_sha=$(git rev-parse "${release_tag}^{commit}")
  git fetch origin main --no-tags >/dev/null 2>&1
  main_sha=$(git rev-parse 'origin/main^{commit}')

  if ! git merge-base --is-ancestor "$release_sha" "$main_sha"; then
    fail "Release commit is not on main: $release_sha"
  fi

  printf 'Tag: %s\n' "$release_tag"
  printf 'Commit: %s\n' "$release_sha"
}

find_pull_request() {
  section 'Pull request'

  local associated_prs
  associated_prs=$(gh api \
    --header 'Accept: application/vnd.github+json' \
    "repos/${repo}/commits/${release_sha}/pulls")

  pr_number=$(jq -r \
    --arg repo "$repo" \
    --arg release_sha "$release_sha" '
      map(select(
        .base.ref == "main"
        and .base.repo.full_name == $repo
        and .state == "closed"
        and .merged_at != null
        and .merge_commit_sha == $release_sha
      ))
      | sort_by([.merged_at, .number])
      | last
      | .number // empty
    ' <<<"$associated_prs")

  if [ -z "$pr_number" ]; then
    fail "No merged main PR found for $release_sha."
  fi

  pr_json=$(gh api \
    --header 'Accept: application/vnd.github+json' \
    "repos/${repo}/pulls/${pr_number}")

  printf 'PR: #%s\n' "$pr_number"
}

check_pull_request() {
  local state
  local merged_at
  local merge_sha
  local head_repo

  state=$(json_value "$pr_json" '.state')
  merged_at=$(json_value "$pr_json" '.merged_at // empty')
  merge_sha=$(json_value "$pr_json" '.merge_commit_sha // empty')
  candidate_sha=$(json_value "$pr_json" '.head.sha')
  head_repo=$(json_value "$pr_json" '.head.repo.full_name // empty')

  if [ "$state" != 'closed' ] || [ -z "$merged_at" ]; then
    fail "PR #${pr_number} is not merged."
  fi

  if [ "$merge_sha" != "$release_sha" ]; then
    fail "PR #${pr_number} did not create release commit ${release_sha}."
  fi

  if [ "$head_repo" != "$repo" ]; then
    fail "PR #${pr_number} is not from this repository."
  fi
}

find_candidate() {
  section 'Candidate'

  case "$target" in
    apk)
      candidate_tag="candidate-apk-${candidate_sha}"
      ;;
    pages)
      candidate_tag="candidate-pages-${candidate_sha}"
      ;;
  esac

  if ! git fetch origin "$candidate_sha" --no-tags >/dev/null 2>&1; then
    fail "Could not fetch candidate commit: $candidate_sha"
  fi

  printf 'Tag: %s\n' "$candidate_tag"
  printf 'Commit: %s\n' "$candidate_sha"
}

check_candidate_release() {
  local release_json
  local target_sha
  local is_prerelease
  local notes

  if ! release_json=$(gh release view "$candidate_tag" \
    --repo "$repo" \
    --json targetCommitish,body,isPrerelease); then
    fail "Candidate release not found: $candidate_tag"
  fi

  target_sha=$(json_value "$release_json" '.targetCommitish')
  is_prerelease=$(json_value "$release_json" '.isPrerelease')
  notes=$(json_value "$release_json" '.body // ""')

  if [ "$is_prerelease" != 'true' ]; then
    fail "Candidate is not a pre-release: $candidate_tag"
  fi

  if [ "$target_sha" != "$candidate_sha" ]; then
    fail "Candidate points to ${target_sha}, not ${candidate_sha}."
  fi

  if ! grep -Fqx "Candidate PR: #${pr_number}" <<<"$notes"; then
    fail "Candidate does not match PR #${pr_number}."
  fi
}

is_documentation() {
  case "$1" in
    *.md|docs/*|*/docs/*|documentation/*|*/documentation/*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

is_ci_input() {
  case "$1" in
    .github/workflows/*|\
    .github/actions/*|\
    .github/CI-scripts/*|\
    .github/gradle/*|\
    .github/ci-path-filters.yml)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

is_apk_input() {
  case "$1" in
    Flutter/budgetit/*)
      return 0
      ;;
  esac

  is_ci_input "$1"
}

is_pages_input() {
  case "$1" in
    Flutter/budgetit/lib/landing_page/*|\
    Flutter/budgetit/lib/shared/widgets/landingpage/*|\
    Flutter/budgetit/lib/utils/app_colour.dart|\
    Flutter/budgetit/lib/utils/fonts/*|\
    Flutter/budgetit/assets/*|\
    Flutter/budgetit/pubspec.yaml|\
    Flutter/budgetit/pubspec.lock|\
    Flutter/budgetit/.fvmrc|\
    Flutter/budgetit/web/*)
      return 0
      ;;
  esac

  is_ci_input "$1"
}

is_target_input() {
  local path=$1

  if is_documentation "$path"; then
    return 1
  fi

  case "$target" in
    apk)
      is_apk_input "$path"
      ;;
    pages)
      is_pages_input "$path"
      ;;
  esac
}

check_candidate_changes() {
  section 'Changes'

  local path
  while IFS= read -r path; do
    [ -z "$path" ] && continue

    if is_target_input "$path"; then
      fail "Candidate is stale. Changed: $path"
    fi
  done < <(git diff --name-only "$candidate_sha" "$release_sha")

  printf 'No stale %s inputs found.\n' "$target"
}

write_outputs() {
  printf 'CANDIDATE_RELEASE_TAG=%s\n' "$candidate_tag" >>"$env_file"
  printf 'CANDIDATE_SOURCE_SHA=%s\n' "$candidate_sha" >>"$env_file"
  printf 'CANDIDATE_PR_NUMBER=%s\n' "$pr_number" >>"$env_file"
}

main() {
  check_args
  cd "$repo_root"

  check_tag
  check_release_commit
  find_pull_request
  check_pull_request
  find_candidate
  check_candidate_release
  check_candidate_changes
  write_outputs

  printf '\nRelease candidate is valid.\n'
}

main
