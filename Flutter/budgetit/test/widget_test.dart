import 'package:flutter/material.dart';
// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart'; // not needed in this test
import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/main.dart';

void main() {
  testWidgets('App launches and navigates between main screens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BudgetApp());
    await tester.pumpAndSettle();

    // The app should start on the dashboard.
    expect(find.byType(NavigationBar), findsOneWidget);

    // Go to transactions screen.
    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    // Go to budget manager screen.
    await tester.tap(find.byType(NavigationDestination).at(2));
    await tester.pumpAndSettle();

    expect(find.text('MONTHLY SPENDING'), findsOneWidget);
    expect(find.text('Budget Categories'), findsOneWidget);
    expect(find.text('CREATE NEW BUDGET'), findsOneWidget);

    // Go back to dashboard.
    await tester.tap(find.byType(NavigationDestination).at(0));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Rent'), findsOneWidget);
    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Dining'), findsOneWidget);
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const BudgetItApp());
    expect(find.byType(BudgetItApp), findsOneWidget);
  });
}
