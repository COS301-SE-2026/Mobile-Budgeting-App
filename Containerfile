FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC

# Some container runtimes have a limited UID range. Flutter's precache
# downloads tarballs with UIDs outside that range, causing
# tar chown to fail with "Invalid argument".
# --no-same-owner skips chown entirely.
ENV TAR_OPTIONS="--no-same-owner"

# Some container runtimes set /tmp to 755 instead of the usual 1777.
# apt drops to the _apt user for some operations and can't create temp files
# without world-write on /tmp.
# Fix it before any apt command runs.
RUN chmod 1777 /tmp

# ── System packages ──────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git unzip wget xz-utils zip \
    openjdk-17-jdk-headless \
    lib32stdc++6 lib32z1 libglu1-mesa \
    libgtk-3-dev cmake ninja-build pkg-config clang \
    libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev \
    # ADB client only — connects to host ADB server
    android-tools-adb \
    xvfb \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# ── Android SDK ──────────────────────────────────────────────────────────────
# Paths here match Flutter/budgetit/android/local.properties exactly:
#   sdk.dir=/opt/android-sdk
#   flutter.sdk=/opt/flutter
ENV ANDROID_SDK_ROOT=/opt/android-sdk \
    ANDROID_HOME=/opt/android-sdk

# Command-line tools version commandlinetools-linux-14742923
# To update: check https://developer.android.com/studio#command-tools for the
# latest version number and replace 14742923 in the URL below.
RUN mkdir -p /tmp/cmdtools && \
    wget -q \
        https://dl.google.com/android/repository/commandlinetools-linux-14742923_latest.zip \
        -O /tmp/cmdtools.zip && \
    unzip -q /tmp/cmdtools.zip -d /tmp/cmdtools && \
    mkdir -p /opt/android-sdk/cmdline-tools && \
    mv /tmp/cmdtools/cmdline-tools /opt/android-sdk/cmdline-tools/latest && \
    rm -rf /tmp/cmdtools.zip /tmp/cmdtools

ENV PATH="${PATH}:/opt/android-sdk/cmdline-tools/latest/bin:/opt/android-sdk/platform-tools"

# Accept licenses and install SDK components.
# Platforms android-30 through android-36 cover Android 11–16.
# Two NDK versions: flutter.ndkVersion (27) and the one Gradle pulls for newer devices (28).
RUN yes | sdkmanager --licenses && \
    sdkmanager \
        "platform-tools" \
        "platforms;android-30" \
        "platforms;android-31" \
        "platforms;android-32" \
        "platforms;android-33" \
        "platforms;android-34" \
        "platforms;android-35" \
        "platforms;android-36" \
        "build-tools;30.0.3" \
        "build-tools;31.0.0" \
        "build-tools;32.0.0" \
        "build-tools;33.0.2" \
        "build-tools;34.0.0" \
        "build-tools;35.0.0" \
        "build-tools;36.0.0" \
        "ndk;27.0.11902837" \
        "ndk;28.2.13676358" \
        "cmdline-tools;latest"

# ── Flutter SDK ──────────────────────────────────────────────────────────────
# Installed directly at /opt/flutter — no FVM in the container.
# FVM on the host is unaffected; .fvm/ dirs are excluded from this image.
ENV FLUTTER_SDK=/opt/flutter

RUN git clone --depth 1 --branch 3.41.9 \
        https://github.com/flutter/flutter.git /opt/flutter

ENV PATH="${PATH}:/opt/flutter/bin"

RUN flutter precache --android --linux --web && \
    flutter config --no-analytics --no-cli-animations && \
    yes | flutter doctor --android-licenses 2>&1 | tail -5

# ── Entrypoint and environment ─────────────────────────────────────────
COPY container/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENV GRADLE_USER_HOME=/root/.gradle \
    PUB_CACHE=/root/.pub-cache

WORKDIR /workspace
