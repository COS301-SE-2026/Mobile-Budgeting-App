// daos/budget_dao.dart
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import '../schema.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [BudgetTemplates, BudgetPeriods])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  final Uuid _uuid = const Uuid();

  BudgetDao(super.db);

  DateTime _now() => DateTime.now().toUtc();

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

  Future<BudgetTemplate?> getBudgetTemplateById(
    String id, {
    bool includeDeleted = false,
  }) {
    final q = select(budgetTemplates)..where((t) => t.id.equals(id));
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.getSingleOrNull();
  }

  Future<List<BudgetTemplate>> getAllBudgetTemplates({
    bool includeDeleted = false,
  }) {
    final q = select(budgetTemplates);
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
  }

  /// Returns a single budget template for the given category.
  /// Throws if more than one template exists for the same category.
  Future<BudgetTemplate?> getBudgetTemplateByCategory(
    String categoryId, {
    bool includeDeleted = false,
  }) {
    final q = select(budgetTemplates)
      ..where((t) => t.categoryId.equals(categoryId));
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.getSingleOrNull();
  }

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

  Future<void> softDeleteBudgetTemplate(String id) async {
    final now = _now();
    await (update(budgetTemplates)..where((t) => t.id.equals(id))).write(
      BudgetTemplatesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  Future<void> hardDeleteBudgetTemplate(String id) async {
    await (delete(budgetPeriods)..where((t) => t.templateId.equals(id))).go();
    await (delete(budgetTemplates)..where((t) => t.id.equals(id))).go();
  }

  Future<void> restoreBudgetTemplate(String id) async {
    await (update(budgetTemplates)..where((t) => t.id.equals(id))).write(
      BudgetTemplatesCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_now()),
      ),
    );
  }

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

  Future<BudgetPeriod?> getBudgetPeriodById(String id) {
    return (select(
      budgetPeriods,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<BudgetPeriod>> getBudgetPeriodsForTemplate(String templateId) {
    return (select(budgetPeriods)
          ..where((t) => t.templateId.equals(templateId))
          ..orderBy([(t) => OrderingTerm.asc(t.startDate)]))
        .get();
  }

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

  Future<void> hardDeleteBudgetPeriod(String id) async {
    await (delete(budgetPeriods)..where((t) => t.id.equals(id))).go();
  }
}
