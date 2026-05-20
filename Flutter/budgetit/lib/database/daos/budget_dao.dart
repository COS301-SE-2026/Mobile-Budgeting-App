// daos/budget_dao.dart
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import '../schema.dart';

part 'budget_dao.g.dart';

/// Data access object for budget templates and budget periods.
///
/// [BudgetDao] manages budget template lifecycle and the generation of
/// budget periods based on a template's [PeriodType]. Budget templates
/// define how much should be budgeted per time period (daily, weekly,
/// monthly, or yearly) for a given category.
///
/// Budget periods are generated from a template and can be overridden
/// manually for a specific period without affecting the template.
///
/// Soft deletes are supported for budget templates via [softDeleteBudgetTemplate],
/// which marks records as deleted without removing them from the database.
///
/// Usage:
/// ```dart
/// final dao = BudgetDao(database);
/// final template = await dao.insertBudgetTemplate(
///   categoryId: 'food',
///   amount: Decimal.parse('500.00'),
///   periodType: PeriodType.monthly,
/// );
/// final period = await dao.generateNextBudgetPeriod(template.id);
/// ```
@DriftAccessor(tables: [BudgetTemplates, BudgetPeriods])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  /// Singleton UUID generator used to create unique identifiers
  /// for templates and periods.
  final Uuid _uuid = const Uuid();

  BudgetDao(super.db);

  /// Returns the current UTC time.
  DateTime _now() => DateTime.now().toUtc();

  /// Inserts a new budget template for the given [categoryId].
  ///
  /// Generates a new UUID for the template and returns the persisted
  /// [BudgetTemplate] record.
  ///
  /// - [categoryId] - the category this budget template applies to
  /// - [amount] - the budget amount for the period
  /// - [periodType] - the frequency at which to generate budget periods
  /// - [currency] - the currency code (defaults to 'ZAR')
  Future<BudgetTemplate> insertBudgetTemplate({
    required String categoryId,
    required Decimal amount,
    required PeriodType periodType,
    String currency = 'ZAR',
  }) async {
    final id = _uuid.v4();
    final now = _now();
    await into(budgetTemplates).insert(
      BudgetTemplatesCompanion.insert(
        id: id,
        categoryId: categoryId,
        amount: amount,
        periodType: periodType,
        currency: Value(currency),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return (select(budgetTemplates)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Retrieves a single budget template by its [id].
  ///
  /// Returns `null` if no template exists with the given ID or if the
  /// template has been soft-deleted and [includeDeleted] is `false`.
  ///
  /// - [id] - the unique identifier of the template
  /// - [includeDeleted] - if `true`, includes soft-deleted templates
  ///   (defaults to `false`)
  Future<BudgetTemplate?> getBudgetTemplateById(
    String id, {
    bool includeDeleted = false,
  }) {
    final q = select(budgetTemplates)..where((t) => t.id.equals(id));
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.getSingleOrNull();
  }

  /// Retrieves all budget templates.
  ///
  /// By default, soft-deleted templates are excluded. Use [includeDeleted]
  /// to include soft-deleted templates.
  ///
  /// - [includeDeleted] - if `true`, includes soft-deleted templates
  ///   (defaults to `false`)
  Future<List<BudgetTemplate>> getAllBudgetTemplates({
    bool includeDeleted = false,
  }) {
    final q = select(budgetTemplates);
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
  }

  /// Returns the active budget template for the given [categoryId].
  ///
  /// Only returns the first matching template (if one exists). Throws
  /// if more than one active template exists for the same category.
  ///
  /// - [categoryId] - the category identifier to look up
  /// - [includeDeleted] - if `true`, includes soft-deleted templates
  ///   (defaults to `false`)
  Future<BudgetTemplate?> getBudgetTemplateByCategory(
    String categoryId, {
    bool includeDeleted = false,
  }) {
    final q = select(budgetTemplates)
      ..where((t) => t.categoryId.equals(categoryId));
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.getSingleOrNull();
  }

  /// Updates a budget template's fields.
  ///
  /// Only provided non-`null` parameters are updated. The
  /// [BudgetTemplate.updatedAt] timestamp is always refreshed.
  ///
  /// Returns the updated [BudgetTemplate].
  Future<BudgetTemplate> updateBudgetTemplate(
    String id, {
    Decimal? amount,
    PeriodType? periodType,
    String? currency,
  }) async {
    final companion = BudgetTemplatesCompanion(
      amount: amount != null ? Value(amount) : const Value.absent(),
      periodType: periodType != null ? Value(periodType) : const Value.absent(),
      currency: currency != null ? Value(currency) : const Value.absent(),
      updatedAt: Value(_now()),
    );
    await (update(
      budgetTemplates,
    )..where((t) => t.id.equals(id))).write(companion);
    return (select(budgetTemplates)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Soft-deletes a budget template by marking [id] with a [deletedAt] timestamp.
  ///
  /// The template is not actually removed from the database. It will be
  /// excluded from query results unless [getBudgetTemplateById] or
  /// [getAllBudgetTemplates] are called with [includeDeleted] = `true`.
  Future<void> softDeleteBudgetTemplate(String id) async {
    final now = _now();
    await (update(budgetTemplates)..where((t) => t.id.equals(id))).write(
      BudgetTemplatesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  /// Hard-deletes a budget template and all associated [BudgetPeriod]s.
  ///
  /// This permanently removes both the template record and any generated
  /// budget periods for that template.
  Future<void> hardDeleteBudgetTemplate(String id) async {
    await (delete(budgetPeriods)..where((t) => t.templateId.equals(id))).go();
    await (delete(budgetTemplates)..where((t) => t.id.equals(id))).go();
  }

  /// Restores a soft-deleted budget template by clearing its [deletedAt] timestamp.
  ///
  /// The template becomes visible in queries again after restoration.
  Future<void> restoreBudgetTemplate(String id) async {
    await (update(budgetTemplates)..where((t) => t.id.equals(id))).write(
      BudgetTemplatesCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_now()),
      ),
    );
  }

  /// Inserts a new budget period linked to a [templateId].
  ///
  /// - [templateId] - the template this period belongs to
  /// - [startDate] - start of the budgeting period
  /// - [endDate] - end of the budgeting period
  /// - [budgetedAmount] - amount budgeted for this period
  /// - [isOverridden] - if `true`, indicates this period has been manually
  ///   overridden (defaults to `false`)
  Future<BudgetPeriod> insertBudgetPeriod({
    required String templateId,
    required DateTime startDate,
    required DateTime endDate,
    required Decimal budgetedAmount,
    bool isOverridden = false,
  }) async {
    final id = _uuid.v4();
    final now = _now();
    await into(budgetPeriods).insert(
      BudgetPeriodsCompanion.insert(
        id: id,
        templateId: templateId,
        startDate: startDate,
        endDate: endDate,
        budgetedAmount: budgetedAmount,
        isOverridden: isOverridden,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return (select(budgetPeriods)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Retrieves a single budget period by its [id].
  ///
  /// Returns `null` if no period exists with the given ID.
  Future<BudgetPeriod?> getBudgetPeriodById(String id) {
    return (select(
      budgetPeriods,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Retrieves all budget periods for a given template, ordered by [BudgetPeriod.startDate] ascending.
  ///
  /// - [templateId] - the template identifier
  Future<List<BudgetPeriod>> getBudgetPeriodsForTemplate(String templateId) {
    return (select(budgetPeriods)
          ..where((t) => t.templateId.equals(templateId))
          ..orderBy([(t) => OrderingTerm.asc(t.startDate)]))
        .get();
  }

  /// Returns the active budget period for a [templateId] at the given [date].
  ///
  /// The active period is the one where [startDate] <= [date] <= [endDate].
  ///
  /// Returns `null` if no period is active for the given [date].
  Future<BudgetPeriod?> getActiveBudgetPeriod(
    String templateId,
    DateTime date,
  ) {
    return (select(budgetPeriods)..where(
          (t) =>
              t.templateId.equals(templateId) &
              t.startDate.isSmallerOrEqualValue(date) &
              t.endDate.isBiggerOrEqualValue(date),
        ))
        .getSingleOrNull();
  }

  /// Generates the next budget period for a template.
  ///
  /// Calculates the start and end dates based on the template's
  /// [PeriodType]:
  /// - [PeriodType.daily] - same day until end of day
  /// - [PeriodType.weekly] - Monday to Sunday of current week
  /// - [PeriodType.monthly] - 1st to last day of current month
  /// - [PeriodType.yearly] - January 1st to December 31st of current year
  ///
  /// The [budgetedAmount] is taken from the template's [BudgetTemplate.amount].
  ///
  /// Throws a [StateError] if the template does not exist.
  Future<BudgetPeriod> generateNextBudgetPeriod(String templateId) async {
    final template = await getBudgetTemplateById(templateId);
    if (template == null) {
      throw StateError('Budget template $templateId not found');
    }

    final effectiveDate = DateTime.now();
    DateTime startDate, endDate;

    switch (template.periodType) {
      case PeriodType.daily:
        startDate = effectiveDate;
        endDate = effectiveDate
            .add(const Duration(days: 1))
            .subtract(const Duration(microseconds: 1));
        break;
      case PeriodType.weekly:
        startDate = effectiveDate.subtract(
          Duration(days: effectiveDate.weekday - 1),
        );
        endDate = startDate
            .add(const Duration(days: 6))
            .subtract(const Duration(microseconds: 1));
        break;
      case PeriodType.monthly:
        startDate = DateTime(effectiveDate.year, effectiveDate.month, 1);
        endDate = DateTime(
          effectiveDate.year,
          effectiveDate.month + 1,
          0,
        ).subtract(const Duration(microseconds: 1));
        break;
      case PeriodType.yearly:
        startDate = DateTime(effectiveDate.year);
        endDate = DateTime(
          effectiveDate.year + 1,
          1,
          0,
        ).subtract(const Duration(microseconds: 1));
        break;
    }

    return insertBudgetPeriod(
      templateId: templateId,
      startDate: startDate,
      endDate: endDate,
      budgetedAmount: template.amount,
    );
  }

  /// Updates a budget period's fields.
  ///
  /// Only provided non-`null` parameters are updated. The
  /// [BudgetPeriod.updatedAt] timestamp is always refreshed.
  ///
  /// - [id] - the period to update
  /// - [budgetedAmount] - new budgeted amount
  /// - [isOverridden] - override status
  /// - [startDate] - new start date
  /// - [endDate] - new end date
  ///
  /// Returns the updated [BudgetPeriod].
  Future<BudgetPeriod> updateBudgetPeriod(
    String id, {
    Decimal? budgetedAmount,
    bool? isOverridden,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final companion = BudgetPeriodsCompanion(
      budgetedAmount: budgetedAmount != null
          ? Value(budgetedAmount)
          : const Value.absent(),
      isOverridden: isOverridden != null
          ? Value(isOverridden)
          : const Value.absent(),
      startDate: startDate != null ? Value(startDate) : const Value.absent(),
      endDate: endDate != null ? Value(endDate) : const Value.absent(),
      updatedAt: Value(_now()),
    );
    await (update(
      budgetPeriods,
    )..where((t) => t.id.equals(id))).write(companion);
    return (select(budgetPeriods)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Hard-deletes a budget period by its [id].
  Future<void> hardDeleteBudgetPeriod(String id) async {
    await (delete(budgetPeriods)..where((t) => t.id.equals(id))).go();
  }
}
