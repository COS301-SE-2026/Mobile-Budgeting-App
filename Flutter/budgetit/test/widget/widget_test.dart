import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/main.dart';
import 'package:budgetit/views/budget_manager/budget_manager_screen.dart';

import '../support/mock_db.dart';

void main() {
  testWidgets('Budget manager screen loads', (WidgetTester tester) async {
    final mock = MockDb();

    await tester.pumpWidget(
      wrapWithProviders(
        BudgetManagerScreen(database: mock.db),
        db: mock.db,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('MONTHLY BUDGET OVERVIEW'), findsOneWidget);
    expect(find.text('Budget Categories'), findsOneWidget);
    expect(find.text('CREATE NEW BUDGET'), findsOneWidget);
  });

  testWidgets('app shows the bottom navigation shell', (tester) async {
    final mock = MockDb();

    await tester.pumpWidget(BudgetApp(db: mock.db));
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(3));
  }, skip: true); // Skip for now, needs mock auth integration.
}