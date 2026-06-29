COMPOSE_CMD = $(shell which podman-compose 2>/dev/null || which docker-compose 2>/dev/null || echo docker-compose)
CONTAINER_CMD ?= $(shell which podman 2>/dev/null || which docker 2>/dev/null || echo docker)
FLUTTER_COMPOSE = -f flutter/docker-compose.yml
BACKEND_COMPOSE  = -f backend/docker-compose.yml

.PHONY: flutter-build-image flutter-dev flutter-shell \
        flutter-build-apk flutter-build-aab flutter-build-web flutter-build-linux \
        flutter-test flutter-clean

flutter-build-image:
	$(COMPOSE_CMD) $(FLUTTER_COMPOSE) build

flutter-dev:
	$(COMPOSE_CMD) $(FLUTTER_COMPOSE) run --rm dev

flutter-shell:
	$(COMPOSE_CMD) $(FLUTTER_COMPOSE) run --rm dev bash

flutter-build-apk:
	$(COMPOSE_CMD) $(FLUTTER_COMPOSE) run --rm build-apk

flutter-build-aab:
	$(COMPOSE_CMD) $(FLUTTER_COMPOSE) run --rm build-aab

flutter-build-web:
	$(COMPOSE_CMD) $(FLUTTER_COMPOSE) run --rm build-web

flutter-build-linux:
	$(COMPOSE_CMD) $(FLUTTER_COMPOSE) run --rm build-linux

flutter-test:
	$(COMPOSE_CMD) $(FLUTTER_COMPOSE) run --rm test

flutter-clean:
	$(COMPOSE_CMD) $(FLUTTER_COMPOSE) down --volumes --remove-orphans
	$(CONTAINER_CMD) rmi budgetit-flutter:latest 2>/dev/null || true

.PHONY: backend-build backend-up backend-down backend-clean

backend-build:
	$(COMPOSE_CMD) $(BACKEND_COMPOSE) build

backend-up:
	$(COMPOSE_CMD) $(BACKEND_COMPOSE) up -d

backend-down:
	$(COMPOSE_CMD) $(BACKEND_COMPOSE) down

backend-clean:
	$(COMPOSE_CMD) $(BACKEND_COMPOSE) down --volumes --remove-orphans

.PHONY: clean

clean: flutter-clean backend-clean
	$(CONTAINER_CMD) network rm budgetit-net 2>/dev/null || true

.PHONY: help

help:
	@echo ""
	@echo "BudgetIt Docker — available commands:"
	@echo ""
	@echo "  Flutter"
	@echo "    make flutter-build-image     Build Flutter container image"
	@echo "    make flutter-dev             Interactive dev shell (ADB bridge)"
	@echo "    make flutter-shell           Bash shell in container"
	@echo "    make flutter-build-apk       Build release APK"
	@echo "    make flutter-build-aab       Build release AAB"
	@echo "    make flutter-build-web       Build web release"
	@echo "    make flutter-build-linux     Build Linux desktop release"
	@echo "    make flutter-test            Run Flutter tests"
	@echo "    make flutter-clean           Remove Flutter containers, volumes, image"
	@echo ""
	@echo "  Backend"
	@echo "    make backend-build           Build backend image"
	@echo "    make backend-up              Start backend (detached)"
	@echo "    make backend-down            Stop backend"
	@echo "    make backend-clean           Remove backend containers and volumes"
	@echo ""
	@echo "  All"
	@echo "    make clean                   Remove everything + network"
	@echo ""
