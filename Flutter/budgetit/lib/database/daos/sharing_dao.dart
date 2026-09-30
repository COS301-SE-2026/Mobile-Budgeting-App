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

  Future<BudgetMember?> getBudgetMember(
    String budgetTemplateId,
    String userId,
  ) {
    return (select(budgetMembers)..where(
          (t) =>
              t.budgetTemplateId.equals(budgetTemplateId) &
              t.userId.equals(userId) &
              t.deletedAt.isNull(),
        ))
        .getSingleOrNull();
  }

  Future<List<BudgetMember>> getBudgetMembers(String budgetTemplateId) {
    return (select(budgetMembers)..where(
          (t) =>
              t.budgetTemplateId.equals(budgetTemplateId) &
              t.deletedAt.isNull(),
        ))
        .get();
  }

  Future<void> removeBudgetMember(
    String budgetTemplateId,
    String userId,
  ) async {
    final now = _now();
    await (update(budgetMembers)..where(
          (t) =>
              t.budgetTemplateId.equals(budgetTemplateId) &
              t.userId.equals(userId),
        ))
        .write(
          BudgetMembersCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
  }

  /// Returns the number of budget members.
  /// Includes soft-deleted rows.
  Future<int> countBudgetMembers() async {
    final members = await select(budgetMembers).get();
    return members.length;
  }

  /// Hard deletes all budget memberships.
  Future<void> deleteAllBudgetMembers() async {
    await delete(budgetMembers).go();
  }

  // ── Goals ──

  Future<GoalMember> inviteToGoal({
    required String goalTemplateId,
    required String inviteeId,
    required String invitedBy,
  }) async {
    if (inviteeId == invitedBy) {
      throw ArgumentError('You cannot invite yourself to a goal');
    }
    final existing = await getGoalMember(goalTemplateId, inviteeId);
    if (existing != null) return existing;

    final id = _uuid.v4();
    final now = _now();
    await into(goalMembers).insert(
      GoalMembersCompanion.insert(
        id: id,
        goalTemplateId: goalTemplateId,
        userId: Value(inviteeId),
        status: const Value(GoalMemberStatus.pending),
        invitedBy: Value(invitedBy),
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
          )
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<GoalMember>> getGoalMembers(String goalTemplateId) {
    return (select(goalMembers)
          ..where(
            (t) =>
                t.goalTemplateId.equals(goalTemplateId) & t.deletedAt.isNull(),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<Map<String, List<GoalMember>>> getGoalMembersForTemplates(
    Iterable<String> goalTemplateIds,
  ) async {
    final ids = goalTemplateIds.toList();
    if (ids.isEmpty) return {};
    final rows =
        await (select(goalMembers)
              ..where((t) => t.goalTemplateId.isIn(ids) & t.deletedAt.isNull())
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
            .get();
    final byTemplate = <String, List<GoalMember>>{};
    for (final row in rows) {
      byTemplate.putIfAbsent(row.goalTemplateId, () => []).add(row);
    }
    return byTemplate;
  }

  Future<List<GoalMember>> getPendingGoalInvites(String userId) {
    return (select(goalMembers)
          ..where(
            (t) =>
                t.userId.equals(userId) &
                t.status.equalsValue(GoalMemberStatus.pending) &
                t.deletedAt.isNull(),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<void> respondToGoalInvite(
    String memberId, {
    required bool accept,
  }) async {
    final now = _now();
    await (update(goalMembers)..where(
          (t) =>
              t.id.equals(memberId) &
              t.status.equalsValue(GoalMemberStatus.pending) &
              t.deletedAt.isNull(),
        ))
        .write(
          GoalMembersCompanion(
            status: Value(
              accept ? GoalMemberStatus.accepted : GoalMemberStatus.declined,
            ),
            deletedAt: accept ? const Value.absent() : Value(now),
            updatedAt: Value(now),
          ),
        );
  }

  Future<void> removeGoalMember(String goalTemplateId, String userId) async {
    final now = _now();
    await (update(goalMembers)..where(
          (t) =>
              t.goalTemplateId.equals(goalTemplateId) &
              t.userId.equals(userId) &
              t.deletedAt.isNull(),
        ))
        .write(
          GoalMembersCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
  }
}
