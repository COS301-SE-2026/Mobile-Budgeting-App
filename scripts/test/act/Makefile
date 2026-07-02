REPO_ROOT := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/../../..)
WORKFLOW ?= $(REPO_ROOT)/.github/workflows/ci-main.yml
ACT_EVENT_FILE := /tmp/github-event.json
ACT := /home/donovan/act/act
VERBOSE ?= false
BRANCH ?= main

ARTIFACTS_DIR := $(CURDIR)/act/artifacts
CACHE_DIR := $(CURDIR)/act/cache

GITHUB_TOKEN := $(shell gh auth token)

ACT_FLAGS = --artifact-server-path=$(ARTIFACTS_DIR) --cache-server-path=$(CACHE_DIR) --directory=$(REPO_ROOT) $(if $(filter true,$(VERBOSE)),--verbose,) -P self-hosted=catthehacker/ubuntu:act-latest -P ubuntu-slim=catthehacker/ubuntu:act-latest -p=false

SECRET_SCAN_FLAGS := --env GITLEAKS_ENABLE_UPLOAD_ARTIFACT=false

ME = $(shell whoami)

setup-event:
	@echo "Creating GH event payload ..."
	@mkdir -p /tmp
	@mkdir -p $(ARTIFACTS_DIR)
	@mkdir -p $(CACHE_DIR)
	@printf '{\n  "repository": {\n    "owner": {\n      "login": "$(ME)"\n    },\n    "name": "Mobile-Budgeting-App"\n  },\n  "ref": "refs/heads/$(BRANCH)",\n  "sha": "HEAD",\n  "commits": [\n    {\n      "id": "HEAD",\n      "timestamp": "2026-06-03T11:00:00Z"\n    }\n  ]\n}\n' > $(ACT_EVENT_FILE)
	@echo "Event payload created"
	@echo "Artifact Directory : $(ARTIFACTS_DIR)"
	@echo "Cache Directory : $(CACHE_DIR)"

list-jobs:
	$(ACT) -l -W $(WORKFLOW)

# --- per-job targets for ci-main.yml ---
secret-scan: setup-event
	$(ACT) -j secret-scan -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

prepare: setup-event
	$(ACT) -j prepare -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

dart-format: setup-event
	$(ACT) -j dart-format -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

flutter-analyze: setup-event
	$(ACT) -j flutter-analyze -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

unit-tests: setup-event
	$(ACT) -j unit-tests -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

coverage-gate: setup-event
	$(ACT) -j coverage-gate -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

sonarcloud: setup-event
	$(ACT) -j sonarcloud -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

dependency-audit: setup-event
	$(ACT) -j dependency-audit -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

golden-tests: setup-event
	$(ACT) -j golden-tests -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

perf-benchmarks: setup-event
	$(ACT) -j perf-benchmarks -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

integration-tests: setup-event
	$(ACT) -j integration-tests -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

apk-build: setup-event
	$(ACT) -j apk-build -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

update-badges: setup-event
	$(ACT) -j update-badges -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

# --- whole-workflow targets ---
ci-main: WORKFLOW := $(REPO_ROOT)/.github/workflows/ci-main.yml
ci-main: BRANCH := main
ci-main: setup-event
	$(ACT) -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

ci-dev: WORKFLOW := $(REPO_ROOT)/.github/workflows/ci-dev.yml
ci-dev: BRANCH := dev
ci-dev: setup-event
	$(ACT) -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

ci-feature: WORKFLOW := $(REPO_ROOT)/.github/workflows/ci-feature.yml
ci-feature: BRANCH := feature/feature-name
ci-feature: setup-event
	$(ACT) -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

# --- convenience: a few common subsets ---
lint: dart-format flutter-analyze
test: unit-tests
verify: lint test coverage-gate

# --- cleanup ---
clean-artifacts:
	@rm -rf $(ARTIFACTS_DIR)

clean-cache:
	@rm -rf $(CACHE_DIR)

clean: clean-artifacts clean-cache

.PHONY: setup-event list-jobs secret-scan prepare dart-format flutter-analyze \
        unit-tests coverage-gate sonarcloud dependency-audit golden-tests \
        perf-benchmarks integration-tests apk-build update-badges \
        lint test verify \
        clean clean-artifacts clean-cache \
        ci-main ci-dev ci-feature
