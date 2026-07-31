import 'package:budgetit/main.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/views/budget_manager/budget_manager_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/mock_db.dart';

String currentMonthYearLabel() {
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

  return '${months[now.month - 1]} ${now.year}';
}

void main() {
  testWidgets('Budget Manager screen loads', (tester) async {
    final mock = MockDb();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
        ),
        home: wrapWithProviders(
          BudgetManagerScreen(database: mock.db),
          db: mock.db,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('MONTHLY BUDGET OVERVIEW'), findsOneWidget);
    expect(find.text('CREATE NEW BUDGET'), findsOneWidget);
  });

  testWidgets('Budget Manager shows current month and year', (tester) async {
    final mock = MockDb();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
        ),
        home: wrapWithProviders(
          BudgetManagerScreen(database: mock.db),
          db: mock.db,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text(currentMonthYearLabel()), findsOneWidget);
    expect(find.text('JUNE 2024'), findsNothing);
  });

  testWidgets('Create Budget opens dialog', (tester) async {
    final mock = MockDb();

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: <ThemeExtension<dynamic>>[MyColours.lightTheme],
        ),
        home: wrapWithProviders(
          BudgetManagerScreen(database: mock.db),
          db: mock.db,
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('CREATE NEW BUDGET'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
  });
}
