WORKFLOW := .github/workflows/ci-main.yml
ACT_EVENT_FILE := /tmp/github-event.json

ARTIFACTS_DIR := $(CURDIR)/act/artifacts
CACHE_DIR := $(CURDIR)/act/cache

GITHUB_TOKEN := $(shell gh auth token)

ACT_FLAGS = --artifact-server-path=$(ARTIFACTS_DIR) --cache-server-path=$(CACHE_DIR) --verbose

SECRET_SCAN_FLAGS := --env GITLEAKS_ENABLE_UPLOAD_ARTIFACT=false

ME = $(shell whoami)

setup-event:
	@echo "Creating GH event payload ..."
	@mkdir -p /tmp
	@mkdir -p $(ARTIFACTS_DIR)
	@mkdir -p $(CACHE_DIR)
	@printf '{\n  "repository": {\n    "owner": {\n      "login": "$(ME)"\n    },\n    "name": "Mobile-Budgeting-App"\n  },\n  "ref": "refs/heads/main",\n  "sha": "HEAD",\n  "commits": [\n    {\n      "id": "HEAD",\n      "timestamp": "2026-06-03T11:00:00Z"\n    }\n  ]\n}\n' > $(ACT_EVENT_FILE)
	@echo "Event payload created"
	@echo "Artifact Directory : $(ARTIFACTS_DIR)"
	@echo "Cache Directory : $(CACHE_DIR)"

list-jobs:
	act -l -W $(WORKFLOW)

detect: setup-event
	act -j detect -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

secret-scan: setup-event
	act -j secret-scan -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)


flutter-ci: setup-event
	act -j flutter-ci -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

sonarcloud: setup-event
	act -j sonarcloud -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

dependency-audit: setup-event
	act -j dependency-audit -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

apk-build: setup-event
	act -j apk-build -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

update-badges: setup-event
	act -j update-badges -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

golden-tests: setup-event
	act -j golden-tests -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

perf-benchmarks: setup-event
	act -j perf-benchmarks -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

integration-tests: setup-event
	act -j integration-tests -W $(WORKFLOW) -s GITHUB_TOKEN="$(GITHUB_TOKEN)" --eventpath $(ACT_EVENT_FILE) $(ACT_FLAGS) $(SECRET_SCAN_FLAGS)

clean-artifacts:
	@rm -rf $(ARTIFACTS_DIR)

clean-cache:
	@rm -rf $(CACHE_DIR)

clean : clean-artifacts clean-cache

.PHONY: setup-event list-jobs secret-scan detect flutter-ci sonarcloud \
        dependency-audit apk-build update-badges golden-tests \
        perf-benchmarks integration-tests clean clean-artifacts clean-cache
