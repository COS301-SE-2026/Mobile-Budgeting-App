import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/views/budget_manager/budget_manager_screen.dart';

void main() {
  testWidgets('Budget manager screen loads correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BudgetManagerScreen(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('MONTHLY SPENDING'), findsOneWidget);
    expect(find.text('Budget Categories'), findsOneWidget);
    expect(find.text('CREATE NEW BUDGET'), findsOneWidget);

    expect(find.text('Rent'), findsOneWidget);
    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Dining'), findsOneWidget);
  });
}