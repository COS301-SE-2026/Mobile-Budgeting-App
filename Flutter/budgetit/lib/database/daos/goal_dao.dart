// daos/goal_dao.dart
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import '../schema.dart';

part 'goal_dao.g.dart';

/// Data access object for income goals (goal templates and goal periods).
///
/// Goals mirror budgets but track an income target per period. [GoalDao]
/// manages goal template lifecycle and the generation of [GoalPeriods] from a
/// template's [PeriodType].
@DriftAccessor(tables: [GoalTemplates, GoalPeriods, GoalContributions])
class GoalDao extends DatabaseAccessor<AppDatabase> with _$GoalDaoMixin {
  /// Singleton UUID generator used to create unique identifiers.
  final Uuid _uuid = const Uuid();

  GoalDao(super.db);

  DateTime _now() => DateTime.now().toUtc();

  /// Inserts a new goal template for the given [categoryId].
  Future<GoalTemplate> insertGoalTemplate({
    String? categoryId,
    required Decimal targetAmount,
    required PeriodType periodType,
    String currency = 'ZAR',
    String? name,
  }) async {
    final id = _uuid.v4();
    final now = _now();
    await into(goalTemplates).insert(
      GoalTemplatesCompanion.insert(
        id: id,
        categoryId: Value(categoryId),
        targetAmount: targetAmount,
        periodType: periodType,
        currency: Value(currency),
        name: Value(name),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return (select(goalTemplates)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Retrieves a goal template by [id], excluding soft-deleted rows by default.
  Future<GoalTemplate?> getGoalTemplateById(
    String id, {
    bool includeDeleted = false,
  }) {
    final q = select(goalTemplates)..where((t) => t.id.equals(id));
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.getSingleOrNull();
  }

  /// Retrieves all goal templates, excluding soft-deleted rows by default.
  Future<List<GoalTemplate>> getAllGoalTemplates({
    bool includeDeleted = false,
  }) {
    final q = select(goalTemplates);
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
  }

  /// Returns the active goal template for the given [categoryId].
  Future<GoalTemplate?> getGoalTemplateByCategory(
    String categoryId, {
    bool includeDeleted = false,
  }) {
    final q = select(goalTemplates)
      ..where((t) => t.categoryId.equals(categoryId))
      ..limit(1);
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.getSingleOrNull();
  }

  /// Updates a goal template's fields.
  Future<GoalTemplate> updateGoalTemplate(
    String id, {
    Decimal? targetAmount,
    PeriodType? periodType,
    String? currency,
    String? name,
    String? categoryId,
    bool clearName = false,
    bool clearCategory = false,
  }) async {
    final companion = GoalTemplatesCompanion(
      targetAmount: targetAmount != null
          ? Value(targetAmount)
          : const Value.absent(),
      periodType: periodType != null ? Value(periodType) : const Value.absent(),
      currency: currency != null ? Value(currency) : const Value.absent(),
      name: clearName
          ? const Value(null)
          : name != null
          ? Value(name)
          : const Value.absent(),
      categoryId: clearCategory
          ? const Value(null)
          : categoryId != null
          ? Value(categoryId)
          : const Value.absent(),
      updatedAt: Value(_now()),
    );
    await (update(goalTemplates)..where((t) => t.id.equals(id))).write(companion);
    return (select(goalTemplates)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Soft-deletes a goal template.
  Future<void> softDeleteGoalTemplate(String id) async {
    final now = _now();
    await (update(goalTemplates)..where((t) => t.id.equals(id))).write(
      GoalTemplatesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  /// Hard-deletes a goal template and all associated periods and
  /// contributions.
  Future<void> hardDeleteGoalTemplate(String id) async {
    await db.transaction(() async {
      await (delete(
        goalContributions,
      )..where((t) => t.templateId.equals(id))).go();
      await (delete(goalPeriods)..where((t) => t.templateId.equals(id))).go();
      await (delete(goalTemplates)..where((t) => t.id.equals(id))).go();
    });
  }

  /// Restores a soft-deleted goal template.
  Future<void> restoreGoalTemplate(String id) async {
    await (update(goalTemplates)..where((t) => t.id.equals(id))).write(
      GoalTemplatesCompanion(
        deletedAt: const Value(null),
        updatedAt: Value(_now()),
      ),
    );
  }

  /// Inserts a new goal period linked to a [templateId].
  Future<GoalPeriod> insertGoalPeriod({
    required String templateId,
    required DateTime startDate,
    required DateTime endDate,
    required Decimal targetAmount,
    bool isOverridden = false,
  }) async {
    if (!endDate.isAfter(startDate)) {
      throw ArgumentError('endDate must be after startDate');
    }
    final id = _uuid.v4();
    final now = _now();
    await into(goalPeriods).insert(
      GoalPeriodsCompanion.insert(
        id: id,
        templateId: templateId,
        periodKey:
            '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}',
        startDate: startDate,
        endDate: endDate,
        targetAmount: targetAmount,
        isOverridden: isOverridden,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return (select(goalPeriods)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Retrieves a goal period by [id].
  Future<GoalPeriod?> getGoalPeriodById(String id) {
    return (select(goalPeriods)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Retrieves all goal periods for a template, ordered by start date.
  Future<List<GoalPeriod>> getGoalPeriodsForTemplate(String templateId) {
    return (select(goalPeriods)
          ..where((t) => t.templateId.equals(templateId))
          ..orderBy([(t) => OrderingTerm.asc(t.startDate)]))
        .get();
  }

  /// Returns the active goal period for a [templateId] at the given [date].
  Future<GoalPeriod?> getActiveGoalPeriod(String templateId, DateTime date) {
    return (select(goalPeriods)
          ..where(
            (t) =>
                t.templateId.equals(templateId) &
                t.startDate.isSmallerOrEqualValue(date) &
                t.endDate.isBiggerOrEqualValue(date),
          )
          ..limit(1))
        .getSingleOrNull();
  }

  /// Generates the next goal period for a template.
  Future<GoalPeriod> generateNextGoalPeriod(String templateId) async {
    final template = await getGoalTemplateById(templateId);
    if (template == null) {
      throw StateError('Goal template $templateId not found');
    }

    final now = DateTime.now().toUtc();
    final existing = await getActiveGoalPeriod(templateId, now);
    if (existing != null) return existing;

    final today = DateTime.utc(now.year, now.month, now.day);
    DateTime startDate, endDate;

    switch (template.periodType) {
      case PeriodType.daily:
        startDate = today;
        endDate = today
            .add(const Duration(days: 1))
            .subtract(const Duration(milliseconds: 1));
      case PeriodType.weekly:
        startDate = today.subtract(Duration(days: today.weekday - 1));
        endDate = startDate
            .add(const Duration(days: 7))
            .subtract(const Duration(milliseconds: 1));
      case PeriodType.monthly:
        startDate = DateTime.utc(now.year, now.month, 1);
        endDate = DateTime.utc(
          now.year,
          now.month + 1,
          1,
        ).subtract(const Duration(milliseconds: 1));
      case PeriodType.yearly:
        startDate = DateTime.utc(now.year, 1, 1);
        endDate = DateTime.utc(
          now.year + 1,
          1,
          1,
        ).subtract(const Duration(milliseconds: 1));
    }

    return insertGoalPeriod(
      templateId: templateId,
      startDate: startDate,
      endDate: endDate,
      targetAmount: template.targetAmount,
    );
  }

  /// Updates a goal period's fields.
  Future<GoalPeriod> updateGoalPeriod(
    String id, {
    Decimal? targetAmount,
    bool? isOverridden,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (startDate != null && endDate != null && !endDate.isAfter(startDate)) {
      throw ArgumentError('endDate must be after startDate');
    }
    final companion = GoalPeriodsCompanion(
      targetAmount: targetAmount != null
          ? Value(targetAmount)
          : const Value.absent(),
      isOverridden: isOverridden != null
          ? Value(isOverridden)
          : const Value.absent(),
      startDate: startDate != null ? Value(startDate) : const Value.absent(),
      endDate: endDate != null ? Value(endDate) : const Value.absent(),
      updatedAt: Value(_now()),
    );
    await (update(goalPeriods)..where((t) => t.id.equals(id))).write(companion);
    return (select(goalPeriods)..where((t) => t.id.equals(id))).getSingle();
  }

  /// Hard-deletes a goal period by [id].
  Future<void> hardDeleteGoalPeriod(String id) async {
    await (delete(goalPeriods)..where((t) => t.id.equals(id))).go();
  }

  Future<GoalContribution> insertGoalContribution({
    required String templateId,
    required Decimal amount,
    String? note,
    String? transactionId,
    DateTime? contributedAt,
  }) async {
    if (amount <= Decimal.zero) {
      throw ArgumentError('amount must be greater than zero');
    }
    final id = _uuid.v4();
    final now = _now();
    await into(goalContributions).insert(
      GoalContributionsCompanion.insert(
        id: id,
        templateId: templateId,
        amount: amount,
        note: Value(note),
        transactionId: Value(transactionId),
        contributedAt: contributedAt?.toUtc() ?? now,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return (select(
      goalContributions,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  Future<List<GoalContribution>> getContributionsForTemplate(
    String templateId, {
    bool includeDeleted = false,
  }) {
    final q = select(goalContributions)
      ..where((t) => t.templateId.equals(templateId))
      ..orderBy([(t) => OrderingTerm.desc(t.contributedAt)]);
    if (!includeDeleted) q.where((t) => t.deletedAt.isNull());
    return q.get();
  }

  Future<Decimal> getTotalSavedForTemplate(String templateId) async {
    final rows = await getContributionsForTemplate(templateId);
    return rows.fold<Decimal>(Decimal.zero, (sum, row) => sum + row.amount);
  }

  Future<void> softDeleteGoalContribution(String id) async {
    final now = _now();
    await (update(goalContributions)..where((t) => t.id.equals(id))).write(
      GoalContributionsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  Future<void> clearContributionsForTemplate(String templateId) async {
    final now = _now();
    await (update(goalContributions)..where(
          (t) => t.templateId.equals(templateId) & t.deletedAt.isNull(),
        ))
        .write(
          GoalContributionsCompanion(
            deletedAt: Value(now),
            updatedAt: Value(now),
          ),
        );
  }
}
