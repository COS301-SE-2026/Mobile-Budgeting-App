// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart'; // not needed in this test
import 'package:flutter_test/flutter_test.dart';

import 'package:budgetit/views/budget_manager/budget_manager_screen.dart';
import 'package:flutter/material.dart';

void main() {
   testWidgets('Budget manager screen loads correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BudgetManagerScreen(), 
      ),
    );

 //   expect(find.text('Budget IT'), findsOneWidget);
    expect(find.text('MONTHLY SPENDING'), findsOneWidget);
    expect(find.text('Budget Categories'), findsOneWidget);
    expect(find.text('CREATE NEW BUDGET'), findsOneWidget);

    expect(find.text('Rent'), findsOneWidget);
    expect(find.text('Groceries'), findsOneWidget);
    expect(find.text('Dining'), findsOneWidget);
  testWidgets('App builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const BudgetItApp());
    expect(find.byType(BudgetItApp), findsOneWidget);
  });
}
