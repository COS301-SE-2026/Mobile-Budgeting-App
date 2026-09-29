/// Compile-time application configuration.
///
/// Values are injected at build time through Flutter's `--dart-define` flags,
/// which lets a single codebase target different environments (local/dev vs
/// prod/AWS) without any code changes.
///
/// ### Local development (defaults)
/// The defaults point at the Android emulator's alias for the host machine
/// (`10.0.2.2`), so no flags are needed:
///
/// ```sh
/// fvm flutter run
/// ```
///
/// ### Production (AWS)
/// Pass the real endpoints and switch the environment:
///
/// ```sh
/// fvm flutter run \
///   --dart-define=ENVIRONMENT=prod \
///   --dart-define=POWERSYNC_URL=https://sync.example.com \
///   --dart-define=API_URL=https://api.example.com
/// ```
///
/// For release builds, pass the same flags to `flutter build apk`.
library;

class AppConfig {
  AppConfig._();

  /// The deployment environment: `dev` (default) or `prod`.
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'dev',
  );

  /// Whether the app is running against production infrastructure.
  static bool get isProduction => environment == 'prod';

  /// Base URL of the PowerSync service.
  ///
  /// Defaults to `10.0.2.2`, the Android emulator's alias for the host machine.
  static const String powerSyncUrl = String.fromEnvironment(
    'POWERSYNC_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  /// Base URL of the FastAPI backend.
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  /// Endpoint that receives PowerSync's CRUD upload queue.
  static String get uploadEndpoint => '$apiUrl/powersync/upload';
}
