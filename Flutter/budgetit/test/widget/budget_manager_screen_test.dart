import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:budgetit/views/budget_manager/budget_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:drift/native.dart';

import '../support/mock_db.dart';

//wrapper for each widget
Widget wrapBudgetManager(AppDatabase db) {
  return ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: MaterialApp(
      theme: ThemeData(extensions: [MyColours.lightTheme]),
      home: BudgetManagerScreen(database: db),
    ),
  );
}

void main() {
  group('BudgetManagerScreen', () {
    late MockDb mock;

    setUp(() {
      mock = MockDb();

      when(mock.budgetDao.getAllBudgetTemplates()).thenAnswer((_) async => []);

      when(
        mock.categoryDao.getCategoriesByType(CategoryType.expense),
      ).thenAnswer((_) async => []);
    });

    testWidgets('shows empty state when no budgets exist', (tester) async {
      await tester.pumpWidget(wrapBudgetManager(mock.db));
      await tester.pumpAndSettle();

      expect(find.text('BUDGET MANAGER'), findsOneWidget);
      expect(find.text('MONTHLY BUDGET OVERVIEW'), findsOneWidget);
      expect(find.text('BUDGET CATEGORIES'), findsOneWidget);
      expect(find.text('CREATE NEW BUDGET'), findsOneWidget);

      expect(
        find.text(
          'No budgets created yet. Tap the button below to create one.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('month and year picker updates the budget period', (
      tester,
    ) async {
      final now = DateTime.now();
      const months = [
        'JANUARY',
        'FEBRUARY',
        'MARCH',
        'APRIL',
        'MAY',
        'JUNE',
        'JULY',
        'AUGUST',
        'SEPTEMBER',
        'OCTOBER',
        'NOVEMBER',
        'DECEMBER',
      ];
      final currentLabel = '${months[now.month - 1]} ${now.year}';
      final targetMonth = now.month == 1 ? 2 : 1;

      await tester.pumpWidget(wrapBudgetManager(mock.db));
      await tester.pumpAndSettle();
      await tester.tap(find.text(currentLabel));
      await tester.pumpAndSettle();

      expect(find.text('SELECT BUDGET PERIOD'), findsOneWidget);
      expect(find.text('Year'), findsOneWidget);
      expect(
        find.text(months[targetMonth - 1].substring(0, 3)),
        findsOneWidget,
      );

      await tester.tap(find.text(months[targetMonth - 1].substring(0, 3)));
      await tester.tap(find.text('Apply'));
      await tester.pumpAndSettle();

      expect(
        find.text('${months[targetMonth - 1]} ${now.year}'),
        findsOneWidget,
      );
    });

    testWidgets('creates a budget without a dialog lifecycle error', (
      tester,
    ) async {
      final database = AppDatabase.forTesting(NativeDatabase.memory());
      addTearDown(database.close);
      await database.categoryDao.insertCategory(
        name: 'Groceries',
        type: CategoryType.expense,
      );

      await tester.pumpWidget(wrapBudgetManager(database));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CREATE NEW BUDGET'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '500');
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(await database.budgetDao.getAllBudgetTemplates(), hasLength(1));
    });
  });
}
