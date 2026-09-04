import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:decimal/decimal.dart';

abstract interface class BudgetDaoContract {
  Future<BudgetTemplate> insertBudgetTemplate({
    required String categoryId,
    required Decimal amount,
    required PeriodType periodType,
    String currency = 'ZAR',
  });

  Future<BudgetTemplate?> getBudgetTemplateById(
    String id, {
    bool includeDeleted = false,
  });

  Future<List<BudgetTemplate>> getAllBudgetTemplates({
    bool includeDeleted = false,
  });

  Future<BudgetTemplate?> getBudgetTemplateByCategory(
    String categoryId, {
    bool includeDeleted = false,
  });

  Future<BudgetTemplate> updateBudgetTemplate(
    String id, {
    Decimal? amount,
    PeriodType? periodType,
    String? currency,
  });

  Future<void> softDeleteBudgetTemplate(String id);

  Future<void> hardDeleteBudgetTemplate(String id);

  Future<void> restoreBudgetTemplate(String id);

  Future<BudgetPeriod> insertBudgetPeriod({
    required String templateId,
    required DateTime startDate,
    required DateTime endDate,
    required Decimal budgetedAmount,
    bool isOverridden = false,
  });

  Future<BudgetPeriod?> getBudgetPeriodById(String id);

  Future<List<BudgetPeriod>> getBudgetPeriodsForTemplate(String templateId);

  Future<BudgetPeriod?> getActiveBudgetPeriod(
    String templateId,
    DateTime date,
  );

  Future<BudgetPeriod> generateNextBudgetPeriod(String templateId);

  Future<BudgetPeriod> updateBudgetPeriod(
    String id, {
    Decimal? budgetedAmount,
    bool? isOverridden,
    DateTime? startDate,
    DateTime? endDate,
  });

  Future<void> hardDeleteBudgetPeriod(String id);
}
