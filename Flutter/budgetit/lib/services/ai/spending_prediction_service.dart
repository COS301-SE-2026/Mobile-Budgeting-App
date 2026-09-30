import 'spending_features.dart';
import 'spending_prediction.dart';

class SpendingPredictionService {
  const SpendingPredictionService();

  SpendingPrediction predict(SpendingFeatures features) {
    if (features.daysElapsed <= 0) {
      return SpendingPrediction(
        currentSpending: features.currentSpending,
        predictedMonthEndSpending: features.currentSpending,
        confidence: 0.0,
      );
    }

    final totalDays = features.daysElapsed + features.daysRemaining;

    final predictedSpending = features.averageDailySpending * totalDays;

    final confidence = _calculateConfidence(features);

    return SpendingPrediction(
      currentSpending: features.currentSpending,
      predictedMonthEndSpending: predictedSpending,
      confidence: confidence,
    );
  }

  double _calculateConfidence(SpendingFeatures features) {
    if (features.transactionCount == 0) {
      return 0.0;
    }

    final historyScore = (features.daysElapsed / 30).clamp(0.0, 1.0);

    final transactionScore = (features.transactionCount / 20).clamp(0.0, 1.0);

    return ((historyScore + transactionScore) / 2).clamp(0.0, 1.0);
  }
}
