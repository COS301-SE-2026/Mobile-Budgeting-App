# ── Flutter ────────────────────────────────────────────────

flutter-setup:
	@echo "Installing Flutter dependencies..."
	sudo apt update && sudo apt install -y \
		curl git unzip xz-utils zip libglu1-mesa openjdk-17-jdk wget
	@echo "Cloning Flutter SDK..."
	cd ~ && git clone https://github.com/flutter/flutter.git -b stable || \
		echo "Flutter already cloned, skipping."
	@echo "Adding Flutter to PATH..."
	grep -q 'flutter/bin' ~/.bashrc || \
		echo 'export PATH="$$HOME/flutter/bin:$$PATH"' >> ~/.bashrc
	@echo "Setting up Android SDK..."
	mkdir -p ~/Android/Sdk/cmdline-tools
	cd ~ && wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip
	unzip -q ~/commandlinetools-linux-11076708_latest.zip -d ~/Android/Sdk/cmdline-tools || true
	mv ~/Android/Sdk/cmdline-tools/cmdline-tools ~/Android/Sdk/cmdline-tools/latest 2>/dev/null || true
	grep -q 'ANDROID_SDK_ROOT' ~/.bashrc || echo '\
export ANDROID_SDK_ROOT="$$HOME/Android/Sdk"\n\
export PATH="$$PATH:$$ANDROID_SDK_ROOT/cmdline-tools/latest/bin"\n\
export PATH="$$PATH:$$ANDROID_SDK_ROOT/platform-tools"' >> ~/.bashrc
	@echo "Installing Android SDK packages..."
	. ~/.bashrc && sdkmanager "platforms;android-36" "build-tools;28.0.3" "platform-tools"
	. ~/.bashrc && flutter config --android-sdk ~/Android/Sdk
	@echo ""
	@echo "✓ Done. Run: source ~/.bashrc"
	@echo "  Then:   flutter doctor --android-licenses"

flutter-update:
	cd ~/flutter && git pull
	sdkmanager --update
	sdkmanager "platforms;android-36" "build-tools;28.0.3"

flutter-doctor:
	flutter doctor -v

flutter-get:
	cd flutter && flutter pub get

flutter-run:
	cd flutter && flutter run

flutter-test:
	cd flutter && flutter test

flutter-build-apk:
	cd flutter && flutter build apk --release