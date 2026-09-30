import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/shared/widgets/goals_page.dart';
import 'package:decimal/decimal.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/mock_db.dart';

const me = 'user-me';
const friend = 'user-friend';
const stranger = 'user-stranger';
const friendCode = 'FRIEND01';

class _FakeAuthUser extends Fake implements AuthUser {
  @override
  String get userId => me;
}

class _FakeAuthPlugin extends AuthPluginInterface {
  @override
  Future<AuthUser> getCurrentUser({GetCurrentUserOptions? options}) async =>
      _FakeAuthUser();
}

void main() {
  setUpAll(() => Amplify.addPlugin(_FakeAuthPlugin()));
  tearDownAll(() => Amplify.reset());

  late AppDatabase db;
  late BudgetTemplate budget;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await db.createMigrator().createAll();
    budget = await db.budgetDao.getOrCreateDefaultBudget();
  });

  tearDown(() => db.close());

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> pumpPage(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 2800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(wrapWithProviders(const GoalsPage(), db: db));
    await settle(tester);
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 5));
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    await tester.ensureVisible(find.text(text).last);
    await tester.tap(find.text(text).last);
    await settle(tester);
  }

  Future<GoalTemplate> seedGoal({
    String name = 'Laptop',
    String target = '1500',
    String? ownerId,
  }) async {
    final template = await db.goalDao.insertGoalTemplate(
      name: name,
      targetAmount: Decimal.parse(target),
      periodType: PeriodType.monthly,
    );
    if (ownerId == null) return template;
    await (db.update(db.goalTemplates)..where((t) => t.id.equals(template.id)))
        .write(GoalTemplatesCompanion(userId: Value(ownerId)));
    return (await db.goalDao.getGoalTemplateById(template.id))!;
  }

  Future<GoalContribution> seedContribution(
    GoalTemplate goal,
    String amount, {
    String? userId = me,
    DateTime? at,
  }) async {
    final transaction = await db.transactionDao.insertTransaction(
      amount: Decimal.parse(amount),
      type: TransactionType.expense,
      budgetTemplateId: budget.id,
      shortDescription: 'Goal: ${goal.name}',
      transactionDate: DateTime.utc(2026),
      source: TransactionSource.manual,
    );
    return db.goalDao.insertGoalContribution(
      templateId: goal.id,
      amount: Decimal.parse(amount),
      transactionId: transaction.id,
      userId: userId,
      contributedAt: at ?? DateTime.utc(2026),
    );
  }

  Future<void> seedFriend({String userId = friend, String code = friendCode}) {
    return db.transaction(() async {
      final pair = [me, userId]..sort();
      await db
          .into(db.friendships)
          .insert(
            FriendshipsCompanion.insert(
              id: 'friendship-$userId',
              userA: pair.first,
              userB: pair.last,
              createdAt: DateTime.utc(2026),
              updatedAt: DateTime.utc(2026),
            ),
          );
      await db
          .into(db.userProfiles)
          .insert(
            UserProfilesCompanion.insert(
              id: 'profile-$userId',
              userId: Value(userId),
              friendCode: code,
              createdAt: DateTime.utc(2026),
              updatedAt: DateTime.utc(2026),
            ),
          );
    });
  }

  Future<GoalMember> seedMember(
    GoalTemplate goal,
    String userId, {
    GoalMemberStatus status = GoalMemberStatus.accepted,
    String invitedBy = me,
  }) async {
    final id = 'member-${goal.id}-$userId';
    await db
        .into(db.goalMembers)
        .insert(
          GoalMembersCompanion.insert(
            id: id,
            goalTemplateId: goal.id,
            userId: Value(userId),
            status: Value(status),
            invitedBy: Value(invitedBy),
            createdAt: DateTime.utc(2026),
            updatedAt: DateTime.utc(2026),
          ),
        );
    return (db.select(
      db.goalMembers,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  Future<GoalMember> memberRow(String id) {
    return (db.select(
      db.goalMembers,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  group('solo goals', () {
    testWidgets('shows the empty state', (tester) async {
      await pumpPage(tester);

      expect(find.text('SAVINGS GOALS'), findsOneWidget);
      expect(find.text('TOTAL SAVED'), findsOneWidget);
      expect(find.text('CREATE NEW GOAL'), findsOneWidget);
      expect(find.textContaining('No goals yet'), findsOneWidget);
      expect(find.text('GOAL INVITES'), findsNothing);

      await finish(tester);
    });

    testWidgets('creates a goal from the dialog', (tester) async {
      await pumpPage(tester);

      await tapText(tester, 'CREATE NEW GOAL');
      expect(find.text('NEW GOAL'), findsOneWidget);
      expect(find.text('SHARE WITH FRIENDS (OPTIONAL)'), findsNothing);
      await tester.enterText(
        find.widgetWithText(TextField, 'Goal name'),
        'Laptop',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Target amount'),
        '1500',
      );
      await tapText(tester, 'Create');

      final templates = await db.goalDao.getAllGoalTemplates();
      expect(templates.single.name, 'Laptop');
      expect(templates.single.targetAmount, Decimal.parse('1500'));
      expect(find.text('Laptop'), findsOneWidget);
      expect(find.text('R0 / R1500'), findsOneWidget);
      expect(find.text('Monthly Goal'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('rejects an invalid target amount', (tester) async {
      await pumpPage(tester);

      await tapText(tester, 'CREATE NEW GOAL');
      await tester.enterText(
        find.widgetWithText(TextField, 'Target amount'),
        'abc',
      );
      await tapText(tester, 'Create');

      expect(
        find.text('Enter a target amount greater than zero.'),
        findsOneWidget,
      );
      expect(await db.goalDao.getAllGoalTemplates(), isEmpty);

      await finish(tester);
    });

    testWidgets('allocates money and records who put it in', (tester) async {
      final goal = await seedGoal();
      await pumpPage(tester);

      await tapText(tester, 'ALLOCATE');
      expect(find.text('ALLOCATE TO LAPTOP'), findsOneWidget);
      await tester.enterText(find.widgetWithText(TextField, 'Amount'), '200');
      await tester.enterText(
        find.widgetWithText(TextField, 'Note (optional)'),
        'Payday',
      );
      await tapText(tester, 'Allocate');

      final contributions = await db.goalDao.getContributionsForTemplate(
        goal.id,
      );
      expect(contributions.single.amount, Decimal.parse('200'));
      expect(contributions.single.userId, me);
      expect(contributions.single.note, 'Payday');
      final transactions = await db.transactionDao.getAllTransactions();
      expect(transactions.single.type, TransactionType.expense);
      expect(transactions.single.id, contributions.single.transactionId);
      expect(find.text('R200.00 allocated to Laptop.'), findsOneWidget);
      expect(find.text('R200 / R1500'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('rejects an invalid allocation', (tester) async {
      final goal = await seedGoal();
      await pumpPage(tester);

      await tapText(tester, 'ALLOCATE');
      await tester.enterText(find.widgetWithText(TextField, 'Amount'), '0');
      await tapText(tester, 'Allocate');

      expect(find.text('Enter an amount greater than zero.'), findsOneWidget);
      expect(await db.goalDao.getContributionsForTemplate(goal.id), isEmpty);

      await finish(tester);
    });

    testWidgets('details show history and undo removes it', (tester) async {
      final goal = await seedGoal();
      final contribution = await seedContribution(goal, '300');
      await pumpPage(tester);

      await tapText(tester, 'Laptop');
      expect(find.text('LAPTOP'), findsOneWidget);
      expect(find.text('ALLOCATION HISTORY'), findsOneWidget);
      expect(find.text('MEMBERS'), findsOneWidget);
      expect(find.text('OWNER'), findsOneWidget);
      expect(find.text('R300.00'), findsWidgets);
      expect(find.text('Saved by you'), findsNothing);
      expect(find.text('At this rate'), findsOneWidget);
      expect(find.text('Leave'), findsNothing);

      await tester.tap(find.byTooltip('Undo this allocation'));
      await settle(tester);

      expect(await db.goalDao.getContributionsForTemplate(goal.id), isEmpty);
      expect(
        await db.transactionDao.getTransactionById(contribution.transactionId!),
        isNull,
      );
      expect(find.text('Allocation removed.'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('releasing funds books the savings back', (tester) async {
      final goal = await seedGoal();
      await seedContribution(goal, '300');
      await pumpPage(tester);

      await tapText(tester, 'Laptop');
      await tapText(tester, 'Release funds');
      expect(find.textContaining('the goal will reset to zero'), findsOne);
      await tapText(tester, 'Release');

      expect(await db.goalDao.getContributionsForTemplate(goal.id), isEmpty);
      expect(await db.goalDao.getGoalTemplateById(goal.id), isNotNull);
      final income = await db.transactionDao.getTransactionsByType(
        TransactionType.income,
      );
      expect(income.single.amount, Decimal.parse('300'));
      expect(find.text('R300.00 returned to income.'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('deletes a goal and returns its savings', (tester) async {
      final goal = await seedGoal();
      await seedContribution(goal, '120');
      await pumpPage(tester);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await settle(tester);
      expect(find.text('DELETE GOAL'), findsOneWidget);
      expect(find.textContaining('R120.00 set aside'), findsOneWidget);
      await tapText(tester, 'Delete');

      expect(await db.goalDao.getGoalTemplateById(goal.id), isNull);
      expect(find.text('R120.00 returned to income.'), findsOneWidget);
      expect(find.textContaining('No goals yet'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('deleting an empty goal just removes it', (tester) async {
      final goal = await seedGoal();
      await pumpPage(tester);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await settle(tester);
      await tapText(tester, 'Delete');

      expect(await db.goalDao.getGoalTemplateById(goal.id), isNull);
      expect(find.text('Goal deleted.'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('edits an existing goal', (tester) async {
      final goal = await seedGoal();
      await pumpPage(tester);

      await tapText(tester, 'Laptop');
      await tapText(tester, 'Edit');
      expect(find.text('EDIT GOAL'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextField, 'Goal name'),
        'Gaming PC',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Target amount'),
        '2000',
      );
      await tapText(tester, 'Save');

      final updated = await db.goalDao.getGoalTemplateById(goal.id);
      expect(updated!.name, 'Gaming PC');
      expect(updated.targetAmount, Decimal.parse('2000'));
      expect(find.text('Gaming PC'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('views, reached goals and search filter', (tester) async {
      final done = await seedGoal(name: 'Phone', target: '100');
      await seedContribution(done, '100');
      final open = await seedGoal(name: 'Bike', target: '1000');
      await seedContribution(open, '100');
      await pumpPage(tester);

      expect(find.text('GOAL REACHED'), findsOneWidget);
      expect(find.text('1 OF 2 GOALS REACHED'), findsOneWidget);
      expect(find.text('100% · Goal reached'), findsOneWidget);
      expect(find.text('10% · R900.00 to go'), findsOneWidget);

      await tester.tap(find.text('REACHED').first);
      await settle(tester);
      expect(find.text('Phone'), findsOneWidget);
      expect(find.text('Bike'), findsNothing);

      await tester.tap(find.text('NEWEST'));
      await settle(tester);
      expect(find.text('Bike'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'zzz');
      await settle(tester);
      expect(find.text('No goals match "zzz".'), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, 'bik');
      await settle(tester);
      expect(find.text('Bike'), findsOneWidget);
      expect(find.text('Phone'), findsNothing);

      await finish(tester);
    });

    testWidgets('reached view shows an empty message', (tester) async {
      await seedGoal();
      await pumpPage(tester);

      await tester.tap(find.text('REACHED'));
      await settle(tester);

      expect(
        find.text('No goals reached yet. Keep allocating.'),
        findsOneWidget,
      );

      await finish(tester);
    });

    testWidgets('refreshes when data changes underneath it', (tester) async {
      final goal = await seedGoal();
      await pumpPage(tester);
      expect(find.text('R0 / R1500'), findsOneWidget);

      await seedContribution(goal, '500', userId: friend);
      await settle(tester);

      expect(find.text('R500 / R1500'), findsOneWidget);

      await finish(tester);
    });
  });

  group('sharing a goal', () {
    testWidgets('creates a goal shared with a friend', (tester) async {
      await seedFriend();
      await pumpPage(tester);

      await tapText(tester, 'CREATE NEW GOAL');
      expect(find.text('SHARE WITH FRIENDS (OPTIONAL)'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextField, 'Goal name'),
        'Holiday',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Target amount'),
        '8000',
      );
      await tapText(tester, 'Friend $friendCode');
      await tapText(tester, 'Create');

      final template = (await db.goalDao.getAllGoalTemplates()).single;
      final members = await db.sharingDao.getGoalMembers(template.id);
      expect(members.single.userId, friend);
      expect(members.single.status, GoalMemberStatus.pending);
      expect(members.single.invitedBy, me);
      expect(find.text('Goal created. Invite sent.'), findsOneWidget);
      expect(find.text('SHARED · 1'), findsOneWidget);
      expect(find.text('Monthly · Shared Goal'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('creates a goal shared with two friends', (tester) async {
      await seedFriend();
      await seedFriend(userId: stranger, code: 'FRIEND02');
      await pumpPage(tester);

      await tapText(tester, 'CREATE NEW GOAL');
      await tester.enterText(
        find.widgetWithText(TextField, 'Target amount'),
        '100',
      );
      await tapText(tester, 'Friend $friendCode');
      await tapText(tester, 'Friend FRIEND02');
      await tapText(tester, 'Friend FRIEND02');
      await tapText(tester, 'Friend FRIEND02');
      await tapText(tester, 'Create');

      final template = (await db.goalDao.getAllGoalTemplates()).single;
      expect(await db.sharingDao.getGoalMembers(template.id), hasLength(2));
      expect(find.text('Goal created. 2 invites sent.'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('invites a friend to an existing goal', (tester) async {
      await seedFriend();
      final goal = await seedGoal();
      await pumpPage(tester);

      await tapText(tester, 'Laptop');
      await tapText(tester, 'Share');
      expect(find.text('SHARE LAPTOP'), findsOneWidget);
      await tapText(tester, 'Friend $friendCode');
      await tapText(tester, 'Send invites');

      final member = await db.sharingDao.getGoalMember(goal.id, friend);
      expect(member!.status, GoalMemberStatus.pending);
      expect(find.text('Invite sent.'), findsOneWidget);
      expect(find.text('SHARED · 1'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('share dialog explains when there are no friends', (
      tester,
    ) async {
      await seedGoal();
      await pumpPage(tester);

      await tapText(tester, 'Laptop');
      await tapText(tester, 'Share');

      expect(find.textContaining('Add friends first'), findsOneWidget);
      expect(find.text('Send invites'), findsNothing);
      await tapText(tester, 'Cancel');

      await finish(tester);
    });

    testWidgets('share dialog knows everyone is already on the goal', (
      tester,
    ) async {
      await seedFriend();
      final goal = await seedGoal();
      await seedMember(goal, friend);
      await pumpPage(tester);

      await tapText(tester, 'Laptop');
      await tapText(tester, 'Share');

      expect(
        find.text('All your friends are already on this goal.'),
        findsOneWidget,
      );

      await finish(tester);
    });

    testWidgets('sending no selection does nothing', (tester) async {
      await seedFriend();
      final goal = await seedGoal();
      await pumpPage(tester);

      await tapText(tester, 'Laptop');
      await tapText(tester, 'Share');
      await tapText(tester, 'Send invites');

      expect(await db.sharingDao.getGoalMembers(goal.id), isEmpty);

      await finish(tester);
    });
  });

  group('invites', () {
    testWidgets('an invite can be accepted', (tester) async {
      await seedFriend();
      final goal = await seedGoal(name: 'Road trip', ownerId: friend);
      final invite = await seedMember(
        goal,
        me,
        status: GoalMemberStatus.pending,
        invitedBy: friend,
      );
      await pumpPage(tester);

      expect(find.text('GOAL INVITES'), findsOneWidget);
      expect(
        find.textContaining('Friend $friendCode invited you'),
        findsOneWidget,
      );
      expect(find.textContaining('No goals yet'), findsOneWidget);

      await tapText(tester, 'Join goal');

      expect((await memberRow(invite.id)).status, GoalMemberStatus.accepted);
      expect(find.text('You joined "Road trip".'), findsOneWidget);
      expect(find.text('GOAL INVITES'), findsNothing);
      expect(find.byIcon(Icons.logout), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsNothing);

      await finish(tester);
    });

    testWidgets('an invite can be declined', (tester) async {
      final goal = await seedGoal(name: 'Road trip', ownerId: stranger);
      final invite = await seedMember(
        goal,
        me,
        status: GoalMemberStatus.pending,
        invitedBy: stranger,
      );
      await pumpPage(tester);

      expect(find.textContaining('Member invited you'), findsOneWidget);
      await tapText(tester, 'Decline');

      final row = await memberRow(invite.id);
      expect(row.status, GoalMemberStatus.declined);
      expect(row.deletedAt, isNotNull);
      expect(find.text('Invite to "Road trip" declined.'), findsOneWidget);
      expect(find.text('GOAL INVITES'), findsNothing);

      await finish(tester);
    });

    testWidgets('goals of others without membership stay hidden', (
      tester,
    ) async {
      await seedGoal(name: 'Not mine', ownerId: stranger);
      await pumpPage(tester);

      expect(find.text('Not mine'), findsNothing);
      expect(find.textContaining('No goals yet'), findsOneWidget);

      await finish(tester);
    });
  });

  group('shared goal as owner', () {
    testWidgets('details show members and only my undo buttons', (
      tester,
    ) async {
      await seedFriend();
      final goal = await seedGoal();
      await seedMember(goal, friend);
      await seedMember(goal, stranger, status: GoalMemberStatus.pending);
      await seedContribution(goal, '100', at: DateTime.utc(2026, 1, 2));
      await seedContribution(
        goal,
        '50',
        userId: friend,
        at: DateTime.utc(2026, 1, 3),
      );
      await pumpPage(tester);

      expect(find.text('SHARED · 2'), findsOneWidget);
      await tapText(tester, 'Laptop');

      expect(find.text('Saved by you'), findsOneWidget);
      expect(find.text('R100.00'), findsWidgets);
      expect(find.text('OWNER'), findsOneWidget);
      expect(find.text('INVITED'), findsOneWidget);
      expect(find.text('Friend $friendCode'), findsOneWidget);
      expect(find.text('Member'), findsOneWidget);
      expect(find.textContaining('Friend $friendCode · '), findsOneWidget);
      expect(find.textContaining('You · '), findsOneWidget);
      expect(find.byTooltip('Undo this allocation'), findsOneWidget);
      expect(find.byTooltip('Remove member'), findsOneWidget);
      expect(find.byTooltip('Cancel invite'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('cannot delete while members remain', (tester) async {
      final goal = await seedGoal();
      await seedMember(goal, friend);
      await pumpPage(tester);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await settle(tester);

      expect(
        find.textContaining('Other members are still on this goal'),
        findsOne,
      );
      expect(find.text('DELETE GOAL'), findsNothing);
      expect(await db.goalDao.getGoalTemplateById(goal.id), isNotNull);

      await finish(tester);
    });

    testWidgets('deleting withdraws pending invites', (tester) async {
      final goal = await seedGoal();
      final pending = await seedMember(
        goal,
        friend,
        status: GoalMemberStatus.pending,
      );
      await pumpPage(tester);

      await tester.tap(find.byIcon(Icons.delete_outline));
      await settle(tester);
      await tapText(tester, 'Delete');

      expect(await db.goalDao.getGoalTemplateById(goal.id), isNull);
      expect((await memberRow(pending.id)).deletedAt, isNotNull);

      await finish(tester);
    });

    testWidgets('cannot remove a member who still has money in', (
      tester,
    ) async {
      await seedFriend();
      final goal = await seedGoal();
      final member = await seedMember(goal, friend);
      await seedContribution(goal, '50', userId: friend);
      await pumpPage(tester);

      await tapText(tester, 'Laptop');
      await tester.tap(find.byTooltip('Remove member'));
      await settle(tester);

      expect(find.textContaining('still has money in this goal'), findsOne);
      expect((await memberRow(member.id)).deletedAt, isNull);

      await finish(tester);
    });

    testWidgets('removes a member without money', (tester) async {
      await seedFriend();
      final goal = await seedGoal();
      final member = await seedMember(goal, friend);
      await pumpPage(tester);

      await tapText(tester, 'Laptop');
      await tester.tap(find.byTooltip('Remove member'));
      await settle(tester);

      expect((await memberRow(member.id)).deletedAt, isNotNull);
      expect(
        find.text('Friend $friendCode removed from the goal.'),
        findsOneWidget,
      );
      expect(find.text('SHARED · 1'), findsNothing);

      await finish(tester);
    });

    testWidgets('cancels a pending invite', (tester) async {
      final goal = await seedGoal();
      final member = await seedMember(
        goal,
        friend,
        status: GoalMemberStatus.pending,
      );
      await pumpPage(tester);

      await tapText(tester, 'Laptop');
      await tester.tap(find.byTooltip('Cancel invite'));
      await settle(tester);

      expect((await memberRow(member.id)).deletedAt, isNotNull);
      expect(find.text('Invite cancelled.'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('releasing returns only my share', (tester) async {
      final goal = await seedGoal();
      await seedMember(goal, friend);
      await seedContribution(goal, '100');
      final theirs = await seedContribution(goal, '40', userId: friend);
      await pumpPage(tester);

      await tapText(tester, 'Laptop');
      await tapText(tester, 'Release funds');
      expect(find.textContaining('Other members keep'), findsOneWidget);
      await tapText(tester, 'Release');

      final remaining = await db.goalDao.getContributionsForTemplate(goal.id);
      expect(remaining.map((c) => c.id), [theirs.id]);
      final income = await db.transactionDao.getTransactionsByType(
        TransactionType.income,
      );
      expect(income.single.amount, Decimal.parse('100'));
      expect(find.text('R100.00 returned to income.'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('release is hidden when I have nothing in', (tester) async {
      final goal = await seedGoal();
      await seedMember(goal, friend);
      await seedContribution(goal, '40', userId: friend);
      await pumpPage(tester);

      await tapText(tester, 'Laptop');

      expect(find.text('Release funds'), findsNothing);
      expect(find.byTooltip('Undo this allocation'), findsNothing);

      await finish(tester);
    });
  });

  group('shared goal as member', () {
    testWidgets('leaving returns my money and removes access', (tester) async {
      await seedFriend();
      final goal = await seedGoal(name: 'Road trip', ownerId: friend);
      final membership = await seedMember(goal, me, invitedBy: friend);
      await seedContribution(goal, '100');
      final theirs = await seedContribution(goal, '60', userId: friend);
      await pumpPage(tester);

      expect(find.text('R160 / R1500'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.logout));
      await settle(tester);
      expect(find.text('LEAVE GOAL'), findsOneWidget);
      expect(find.textContaining('R100.00 you put in'), findsOneWidget);
      await tapText(tester, 'Leave');

      expect((await memberRow(membership.id)).deletedAt, isNotNull);
      final remaining = await db.goalDao.getContributionsForTemplate(goal.id);
      expect(remaining.map((c) => c.id), [theirs.id]);
      expect(
        find.text('You left "Road trip". R100.00 returned to income.'),
        findsOneWidget,
      );
      expect(find.text('Road trip'), findsNothing);

      await finish(tester);
    });

    testWidgets('leaving without money just leaves', (tester) async {
      final goal = await seedGoal(name: 'Road trip', ownerId: friend);
      await seedMember(goal, me, invitedBy: friend);
      await pumpPage(tester);

      await tapText(tester, 'Road trip');
      expect(find.text('Friend'), findsNothing);
      expect(find.text('Member'), findsOneWidget);
      await tapText(tester, 'Leave');
      expect(find.textContaining('need a new invite'), findsOneWidget);
      await tapText(tester, 'Leave');

      expect(find.text('You left "Road trip".'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('cancelling the leave dialog keeps the membership', (
      tester,
    ) async {
      final goal = await seedGoal(name: 'Road trip', ownerId: friend);
      final membership = await seedMember(goal, me, invitedBy: friend);
      await pumpPage(tester);

      await tester.tap(find.byIcon(Icons.logout));
      await settle(tester);
      await tapText(tester, 'Cancel');

      expect((await memberRow(membership.id)).deletedAt, isNull);
      expect(find.text('Road trip'), findsOneWidget);

      await finish(tester);
    });

    testWidgets('members can allocate to a shared goal', (tester) async {
      final goal = await seedGoal(name: 'Road trip', ownerId: friend);
      await seedMember(goal, me, invitedBy: friend);
      await pumpPage(tester);

      await tapText(tester, 'ALLOCATE');
      await tester.enterText(find.widgetWithText(TextField, 'Amount'), '75');
      await tapText(tester, 'Allocate');

      final contributions = await db.goalDao.getContributionsForTemplate(
        goal.id,
      );
      expect(contributions.single.userId, me);
      expect(find.text('R75 / R1500'), findsOneWidget);

      await finish(tester);
    });
  });
}
