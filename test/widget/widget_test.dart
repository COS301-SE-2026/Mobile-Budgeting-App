import 'package:budgetit/main.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';

void main() {
  testWidgets('App launches and navigates between main screens', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const BudgetApp());
    await tester.pumpAndSettle();

    // The app should start with the shared bottom navigation.
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(3));

    // Go to transactions screen.
    await tester.tap(find.byType(NavigationDestination).at(1));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    // Go to budget manager screen.
    await tester.tap(find.byType(NavigationDestination).at(2));
    await tester.pumpAndSettle();

 //   expect(find.text('Budget IT'), findsOneWidget);
    expect(find.text('MONTHLY SPENDING'), findsOneWidget);
    expect(find.text('Budget Categories'), findsOneWidget);
    expect(find.text('CREATE NEW BUDGET'), findsOneWidget);

    expect(find.text('Rent'), findsOneWidget);
    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Dining'), findsOneWidget);
  });
}
