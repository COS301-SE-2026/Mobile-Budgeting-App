import 'package:budgetit/models/financial_health_score.dart';

abstract interface class FinancialHealthScoreServiceContract {
  Future<FinancialHealthScore> calculateMonthlyScore();
}
