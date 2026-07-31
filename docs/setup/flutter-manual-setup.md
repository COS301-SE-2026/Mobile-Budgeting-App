# Flutter Manual Setup

Runs the Flutter app directly . Uses FVM to pin the Flutter version.
All commands run from the repo root.

- [Requirements](#requirements)
- [System Dependencies](#system-dependencies)
- [Android Studio](#android-studio)
- [FVM](#fvm)
- [Setup](#setup)
- [Verify](#verify)
- [Running](#running)

---

## Requirements

- Flutter (managed by FVM)
- [Android Studio](https://developer.android.com/studio) (latest stable)
- Java (bundled with Android Studio)

---

## System Dependencies

### Windows

Enable Developer Mode (FVM requires symlinks):

- Win + S -> Developer settings -> toggle Developer Mode on -> restart terminal

No extra packages needed. Android Studio bundles everything.

### WSL

Install an Ubuntu WSL distro from the Microsoft Store, then follow the Ubuntu / Debian
instructions below inside WSL. Android Studio runs on the Windows host; USB passthrough
from WSL uses `adb` on both sides.

```bash
wsl --install -d Ubuntu
```

> Android emulators are not available inside WSL. Use a physical device connected via USB
> to the Windows host, or run the emulator on the Windows host.

### Ubuntu / Debian

```bash
sudo apt-get update
sudo apt-get install -y curl git unzip zip openjdk-17-jdk-headless \
    libgtk-3-dev cmake ninja-build pkg-config clang \
    libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev
```

### Fedora / RHEL

```bash
sudo dnf install -y curl git unzip zip java-17-openjdk-headless \
    gtk3-devel cmake ninja-build pkg-config clang \
    libXrandr-devel libXinerama-devel libXcursor-devel libXi-devel
```

---

## Android Studio

1. Download from https://developer.android.com/studio and run the installer
2. On first launch, choose Standard install in the Setup Wizard. It downloads SDK, emulator, and build tools automatically

### Enable SDK Command Line Tools

1. Android Studio -> Settings -> Languages & Frameworks -> Android SDK
2. SDK Tools tab -> check Android SDK Command-line Tools (latest) -> Apply -> OK

---

## FVM

```bash
dart pub global activate fvm
```

Add to PATH:

| OS | PATH entry |
|---|---|
| Windows | `%APPDATA%\Pub\Cache\bin` |
| WSL / Ubuntu / Fedora / RHEL | `$HOME/.pub-cache/bin` |

Restart your terminal, then:

```bash
fvm --version
```

---

## Setup

From the **repo root**:

```bash
make setup-flutter
```

> Installs the pinned Flutter version, dependencies, and accepts Android licenses.

---

## Verify

```bash
make flutter-doctor
```

---

## Running

```bash
make flutter-run
```

Device-specific:

```bash
make flutter-devices
make flutter-run-android
```

> Requires a connected Android device or a running emulator. See
> [Android Setup Guide](android.md) for device setup and emulator instructions.

---

## VS Code (optional)

See [vscode-setup.md](vscode-setup.md).
