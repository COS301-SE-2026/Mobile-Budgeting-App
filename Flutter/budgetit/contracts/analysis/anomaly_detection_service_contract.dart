import 'package:budgetit/models/anomaly_result.dart';
import 'package:budgetit/models/monthly_spending_summary.dart';

abstract interface class AnomalyDetectionServiceContract {
  List<AnomalyResult> detect(List<MonthlySpendingSummary> history);
}
