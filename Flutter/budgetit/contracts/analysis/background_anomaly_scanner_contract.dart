import 'package:budgetit/models/anomaly_result.dart';
import 'package:budgetit/models/spending_prediction.dart';

abstract interface class BackgroundAnomalyScannerContract {
  bool get isScanning;

  List<AnomalyResult> get anomalies;

  SpendingPrediction? get prediction;

  DateTime? get lastScanned;

  String? get lastError;

  Future<void> scan();

  void clear();

  void setTestState({
    bool isScanning = false,
    List<AnomalyResult> anomalies = const [],
    SpendingPrediction? prediction,
    DateTime? lastScanned,
    String? lastError,
  });

  bool isStale({Duration maxAge = const Duration(minutes: 30)});
}
