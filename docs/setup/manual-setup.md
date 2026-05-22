# Manual Setup — BudgetIt

Full step-by-step instructions for setting up the Flutter development environment manually.
All commands are run from the **Capstone/ root** using the Makefile.

---

## Prerequisites

| Tool | Version |
|---|---|
| Flutter | managed by FVM (stable) |
| Dart | bundled with Flutter |
| FVM | latest |
| Android Studio | latest stable |
| Android SDK | 36 |
| Android Build Tools | 28.0.3 |
| Java | bundled with Android Studio |

---

## Step 1 — Enable Developer Mode (Windows only)

FVM requires symlinks which are blocked by default on Windows.

- Press `Win + S` → search **Developer settings**
- Toggle **Developer Mode** on
- Restart your terminal

---

## Step 2 — Install Android Studio

1. Download from https://developer.android.com/studio and run the installer
2. On first launch run through the **Setup Wizard** — choose **Standard** install
3. It will automatically download the Android SDK, emulator, and build tools

### Enable Android SDK Command Line Tools

Required by Flutter, not installed by default.

1. Open Android Studio
2. Go to **Settings** → **Languages & Frameworks** → **Android SDK**
   (or click **More Actions** → **SDK Manager** from the welcome screen)
3. Click the **SDK Tools** tab
4. Check **Android SDK Command-line Tools (latest)**
5. Click **Apply** → **OK** and let it download

### Install Flutter and Dart plugins

1. Go to **Settings** → **Plugins**
2. Search **Flutter** → Install (Dart installs automatically)
3. Restart Android Studio

---

## Step 3 — Install FVM

Open PowerShell:

```powershell
dart pub global activate fvm
```

Add the pub global bin to your PATH if prompted — add `%APPDATA%\Pub\Cache\bin` to your system PATH via Environment Variables and restart your terminal.

Verify:
```powershell
fvm --version
```

---

## Step 4 — Set up Flutter

From the **Capstone/ root**:

```powershell
make setup-flutter
```

This activates FVM, installs the pinned Flutter version from `.fvm/fvm_config.json`, installs all dependencies, and accepts Android licenses in one step.

---

## Step 5 — Configure VS Code

Install the **Flutter** and **Dart** extensions in VS Code, then add this to `Flutter/budgetit/.vscode/settings.json`:

```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk"
}
```

This tells VS Code to use the FVM-managed Flutter instead of any system Flutter.

---

## Step 6 — Verify everything

```powershell
make flutter-doctor
```

You want these green:
```
[✓] Flutter
[✓] Android toolchain
[✓] Android Studio
[✓] Connected device
```

Chrome and Linux toolchain warnings can be ignored for Android development.

---

## Running the App

### On an emulator

1. Open Android Studio → **Virtual Device Manager**
2. Click **Create Device** → pick a Pixel → download a system image → Finish
3. Hit the play button to start the emulator
4. Run from the Capstone/ root:

```powershell
make flutter-run
```

### On a physical Android device

1. On your phone go to **Settings** → **About Phone** → tap **Build Number** 7 times
2. Go to **Developer Options** → enable **USB Debugging**
3. Plug in via USB and trust the computer when prompted
4. Run:

```powershell
make flutter-devices    # confirm device is listed
make flutter-run
```
