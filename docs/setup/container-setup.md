# Container Setup

Runs the full Flutter build environment in a container, giving every developer identical
Flutter / Dart SDK versions regardless of their host setup. Primary target is Android
mobile; web and Linux desktop are also supported.

> **Podman or Docker?** The Makefile auto-detects whichever you have installed — no
> configuration needed. All `make container-*` commands work identically with either.

---

## Prerequisites

### Fedora / RHEL
```bash
sudo dnf install podman podman-compose android-tools
```

### Ubuntu / Debian
```bash
sudo apt-get install docker.io docker-compose android-tools-adb
sudo usermod -aG docker $USER   # allows running docker without sudo — re-login after
```

### Verify
```bash
docker --version        # or: podman --version
docker-compose --version  # or: podman-compose --version
adb version
```

---

## First-Time Setup

Build the image once (~20 min — downloads Flutter engine artifacts):

```bash
make container-build-image
```

This creates a local image named `budgetit-flutter:latest`. Subsequent builds use the
layer cache so only changed layers re-download.

---

## ADB Bridge Setup (Connecting Your Android Device)

The container connects to the ADB server running on your host machine rather than running
its own. Because the container shares your host's network, any device your host can see is
automatically visible inside the container.

### Step 1 — Enable Developer Options on your phone

1. **Settings → About phone** → tap **Build number** 7 times
2. Go back to **Settings → Developer Options**
3. Enable **USB debugging** (and **Wireless debugging** if connecting over Wi-Fi)

### Step 2 — Connect your device

**Option A — USB cable (simplest)**

Plug your phone in. Accept the **"Allow USB debugging"** prompt on your phone, then confirm:
```bash
adb devices
# List of devices attached
# R58M123ABCD    device
```

**Option B — Wireless (Android 11+)**

On your phone:
- Settings → Developer Options → **Wireless debugging** → enable
- Tap **"Pair device with pairing code"** — note the IP, pairing port, and 6-digit code
- On the main Wireless Debugging screen, note the **IP address & Port** (the debug port)

On your computer:
```bash
# Pair once — you never need to do this again for this device
adb pair <phone-ip>:<pairing-port>
# Enter the 6-digit code when prompted

# Connect each session — the debug port changes every time Wireless Debugging is opened
adb connect <phone-ip>:<debug-port>

adb devices   # confirm it's visible
```

> **Tip:** Set a static IP for your phone in your router's DHCP settings
> ("Address Reservation" or "DHCP Reservation") so the IP never changes between sessions.

### Step 3 — Start the ADB server

```bash
adb start-server
```

This must run **before** any container dev target. The container's ADB client connects to
this server on `localhost:5037` — if it's not running, Flutter won't find your device.

The server stays running in the background until you reboot or run `adb kill-server`.
You only need to do this once per login session.

### Step 4 — Verify the bridge

```bash
make container-adb-devices
# Output should match 'adb devices' on your host exactly
```

---

## Development Workflow

| Goal | Command |
|---|---|
| Interactive bash shell | `make container-dev` |
| Run app on Android (hot reload) | `make container-run-android` |
| Run app as Linux desktop | `make container-run-linux` |
| List connected ADB devices | `make container-adb-devices` |

### Hot Reload on Android

1. Connect your device: `adb devices`
2. Start the ADB server: `adb start-server`
3. Run: `make container-run-android`
4. Edit source files in your host IDE — Flutter hot reloads automatically on save

### Linux Desktop

```bash
make container-run-linux
```

Requires a display. On a desktop session `DISPLAY` is forwarded automatically.
For headless SSH sessions the entrypoint falls back to a virtual framebuffer (Xvfb).

---

## Build Artifacts

One-shot builds. Output lands on the **host** filesystem automatically since the source
tree is bind-mounted into the container.

| Target | Command | Output path |
|---|---|---|
| Android APK | `make container-build-apk` | `Flutter/budgetit/build/app/outputs/flutter-apk/app-release.apk` |
| Android AAB | `make container-build-aab` | `Flutter/budgetit/build/app/outputs/bundle/release/app-release.aab` |
| Web | `make container-build-web` | `Flutter/budgetit/build/web/` |
| Linux desktop | `make container-build-linux` | `Flutter/budgetit/build/linux/x64/release/bundle/` |
| Run tests | `make container-test` | stdout |

---

## Cleaning Up

```bash
make container-clean    # stop containers, remove named volumes (Gradle/Pub cache)
                        # next build re-downloads caches from scratch

make container-prune    # system prune — reclaims disk from all stopped containers
                        # and dangling images (affects all container projects)
```

---

## Platform Notes

| Platform | Support |
|---|---|
| Android (APK/AAB) | ✅ Full — build and run |
| Web | ✅ Build only — no browser in container |
| Linux desktop | ✅ Full — build and run (requires display) |
| Windows | ❌ Not possible — Flutter cannot cross-compile for Windows from Linux |
| macOS | ❌ Not possible — requires macOS host |
| iOS | ❌ Not possible — requires macOS host |

---

## Troubleshooting

**`podman-compose: command not found` / `docker-compose: command not found`**
```bash
sudo dnf install podman-compose   # Fedora
sudo apt-get install docker-compose  # Ubuntu
```

**`flutter run` can't find device**
```bash
adb start-server            # ensure host ADB server is running
adb devices                 # confirm device is visible on host
make container-adb-devices  # confirm it's visible inside the container
```
If the device shows on the host but not in the container:
```bash
adb kill-server && adb start-server
```

**SELinux denial on volume mount (Fedora only)**

All mounts use `:z` which handles this automatically. If you still see denials:
```bash
sudo ausearch -m avc -ts recent | grep podman
```
The most common cause is running `sudo podman` instead of plain `podman` — always run
rootless (without sudo).

**Wayland display issues with `flutter run -d linux`**
```bash
WAYLAND_DISPLAY= make container-run-linux   # force X11 instead
```

**Image is very large (~4 GB)**

Expected — Flutter pre-caches engine artifacts for Android, Linux, and web. To rebuild
without the cache:
```bash
make container-build-image-nocache
```
Or remove the `--android --linux --web` flags from the `flutter precache` line in
`Containerfile` and rebuild for a leaner image.
