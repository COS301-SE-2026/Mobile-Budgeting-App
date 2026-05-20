#!/usr/bin/env bash
# Usage (called by docker-compose dev service, or called directly)
#   entrypoint.sh — bash shell (default)
#   entrypoint.sh dev — same as above
#   entrypoint.sh android — flutter run -d android (with hot reload)
#   entrypoint.sh run-linux — flutter run -d linux (X11/Xvfb fallback)
#   entrypoint.sh adb-devices — list devices via host ADB server
set -euo pipefail

flutter pub get

MODE=${1:-shell}

case "$MODE" in
  dev|shell)
    exec bash
    ;;

  android)
    # ADB connects to host server via network_mode:host
    # Hot reload is automatic
    # No -d flag: Flutter auto-selects the single connected device, or shows a dialog if multiple are attached.
    exec flutter run
    ;;

  run-linux)
    # Runs the Linux desktop app; needs a display.
    # Falls back to Xvfb :99 when no display is forwarded (SSH sessions).
    if [ -z "${DISPLAY:-}" ] && [ -z "${WAYLAND_DISPLAY:-}" ]; then
      Xvfb :99 -screen 0 1280x720x24 &
      export DISPLAY=:99
    fi
    exec flutter run -d linux
    ;;

  adb-devices)
    exec adb devices
    ;;

  *)
    exec "$@"
    ;;
esac
