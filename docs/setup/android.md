# Android Debug Bridge (ADB) & Android Studio Setup Guide

> **Source:** [developer.android.com/tools/adb](https://developer.android.com/tools/adb)

---

## Part 1: Setting Up on Windows

### Step 1 — Install Android Studio

1. Go to [developer.android.com/studio](https://developer.android.com/studio) and download the latest Android Studio installer for Windows (`.exe`).
2. Run the installer and follow the setup wizard. Make sure the following components are checked:
   - Android Studio
   - Android SDK
   - Android SDK Platform
   - Android Virtual Device (optional, for emulator use)
3. Complete the installation and launch Android Studio.
4. On first launch, the setup wizard will download the Android SDK and Platform Tools (which includes `adb`).

### Step 2 — Locate ADB / Add it to PATH

By default, ADB is installed at:

```
C:\Users\<YourUsername>\AppData\Local\Android\Sdk\platform-tools\
```

To use `adb` from any terminal window, add it to your system PATH:

1. Open **Start** → search for **"Environment Variables"** → click **"Edit the system environment variables"**.
2. Click **Environment Variables…**
3. Under **System variables**, find `Path` and click **Edit**.
4. Click **New** and paste the full path to `platform-tools`, e.g.:
   ```
   C:\Users\<YourUsername>\AppData\Local\Android\Sdk\platform-tools
   ```
5. Click **OK** on all dialogs.
6. Open a new Command Prompt or PowerShell window and run:
   ```
   adb version
   ```
   You should see the ADB version printed — it's working!

### Step 3 — Install USB Drivers (Windows only)

Windows requires OEM USB drivers to recognise Android devices over USB.

- **Google devices (Pixel, Nexus):** Install the [Google USB Driver](https://developer.android.com/studio/run/win-usb) via Android Studio's SDK Manager under **SDK Tools**.
- **Other manufacturers:** Download the driver from your device manufacturer's website (Samsung, OnePlus, Xiaomi, etc.) or use a universal driver like the one from [adb.clockworkmod.com](https://adb.clockworkmod.com).

---

## Part 2: Setting Up on Linux (Debian/Ubuntu)

### Step 1 — Install Android Studio (via `.tar.gz` or `snap`)

**Option A — Snap (easiest):**

```bash
sudo snap install android-studio --classic
```

**Option B — Manual install:**

1. Download the Linux `.tar.gz` from [developer.android.com/studio](https://developer.android.com/studio).
2. Extract it:
   ```bash
   tar -xzf android-studio-*.tar.gz -C ~/
   ```
3. Launch Android Studio:
   ```bash
   ~/android-studio/bin/studio.sh
   ```
4. Follow the setup wizard; it will download the SDK and Platform Tools automatically.

### Step 2 — Install ADB via apt (lightweight alternative)

If you don't need the full Android Studio IDE, you can install ADB on its own:

```bash
sudo apt update
sudo apt install adb
```

Verify:

```bash
adb version
```

### Step 3 — Add ADB to PATH (if using SDK Platform Tools manually)

If you installed via Android Studio, ADB lives at:

```
~/Android/Sdk/platform-tools/adb
```

Add it to your PATH permanently by editing `~/.bashrc` or `~/.zshrc`:

```bash
echo 'export PATH="$HOME/Android/Sdk/platform-tools:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Step 4 — Set Up udev Rules (required for USB on Linux)

Linux requires udev rules to allow non-root access to Android devices over USB:

```bash
sudo apt install android-sdk-platform-tools-common
```

Or manually add a udev rule:

```bash
echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="plugdev"' | sudo tee /etc/udev/rules.d/51-android.rules
sudo chmod a+r /etc/udev/rules.d/51-android.rules
sudo udevadm control --reload-rules
```

> Replace `18d1` with your device's USB vendor ID. You can find it by running `lsusb` with your device connected.

Also add your user to the `plugdev` group:

```bash
sudo usermod -aG plugdev $USER
```

Log out and back in for the group change to take effect.

---

## Part 3: Enable Developer Options & USB Debugging on Your Device

Before ADB can communicate with your device, you must enable **Developer Options**:

1. Open **Settings** on your Android device.
2. Go to **About phone** (or **About tablet**).
3. Tap **Build number** seven times in a row. You'll see a message saying *"You are now a developer!"*
4. Go back to **Settings** → **Developer options** (usually near the bottom or under **System**).
5. Enable **USB debugging**.

> On Android 4.2.2 (API 17) and higher, the first time you connect to a new computer you'll be prompted to **Allow USB debugging** on the device — tap **Allow**, and optionally check **Always allow from this computer**.

---

## Part 4: Pairing Your Device

### USB Pairing

1. Connect your device to your computer with a USB cable.
2. Accept the **Allow USB debugging** prompt on the device if it appears.
3. In your terminal, run:
   ```
   adb devices
   ```
   You should see output like:
   ```
   List of devices attached
   R5CT123ABCD   device
   ```
   If the status says `unauthorized`, check your device screen and tap **Allow**.

---

### Wireless Pairing (Android 11+ recommended)

Android 11 and higher support fully wireless ADB — no USB cable needed after the initial pairing.

**Prerequisites:**
- Both your device and computer are on the **same Wi-Fi network**.
- Device is running Android 11 (API 30) or higher.
- Android Studio and SDK Platform Tools are up to date.

#### Via Android Studio (QR code or pairing code)

1. On your device, go to **Settings → Developer options → Wireless debugging** and enable it.
2. In Android Studio, open the **Run configurations** dropdown and select **Pair Devices Using Wi-Fi**.
3. A popup window appears with a QR code and pairing code option.
4. On your device, tap **Wireless debugging** → then either:
   - **Pair device with QR code** — scan the QR code shown in Android Studio.
   - **Pair device with pairing code** — tap this option on your device, note the 6-digit code shown, then enter it in the Android Studio popup.
5. Once paired, select your device from the run target and deploy your app wirelessly.

#### Via Command Line

1. On your device, go to **Settings → Developer options → Wireless debugging** → tap **Pair device with pairing code**.
2. Note the **IP address**, **port number**, and **pairing code** shown on your device.
3. On your computer, run:
   ```bash
   adb pair <ip_address>:<port>
   ```
   For example:
   ```bash
   adb pair 192.168.1.42:37889
   ```
4. When prompted, enter the 6-digit pairing code from your device.
5. After pairing, connect using the separate connection port shown under **Wireless debugging** on your device:
   ```bash
   adb connect 192.168.1.42:<connection_port>
   ```
6. Verify:
   ```bash
   adb devices
   ```

> **Tip:** You can add a **Quick Settings tile** for Wireless Debugging via **Developer options → Quick settings developer tiles** to easily toggle it on and off.

---

### Wireless Pairing (Android 10 and lower — requires initial USB)

For older devices, wireless ADB requires a USB cable for the first step:

1. Connect your device via USB.
2. Run:
   ```bash
   adb tcpip 5555
   ```
3. Disconnect the USB cable.
4. Find your device's IP address: **Settings → About phone → Status → IP address**.
5. Connect wirelessly:
   ```bash
   adb connect <device_ip_address>:5555
   ```
6. Verify:
   ```bash
   adb devices
   ```

---

## Useful ADB Commands

| Command | Description |
|---|---|
| `adb devices` | List connected devices |
| `adb devices -l` | List devices with details |
| `adb install app.apk` | Install an APK |
| `adb uninstall com.example.app` | Uninstall an app by package name |
| `adb shell` | Open an interactive shell on the device |
| `adb push local/file /sdcard/` | Copy a file to the device |
| `adb pull /sdcard/file ./` | Copy a file from the device |
| `adb logcat` | View device logs |
| `adb kill-server` | Stop the ADB server (useful for troubleshooting) |
| `adb start-server` | Start the ADB server |

---

## Troubleshooting

- **Device not showing up:** Try a different USB cable or port, re-enable USB debugging, or run `adb kill-server` then `adb devices` again.
- **Wireless debugging drops:** This can happen when the device switches Wi-Fi networks. Re-enable wireless debugging and reconnect.
- **`unauthorized` status:** Accept the debugging prompt on your device screen.
- **Linux: `no permissions`:** Make sure udev rules are set up correctly and you're in the `plugdev` group. Run `adb kill-server && sudo adb start-server` if needed.
- **Corporate/secure Wi-Fi blocking wireless ADB:** Try a personal hotspot or connect via USB instead.