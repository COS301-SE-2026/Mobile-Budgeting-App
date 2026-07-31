import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/main.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/views/budget_manager/budget_detail_screen.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../support/fixtures.dart';
import '../support/mock_db.dart';

Widget _wrap({required AppDatabase database, required Widget child}) {
  return MaterialApp(
    theme: ThemeData(
      extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
    ),
    home: wrapWithProviders(child, db: database),
  );
}

Transaction _expense({
  required String id,
  required String description,
  required double amount,
  DateTime? date,
}) {
  return transactionFixture(
    id: id,
    shortDescription: description,
    amount: Decimal.parse(amount.toString()),
    type: TransactionType.expense,
    transactionDate: date ?? DateTime.now(),
  );
}

BudgetDetailScreen _screen({
  required AppDatabase database,
  double spent = 500,
  double limit = 2000,
  String title = 'Food',
  String subtitle = 'Monthly food budget',
}) {
  return BudgetDetailScreen(
    database: database,
    templateId: 'template-food',
    categoryId: 'cat-food',
    title: title,
    subtitle: subtitle,
    spent: spent,
    limit: limit,
    icon: Icons.fastfood,
    progressColor: Colors.greenAccent,
  );
}

void main() {
  late MockDb mock;

  setUp(() {
    mock = MockDb();

    when(
      mock.budgetDao.getBudgetTemplateById(any),
    ).thenAnswer((_) async => null);

    when(
      mock.transactionDao.getTransactionsByCategory(any),
    ).thenAnswer((_) async => []);
  });

  group('BudgetDetailScreen', () {
    testWidgets('shows budget overview details', (tester) async {
      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          child: _screen(database: mock.db),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Food'), findsWidgets);
      expect(find.text('Monthly food budget'), findsOneWidget);
      expect(find.text('SPENT'), findsOneWidget);
      expect(find.text('R0.00'), findsOneWidget);
      expect(find.text('Budget limit: R2000.00'), findsOneWidget);
      expect(find.text('You still have R2000.00 remaining.'), findsOneWidget);
    });

    testWidgets('shows healthy budget status and tip', (tester) async {
      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          child: _screen(database: mock.db),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('This budget is currently healthy.'), findsOneWidget);
      expect(
        find.text(
          'Nice work. Keep tracking spending to stay within this budget.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows close to limit status and tip', (tester) async {
      when(mock.transactionDao.getTransactionsByCategory(any)).thenAnswer(
        (_) async => [
          _expense(id: 't1', description: 'Groceries', amount: 1700),
        ],
      );

      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          child: _screen(database: mock.db),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('R1700.00'), findsWidgets);
      expect(
        find.text('You are close to your limit. Spend carefully.'),
        findsOneWidget,
      );
      expect(
        find.text(
          'You are close to the limit. Check recent transactions before spending more in this category.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows over limit status and over badge', (tester) async {
      when(mock.transactionDao.getTransactionsByCategory(any)).thenAnswer(
        (_) async => [
          _expense(id: 't1', description: 'Groceries', amount: 2500),
        ],
      );

      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          child: _screen(database: mock.db),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('OVER'), findsOneWidget);
      expect(find.text('R2500.00'), findsWidgets);
      expect(find.text('You are R500.00 over this budget.'), findsOneWidget);
      expect(
        find.text(
          'You have exceeded this budget. Review your recent spending.',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          'This budget is over limit. Consider reviewing non-essential spending or adjusting the budget amount.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows quick action buttons', (tester) async {
      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          child: _screen(database: mock.db),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Add Transaction'), findsOneWidget);
      expect(find.text('Edit Budget'), findsOneWidget);
      expect(find.text('View Spending Insights'), findsOneWidget);
    });

    testWidgets('shows empty recent transactions message', (tester) async {
      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          child: _screen(database: mock.db),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Recent Transactions'), findsOneWidget);
      expect(
        find.text('No recent transactions for this budget yet.'),
        findsOneWidget,
      );
    });

    testWidgets('shows recent expense transactions for current period', (
      tester,
    ) async {
      when(mock.transactionDao.getTransactionsByCategory(any)).thenAnswer(
        (_) async => [
          _expense(id: 't1', description: 'Groceries', amount: 400),
          _expense(id: 't2', description: 'Takeaways', amount: 250),
          _expense(id: 't3', description: 'Fruit', amount: 100),
          _expense(id: 't4', description: 'Hidden fourth item', amount: 50),
        ],
      );

      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          child: _screen(database: mock.db),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Groceries'), findsOneWidget);
      expect(find.text('Takeaways'), findsOneWidget);
      expect(find.text('Fruit'), findsOneWidget);
      expect(find.text('Hidden fourth item'), findsNothing);
      expect(find.text('R400.00'), findsWidgets);
      expect(find.text('R250.00'), findsWidgets);
      expect(find.text('R100.00'), findsWidgets);
    });

    testWidgets('opens and closes spending insights dialog', (tester) async {
      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          child: _screen(database: mock.db),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('View Spending Insights'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Spending Insights'), findsOneWidget);
      expect(find.textContaining('You have used'), findsOneWidget);

      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('opens and cancels edit budget dialog', (tester) async {
      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          child: _screen(database: mock.db),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit Budget'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Edit Budget'), findsWidgets);
      expect(find.text('Budget limit'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('edit budget validates invalid amount', (tester) async {
      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          child: _screen(database: mock.db),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit Budget'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '0');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid budget limit.'), findsOneWidget);
    });

    testWidgets('opens and cancels add transaction dialog', (tester) async {
      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          child: _screen(database: mock.db),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Transaction'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Add Transaction'), findsWidgets);
      expect(find.text('Description'), findsOneWidget);
      expect(find.text('Amount'), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('add transaction validates missing description', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          child: _screen(database: mock.db),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Transaction'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a description.'), findsOneWidget);
    });

    testWidgets('add transaction validates invalid amount', (tester) async {
      await tester.pumpWidget(
        _wrap(
          database: mock.db,
          child: _screen(database: mock.db),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Add Transaction'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).at(0), 'Bread');
      await tester.enterText(find.byType(TextField).at(1), '0');
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();

      expect(find.text('Please enter a valid amount.'), findsOneWidget);
    });
  });
}
