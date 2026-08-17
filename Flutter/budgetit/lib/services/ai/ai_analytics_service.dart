import 'spending_feature_service.dart';
import 'spending_prediction.dart';
import 'spending_prediction_service.dart';

class AiAnalyticsService {
  AiAnalyticsService({
    required SpendingFeatureService featureService,
    required SpendingPredictionService predictionService,
  }) : _featureService = featureService,
       _predictionService = predictionService;

  final SpendingFeatureService _featureService;
  final SpendingPredictionService _predictionService;

  Future<SpendingPrediction> getSpendingPrediction({
    DateTime? referenceDate,
  }) async {
    final features = await _featureService.buildFeatures(
      referenceDate: referenceDate,
    );

    return _predictionService.predict(features);
  }
}
