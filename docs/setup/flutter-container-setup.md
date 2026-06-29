# Flutter Container Setup

Runs the Flutter build environment in a container.
Auto detects container runtime.

- [Requirements](#requirements)
- [ADB Setup](#adb-setup)
- [Quick Start](#quick-start)
- [Build Outputs](#build-outputs)
- [Connecting a Device](#connecting-a-device-or-emulator)
- [Cleaning Up](#cleaning-up)

---

## Requirements

- [Docker](https://docs.docker.com/engine/install/) or [Podman](https://podman.io/docs/installation/)
- [Android platform tools](https://developer.android.com/tools/releases/platform-tools) (for ADB)

> See [Docker Setup Guide](docker-setup.md) for Docker/Podman install instructions.
>
> See [Android Setup Guide](android.md) for Android and ADB setup on all platforms.

---

## Configuration

Copy the example env file if you want to override defaults:

```bash
cp docker/flutter/.env.example docker/flutter/.env
```

---

## ADB Setup

Enable Developer Options on your phone: Settings -> About phone -> tap Build number 7 times.

Enable USB debugging (and Wireless debugging for Android 11+). Connect via USB or pair wirelessly.

```bash
adb devices
adb start-server
```

> See [Android Setup Guide](android.md) for detailed ADB setup and emulator instructions.


---

## Quick Start

```bash
make -C docker flutter-build-image
```

> First build downloads Android SDK and Flutter (~5-10 min).

```bash
make -C docker flutter-test
```

Full command list: `make -C docker help`

---

## Build Outputs 

Output lands on the host filesystem.

| Target | Command | Output |
|---|---|---|
| APK | `make -C docker flutter-build-apk` | `Flutter/budgetit/build/app/outputs/flutter-apk/app-release.apk` |
| AAB | `make -C docker flutter-build-aab` | `Flutter/budgetit/build/app/outputs/bundle/release/app-release.aab` |
| Web | `make -C docker flutter-build-web` | `Flutter/budgetit/build/web/` |
| Linux | `make -C docker flutter-build-linux` | `Flutter/budgetit/build/linux/x64/release/bundle/` |

---

## Connecting a Device or Emulator

The dev container uses host networking (`network_mode: host`) and the
`ADB_SERVER_SOCKET` environment variable to bridge to the ADB server running on
your host. This means any device or emulator your host sees is automatically
visible inside the container. Both are pre-configured in `docker-compose.yml`.

### On the Host

First, make sure ADB is running on the host:

```bash
adb start-server
```

Then connect your device or start an emulator:

**Physical device over USB:**

Plug in your phone and accept the USB debugging prompt. Verify:

```bash
adb devices
# R5CT123ABCD    device
```

**Physical device over Wi-Fi (Android 11+):**

Pair and connect wirelessly as described in [android.md](android.md). Verify
with `adb devices`.

**Emulator:**

Start the emulator on the host (from Android Studio or the command line):

```bash
emulator -list-avds
emulator -avd Pixel_9_API_36
```

> The emulator must run on the host. It cannot run inside the container.

### Inside the Container

```bash
make -C docker flutter-dev
```

Once inside the container shell, verify the device is visible:

```bash
flutter devices
```

Expected output:

```
R5CT123ABCD (mobile)  • ABC123 • android • Android 14 (API 34)
```

Or for an emulator:

```
Pixel 9 (emulator) • emulator-5554 • android • Android 14 (API 34)
```

### Running the App

```bash
flutter run
```

If multiple devices are connected, specify one:

```bash
flutter run -d emulator-5554
```

> Hot reload and hot restart work normally inside the container. The source
> tree is bind-mounted, so edits on the host are visible immediately.

---

## Cleaning Up

```bash
make -C docker flutter-clean
make -C docker backend-clean
make -C docker clean
```

---

## VS Code (optional)

See [vscode-setup.md](vscode-setup.md).
