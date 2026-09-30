import 'package:budgetit/models/anomaly_result.dart';
import 'package:budgetit/models/spending_prediction.dart';

/// Holds the result of the most recent anomaly scan for the UI to observe.
/// A scan reads recent spending history, runs anomaly detection over it and
/// produces a prediction for the current month, caching all three so screens
/// can render without re-querying. Implementations are expected to be
/// listenable (the app's implementation extends 'ChangeNotifier') and to
/// notify observers whenever [isScanning], [anomalies], [prediction],
/// [lastScanned] or [lastError] changes.
///
/// Errors are captured into [lastError] rather than thrown, so a failed scan
/// leaves the previously cached results intact.
///
/// {@category Analysis}
abstract interface class BackgroundAnomalyScannerContract {
  /// Whether a scan is currently in progress.
  bool get isScanning;

  /// Anomalies from the most recent successful scan, highest z-score first.
  /// Empty before the first scan. Implementations should return an
  /// unmodifiable view.
  List<AnomalyResult> get anomalies;

  /// The current-month spending forecast from the most recent scan.
  /// 'null' before the first scan, or when there was too little history to
  /// produce a forecast.
  SpendingPrediction? get prediction;

  /// When the last successful scan completed, or 'null' if none has.
  DateTime? get lastScanned;

  /// The error message from the last failed scan, or 'null' if the last scan
  /// succeeded or none has run.
  /// Cleared at the start of every scan.
  String? get lastError;

  /// Runs a scan and refreshes the cached results.
  /// Returns immediately without doing anything if a scan is already running,
  /// so it is safe to call from several widgets at once. Never throws: a
  /// failure is recorded in [lastError] and leaves the previous results in
  /// place.
  Future<void> scan();

  /// Clears all cached results back to the pre-scan state and notifies
  /// listeners.
  void clear();

  /// Overwrites the cached state directly, without scanning.
  /// Intended for tests that need a deterministic scanner state; production
  /// code should call [scan]. Implementations should mark this
  /// '@visibleForTesting'.
  void setTestState({
    bool isScanning = false,
    List<AnomalyResult> anomalies = const [],
    SpendingPrediction? prediction,
    DateTime? lastScanned,
    String? lastError,
  });

  /// Whether the cached results are older than [maxAge].
  /// Returns 'true' when no scan has completed yet, so a caller can treat
  /// "stale" as "needs a scan" without a separate null check.
  bool isStale({Duration maxAge = const Duration(minutes: 30)});
}
