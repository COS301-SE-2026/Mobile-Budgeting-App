# VS Code Setup

- [Extensions](#extensions)
- [Flutter SDK Path](#flutter-sdk-path)

---

## Extensions

Install the **Flutter** extension from the VS Code marketplace. It automatically
installs the **Dart** extension alongside it. These provide code completion, syntax
highlighting, debugging, and Flutter widget editing tools.

No other extensions are required.

---

## Flutter SDK Path

VS Code needs to know where the Flutter SDK lives for Dart analysis and
tooling features to work.

### Manual Setup (FVM)

If you followed [flutter-manual-setup.md](flutter-manual-setup.md), the Flutter SDK
is managed by FVM inside the project directory. Add this to
`Flutter/budgetit/.vscode/settings.json`:

```json
{
  "dart.flutterSdkPath": ".fvm/flutter_sdk"
}
```

### Container Setup

If you followed [flutter-container-setup.md](flutter-container-setup.md), Flutter
lives inside the container, and VS Code on the host cannot see it. To get
Dart analysis in VS Code, you must install Flutter locally as well:

1. Follow the [manual setup](flutter-manual-setup.md) steps to install Flutter
   and FVM on your host
2. Run `cd Flutter/budgetit && fvm install && fvm flutter pub get`
3. Add the FVM SDK path to `.vscode/settings.json` (see above)

If you don't need host side Dart analysis, skip all of this. All builds and
tests run inside the container regardless.
