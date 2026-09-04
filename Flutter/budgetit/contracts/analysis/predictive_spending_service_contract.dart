import 'package:budgetit/models/monthly_spending_summary.dart';
import 'package:budgetit/models/spending_prediction.dart';

abstract interface class PredictiveSpendingServiceContract {
  SpendingPrediction? predict(List<MonthlySpendingSummary> history);

  SpendingPrediction? predictCurrentMonth(
    List<MonthlySpendingSummary> history, {
    double currentMonthActual = 0,
    int dayOfMonth = 1,
    int daysInMonth = 30,
  });
}
