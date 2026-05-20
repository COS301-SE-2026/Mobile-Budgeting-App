# ── BudgetIt Makefile ──────────────────────────────────────
# Run all commands from the root.
# Flutter app lives at Flutter/budgetit/
# All Flutter commands use FVM to ensure the pinned version is used.

FLUTTER_DIR   = Flutter/budgetit
COMPOSE_CMD  ?= $(shell which podman-compose 2>/dev/null || which docker-compose 2>/dev/null || echo docker-compose)
CONTAINER_CMD ?= $(shell which podman 2>/dev/null || which docker 2>/dev/null || echo docker)
IMAGE_NAME    = budgetit-flutter

# ── Flutter ────────────────────────────────────────────────

flutter-get:
	cd $(FLUTTER_DIR) && fvm flutter pub get

flutter-run:
	cd $(FLUTTER_DIR) && fvm flutter run

flutter-run-android:
	cd $(FLUTTER_DIR) && fvm flutter run -d android

flutter-test:
	cd $(FLUTTER_DIR) && fvm flutter test

flutter-test-coverage:
	cd $(FLUTTER_DIR) && fvm flutter test --coverage

flutter-build-apk:
	cd $(FLUTTER_DIR) && fvm flutter build apk --release

flutter-build-appbundle:
	cd $(FLUTTER_DIR) && fvm flutter build appbundle --release

flutter-clean:
	cd $(FLUTTER_DIR) && fvm flutter clean && fvm flutter pub get

flutter-analyze:
	cd $(FLUTTER_DIR) && fvm flutter analyze

flutter-doctor:
	Flutter\budgetit\.fvm\flutter_sdk\bin\flutter doctor -v

flutter-devices:
	Flutter\budgetit\.fvm\flutter_sdk\bin\flutter devices

flutter-update:
	cd $(FLUTTER_DIR) && fvm install stable && fvm use stable && fvm flutter pub get

# ── Setup ──────────────────────────────────────────────────

setup-flutter:
	@echo "Activating FVM..."
	dart pub global activate fvm
	@echo "Installing pinned Flutter version..."
	cd $(FLUTTER_DIR) && fvm install
	@echo "Installing dependencies..."
	cd $(FLUTTER_DIR) && fvm flutter pub get
	@echo "Accepting Android licenses..."
	cd $(FLUTTER_DIR) && fvm flutter doctor --android-licenses
	@echo ""
	@echo "✓ Done. Run: make flutter-doctor to verify."

# ── Help ───────────────────────────────────────────────────

help:
	@echo ""
	@echo "BudgetIt — available commands:"
	@echo ""
	@echo "  Setup"
	@echo "    make setup-flutter            Full Flutter environment setup"
	@echo ""
	@echo "  Development"
	@echo "    make flutter-get              Install dependencies"
	@echo "    make flutter-run              Run on connected device/emulator"
	@echo "    make flutter-run-android      Run specifically on Android"
	@echo "    make flutter-devices          List connected devices"
	@echo "    make flutter-clean            Clean and reinstall dependencies"
	@echo "    make flutter-analyze          Run static analysis"
	@echo ""
	@echo "  Testing"
	@echo "    make flutter-test             Run all tests"
	@echo "    make flutter-test-coverage    Run tests with coverage"
	@echo ""
	@echo "  Build"
	@echo "    make flutter-build-apk        Build release APK"
	@echo "    make flutter-build-appbundle  Build Play Store bundle"
	@echo ""
	@echo "  Maintenance"
	@echo "    make flutter-doctor           Check Flutter setup"
	@echo "    make flutter-update           Update to latest stable Flutter"
	@echo ""
	@echo "  Container — see CONTAINER_SETUP.md"
	@echo "    make container-build-image    Build the Flutter container image"
	@echo "    make container-dev            Interactive dev shell (ADB bridge, hot reload)"
	@echo "    make container-run-android    Run on Android device/emulator (hot reload)"
	@echo "    make container-run-linux      Run Linux desktop app (X11/Xvfb)"
	@echo "    make container-adb-devices    List ADB devices via host server"
	@echo "    make container-build-apk      Build release APK (output on host)"
	@echo "    make container-build-aab      Build release AAB (output on host)"
	@echo "    make container-build-web      Build web release (output on host)"
	@echo "    make container-build-linux    Build Linux desktop release (output on host)"
	@echo "    make container-test           Run Flutter tests"
	@echo "    make container-clean          Remove containers, volumes, and image"
	@echo ""

.PHONY: flutter-get flutter-run flutter-run-android flutter-test \
        flutter-test-coverage flutter-build-apk flutter-build-appbundle \
        flutter-clean flutter-analyze flutter-doctor flutter-devices \
        flutter-update setup-flutter help \
        container-build-image container-build-image-nocache \
        container-dev container-shell container-run-android container-run-linux \
        container-build-apk container-build-aab container-build-web container-build-linux \
        container-test container-adb-devices container-clean container-prune

# ── Container ──────────────────────────────────────────────

container-build-image:
	$(CONTAINER_CMD) build --security-opt label=disable -t $(IMAGE_NAME):latest -f Containerfile .

container-build-image-nocache:
	$(CONTAINER_CMD) build --no-cache --security-opt label=disable -t $(IMAGE_NAME):latest -f Containerfile .

container-dev:
	$(COMPOSE_CMD) run --rm dev

container-shell:
	$(COMPOSE_CMD) run --rm dev bash

container-run-android:
	$(COMPOSE_CMD) run --rm dev android

container-run-linux:
	$(COMPOSE_CMD) run --rm dev-linux run-linux

container-build-apk:
	$(COMPOSE_CMD) run --rm build-apk

container-build-aab:
	$(COMPOSE_CMD) run --rm build-aab

container-build-web:
	$(COMPOSE_CMD) run --rm build-web

container-build-linux:
	$(COMPOSE_CMD) run --rm build-linux

container-test:
	$(COMPOSE_CMD) run --rm test

container-adb-devices:
	$(COMPOSE_CMD) run --rm dev adb-devices

container-clean:
	$(COMPOSE_CMD) down --volumes --remove-orphans
	$(CONTAINER_CMD) rmi $(IMAGE_NAME):latest 2>/dev/null || true

container-prune:
	$(CONTAINER_CMD) system prune -f
