import 'package:flutter/foundation.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/models/anomaly_result.dart';
import 'package:budgetit/models/spending_prediction.dart';
import 'package:budgetit/services/analysis/transaction_history_service.dart';
import 'package:budgetit/services/analysis/anomaly_detection_service.dart';
import 'package:budgetit/services/analysis/predictive_spending_service.dart';


class BackgroundAnomalyScanner extends ChangeNotifier {
    final AppDatabase _db;
    final AnomalyDetectionService _anomalyService;
    final TransactionHistoryService _historyService;
    final PredictiveSpendingService _predictiveService = PredictiveSpendingService();

    static const int _historyMonths = 6;
    bool _scanning = false;
    bool get isScanning => _scanning;

    List<AnomalyResult> _anomalies = [];
    List<AnomalyResult> get anomalies => List.unmodifiable(_anomalies);

    SpendingPrediction? _prediction;
    SpendingPrediction? get prediction => _prediction;

    DateTime? _lastScanned;
    DateTime? get lastScanned => _lastScanned;

    String? _lastError;
    String? get lastError => _lastError;

    BackgroundAnomalyScanner(this._db)
        : _historyService = TransactionHistoryService(_db),
          _anomalyService = AnomalyDetectionService()
;         // _predictionService = PredictiveSpendingService();

    Future<void> scan() async {
        if (_scanning) return;

        _scanning = true;
        _lastError = null;
        notifyListeners();

        try {
            final history = await _historyService.getNonEmptyMonthlyHistory(
                monthsBack: _historyMonths,
            );

            final anomalies = _anomalyService.detect(history);

            final now = DateTime.now();
            final currentMonthSummary = await _historyService.getSummaryForMonth(
                now.year,
                now.month,
            );
            final prediction = _predictiveService.predictCurrentMonth(
                history,
                currentMonthActual: currentMonthSummary.totalExpenses,
                dayOfMonth: DateTime(now.year, now.month + 1, 0).day,
            );

            _anomalies = anomalies;
            _prediction = prediction;
            _lastScanned = DateTime.now();
        } catch (e) {
            _lastError = e.toString();
            debugPrint('[BackgroundAnomalyScanner] scan error: $e');
        } finally { 
            _scanning = false;
            notifyListeners();
        }
    }

    void clear() {
        _anomalies = [];
        _prediction = null;
        _lastScanned = null;
        _lastError = null;
        notifyListeners();
    }

    bool isStale({Duration maxAge = const Duration(minutes: 30)}) {
        if (_lastScanned == null ) return true;
        return DateTime.now().difference(_lastScanned!) > maxAge;
    }
}