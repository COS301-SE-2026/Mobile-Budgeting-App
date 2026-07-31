import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';


import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/views/budget_manager/budget_manager_screen.dart';

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
  testWidgets('Budget Manager full flow works', (WidgetTester tester) async {
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

    // 1. Screen loads.
    expect(find.text('MONTHLY BUDGET OVERVIEW'), findsOneWidget);
    expect(find.text('CREATE NEW BUDGET'), findsOneWidget);

    // 2. Dynamic month/year appears.
    expect(find.text(currentMonthYearLabel()), findsOneWidget);
    expect(find.text('JUNE 2024'), findsNothing);

    // 3. Create Budget button exists.
    expect(find.text('CREATE NEW BUDGET'), findsOneWidget);

    // 4. Open Create Budget dialog.
    await tester.tap(find.text('CREATE NEW BUDGET'));
    await tester.pumpAndSettle();

    // 5. Confirm dialog opened.
    expect(find.textContaining('Create'), findsWidgets);
    expect(find.byType(AlertDialog), findsOneWidget);
  });
}
