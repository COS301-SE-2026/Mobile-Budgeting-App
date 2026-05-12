# ── BudgetIt Makefile ──────────────────────────────────────
# Run all commands from the root.
# Flutter app lives at Flutter/budgetit/
# All Flutter commands use FVM to ensure the pinned version is used.

FLUTTER_DIR = Flutter/budgetit

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
	fvm flutter doctor -v

flutter-devices:
	fvm flutter devices

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

.PHONY: flutter-get flutter-run flutter-run-android flutter-test \
        flutter-test-coverage flutter-build-apk flutter-build-appbundle \
        flutter-clean flutter-analyze flutter-doctor flutter-devices \
        flutter-update setup-flutter help
