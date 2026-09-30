import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:decimal/decimal.dart';

/// Data access for budget templates and the periods generated from them.
/// A [BudgetTemplate] is the standing rule — "R2000 a month for Groceries" —
/// and a [BudgetPeriod] is one concrete window generated from it, with its own
/// dates and amount. Separating the two lets a single month be overridden
/// without disturbing the rule.
/// Templates support soft deletion; periods are only ever hard-deleted, since
/// they can be regenerated from their template.
///
/// {@category DAOs}
abstract interface class BudgetDaoContract {
  /// Inserts a budget template for [categoryId] and returns the persisted
  /// record.
  ///
  ///  [amount] : the budget amount for one period
  ///  [periodType] : how often periods are generated
  ///  [currency] : ISO currency code, defaults to 'ZAR'
  Future<BudgetTemplate> insertBudgetTemplate({
    required String categoryId,
    required Decimal amount,
    required PeriodType periodType,
    String currency = 'ZAR',
  });

  /// Retrieves a budget template by [id].
  /// Returns 'null' if none exists, or if it is soft-deleted and
  /// [includeDeleted] is 'false'.
  Future<BudgetTemplate?> getBudgetTemplateById(
    String id, {
    bool includeDeleted = false,
  });

  /// Retrieves all budget templates.
  /// Soft-deleted templates are excluded unless [includeDeleted] is 'true'.
  Future<List<BudgetTemplate>> getAllBudgetTemplates({
    bool includeDeleted = false,
  });

  /// Returns the budget template for [categoryId], or 'null' if the category
  /// has no budget.
  /// Returns the first match if more than one exists.
  Future<BudgetTemplate?> getBudgetTemplateByCategory(
    String categoryId, {
    bool includeDeleted = false,
  });

  /// Updates the supplied fields of template [id] and returns the updated
  /// record.
  /// Only non-'null' parameters are written; the updated-at timestamp is
  /// always refreshed. Existing periods are not retrospectively changed.
  Future<BudgetTemplate> updateBudgetTemplate(
    String id, {
    Decimal? amount,
    PeriodType? periodType,
    String? currency,
  });

  /// Soft-deletes template [id] by stamping its deleted-at timestamp.
  /// Generated periods are left in place. Reverse with
  /// [restoreBudgetTemplate].
  Future<void> softDeleteBudgetTemplate(String id);

  /// Permanently removes template [id] together with every period generated
  /// from it, in one database transaction.
  /// This cannot be undone.
  Future<void> hardDeleteBudgetTemplate(String id);

  /// Restores a soft-deleted template by clearing its deleted-at timestamp.
  Future<void> restoreBudgetTemplate(String id);

  /// Inserts a budget period against [templateId] and returns it.
  ///
  ///  [startDate], [endDate] : the window this period covers
  ///  [budgetedAmount] : the amount allowed in this window, which may differ
  ///   from the template amount
  ///  [isOverridden] : marks the period as manually adjusted, so period
  ///   generation will not overwrite it
  Future<BudgetPeriod> insertBudgetPeriod({
    required String templateId,
    required DateTime startDate,
    required DateTime endDate,
    required Decimal budgetedAmount,
    bool isOverridden = false,
  });

  /// Retrieves a budget period by [id], or 'null' if none exists.
  Future<BudgetPeriod?> getBudgetPeriodById(String id);

  /// Returns every period generated from [templateId], earliest start date
  /// first.
  Future<List<BudgetPeriod>> getBudgetPeriodsForTemplate(String templateId);

  /// Returns the period of [templateId] that contains [date], or 'null' if
  /// none does.
  /// A period is active when its start date is at or before [date] and its
  /// end date at or after. Pass [date] in UTC, since period boundaries are
  /// stored in UTC.
  Future<BudgetPeriod?> getActiveBudgetPeriod(
    String templateId,
    DateTime date,
  );

  /// Generates and returns the next budget period for [templateId].
  /// If a period is already active for the current date it is returned
  /// unchanged, so calling this repeatedly will not create duplicates.
  ///
  /// Boundaries are computed in UTC from the template's period type: a
  /// calendar day, Monday-to-Sunday week, calendar month or calendar year,
  /// each running to 23:59:59.999 of its final day. The amount is taken from
  /// the template.
  /// Throws a [StateError] if [templateId] does not exist.
  Future<BudgetPeriod> generateNextBudgetPeriod(String templateId);

  /// Updates the supplied fields of period [id] and returns the updated
  /// record.
  /// Only non-'null' parameters are written; the updated-at timestamp is
  /// always refreshed.
  Future<BudgetPeriod> updateBudgetPeriod(
    String id, {
    Decimal? budgetedAmount,
    bool? isOverridden,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Permanently removes budget period [id].
  /// Periods have no soft delete, as they can be regenerated with
  /// [generateNextBudgetPeriod].
  Future<void> hardDeleteBudgetPeriod(String id);
}
