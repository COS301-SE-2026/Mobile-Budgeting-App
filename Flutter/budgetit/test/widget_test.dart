import 'package:flutter/material.dart';
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
  });
}