// daos/sharing_dao.dart
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import '../schema.dart';

part 'sharing_dao.g.dart';

/// Data access object for sharing budgets and goals with co-owners.
///
/// The template owner is identified by `user_id` on the template row; these
/// membership rows hold the additional participants (equal co-owners).
@DriftAccessor(tables: [BudgetMembers, GoalMembers])
class SharingDao extends DatabaseAccessor<AppDatabase> with _$SharingDaoMixin {
  final Uuid _uuid = const Uuid();

  SharingDao(super.db);

  DateTime _now() => DateTime.now().toUtc();

  // ── Budgets ──

  /// Adds [userId] as a co-owner of the budget template (idempotent).
  Future<BudgetMember> addBudgetMember({
    required String budgetTemplateId,
    required String userId,
  }) async {
    final existing = await getBudgetMember(budgetTemplateId, userId);
    if (existing != null) return existing;

    final id = _uuid.v4();
    final now = _now();
    await into(budgetMembers).insert(
      BudgetMembersCompanion.insert(
        id: id,
        budgetTemplateId: budgetTemplateId,
        userId: Value(userId),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return (select(budgetMembers)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<BudgetMember?> getBudgetMember(String budgetTemplateId, String userId) {
    return (select(budgetMembers)
          ..where(
            (t) =>
                t.budgetTemplateId.equals(budgetTemplateId) &
                t.userId.equals(userId) &
                t.deletedAt.isNull(),
          ))
        .getSingleOrNull();
  }

  Future<List<BudgetMember>> getBudgetMembers(String budgetTemplateId) {
    return (select(budgetMembers)
          ..where(
            (t) =>
                t.budgetTemplateId.equals(budgetTemplateId) &
                t.deletedAt.isNull(),
          ))
        .get();
  }

  Future<void> removeBudgetMember(String budgetTemplateId, String userId) async {
    final now = _now();
    await (update(budgetMembers)
          ..where(
            (t) =>
                t.budgetTemplateId.equals(budgetTemplateId) &
                t.userId.equals(userId),
          ))
        .write(
      BudgetMembersCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }

  // ── Goals ──

  /// Adds [userId] as a co-owner of the goal template (idempotent).
  Future<GoalMember> addGoalMember({
    required String goalTemplateId,
    required String userId,
  }) async {
    final existing = await getGoalMember(goalTemplateId, userId);
    if (existing != null) return existing;

    final id = _uuid.v4();
    final now = _now();
    await into(goalMembers).insert(
      GoalMembersCompanion.insert(
        id: id,
        goalTemplateId: goalTemplateId,
        userId: Value(userId),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return (select(goalMembers)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<GoalMember?> getGoalMember(String goalTemplateId, String userId) {
    return (select(goalMembers)
          ..where(
            (t) =>
                t.goalTemplateId.equals(goalTemplateId) &
                t.userId.equals(userId) &
                t.deletedAt.isNull(),
          ))
        .getSingleOrNull();
  }

  Future<List<GoalMember>> getGoalMembers(String goalTemplateId) {
    return (select(goalMembers)
          ..where(
            (t) =>
                t.goalTemplateId.equals(goalTemplateId) &
                t.deletedAt.isNull(),
          ))
        .get();
  }

  Future<void> removeGoalMember(String goalTemplateId, String userId) async {
    final now = _now();
    await (update(goalMembers)
          ..where(
            (t) =>
                t.goalTemplateId.equals(goalTemplateId) &
                t.userId.equals(userId),
          ))
        .write(
      GoalMembersCompanion(deletedAt: Value(now), updatedAt: Value(now)),
    );
  }
}
