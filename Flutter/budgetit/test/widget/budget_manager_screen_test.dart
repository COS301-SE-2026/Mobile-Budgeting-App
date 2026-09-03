import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/theme_provider.dart';
import 'package:budgetit/views/budget_manager/budget_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../support/mock_db.dart';

//wrapper for each widget
Widget wrapBudgetManager(AppDatabase db) {
  return ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: MaterialApp(
      theme: ThemeData(
        extensions: [MyColours.lightTheme],
      ),
      home: BudgetManagerScreen(database: db),
    ),
  );
}

void main() {
  group('BudgetManagerScreen', () {
    late MockDb mock;

    setUp(() {
      mock = MockDb();

      when(mock.budgetDao.getAllBudgetTemplates()).thenAnswer(
        (_) async => [],
      );

      when(mock.categoryDao.getCategoriesByType(CategoryType.expense))
          .thenAnswer(
        (_) async => [],
      );
    });

    testWidgets('shows empty state when no budgets exist', (tester) async {
      await tester.pumpWidget(wrapBudgetManager(mock.db));
      await tester.pumpAndSettle();

      expect(find.text('BUDGET MANAGER'), findsOneWidget);
      expect(find.text('MONTHLY BUDGET OVERVIEW'), findsOneWidget);
      expect(find.text('BUDGET CATEGORIES'), findsOneWidget);
      expect(find.text('CREATE NEW BUDGET'), findsOneWidget);

      expect(
        find.text('No budgets created yet. Tap the button below to create one.'),
        findsOneWidget,
      );
    });
  });
}